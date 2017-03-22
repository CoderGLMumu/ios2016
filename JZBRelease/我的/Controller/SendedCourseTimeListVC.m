//
//  SendedCourseTimeListVC.m
//  JZBRelease
//
//  Created by cl z on 16/9/14.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "SendedCourseTimeListVC.h"

#import "MJRefresh.h"
#import "HttpManager.h"
#import "GetCourseTimeListModel.h"
#import "Defaults.h"
#import "XBLiveVideoCell.h"
#import "CourseTimeModel.h"
#import "CourseTimeVC.h"
#import "AliVcMoiveViewController.h"
#import <AliyunPlayerSDK/AliVcMediaPlayer.h>
#import "AlivcLiveViewController.h"
#import <AlivcLiveVideo/AlivcLiveVideo.h>
#import "AskAnswerItem.h"

#import "LiveVideoViewController.h"
#import "XBLiveListItem.h"

@interface SendedCourseTimeListVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *courseAry;
    BOOL footerFresh;
    
    NSInteger pageNum;
}

@property(nonatomic,assign) NSInteger requestCount;
@property(nonatomic,strong) NSMutableArray *courseAry;
@end

@implementation SendedCourseTimeListVC

- (void)viewDidLoad {
    
    pageNum = 0;
    
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

    
   // [self configNav];

//    if (!self.isRootVCComing) {
//        [self configNav];
//    }else{
//        if (self.isMine) {
//            [self configNav];
//        }
//    }
    [self createTableView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
                GetCourseTimeListModel *model = [[GetCourseTimeListModel alloc]init];
                model.access_token = [[LoginVM getInstance] readLocal].token;
                model.id = @"0";
                model.course_id = @"0";
                if (footerFresh) {
                    pageNum++;
                    
                    if (self.isRootVCComing) {
                        model.type = @"3";
                        model.page = [NSString stringWithFormat:@"%ld",(long)pageNum];
                        model.course_id = @"0";
//                        if (self.isMine) {
//                            model.my = @"1";
//                        }else{
                            model.user_id = self.userID;
//                        }
                        model.t = self.liveType;
                        model.limit = @"20";
                    }
                    model.page = [NSString stringWithFormat:@"%ld",(long)pageNum];
                }else{
                    pageNum = 0;
                    model.page = [NSString stringWithFormat:@"%ld",(long)pageNum];
                }
                
                if (self.isYuGao) {
                 //   model.type = @"3";
                    model.user_id = self.userID;
                    model.course_id = @"0";
                    model.t = @"1";
                    model.limit = @"20";
                }
                
                if (self.isZhiBo) {
                  //  model.type = @"3";
                    model.user_id = self.userID;
                    model.course_id = @"0";
                    model.t = @"2";
                    model.limit = @"20";
                }
                
                if (self.isVideo) {
                    //model.type = @"3";
                    model.user_id = self.userID;
                    model.course_id = @"0";
                    model.t = @"3";
                    model.limit = @"20";
                }
                
                if (self.isRootVCComing) {
                    model.type = @"3";
//                    if (self.isMine) {
//                        model.my = @"1";
//                    }else{
                      model.user_id = self.userID;
                   // }
                    model.course_id = @"0";
                    model.t = self.liveType;
                    model.limit = @"20";
                }else {
                    //model.t = @"1";
//                    model.user_id = [[LoginVM getInstance]readLocal]._id;
//                    model.my = @"1";
                }
                
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
//                            NSInteger beginCount = self.courseAry.count - 1;
                            //[self.fakeDatasource insertObjects:ary atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(beginCount, ary.count)]];
                            
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
                            for (int i = 0; i < ary.count; i ++) {
                                CourseTimeModel *courseTimeModel = [CourseTimeModel mj_objectWithKeyValues:[ary objectAtIndex:i]];
                                if ([courseTimeModel isKindOfClass:[CourseTimeModel class]]) {
                                    if (courseTimeModel) {
                                        if (self.isYuGao) {
                                            if (([courseTimeModel.type isEqualToString:@"3"] || [courseTimeModel.type isEqualToString:@"4"]) && [courseTimeModel.label isEqualToString:@"直播预告"]) {
                                                [self.courseAry addObject:courseTimeModel];
                                            }
                                        }
                                        if (self.isZhiBo) {
                                            if (([courseTimeModel.type isEqualToString:@"3"] || [courseTimeModel.type isEqualToString:@"4"]) && [courseTimeModel.label isEqualToString:@"直播预告"]) {
                                                [self.courseAry addObject:courseTimeModel];
                                            }
                                        }
                                        if (self.isVideo) {
                                            if (([courseTimeModel.type isEqualToString:@"3"] || [courseTimeModel.type isEqualToString:@"4"]) && [courseTimeModel.label isEqualToString:@"直播预告"]) {
                                                [self.courseAry addObject:courseTimeModel];
                                            }
                                        }
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

- (XBLiveVideoCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"XBLiveVideoCell";
    XBLiveVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        UINib *nib = [UINib nibWithNibName:@"XBLiveVideoCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellID];
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    }
    if (self.courseAry.count > indexPath.row) {
        cell.courseTimeModel = [self.courseAry objectAtIndex:indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    //XBLiveVideoCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    CourseTimeModel *courseTimeModel;
    if (self.courseAry.count > indexPath.row) {
        
        courseTimeModel = [self.courseAry objectAtIndex:indexPath.row];
//        NSLog(@"%ld--%@",(long)indexPath.row,[self.courseAry objectAtIndex:indexPath.row]);
    }
    
    dispatch_async(dispatch_queue_create("", nil), ^{
        [[HttpManager shareManager] netStatus:^(AFNetworkReachabilityStatus status) {
            if(status == AFNetworkReachabilityStatusReachableViaWWAN || status ==AFNetworkReachabilityStatusReachableViaWiFi){
                GetCourseTimeListModel *model = [[GetCourseTimeListModel alloc]init];
                model.access_token = [[LoginVM getInstance] readLocal].token;
                model.id = courseTimeModel.id;
                
                if (footerFresh) {
                    
                }else{
                    model.page = @"0";
                }
                
                model.user_id = [[LoginVM getInstance]readLocal]._id;
                model.my = @"1";
                
                SendAndGetDataFromNet *send = [[SendAndGetDataFromNet alloc]init];
                __weak typeof (send) wsend = send;
                __weak typeof (self) wself = self;
                send.returnDict = ^(NSDictionary *dict){
                    if (!dict) {
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
                           // NSInteger beginCount = self.courseAry.count - 1;
                            //[self.fakeDatasource insertObjects:ary atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(beginCount, ary.count)]];
                            
                            footerFresh = NO;
                        }else{
                            if (!self.courseAry) {
                                self.courseAry = [[NSMutableArray alloc]init];
                            }
//                            [self.courseAry removeAllObjects];
                            
                            if (self.isRootVCComing) {
                                
                                CourseTimeModel *courseModel = [CourseTimeModel mj_objectWithKeyValues:dict[@"data"]];
                                
                                LiveVideoViewController *vc = [LiveVideoViewController new];
                                
                                    vc.item = courseModel;
                                
                                if (!vc.item) {
                                    [SVProgressHUD showInfoWithStatus:@"网络不顺畅"];
                                    return ;
                                }
                                
                                vc.hidesBottomBarWhenPushed = YES;
                                [self.navigationController pushViewController:vc animated:YES];
                                
                                
                            }else {
                                CourseTimeModel *courseTimeModel = [CourseTimeModel mj_objectWithKeyValues:dict[@"data"]];
                                if ([courseTimeModel isKindOfClass:[CourseTimeModel class]]) {
                                    if (courseTimeModel) {
                                        //                                        NSLog(@"gaolinTTT%@",courseTimeModel);
                                        NSString *str = courseTimeModel.push_path;
                                        
                                        if (![str containsString:@"rtmp://"]) {
                                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"推流地址格式错误，无法直播" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                            [alert show];
                                            return;
                                        }
                                        
                                        AlivcLiveViewController *live = [[AlivcLiveViewController alloc] initWithNibName:@"AlivcLiveViewController" bundle:nil url:str];
                                        live.isScreenHorizontal = NO;
                                        
                                        live.question = [AskAnswerItem mj_objectArrayWithKeyValuesArray:courseTimeModel.question];
                                        live.class_id = courseTimeModel.id;
                                        live.teacher = courseTimeModel.teacher;
                                        live.join_list_user = courseTimeModel.join_list;
                                        live.start_time = courseTimeModel.start_time;
                                        live.end_time = courseTimeModel.end_time;
                                        
                                        [self presentViewController:live animated:YES completion:nil];
                                    }
                                }
                              }
                            
                            
                            }
                            
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self refreshComplete];
                            
                        });
                    
                };
                [send dictFromNet:model WithRelativePath:@"Get_CourseTime_List_URL"];
                
            }else{
                [Toast makeShowCommen:@"您的网络有问题 " ShowHighlight:@"请重置" HowLong:1.2];
            }
        }];
    });

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 276;
}


@end
