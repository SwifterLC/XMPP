//
//  XMPPManager.h
//  XMPP
//
//  Created by 刘成 on 2017/7/19.
//  Copyright © 2017年 刘成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XMPPFramework/XMPPFramework.h>
@interface XMPPManager : NSObject

/**
 xmpp通讯信道流
 */
@property(nonatomic,strong)XMPPStream *stream;
//好友模块
@property(nonatomic,strong)XMPPRosterCoreDataStorage *rosterCoreDataStorage;
@property(nonatomic,strong)XMPPRoster *roster;
//名片模块
@property(nonatomic,strong)XMPPvCardCoreDataStorage *vCardCoreDataStorage;
@property(nonatomic,strong)XMPPvCardTempModule *vCardTempModule;
@property(nonatomic,strong)XMPPvCardAvatarModule *vCardAvatarModule;
//消息模块
@property(nonatomic,strong)XMPPMessageArchiving *messageArchiving;
@property(nonatomic,strong)NSManagedObjectContext *messageCoreDataContext;
/**
 返回单例对象

 @return .
 */
+(instancetype)shareManager;

/**
 登录

 @param userName 用户名
 @param psw 密码
 */
-(void)loginWithUserName:(NSString *)userName AndPassword:(NSString *)psw;
/**
 注册
 
 @param userName 用户名
 @param psw 密码
 */
-(void)registerWithUserName:(NSString *)userName AndPassword:(NSString *)psw;
@end
