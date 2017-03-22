//
//  FansListVC.m
//  JZBRelease
//
//  Created by cl z on 16/8/20.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "AttentionListVC.h"
#import "Defaults.h"
#import "MJRefresh.h"
#import "GetFansListModel.h"
#import "FansListModel.h"
#import "AttentionCell.h"
#import "UIImageView+WebCache.h"
//#import "OtherPersonCentralVC.h"
#import "PublicOtherPersonVC.h"

#import "GLNAVC.h"

//#import "WDFansCell.h"

@interface AttentionListVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *dataAry;

/** isMyFocus */
@property (nonatomic, assign) BOOL isMyAttent;

@end

@implementation AttentionListVC

static NSString* ID = @"AttentionCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    [self configNav];
    
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    GLLog(@"%@",self.navigationController);
    if ([self.navigationController isKindOfClass:[GLNAVC class]]) {
        
    }else {
        [self configNav];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self createTableView];
}

-(void)backAction{
    
    self.navigationController.navigationBar.hidden = YES;
    
    if (self.isSecVCPush) {
        self.navigationController.navigationBar.hidden = NO;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createTableView{
    //    NSLog(@"self.view.frame.size.height %f",self.view.frame.size.height);
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
    //    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    __unsafe_unretained UITableView *tableView1 = self.tableView;
    self.tableView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f8f8f8"];
    /** 去除多余的分割线 */
    self.tableView.tableFooterView = [[UIImageView alloc]init];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AttentionCell" bundle:nil] forCellReuseIdentifier:ID];
    
    // 下拉刷新
    tableView1.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self createData];
        
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
}

- (void)createData{
    NSLog(@"-----------头部刷新数据-----------");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self downloadData];
    });
    
}

- (void)createFootData{
    NSLog(@"-----------尾部加载更多数据-----------");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //        for (int i = 200; i < 210; i ++) {
        //            [self.dataSource addObject:[NSString stringWithFormat:@"%d",i]];
        //        }
        
        [self.tableView reloadData];
        //        [_refresh endRefresh];
    });
}

- (void)downloadData {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[HttpManager shareManager] netStatus:^(AFNetworkReachabilityStatus status) {
            if(status == AFNetworkReachabilityStatusReachableViaWWAN || status ==AFNetworkReachabilityStatusReachableViaWiFi){
                GetFansListModel *model = [[GetFansListModel alloc]init];
                model.access_token = [[LoginVM getInstance] readLocal].token;
                model.type = @"1";
                model.pid = @"0";
                model.user_id = self.user.uid;
                
                if (self.user.uid &&self.user.uid != [LoginVM getInstance].readLocal._id) {
                    self.isMyAttent = YES;
                }
                
                SendAndGetDataFromNet *sendAndget = [[SendAndGetDataFromNet alloc]init];
                __block SendAndGetDataFromNet *wsend = sendAndget;
                sendAndget.returnDict = ^(NSDictionary *dict){
                    if (1 == [[dict objectForKey:@"state"] intValue]) {
                        NSArray *ary = [dict objectForKey:@"data"];
                        if (self.dataAry) {
                            [self.dataAry removeAllObjects];
                        }
                        for (int i = 0; i < ary.count; i ++) {
                            Users *model = [Users mj_objectWithKeyValues:[ary objectAtIndex:i][@"user"]];
                            [self.dataAry addObject:model];
                        }
                        NSLog(@"%@",ary);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self refreshComplete];
                        });
                        
                    }else{
                        [LoginVM getInstance].isGetToken = ^(){
                            model.access_token = [[LoginVM getInstance] readLocal].token;
                            [wsend dictFromNet:model WithRelativePath:@"Get_Fans_List"];
                        };
                        [[LoginVM getInstance] loginWithUserInfoForGetNewToken:[[LoginVM getInstance] readLocal]];
                    }
                };
                [sendAndget dictFromNet:model WithRelativePath:@"Get_Fans_List"];
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
        
        notDataShowView *view;
        
        if (self.dataAry.count) {
            if ([notDataShowView sharenotDataShowView].superview) {
                [[notDataShowView sharenotDataShowView] removeFromSuperview];
            }
        }else {
            view = [notDataShowView sharenotDataShowView:self.tableView];
            [self.view addSubview:view];
            
        }
        
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
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
    
    AttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.isMyAttent = self.isMyAttent;
    if (self.dataAry.count > indexPath.row) {
        
        
        cell.item = self.dataAry[indexPath.row];
        
    }
    
    return cell;
    //    FansListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //    if (!cell) {
    //        cell = [[FansListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    //    }
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    if (self.dataAry.count > indexPath.row) {
    //        FansListModel *model = [self.dataAry objectAtIndex:indexPath.row];
    //        [cell.avtarImageView sd_setImageWithURL:[NSURL URLWithString:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:model.avatar]] placeholderImage:[UIImage imageNamed:@"bq_img_head"]];
    //        [cell.nameLabel setText:model.nickname];
    //    }
    
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (self.dataAry.count > 0) {
//        FansListModel *model = [self.dataAry objectAtIndex:0];
//        return model.inteval * 2 + model.avatarWidth;
//    }
//    return 0;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    OtherPersonCentralVC *other = [[OtherPersonCentralVC alloc]init];
    PublicOtherPersonVC *other = [[UIStoryboard storyboardWithName:@"PublicOtherPersonVC" bundle:nil]instantiateInitialViewController];
    
    Users *user = [[Users alloc]init];
    FansListModel *model = [self.dataAry objectAtIndex:indexPath.row];
    user.uid = model.uid;
    other.user = user;
    other.isSecVCPush = YES;
    
    if ([other.user.uid isEqualToString:[LoginVM getInstance].readLocal._id] || other.user.uid == nil) {
        return ;
    }
    
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController pushViewController:other animated:YES];
}

-(NSMutableArray *)dataAry{
    if (!_dataAry) {
        _dataAry = [[NSMutableArray alloc]init];
    }
    return _dataAry;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

//分隔线左对齐
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }

    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
