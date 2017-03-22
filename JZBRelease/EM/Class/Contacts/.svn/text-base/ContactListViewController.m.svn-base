/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "ContactListViewController.h"

//#import "EaseChineseToPinyin.h"
#import "ChatViewController.h"
#import "RobotListViewController.h"
#import "ChatroomListViewController.h"
#import "AddFriendViewController.h"
#import "ApplyViewController.h"
#import "EMSearchBar.h"
#import "EMSearchDisplayController.h"
#import "UserProfileManager.h"
#import "RealtimeSearchUtil.h"
#import "UserProfileManager.h"
#import "RedPacketChatViewController.h"
#import "HXFriendList.h"
#import "DataBaseHelperSecond.h"
#import "HXFriendDataSource.h"
#import "HXDataHelper.h"

#import "AFNetworking.h"
#import "HttpToolSDK.h"

#import "MJExtension.h"

#import "ApplyFriendNoticeVC.h"
#import "ApplyGruopNoticeVC.h"

@implementation NSString (search)

//根据用户昵称进行搜索
- (NSString*)showName
{
    return [[UserProfileManager sharedInstance] getNickNameWithUsername:self];
}

@end

@interface ContactListViewController ()<UISearchBarDelegate, UISearchDisplayDelegate,BaseTableCellDelegate,UIActionSheetDelegate,EaseUserCellDelegate>
{
    NSIndexPath *_currentLongPressIndex;
}

@property (strong, nonatomic) NSMutableArray *sectionTitles;
@property (strong, nonatomic) NSMutableArray *contactsSource;
@property (strong, nonatomic) NSMutableArray *glFriendContactsSource;

@property (nonatomic) NSInteger unapplyCount;
@property (strong, nonatomic) EMSearchBar *searchBar;

@property (strong, nonatomic) EMSearchDisplayController *searchController;

@property (strong, nonatomic) AFHTTPSessionManager *manager;

/** userInfo */
@property (nonatomic, strong) UserInfo *userInfo;

/** FMDBTool */
@property (nonatomic, strong) GLFMDBToolSDK *FMDBTool;

@end

@implementation ContactListViewController

+(void)load
{
    

}

- (NSMutableArray *)glFriendContactsSource
{
    if (_glFriendContactsSource == nil) {
        _glFriendContactsSource = [NSMutableArray array];
    }
    return _glFriendContactsSource;
}

- (GLFMDBToolSDK *)FMDBTool
{
    if (_FMDBTool == nil) {
        _FMDBTool = [GLFMDBToolSDK shareToolsWithCreateDDL:nil];
    }
    return _FMDBTool;
}

- (UserInfo *)userInfo
{
    if (_userInfo == nil) {
        _userInfo = [[UserInfo alloc] init];
    }
    return _userInfo;
}

- (AFHTTPSessionManager *)manager
{
    if(!_manager){
        _manager = [[AFHTTPSessionManager alloc]init];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNote];
    
    self.userInfo = [[LoginVM getInstance]readLocal];
    
    // Do any additional setup after loading the view.
    self.showRefreshHeader = YES;
    
    _contactsSource = [NSMutableArray array];
    _sectionTitles = [NSMutableArray array];
    
    [self searchController];
    self.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    [self.view addSubview:self.searchBar];
    
    self.tableView.frame = CGRectMake(0, self.searchBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.searchBar.frame.size.height);
    // 15的距离在哪还没找到,暂时写在这里
//    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.searchBar.frame.size.height);
    
    // 环信UIdemo中有用到Parse, 加载用户好友个人信息
    [[UserProfileManager sharedInstance] loadUserProfileInBackgroundWithBuddy:self.contactsSource saveToLoacal:YES completion:NULL];
    
//    self.tableView.backgroundColor = [UIColor orangeColor];
    
    self.view.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"F8F8F8"];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadApplyView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter

- (NSArray *)rightItems
{
    if (_rightItems == nil) {
        UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [addButton setImage:[UIImage imageNamed:@"addContact.png"] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(addContactAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
        _rightItems = @[addItem];
    }
    
    return _rightItems;
}

- (UISearchBar *)searchBar
{
    if (_searchBar == nil) {
        _searchBar = [[EMSearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.placeholder = NSLocalizedString(@"search", @"Search");
        _searchBar.backgroundColor = [UIColor colorWithRed:0.747 green:0.756 blue:0.751 alpha:1.000];
    }
    
    return _searchBar;
}

- (EMSearchDisplayController *)searchController
{
    if (_searchController == nil) {
        _searchController = [[EMSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        _searchController.delegate = self;
        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        __weak ContactListViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            static NSString *CellIdentifier = @"ContactListCell";
            BaseTableViewCell *cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            // Configure the cell...
            if (cell == nil) {
                cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            NSString *buddy = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            cell.imageView.image = [UIImage imageNamed:@"ZCCG_TX"];
            cell.textLabel.text = buddy;
            cell.username = buddy;
            
            return cell;
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return 50;
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            NSString *buddy = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            NSString *loginUsername = [[EMClient sharedClient] currentUsername];
            if (loginUsername && loginUsername.length > 0) {
                if ([loginUsername isEqualToString:buddy]) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"friend.notChatSelf", @"can't talk to yourself") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
                    [alertView show];
                    
                    return;
                }
            }
            
            [weakSelf.searchController.searchBar endEditing:YES];

#ifdef REDPACKET_AVALABLE
            RedPacketChatViewController *chatVC = [[RedPacketChatViewController alloc]
#else
            ChatViewController *chatVC = [[ChatViewController alloc]
#endif
                                          initWithConversationChatter:buddy
                                                                                conversationType:EMConversationTypeChat];
            chatVC.title = [[UserProfileManager sharedInstance] getNickNameWithUsername:buddy];
                                                   
           chatVC.hidesBottomBarWhenPushed = YES;
                                                   
            [weakSelf.navigationController pushViewController:chatVC animated:YES];
        }];
    }

    return _searchController;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.dataArray count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    }
    
    return [[self.dataArray objectAtIndex:(section - 1)] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) { // 头部cell
        
        NSString *CellIdentifier = @"commonCell";
        EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            if (indexPath.row == 1) {
                
                /** 
                 
                 NSString *CellIdentifier = @"addFriend";
                 EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                 if (cell == nil) {
                 cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                 }
                 // 这里修改图片
                 cell.avatarView.image = [UIImage imageNamed:@"grzx_contacts_addfriend"];
                 //            cell.titleLabel.text = NSLocalizedString(@"title.apply", @"Application and notification");
                 cell.titleLabel.text = @"新好友";
                 cell.avatarView.badge = self.unapplyCount;
                 return cell;
                 
                 */
                
//                cell.avatarView.image = [UIImage imageNamed:@"grzx_contacts_bangpai"];
//                //            cell.titleLabel.text = NSLocalizedString(@"title.chatroomlist",@"chatroom list");
//                cell.titleLabel.text = @"帮派";
            }
        
        
        }
        
        if (indexPath.row == 0) {
            cell.avatarView.image = [UIImage imageNamed:@"LB_newcommunity"];
            
            //            cell.titleLabel.text = NSLocalizedString(@"title.robotlist",@"robot list");
            cell.titleLabel.text = @"社群";
            
            /** 
             
             cell.avatarView.image = [UIImage imageNamed:@"grzx_contacts_addshequn"];
             //            cell.titleLabel.text = NSLocalizedString(@"title.group", @"Group");
             cell.titleLabel.text = @"新社群";
             //            cell.avatarView.badge = 2;

             */
            
        }
        else if (indexPath.row == 2) {
//            cell.avatarView.image = [UIImage imageNamed:@"grzx_contacts_daka"];
//            //            cell.titleLabel.text = NSLocalizedString(@"title.robotlist",@"robot list");
//            cell.titleLabel.text = @"关注的大咖";
        }
        else if (indexPath.row == 3) {
            
        }
        
        else if (indexPath.row == 4) {
            
        }
        return cell;
    }
    else{ // 返回联系人cell
        NSString *CellIdentifier = [EaseUserCell cellIdentifierWithModel:nil];
        EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        // Configure the cell...
        if (cell == nil) {
            cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        NSArray *userSection = [self.dataArray objectAtIndex:(indexPath.section - 1)];
        EaseUserModel *model = [userSection objectAtIndex:indexPath.row];
        
        UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:model.buddy];
        if (profileEntity) {
            // 头像地址
            model.avatarURLPath = profileEntity.imageUrl;
            model.avatarImage = [UIImage imageNamed:@"chatListCellHead@2x.png"];
            model.nickname = profileEntity.nickname == nil ? profileEntity.username : profileEntity.nickname;
        }
        model.avatarImage = [UIImage imageNamed:@"ZCCG_TX"];
        cell.indexPath = indexPath;
        cell.delegate = self;
        cell.model = model;
        
        return cell;
    }}

#pragma mark - Table view delegate

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionTitles;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    else{
        return 22;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return nil;
    }
    
    UIView *contentView = [[UIView alloc] init];
//    [contentView setBackgroundColor:[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0]];
    
    [contentView setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"F8F8F8"]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 22)];
    label.backgroundColor = [UIColor clearColor];
    [label setText:[self.sectionTitles objectAtIndex:(section - 1)]];
    [contentView addSubview:label];
    return contentView;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

/** 点击了tableViewCell */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        if (row == 1) { // 帮派
            
            /** 
             ApplyFriendNoticeVC *applyFriendNoticeVC = [ApplyFriendNoticeVC new];
             
             applyFriendNoticeVC.hidesBottomBarWhenPushed = YES;
             
             [self.navigationController pushViewController:applyFriendNoticeVC animated:YES];
             if ([self.tabBarController.tabBarItem.badgeValue isEqualToString:@"F"]){
             
             self.tabBarController.tabBarItem.badgeValue = nil;
             
             }
             */
            
            
        }
        else if (row == 0) // 社群
        {
            /** 环信助手 */
            //            RobotListViewController *robot = [[RobotListViewController alloc] init];
            //            [self.navigationController pushViewController:robot animated:YES];
            /** 聊天室 */
            //            ChatroomListViewController *controller = [[ChatroomListViewController alloc] initWithStyle:UITableViewStylePlain];
            //            [self.navigationController pushViewController:controller animated:YES];
            
            GroupListViewController *groupController = [[GroupListViewController alloc] initWithStyle:UITableViewStylePlain];
            
            groupController.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:groupController animated:YES];
            
            /** 
             ApplyGruopNoticeVC *applyGruopNoticeVC = [ApplyGruopNoticeVC new];
             
             applyGruopNoticeVC.hidesBottomBarWhenPushed = YES;
             
             [self.navigationController pushViewController:applyGruopNoticeVC animated:YES];
             
             if ([self.tabBarController.tabBarItem.badgeValue isEqualToString:@"G"]){
             
             self.tabBarController.tabBarItem.badgeValue = nil;
             
             }

             
             */
            
//            if (_groupController == nil) {
//                _groupController = [[GroupListViewController alloc] initWithStyle:UITableViewStylePlain];
//            }
//            else{
//                [_groupController reloadDataSource];
//            }
//            [self.navigationController pushViewController:[ApplyViewController shareController] animated:YES];
//            GroupListViewController *groupController = [[GroupListViewController alloc] initWithStyle:UITableViewStylePlain];
//            [self.navigationController pushViewController:groupController animated:YES];
        }
        else if (row == 2) // 关注的大咖
        {
            
        }
        else if (row == 3) {
            
        }
    }
    else{ // 联系人点击
        EaseUserModel *model = [[self.dataArray objectAtIndex:(section - 1)] objectAtIndex:row];
        NSString *loginUsername = [[EMClient sharedClient] currentUsername];
        if (loginUsername && loginUsername.length > 0) {
            if ([loginUsername isEqualToString:model.buddy]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"friend.notChatSelf", @"can't talk to yourself") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
                [alertView show];
                
                return;
            }
        }
#ifdef REDPACKET_AVALABLE
        RedPacketChatViewController *chatController = [[RedPacketChatViewController alloc]
#else
        ChatViewController *chatController = [[ChatViewController alloc]
#endif
                                              initWithConversationChatter:model.uid conversationType:EMConversationTypeChat];
        chatController.title = model.nickname.length > 0 ? model.nickname : model.buddy;
                  
       chatController.hidesBottomBarWhenPushed = YES;
                                                       
        [self.navigationController pushViewController:chatController animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.section == 0) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *loginUsername = [[EMClient sharedClient] currentUsername];
        EaseUserModel *model = [[self.dataArray objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
//        if ([model.buddy isEqualToString:loginUsername]) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"friend.notDeleteSelf", @"can't delete self") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
//            [alertView show];
//            
//            return;
//        }
//        
//        EMError *error = [[EMClient sharedClient].contactManager deleteContact:model.buddy];
//        if (!error) {
//            [[EMClient sharedClient].chatManager deleteConversation:model.buddy deleteMessages:YES];
//            
//            [tableView beginUpdates];
//            [[self.dataArray objectAtIndex:(indexPath.section - 1)] removeObjectAtIndex:indexPath.row];
//            [self.contactsSource removeObject:model.buddy];
//            [tableView  deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            [tableView endUpdates];
//        }
//        else{
//            [self showHint:[NSString stringWithFormat:NSLocalizedString(@"deleteFailed", @"Delete failed:%@"), error.errorDescription]];
//            [tableView reloadData];
//        }
        
        NSDictionary *parameters = @{
                                     @"access_token":[LoginVM getInstance].readLocal.token,
                                     @"to_uid":[model.uid substringFromIndex:7]
                                     };
        
        EMError *error = [[EMClient sharedClient].contactManager deleteContact:model.uid];
        if (!error) {
            [[EMClient sharedClient].chatManager deleteConversation:model.uid deleteMessages:YES];
  
            }
        [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/Friend/del"] parameters:parameters success:^(id json) {
        
            publicBaseJsonItem *item = [publicBaseJsonItem mj_objectWithKeyValues:json];
            
        if ([item.state isEqual:@(0)]) {
            [SVProgressHUD show];
            return ;
        }
            
            [SVProgressHUD showInfoWithStatus:@"删除成功"];
            [tableView beginUpdates];
            [[self.dataArray objectAtIndex:(indexPath.section - 1)] removeObjectAtIndex:indexPath.row];
            [self.contactsSource removeObject:model.uid];
            [tableView  deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView endUpdates];
//            NSLog(@"TTT--json%@",json);
        } failure:^(NSError *error) {
            
        }];
        
        
    }
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    __weak typeof(self) weakSelf = self;
    if (self.glFriendContactsSource.count == 0) return;
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.glFriendContactsSource searchText:(NSString *)searchText collationStringSelector:@selector(showName) resultBlock:^(NSArray *results) {
        if (results) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.searchController.resultsSource removeAllObjects];
                [weakSelf.searchController.resultsSource addObjectsFromArray:results];
                [weakSelf.searchController.searchResultsTableView reloadData];
            });
        }
    }];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [[RealtimeSearchUtil currentUtil] realtimeSearchStop];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - BaseTableCellDelegate

- (void)cellImageViewLongPressAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row >= 1) {
        // 群组，聊天室
        return;
    }
    NSString *loginUsername = [[EMClient sharedClient] currentUsername];
    EaseUserModel *model = [[self.dataArray objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
    if ([model.buddy isEqualToString:loginUsername])
    {
        return;
    }
    
    _currentLongPressIndex = indexPath;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") destructiveButtonTitle:NSLocalizedString(@"friend.block", @"join the blacklist") otherButtonTitles:nil, nil];
    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
}

#pragma mark - action

- (void)addContactAction
{
    AddFriendViewController *addController = [[AddFriendViewController alloc] initWithStyle:UITableViewStylePlain];
    
    addController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:addController animated:YES];
}

#pragma mark - private data

// 系统给联系人tableView赋值方法
- (void)_sortDataArray:(NSArray *)buddyList
{
//    NSLog(@"self.dataArray--%@",self.dataArray);
//    NSLog(@"self.dataArray--%@",self.sectionTitles);
    [self.dataArray removeAllObjects];
    [self.sectionTitles removeAllObjects];
    
    NSMutableArray *contactsSource = [NSMutableArray array];
    NSMutableArray *uids = [NSMutableArray array];
    NSMutableArray *userModels = [NSMutableArray array];
    
    //从获取的数据中剔除黑名单中的好友
    NSArray *blockList = [[EMClient sharedClient].contactManager getBlackListFromDB];
//    for (NSString *buddy in buddyList) {
//        if (![blockList containsObject:buddy]) {
//            [contactsSource addObject:buddy];
//        }
//    }
    /** 加载/更新 数据源 */
    for (NSString *buddy in buddyList) {
//        if (![blockList containsObject:buddy]) {
//            
//            HXFriendDataSource *friendDataSource = [HXFriendDataSource new];
//            friendDataSource.uid = [buddy substringFromIndex:7];
//            [uids addObject:friendDataSource.uid];
////
//            friendDataSource = (HXFriendDataSource *)[[DataBaseHelperSecond getInstance]getModelFromTabel:friendDataSource];
////
//            if (friendDataSource.nickname){
//                [contactsSource addObject:friendDataSource.nickname];
//            }
//        }
        
    }
        // 传入DDL 创建表打开数据库[banner][entranceIcons][partitions]
        self.FMDBTool = [GLFMDBToolSDK shareToolsWithCreateDDL:nil];
        
        // 查询数据【banner】
        NSString *query_sql = @"select * from t_HXFriendDataSource";
        
        FMResultSet *result = [self.FMDBTool queryWithSql:query_sql];
        while ([result next]) { // next方法返回yes代表有数据可取
            HXFriendDataSource *friendDataSource = [HXFriendDataSource new];
            friendDataSource.uid = [result stringForColumn:@"uid"];
            
            [uids addObject:friendDataSource.uid];
            
            friendDataSource.nickname = [result stringForColumn:@"nickname"];
            friendDataSource.UserModel = [NSKeyedUnarchiver unarchiveObjectWithData:[result dataNoCopyForColumn:@"UserModel"]];
            [userModels addObject:friendDataSource.UserModel];
            if (friendDataSource.nickname){
                [contactsSource addObject:friendDataSource.nickname];
                [self.glFriendContactsSource addObject:friendDataSource.nickname];
            }
        }
//    for (NSDictionary *buddy in buddyList) {
//        if (![blockList containsObject:buddy]) {
//            if ([buddy isKindOfClass:[NSDictionary class]]){
//                [contactsSource addObject:buddy.allValues[0]];
//                [uids addObject:buddy.allKeys[0]];
//            }else{
//                [contactsSource addObject:buddy];
//            }
//        }
//    }
    
    //建立索引的核心, 返回27，是a－z和＃
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    [self.sectionTitles addObjectsFromArray:[indexCollation sectionTitles]];
    
    NSInteger highSection = [self.sectionTitles count];
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i < highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
    }
    
    //按首字母分组
    int index = 0;
    for (NSString *buddy in contactsSource) {
        
        EaseUserModel *model = userModels[index];
        if (model) {
            //            model.avatarURLPath = .userModels[index]
            model.nickname = [[UserProfileManager sharedInstance] getNickNameWithUsername:buddy];
            model.uid = [NSString stringWithFormat:@"member_%@",uids[index]];
            ;
            index++;
            NSString *firstLetter = [EaseChineseToPinyin pinyinFromChineseString:[[UserProfileManager sharedInstance] getNickNameWithUsername:buddy]];
            
            if (!firstLetter.length) {
                firstLetter = @"#";
            };
            
            NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
            
            if (sortedArray.count){
                NSMutableArray *array = [sortedArray objectAtIndex:section];
                [array addObject:model];
            }
            
            
        }
    }
    
    //每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(EaseUserModel *obj1, EaseUserModel *obj2) {
            NSString *firstLetter1 = [EaseChineseToPinyin pinyinFromChineseString:obj1.buddy];
            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
            
            NSString *firstLetter2 = [EaseChineseToPinyin pinyinFromChineseString:obj2.buddy];
            firstLetter2 = [[firstLetter2 substringToIndex:1] uppercaseString];
            
            return [firstLetter1 caseInsensitiveCompare:firstLetter2];
        }];
        
        
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
    }
    
    //去掉空的section
    for (NSInteger i = [sortedArray count] - 1; i >= 0; i--) {
        NSArray *array = [sortedArray objectAtIndex:i];
        if ([array count] == 0) {
            [sortedArray removeObjectAtIndex:i];
            [self.sectionTitles removeObjectAtIndex:i];
        }
    }
    
    [self.dataArray addObjectsFromArray:sortedArray];
    if (self.dataArray.count > 0) {
        [self.tableView reloadData];
    }
    
}

#pragma mark - EaseUserCellDelegate

- (void)cellLongPressAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row >= 1) {
        // 群组，聊天室
        return;
    }
    NSString *loginUsername = [[EMClient sharedClient] currentUsername];
    EaseUserModel *model = [[self.dataArray objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
    if ([model.buddy isEqualToString:loginUsername])
    {
        return;
    }
    
    _currentLongPressIndex = indexPath;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") destructiveButtonTitle:NSLocalizedString(@"friend.block", @"join the blacklist") otherButtonTitles:nil, nil];
    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex && _currentLongPressIndex) {
        EaseUserModel *model = [[self.dataArray objectAtIndex:(_currentLongPressIndex.section - 1)] objectAtIndex:_currentLongPressIndex.row];
        [self showHudInView:self.view hint:NSLocalizedString(@"wait", @"Pleae wait...")];
        
        EMError *error = [[EMClient sharedClient].contactManager addUserToBlackList:model.buddy relationshipBoth:YES];
        if (!error) {
            //由于加入黑名单成功后会刷新黑名单，所以此处不需要再更改好友列表
            [self reloadDataSource];
        }
        else {
            [self showHint:error.errorDescription];
        }
        [self hideHud];
    }
    _currentLongPressIndex = nil;
}

#pragma mark - data

- (void)tableViewDidTriggerHeaderRefresh
{
    //    [self showHudInView:self.view hint:NSLocalizedString(@"loadData", @"Load data...")];
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        NSArray *buddyList = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
        if (!error) {
            [[EMClient sharedClient].contactManager getBlackListFromServerWithError:&error];
            if (!error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakself.contactsSource removeAllObjects];
                    [weakself.glFriendContactsSource removeAllObjects];
                    
                    for (NSInteger i = (buddyList.count - 1); i >= 0; i--) {
                        NSString *username = [buddyList objectAtIndex:i];
                        [weakself.contactsSource addObject:username];
                    }
                    
                    NSString *loginUsername = [[EMClient sharedClient] currentUsername];
                    if (loginUsername && loginUsername.length > 0) {
                        [weakself.contactsSource addObject:loginUsername];
                    }
                    [weakself _sortDataArray:self.contactsSource];
                });
            }
        }
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself showHint:NSLocalizedString(@"loadDataFailed", @"Load data failed.")];
                [weakself reloadDataSource];
            });
        }
        [weakself tableViewDidFinishTriggerHeader:YES reload:NO];
    });
}

#pragma mark - public

- (void)reloadDataSource
{
    [self.dataArray removeAllObjects];
    [self.contactsSource removeAllObjects];
    [self.glFriendContactsSource removeAllObjects];
    
    NSArray *buddyList = [[EMClient sharedClient].contactManager getContactsFromDB];
    
    for (NSString *buddy in buddyList) {
        [self.contactsSource addObject:buddy];
    }
    
    NSString *loginUsername = [[EMClient sharedClient] currentUsername];
    if (loginUsername && loginUsername.length > 0) {
        [self.contactsSource addObject:loginUsername];
    }
    
    [self _sortDataArray:self.contactsSource];
    
    [self.tableView reloadData];
}

- (void)reloadApplyView
{
//    NSInteger count = [[[ApplyViewController shareController] dataSource] count];
//    self.unapplyCount = count;
    
    [self tableViewDidTriggerHeaderRefresh];
    
    [[HXDataHelper new]loadHXDataWithComplete:^{
        [self tableViewDidTriggerHeaderRefresh];
        [self.tableView reloadData];
    }];
    
//    [self tableViewDidTriggerHeaderRefresh];
    [self.tableView reloadData];
}

- (void)reloadGroupView
{
    [self reloadApplyView];
    
    if (_groupController) {
        [_groupController reloadDataSource];
    }
}

- (void)addFriendAction
{
    AddFriendViewController *addController = [[AddFriendViewController alloc] initWithStyle:UITableViewStylePlain];
    
    addController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:addController animated:YES];
}
         
/** 接收到加好友的信息 */
- (void)MessageFriend_add:(NSNotification *)note
{
    NSUserDefaults *udefault = [NSUserDefaults standardUserDefaults];
    NSInteger num = [udefault integerForKey:@"MessageFriend"];
    self.unapplyCount = num;
//    self.navigationController.tabBarItem.badgeValue = @"N";
    [self.tableView reloadData];
}

- (void)MessageFriend_agree:(NSNotification *)note
{
    NSUserDefaults *udefault = [NSUserDefaults standardUserDefaults];
    NSInteger num = [udefault integerForKey:@"MessageFriend"];
    self.unapplyCount = num;
//    self.navigationController.tabBarItem.badgeValue = @"N";
    [self.tableView reloadData];
}
        
- (void)setupNote
{
    //object是哪个对象发
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadApplyView) name:@"didReceiveAgreedFromUsername" object:nil];
    
    //object是哪个对象发
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadApplyView) name:@"didReceiveAgreedFromUsername" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MessageFriend_add:) name:@"MessageFriend_add" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MessageFriend_agree:) name:@"MessageFriend_agree" object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MessageFriend_add:) name:@"MessageFriend_add" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MessageFriend_agree:) name:@"MessageFriend_agree" object:nil];
}
                                                       
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MessageFriend_add" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MessageFriend_agree" object:nil];
}
                                                       
                                                       

@end
