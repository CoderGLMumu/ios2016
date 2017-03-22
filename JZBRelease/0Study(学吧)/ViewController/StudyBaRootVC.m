//
//  BQRootVC.m
//  JZBRelease
//
//  Created by cl z on 16/8/24.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "StudyBaRootVC.h"
#import "TitleToolsView.h"
#import "BQDynamicVC.h"
#import "BQRenMaiVC.h"
#import "TitleScrollView.h"
#import "Defaults.h"
#import "BQRMRootVC.h"
#import "ZJBHelp.h"
#import "SendDynamicVC.h"
#import "BQFilterVC.h"

#import "XBLiveVideoVC.h"
#import "XBPointVideoVC.h"

#import "MyCourseVC.h"
#import "SendedCourseListVC.h"
#import "SendedCourseTimeListVC.h"

#import "playerDownLoad.h"

#import "AppDelegate.h"
#import "AliVcMoiveViewController.h"


@interface StudyBaRootVC (){
    BOOL isDynamic;
}
@property(nonatomic,retain)NSMutableArray *vcArr;
@property(nonatomic,retain)TitleScrollView *contentScrView;
@property(nonatomic,retain)TitleToolsView *titleToolsView;
@end

@implementation StudyBaRootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    AppDelegate *appD = (AppDelegate*) [UIApplication sharedApplication].delegate;
//    
//    if (!appD.checkpay) {
//        
//        TBMoiveViewController* currentView = [[TBMoiveViewController alloc] init];
//        
//
//        
//        //    NSURL *url = [NSURL URLWithString:@"http://live2.jianzhongbang.com/tset/aaa1234.m3u8"];
//        
//        /** 利哥的直播间 */
//        //    NSURL *url = [NSURL URLWithString:@"http://live2.jianzhongbang.com/test/aaa.flv"];
//        
//        //     NSURL *url = [NSURL URLWithString:@"http://data.5sing.kgimg.com/G065/M08/12/13/gQ0DAFe1GXGADiwUAHTtcKc0Z0A129.mp3"];
//
//        
//        NSURL *url = [NSURL URLWithString:@"http://bang.jianzhongbang.com/1.mp4"];
//        
//        [currentView SetMoiveSource:url];
//        
//        //    [self.view layoutIfNeeded];
//        
//        currentView.videoFrame = CGRectMake(0, 0, GLScreenW, GLScreenH);
//        
//
//        
//        [self addChildViewController:currentView];
//        [self.view addSubview:currentView.view];
//        
//
//        return ;
//    }
    
    [ZJBHelp getInstance].studyBaRootVC = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [[ZJBHelp getInstance] configNav:self WithLOrR:LEFT ImageName:@"XB_DOWN" Action:@selector(pushOffdown)];
    
    [[ZJBHelp getInstance] configNav:self WithLOrR:RIGHT ImageName:@"BR_FB" Action:@selector(addDynamicOrSearch)];
    NSArray *titleAry = @[@"学吧"];
    isDynamic = YES;
    self.titleToolsView = [TitleToolsView getInstanceWithTitleAry:titleAry DefaultSelectIndex:0 SelectTitleColor:[UIColor whiteColor] NotSelectTitleColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_NotSelect_Color" WithKind:XMLTypeColors]] SelectTitleFont:[UIFont systemFontOfSize:17] NotSelectTitleFont:[UIFont systemFontOfSize:15]];
    __weak typeof (self) wself = self;
    self.titleToolsView.returnAction = ^(NSInteger index){
        [wself.contentScrView updateVCViewFromIndex:index];
        [wself exchangeState:index];
    };
    self.navigationItem.titleView = self.titleToolsView;
    _vcArr = [NSMutableArray array];
    [_vcArr addObject:NSStringFromClass([XBLiveVideoVC class])];
   // [_vcArr addObject:NSStringFromClass([XBPointVideoVC class])];
    [self createContentVCSrc];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [SVProgressHUD showSuccessWithStatus:@"登陆成功，增加积分 +2"];
        //[Toast makeShowCommen:@"欢迎," ShowHighlight:@"登陆成功" HowLong:0.8];
    });
    
}

- (void)exchangeState:(NSInteger) index{
    if (0 == index) {
        isDynamic = YES;
        [[ZJBHelp getInstance] configNav:self WithLOrR:RIGHT ImageName:@"BR_FB" Action:@selector(addDynamicOrSearch)];
    }else{
        isDynamic = NO;
        [[ZJBHelp getInstance] configNav:self WithLOrR:RIGHT ImageName:nil Action:@selector(addDynamicOrSearch)];
    }
    
}

//- (void)selectAction{
//    BQFilterVC *filterVC = [[BQFilterVC alloc]init];
//    self.tabBarController.tabBar.hidden = YES;
//    [self.navigationController pushViewController:filterVC animated:YES];
//}

- (void)pushOffdown{
    
    playerDownLoad *vc = [playerDownLoad new];
    
    [self.navigationController pushViewController:vc animated:YES];
//    BQFilterVC *filterVC = [[BQFilterVC alloc]init];
//    self.tabBarController.tabBar.hidden = YES;
//    [self.navigationController pushViewController:filterVC animated:YES];
}

- (void)addDynamicOrSearch{
    if (isDynamic) {
        DataBaseHelperSecond *db = [DataBaseHelperSecond getInstance];
        
        Users *user = [[Users alloc]init];
        user.uid = [[LoginVM getInstance] readLocal]._id;
        user = (Users *)[db getModelFromTabel:user];
//
//        if ([user.is_teacher integerValue] == 1) {
//            SendedCourseTimeListVC *vc = [[SendedCourseTimeListVC alloc]init];
//            
//            [self.navigationController pushViewController:vc animated:YES];
//        }else{
        MyCourseVC *vc = [[MyCourseVC alloc]init];
        if ([user.is_teacher integerValue] == 1) {
            vc.fromXBAndIsTeacher = YES;
        }
        [self.navigationController pushViewController:vc animated:YES];
//        }
    }else{
        //人脉搜索
        
    }
}

-(void)createContentVCSrc
{
    __weak typeof(self) weakSelf = self;
    XBLiveVideoVC *defaultVC = [[XBLiveVideoVC alloc]init];
    [self addChildViewController:defaultVC];
    _contentScrView = [[TitleScrollView alloc]initWithSeleterConditionTitleArr:_vcArr withDefaultVC:defaultVC andBtnBlock:^(int index) {
        [weakSelf updateSelectToolsIndex:index];
    } withFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT- 64 - 49)];
    _contentScrView.superVC = self;
    [self.view addSubview:_contentScrView];
}

-(void)updateSelectToolsIndex:(NSInteger)index{
    [self exchangeState:index];
    [self.titleToolsView updateState:index];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}



@end
