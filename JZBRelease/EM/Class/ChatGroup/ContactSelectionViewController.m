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

#import "ContactSelectionViewController.h"

#import "EMSearchBar.h"
#import "EMRemarkImageView.h"
#import "EMSearchDisplayController.h"
#import "RealtimeSearchUtil.h"
#import "HXFriendDataSource.h"
#import "DataBaseHelperSecond.h"

@interface ContactSelectionViewController ()<UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) NSMutableArray *contactsSource;
@property (strong, nonatomic) NSMutableArray *selectedContacts;
@property (strong, nonatomic) NSMutableArray *blockSelectedUsernames;

@property (strong, nonatomic) EMSearchBar *searchBar;
@property (strong, nonatomic) EMSearchDisplayController *searchController;

@property (strong, nonatomic) UIView *footerView;
@property (strong, nonatomic) UIScrollView *footerScrollView;
@property (strong, nonatomic) UIButton *doneButton;

@property (strong, nonatomic) NSMutableArray *imgDataSource;

@property (nonatomic) BOOL presetDataSource;

/** FMDBTool */
@property (nonatomic, strong) GLFMDBToolSDK *FMDBTool;

@end

@implementation ContactSelectionViewController

- (GLFMDBToolSDK *)FMDBTool
{
    if (_FMDBTool == nil) {
        _FMDBTool = [GLFMDBToolSDK shareToolsWithCreateDDL:nil];
    }
    return _FMDBTool;
}

- (NSMutableArray *)imgDataSource
{
    if (_imgDataSource == nil) {
        _imgDataSource = [NSMutableArray array];
    }
    return _imgDataSource;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _contactsSource = [NSMutableArray array];
        _selectedContacts = [NSMutableArray array];
        
        [self setObjectComparisonStringBlock:^NSString *(id object) {
            return object;
        }];
        
        [self setComparisonObjectSelector:^NSComparisonResult(id object1, id object2) {
            NSString *username1 = (NSString *)object1;
            NSString *username2 = (NSString *)object2;
            
            return [username1 caseInsensitiveCompare:username2];
        }];
    }
    return self;
}

- (instancetype)initWithBlockSelectedUsernames:(NSArray *)blockUsernames
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        _blockSelectedUsernames = [NSMutableArray array];
        [_blockSelectedUsernames addObjectsFromArray:blockUsernames];
    }
    
    return self;
}

- (instancetype)initWithContacts:(NSArray *)contacts
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        _presetDataSource = YES;
        [_contactsSource addObjectsFromArray:contacts];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"title.chooseContact", @"select the contact");
    self.navigationItem.rightBarButtonItem = nil;
    
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.footerView];
    self.tableView.editing = YES;
    self.tableView.frame = CGRectMake(0, self.searchBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.searchBar.frame.size.height - self.footerView.frame.size.height);
    [self searchController];
    
    if ([_blockSelectedUsernames count] > 0) {
        for (NSString *username in _blockSelectedUsernames) {
            NSInteger section = [self sectionForString:username];
            NSMutableArray *tmpArray = [_dataSource objectAtIndex:section];
            if (tmpArray && [tmpArray count] > 0) {
                for (int i = 0; i < [tmpArray count]; i++) {
                    NSString *buddy = [tmpArray objectAtIndex:i];
                    if ([buddy isEqualToString:username]) {
                        [self.selectedContacts addObject:buddy];
                        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:section] animated:NO scrollPosition:UITableViewScrollPositionNone];
                        
                        break;
                    }
                }
            }
        }
        
        if ([_selectedContacts count] > 0) {
            [self reloadFooterView];
        }
    }
    
    [self _setupBarButtonItem];
}

/** 高林修改 群组 NavBar */
/** 高林修改chat聊天界面navBar按钮 */
- (void)_setupBarButtonItem
{
//    /** nav右上btn 全选 */
//    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
//    addButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
//    [addButton setTitle:@"全选" forState:UIControlStateNormal];
//    [addButton setTitle:@"清空" forState:UIControlStateSelected];
//    addButton.selected = NO;
//    [addButton setTitleColor:[UIColor hx_colorWithHexRGBAString:@"ffffff"] forState:UIControlStateNormal];
//    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//    [addButton addTarget:self action:@selector(ContactAllSelectOrNo:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
//    [self.navigationItem setRightBarButtonItem:rightItem];
    
    [self setupNavBarTitle];
}

- (void)setupNavBarTitle
{
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.glw_width - 112 * 2, 40)];
    titleLable.text = self.title;
    titleLable.textColor = [UIColor hx_colorWithHexRGBAString:@"ffffff"];
    titleLable.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLable;
}

/** 全选/清空 */
- (void)ContactAllSelectOrNo:(UIButton *)clickSelBtn
{
    /** 
     clickSelBtn.selected = !clickSelBtn.selected;
     
     
     if (clickSelBtn.isSelected) {
     for (int i = 1; i < [self.dataSource count]; ++i) {
     
     for (int j = 1; j < [[self.dataSource objectAtIndex:i] count]; ++j) {
     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:j];
     
     [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
     NSLog(@"gaolintgttt%d",i);
     }
     
     //            [self.selectedContacts addObjectsFromArray:_dataSource];
     }
     
     }else {
     
     for (int i = 0; i < _dataSource.count; i++) {
     
     NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
     
     [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
     
     //            [self.selectedContacts addObjectsFromArray:_dataSource];
     }
     }
     
     
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter

- (UISearchBar *)searchBar
{
    if (_searchBar == nil) {
        _searchBar = [[EMSearchBar alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 44)];
        _searchBar.delegate = self;
        _searchBar.placeholder = NSLocalizedString(@"search", @"Search");
        _searchBar.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        _searchBar.backgroundColor = [UIColor colorWithRed:0.747 green:0.756 blue:0.751 alpha:1.000];
    }
    
    return _searchBar;
}

- (EMSearchDisplayController *)searchController
{
    if (_searchController == nil) {
        _searchController = [[EMSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        _searchController.editingStyle = UITableViewCellEditingStyleInsert | UITableViewCellEditingStyleDelete;
        _searchController.delegate = self;
        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        __weak ContactSelectionViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            static NSString *CellIdentifier = @"ContactListCell";
            BaseTableViewCell *cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            // Configure the cell...
            if (cell == nil) {
                cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            NSString *username = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            cell.imageView.image = [UIImage imageNamed:@"chatListCellHead.png"];
            cell.textLabel.text = username;
            cell.username = username;
            
            return cell;
        }];
        
        [_searchController setCanEditRowAtIndexPath:^BOOL(UITableView *tableView, NSIndexPath *indexPath) {
            if ([weakSelf.blockSelectedUsernames count] > 0) {
                NSString *username = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
                return ![weakSelf isBlockUsername:username];
            }
            
            return YES;
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return 50;
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            NSString *username = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            if (![weakSelf.selectedContacts containsObject:username])
            {
                NSInteger section = [weakSelf sectionForString:username];
                if (section >= 0) {
                    NSMutableArray *tmpArray = [weakSelf.dataSource objectAtIndex:section];
                    NSInteger row = [tmpArray indexOfObject:username];
                    [weakSelf.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] animated:NO scrollPosition:UITableViewScrollPositionNone];
                }
                
                [weakSelf.selectedContacts addObject:username];
                [weakSelf reloadFooterView];
            }
        }];
        
        [_searchController setDidDeselectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            NSString *username = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            if ([weakSelf.selectedContacts containsObject:username]) {
                NSInteger section = [weakSelf sectionForString:username];
                if (section >= 0) {
                    NSMutableArray *tmpArray = [weakSelf.dataSource objectAtIndex:section];
                    NSInteger row = [tmpArray indexOfObject:username];
                    [weakSelf.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] animated:NO];
                }
                
                [weakSelf.selectedContacts removeObject:username];
                [weakSelf reloadFooterView];
            }
        }];
    }
    
    return _searchController;
}

- (UIView *)footerView
{
    if (self.mulChoice && _footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
        _footerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        _footerView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
        
        _footerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 0, _footerView.frame.size.width - 30 - 70, _footerView.frame.size.height - 5)];
        _footerScrollView.backgroundColor = [UIColor clearColor];
        [_footerView addSubview:_footerScrollView];
        
        _doneButton = [[UIButton alloc] initWithFrame:CGRectMake(_footerView.frame.size.width - 80, 8, 70, _footerView.frame.size.height - 16)];
//        [_doneButton setBackgroundColor:[UIColor colorWithRed:10 / 255.0 green:82 / 255.0 blue:104 / 255.0 alpha:1.0]];
        [_doneButton setTitle:NSLocalizedString(@"accept", @"Accept") forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor hx_colorWithHexRGBAString:@"000000"] forState:UIControlStateNormal];
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_doneButton setTitle:NSLocalizedString(@"ok", @"OK") forState:UIControlStateNormal];
        [_doneButton addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:_doneButton];
    }
    
    return _footerView;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ContactListCell";
    BaseTableViewCell *cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *username = [[_dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    for (NSDictionary *dictM in self.imgDataSource) {
        for (NSString *userNameT in dictM.allKeys) {
            if ([userNameT isEqualToString:username]) {
                NSString *value = dictM[userNameT];
                [cell.imageView sd_setImageWithURL:[NSURL URLWithString:value] placeholderImage:[UIImage imageNamed:@"ZCCG_TX"]];
            }
        }
    }
    
//    cell.imageView.image = [UIImage imageNamed:@"chatListCellHead.png"];
    
//    cell.imageView.image = [UIImage imageNamed:@"chatListCellHead.png"];
    
    cell.textLabel.text = username;
    cell.username = username;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if ([_blockSelectedUsernames count] > 0) {
        NSString *username = [[_dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        return ![self isBlockUsername:username];
    }
    
    return YES;
}

#pragma mark - Table view delegate
/** 高林 群加人 选择联系人 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [[_dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (self.mulChoice) {
        if (![self.selectedContacts containsObject:object])
        {
            [self.selectedContacts addObject:object];
            [self reloadFooterView];
        }
    }
    else {
        [self.selectedContacts addObject:object];
        [self doneAction:nil];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *username = [[_dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([self.selectedContacts containsObject:username]) {
        [self.selectedContacts removeObject:username];
        
        [self reloadFooterView];
    }
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    [self.searchBar setCancelButtonTitle:NSLocalizedString(@"ok", @"OK")];
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    __weak typeof(self) weakSelf = self;
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.contactsSource searchText:searchText collationStringSelector:@selector(username) resultBlock:^(NSArray *results) {
        if (results) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.searchController.resultsSource removeAllObjects];
                [weakSelf.searchController.resultsSource addObjectsFromArray:results];
                [weakSelf.searchController.searchResultsTableView reloadData];
                
                for (NSString *username in results) {
                    if ([weakSelf.selectedContacts containsObject:username])
                    {
                        NSInteger row = [results indexOfObject:username];
                        [weakSelf.searchController.searchResultsTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                    }
                }
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

#pragma mark - UISearchDisplayDelegate

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    tableView.editing = YES;
}

#pragma mark - private

- (BOOL)isBlockUsername:(NSString *)username
{
    if (username && [username length] > 0) {
        if ([_blockSelectedUsernames count] > 0) {
            for (NSString *tmpName in _blockSelectedUsernames) {
                if ([username isEqualToString:tmpName]) {
                    return YES;
                }
            }
        }
    }
    
    return NO;
}

- (void)reloadFooterView
{
    if (self.mulChoice) {
        [self.footerScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        CGFloat imageSize = self.footerScrollView.frame.size.height;
        NSInteger count = [self.selectedContacts count];
        self.footerScrollView.contentSize = CGSizeMake(imageSize * count, imageSize);
        for (int i = 0; i < count; i++) {
            NSString *username = [self.selectedContacts objectAtIndex:i];
            EMRemarkImageView *remarkView = [[EMRemarkImageView alloc] initWithFrame:CGRectMake(i * imageSize, 0, imageSize, imageSize)];
            remarkView.remark = username;
            for (NSDictionary *dictM in self.imgDataSource) {
                for (NSString *userNameT in dictM.allKeys) {
                    if ([userNameT isEqualToString:username]) {
                        NSString *value = dictM[userNameT];
                        [remarkView.glImageView sd_setImageWithURL:[NSURL URLWithString:value] placeholderImage:[UIImage imageNamed:@"ZCCG_TX"]];
                    }
                }
            }

            [self.footerScrollView addSubview:remarkView];
        }
        
        if ([self.selectedContacts count] == 0) {
            [_doneButton setTitle:NSLocalizedString(@"ok", @"OK") forState:UIControlStateNormal];
        }
        else{
            [_doneButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"doneWithCount", @"Done(%i)"), [self.selectedContacts count]] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - public
/** 选择联系人 加载数据 */
- (void)loadDataSource
{
  //  NSMutableArray *imgs = [NSMutableArray array];
    
    if (!_presetDataSource) {
        [self showHudInView:self.view hint:NSLocalizedString(@"loadData", @"Load data...")];
        [_dataSource removeAllObjects];
        [_contactsSource removeAllObjects];
        
//        NSArray *buddyList = [[EMClient sharedClient].contactManager getContactsFromDB];
//        for (NSString *username in buddyList) {
//            HXFriendDataSource *friendDataSource = [HXFriendDataSource new];
//            friendDataSource.uid = [username substringFromIndex:7];
//            friendDataSource = (HXFriendDataSource *)[[DataBaseHelperSecond getInstance]getModelFromTabel:friendDataSource];
//            
//            [self.contactsSource addObject:friendDataSource.nickname];
//        }
        
        // 传入DDL 创建表打开数据库[banner][entranceIcons][partitions]
        self.FMDBTool = [GLFMDBToolSDK shareToolsWithCreateDDL:nil];
        
        // 查询数据【banner】
        NSString *query_sql = @"select * from t_HXFriendDataSource";
        
        FMResultSet *result = [self.FMDBTool queryWithSql:query_sql];
        while ([result next]) { // next方法返回yes代表有数据可取
            HXFriendDataSource *friendDataSource = [HXFriendDataSource new];
            friendDataSource.uid = [result stringForColumn:@"uid"];
            
            friendDataSource.nickname = [result stringForColumn:@"nickname"];
            friendDataSource.UserModel = [NSKeyedUnarchiver unarchiveObjectWithData:[result dataNoCopyForColumn:@"UserModel"]];
            if (friendDataSource.nickname){
                [self.contactsSource addObject:friendDataSource.nickname];
                [self.imgDataSource addObject:@{friendDataSource.nickname:friendDataSource.UserModel.avatarURLPath}];
            }
        }
        
        [_dataSource addObjectsFromArray:[self sortRecords:self.contactsSource]];
        [self hideHud];
    }
    else {
        _dataSource = [[self sortRecords:self.contactsSource] mutableCopy];
    }
    [self.tableView reloadData];
}

/** 高林 点击 群聊成员 选择完成 确认需要添加 需要触发的代理 */
- (void)doneAction:(id)sender
{
    BOOL isPop = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(viewController:didFinishSelectedSources:)]) {
        if ([_blockSelectedUsernames count] == 0) {
            isPop = [_delegate viewController:self didFinishSelectedSources:self.selectedContacts];
        }
        else{
            NSMutableArray *resultArray = [NSMutableArray array];
            for (NSString *username in self.selectedContacts) {
                if(![self isBlockUsername:username])
                {
                    [resultArray addObject:username];
                }
            }
            isPop = [_delegate viewController:self didFinishSelectedSources:resultArray];
        }
    }
    
    if (isPop) {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)backAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(viewControllerDidSelectBack:)]) {
        [_delegate viewControllerDidSelectBack:self];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
