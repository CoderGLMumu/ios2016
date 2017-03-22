//
//  XBPointVideoVC.m
//  JZBRelease
//
//  Created by zjapple on 16/9/9.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "XBPointVideoVC.h"
#import "MJRefresh.h"
#import "SDCycleScrollView.h"
#import "SelecterToolsScrolView.h"
#import "Defaults.h"
#import "GetCourseTimeListModel.h"
#import "CourseTimeModel.h"
#import "XBLiveVideoCell.h"
#import "CusGroupBtnView.h"
#import "XBCourseTimeListVC.h"
#import "LiveVideoDetailItem.h"
#import "LiveVideoViewController.h"
#import "CusSearchView.h"
#import "AppDelegate.h"
#import "XBOffLiveVideoShowVC.h"
#import "XBXXCell.h"

//=======
#import "XBSearchVC.h"
#import "XBNearCourseOrProjectVC.h"
//>>>>>>> .r976
@interface XBPointVideoVC ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>{
    NSInteger cusSelector;
    NSInteger preSelector;
    BOOL footerFresh;
    NSInteger footerCount;
}

@property (nonatomic, strong) SelecterToolsScrolView *selecterToolsScrolView;
@property (nonatomic, strong) SDCycleScrollView *sdCycleScrollView;
@property (nonatomic, strong) NSMutableArray *dataAry,*cusDataAry,*courseAry,*imageAry,*cycleCourseTimeAry,*cycleImageAry,*cycleTitleAry;
@property (nonatomic, assign) NSInteger requestCount;
@property (nonatomic, strong) CusGroupBtnView *cusGroupBtnView;
@property (nonatomic, strong) CusSearchView *cusSearchView;
@property (nonatomic, strong) UIView *nearView;
@end

@implementation XBPointVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
    [self.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49)];
    self.automaticallyAdjustsScrollViewInsets = NO;
    footerCount = 0;
    [self createTableView];
    self.cusDataAry = [[NSMutableArray alloc]initWithArray:@[@"建众",@"行业",@"跨行"]];
    self.imageAry = [[NSMutableArray alloc]initWithArray:@[@"DB_JZ",@"DB_HY",@"DB_KH"]];
}


- (SDCycleScrollView *)sdCycleScrollView{
    if (!_sdCycleScrollView) {
        // 网络加载 --- 创建带标题的图片轮播器
        _sdCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150) delegate:self placeholderImage:[UIImage imageNamed:@"WD_bannerPIC"]];
        
        _sdCycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _sdCycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
        __weak typeof (self) wself = self;
        _sdCycleScrollView.clickItemOperationBlock = ^(NSInteger index) {
            
//            AppDelegate *delegate = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
//            if (!delegate.checkpay) {
//                XBOffLiveVideoShowVC *mobilevideoShowVC = [[XBOffLiveVideoShowVC alloc] init];
//                mobilevideoShowVC.videoURL = [NSURL URLWithString:@"http://bang.jianzhongbang.com/1.mp4"];
//                [[ZJBHelp getInstance].studyBaRootVC presentViewController:mobilevideoShowVC animated:YES completion:nil];
//                return ;
//            }
            
            //跳转
            LiveVideoViewController *vc = [LiveVideoViewController new];
            
            CourseTimeModel *item = wself.cycleCourseTimeAry[index];
            
            vc.item = item;
            vc.isBackVideo = YES;
            
            if (!vc.item) {
                [SVProgressHUD showInfoWithStatus:@"网络不顺畅"];
                return ;
            }
            
            vc.hidesBottomBarWhenPushed = YES;
            [wself.navigationController pushViewController:vc animated:YES];
            
        };
        [self downloadDataForCycle];
    }
    return _sdCycleScrollView;
}

- (void)downloadDataForCycle{
    dispatch_async(dispatch_queue_create("", nil), ^{
        [[HttpManager shareManager] netStatus:^(AFNetworkReachabilityStatus status) {
            if(status == AFNetworkReachabilityStatusReachableViaWWAN || status ==AFNetworkReachabilityStatusReachableViaWiFi){
                GetCourseTimeListModel *model = [[GetCourseTimeListModel alloc]init];
                model.access_token = [[LoginVM getInstance] readLocal].token;
                model.id = @"0";
                model.type = @"5";
                model.course_id = @"0";
                model.position = @"1";
                
                
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
                        if (!self.cycleCourseTimeAry) {
                            self.cycleCourseTimeAry = [[NSMutableArray alloc]init];
                        }
                        if (!self.cycleImageAry) {
                            self.cycleImageAry = [[NSMutableArray alloc]init];
                        }
                        if (!self.cycleTitleAry) {
                            self.cycleTitleAry = [[NSMutableArray alloc]init];
                        }
                        for (int i = 0; i < ary.count; i ++) {
                            CourseTimeModel *courseTimeModel = [CourseTimeModel mj_objectWithKeyValues:[ary objectAtIndex:i]];
                            if ([courseTimeModel isKindOfClass:[CourseTimeModel class]]) {
                                if (courseTimeModel) {
                                    [self.cycleCourseTimeAry addObject:courseTimeModel];
                                }
                            }
                            NSString *path = courseTimeModel.thumb2;
                            if (!path) {
                                path = @"WD_bannerPIC";
                            }
                            [self.cycleImageAry addObject:path];
                            if (courseTimeModel.title) {
                                [self.cycleTitleAry addObject:courseTimeModel.title];
                            }else{
                                [self.cycleTitleAry addObject:@" "];
                            }
                        }
                        
                        self.sdCycleScrollView.imageURLStringsGroup = self.cycleImageAry;
                        self.sdCycleScrollView.titlesGroup = self.cycleTitleAry;
                    }
                };
                [send dictDataFromNet:model WithRelativePath:@"Get_CourseTime_List_URL"];
                
            }else{
                [Toast makeShowCommen:@"您的网络有问题 " ShowHighlight:@"请重置" HowLong:1.2];
            }
        }];
    });
}


- (void)addBtnAction{
//    YZSortViewController *yzVC = [[YZSortViewController alloc]init];
//    yzVC.focusedAry = self.cusDataAry;
//    yzVC.returnData = ^(NSMutableArray *dataAry){
//        self.cusDataAry = dataAry;
//        [self.cusAORView removeFromSuperview];
//        self.cusAORView = nil;
//        self.cusAORView = [CusAddOrReduceBtnView cusAddOrReduceBtnView:self.cusDataAry];
//        [self.cusAORView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
//        [self.cusAORView initAllViews];
//        __weak typeof (self) wself = self;
//        self.cusAORView.returnBlock = ^(NSInteger tag){
//            cusSelector = tag;
//            [wself.tableView reloadData];
//        };
//        [self.cusAORView.addBtn addTarget:self action:@selector(addBtnAction) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:self.cusAORView];
//    };
    [ZJBHelp getInstance].bbRootVC.tabBarController.tabBar.hidden = YES;
    //[[ZJBHelp getInstance].bbRootVC.navigationController pushViewController:yzVC animated:YES];
}

- (void)createTableView{
    NSLog(@"self.view.frame.size.height %f",self.view.frame.size.height);
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f2f2f2"];
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    __unsafe_unretained UITableView *tableView1 = self.tableView;
    
    // 下拉刷新
    tableView1.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        footerFresh = NO;
        [self createData];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView1.mj_header.automaticallyChangeAlpha = YES;
    
//    // 上拉刷新
//    tableView1.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
//        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        //            // 结束刷新
//        //            [tableView1.mj_footer endRefreshing];
//        //        });
//        footerFresh = YES;
//        [self createFootData];
//    }];
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

        [self downloadData];
        
    });
}

- (void)downloadData {
    dispatch_async(dispatch_queue_create("", nil), ^{
        [[HttpManager shareManager] netStatus:^(AFNetworkReachabilityStatus status) {
            if(status == AFNetworkReachabilityStatusReachableViaWWAN || status ==AFNetworkReachabilityStatusReachableViaWiFi){
                GetCourseTimeListModel *model = [[GetCourseTimeListModel alloc]init];
                model.access_token = [[LoginVM getInstance] readLocal].token;
                model.id = @"0";
                model.type = @"5";
                model.course_id = @"0";
                
                if (footerFresh) {
                    footerCount++;
                    model.page = [NSString stringWithFormat:@"%ld",footerCount];
                }else{
                    model.page = @"0";
                }
                model.limit = @"10";
                
                
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
                                    if (courseTimeModel) {
                                        [self.courseAry addObject:courseTimeModel];
                                    }
                                }
                            }
                        }else{
                            if (!self.courseAry) {
                                self.courseAry = [[NSMutableArray alloc]init];
                            }
                            [self.courseAry removeAllObjects];
                            footerCount = 0;
                            for (int i = 0; i < ary.count; i ++) {
                                CourseTimeModel *courseTimeModel = [CourseTimeModel mj_objectWithKeyValues:[ary objectAtIndex:i]];
                                if ([courseTimeModel isKindOfClass:[CourseTimeModel class]]) {
                                    if (courseTimeModel) {
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


- (void)refreshBegin {
    [UIView animateWithDuration:0.2f animations:^{
        //self.tableView.contentInset = UIEdgeInsetsMake(kRefreshBoundary, 0.0f, 0.0f, 0.0f);
    } completion:^(BOOL finished) {
        // [self.tableViewHeader refreshingAnimateBegin];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self downloadData];
        });
    }];
}


- (void)refreshComplete {
    //[self.tableViewHeader refreshingAnimateStop];
    [UIView animateWithDuration:0.35f animations:^{
        //self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
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
    return self.courseAry.count + 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

        if (indexPath.row == 0) {
            static NSString* cuscellIdentifier = @"CusFirstCellIdentifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cuscellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cuscellIdentifier];
                [cell.contentView addSubview:self.sdCycleScrollView];
            }
            [cell setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.row == 1){
            static NSString* cuscellIdentifier = @"CusTwoCellIdentifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cuscellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cuscellIdentifier];
                [cell.contentView addSubview:self.nearView];
            }
            [cell setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.row == 2){
            static NSString* cuscellIdentifier = @"CusThreeCellIdentifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cuscellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cuscellIdentifier];
                [cell.contentView addSubview:self.cusSearchView];
            }
            [cell setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;

        }else{
            static NSString *cellID = @"XBXXCell";
            XBXXCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                UINib *nib = [UINib nibWithNibName:@"XBXXCell" bundle:nil];
                [tableView registerNib:nib forCellReuseIdentifier:cellID];
                cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            }
            if (self.courseAry.count > indexPath.row - 3) {
                cell.courseTimeModel = [self.courseAry objectAtIndex:indexPath.row - 3];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
}

- (UIView *)cusSearchView{
    if (!_cusSearchView) {
        _cusSearchView = [[CusSearchView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 58)];
        __weak typeof (self) wself = self;
        [_cusSearchView setLabelText:@"请输入你要搜索的课程、内容、项目"];
        _cusSearchView.returnAction = ^(NSInteger tag){
            XBSearchVC *xbSearch = [[XBSearchVC alloc]init];
            [wself.navigationController pushViewController:xbSearch animated:YES];
        };
    }
    return _cusSearchView;
}

- (UIView *)nearView{
    if (!_nearView) {
        _nearView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        [_nearView setBackgroundColor:[UIColor whiteColor]];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 12, 20, 20)];
        [_nearView addSubview:imageView];
        [imageView setImage:[UIImage imageNamed:@"XB_XX_FJ"]];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(52, 0, 100, 44)];
        [label setFont:[UIFont systemFontOfSize:14]];
        [label setTextColor:[UIColor hx_colorWithHexRGBAString:@"757575"]];
        [label setText:@"附近"];
        [_nearView addSubview:label];
        
        UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 29, (44 - 15) / 2, 9, 15)];
        [_nearView addSubview:imageView1];
        [imageView1 setImage:[UIImage imageNamed:@"XB_XX_arrow"]];
    }
    return _nearView;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (0 == cusSelector) {
//        if (indexPath.row == 0) {
//            return;
//        }else{
//                        return;
//        }
//    }
    if (indexPath.row == 0) {
        
    }else if (indexPath.row == 1){
        XBNearCourseOrProjectVC *vc = [[XBNearCourseOrProjectVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2){
        
    }else{
        LiveVideoViewController *vc = [LiveVideoViewController new];
        
        vc.isLineDown = YES;
        
        CourseTimeModel *item = self.courseAry[indexPath.row - 3];
        
        vc.item = item;
        if (!vc.item) {
            [SVProgressHUD showInfoWithStatus:@"网络不顺畅"];
            return ;
        }
        
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        return 150;
    }else if (1 == indexPath.row){
        return 44;
    }else if (2 == indexPath.row){
        return 58;
    }else{
        return 280 - 37;
    }
}


- (CusGroupBtnView *)cusGroupBtnView{
    if (!_cusGroupBtnView) {
        _cusGroupBtnView = [[CusGroupBtnView alloc]initWithSeleterConditionTitleArr:self.cusDataAry WithImageAry:self.imageAry WithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
        __weak typeof (self) wself = self;
        _cusGroupBtnView.returnAction = ^(NSInteger tag){
            XBCourseTimeListVC *vc = [[XBCourseTimeListVC alloc]init];
            vc.tag = tag;
            [wself.navigationController pushViewController:vc animated:YES];
        }; 
    }
    
    return _cusGroupBtnView;
}

-(NSMutableArray *)dataAry{
    if (_dataAry) {
        return _dataAry;
    }
    _dataAry = [[NSMutableArray alloc]init];
    return _dataAry;
}




@end
