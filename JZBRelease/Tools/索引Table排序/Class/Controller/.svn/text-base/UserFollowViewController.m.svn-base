//
//  UserFollowViewController.m
//  剧能玩2.1
//
//  Created by 大兵布莱恩特 on 15/10/28.
//  Copyright © 2015年 大兵布莱恩特 . All rights reserved.
//

#import "UserFollowViewController.h"
#import "UserFollowSearchResultViewController.h"
#import "CustomSearchViewController.h"
#import "SearchResultHandle.h"
#import "FollowGroupModel.h"
#import "FollowModel.h"
#import "ChineseInclude.h"
#import "PinYinForObjc.h"
#import "FollwTableViewCell.h"
#import "NSMutableArray+FilterElement.h"
#import "UIView+MHCommon.h"
#import "RecommendPersonItem.h"

#import "RecommendPersonCell.h"

@interface UserFollowViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate,UISearchControllerDelegate,CustomSearchViewControllerDelegate,UserFollowSearchResultViewControllerDelegate>

@property (nonatomic,strong) UITableView *tableView; // 表示图
@property (nonatomic,strong) NSMutableArray *dataArray; // 数据源大数组
@property (nonatomic,strong) CustomSearchViewController *searchController; // 搜索的控制器
@property (nonatomic,strong) NSMutableArray *searchList; // 搜索结果的数组
@property (nonatomic,strong) UserFollowSearchResultViewController *resultViewController;//搜索的结果控制器
@property (nonatomic,strong) NSMutableArray *array; // 数据源数组 分组和每个区的模型
@property (nonatomic,strong) NSMutableArray *sectionIndexs; // 放字母索引的数组
@end

@implementation UserFollowViewController

#pragma mark - viewWillAppear设置 导航条出现
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"推荐人";
    [self.view addSubview:self.tableView];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    // 创建搜索的控制器
    [self setupSearchController];
    // 加载数据源
    [self loadDatas];
}
/**
 *  加载数据
 */
- (void)loadDatas
{
    
//    self.dataArray = [NSMutableArray arrayWithObjects:@"2dddddd",@"sss",@"sssss",@"ssss",@"百度",@"腾讯",@"阿里巴巴",@"dzb8818082@163.com",@"@#3",@"大兵布莱恩特",@"德克诺维茨基",nil];
    
    // 加载模型数据
    [self downloadData];
    
}

- (void)downloadData
{
    self.array = [NSMutableArray array];
    NSMutableArray *tempArray = [NSMutableArray array];
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/User/saleList"] parameters:nil success:^(id json) {
        
        //        if ([json[@"state"] isEqual:@(0)]) {
        //            [SVProgressHUD show];
        //        }
        
        self.dataArray = [RecommendPersonItem mj_objectArrayWithKeyValuesArray:json];
        //        self.item = [WDBDetailItem mj_objectWithKeyValues:json[@"data"]];
        
//        [self.tableView reloadData];
        
        
        self.sectionIndexs = [NSMutableArray array];
//        for (NSString *string in self.dataArray) {
//            NSString *header = [PinYinForObjc chineseConvertToPinYinHead:string];
//            [self.sectionIndexs addObject:header];
//        }
        for (RecommendPersonItem *item in self.dataArray) {
            NSString *string = item.nickname;
            
            NSString *header = [PinYinForObjc chineseConvertToPinYinHead:string];
            [self.sectionIndexs addObject:header];
        }
        
        // 去除数组中相同的元素
        self.sectionIndexs = [self.sectionIndexs filterTheSameElement];
        // 数组排序
        [self.sectionIndexs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSString *string1 = obj1;
            NSString *string2 = obj2;
            return [string1 compare:string2];
        }];
        // 将排序号的首字母数组取出 分成一个个组模型 和组模型下边的一个个 item
        for (NSString *string in self.sectionIndexs) {
            FollowGroupModel *group = [FollowGroupModel getGroupsWithArray:self.dataArray groupTitle:string];
            if ([group.groupTitle isEqualToString:@"#"]) {
                // 默认 #开头的放在数组的最前边 后边才是 A-Z
                [tempArray insertObject:group atIndex:0];
            }else{
                [tempArray addObject:group];
            }
        }
        
        
        self.array = tempArray;
        [self.tableView reloadData];
        
        
        //        NSLog(@"TTT--json%@",json);
    } failure:^(NSError *error) {
        
    }];
}

/**
 *  初始化搜索控制器
 */
- (void)setupSearchController
{
    self.resultViewController = [[UserFollowSearchResultViewController alloc] init];
    self.resultViewController.delegate = self;
    self.resultViewController.tableView.tableFooterView = [UIView new];
    _searchController = [[CustomSearchViewController alloc] initWithSearchResultsController:self.resultViewController];
    _searchController.delegate = self;
    _searchController.delegateCustom = self;
    _searchController.searchResultsUpdater = self;
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.hidesNavigationBarDuringPresentation = NO;
    _searchController.searchBar.delegate = self;
    _searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    _searchController.searchBar.placeholder = @"请输入搜索的推荐人姓名";
    _searchController.searchBar.searchBarStyle = UISearchBarStyleProminent;
    _searchController.searchBar.returnKeyType = UIReturnKeyDone;
    // 改变取消按钮字体颜色
    _searchController.searchBar.tintColor = [UIColor redColor];
    // 改变searchBar背景颜色
    
    _searchController.searchBar.barTintColor = [UIColor hx_colorWithHexRGBAString:@"222222"];
    _searchController.searchBar.alpha = 0.95;
    // 取消searchBar上下边缘的分割线
//    _searchController.searchBar.backgroundImage = [[UIImage alloc] init];
    self.tableView.tableHeaderView = self.searchController.searchBar;
}
#pragma mark - 懒加载一些内容
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)searchList
{
    if (!_searchList) {
        _searchList = [NSMutableArray array];
    }
    return _searchList;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, GLScreenW, GLScreenH) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.searchController.active?1:self.array.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.active) {
        return 0;
    }
    FollowGroupModel *group = self.array[section];
    return group.follows.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"FollwTableViewCell";
//    FollwTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    RecommendPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
//    cell.item = self.dataSource[indexPath.row];
    
    if (!cell) {
        
        cell = [RecommendPersonCell viewFromBundle];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    FollowGroupModel *group = self.array[indexPath.section];
    RecommendPersonItem *followM = group.follows[indexPath.row];
    
    cell.item = followM;
    
//    cell.nickNmaeLabel.text = followM.nickname;
    return cell;
}
/**
 *   右侧的索引标题数组
 *
 *   @param tableView 标示图
 *
 *   @return 数组
 */
- (NSArray*)sectionIndexTitlesForTableView:(UITableView*)tableView
{
    return self.searchController.active?nil:self.sectionIndexs;
}
//#pragma mark - UITableViewDelegate
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FollowGroupModel *group = self.array[indexPath.section];
    RecommendPersonItem *followM = group.follows[indexPath.row];
    
    Users *user = followM;
    
    if (self.cellback) {
        self.cellback(user);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FollowGroupModel *group = self.array[section];
    // 背景图
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GLScreenW, 30)];
    bgView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    // 显示分区的 label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, GLScreenW-40, 30)];
    label.text = group.groupTitle;
    label.font = FONT_SIZE(15);
    [bgView addSubview:label];
    return bgView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.searchController.active?0:30;
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = [self.searchController.searchBar text];
    // 移除搜索结果数组的数据
    [self.searchList removeAllObjects];
    //过滤数据
    self.searchList= [SearchResultHandle getSearchResultBySearchText:searchString dataArray:self.dataArray];
    if (searchString.length==0&&self.searchList!= nil) {
        [self.searchList removeAllObjects];
    }
    self.searchList = [self.searchList filterTheSameElement];
    NSMutableArray *dataSource = nil;
    if ([self.searchList count]>0) {
        dataSource = [NSMutableArray array];
        // 结局了数据重复的问题
        
        [dataSource addObjectsFromArray:self.searchList];
        
//        for (NSString *str in self.searchList) {
////            FollowModel *model = [[FollowModel alloc] init];
////            model.nickname = str;
////            model.img_Url = nil;
//            
//            Users *model = [[Users alloc] init];
////            model = 
//            
//            [dataSource addObject:model];
//        }
    }
    //刷新表格
    self.resultViewController.dataSource = dataSource;
    [self.resultViewController.tableView reloadData];
    [self.tableView reloadData];
}

#pragma mark - 设置 tableViewcell横线左对齐
-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchControllerDissmiss];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self searchControllerDissmiss];
}
#pragma mark - CustomSearchViewControllerDelegate
/**
 *  搜索控制器的自定义导航条返回按钮
 *
 *  @param searchController 搜索的控制器
 */
- (void)searchControllerBackButtonClick:(UISearchController *)searchController
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UserFollowSearchResultViewControllerDelegate
/**
 *  点击了搜索的结果的 cell
 *
 *  @param resultVC  搜索结果的控制器
 *  @param follow    搜索结果信息的模型
 */
- (void)resultViewController:(UserFollowSearchResultViewController *)resultVC didSelectFollowModel:(FollowModel *)follow
{
    [self searchControllerDissmiss];
    
    RecommendPersonItem *followM = (RecommendPersonItem *)follow;
    
    Users *user = followM;
    
    if (self.cellback) {
        self.cellback(user);
    }
    [self.searchController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  搜索的控制器消失了
 */
- (void)searchControllerDissmiss
{
    self.searchController.searchBar.text = @"";
//    [self.searchController dismissViewControllerAnimated:YES completion:nil];
}


@end
