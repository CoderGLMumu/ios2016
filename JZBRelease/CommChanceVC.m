//
//  CommChanceVC.m
//  JZBRelease
//
//  Created by zcl on 2016/10/8.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "CommChanceVC.h"
#import "Defaults.h"
#import "MJRefresh.h"
#import "CommerChanceModel.h"
#import "CommerChanceCellModel.h"
#import "CommerChanceCell.h"
#import "CusSearchView.h"
#import "BBActivityDetailVC.h"
#import "MoreCommerChanceVC.h"
#import "BBActivitySearchVC.h"

#import "ApplyVipVC.h"
#import "BCH_Alert.h"

@interface CommChanceVC ()<UITableViewDelegate,UITableViewDataSource>{
    BOOL footerFresh;
    NSInteger footerCount;
}
@property(nonatomic, strong) NSMutableArray *dataAry;
@property (nonatomic, strong) CusSearchView *cusSearchView;
@end

@implementation CommChanceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    kRefreshBoundary = 40.0f;
    [self createTableView];
    
    self.title = @"帮吧商机";
    
}

#pragma mark - viewWillAppear设置 导航条出现
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (UIView *)cusSearchView{
    if (!_cusSearchView) {
        _cusSearchView = [[CusSearchView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 58)];
        [_cusSearchView setLabelText:@"查找商机"];
//        __weak typeof ([ZJBHelp getInstance].bbRootVC) wself = [ZJBHelp getInstance].bbRootVC;
        __weak typeof(self) wself = self;
        _cusSearchView.returnAction = ^(NSInteger tag){
            BBActivitySearchVC *vc = [[BBActivitySearchVC alloc]init];
            [wself.navigationController pushViewController:vc animated:YES];
        };
    }
    return _cusSearchView;
}

- (void)createTableView{
    NSLog(@"self.view.frame.size.height %f",self.view.frame.size.height);
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor whiteColor];
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
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //            // 结束刷新
        //            [tableView1.mj_footer endRefreshing];
        //        });
        [self createFootData];
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
        footerFresh = NO;
        [self downloadData];
    });
    
}

- (void)createFootData{
    NSLog(@"-----------尾部加载更多数据-----------");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //        for (int i = 200; i < 210; i ++) {
        //            [self.dataSource addObject:[NSString stringWithFormat:@"%d",i]];
        //        }
        footerFresh = YES;
        [self downloadData];
        //[_refresh endRefresh];
    });
}

- (void)refreshBegin {
    [UIView animateWithDuration:0.2f animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0.0f, 0.0f, 0.0f);
    } completion:^(BOOL finished) {
        // [self.tableViewHeader refreshingAnimateBegin];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self downloadData];
        });
    }];
}


- (void)downloadData {
    
    [[HttpManager shareManager] netStatus:^(AFNetworkReachabilityStatus status) {
        if(status == AFNetworkReachabilityStatusReachableViaWWAN || status ==AFNetworkReachabilityStatusReachableViaWiFi){
            CommerChanceModel *model = [[CommerChanceModel alloc]init];
            model.access_token = [[LoginVM getInstance] readLocal].token;
            model.id = @"0";
            if (footerFresh) {
                footerCount++;
                model.page = [NSString stringWithFormat:@"%ld",footerCount];
            }else{
                model.page = @"0";
            }
            model.my = @"0";
            
            SendAndGetDataFromNet *sendAndget = [[SendAndGetDataFromNet alloc]init];
            __block SendAndGetDataFromNet *wsend = sendAndget;
            sendAndget.returnDict = ^(NSDictionary *dict){
                if (1 == [[dict objectForKey:@"state"] intValue]) {
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSArray *ary = [dict objectForKey:@"data"];
                        
                        if (footerFresh) {
                            if (ary.count == 0) {
                                [self.tableView.mj_footer endRefreshing];
                                footerCount = 0;
                                return ;
                            }
                            for (int i = 0; i < ary.count; i ++) {
                                CommerChanceCellModel *model = [CommerChanceCellModel mj_objectWithKeyValues:[ary objectAtIndex:i]];
                                [self.dataAry addObject:model];
                            }
                        }else{
                            if (!self.dataAry) {
                                self.dataAry = [[NSMutableArray alloc]init];
                            }
                            [self.dataAry removeAllObjects];
                            for (int i = 0; i < ary.count; i ++) {
                                CommerChanceCellModel *model = [CommerChanceCellModel mj_objectWithKeyValues:[ary objectAtIndex:i]];
                                [self.dataAry addObject:model];
                            }

                        }

                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self refreshComplete];
                        });
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        if (self.dataAry) {
            
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
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        static NSString* cellIdentifier = @"cellIdentifier";
        CommerChanceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[CommerChanceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        if (self.dataAry.count > indexPath.row) {
            [cell updateDetail:[self.dataAry objectAtIndex:indexPath.row]];
            cell.typebtn.tag = indexPath.row;
            [cell.typebtn addTarget:self action:@selector(typebtnaction:) forControlEvents:UIControlEventTouchUpInside];
            cell.lookforbtn.tag = indexPath.row;
            [cell.lookforbtn addTarget:self action:@selector(lookforbtnaction:) forControlEvents:UIControlEventTouchUpInside];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}

- (void)typebtnaction:(UIButton *)btn{
    if (self.dataAry.count > btn.tag) {
        CommerChanceCellModel *model = [self.dataAry objectAtIndex:btn.tag];
        MoreCommerChanceVC *vc = [[MoreCommerChanceVC alloc]init];
        vc.model = model;
//        [ZJBHelp getInstance].bbRootVC.tabBarController.tabBar.hidden = YES;
        
//        [[ZJBHelp getInstance].bbRootVC.navigationController pushViewController:vc animated:YES];
        self.tabBarController.tabBar.hidden = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)lookforbtnaction:(UIButton *)btn{
    if (self.dataAry.count > btn.tag) {
        CommerChanceCellModel *model = [self.dataAry objectAtIndex:btn.tag];
        BBActivityDetailVC *vc = [[BBActivityDetailVC alloc]init];
        vc.activity_id = model.activity_id;
        vc.model = model;
//        [ZJBHelp getInstance].bbRootVC.tabBarController.tabBar.hidden = YES;
//        
//        [[ZJBHelp getInstance].bbRootVC.navigationController pushViewController:vc animated:YES];
        self.tabBarController.tabBar.hidden = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return self.cusSearchView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 58;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AppDelegate *appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (!appD.vip) {
        [UIView bch_showWithTitle:@"提示" message:@"查看商机详情要先加入建众帮会员哦！" buttonTitles:@[@"取消",@"确定"] callback:^(id sender, NSUInteger buttonIndex) {
            if (1 == buttonIndex) {
              //  AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                
              //  if (appDelegate.checkpay) {
                    ApplyVipVC *applyVipVC = [[ApplyVipVC alloc]init];
                    [self.navigationController pushViewController:applyVipVC animated:YES];
              //  }
            }
        }];
        return;
    };
    
    CommerChanceCellModel *model = [self.dataAry objectAtIndex:indexPath.row];
    BBActivityDetailVC *vc = [[BBActivityDetailVC alloc]init];
    vc.model = model;
    vc.activity_id = model.activity_id;
//    [ZJBHelp getInstance].bbRootVC.tabBarController.tabBar.hidden = YES;
//    
//    [[ZJBHelp getInstance].bbRootVC.navigationController pushViewController:vc animated:YES];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 207;
    }
    return 0;
}


- (void)tableViewCell:(UITableViewCell *)cell didClickedLinkWithData:(id)data clinkType:(Clink_Type)clink_type{
    if (clink_type == Clink_Type_One) {
//        ActivityModel *model = ((BBActivityCell *)cell).cellLayout.activityModel;
//        //        OtherPersonCentralVC *vc = [[OtherPersonCentralVC alloc]init];
//        
//        PublicOtherPersonVC *vc = [[UIStoryboard storyboardWithName:@"PublicOtherPersonVC" bundle:nil]instantiateInitialViewController];
//        vc.user = model.user;
//        [ZJBHelp getInstance].bbRootVC.tabBarController.tabBar.hidden = YES;
//        [ZJBHelp getInstance].bbRootVC.navigationController.navigationBar.hidden = YES;
//        [[ZJBHelp getInstance].bbRootVC.navigationController pushViewController:vc animated:YES];
    }
}

@end
