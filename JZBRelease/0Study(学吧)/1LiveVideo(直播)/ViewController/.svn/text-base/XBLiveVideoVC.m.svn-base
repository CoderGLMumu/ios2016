//
//  XBLiveVideoVC.m
//  JZBRelease
//
//  Created by zjapple on 16/9/9.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "XBLiveVideoVC.h"
#import "SDCycleScrollView.h"
#import "Masonry.h"
#import "XBLiveVideoCell.h"
#import "LiveVideoViewController.h"

#import "XBLiveBannerItem.h"
#import "XBLiveListItem.h"
#import "MJRefresh.h"
#import "CusGroupBtnView.h"
#import "SendedCourseTimeListVC.h"
#import "XBCourseTimeListVC.h"
#import "Defaults.h"
#import "CourseTimeModel.h"
#import "CusSearchView.h"
#import "XBSearchVC.h"
#import "ThemeListModel.h"
#import "CourseTimeModel.h"
#import "ZBYGModel.h"
#import "ZBModel.h"
#import "FreeModel.h"
#import "HotModel.h"
#import "ZCBModel.h"
#import "JZCXModel.h"
#import "ZDYXModel.h"
#import "XBBigCell.h"
#import "XBTwoSmallCell.h"
#import "XBFourSmallCell.h"
#import "TeacherModel.h"
#import "XBTeacherView.h"
#import "TeacherCell.h"
#import "XBStudyTypeVC.h"
#import "XBTypeListVC.h"
#import "PublicOtherPersonVC.h"
#import "AppDelegate.h"
#import "XBOffLiveVideoShowVC.h"


#define XBDataCacheForDict @"XBDataCacheForDict.plist"

@interface XBLiveVideoVC ()<SDCycleScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>{
    int height;
}

/** cycleScrollView2 */
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView2;

/** liveTableView */
@property (nonatomic, weak) UITableView *liveTableView;

/** banner数据源 */
@property (nonatomic, strong) NSArray *bannerDataSource,*teacherAry;

@property (nonatomic, strong) ZBYGModel *zbygModel;
@property (nonatomic, strong) ZBModel *zbModel;
@property (nonatomic, strong) FreeModel *freeModel;
@property (nonatomic, strong) HotModel *hotModel;
@property (nonatomic, strong) ZCBModel *zcbModel;
@property (nonatomic, strong) JZCXModel *jzcxModel;
@property (nonatomic, strong) ZDYXModel *zdyxModel;
@property (nonatomic, strong) TeacherModel *teacherModel;

@property (nonatomic, strong) NSMutableArray *dataAry,*cusDataAry,*imageAry;

/** bannerImages */
@property (nonatomic, strong) NSArray *bannerImages;
@property (nonatomic, strong) NSArray *bannerTitles;
@property (nonatomic, strong) NSArray *titleAry;


@property (nonatomic, strong) CusGroupBtnView *cusGroupBtnView;
@property (nonatomic, strong) CusSearchView *cusSearchView;
@property (nonatomic, strong) XBTeacherView *xbteacherView;

@property (nonatomic, assign) BOOL isDownLoadblock;
@property (nonatomic, assign) NSInteger requestCount;

@property (nonatomic, strong) NSDictionary *dataDict;

@end

@implementation XBLiveVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    height = 0;
    self.view.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f2f2f2"];
    
    self.dataDict = [LocalDataRW readDictFromLocalOfDocument:XBDataCacheForDict WithDirectory_Type:Directory_XB];
//    self.cusDataAry = [[NSMutableArray alloc]initWithArray:@[@"行业智库",@"跨行智库",@"建众智库"]];
//    self.imageAry = [[NSMutableArray alloc]initWithArray:@[@"DB_HY",@"DB_KH",@"DB_JZ"]];
    if (self.dataDict) {
        [self dealWithData:self.dataDict];
    }
    [self setupliveTableView];
    
    [self setupBanner];
    
    [self DownLoadData];
}

- (void)DownLoadData
{
   UserInfo *info = [[LoginVM getInstance] readLocal];
    if (!info) {
        info = [[UserInfo alloc]init];
//        info.account = @"13322223333";
//        info.password = @"123456";
        info.token = @"fsdfas";
        
    }
    NSDictionary *parameters = @{
                                 @"access_token":info.token
                                 };
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/Study/getIndex"] parameters:parameters success:^(id json) {
    
        if ([json[@"state"] isEqual:@(0)]) {
//            NSLog(@"TTT--json%@",json);
//            [SVProgressHUD showInfoWithStatus:json[@"info"]];
            if (self.requestCount == 0) {
                //self.isDownLoadblock = YES;
                [LoginVM getInstance].jumpToTab = ^(int state, NSString *info){
                    if (1 == state) {
                        [self.liveTableView.mj_header beginRefreshing];
                        self.requestCount ++;
                    }
                };
//                AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//                
//                if (!appDelegate.checkpay) {
//                    UserInfo *info = [[LoginVM getInstance] readLocal];
//                    if (info && info.account.length > 0) {
//                        
//                    }else{
//                        info = [[UserInfo alloc]init];
//                        info.account = @"13322223333";
//                        info.password = @"123456";
//                    }
//                    [[LoginVM getInstance] loginWithUserInfo:info];
//                }else{
                    [[LoginVM getInstance] loginWithUserInfo:[[LoginVM getInstance] readLocal]];
              //  }
                
                
                //[self.liveTableView.mj_header beginRefreshing];
            }else{
                [self.liveTableView.mj_header endRefreshing];
            }
            
            return ;
        }else {
            
            [LocalDataRW writeDictToLocaOfDocument:json WithDirectory_Type:Directory_XB AtFileName:XBDataCacheForDict];
            self.dataAry = [self dealWithData:json];
            [self.liveTableView reloadData];
        }
        
        [self.liveTableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
       
        [self.liveTableView.mj_header endRefreshing];
        
    }];
}

- (NSMutableArray *)dealWithData:(NSDictionary *)json{
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    self.bannerDataSource = [CourseTimeModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"fouce"][@"fouce_list"]];
    self.cusDataAry = [ThemeListModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"theme"][@"theme_list"]];
    self.zbygModel = [ZBYGModel mj_objectWithKeyValues:json[@"data"][@"zbyg"]];
    self.zbModel = [ZBModel mj_objectWithKeyValues:json[@"data"][@"zb"]];
    self.freeModel = [FreeModel mj_objectWithKeyValues:json[@"data"][@"free"]];
    
    self.hotModel = [HotModel mj_objectWithKeyValues:json[@"data"][@"hot"]];
    self.zcbModel = [ZCBModel mj_objectWithKeyValues:json[@"data"][@"zcb"]];
    self.teacherModel = [TeacherModel mj_objectWithKeyValues:json[@"data"][@"teacher"]];
    self.jzcxModel = [JZCXModel mj_objectWithKeyValues:json[@"data"][@"jzcx"]];
    self.zdyxModel = [ZDYXModel mj_objectWithKeyValues:json[@"data"][@"zdyx"]];
    
    if (self.zbygModel && self.zbygModel.zbyg_list.count > 0) {
        [array addObject:self.zbygModel];
    }
    if (self.zbModel && self.zbModel.zb_list.count > 0) {
        [array addObject:self.zbModel];
    }
    if (self.freeModel && self.freeModel.free_list.count > 0) {
        [array addObject:self.freeModel];
    }
    if (self.hotModel && self.hotModel.hot_list.count > 0) {
        [array addObject:self.hotModel];
    }
    if (self.zcbModel && self.zcbModel.zcb_list.count > 0) {
        [array addObject:self.zcbModel];
    }
    if (self.teacherModel && self.teacherModel.teacher_list.count > 0) {
        [array addObject:self.teacherModel];
    }
    if (self.jzcxModel && self.jzcxModel.jzcx_list.count > 0) {
        [array addObject:self.jzcxModel];
    }
    if (self.zdyxModel && self.zdyxModel.zdyx_list.count > 0) {
        [array addObject:self.zdyxModel];
    }
    
    /** 给banner提供数据 */
    [self HandleBannerData];
    return array;
}


- (XBTeacherView *)xbteacherView{
    if (!_xbteacherView) {
        if (!self.teacherModel) {
            return nil;
        }
        _xbteacherView = [[XBTeacherView alloc]initWithTeacherArr:self.teacherModel.teacher_list WithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 120)];
    }
    return _xbteacherView;
}

- (void)HandleBannerData
{
    self.cycleScrollView2 = nil;
    /** 给banner提供数据 */
    NSMutableArray *arrM_img = [NSMutableArray array];
    NSMutableArray *arrM_title = [NSMutableArray array];
    for (CourseTimeModel *model in self.bannerDataSource) {
        if (model.thumb) {
            //[arrM_img addObject:[AddHostToLoadPIC AddHostToLoadPICWithString:model.thumb]];
            [arrM_img addObject:model.thumb2];
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
    liveTableView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f2f2f2"];
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

}

- (void)setupBanner
{
    
}


#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }else if (section == 1){
        return 0;
    }else if (section == 2){
        return 0;
    }else if (section == 3){
        if (self.dataAry) {
            return self.dataAry.count;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[self.dataAry objectAtIndex:indexPath.row] isKindOfClass:[self.zbygModel class]]) {
        XBBigCell *cell = [tableView dequeueReusableCellWithIdentifier:@"zbygXBBigCell"];
        if (!cell) {
            cell = [[XBBigCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"zbygXBBigCell"];
        }
        cell.zbygModel = [self.dataAry objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if ([[self.dataAry objectAtIndex:indexPath.row] isKindOfClass:[self.zbModel class]]){
        XBBigCell *cell = [tableView dequeueReusableCellWithIdentifier:@"zbXBBigCell"];
        if (!cell) {
            cell = [[XBBigCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"zbXBBigCell"];
        }
        cell.zbModel = [self.dataAry objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }else if ([[self.dataAry objectAtIndex:indexPath.row] isKindOfClass:[self.freeModel class]]){
        XBTwoSmallCell *cell = [tableView dequeueReusableCellWithIdentifier:@"freeSmallCell"];
        if (!cell) {
            cell = [[XBTwoSmallCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"freeSmallCell"];
        }
        cell.freeModel = [self.dataAry objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if ([[self.dataAry objectAtIndex:indexPath.row] isKindOfClass:[self.hotModel class]]){
        XBFourSmallCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hotSmallCell"];
        if (!cell) {
            cell = [[XBFourSmallCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hotSmallCell"];
        }
        cell.hotModel = [self.dataAry objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }else if ([[self.dataAry objectAtIndex:indexPath.row] isKindOfClass:[self.zcbModel class]]){
        XBTwoSmallCell *cell = [tableView dequeueReusableCellWithIdentifier:@"zcbSmallCell"];
        if (!cell) {
            cell = [[XBTwoSmallCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"zcbSmallCell"];
        }
        cell.zcbModel = [self.dataAry objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if ([[self.dataAry objectAtIndex:indexPath.row] isKindOfClass:[self.jzcxModel class]]){
        XBFourSmallCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jzcxSmallCell"];
        if (!cell) {
            cell = [[XBFourSmallCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"jzcxSmallCell"];
        }
        cell.jzcxModel = [self.dataAry objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if ([[self.dataAry objectAtIndex:indexPath.row] isKindOfClass:[self.zdyxModel class]]){
        XBFourSmallCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jzcxSmallCell"];
        if (!cell) {
            cell = [[XBFourSmallCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"jzcxSmallCell"];
        }
        cell.zdyxModel = [self.dataAry objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if ([[self.dataAry objectAtIndex:indexPath.row] isKindOfClass:[self.teacherModel class]]){
        TeacherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"teacherCell"];
        if (!cell) {
            cell = [[TeacherCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"teacherCell"];
        }
        cell.teacherModel = [self.dataAry objectAtIndex:indexPath.row];
        __block typeof (self) wself = self;
        if (!cell.xbteacherView) {
            cell.xbteacherView = self.xbteacherView;
            cell.xbteacherView.returnAction = ^(NSInteger tag){
                PublicOtherPersonVC *othervc = [[UIStoryboard storyboardWithName:@"PublicOtherPersonVC" bundle:nil]instantiateInitialViewController];
                othervc.view.backgroundColor = [UIColor whiteColor];
                
                Users *user = [Users mj_objectWithKeyValues:[wself.teacherModel.teacher_list objectAtIndex:tag]];
                othervc.user = user;
                othervc.fromDynamicDetailVC = YES;
                if ([othervc.user.uid isEqualToString:[LoginVM getInstance].readLocal._id] || othervc.user.uid == nil) {
                    return ;
                }
                
                self.navigationController.navigationBar.hidden = YES;
                self.tabBarController.tabBar.hidden = YES;
                [self.navigationController pushViewController:othervc animated:YES];
            };
            [cell.contentView addSubview:self.xbteacherView];
            UIView *intevalView = [[UIView alloc]initWithFrame:CGRectMake(0, self.xbteacherView.frame.origin.y + self.xbteacherView.frame.size.height, SCREEN_WIDTH, 12)];
            [intevalView setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
            [cell.contentView addSubview:intevalView];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 45)];
//    
//    [headerView setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f8f8f8"]];
    
    if (section == 0) {
        return self.cycleScrollView2;
        
    }else if (section == 1) {
        
        return self.cusGroupBtnView;
        
    }else if (section == 2) {
        return self.cusSearchView;
       
    }
    return nil;
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
    __weak typeof (self) wself = self;
    _cycleScrollView2.clickItemOperationBlock = ^(NSInteger index) {
        
//        AppDelegate *delegate = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
//        if (!delegate.checkpay) {
//            XBOffLiveVideoShowVC *mobilevideoShowVC = [[XBOffLiveVideoShowVC alloc] init];
//            mobilevideoShowVC.videoURL = [NSURL URLWithString:@"http://bang.jianzhongbang.com/1.mp4"];
//            [[ZJBHelp getInstance].studyBaRootVC presentViewController:mobilevideoShowVC animated:YES completion:nil];
//            return ;
//        }
        
        //跳转
        LiveVideoViewController *vc = [LiveVideoViewController new];
        
        CourseTimeModel *item = wself.bannerDataSource[index];
        if ([item.label isEqualToString:@"直播预告"]) {
            vc.isBackVideo = NO;
        }else if([item.label isEqualToString:@"正在直播"]){
            vc.isBackVideo = NO;
        }else{
            vc.isBackVideo = YES;
        }
        vc.item = item;
        
        if (!vc.item) {
            [SVProgressHUD showInfoWithStatus:@"网络不顺畅"];
            return ;
        }
        
        vc.hidesBottomBarWhenPushed = YES;
        [wself.navigationController pushViewController:vc animated:YES];
        
    };
    
    return _cycleScrollView2;
}

- (CusGroupBtnView *)cusGroupBtnView{
    if (!_cusGroupBtnView) {
        if (!self.cusDataAry) {
            return nil;
        }
        _cusGroupBtnView = [[CusGroupBtnView alloc]initWithSeleterConditionTitleArr:self.cusDataAry WithImageAry:self.imageAry WithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
        __weak typeof (self) wself = self;
        _cusGroupBtnView.returnAction = ^(NSInteger tag){
            ThemeListModel *themeModel = [wself.cusDataAry objectAtIndex:tag];
            if (0 == [themeModel.id integerValue]) {
                XBStudyTypeVC *studyTypeVC = [[XBStudyTypeVC alloc]init];
                [wself.navigationController pushViewController:studyTypeVC animated:YES];
                return ;
            }else {
                XBTypeListVC *typeListVC = [[XBTypeListVC alloc]init];
                typeListVC.tag = @"selectTheme";
                typeListVC.code_id = themeModel.id;
                typeListVC.title = themeModel.name;
                [wself.navigationController pushViewController:typeListVC animated:YES];
            }
//            XBCourseTimeListVC *vc = [[XBCourseTimeListVC alloc]init];
//            vc.tag = tag;
//            [wself.navigationController pushViewController:vc animated:YES];
        };
    }
    
    return _cusGroupBtnView;
}

- (UIView *)cusSearchView{
    if (!_cusSearchView) {
        _cusSearchView = [[CusSearchView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 58)];
        __weak typeof (self) wself = self;
        _cusSearchView.returnAction = ^(NSInteger tag){
            XBSearchVC *xbSearch = [[XBSearchVC alloc]init];
            [wself.navigationController pushViewController:xbSearch animated:YES];
        };
    }
    return _cusSearchView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 ) {
        return 150;
    }else if (section == 1) {
        return 90;
    }else if (section == 2){
        return 58;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == height) {
        if (fabs((double)MAX(Main_Screen_Width, Main_Screen_Height) - (double)568) < DBL_EPSILON) {
            height = 95;
            
        }else if (fabs((double)MAX(Main_Screen_Width, Main_Screen_Height) - (double)736) < DBL_EPSILON){
            height = 115;
            
        }else if (fabs((double)MAX(Main_Screen_Width, Main_Screen_Height) - (double)667) < DBL_EPSILON){
            height = 115;
        }
    }
    if ([[self.dataAry objectAtIndex:indexPath.row] isKindOfClass:[self.zbygModel class]]) {
        return 40 + 150 + 9 + 39 + 12;
    }else if ([[self.dataAry objectAtIndex:indexPath.row] isKindOfClass:[self.zbModel class]]){
        return 40 + 150 + 9 + 39 + 12;
    }else if ([[self.dataAry objectAtIndex:indexPath.row] isKindOfClass:[self.freeModel class]]){
        return 40 + height + 8 + 39 + 12;
    }else if ([[self.dataAry objectAtIndex:indexPath.row] isKindOfClass:[self.hotModel class]]){
        int heigth;
        heigth = 40 + height + 8 + 39 + 12;
        if (self.hotModel.hot_list.count > 1) {
            heigth = 40 + height + 8 + 39 + 12;
        }
        if (self.hotModel.hot_list.count > 2) {
            heigth = 40 + (height + 8 + 39) * 2 + 12 - 8;
        }
        return heigth;
        
    }else if ([[self.dataAry objectAtIndex:indexPath.row] isKindOfClass:[self.zcbModel class]]){
        return 40 + height + 8 + 39 + 12;
    }else if ([[self.dataAry objectAtIndex:indexPath.row] isKindOfClass:[self.jzcxModel class]]){
        int heigth;
        heigth = 40 + height + 8 + 39 + 12 ;
        if (self.jzcxModel.jzcx_list.count > 1) {
            heigth = 40 + height + 8 + 39 + 12;
        }
        if (self.jzcxModel.jzcx_list.count > 2) {
            heigth = 40 + (height + 8 + 39) * 2 + 12 - 8;
        }
        return heigth;
    }else if ([[self.dataAry objectAtIndex:indexPath.row] isKindOfClass:[self.zdyxModel class]]){
        int heigth;
        heigth = 40 + height + 8 + 39 + 12;
        if (self.zdyxModel.zdyx_list.count > 1) {
            heigth = 40 + height + 8 + 39 + 12;
        }
        if (self.zdyxModel.zdyx_list.count > 2) {
            heigth = 40 + (height + 8 + 39) * 2 + 12 - 8;
        }
        return heigth;
    }else if ([[self.dataAry objectAtIndex:indexPath.row] isKindOfClass:[self.teacherModel class]]){
        return 40 + 120 + 12;
    }
    return 0;
}

- (void)tapMoreLivelabel
{
    SendedCourseTimeListVC *vc = [SendedCourseTimeListVC new];
    
    vc.isRootVCComing = YES;
    vc.liveType = @"2";
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tapMorePreLivelabel
{
    SendedCourseTimeListVC *vc = [SendedCourseTimeListVC new];
    
    vc.isRootVCComing = YES;
    vc.liveType = @"1";
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
