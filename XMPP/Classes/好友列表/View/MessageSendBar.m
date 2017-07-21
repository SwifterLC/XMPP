//
//  MessageSendBar.m
//  XMPP
//
//  Created by 刘成 on 2017/7/21.
//  Copyright © 2017年 刘成. All rights reserved.
//

#import "MessageSendBar.h"
#import "XMPPManager.h"
@interface MessageSendBar()
@property (weak, nonatomic) IBOutlet UITextField *messageBox;
@property (weak, nonatomic) IBOutlet UIButton *sendBt;
@end
@implementation MessageSendBar

+(instancetype)sendBarWithNib{
    return [[UINib nibWithNibName:@"MessageSendBar" bundle:nil]instantiateWithOwner:nil options:nil].firstObject;
}
- (IBAction)send:(id)sender {
    if (self.messageBox.text&&![self.messageBox.text isEqualToString:@""]) {
        [self.messageBox endEditing:YES];
        self.sendMsgBlock(self.messageBox.text);
    }
}

@end
