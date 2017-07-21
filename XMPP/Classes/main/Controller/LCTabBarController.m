//
//  LCTabBarController.m
//  XMPP
//
//  Created by 刘成 on 2017/7/19.
//  Copyright © 2017年 刘成. All rights reserved.
//

#import "LCTabBarController.h"
#import "LCNavigationController.h"
#import "UIColor+Addition.h"
@interface LCTabBarController ()

@end

@implementation LCTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIViewController *vc1 = [self addChildViewControllerWithSBName:@"Roster" withTitle:@"好友列表" withImageName:@"roster_tabbar"];
    UIViewController *vc2 = [self addChildViewControllerWithSBName:@"Recent" withTitle:@"最近联系人" withImageName:@"recent_tabbar"];
    self.viewControllers = @[vc2,vc1];
    self.tabBar.barTintColor = [UIColor colorWithHex:0x00bcd4];
}
-(UIViewController *)addChildViewControllerWithSBName:(NSString *)sbName withTitle:(NSString *)title withImageName:(NSString *)imgName{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:sbName bundle:nil];
    UIViewController *vc = sb.instantiateInitialViewController;
    vc.tabBarItem.image = [[self imageWithImage:[UIImage imageNamed:imgName] AndScale:6]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[self imageWithImage:[UIImage imageNamed:[imgName stringByAppendingString:@"_SEL"]] AndScale:6]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.title = title;
    LCNavigationController *navi = [[LCNavigationController alloc]initWithRootViewController:vc];
    vc.navigationItem.title = title;
    return navi;
}
//image 缩放
-(UIImage *)imageWithImage:(UIImage *)img AndScale:(CGFloat)scale{
    CGImageRef ref = img.CGImage;
    return [UIImage imageWithCGImage:ref scale:scale orientation:UIImageOrientationUp];
}
@end
