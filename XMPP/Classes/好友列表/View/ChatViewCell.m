//
//  ChatViewCell.m
//  XMPP
//
//  Created by 刘成 on 2017/7/21.
//  Copyright © 2017年 刘成. All rights reserved.
//

#import "ChatViewCell.h"
#import "XMPPManager.h"
@interface ChatViewCell()
@property (weak, nonatomic) IBOutlet UILabel *timeStamp;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIButton *messageBox;
@end
@implementation ChatViewCell

-(void)setMessage:(XMPPMessageArchiving_Message_CoreDataObject *)message{
    _message = message;
    [self.messageBox setTitleColor:[UIColor colorWithHex:0x6f7179] forState:UIControlStateNormal];
    self.timeStamp.text = [message.timestamp xmppTimeString];
    if (message.isOutgoing) {
        self.icon.image = [UIImage imageWithData:[XMPPManager shareManager].vCardTempModule.myvCardTemp.photo];
    }else{
    self.icon.image = [UIImage imageWithData:[[XMPPManager shareManager].vCardAvatarModule photoDataForJID:message.bareJid]];
    }
    if (message.isComposing) {
        [self.messageBox setTitle:@"对方正在输入....." forState:UIControlStateNormal];
        [self.messageBox setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }else{
    [self.messageBox setTitle:message.body forState:UIControlStateNormal];
    }
}
//当为控件设置自动布局时,会出现问题
-(void)layoutSubviews{
    [super layoutSubviews];
    CGSize size = [self.messageBox.titleLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth-182, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    self.messageBox.w = size.width + 30;
    self.messageBox.h = size.height +20;
    if (self.message.isOutgoing) {
        self.messageBox.x = kScreenWidth - 76 - size.width -30;
    }
}
+(NSString *)cellIDFromMessage:(XMPPMessageArchiving_Message_CoreDataObject *)message{
    if (!message.isOutgoing) {
        return @"chatCell_other";
    }else{
        return @"chatCell_me";
    }
}
@end
