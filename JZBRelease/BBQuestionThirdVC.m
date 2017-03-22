//
//  BBQuestionThirdVC.m
//  JZBRelease
//
//  Created by cl z on 16/11/2.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "BBQuestionThirdVC.h"
#import "SDCycleScrollView.h"
#import "FamousMasterColumnsModel.h"
#import "HotQuestionsModel.h"
#import "TodayQuestionsModel.h"
#import "QuestionsModel.h"
#import "CusGroupBtnView.h"
#import "CusSearchView.h"
#import "XBTeacherView.h"
#import "MJRefresh.h"
#import "WDFocusModel.h"
#import "Defaults.h"
#import "FamousMasterColumnsCell.h"
#import "PublicOtherPersonVC.h"
#import "QuestionsLayout.h"
#import "QuestionCell.h"
#import "WDTitleView.h"
#import "BBQuestionSearchVC.h"
#import "BBQuestionDetailVC.h"
#import "BBQuestionsNewVC.h"
#import "BCH_Alert.h"
#import "ApplyVipVC.h"
#import "PublicLogOutUser.h"

#define BBDataCacheForDict @"BBDataCacheForDict.plist"

@interface BBQuestionThirdVC ()<SDCycleScrollViewDelegate, UITableViewDelegate, UITableViewDataSource,TableViewCellDelegate>{
    NSInteger wait;
}

/** cycleScrollView2 */
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView2;

@property (nonatomic, strong) UIView *intevalView1;
@property (nonatomic, strong) UIView *intevalView2;
@property (nonatomic, strong) UIView *intevalView3;
/** liveTableView */
@property (nonatomic, weak) UITableView *liveTableView;

/** banner数据源 */
@property (nonatomic, strong) NSArray *bannerDataSource,*teacherAry;

@property (nonatomic, strong) FamousMasterColumnsModel *fmcModel;
@property (nonatomic, strong) HotQuestionsModel *hqModel;
@property (nonatomic, strong) TodayQuestionsModel *tqModel;

@property (nonatomic, strong) NSMutableArray *dataAry,*cusDataAry,*imageAry,*hotQuestionLayoutAry,*todayQuestionLayoutAry;

/** bannerImages */
@property (nonatomic, strong) NSArray *bannerImages;
@property (nonatomic, strong) NSArray *bannerTitles;
@property (nonatomic, strong) NSArray *titleAry;


@property (nonatomic, strong) CusGroupBtnView *cusGroupBtnView;
@property (nonatomic, strong) CusSearchView *cusSearchView;
@property (nonatomic, strong) XBTeacherView *xbteacherView;

@property (nonatomic, strong) WDTitleView *fmcTitleView;
@property (nonatomic, strong) WDTitleView *hotTitleView;
@property (nonatomic, strong) WDTitleView *todayTitleView;

@property (nonatomic, assign) BOOL isDownLoadblock;
@property (nonatomic, assign) NSInteger requestCount;
@property (nonatomic, strong) NSDictionary *dataDict;
@end

@implementation BBQuestionThirdVC{
    BOOL isAccess;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    wait = -1;
    self.view.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f2f2f2"];
    self.dataDict = [LocalDataRW readDictFromLocalOfDocument:BBDataCacheForDict WithDirectory_Type:Directory_BB];
    //    self.cusDataAry = [[NSMutableArray alloc]initWithArray:@[@"行业智库",@"跨行智库",@"建众智库"]];
    //    self.imageAry = [[NSMutableArray alloc]initWithArray:@[@"DB_HY",@"DB_KH",@"DB_JZ"]];
    if (self.dataDict) {
        [self dealWithData:self.dataDict];
    }
    [self setupliveTableView];
    
    [self setupBanner];
    
    //[self DownLoadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [[ZJBHelp getInstance].bbRootVC.navigationController setNavigationBarHidden:NO animated:YES];
    [ZJBHelp getInstance].bbRootVC.tabBarController.tabBar.hidden = NO;
}

- (void)DownLoadData
{
    if (![[LoginVM getInstance] readLocal]) {
        return;
    }
    if (isAccess) {
        
        return ;
    }
    isAccess = YES;
    
    dispatch_async(dispatch_queue_create("", nil), ^{
        NSDictionary *parameters = @{
                                     @"access_token":[[LoginVM getInstance]readLocal].token
                                     };
        
        [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/Question/getIndex"] parameters:parameters success:^(id json) {
            
            if ([json[@"state"] isEqual:@(0)]) {
                //            NSLog(@"TTT--json%@",json);
                //            [SVProgressHUD showInfoWithStatus:json[@"info"]];
                if (self.requestCount == 0) {
                    //self.isDownLoadblock = YES;
                    [LoginVM getInstance].isGetToken = ^(){
                        [self.liveTableView.mj_header beginRefreshing];
                        self.requestCount ++;
                    };
                    [[LoginVM getInstance] loginWithUserInfoForGetNewToken:[[LoginVM getInstance] readLocal]];
                    //[self.liveTableView.mj_header beginRefreshing];
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.requestCount = 0;
                        [self.liveTableView.mj_header endRefreshing];
                        [SVProgressHUD showInfoWithStatus:json[@"info"]];
                    });
                    
                }
                
                return ;
            }else {
                dispatch_async(dispatch_queue_create("dealdata", nil), ^{
                    self.dataAry = [self dealWithData:json];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.liveTableView reloadData];
                        [self.liveTableView.mj_header endRefreshing];
                        isAccess = NO;
                        self.liveTableView.scrollEnabled = YES;
                    });

                });
                
            }
            
        } failure:^(NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.liveTableView.mj_header endRefreshing];
            });
            
        }];

    });
}

- (NSMutableArray *)dealWithData:(NSDictionary *)json{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    self.bannerDataSource = [WDFocusModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"focus"][@"focus_list"]];
    
    self.fmcModel = [FamousMasterColumnsModel mj_objectWithKeyValues:json[@"data"][@"teacher"]];
    self.hqModel = [HotQuestionsModel mj_objectWithKeyValues:json[@"data"][@"hot"]];
    self.tqModel = [TodayQuestionsModel mj_objectWithKeyValues:json[@"data"][@"zxwd"]];
    
    
    
    if (self.fmcModel && self.fmcModel.teacher_list.count > 0) {
        [array addObject:self.fmcModel];
    }
    if (self.hqModel && self.hqModel.hot_list.count > 0) {
        self.hotQuestionLayoutAry = [self cellWithDataAry:self.hqModel.hot_list];
        [array addObject:self.hqModel];
    }
    if (self.tqModel && self.tqModel.zxwd_list.count > 0) {
        self.todayQuestionLayoutAry = [self cellWithDataAry:self.tqModel.zxwd_list];
        [array addObject:self.tqModel];
    }
    
    /** 给banner提供数据 */
    [self HandleBannerData];
    return array;
}



- (XBTeacherView *)xbteacherView{
    if (!_xbteacherView) {
        if (!self.fmcModel) {
            return nil;
        }
        _xbteacherView = [[XBTeacherView alloc]initWithTeacherArr:self.fmcModel.teacher_list WithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    }
    return _xbteacherView;
}

- (void)HandleBannerData
{
    /** 给banner提供数据 */
    NSMutableArray *arrM_img = [NSMutableArray array];
    NSMutableArray *arrM_title = [NSMutableArray array];
    for (WDFocusModel *model in self.bannerDataSource) {
        if (model.thumb) {
            //[arrM_img addObject:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:model.thumb]];
            [arrM_img addObject:model.thumb];
        }
        if (model.title) {
            [arrM_title addObject:model.title];
        }
    }
    self.bannerImages = arrM_img;
    self.bannerTitles = arrM_title;
}

- (void)setupliveTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UITableView *liveTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.glw_width, self.view.glb_bottom - 53 ) style:UITableViewStylePlain];
    liveTableView.contentInset = UIEdgeInsetsMake(0, 0, 53, 0);
    liveTableView.backgroundColor = [UIColor whiteColor];
    liveTableView.scrollIndicatorInsets = liveTableView.contentInset;
    //self.view.glb_bottom -49 - self.cycleScrollView2.glb_bottom
    [self.view addSubview:liveTableView];
    
    self.liveTableView = liveTableView;
    
    [self.liveTableView registerNib:[UINib nibWithNibName:@"XBLiveVideoCell" bundle:nil] forCellReuseIdentifier:@"liveCell"];
    
    self.liveTableView.delegate = self;
    self.liveTableView.dataSource = self;
    
    self.liveTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.liveTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self DownLoadData];
        
    }];
    
    [self.liveTableView.mj_header beginRefreshing];
    
}

- (void)setupBanner
{
    
}

-(NSMutableArray *)cellWithDataAry:(NSArray *) dataAry{
    NSMutableArray *ary = [[NSMutableArray alloc]init];
    BOOL isLast = NO;
    for (NSInteger i = 0; i < dataAry.count ; i ++) {
        QuestionsModel *questionsModel = [QuestionsModel mj_objectWithKeyValues:[dataAry objectAtIndex:i]];
        if (questionsModel) {
            if (i == dataAry.count - 1) {
                isLast = YES;
            }
            QuestionsLayout *layout = [self layoutWithDetailListModel:questionsModel index:i IsDetail:NO IsLast:isLast];
            if (layout) {
                [ary addObject:layout];
            }
        }
    }
    return ary;
}

- (QuestionsLayout *)layoutWithDetailListModel:(QuestionsModel *)questionsModel index:(NSInteger)index IsDetail:(BOOL)isDetail IsLast:(BOOL)isLast{
    //生成Storage容器
    LWStorageContainer* container = [[LWStorageContainer alloc] init];
    //生成Layout
    QuestionsLayout* layout = [[QuestionsLayout alloc]initWithContainer:container Model:questionsModel dateFormatter:[self dateFormatter] index:index IsDetail:isDetail IsLast:isLast];
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


#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2 + self.dataAry.count;
}


#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }else if (section == 1){
        return 0;
    }else{
        NSObject *obj = [self.dataAry objectAtIndex:section - 2];
        if ([obj isKindOfClass:[self.fmcModel class]]) {
            return 1;
        }else if ([obj isKindOfClass:[self.hqModel class]]){
            return self.hqModel.hot_list.count;
        }else if ([obj isKindOfClass:[self.tqModel class]]){
            return self.tqModel.zxwd_list.count;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentifier = @"QuestionCellIdentifier";
    NSObject *obj = [self.dataAry objectAtIndex:indexPath.section - 2];
    if ([obj isKindOfClass:[self.fmcModel class]]) {
        FamousMasterColumnsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FamousMasterColumnsCell"];
        if (!cell) {
            cell = [[FamousMasterColumnsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FamousMasterColumnsCell"];
        }
        
        __block typeof (self) wself = self;
        if (!cell.teacherView) {
            cell.teacherView = self.xbteacherView;
            cell.teacherView.returnAction = ^(NSInteger tag){
                [Toast makeShowCommen:@"功能暂未开发，敬请期待" ShowHighlight:@"" HowLong:1];
//                PublicOtherPersonVC *othervc = [[UIStoryboard storyboardWithName:@"PublicOtherPersonVC" bundle:nil]instantiateInitialViewController];
//                othervc.view.backgroundColor = [UIColor whiteColor];
//                Users *user = [Users mj_objectWithKeyValues:[wself.fmcModel.teacher_list objectAtIndex:tag]];
//                othervc.user = user;
//                othervc.fromDynamicDetailVC = YES;
//                self.navigationController.navigationBar.hidden = YES;
//                self.tabBarController.tabBar.hidden = YES;
//                [self.navigationController pushViewController:othervc animated:YES];
            };
            [cell.contentView addSubview:self.xbteacherView];
            UIView *intevalView = [[UIView alloc]initWithFrame:CGRectMake(0, self.xbteacherView.frame.origin.y + self.xbteacherView.frame.size.height, SCREEN_WIDTH, 12)];
            [intevalView setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
            [cell.contentView addSubview:intevalView];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }else if ([obj isKindOfClass:[self.hqModel class]]){
        
        QuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[QuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        if (self.hotQuestionLayoutAry.count > indexPath.row) {
            QuestionsLayout* cellLayouts = self.hotQuestionLayoutAry[indexPath.row];
            cell.cellLayout = cellLayouts;
        }
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }else if ([obj isKindOfClass:[self.tqModel class]]){
        QuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[QuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        if (self.hotQuestionLayoutAry.count > indexPath.row) {
            QuestionsLayout* cellLayouts = self.todayQuestionLayoutAry[indexPath.row];
            cell.cellLayout = cellLayouts;
        }
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GLLog(@"%@",[LoginVM getInstance].users);
    GLLog(@"%@",[LoginVM getInstance].users);
    GLLog(@"%@",[LoginVM getInstance].users);
    
    if ([LoginVM getInstance].users) {
        
    }else {
        
        
        [PublicLogOutUser logOutUser:self.navigationController netWorkLoOut:YES];
        
        return ;
    }
    
    AppDelegate *appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (!appD.vip) {
        [UIView bch_showWithTitle:@"提示" message:@"查看问答详情要先加入建众帮会员哦！" buttonTitles:@[@"取消",@"确定"] callback:^(id sender, NSUInteger buttonIndex) {
            if (1 == buttonIndex) {
                AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                
                //if (appDelegate.checkpay) {
                    ApplyVipVC *applyVipVC = [[ApplyVipVC alloc]init];
                    [self.navigationController pushViewController:applyVipVC animated:YES];
                //}
            }
        }];
        return;
    };
    NSObject *obj = [self.dataAry objectAtIndex:indexPath.section - 2];
    if ([obj isKindOfClass:[self.fmcModel class]]) {
        return;
    }else if ([obj isKindOfClass:[self.hqModel class]]){
        QuestionsLayout *layout = self.hotQuestionLayoutAry[indexPath.row];
        layout.questionsModel.row = [NSNumber numberWithInteger:indexPath.row];
        BBQuestionDetailVC *vc = [[BBQuestionDetailVC alloc]init];
        __weak typeof (self) wself = self;
        vc.updateData = ^(){
            [wself.liveTableView.mj_header beginRefreshing];
        };
        vc.questionModel = layout.questionsModel;
        [ZJBHelp getInstance].bbRootVC.tabBarController.tabBar.hidden = YES;
        [[ZJBHelp getInstance].bbRootVC.navigationController pushViewController:vc animated:YES];
    }else if ([obj isKindOfClass:[self.tqModel class]]){
        QuestionsLayout *layout = self.todayQuestionLayoutAry[indexPath.row];
        layout.questionsModel.row = [NSNumber numberWithInteger:indexPath.row];
        BBQuestionDetailVC *vc = [[BBQuestionDetailVC alloc]init];
        __weak typeof (self) wself = self;
        vc.updateData = ^(){
            [wself.liveTableView.mj_header beginRefreshing];
        };
        vc.questionModel = layout.questionsModel;
        [ZJBHelp getInstance].bbRootVC.tabBarController.tabBar.hidden = YES;
        [[ZJBHelp getInstance].bbRootVC.navigationController pushViewController:vc animated:YES];
    }
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 45)];
    //
    //    [headerView setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f8f8f8"]];
    
    if (section == 0) {
        return self.cusSearchView;
        
    }else if (section == 1) {
        
        return self.cycleScrollView2;
        
    }else {
        NSObject *obj = [self.dataAry objectAtIndex:section - 2];
        if ([obj isKindOfClass:[self.fmcModel class]]) {
            self.fmcTitleView.btn.tag = section;
            return self.fmcTitleView;
        }else if ([obj isKindOfClass:[self.hqModel class]]){
            self.hotTitleView.btn.tag = section;
            return self.hotTitleView;
        }else if ([obj isKindOfClass:[self.tqModel class]]){
            self.todayTitleView.btn.tag = section;
            return self.todayTitleView;
        }
 
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (0 == section) {
        return nil;
    }else if(1 == section){
        return self.intevalView1;
    }else{
        NSObject *obj = [self.dataAry objectAtIndex:section - 2];
        if ([obj isKindOfClass:[self.fmcModel class]]) {
            return self.intevalView2;
        }else if ([obj isKindOfClass:[self.hqModel class]]){
            return self.intevalView3;
        }else{
            return nil;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (0 == section) {
        return 0;
    }else{
        return 12;
    }
}

- (WDTitleView *)fmcTitleView{
    if (!_fmcTitleView) {
        _fmcTitleView = [WDTitleView initTypeStr:self.fmcModel.title WithFrame:CGRectMake(0, 0, GLScreenW, 40)];
        [_fmcTitleView.btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fmcTitleView;
}

- (WDTitleView *)hotTitleView{
    if (!_hotTitleView) {
        _hotTitleView = [WDTitleView initTypeStr:self.hqModel.title WithFrame:CGRectMake(0, 0, GLScreenW, 40)];
        [_hotTitleView.btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hotTitleView;
}

- (WDTitleView *)todayTitleView{
    if (!_todayTitleView) {
        _todayTitleView = [WDTitleView initTypeStr:self.tqModel.title WithFrame:CGRectMake(0, 0, GLScreenW, 40)];
        [_todayTitleView.btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _todayTitleView;
}

- (void)btnAction:(UIButton *)btn{
    NSObject *obj = [self.dataAry objectAtIndex:btn.tag - 2];
    if ([obj isKindOfClass:[self.fmcModel class]]) {
        [Toast makeShowCommen:@"功能暂未开发，" ShowHighlight:@"敬请期待" HowLong:1];
    }else if ([obj isKindOfClass:[self.hqModel class]]){
        BBQuestionsNewVC *newVc = [[BBQuestionsNewVC alloc]init];
        [[ZJBHelp getInstance].bbRootVC.navigationController pushViewController:newVc animated:YES];
    }else if ([obj isKindOfClass:[self.tqModel class]]){
        BBQuestionsNewVC *newVc = [[BBQuestionsNewVC alloc]init];
        [[ZJBHelp getInstance].bbRootVC.navigationController pushViewController:newVc animated:YES];
    }

}

- (UIView *)intevalView1{
    if (!_intevalView1) {
        _intevalView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 12)];
        [_intevalView1 setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
        UIView *top = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GLScreenW, 0.8)];
        [top setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"e2e2e2"]];
        [_intevalView1 addSubview:top];
        UIView *bottom = [[UIView alloc]initWithFrame:CGRectMake(0, 11.2, GLScreenW, 0.8)];
        [bottom setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"e2e2e2"]];
        [_intevalView1 addSubview:bottom];
        
    }
    return _intevalView1;
}

- (UIView *)intevalView2{
    if (!_intevalView2) {
        _intevalView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 12)];
        [_intevalView2 setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
        UIView *top = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GLScreenW, 0.8)];
        [top setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"e2e2e2"]];
        [_intevalView2 addSubview:top];
        UIView *bottom = [[UIView alloc]initWithFrame:CGRectMake(0, 11.2, GLScreenW, 0.8)];
        [bottom setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"e2e2e2"]];
        [_intevalView2 addSubview:bottom];
        
    }
    return _intevalView2;
}

- (UIView *)intevalView3{
    if (!_intevalView3) {
        _intevalView3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 12)];
        [_intevalView3 setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
        UIView *top = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GLScreenW, 0.8)];
        [top setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"e2e2e2"]];
        [_intevalView3 addSubview:top];
        UIView *bottom = [[UIView alloc]initWithFrame:CGRectMake(0, 11.2, GLScreenW, 0.8)];
        [bottom setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"e2e2e2"]];
        [_intevalView3 addSubview:bottom];
        
    }
    return _intevalView3;
}

- (SDCycleScrollView *)cycleScrollView2{
    if (!_cycleScrollView2) {
        // 网络加载 --- 创建带标题的图片轮播器
        _cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.glw_width, self.view.glw_width / 2.419) delegate:self placeholderImage:nil];
        [_cycleScrollView2 setBackgroundColor:[UIColor whiteColor]];
        _cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _cycleScrollView2.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    }
    _cycleScrollView2.imageURLStringsGroup = self.bannerImages;
    _cycleScrollView2.titlesGroup =self.bannerTitles;
    //__weak typeof (self) wself = self;
    _cycleScrollView2.clickItemOperationBlock = ^(NSInteger index) {
        
        
        
    };
    
    return _cycleScrollView2;
}

- (UIView *)cusSearchView{
    if (!_cusSearchView) {
        _cusSearchView = [[CusSearchView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 58)];
        [_cusSearchView setLabelText:@"请输入你要搜索的问题"];
        //__weak typeof ([ZJBHelp getInstance].bbRootVC) wself = [ZJBHelp getInstance].bbRootVC;
        _cusSearchView.returnAction = ^(NSInteger tag){
            BBQuestionSearchVC *searchVC = [[BBQuestionSearchVC alloc]init];
            //[ZJBHelp getInstance].bbRootVC.navigationController.navigationBar.hidden = YES;
            //[ZJBHelp getInstance].bbRootVC.tabBarController.tabBar.hidden = YES;
            [[ZJBHelp getInstance].bbRootVC.navigationController pushViewController:searchVC animated:YES];
        };    }
    return _cusSearchView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 ) {
        return 58;
    }else if (section == 1) {
        return 150;
    }else {
        return 40;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject *obj = [self.dataAry objectAtIndex:indexPath.section - 2];
    if ([obj isKindOfClass:[self.fmcModel class]]) {
        return 120;
    }else if ([obj isKindOfClass:[self.hqModel class]]){
        if (self.hotQuestionLayoutAry.count > indexPath.row) {
            QuestionsLayout *layout = [self.hotQuestionLayoutAry objectAtIndex:indexPath.row];
            return layout.cellHeight;
        }
        return 0;
    }else if ([obj isKindOfClass:[self.tqModel class]]){
        if (self.todayQuestionLayoutAry.count > indexPath.row) {
            QuestionsLayout *layout = [self.todayQuestionLayoutAry objectAtIndex:indexPath.row];
            return layout.cellHeight;
        }
        return 0;
    }

    return 0;
}

- (void)tapMoreLivelabel
{
//    SendedCourseTimeListVC *vc = [SendedCourseTimeListVC new];
//    
//    vc.isRootVCComing = YES;
//    vc.liveType = @"2";
//    
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tapMorePreLivelabel
{
//    SendedCourseTimeListVC *vc = [SendedCourseTimeListVC new];
//    
//    vc.isRootVCComing = YES;
//    vc.liveType = @"1";
//    
//    [self.navigationController pushViewController:vc animated:YES];
}

@end
