//
//  PlayBackVideoVC.m
//  JZBRelease
//
//  Created by cl z on 16/9/21.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "PlayBackVideoCourseVC.h"
#import "MJRefresh.h"
#import "HttpManager.h"
#import "GetCourseListModel.h"
#import "Defaults.h"
#import "XBLiveVideoCell.h"
#import "CourseModel.h"
#import "SendedCourseTimeListVC.h"
#import "SerialsCourseVC.h"
#import "PlayBackVideoCourseTimeListVC.h"
#import "VideoDetailXGKCCell.h"
#import "XBLiveMobileVideoShowVC.h"
#import "LiveVideoViewController.h"
@interface PlayBackVideoCourseVC ()<UITableViewDelegate,UITableViewDataSource>{
   // NSMutableArray *courseAry;
    BOOL footerFresh;
    NSInteger footerCount;
}

@property(nonatomic,assign) NSInteger requestCount;
@property(nonatomic,strong) NSMutableArray *courseAry;
@end

@implementation PlayBackVideoCourseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"课程列表";
//    [self configNav];
    

//    [self setupNavbutton];

    
    [self createTableView];
}
#pragma mark - viewWillAppear设置 导航条出现

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    GLLog(@"%@",self.navigationController);
    if ([self.navigationController isKindOfClass:[GLNAVC class]]) {
        
    }else {
        [self leftconfigNav];
    }
}

-(void)leftconfigNav
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

-(void)backAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

/** 设置Nav返回按钮 */
- (void)setupNavbutton
{
    UIButton *backBtn = [UIButton createButtonWithFrame:CGRectMake(15, 28, 25, 25) FImageName:@"XB_FL_back" Target:self Action:@selector(backAction) Title:nil];
    backBtn.contentMode = UIViewContentModeCenter;
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
}

//- (void) backAction{
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
-(void)configNav
{
    UIButton *sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 35, 28)];
    [sendBtn setImage:[UIImage imageNamed:@"BQ_DT_release"] forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(addCourse) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    UIBarButtonItem *sendBarBtn = [[UIBarButtonItem alloc]initWithCustomView:sendBtn];
    self.navigationItem.rightBarButtonItem = sendBarBtn;
    
}

- (void)addCourse{
    SerialsCourseVC *vc = [[SerialsCourseVC alloc]init];
    __weak typeof (self) wself = self;
    vc.returnAction = ^(){
        [wself.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)createTableView{
    NSLog(@"self.view.frame.size.height %f",self.view.frame.size.height);
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f2f2f2"];
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    __unsafe_unretained UITableView *tableView1 = self.tableView;
    
    // 下拉刷新
    tableView1.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self createData];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView1.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    tableView1.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //            // 结束刷新
        //            [tableView1.mj_footer endRefreshing];
        //        });
        footerFresh = YES;
        [self createFootData];
    }];
    [tableView1.mj_header beginRefreshing];
}

- (void)createData{
    NSLog(@"-----------头部刷新数据-----------");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self downloadData];
    });
    
}

- (void)createFootData{
    NSLog(@"-----------尾部加载更多数据-----------");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //        for (int i = 200; i < 210; i ++) {
        //            [self.dataSource addObject:[NSString stringWithFormat:@"%d",i]];
        //        }
        [self downloadData];
        //        [_refresh endRefresh];
    });
}

- (void)downloadData {
    dispatch_async(dispatch_queue_create("", nil), ^{
        [[HttpManager shareManager] netStatus:^(AFNetworkReachabilityStatus status) {
            if(status == AFNetworkReachabilityStatusReachableViaWWAN || status ==AFNetworkReachabilityStatusReachableViaWiFi){
                GetCourseListModel *model = [[GetCourseListModel alloc]init];
                model.access_token = [[LoginVM getInstance] readLocal].token;
                model.id = @"0";
                if (footerFresh) {
                    footerCount++;
                    model.page = [NSString stringWithFormat:@"%ld",footerCount];
                }else{
                    model.page = @"0";
                }
                model.user_id = self.user.uid;
                model.my = @"1";
                model.limit = @"20";
                
                SendAndGetDataFromNet *send = [[SendAndGetDataFromNet alloc]init];
                __block typeof (send) wsend = send;
                __weak typeof (self) wself = self;
                send.returnArray = ^(NSArray *ary){
                    if (!ary) {
                        if (wself.requestCount > 1) {
                            [wself refreshComplete];
                            [Toast makeShowCommen:@"您的网络有问题 " ShowHighlight:@"请重置" HowLong:0.8];
                            return ;
                        }
                        [LoginVM getInstance].isGetToken = ^(){
                            model.access_token = [[LoginVM getInstance] readLocal].token;
                            [wsend commenDataFromNet:model WithRelativePath:@"Get_CourseTime_List_URL"];
                            wself.requestCount ++;
                        };
                        [[LoginVM getInstance] loginWithUserInfoForGetNewToken:[[LoginVM getInstance] readLocal]];
                        
                    }else{
                        wself.requestCount = 0;
                        
                        if (footerFresh) {
                            for (int i = 0; i < ary.count; i ++) {
                                CourseTimeModel *courseTimeModel = [CourseTimeModel mj_objectWithKeyValues:[ary objectAtIndex:i]];
                                if ([courseTimeModel isKindOfClass:[CourseTimeModel class]]) {
                                    if ([courseTimeModel.type isEqualToString:@"1"] || [courseTimeModel.type isEqualToString:@"2"]) {
                                        [self.courseAry addObject:courseTimeModel];
                                        
                                    }
                                }
                            }   
                            footerFresh = NO;
                        }else{
                            if (!self.courseAry) {
                                self.courseAry = [[NSMutableArray alloc]init];
                            }
                            [self.courseAry removeAllObjects];
                            for (int i = 0; i < ary.count; i ++) {
                                CourseTimeModel *courseTimeModel = [CourseTimeModel mj_objectWithKeyValues:[ary objectAtIndex:i]];
                                if ([courseTimeModel isKindOfClass:[CourseTimeModel class]]) {
                                    if ([courseTimeModel.type isEqualToString:@"1"] || [courseTimeModel.type isEqualToString:@"2"]) {
                                        [self.courseAry addObject:courseTimeModel];

                                    }
                                }
                            }
                            
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self refreshComplete];
                            
                        });
                    }
                };
                [send dictDataFromNet:model WithRelativePath:@"Get_CourseTime_List_URL"];
                
            }else{
                [Toast makeShowCommen:@"您的网络有问题 " ShowHighlight:@"请重置" HowLong:1.2];
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
        
        if (footerFresh) {
            footerFresh = NO;
            [self.tableView.mj_footer endRefreshing];
        }else{
            [self.tableView.mj_header endRefreshing];
        }
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.courseAry) {
        
        /** 全部列表页面的空数据占位图片 */
        notDataShowView *view;
        
        if (self.courseAry.count) {
            if ([notDataShowView sharenotDataShowView].superview) {
                [[notDataShowView sharenotDataShowView] removeFromSuperview];
            }
        }else {
            view = [notDataShowView sharenotDataShowView:tableView];
            [tableView addSubview:view];
            
        }
        
        return self.courseAry.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"VideoDetailXGKCCell";
    VideoDetailXGKCCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        UINib *nib = [UINib nibWithNibName:@"VideoDetailXGKCCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellID];
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    }
    if (self.courseAry.count > indexPath.row) {
        cell.item = [self.courseAry objectAtIndex:indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    AppDelegate *delegate = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
//    if (!delegate.checkpay) {
//        XBLiveMobileVideoShowVC *mobilevideoShowVC = [[XBLiveMobileVideoShowVC alloc] init];
//        
//        mobilevideoShowVC.playUrl = @"http://bang.jianzhongbang.com/1.mp4";
//        
//        [[ZJBHelp getInstance].studyBaRootVC presentViewController:mobilevideoShowVC animated:YES completion:nil];
//        return ;
//    }
    
    LiveVideoViewController *vc = [LiveVideoViewController new];
    
    CourseTimeModel *item = self.courseAry[indexPath.row];
    
    vc.item = item;
    vc.isBackVideo = YES;
    
    if (!vc.item) {
        [SVProgressHUD showInfoWithStatus:@"网络不顺畅"];
        return ;
    }
    
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 119;
}


@end
