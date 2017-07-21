//
//  XMPPManager.m
//  XMPP
//
//  Created by 刘成 on 2017/7/19.
//  Copyright © 2017年 刘成. All rights reserved.
//

#import "XMPPManager.h"
typedef NS_ENUM(NSInteger,XMPPManagerConnectType){
    XMPPManagerConnectTypeLogin,
    XMPPManagerConnectTypeRegister
};
@interface XMPPManager()<XMPPStreamDelegate,XMPPRosterDelegate,UIAlertViewDelegate>
@property(nonatomic,copy)NSString *password;
@property(nonatomic,assign)XMPPManagerConnectType connectType;
@property(nonatomic,strong)XMPPJID *subjectFrom;
@end
@implementation XMPPManager
/**
 返回单例对象
 
 @return .
 */
+(instancetype)shareManager{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        //初始化通信信道对象
        self.stream = [[XMPPStream alloc]init];
        //设置 host 与 port
        self.stream.hostName = kHostName;
        self.stream.hostPort = kHostPort;
        [self.stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        //添加好友花名册模块
        [self addRosterModule];
        //添加好友名片模块
        [self addvCardModule];
        //添加消息模块
        [self addMessageModule];
    }
    return self;
}
/**
 登录
 
 @param userName 用户名
 @param psw 密码
 */
-(void)loginWithUserName:(NSString *)userName AndPassword:(NSString *)psw{
    //设置连接状态是 login
    self.connectType = XMPPManagerConnectTypeLogin;
    //存储用户密码
    self.password = psw;
    //连接服务器
    [self connectToServerWithUserName:userName];
}
/**
 注册
 
 @param userName 用户名
 @param psw 密码
 */
-(void)registerWithUserName:(NSString *)userName AndPassword:(NSString *)psw{
    //设置连接状态是 register
    self.connectType = XMPPManagerConnectTypeRegister;
    //存储用户密码
    self.password = psw;
    //连接服务器
    [self connectToServerWithUserName:userName];
}
-(void)connectToServerWithUserName:(NSString *)userName{
    XMPPJID *JID = [XMPPJID jidWithUser:userName domain:kDomain resource:kResource];
    self.stream.myJID = JID;
    //如果已连接或者正在连接,那么发送下线状态然后断开连接
    if ([self.stream isConnected]||[self.stream isConnecting]) {
        XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailabel"];
        [self.stream sendElement:presence];
        [self.stream disconnect];
    }
    NSError *err;
    //连接服务器,超时时长设置-1不超时
    [self.stream connectWithTimeout:-1 error:&err];
    if (err) {
        NSLog(@"%s  %d,连接错误,错误原因%@",__func__,__LINE__,[err localizedDescription]);
    }
}
#pragma mark - XMPPStreamDelegate
//连接超时
-(void)xmppStreamConnectDidTimeout:(XMPPStream *)sender{
    NSLog(@"连接超时--%s",__func__);
}
//连接成功后验证用户密码
-(void)xmppStreamDidConnect:(XMPPStream *)sender{
    NSError *err;
    switch (self.connectType) {
        case XMPPManagerConnectTypeLogin:
            //登录验证用户密码
            [self.stream authenticateWithPassword:self.password error:&err];
            if (err) {
                NSLog(@"%s  %d,验证用户密码出错,原因:%@",__func__,__LINE__,[err localizedDescription]);
            }
            break;
        case XMPPManagerConnectTypeRegister:
            //注册添加用户密码
            [self.stream registerWithPassword:self.password error:&err];
            if (err) {
                NSLog(@"%s  %d,注册用户出错,原因:%@",__func__,__LINE__,[err localizedDescription]);
            }
            break;
    }
}
//验证成功,发送上线状态
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];
    [self.stream sendElement:presence];
    //登录成功添加模块
    NSLog(@"登录成功");
}
//激活好友列表模块
-(void)addRosterModule{
    self.rosterCoreDataStorage = [[XMPPRosterCoreDataStorage alloc]init];
    self.roster = [[XMPPRoster alloc]initWithRosterStorage:self.rosterCoreDataStorage dispatchQueue:dispatch_get_main_queue()];
    [self.roster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self.roster activate:self.stream];
}
//激活名片模块
-(void)addvCardModule{
    self.vCardCoreDataStorage = [XMPPvCardCoreDataStorage sharedInstance];
    [self.vCardTempModule = [XMPPvCardTempModule alloc]initWithvCardStorage:self.vCardCoreDataStorage dispatchQueue:dispatch_get_main_queue()];
    [self.vCardAvatarModule = [XMPPvCardAvatarModule alloc]initWithvCardTempModule:self.vCardTempModule dispatchQueue:dispatch_get_main_queue()];
    [self.vCardTempModule activate:self.stream];
    [self.vCardAvatarModule activate:self.stream];
}
//激活消息模块
-(void)addMessageModule{
    XMPPMessageArchivingCoreDataStorage *coraDataStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    self.messageCoreDataContext = [coraDataStorage mainThreadManagedObjectContext];
    self.messageArchiving =[[XMPPMessageArchiving alloc]initWithMessageArchivingStorage:coraDataStorage dispatchQueue:dispatch_get_main_queue()];
    [self.messageArchiving activate:self.stream];
}
#pragma mark - xmppRosterDelegate
//注意:只有在双方不是 BOTH FROM TO NONE 四种状态时,才会弹框提醒.
-(void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence{
    self.subjectFrom = presence.from;
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"接收到好友请求" message:[NSString stringWithFormat:@"来自于%@",presence.from.user] delegate:self cancelButtonTitle:@"拒绝" otherButtonTitles:@"接收", nil];
    [alertView show];
}
#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self.roster rejectPresenceSubscriptionRequestFrom:self.subjectFrom];
            break;
        case 1:
            [self.roster acceptPresenceSubscriptionRequestFrom:self.subjectFrom andAddToRoster:YES];
    }
}
@end
