//
//  PerActivityVC.m
//  JZBRelease
//
//  Created by cl z on 16/8/10.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "PerActivityVC.h"
#import "MJRefresh.h"
#import "Defaults.h"
#import "GetActivityListModel.h"
#import "ActivityModel.h"
#import "BBActivityCell.h"
#import "ActivityLayout.h"
#import "TableViewCell.h"
#import "BBActivityDetailVC.h"
//#import "OtherPersonCentralVC.h"
#import "PublicOtherPersonVC.h"
#import "GLNAVC.h"

@interface PerActivityVC ()<UITableViewDelegate,UITableViewDataSource,TableViewCellDelegate>
@property (nonatomic, strong) NSMutableArray *dataAry;
@property (nonatomic, assign) CGFloat kRefreshBoundary;
@property (nonatomic, assign,getter = isNeedRefresh) BOOL needRefresh;
@property(nonatomic, strong) UISegmentedControl *segment;

@end

@implementation PerActivityVC
@synthesize kRefreshBoundary;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    kRefreshBoundary = 40.0f;
    [self createTableView];
//    [self configNav];
    self.segment = [[UISegmentedControl alloc]initWithItems:@[@"发布",@"参与"]];
    self.segment.frame = CGRectMake(0, 0, 120, 28);
    self.segment.selectedSegmentIndex = 0;
    self.segment.tintColor= [UIColor whiteColor];
    [self.segment addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segment;


}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    GLLog(@"%@",self.navigationController);
    if ([self.navigationController isKindOfClass:[GLNAVC class]]) {
        
    }else {
        [self configNav];
    }
}

-(void)configNav
{
    //11 20
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11 + 5 + 40, 35)];
    UIImageView *backImageView = [UIImageView createImageViewWithFrame:CGRectMake(0, (35-20)/2, 20, 20) ImageName:@"DL_light_ARROW"];
    backImageView.userInteractionEnabled = YES;
    [backView addSubview:backImageView];
//    UILabel *backLabel = [UILabel createLabelWithFrame:CGRectMake(11 + 5,(35-20)/2, 40, 20) Font:17 Text:@"返回" andLCR:0 andColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]]];
//    [backView addSubview:backLabel];
    UIControl *back = [[UIControl alloc] initWithFrame:backView.bounds];
    [back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:back];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
}

-(void) backAction{
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
    //self.tabBarController.tabBar.hidden = NO;
}

- (void)createTableView{
    NSLog(@"self.view.frame.size.height %f",self.view.frame.size.height);
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Inteval_Color" WithKind:XMLTypeColors]];
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    __unsafe_unretained UITableView *tableView1 = self.tableView;
    
    // 下拉刷新
    tableView1.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self createData];
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //            // 结束刷新
        //
        //        });
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView1.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    tableView1.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            [tableView1.mj_footer endRefreshing];
        });
    }];
    [tableView1.mj_header beginRefreshing];
    //    /* 初始化控件 */
    //    _refresh = [[WJRefresh alloc]init];
    //    //self.needRefresh = YES;
    //    __weak typeof(self)weakSelf = self;
    //    [_refresh addHeardRefreshTo:tableView heardBlock:^{
    //        [weakSelf createData];
    //    } footBlok:^{
    //        [weakSelf createFootData];
    //    }];
    //    [_refresh beginHeardRefresh];
}

- (void)createData{
    NSLog(@"-----------头部刷新数据-----------");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self downloadData];
    });
    
}

-(void) segmentChange:(UISegmentedControl *) segment{
    
    if (segment.selectedSegmentIndex == 1) {
        if (!self.dataAry) {
            [self.tableView.mj_header beginRefreshing];
            return;
        }
    }
    [self.tableView reloadData];
}

- (void)createFootData{
    NSLog(@"-----------尾部加载更多数据-----------");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //        for (int i = 200; i < 210; i ++) {
        //            [self.dataSource addObject:[NSString stringWithFormat:@"%d",i]];
        //        }
        [self.tableView reloadData];
        //[_refresh endRefresh];
    });
}

-(NSMutableArray *)cellWithDataAry:(NSArray *) dataAry{
    NSMutableArray *ary = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < dataAry.count ; i ++) {
        ActivityModel *model = [dataAry objectAtIndex:i];
        ActivityLayout *layout = [self layoutWithDetailListModel:model index:i];
        if (layout) {
            [ary addObject:layout];
        }
    }
    
    return ary;
}

- (ActivityLayout *)layoutWithDetailListModel:(ActivityModel *)activityModel index:(NSInteger)index{
    //生成Storage容器
    LWStorageContainer* container = [[LWStorageContainer alloc] init];
    //生成Layout
    ActivityLayout* layout = [[ActivityLayout alloc]initWithContainer:container Model:activityModel dateFormatter:[self dateFormatter] index:index];
    return layout;
}

- (NSDateFormatter *)dateFormatter {
    static NSDateFormatter* dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM月dd日 hh:mm"];
    });
    return dateFormatter;
}

- (void)downloadData {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[HttpManager shareManager] netStatus:^(AFNetworkReachabilityStatus status) {
            if(status == AFNetworkReachabilityStatusReachableViaWWAN || status ==AFNetworkReachabilityStatusReachableViaWiFi){
                GetActivityListModel *model = [[GetActivityListModel alloc]init];
                model.access_token = [[LoginVM getInstance] readLocal].token;
                model.id = @"0";
                model.pid = @"";
                model.user_id = self.user.uid;
                
                SendAndGetDataFromNet *sendAndget = [[SendAndGetDataFromNet alloc]init];
                __block SendAndGetDataFromNet *wsend = sendAndget;
                sendAndget.returnDict = ^(NSDictionary *dict){
                    if (1 == [[dict objectForKey:@"state"] intValue]) {
                        NSArray *ary = [dict objectForKey:@"data"];
                        NSMutableArray *modelAry = [[NSMutableArray alloc]init];
                        for (int i = 0; i < ary.count; i ++) {
                            ActivityModel *activityModel = [ActivityModel mj_objectWithKeyValues:[ary objectAtIndex:i]];
                            if ([activityModel isKindOfClass:[ActivityModel class]]) {
                                [modelAry addObject:activityModel];
                            }
                        }
                        if (self.dataAry) {
                            [self.dataAry removeAllObjects];
                        }
                        self.dataAry = [self cellWithDataAry:modelAry];
                        NSLog(@"%@",ary);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self refreshComplete];
                        });
                    }else{
                        [LoginVM getInstance].isGetToken = ^(){
                            model.access_token = [[LoginVM getInstance] readLocal].token;
                            [wsend dictFromNet:model WithRelativePath:@"Get_ActivityList"];
                        };
                        [[LoginVM getInstance] loginWithUserInfoForGetNewToken:[[LoginVM getInstance] readLocal]];
                    }
                    
                    
                };
                [sendAndget dictFromNet:model WithRelativePath:@"Get_ActivityList"];
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
        [self.tableView reloadData];
        self.needRefresh = NO;
        [self.tableView.mj_header endRefreshing];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    /** 全部列表页面的空数据占位图片 */
    notDataShowView *view;
    
    if (self.dataAry.count) {
        if ([notDataShowView sharenotDataShowView].superview) {
            [[notDataShowView sharenotDataShowView] removeFromSuperview];
        }
    }else {
        view = [notDataShowView sharenotDataShowView:tableView];
        [tableView addSubview:view];
        
    }
    
    return self.dataAry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifier = @"cellIdentifier";
    BBActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[BBActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (self.dataAry.count > indexPath.row) {
        ActivityLayout* cellLayouts = self.dataAry[indexPath.row];
        cell.cellLayout = cellLayouts;
    }
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ActivityLayout *layout = [self.dataAry objectAtIndex:indexPath.row];
    ActivityModel *model = layout.activityModel;
    BBActivityDetailVC *vc = [[BBActivityDetailVC alloc]init];
    vc.fromPerson = YES;
    vc.activity_id = model.activity_id;
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataAry.count > indexPath.row) {
        ActivityLayout *layout = self.dataAry[indexPath.row];
        return layout.cellHeight;
    }
    return 0;
}


- (void)tableViewCell:(UITableViewCell *)cell didClickedLinkWithData:(id)data clinkType:(Clink_Type)clink_type{
    if (clink_type == Clink_Type_One) {
        ActivityModel *model = ((BBActivityCell *)cell).cellLayout.activityModel;
//        OtherPersonCentralVC *vc = [[OtherPersonCentralVC alloc]init];
        PublicOtherPersonVC *vc = [[UIStoryboard storyboardWithName:@"PublicOtherPersonVC" bundle:nil]instantiateInitialViewController];
        
        vc.user = model.user;
        
        if ([vc.user.uid isEqualToString:[LoginVM getInstance].readLocal._id] || vc.user.uid == nil) {
            return ;
        }
        
        self.navigationController.navigationBar.hidden = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)tableViewCell:(TableViewCell *)cell didClickedCommentWithCellLayout:(CellLayout *)layout
          atIndexPath:(NSIndexPath *)indexPath clinkType:(Clink_Type)clink_type{
    if (clink_type == Clink_Type_One) {
        ActivityModel *model = ((BBActivityCell *)cell).cellLayout.activityModel;
//        OtherPersonCentralVC *vc = [[OtherPersonCentralVC alloc]init];
        
        PublicOtherPersonVC *vc = [[UIStoryboard storyboardWithName:@"PublicOtherPersonVC" bundle:nil]instantiateInitialViewController];
        
        vc.user = model.user;
        
        if ([vc.user.uid isEqualToString:[LoginVM getInstance].readLocal._id] || vc.user.uid == nil) {
            return ;
        }
        
        self.navigationController.navigationBar.hidden = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (clink_type == Clink_Type_Two){
        ActivityLayout *layout = [self.dataAry objectAtIndex:indexPath.row];
        ActivityModel *model = layout.activityModel;
        BBActivityDetailVC *vc = [[BBActivityDetailVC alloc]init];
        vc.fromPerson = YES;
        vc.activity_id = model.activity_id;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

-(NSMutableArray *)dataAry{
    if (_dataAry) {
        return _dataAry;
    }
    _dataAry = [[NSMutableArray alloc]init];
    return _dataAry;
}

@end
