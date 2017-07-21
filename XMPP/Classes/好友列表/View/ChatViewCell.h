//
//  ChatViewCell.h
//  XMPP
//
//  Created by 刘成 on 2017/7/21.
//  Copyright © 2017年 刘成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XMPPFramework/XMPPFramework.h>
@interface ChatViewCell : UITableViewCell
@property(nonatomic,strong)XMPPMessageArchiving_Message_CoreDataObject *message;
+(NSString *)cellIDFromMessage:(XMPPMessageArchiving_Message_CoreDataObject *)message;
@end
