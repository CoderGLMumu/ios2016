//
//  BBRootVC.m
//  JZBRelease
//
//  Created by zjapple on 16/7/7.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "BBRootVC.h"
#import "BBPersonalVC.h"
#import "SelecterToolsScrolView.h"
#import "Defaults.h"
#import "SelecterContentScrollView.h"
#import "BBHotVC.h"
#import "BBRankingVC.h"
#import "BBQuestionsVC.h"
#import "BBActivityVC.h"
#import "SendActivityVC.h"
#import "PopupView.h"
#import "LewPopupViewAnimationDrop.h"
#import "BBActivityDetailVC.h"
#import "BBQuestionDetailVC.h"
#import "QuestionsModel.h"
#import "QuestionEditVC.h"
#import "OtherPersonCentralVC.h"
#import "BBQuestionSearchVC.h"
#import "BBActivitySearchVC.h"
#import "TitleToolsView.h"
#import "TitleScrollView.h"
#import "BBQuestionsNewVC.h"
#import "RankingVC.h"
#import "CommChanceVC.h"
#import "SendCommerChanceVC.h"
#import "BBQuestionThirdVC.h"
#import "BQRMRootVC.h"
#import "PublicLogOutUser.h"

@interface BBRootVC ()<UISearchBarDelegate>{
    int preSelector;
    UIView *rightView;
    NSInteger whichIndex;
    UISearchBar *searchBar;
}

@property(nonatomic, retain) NSArray *titleArr;
@property(nonatomic, retain) TitleToolsView *titleToolsView;
@property(nonatomic,retain)NSMutableArray *vcArr;
@property(nonatomic,retain)TitleScrollView *contentScrView;


@end

@implementation BBRootVC

-(instancetype)init{
    self = [super init];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [ZJBHelp getInstance].bbRootVC = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //[[ZJBHelp getInstance] configNav:self WithLOrR:LEFT ImageName:@"BB_filter" Action:@selector(rankingAction)];
   // AppDelegate *appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    //if (appD.checkpay) {
        [self configNav];
   // }
    
    NSArray *titleAry = @[@"问答"];
    self.titleToolsView = [TitleToolsView getInstanceWithTitleAry:titleAry DefaultSelectIndex:0 SelectTitleColor:[UIColor whiteColor] NotSelectTitleColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_NotSelect_Color" WithKind:XMLTypeColors]] SelectTitleFont:[UIFont systemFontOfSize:17] NotSelectTitleFont:[UIFont systemFontOfSize:15]];
    __weak typeof (self) wself = self;
    self.titleToolsView.returnAction = ^(NSInteger index){
        [wself.contentScrView updateVCViewFromIndex:index];
        [wself exchangeState:index];
    };
    self.navigationItem.titleView = self.titleToolsView;
    _vcArr = [NSMutableArray array];
    [_vcArr addObject:NSStringFromClass([BBQuestionThirdVC class])];
    

   // [_vcArr addObject:NSStringFromClass([BQRMRootVC class])];

//    [_vcArr addObject:NSStringFromClass([BQRMRootVC class])];

    
//    [_vcArr addObject:NSStringFromClass([CommChanceVC class])];
    
    //[_vcArr addObject:NSStringFromClass([UIViewController class])];
    [self createContentVCSrc];

}

-(void)configNav
{
    [[ZJBHelp getInstance] configNav:self WithLOrR:RIGHT ImageName:@"BR_FB" Action:@selector(sendQuestionOrActivity)];
    //11 20
//    UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 35)];
////    UIImageView *shareImageView1 = [UIImageView createImageViewWithFrame:CGRectMake(20, (35-20)/2, 20, 20) ImageName:@"WD_search"];
////    [shareView addSubview:shareImageView1];
//    
//    UIButton *shareImageView2 = [[UIButton alloc]initWithFrame:CGRectMake(30, (35-20)/2, 20, 20)];
//    [shareImageView2 setImage:[UIImage imageNamed:@"WD_release"] forState:UIControlStateNormal];
//    [shareView addSubview:shareImageView2];
//    shareImageView2.userInteractionEnabled = YES;
//    [shareImageView2 addTarget:self action:@selector(sendQuestionOrActivity) forControlEvents:UIControlEventTouchUpInside];
//    
////    UIControl *share1 = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 40, 35)];
////    [share1 addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
////    [shareView addSubview:share1];
//    UIControl *share2 = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 50, 35)];
//    [share2 addTarget:self action:@selector(sendQuestionOrActivity) forControlEvents:UIControlEventTouchUpInside];
//    [shareView addSubview:share2];
//    UIBarButtonItem *rifhtBtnItem = [[UIBarButtonItem alloc] initWithCustomView:shareView];
//    self.navigationItem.rightBarButtonItem = rifhtBtnItem;
    
}


- (void)exchangeState:(NSInteger) index{
    whichIndex = index;
    if (2 == index) {
        //[[ZJBHelp getInstance] configNav:self WithLOrR:LEFT ImageName:@"BB_filter" Action:@selector(rankingAction)];
        [[ZJBHelp getInstance] configNav:self WithLOrR:RIGHT ImageName:@"" Action:nil];
    }else if (0 == index || 1 == index){
        //[[ZJBHelp getInstance] configNav:self WithLOrR:LEFT ImageName:@"BB_filter" Action:@selector(rankingAction)];
        [self configNav];
        //[[ZJBHelp getInstance] configNav:self WithLOrR:RIGHT ImageName:@"WD_release" Action:@selector(sendQuestionOrActivity)];
    }
}

/** 不开放排行榜 */
- (void)rankingAction{
//    RankingVC *rankingVC = [RankingVC new];
//    
//    [self.navigationController pushViewController:rankingVC animated:YES];
    
}

- (void)searchAction{
    if (0 == whichIndex) {
        BBQuestionSearchVC *searchVC = [[BBQuestionSearchVC alloc]init];
        [self presentViewController:searchVC animated:YES completion:^{
            
        }];
    }else if(1 == whichIndex){
        BBActivitySearchVC *searchVC = [[BBActivitySearchVC alloc]init];
        [self presentViewController:searchVC animated:YES completion:^{
            
        }];
    }
}

- (void)sendQuestionOrActivity{
    
    if ([LoginVM getInstance].users) {
        
    }else {
//        [PublicLogOutUser logOutUser:self.navigationController];
        [PublicLogOutUser logOutUser:self.navigationController netWorkLoOut:YES];
        return ;
    }
    
    GLLog(@"%@",[LoginVM getInstance].users);
    GLLog(@"%@",[LoginVM getInstance].users);
    GLLog(@"%@",[LoginVM getInstance].users);
    
    AppDelegate *appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
   // if (appD.checkpay) {
        if (!appD.vip) {
            [UIView bch_showWithTitle:@"提示" message:@"查看问答详情要先加入建众帮会员哦！" buttonTitles:@[@"取消",@"确定"] callback:^(id sender, NSUInteger buttonIndex) {
                if (1 == buttonIndex) {
                   // AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                    
                   // if (appDelegate.checkpay) {
                        ApplyVipVC *applyVipVC = [[ApplyVipVC alloc]init];
                        [self.navigationController pushViewController:applyVipVC animated:YES];
                   // }
                }
            }];
            return;
        };

   // }else{
   //     [SVProgressHUD showSuccessWithStatus:@"该功能暂未开发，敬请期待"];
        //AppDelegate *appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
     //   return;
//        if (!appD.checkpay) {
//            
//            return;
//        }
  //  }
    if (0 == whichIndex) {
        QuestionEditVC *sendVC = [[QuestionEditVC alloc]init];
        [self.navigationController pushViewController:sendVC animated:YES];
        self.tabBarController.tabBar.hidden = YES;
    }else if(1 == whichIndex){
        SendCommerChanceVC *activityVC = [[SendCommerChanceVC alloc]init];
        [self.navigationController pushViewController:activityVC animated:YES];
        self.tabBarController.tabBar.hidden = YES;
    }
}

-(void)createContentVCSrc
{
    __weak typeof(self) weakSelf = self;
    BBQuestionThirdVC *defaultVC = [[BBQuestionThirdVC alloc]init];
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

@end
