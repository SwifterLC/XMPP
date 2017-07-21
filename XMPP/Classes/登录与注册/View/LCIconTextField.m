
//
//  LCIconTextField.m
//  XMPP
//
//  Created by 刘成 on 2017/7/19.
//  Copyright © 2017年 刘成. All rights reserved.
//

#import "LCIconTextField.h"
#import "UIView+Frame.h"
@implementation LCIconTextField
-(void)setImgName:(UIImage *)imgName{
    UIImageView *imgView = [[UIImageView alloc]initWithImage:imgName];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.w = self.h*0.6;
    imgView.h = self.h*0.6;
    self.leftView = imgView;
    self.leftViewMode = UITextFieldViewModeAlways;
}
-(CGRect)leftViewRectForBounds:(CGRect)bounds{
    CGRect rect = [super leftViewRectForBounds:bounds];
    rect.origin.x = self.leftSpace;
    return rect;
}
-(CGRect)editingRectForBounds:(CGRect)bounds{
   return CGRectInset(bounds, self.rightSpace, 0);
}
-(CGRect)textRectForBounds:(CGRect)bounds{
    bounds.origin.x = self.rightSpace;
    return bounds;
}
@end
