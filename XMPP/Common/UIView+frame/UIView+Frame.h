//
//  UIView+Frame.h
//  网易彩票
//
//  Created by 刘成 on 2017/7/15.
//  Copyright © 2017年 刘成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

/**
 获取与设置view的x 值
 */
@property(nonatomic,assign)CGFloat x;
/**
 获取与设置view的y 值
 */
@property(nonatomic,assign)CGFloat y;
/**
 获取与设置view的width 值
 */
@property(nonatomic,assign)CGFloat w;
/**
 获取与设置view的height 值
 */
@property(nonatomic,assign)CGFloat h;
@end
