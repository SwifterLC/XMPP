//
//  AppDelegate.m
//  XMPP
//
//  Created by 刘成 on 2017/7/19.
//  Copyright © 2017年 刘成. All rights reserved.
//

#import "AppDelegate.h"
#import "LCTabBarController.h"
#import "XMPPManager.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    if (![self shouldShowLogin]) {
        self.window.rootViewController = [UIStoryboard storyboardWithName:@"LoginAndRegister" bundle:nil].instantiateInitialViewController;
    }else{
        [[XMPPManager shareManager]loginWithUserName:[[NSUserDefaults standardUserDefaults] valueForKey:@"userName"] AndPassword:[[NSUserDefaults standardUserDefaults] valueForKey:@"password"]];
        LCTabBarController *tabbarController = [[LCTabBarController alloc]init];
        self.window.rootViewController = tabbarController;
    }
    [self.window makeKeyAndVisible];
    
    
    
    return YES;
}
-(BOOL)shouldShowLogin{
    return [[NSUserDefaults standardUserDefaults]boolForKey:@"loginKey"];
}
@end
