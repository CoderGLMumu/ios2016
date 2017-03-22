//
//  XBSearchVC.m
//  JZBRelease
//
//  Created by zjapple on 16/9/26.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "BQRMSearchVC.h"
#import "Defaults.h"
#import "MJRefresh.h"
#import "GetCourseTimeListModel.h"
#import "CourseTimeModel.h"
#import "XBLiveVideoCell.h"
#import "LiveVideoViewController.h"
#import "AlivcLiveViewController.h"
#import "AskAnswerItem.h"
#import "VideoDetailXGKCCell.h"
#import "CusSearchVC.h"
#import "AppDelegate.h"
#import "XBOffLiveVideoShowVC.h"

#import "WDBDetailCell.h"
#import "PublicOtherPersonVC.h"

@interface BQRMSearchVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,CusSearchDelegate>{
    NSMutableArray *courseAry;
    BOOL footerFresh;
    NSString *searchKeyWord;
    
    NSInteger pageNum;
}
@property(nonatomic,assign) BOOL isRootVCComing;
@property(nonatomic,assign) NSInteger requestCount;
@property(nonatomic,strong) NSMutableArray *courseAry;

@property (nonatomic, strong) CusSearchVC *cusSearchVC;
@end

@implementation BQRMSearchVC

- (NSMutableArray *)courseAry
{
    if (_courseAry == nil) {
        _courseAry = [NSMutableArray array];
    }
    return _courseAry;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.cusSearchVC = [[CusSearchVC alloc]initWithplaceholder:@"请输入你要搜索的人" WithAdresaName:@"BQRMSearchVC" WithParentOrDeleagteVC:self];

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
        //        for (int i = 200; i < 210; i ++) {
        //            [self.dataSource addObject:[NSString stringWithFormat:@"%d",i]];
        //        }
        [self downloadData];
        //        [_refresh endRefresh];
    });
}

- (void)downloadData {
    
    HttpBaseRequestItem *item = [HttpBaseRequestItem new];

    item.keyword = searchKeyWord;
    
    NSDictionary *parameters = item.mj_keyValues;

    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/User/search_member"] parameters:parameters success:^(id json) {
        
        NSArray *array = [Users mj_objectArrayWithKeyValuesArray:json];
        
        if (array) {
            [self.courseAry removeAllObjects];
            [self.courseAry addObjectsFromArray:array];
        }
        [self refreshComplete];
        //    if ([json[@"state"] isEqual:@(0)]) {
        //        [SVProgressHUD show];
        //    }
        //
        //        NSLog(@"TTT--json%@",json);
    } failure:^(NSError *error) {
        
    }];
    
    
    
    /** 
     dispatch_async(dispatch_queue_create("", nil), ^{
     [[HttpManager shareManager] netStatus:^(AFNetworkReachabilityStatus status) {
     if(status == AFNetworkReachabilityStatusReachableViaWWAN || status ==AFNetworkReachabilityStatusReachableViaWiFi){
     if (searchKeyWord.length == 0) {
     return ;
     }
     GetCourseTimeListModel *model = [[GetCourseTimeListModel alloc]init];
     model.access_token = [[LoginVM getInstance] readLocal].token;
     model.id = @"0";
     model.course_id = @"0";
     model.keyword = searchKeyWord;
     if (footerFresh) {
     pageNum++;
     model.page = [NSString stringWithFormat:@"%ld",(long)pageNum];
     }else{
     pageNum = 0;
     model.page = [NSString stringWithFormat:@"%ld",(long)pageNum];
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
     if (!self.courseAry) {
     self.courseAry = [[NSMutableArray alloc]init];
     }
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
     
     
     [self.courseAry removeAllObjects];
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
     
     
     */
    
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
    
    static NSString *searchResultTableView = @"VideoDetailXGKCCell";
    WDBDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:searchResultTableView];
    if (cell == nil) {
        cell = [[WDBDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchResultTableView];
        //            [cell.contentView addSubLayerWithFrame:CGRectMake(0,
        //                                                              44 - 0.5f,
        //                                                              [UIScreen mainScreen].bounds.size.width,
        //                                                              0.5f
        //                                                              )
        //                                             color:TABLE_LINE_COLOR];
        //            cell.textLabel.backgroundColor = [UIColor whiteColor];
    }
    //        cell.textLabel.text = self.questionDataSource[indexPath.row];
    //        cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.user = self.courseAry[indexPath.row];
    return cell;
    
    
//    static NSString *cellID = @"VideoDetailXGKCCell";
//    VideoDetailXGKCCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    
//    if (!cell) {
//        UINib *nib = [UINib nibWithNibName:@"VideoDetailXGKCCell" bundle:nil];
//        [tableView registerNib:nib forCellReuseIdentifier:cellID];
//        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    }
//    if (self.courseAry.count > indexPath.row) {
//        cell.item = [self.courseAry objectAtIndex:indexPath.row];
//    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AppDelegate *appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (!appD.vip) {
        [UIView bch_showWithTitle:@"提示" message:@"进入建众人脉要先加入建众帮会员哦！" buttonTitles:@[@"取消",@"确定"] callback:^(id sender, NSUInteger buttonIndex) {
            if (1 == buttonIndex) {
                //AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                
               // if (appDelegate.checkpay) {
                    ApplyVipVC *applyVipVC = [[ApplyVipVC alloc]init];
                    [self.navigationController pushViewController:applyVipVC animated:YES];
               // }
            }
        }];
        return;
    };
    
    
//    AppDelegate *delegate = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
//    if (!delegate.checkpay) {
//        XBOffLiveVideoShowVC *mobilevideoShowVC = [[XBOffLiveVideoShowVC alloc] init];
//        mobilevideoShowVC.videoURL = [NSURL URLWithString:@"http://bang.jianzhongbang.com/1.mp4"];
//        [[ZJBHelp getInstance].studyBaRootVC presentViewController:mobilevideoShowVC animated:YES completion:nil];
//        return ;
//    }
    
    CourseTimeModel *courseTimeModel;
    if (self.courseAry.count > indexPath.row) {
        Users *user = self.courseAry[indexPath.row];
        
        PublicOtherPersonVC *vc = [[UIStoryboard storyboardWithName:@"PublicOtherPersonVC" bundle:nil]instantiateInitialViewController];
        vc.user = user;
        
        if ([vc.user.uid isEqualToString:[LoginVM getInstance].readLocal._id] || vc.user.uid == nil) {
            return ;
        }
        
        [self.navigationController setHidesBottomBarWhenPushed:YES];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}




@end
