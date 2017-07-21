//
//  MessageSendBar.h
//  XMPP
//
//  Created by 刘成 on 2017/7/21.
//  Copyright © 2017年 刘成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageSendBar : UIVisualEffectView
+(instancetype)sendBarWithNib;
@property(nonatomic,copy)void(^sendMsgBlock)(NSString *messageBody);
@end
