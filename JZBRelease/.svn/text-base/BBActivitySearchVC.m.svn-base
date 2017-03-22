//
//  BBActivitySearchVC.m
//  JZBRelease
//
//  Created by cl z on 16/8/15.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "BBActivitySearchVC.h"
#import "MJRefresh.h"
#import "Defaults.h"
#import "GetActivityListModel.h"
#import "ActivityModel.h"
#import "BBActivityCell.h"
#import "ActivityLayout.h"
#import "OtherPersonCentralVC.h"
#import "TableViewCell.h"
#import "CommerChanceCell.h"
#import "BBActivityDetailVC.h"
#import "CommerChanceModel.h"
#import "CusSearchVC.h"
#import "ApplyVipVC.h"
#import "BCH_Alert.h"
#import "PublicLogOutUser.h"

@interface BBActivitySearchVC ()<UITableViewDelegate,UITableViewDataSource,CusSearchDelegate>{
    NSString *searchKeyWord;
    NSInteger preSelector;
    BOOL footerFresh;
}
@property (nonatomic, strong) NSMutableArray *dataAry,*questionsAry;

@property (nonatomic, strong) CusSearchVC *cusSearchVC;
@end

@implementation BBActivitySearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //初始搜索
//    CusSearchModel *model = [[CusSearchModel alloc]init];
//    model.adressName = @"BBActivitySearchVC";
//    model.placeholder = @"请输入你要搜索的商机";
//    self.cusSearchVC = [[CusSearchVC alloc]initWithModel:model];
//    self.cusSearchVC.delegate = self;
//    self.cusSearchVC.view.frame = self.view.frame;
//    [self.view addSubview:self.cusSearchVC.view];
    
    self.cusSearchVC = [[CusSearchVC alloc]initWithplaceholder:@"请输入你要搜索的课程内容" WithAdresaName:@"BBActivitySearchVC" WithParentOrDeleagteVC:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}

// CusSearchDelegate 代理方法
- (void)gobackAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) clearBtnAction{
    self.cusSearchVC.keyWordTableView.hidden = NO;
    [self.cusSearchVC.keyWordTableView reloadData];
    if (self.tableView) {
        self.tableView.hidden = YES;
    }
    
}

- (void) beginSearch:(NSString *)keyWord{
    searchKeyWord = keyWord;
    self.cusSearchVC.keyWordTableView.hidden = YES;
    
    if (!self.tableView) {
        [self createTableView];
    }else{
        [self downloadData];
    }
    self.tableView.hidden = NO;
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
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView1.mj_header.automaticallyChangeAlpha = YES;
    
//    // 上拉刷新
//    tableView1.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            // 结束刷新
//            [tableView1.mj_footer endRefreshing];
//        });
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //        for (int i = 200; i < 210; i ++) {
        //            [self.dataSource addObject:[NSString stringWithFormat:@"%d",i]];
        //        }
        [self.tableView reloadData];
        //        [_refresh endRefresh];
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
    
    [[HttpManager shareManager] netStatus:^(AFNetworkReachabilityStatus status) {
        if(status == AFNetworkReachabilityStatusReachableViaWWAN || status ==AFNetworkReachabilityStatusReachableViaWiFi){
            CommerChanceModel *model = [[CommerChanceModel alloc]init];
            model.access_token = [[LoginVM getInstance] readLocal].token;
            model.id = @"0";
            if (footerFresh) {
                
            }else{
                
            }
            if (searchKeyWord) {
                model.keyword = searchKeyWord;
            }
            
            model.my = @"0";
            
            SendAndGetDataFromNet *sendAndget = [[SendAndGetDataFromNet alloc]init];
            __block SendAndGetDataFromNet *wsend = sendAndget;
            sendAndget.returnDict = ^(NSDictionary *dict){
                if (1 == [[dict objectForKey:@"state"] intValue]) {
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSArray *ary = [dict objectForKey:@"data"];
                        if (!ary || ary.count == 0) {
                            [SVProgressHUD showInfoWithStatus:@"亲，很抱歉暂时没有您需要的内容！我们会不断努力，提供更多有价值的干货！"];
                            //                            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"亲，很抱歉暂时没有您需要的内容！我们会不断努力，提供更多有价值的干货！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                            //                            [alertView show];
                            
                        }
                        if (footerFresh) {
                            
                    //        NSInteger beginCount = self.dataAry.count - 1;
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

- (void)typebtnaction:(UIButton *)btn{
    NSLog(@"%ld btn.tag",btn.tag);
}
- (void)lookforbtnaction:(UIButton *)btn{
    if (self.dataAry.count > btn.tag) {
        CommerChanceCellModel *model = [self.dataAry objectAtIndex:btn.tag];
        BBActivityDetailVC *vc = [[BBActivityDetailVC alloc]init];
        vc.activity_id = model.activity_id;
        vc.model = model;
        //[ZJBHelp getInstance].bbRootVC.navigationController.navigationBar.hidden = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AppDelegate *appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if ([LoginVM getInstance].users) {
        
    }else {
//        [PublicLogOutUser logOutUser:self.navigationController];
        [PublicLogOutUser logOutUser:self.navigationController netWorkLoOut:YES];
        return ;
    }
    
    GLLog(@"%@",[LoginVM getInstance].users);
    GLLog(@"%@",[LoginVM getInstance].users);
    GLLog(@"%@",[LoginVM getInstance].users);
    
    if (!appD.vip) {
        [UIView bch_showWithTitle:@"提示" message:@"查看商机详情要先加入建众帮会员哦！" buttonTitles:@[@"取消",@"确定"] callback:^(id sender, NSUInteger buttonIndex) {
            if (1 == buttonIndex) {
//                AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//                
//                if (appDelegate.checkpay) {
                    ApplyVipVC *applyVipVC = [[ApplyVipVC alloc]init];
                    [self.navigationController pushViewController:applyVipVC animated:YES];
                //}
            }
        }];
        return;
    };
    CommerChanceCellModel *model = [self.dataAry objectAtIndex:indexPath.row];
    BBActivityDetailVC *vc = [[BBActivityDetailVC alloc]init];
    vc.model = model;
    vc.activity_id = model.activity_id;
    self.tabBarController.tabBar.hidden = YES;
    //[ZJBHelp getInstance].bbRootVC.navigationController.navigationBar.hidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

     return 207;
}


- (void)tableViewCell:(UITableViewCell *)cell didClickedLinkWithData:(id)data clinkType:(Clink_Type)clink_type{
    if (clink_type == Clink_Type_One) {
        ActivityModel *model = ((BBActivityCell *)cell).cellLayout.activityModel;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OtherPersonCentralVC" object:self userInfo:[[model.user class] entityToDictionary:model.user]];
    }
}

- (void)tableViewCell:(TableViewCell *)cell didClickedCommentWithCellLayout:(CellLayout *)layout
          atIndexPath:(NSIndexPath *)indexPath clinkType:(Clink_Type)clink_type{
    if (clink_type == Clink_Type_One) {
        ActivityModel *model = ((BBActivityCell *)cell).cellLayout.activityModel;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OtherPersonCentralVC" object:self userInfo:[[model.user class] entityToDictionary:model.user]];
    }else if (clink_type == Clink_Type_Two){
        ActivityLayout *layout = [self.dataAry objectAtIndex:indexPath.row];
        ActivityModel *model = layout.activityModel;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PushToBBActivityVC" object:self userInfo:@{@"activity_id":model.activity_id}];
        
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
