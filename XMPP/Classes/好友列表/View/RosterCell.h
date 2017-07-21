//
//  RosterCell.h
//  XMPP
//
//  Created by 刘成 on 2017/7/20.
//  Copyright © 2017年 刘成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XMPPFramework/XMPPFramework.h>
@interface RosterCell : UITableViewCell
@property(nonatomic,strong)XMPPUserCoreDataStorageObject *user;
@end
