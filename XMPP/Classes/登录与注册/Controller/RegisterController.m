//
//  RegisterController.m
//  XMPP
//
//  Created by 刘成 on 2017/7/19.
//  Copyright © 2017年 刘成. All rights reserved.
//

#import "RegisterController.h"
#import "XMPPManager.h"
@interface RegisterController ()<XMPPStreamDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *pswTF;

@end
@implementation RegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerNoti];
}
//注册
- (IBAction)register:(id)sender {
    [self.view endEditing:YES];
    if([self suitableToRegister]){
        XMPPManager *manager = [XMPPManager shareManager];
        [manager.stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        [manager registerWithUserName:self.userNameTF.text AndPassword:self.pswTF.text];
    }
}
//取消
- (IBAction)cancel:(id)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//注册键盘通知
-(void)registerNoti{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)keyBoardShow:(NSNotification *)noti{
    NSDictionary *info = noti.userInfo;
    CGRect bgRect = [info[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endRect = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat offset = bgRect.origin.y-endRect.origin.y;
    self.view.transform = CGAffineTransformTranslate(self.view.transform, 0, -offset/3);
}
//点击空白区域让键盘隐藏
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
//移除键盘通知
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
-(BOOL)suitableToRegister{
    if (!self.userNameTF.text||self.userNameTF.text.length==0||!self.pswTF.text||self.pswTF.text.length==0) {
        //没有填内容,警告
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"资料没填完整" message:@"请检查是否填上帐号名密码" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        return NO;
    }
    return YES;
}
#pragma mark - XMPPStreamDelegate
-(void)xmppStreamDidRegister:(XMPPStream *)sender{
    //注册成功登录
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"帐号已存在" message:@"请换个用户名试试" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alertController animated:YES completion:^{
        self.userNameTF.text= @"";
        self.pswTF.text = @"";
    }];
    
}
@end
