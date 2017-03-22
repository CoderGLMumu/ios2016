
//
//  LuXiangCourseTimeVC.m
//  JZBRelease
//
//  Created by cl z on 16/12/7.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "LuXiangCourseTimeVC.h"

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
#import "HasBoughtCourseTimeModel.h"
#import "LiveVideoViewController.h"
#import "LiveVideoDetailItem.h"
#import "AppDelegate.h"
#import "XBLiveMobileVideoShowVC.h"
#import "VideoDetailXGKCCell.h"

@interface LuXiangCourseTimeVC()<UITableViewDelegate,UITableViewDataSource>{
    //NSMutableArray *courseAry;
    BOOL footerFresh;
    
    UIButton *selectAllBtn;
    UIView *view;
    NSInteger pageNum;
    NSInteger count;
    NSMutableArray *delArray;
    
}

@property(nonatomic,assign) NSInteger requestCount;
@property(nonatomic,strong) NSMutableArray *courseAry;
@property (nonatomic, strong) UIButton *selectedBtn,*deleteBtn;
@property (nonatomic, assign) BOOL isEdit;
@end

@implementation LuXiangCourseTimeVC

- (void)viewDidLoad {
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    pageNum = 0;
    count = 0;
    if ([[LoginVM getInstance].users.uid isEqualToString:self.user.uid]) {
        [self setupNavView];
    }
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createTableView];
    [self initBottomViews];
    view.alpha = 0;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupNavView
{
    //导航 选择按钮
    UIButton *selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectedBtn setBackgroundColor:[UIColor clearColor]];
    
    self.selectedBtn = selectedBtn;
    
    selectedBtn.frame = CGRectMake(0, 0, 60, 30);
    [selectedBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [selectedBtn setTitle:@"取消" forState:UIControlStateSelected];
    [selectedBtn addTarget:self action:@selector(MultipleRemove:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *selectItem = [[UIBarButtonItem alloc] initWithCustomView:selectedBtn];
    
    [selectedBtn setFont:[UIFont systemFontOfSize:15]];
    [selectedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [selectedBtn sizeToFit];
    self.navigationItem.rightBarButtonItem =selectItem;
}

- (void)initBottomViews{
    view = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49)];
    [view setBackgroundColor:[UIColor whiteColor]];
    view.layer.borderColor = [UIColor hx_colorWithHexRGBAString:@"f2f2f2"].CGColor;
    view.layer.borderWidth = 0.8;
    [self.view addSubview:view];
    
    selectAllBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width / 2, view.frame.size.height)];
    [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    //[selectAllBtn setTitle:@"取消全选" forState:UIControlStateSelected];
    selectAllBtn.titleLabel.font = [UIFont systemFontOfSize:17];
//    [selectAllBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"1976d2"] forState:UIControlStateNormal];
    [selectAllBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"222222"] forState:UIControlStateNormal];
    [selectAllBtn addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:selectAllBtn];
    
    self.deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(view.frame.size.width / 2, 0, view.frame.size.width / 2, view.frame.size.height)];
    [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    self.deleteBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.deleteBtn addTarget:self action:@selector(remove:) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"ff9800"] forState:UIControlStateNormal];
    [self.deleteBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"bdbdbd"] forState:UIControlStateDisabled];
    [view addSubview:self.deleteBtn];
    
    [self.view addSubview:view];
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
    self.tableView.allowsSelection = YES;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    __unsafe_unretained UITableView *tableView1 = self.tableView;
    
    // 下拉刷新
    tableView1.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        footerFresh = NO;
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
                if (footerFresh) {
                    pageNum++;
                    
                    model.page = [NSString stringWithFormat:@"%ld",(long)pageNum];
                }else{
                    pageNum = 0;
                    model.page = [NSString stringWithFormat:@"%ld",(long)pageNum];
                }
                model.id = @"0";
                model.user_id = self.user.uid;
                model.course_id = @"0";
                model.my = @"1";
                model.t = @"3";
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
                                    if (courseTimeModel) {
                                        if ([courseTimeModel.type isEqualToString:@"1"] || [courseTimeModel.type isEqualToString:@"2"]) {
                                            
                                        }else{
                                            [self.courseAry addObject:courseTimeModel];
                                        }                                    }
                                }
                            }
                        }else{
                            if (!self.courseAry) {
                                self.courseAry = [[NSMutableArray alloc]init];
                            }
                            [self.courseAry removeAllObjects];
                            for (int i = 0; i < ary.count; i ++) {
                                CourseTimeModel *xBLiveListItem = [CourseTimeModel mj_objectWithKeyValues:[ary objectAtIndex:i]];
                                if ([xBLiveListItem isKindOfClass:[CourseTimeModel class]]) {
                                    if (xBLiveListItem) {
                                        if ([xBLiveListItem.type isEqualToString:@"1"] || [xBLiveListItem.type isEqualToString:@"2"]) {
                                            
                                        }else{
                                            [self.courseAry addObject:xBLiveListItem];
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
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isEdit) {
        GLLog(@"%lu",tableView.indexPathsForSelectedRows.count);
        if (tableView.indexPathsForSelectedRows.count == 0) {
            [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
            self.deleteBtn.enabled = NO;
            
            [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除"] forState:UIControlStateNormal];
            
        }else {
            if (tableView.indexPathsForSelectedRows.count == self.courseAry.count) {
                
                [selectAllBtn setTitle:@"取消全选" forState:UIControlStateNormal];
            }else{
                [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
            }
            self.deleteBtn.enabled = YES;
            
            [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除(%lu)",self.tableView.indexPathsForSelectedRows.count] forState:UIControlStateNormal];
            
        }
        return;
    }

    
    LiveVideoViewController *vc = [LiveVideoViewController new];
    
    CourseTimeModel *item = self.courseAry[indexPath.row];
    
    vc.item = item;
    vc.isBackVideo = YES;
    
    if (!vc.item) {
        [SVProgressHUD showInfoWithStatus:@"网络不顺畅"];
        return ;
    }
    
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isEdit) {
        GLLog(@"%lu",tableView.indexPathsForSelectedRows.count);
        if (tableView.indexPathsForSelectedRows.count == 0) {
            [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
            self.deleteBtn.enabled = NO;
            
            [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除"] forState:UIControlStateNormal];
            
        }else {
            if (tableView.indexPathsForSelectedRows.count == self.courseAry.count) {
                
                [selectAllBtn setTitle:@"取消全选" forState:UIControlStateNormal];
            }else{
                [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
            }
            
            self.deleteBtn.enabled = YES;
            
            [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除%lu",self.tableView.indexPathsForSelectedRows.count] forState:UIControlStateNormal];
            
        }
    }
}

#pragma mark - 按钮的点击事件
#pragma mark - 【编辑模式】
- (void)MultipleRemove:(UIButton *)btn {
    // 进入/取消 【编辑模式】
    //    self.tableView.editing = !self.tableView.editing;
    
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        
        self.isEdit = YES;
        
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.35 animations:^{
            view.alpha = 1;
        }];
        
        self.deleteBtn.enabled = NO;
        
        [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除"] forState:UIControlStateNormal];
        
    }else {
        
        self.isEdit = NO;
        
        [btn setTitle:@"编辑" forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.35 animations:^{
            view.alpha = 0;
        }];
        
    }
    
    [self.tableView setEditing:!self.tableView.editing animated:YES];
}

#pragma mark - 【点击了删除】
- (void)remove:(UIButton *)btn {
    //【点击了删除】
    // 注意点:千万不要一边遍历一边删除,因为没删除掉一个元素,其他元素的索引可能会发生变化
    // 获取要删除的模型
    NSMutableArray *deletedData = [NSMutableArray array];
    for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
        [deletedData addObject:self.courseAry[indexPath.row]];
    }
    delArray = deletedData;
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您确定要删除您所选择的课程吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (1 == buttonIndex) {
        dispatch_async(dispatch_queue_create("", nil), ^{
            [self delCourseTime:delArray];
        });
    }
}

- (void)delCourseTime:(NSArray *)delArrays{
    NSString *accessToken = [LoginVM getInstance].userInfo.token;
    //Del_CourseTime_URL
    NSMutableString *mutIDStr = [[NSMutableString alloc]init];
    for (int i = 0; i < delArrays.count; i ++) {
        CourseTimeModel *courseTimeModel = [delArrays objectAtIndex:i];
        if (i != delArrays.count - 1) {
            [mutIDStr appendString:courseTimeModel.id];
            [mutIDStr appendString:@","];
        }else{
            [mutIDStr appendString:courseTimeModel.id];
        }
    }
    
    if (accessToken) {
        NSDictionary *parameters = @{
                                     @"access_token":accessToken,
                                     @"id":mutIDStr,
                                     };
        NSString *path = [[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:[ValuesFromXML getValueWithName:@"Del_CourseTime_URL" WithKind:XMLTypeNetPort]];
        [HttpToolSDK postWithURL:path parameters:parameters success:^(id json) {
            if ([json[@"state"] isEqual:@(0)]) {
                [SVProgressHUD showSuccessWithStatus:json[@"info"]];
                return ;
            }else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                    // 修改模型
                    [self.courseAry removeObjectsInArray:delArrays];
                    
                    // 刷新表格
                    //    [self.tableView reloadData];
                    [self.tableView deleteRowsAtIndexPaths:self.tableView.indexPathsForSelectedRows withRowAnimation:UITableViewRowAnimationAutomatic];
                    
                    [self MultipleRemove:self.selectedBtn];
                    [UIView animateWithDuration:0.35 animations:^{
                        view.alpha = 0;
                        count = 0;
                    }];
                });
            }
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }
}



#pragma mark - 【删除 - 全选】
- (void)selectAllBtnClick:(UIButton *)button {
    
    NSMutableArray *deletedData = [NSMutableArray array];
    
    button.selected = !button.selected;
    
    if (self.tableView.indexPathsForSelectedRows.count == 0) {
        [selectAllBtn setTitle:@"取消全选" forState:UIControlStateNormal];
        self.deleteBtn.enabled = YES;
        
        [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除所有"] forState:UIControlStateNormal];
        
        for (int i = 0; i < self.courseAry.count; i ++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
            [deletedData addObjectsFromArray:self.courseAry];
        }
        
    }else {
        for (int i = 0; i < self.courseAry.count; i ++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            //            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
            [deletedData addObjectsFromArray:self.courseAry];
        }
        
        if (self.tableView.indexPathsForSelectedRows.count == self.courseAry.count) {
            [selectAllBtn setTitle:@"取消全选" forState:UIControlStateSelected];
        }else{
            [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        }
        self.deleteBtn.enabled = NO;
        
        [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除"] forState:UIControlStateNormal];
        
    }
    GLLog(@"self.deleteArr:%@", deletedData);
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 276;
}
@end
