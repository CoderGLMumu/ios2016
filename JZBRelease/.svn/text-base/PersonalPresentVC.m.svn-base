//
//  PersonalPresentVC.m
//  JZBRelease
//
//  Created by zjapple on 16/5/24.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "PersonalPresentVC.h"
#import "PersonalHeaderView.h"
#import "Defaults.h"
#import "Users.h"
#import "MJRefresh.h"
#import "GetUserInfoModel.h"
#import "PersonalModel.h"
#import "StatusModel.h"
#import "CellLayout.h"
#import "TableViewCell.h"
#import "DynamicDetailVC.h"
#import "LWImageBrowserModel.h"
#import "LWImageBrowser.h"
@interface PersonalPresentVC()<TableViewCellDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong) PersonalHeaderView *personalHeaderView;
@property (nonatomic, strong) WJRefresh *refresh;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray* fakeDatasource;
@property (nonatomic, assign) CGFloat kRefreshBoundary;
@property (nonatomic, assign,getter = isNeedRefresh) BOOL needRefresh;
@property(nonatomic, strong) PersonalModel *model;
@property(nonatomic, assign) int requestCount;
@end

@implementation PersonalPresentVC
@synthesize kRefreshBoundary;
-(void)viewDidLoad{
    //[self.navigationController setNavigationBarHidden:YES];
    //self.tabBarController.tabBar.hidden = YES;
    kRefreshBoundary = 40.0f;
    [self createTableView];
    UIView *barBackground = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    barBackground.backgroundColor = [ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Personal_XM_Color" WithKind:XMLTypeColors]];
    barBackground.alpha = 0.3;
    [self.view addSubview:barBackground];
    UIButton *backView = [[UIButton alloc] initWithFrame:CGRectMake(18, 20 + 4.5, 11 + 5 + 40, 35)];
    UIImageView *backImageView = [UIImageView createImageViewWithFrame:CGRectMake(0, (35-20)/2, 20, 20) ImageName:@"DL_light_ARROW"];
    backImageView.userInteractionEnabled = YES;
    [backView addSubview:backImageView];
//    UILabel *backLabel = [UILabel createLabelWithFrame:CGRectMake(11 + 5,(35-20)/2, 40, 20) Font:17 Text:@"返回" andLCR:0 andColor:[UIColor whiteColor]];
//    [backView addSubview:backLabel];
    backView.tag = 0;
    [backView addTarget:self action:@selector(actionBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backView];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)createTableView{
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    [self.view addSubview:tableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
    tableView.bounces = NO;
    __unsafe_unretained UITableView *tableView1 = self.tableView;
    
//    // 下拉刷新
//    tableView1.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self createData];
//        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
//        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        //            // 结束刷新
//        //
//        //        });
//    }];
//    
//    // 设置自动切换透明度(在导航栏下面自动隐藏)
//    tableView1.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    tableView1.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            [tableView1.mj_footer endRefreshing];
        });
    }];
    //[tableView1.mj_header beginRefreshing];
//    /* 初始化控件 */
//    _refresh = [[WJRefresh alloc]init];
    [self createData];
//    //self.needRefresh = YES;
//    __weak typeof(self)weakSelf = self;
//    [_refresh addHeardRefreshTo:tableView heardBlock:^{
//        //[weakSelf createData];
//    } footBlok:^{
//        [weakSelf createFootData];
//    }];
//    //[_refresh beginHeardRefresh];
}

- (void)createData{
    NSLog(@"-----------头部刷新数据-----------");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self downloadData];
    });
    
}

- (void)createFootData{
    NSLog(@"-----------尾部加载更多数据-----------");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    });
}

- (CellLayout *)layoutWithStatusModel:(StatusModel *)statusModel index:(NSInteger)index {
    //生成Storage容器
    statusModel.evaluate = nil;
    LWStorageContainer* container = [[LWStorageContainer alloc] init];
    //生成Layout
    CellLayout* layout = [[CellLayout alloc] initWithContainer:container
                                                   statusModel:statusModel
                                                         index:index
                                                 dateFormatter:nil isDynamicDe:NO];
    return layout;
}

//- (DynamicLayout *)layoutWithEvaluateModel:(EvaluateModel *)evaluateModel index:(NSInteger)index {
//    //生成Storage容器
//    LWStorageContainer* container = [[LWStorageContainer alloc] init];
//    //生成Layout
//    DynamicLayout* layout = [[DynamicLayout alloc]initWithContainer:container Model:evaluateModel dateFormatter:[self dateFormatter] index:index];
//    return layout;
//}



- (void)refreshBegin {
    [UIView animateWithDuration:0.2f animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(kRefreshBoundary, 0.0f, 0.0f, 0.0f);
    } completion:^(BOOL finished) {
        // [self.tableViewHeader refreshingAnimateBegin];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self downloadData];
        });
    }];
}

- (void)downloadData {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[HttpManager shareManager] netStatus:^(AFNetworkReachabilityStatus status) {
            if(status == AFNetworkReachabilityStatusReachableViaWWAN || status ==AFNetworkReachabilityStatusReachableViaWiFi){
                GetUserInfoModel *model = [[GetUserInfoModel alloc]init];
                model.access_token = [[LoginVM getInstance] readLocal].token;
                model.uid = self.user.uid;
                SendAndGetDataFromNet *sendAndget = [[SendAndGetDataFromNet alloc]init];
                __weak SendAndGetDataFromNet *wsend = sendAndget;
                __weak PersonalPresentVC *wself = self;
                sendAndget.returnDict = ^(NSDictionary *dict){
                    if ([dict objectForKey:@"state"]) {
                        wself.requestCount = 0;
                        NSDictionary *dataDict = [dict objectForKey:@"data"];
                        self.model = [PersonalModel mj_objectWithKeyValues:dataDict];
                        [self.fakeDatasource removeAllObjects];
                        self.dataSource = nil;
                        self.fakeDatasource = [[NSMutableArray alloc]initWithArray:self.model.dynamic_list];
                        NSLog(@"dataDict %@",dataDict);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self refreshComplete];
                        });
                    }else{
                        if (wself.requestCount > 1) {
                            [Toast makeShowCommen:@"您的网络有问题 " ShowHighlight:@"请重置" HowLong:0.8];
                            return ;
                        }
                        [LoginVM getInstance].isGetToken = ^(){
                            model.access_token = [[LoginVM getInstance] readLocal].token;
                            [wsend commenDataFromNet:model WithRelativePath:@"USER_INFO"];
                            wself.requestCount ++;
                        };
                        [[LoginVM getInstance] loginWithUserInfoForGetNewToken:[[LoginVM getInstance] readLocal]];                }
                };
                [sendAndget dictFromNet:model WithRelativePath:@"USER_INFO"];
            }else{
                [Toast makeShowCommen:@"您的网络有问题 " ShowHighlight:@"请重置" HowLong:0.8];
            }
        }];
    });
}

- (void)refreshComplete {
    //[self.tableViewHeader refreshingAnimateStop];
    [UIView animateWithDuration:0.35f animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    } completion:^(BOOL finished) {
        self.personalHeaderView = nil;
        [self.tableView reloadData];
        self.needRefresh = NO;
        [_refresh endRefresh];
    }];
}

-(void)actionBtn : (UIButton *) btn{
    if (self.fromDynamicDetailVC) {
        self.navigationController.navigationBar.hidden = NO;
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.fakeDatasource.count > 0) {
        return self.dataSource.count + 1;
    }
    return 1;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (0 == indexPath.row) {
        static NSString* cellIdentifier = @"perHeaderCellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]init];
            [cell.contentView addSubview:self.personalHeaderView];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    static NSString* cellIdentifier = @"perCellIdentifier";
    TableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    if (self.dataSource.count > indexPath.row - 1) {
        CellLayout* cellLayout = self.dataSource[indexPath.row - 1];
        cell.cellLayout = cellLayout;
    }
    return cell;
}

#pragma mark - Actions

- (void)tableViewCell:(TableViewCell *)cell didClickedImageWithCellLayout:(CellLayout *)layout atIndex:(NSInteger)index {
    
    NSMutableArray* tmp = [[NSMutableArray alloc] initWithCapacity:layout.imagePostionArray.count];
    for (NSInteger i = 0; i < layout.imagePostionArray.count; i ++) {
        
        LWImageBrowserModel *imageModel = [[LWImageBrowserModel alloc]initWithLocalImage:[LocalDataRW getImageWithDirectory:Directory_BQ RetalivePath:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:[layout.statusModel.images objectAtIndex:i]]] imageViewSuperView:cell.contentView positionAtSuperView:CGRectFromString(layout.imagePostionArray[i]) index:index];
        [tmp addObject:imageModel];
    }
    LWImageBrowser* imageBrowser = [[LWImageBrowser alloc] initWithParentViewController:self
                                                                                  style:LWImageBrowserAnimationStyleScale
                                                                            imageModels:tmp
                                                                           currentIndex:index];
    imageBrowser.view.backgroundColor = [UIColor blackColor];
    [imageBrowser show];
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (0 == indexPath.row) {
        return;
    }
    DynamicDetailVC *vc = [[DynamicDetailVC alloc]init];
    StatusModel *statusModel = [StatusModel mj_objectWithKeyValues:self.fakeDatasource[indexPath.row - 1]];
    vc.statusModel = statusModel;
    vc.pushFromPersonalVC = YES;
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)tableViewCell:(TableViewCell *)cell didClickedCommentWithCellLayout:(CellLayout *)layout
          atIndexPath:(NSIndexPath *)indexPath clinkType:(Clink_Type)clink_type{
    if (0 == indexPath.row) {
        return;
    }
    DynamicDetailVC *vc = [[DynamicDetailVC alloc]init];
    StatusModel *statusModel = [StatusModel mj_objectWithKeyValues:self.fakeDatasource[indexPath.row - 1]];
    vc.statusModel = statusModel;
    vc.pushFromPersonalVC = YES;
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

-(PersonalHeaderView *)personalHeaderView{
    if (_personalHeaderView) {
        return _personalHeaderView;
    }
    _personalHeaderView = [[PersonalHeaderView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH , 20 + 44 * 2 + 205)];
    if (!self.model) {
        self.model = [[PersonalModel alloc]init];
    }
    [_personalHeaderView initWithData:self.model];
    _personalHeaderView.btnAction = ^(NSInteger tag){
        NSLog(@"tag is %ld",tag);
    };
    return _personalHeaderView;
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"self.ActivityDataSource.count is %ld",self.dataSource.count);
    if (0 == indexPath.row) {
        return self.personalHeaderView.frame.size.height;
    }
    if (self.dataSource.count >= indexPath.row - 1) {
        CellLayout* layout = self.dataSource[indexPath.row - 1];
        return layout.cellHeight;
    }else{
        return 0;
    }
    
}

#pragma mark - Getter

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            for (int i = 0; i < self.fakeDatasource.count; i ++) {
                StatusModel* statusModel = [StatusModel mj_objectWithKeyValues:self.fakeDatasource[i]];
                LWLayout* layout = [self layoutWithStatusModel:statusModel index:i];
                [self.dataSource addObject:layout];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        });
    }
    
    return _dataSource;
}

-(NSMutableArray *)fakeDatasource{
    if (_fakeDatasource) {
        return _fakeDatasource;
    }
    _fakeDatasource = [[NSMutableArray alloc]init];
    return _fakeDatasource;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
//    if (path.row == self.dataSource.count - 1) {
//        self.tableView.bounces = YES;
//    }
    if (((int)scrollView.contentOffset.y) < 10) {
        self.tableView.bounces = NO;
    }else{
        self.tableView.bounces = YES;
    }
}



-(void)dealloc{
    
}

@end
