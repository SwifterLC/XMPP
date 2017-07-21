//
//  RosterCell.m
//  XMPP
//
//  Created by 刘成 on 2017/7/20.
//  Copyright © 2017年 刘成. All rights reserved.
//

#import "RosterCell.h"
@interface RosterCell()
@property (weak, nonatomic) IBOutlet UILabel *subscribLabel;
@property (weak, nonatomic) IBOutlet UILabel *statueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@end
@implementation RosterCell
-(void)setUser:(XMPPUserCoreDataStorageObject *)user{
    _user = user;
    self.nickName.text = user.nickname?user.nickname:user.displayName;
    self.icon.image = user.photo;
    self.subscribLabel.text = user.subscription;
    self.statueLabel.text = user.primaryResource.presence.status;
}
@end
