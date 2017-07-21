//
//  ChatVIewController.m
//  XMPP
//
//  Created by 刘成 on 2017/7/21.
//  Copyright © 2017年 刘成. All rights reserved.
//

#import "ChatVIewController.h"
#import "XMPPManager.h"
#import "ChatViewCell.h"
#import "MessageSendBar.h"
@interface ChatVIewController ()<NSFetchedResultsControllerDelegate>
@property(nonatomic,strong)NSFetchedResultsController *fetchResultController;
@end

@implementation ChatVIewController
-(NSFetchedResultsController *)fetchResultController{
    if (!_fetchResultController) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
        request.sortDescriptors = @[sort];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bareJidStr = %@",self.chatTo.bare];
        request.predicate = predicate;
        _fetchResultController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:[XMPPManager shareManager].messageCoreDataContext sectionNameKeyPath:nil cacheName:nil];
        _fetchResultController.delegate = self;
    }
    return _fetchResultController;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.chatTo.bare;
    [self.fetchResultController performFetch:NULL];
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
#pragma mark - tableViewDatasource,delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fetchResultController.fetchedObjects.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XMPPMessageArchiving_Message_CoreDataObject *messageObj =  self.fetchResultController.fetchedObjects[indexPath.row];
        ChatViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[ChatViewCell cellIDFromMessage:messageObj]];
    cell.message = messageObj;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    XMPPMessageArchiving_Message_CoreDataObject *messageObj =  self.fetchResultController.fetchedObjects[indexPath.row];
    CGSize size =  [messageObj.body boundingRectWithSize:CGSizeMake(kScreenWidth-182, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    return size.height+10>60?size.height+10+57:60+49;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    MessageSendBar *sendBar = [MessageSendBar sendBarWithNib];
    [sendBar setSendMsgBlock:^(NSString *messageBody){
        XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:self.chatTo];
        [message addBody:messageBody];
        [[XMPPManager shareManager].stream sendElement:message];
    }];
    sendBar.w = kScreenWidth;
    sendBar.h = 64;
    return sendBar;
//    UITextField
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 64;
}
#pragma mark - fetch....
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.fetchResultController.fetchedObjects.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

@end
