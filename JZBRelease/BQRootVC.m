//
//  BQRootVC.m
//  JZBRelease
//
//  Created by cl z on 16/8/24.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "BQRootVC.h"
#import "TitleToolsView.h"
#import "BQDynamicVC.h"
#import "BQRenMaiVC.h"
#import "TitleScrollView.h"
#import "Defaults.h"
#import "BQRMRootVC.h"
#import "ZJBHelp.h"
#import "SendDynamicVC.h"
#import "BQFilterVC.h"
@interface BQRootVC (){
    BOOL isDynamic;
}
@property(nonatomic,retain)NSMutableArray *vcArr;
@property(nonatomic,retain)TitleScrollView *contentScrView;
@property(nonatomic,retain)TitleToolsView *titleToolsView;
@end

@implementation BQRootVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [ZJBHelp getInstance].bqRootVC = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [[ZJBHelp getInstance] configNav:self WithLOrR:LEFT ImageName:@"BQ_DT_filter" Action:@selector(selectAction)];
    [[ZJBHelp getInstance] configNav:self WithLOrR:RIGHT ImageName:@"BR_FB" Action:@selector(addDynamicOrSearch)];
    NSArray *titleAry = @[@"动态",@"人脉"];
    isDynamic = YES;
    self.titleToolsView = [TitleToolsView getInstanceWithTitleAry:titleAry DefaultSelectIndex:0 SelectTitleColor:[UIColor whiteColor] NotSelectTitleColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_NotSelect_Color" WithKind:XMLTypeColors]] SelectTitleFont:[UIFont systemFontOfSize:17] NotSelectTitleFont:[UIFont systemFontOfSize:15]];
    __weak typeof (self) wself = self;
    self.titleToolsView.returnAction = ^(NSInteger index){
        [wself.contentScrView updateVCViewFromIndex:index];
        [wself exchangeState:index];
    };
    self.navigationItem.titleView = self.titleToolsView;
    _vcArr = [NSMutableArray array];
    [_vcArr addObject:NSStringFromClass([BQDynamicVC class])];
    [_vcArr addObject:NSStringFromClass([BQRMRootVC class])];
    [self createContentVCSrc];
}

- (void)exchangeState:(NSInteger) index{
    if (0 == index) {
        isDynamic = YES;
        [[ZJBHelp getInstance] configNav:self WithLOrR:LEFT ImageName:@"BQ_DT_filter" Action:@selector(selectAction)];
        [[ZJBHelp getInstance] configNav:self WithLOrR:RIGHT ImageName:@"BR_FB" Action:@selector(addDynamicOrSearch)];
    }else{
        isDynamic = NO;
        [[ZJBHelp getInstance] configNav:self WithLOrR:LEFT ImageName:@"" Action:nil];
        //[[ZJBHelp getInstance] configNav:self WithLOrR:RIGHT ImageName:@"nav_search" Action:@selector(addDynamicOrSearch)];
    }

}

- (void)selectAction{
    BQFilterVC *filterVC = [[BQFilterVC alloc]init];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:filterVC animated:YES];
}

- (void)addDynamicOrSearch{
    if (isDynamic) {
        SendDynamicVC *sendVC = [[SendDynamicVC alloc]init];
        [self.navigationController pushViewController:sendVC animated:YES];
        self.tabBarController.tabBar.hidden = YES;
    }else{
        //人脉搜索
        
    }
}

-(void)createContentVCSrc
{
    __weak typeof(self) weakSelf = self;
    BQDynamicVC *defaultVC = [[BQDynamicVC alloc]init];
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

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.tabBarController.tabBar.gly_y = GLScreenH - 49;
}

@end
