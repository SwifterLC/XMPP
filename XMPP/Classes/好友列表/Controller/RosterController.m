//
//  RosterController.m
//  XMPP
//
//  Created by 刘成 on 2017/7/19.
//  Copyright © 2017年 刘成. All rights reserved.
//

#import "RosterController.h"
#import "XMPPManager.h"
#import "RosterCell.h"
#import "ChatVIewController.h"
@interface RosterController ()<NSFetchedResultsControllerDelegate>
@property(nonatomic,strong)NSFetchedResultsController *fetchResultController;
@end

@implementation RosterController
//好友列表fetchResultController懒加载
-(NSFetchedResultsController *)fetchResultController{
    if (!_fetchResultController) {
        NSManagedObjectContext *context = [[XMPPManager shareManager].rosterCoreDataStorage mainThreadManagedObjectContext];
        NSFetchRequest *requset = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
        //根据好友在线状态排序,优先级最高
        NSSortDescriptor *sort1 = [NSSortDescriptor sortDescriptorWithKey:@"primaryResource.type" ascending:NO];
        //根据好友名字排序,优先级次之
        NSSortDescriptor *sort2 = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
        requset.sortDescriptors = @[sort1,sort2];
        _fetchResultController = [[NSFetchedResultsController alloc]initWithFetchRequest:requset managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
        _fetchResultController.delegate =self;
    }
    return _fetchResultController;
}
- (void)viewDidLoad {
    [super viewDidLoad];    
    [self.fetchResultController performFetch:NULL];
    //添加好友按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFriend)];
    //注册 tableViewCell
    [self.tableView registerNib:[UINib nibWithNibName:@"RosterCell" bundle:nil] forCellReuseIdentifier:@"rosterCell"];
}
-(void)addFriend{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"添加好友" message:@"请输入用户名和昵称" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
         textField.placeholder = @"用户名";
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"昵称";
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        XMPPJID *jid = [XMPPJID jidWithUser:alertController.textFields[0].text domain:kDomain resource:kResource];
        [[XMPPManager shareManager].roster addUser:jid withNickname:alertController.textFields[1].text];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fetchResultController.fetchedObjects.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RosterCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"rosterCell"];
    XMPPUserCoreDataStorageObject *user = self.fetchResultController.fetchedObjects[indexPath.row];
    UIImage *photo = [UIImage imageWithData:[[XMPPManager shareManager].vCardAvatarModule photoDataForJID:user.jid]];
    user.photo = photo;
    cell.user = user;
    return cell;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        XMPPUserCoreDataStorageObject *user = self.fetchResultController.fetchedObjects[indexPath.row];
        [[XMPPManager shareManager].roster removeUser:user.jid];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
#pragma mark - fetchResultControllerDelegate
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView reloadData];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"chatSegue" sender:indexPath];
}
#pragma mark - sugue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"chatSegue"]) {
        NSIndexPath *indexPath = sender;
        XMPPUserCoreDataStorageObject *user = self.fetchResultController.fetchedObjects[indexPath.row];
        ChatVIewController *desVC = segue.destinationViewController;
        desVC.chatTo = user.jid;
    }
}
@end
