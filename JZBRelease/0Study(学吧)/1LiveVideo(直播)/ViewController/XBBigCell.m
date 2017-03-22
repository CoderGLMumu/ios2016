//
//  XBBigCell.m
//  JZBRelease
//
//  Created by cl z on 16/10/12.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "XBBigCell.h"
#import "XBTypeListVC.h"
#import "Defaults.h"
#import "LiveVideoViewController.h"

#import "AppDelegate.h"
#import "XBLiveMobileVideoShowVC.h"

@implementation XBBigCell{
    UIView *intevalView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setZbygModel:(ZBYGModel *)zbygModel{
    if (!self.titleView) {
        self.titleView = [XBTitleView initTypeStr:zbygModel.title WithFrame:CGRectMake(0, 0, GLScreenW, 40)];
        [self.titleView.btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.titleView];
    }
    [self.titleView updateTypeWithModel:zbygModel];
    
    if (!self.bigView) {
        CourseTimeModel *model = [CourseTimeModel mj_objectWithKeyValues:[zbygModel.zbyg_list objectAtIndex:0]];
        self.bigView = [XBBigView initWithModel:model WithFrame:CGRectMake(0, 40, GLScreenW, 159 + 39)];
        self.bigView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [self.bigView addGestureRecognizer:tap];
        [self.contentView addSubview:self.bigView];
    }
    CourseTimeModel *model = [CourseTimeModel mj_objectWithKeyValues:[zbygModel.zbyg_list objectAtIndex:0]];
    [self.bigView updateWithModel:model];
    if (!intevalView) {
        intevalView = [[UIView alloc]initWithFrame:CGRectMake(0, 40 + 150 + 9 + 39, GLScreenW, 12)];
        [intevalView setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
        UIView *top = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GLScreenW, 0.8)];
        [top setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"e2e2e2"]];
        [intevalView addSubview:top];
        UIView *bottom = [[UIView alloc]initWithFrame:CGRectMake(0, 11.2, GLScreenW, 0.8)];
        [bottom setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"e2e2e2"]];
        [intevalView addSubview:bottom];
        [self.contentView addSubview:intevalView];
    }

}

- (void)setZbModel:(ZBModel *)zbModel{
    if (!self.titleView) {
        self.titleView = [XBTitleView initTypeStr:zbModel.title WithFrame:CGRectMake(0, 0, GLScreenW, 40)];
        [self.titleView.btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.titleView];
    }
    [self.titleView updateTypeWithModel:zbModel];
    
    if (!self.bigView) {
        CourseTimeModel *model = [CourseTimeModel mj_objectWithKeyValues:[zbModel.zb_list objectAtIndex:0]];
        self.bigView = [XBBigView initWithModel:model WithFrame:CGRectMake(0, 40, GLScreenW, 159 + 39)];
        self.bigView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [self.bigView addGestureRecognizer:tap];
        [self.contentView addSubview:self.bigView];
    }
    CourseTimeModel *model = [CourseTimeModel mj_objectWithKeyValues:[zbModel.zb_list objectAtIndex:0]];
    [self.bigView updateWithModel:model];
    if (!intevalView) {
        intevalView = [[UIView alloc]initWithFrame:CGRectMake(0, 40 + 150 + 9 + 39, GLScreenW, 12)];
        [intevalView setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
        UIView *top = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GLScreenW, 0.8)];
        [top setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"e2e2e2"]];
        [intevalView addSubview:top];
        UIView *bottom = [[UIView alloc]initWithFrame:CGRectMake(0, 11.2, GLScreenW, 0.8)];
        [bottom setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"e2e2e2"]];
        [intevalView addSubview:bottom];
        [self.contentView addSubview:intevalView];
    }
}


- (void) btnAction:(UIButton *)btn{
    XBTypeListVC *typeListVC = [[XBTypeListVC alloc]init];
    ZBModel *model = (ZBModel *)self.titleView.model;
    typeListVC.tag = model.tag;
    [[ZJBHelp getInstance].studyBaRootVC.navigationController pushViewController:typeListVC animated:YES];
    
//    AppDelegate *delegate = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
//    
//    if (!delegate.checkpay) {
//        
//        
//        
//        
//        
//        XBLiveMobileVideoShowVC *mobilevideoShowVC = [[XBLiveMobileVideoShowVC alloc] init];
//        
//        mobilevideoShowVC.playUrl = @"http://bang.jianzhongbang.com/1.mp4";
//        
//        [[ZJBHelp getInstance].studyBaRootVC presentViewController:mobilevideoShowVC animated:YES completion:nil];
//        return ;
//    }
    
}


- (void)tapAction:(UITapGestureRecognizer *)tap{
    XBBigView *bigView = (XBBigView *)tap.view;
    LiveVideoViewController *vc = [[LiveVideoViewController alloc]init];
    vc.item = bigView.model;
    vc.isBackVideo = NO;
    [[ZJBHelp getInstance].studyBaRootVC.navigationController pushViewController:vc animated:YES];
}


@end
