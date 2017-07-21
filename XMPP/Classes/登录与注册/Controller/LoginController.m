//
//  LoginController.m
//  XMPP
//
//  Created by 刘成 on 2017/7/19.
//  Copyright © 2017年 刘成. All rights reserved.
//

#import "LoginController.h"
#import "XMPPManager.h"
#import "LCTabBarController.h"
@interface LoginController ()<XMPPStreamDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *pswTF;

@end

@implementation LoginController
//登录
- (IBAction)login:(id)sender {
    [self.view endEditing:YES];
    if ([self suitableToLogin]) {
        XMPPManager *manager = [XMPPManager shareManager];
        [manager.stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        [manager loginWithUserName:self.userNameTF.text AndPassword:self.pswTF.text];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置背景图片,拉伸
    self.view.layer.contents = (__bridge id)[UIImage imageNamed:@"login_backgroud"].CGImage;
    
}
-(BOOL)suitableToLogin{
    if (!self.userNameTF.text||self.userNameTF.text.length==0||!self.pswTF.text||self.pswTF.text.length==0) {
        //没有填内容,警告
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"资料没填完整" message:@"请检查是否填上帐号名密码" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        return NO;
    }
    return YES;
}
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    //进入好友列表界面
    [self saveUserInfo];
    [UIApplication sharedApplication].delegate.window.rootViewController = [[LCTabBarController alloc]init];
}
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"验证失败" message:@"请检查帐号密码是否正确" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}
-(void)saveUserInfo{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.userNameTF.text forKey:@"userName"];
    [userDefaults setObject:self.pswTF.text forKey:@"password"];
    [userDefaults setBool:YES forKey:@"loginKey"];
}
@end
