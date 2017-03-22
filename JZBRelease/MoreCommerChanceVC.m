//
//  MoreCommerChanceVC.m
//  JZBRelease
//
//  Created by zcl on 2016/10/9.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "MoreCommerChanceVC.h"
#import "Defaults.h"
#import "MJRefresh.h"
#import "CommerChanceModel.h"
#import "CommerChanceCellModel.h"
#import "CommerChanceCell.h"
#import "CusSearchView.h"
#import "BBActivityDetailVC.h"

@interface MoreCommerChanceVC ()<UITableViewDelegate,UITableViewDataSource>{
    BOOL footerFresh;
}
@property(nonatomic, strong) NSMutableArray *dataAry;
//@property (nonatomic, strong) CusSearchView *cusSearchView;
@end

@implementation MoreCommerChanceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = [NSString stringWithFormat:@"更多%@",self.model._type];
    //    kRefreshBoundary = 40.0f;
    [self.view setBackgroundColor:[UIColor whiteColor]];
//    [self configNav];
}

- (void)viewDidAppear:(BOOL)animated{
    [self createTableView];
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
    
    
    //11 20
    UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11 + 5 + 40, 35)];
    UIImageView *shareImageView = [UIImageView createImageViewWithFrame:CGRectMake(56 - 20, (35-20)/2, 20, 20) ImageName:@"myhomepage_icon_share"];
    shareImageView.userInteractionEnabled = YES;
    [shareView addSubview:shareImageView];
    //    UILabel *backLabel = [UILabel createLabelWithFrame:CGRectMake(11 + 5,(35-20)/2, 40, 20) Font:17 Text:@"返回" andLCR:0 andColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]]];
    //    [backView addSubview:backLabel];
    UIControl *share = [[UIControl alloc] initWithFrame:backView.bounds];
    //[share addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:share];
    UIBarButtonItem *rifhtBtnItem = [[UIBarButtonItem alloc] initWithCustomView:shareView];
    self.navigationItem.rightBarButtonItem = rifhtBtnItem;
    
}

-(void) backAction{
//    if (self.updateDetailComment) {
//        [self.navigationController popViewControllerAnimated:YES];
//        return;
//    }
    [self.navigationController popViewControllerAnimated:YES];
    self.tabBarController.tabBar.hidden = NO;
}


- (void)createTableView{
    NSLog(@"self.view.frame.size.height %f",self.view.frame.size.height);
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
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
            model.activity_type = self.model.activity_type;
            model.id = @"0";
            if (footerFresh) {
                
            }else{
                
            }
            model.my = @"0";
            
            SendAndGetDataFromNet *sendAndget = [[SendAndGetDataFromNet alloc]init];
            __block SendAndGetDataFromNet *wsend = sendAndget;
            sendAndget.returnDict = ^(NSDictionary *dict){
                if (1 == [[dict objectForKey:@"state"] intValue]) {
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSArray *ary = [dict objectForKey:@"data"];
                        
                        if (footerFresh) {
                            
                            NSInteger beginCount = self.dataAry.count - 1;
                            //                            [self.dataAry insertObjects:nextAry atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange        (beginCount, nextAry.count)]];
                        }else{
                            if (self.dataAry) {
                                [self.dataAry removeAllObjects];
                            }
                            //self.dataAry = [self cellWithDataAry:modelAry];
                        }
                        if (!self.dataAry) {
                            self.dataAry = [[NSMutableArray alloc]init];
                        }
                        for (int i = 0; i < ary.count; i ++) {
                            CommerChanceCellModel *model = [CommerChanceCellModel mj_objectWithKeyValues:[ary objectAtIndex:i]];
                            [self.dataAry addObject:model];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
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
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifier = @"cellIdentifier";
    CommerChanceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[CommerChanceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (self.dataAry.count > indexPath.row) {
        [cell updateDetail:[self.dataAry objectAtIndex:indexPath.row]];
        cell.typebtn.tag = indexPath.row;
        cell.typebtn.hidden = YES;
        [cell.typebtn addTarget:self action:@selector(typebtnaction:) forControlEvents:UIControlEventTouchUpInside];
        cell.lookforbtn.tag = indexPath.row;
         [cell.lookforbtn addTarget:self action:@selector(lookforbtnaction:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}

- (void)typebtnaction:(UIButton *)btn{
    NSLog(@"%ld btn.tag",btn.tag);
}
- (void)lookforbtnaction:(UIButton *)btn{
    if (self.dataAry.count > btn.tag) {
        CommerChanceCellModel *model = [self.dataAry objectAtIndex:btn.tag];
        BBActivityDetailVC *vc = [[BBActivityDetailVC alloc]init];
        vc.activity_id = model.activity_id;
        vc.model = model;
        [ZJBHelp getInstance].bbRootVC.tabBarController.tabBar.hidden = YES;
        //[ZJBHelp getInstance].bbRootVC.navigationController.navigationBar.hidden = YES;
        [[ZJBHelp getInstance].bbRootVC.navigationController pushViewController:vc animated:YES];
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CommerChanceCellModel *model = [self.dataAry objectAtIndex:indexPath.row];
    BBActivityDetailVC *vc = [[BBActivityDetailVC alloc]init];
    vc.activity_id = model.activity_id;
    vc.model = model;
    [ZJBHelp getInstance].bbRootVC.tabBarController.tabBar.hidden = YES;
    //[ZJBHelp getInstance].bbRootVC.navigationController.navigationBar.hidden = YES;
    [[ZJBHelp getInstance].bbRootVC.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 207;
}




@end
