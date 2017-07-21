//
//  LCIconTextField.h
//  XMPP
//
//  Created by 刘成 on 2017/7/19.
//  Copyright © 2017年 刘成. All rights reserved.
//


/**
 带图标的 TextField

 @param nonatomic.
 @param copy.
 @return .
 */
IB_DESIGNABLE
#import <UIKit/UIKit.h>

@interface LCIconTextField : UITextField
@property(nonatomic,strong)IBInspectable UIImage *imgName;
@property(nonatomic,assign)IBInspectable int leftSpace;
@property(nonatomic,assign)IBInspectable int rightSpace;

@end
