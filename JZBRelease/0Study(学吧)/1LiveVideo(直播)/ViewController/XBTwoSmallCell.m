//
//  XBTwoSmallCell.m
//  JZBRelease
//
//  Created by cl z on 16/10/12.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "XBTwoSmallCell.h"
#import "LiveVideoViewController.h"
#import "ZJBHelp.h"
#import "XBTypeListVC.h"
#import "ZBModel.h"

#import "AppDelegate.h"
#import "XBLiveMobileVideoShowVC.h"
#import "XBOffLiveVideoShowVC.h"
#import "Defaults.h"

@implementation XBTwoSmallCell{
    UIView *intevalView;
    NSInteger height;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setFreeModel:(FreeModel *)freeModel{
    if (height == 0) {
        if (fabs((double)MAX(Main_Screen_Width, Main_Screen_Height) - (double)568) < DBL_EPSILON) {
            height = 95;
            
        }else if (fabs((double)MAX(Main_Screen_Width, Main_Screen_Height) - (double)736) < DBL_EPSILON){
            height = 115;
            
        }else if (fabs((double)MAX(Main_Screen_Width, Main_Screen_Height) - (double)667) < DBL_EPSILON){
            height = 115;
        }
    }
    if (!self.titleView) {
        self.titleView = [XBTitleView initTypeStr:freeModel.title WithFrame:CGRectMake(0, 0, GLScreenW, 40)];
        [self.titleView.btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.titleView];
    }
    [self.titleView updateTypeWithModel:freeModel];
    if (!self.smallView0) {
        self.smallView0 = [[XBSmallView alloc]initWithFrame:CGRectMake(0, 40, GLScreenW / 2, height + 8 + 39)];
        self.smallView0.isTwoSmall = NO;
        self.smallView0.userInteractionEnabled = YES;
        self.smallView0.tag = 10;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [self.smallView0 addGestureRecognizer:tap];
        [self.contentView addSubview:self.smallView0];
    }
    [self.smallView0 updateWithModel:[CourseTimeModel mj_objectWithKeyValues:[freeModel.free_list objectAtIndex:0]]];
    if (freeModel.free_list.count > 1) {
        if (!self.smallView1) {
            self.smallView1 = [[XBSmallView alloc]initWithFrame:CGRectMake(GLScreenW / 2, 40, GLScreenW / 2, height + 8 + 39)];
            self.smallView1.isTwoSmall = YES;
            self.smallView1.userInteractionEnabled = YES;
            self.smallView1.tag = 11;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
            [self.smallView1 addGestureRecognizer:tap];
            [self.contentView addSubview:self.smallView1];
        }
        [self.smallView1 updateWithModel:[CourseTimeModel mj_objectWithKeyValues:[freeModel.free_list objectAtIndex:1]]];

    }
    if (!intevalView) {
        intevalView = [[UIView alloc]initWithFrame:CGRectMake(0, 40 + height + 8 + 39, GLScreenW, 12)];
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

- (void)setZcbModel:(ZCBModel *)zcbModel{
    if (height == 0) {
        if (fabs((double)MAX(Main_Screen_Width, Main_Screen_Height) - (double)568) < DBL_EPSILON) {
            height = 95;
            
        }else if (fabs((double)MAX(Main_Screen_Width, Main_Screen_Height) - (double)736) < DBL_EPSILON){
            height = 115;
            
        }else if (fabs((double)MAX(Main_Screen_Width, Main_Screen_Height) - (double)667) < DBL_EPSILON){
            height = 115;
        }
    }

    if (!self.titleView) {
        self.titleView = [XBTitleView initTypeStr:zcbModel.title WithFrame:CGRectMake(0, 0, GLScreenW, 40)];
        [self.titleView.btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.titleView];
    }
    [self.titleView updateTypeWithModel:zcbModel];
    if (!self.smallView0) {
        self.smallView0 = [[XBSmallView alloc]initWithFrame:CGRectMake(0, 40, GLScreenW / 2, height + 8 + 39)];
        self.smallView0.isTwoSmall = NO;
        self.smallView0.userInteractionEnabled = YES;
        self.smallView0.tag = 12;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [self.smallView0 addGestureRecognizer:tap];

        [self.contentView addSubview:self.smallView0];
    }
    [self.smallView0 updateWithModel:[CourseTimeModel mj_objectWithKeyValues:[zcbModel.zcb_list objectAtIndex:0]]];
    if (zcbModel.zcb_list.count > 1) {
        if (!self.smallView1) {
            self.smallView1 = [[XBSmallView alloc]initWithFrame:CGRectMake(GLScreenW / 2, 40, GLScreenW / 2, height + 8 + 39)];
            self.smallView1.isTwoSmall = YES;
            self.smallView1.userInteractionEnabled = YES;
            self.smallView1.tag = 13;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
            [self.smallView1 addGestureRecognizer:tap];
            [self.contentView addSubview:self.smallView1];
        }
        [self.smallView1 updateWithModel:[CourseTimeModel mj_objectWithKeyValues:[zcbModel.zcb_list objectAtIndex:1]]];
        
    }
    if (!intevalView) {
        intevalView = [[UIView alloc]initWithFrame:CGRectMake(0, 40 + height + 8 + 39, GLScreenW, 12)];
        [intevalView setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
        UIView *top = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GLScreenW, 0.8)];
        [top setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"e2e2e2"]];
        [intevalView addSubview:top];
        UIView *bottom = [[UIView alloc]initWithFrame:CGRectMake(0, 11.2, GLScreenW, 0.8)];
        [bottom setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"e2e2e2"]];
        [intevalView addSubview:bottom];
        [self.contentView addSubview:intevalView];
    }
    
    [intevalView setFrame:CGRectMake(0, 40 + height + 8 + 39, GLScreenW, 12)];

}

- (void) btnAction:(UIButton *)btn{
    XBTypeListVC *typeListVC = [[XBTypeListVC alloc]init];
    ZBModel *model = (ZBModel *)self.titleView.model;
    typeListVC.tag = model.tag;
    typeListVC.title = model.title;
    [[ZJBHelp getInstance].studyBaRootVC.navigationController pushViewController:typeListVC animated:YES];
}


- (void)tapAction:(UITapGestureRecognizer *)tap{
    
//    AppDelegate *delegate = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
//    
//    if (!delegate.checkpay) {
//  
//        XBOffLiveVideoShowVC *mobilevideoShowVC = [[XBOffLiveVideoShowVC alloc] init];
//        
//        mobilevideoShowVC.videoURL = [NSURL URLWithString:@"http://bang.jianzhongbang.com/1.mp4"];
//
//        [[ZJBHelp getInstance].studyBaRootVC presentViewController:mobilevideoShowVC animated:YES completion:nil];
//        return ;
//    }
    
    XBSmallView *smallView = (XBSmallView *)tap.view;
    LiveVideoViewController *vc = [[LiveVideoViewController alloc]init];
    vc.item = smallView.models;
    vc.isBackVideo = YES;
    [[ZJBHelp getInstance].studyBaRootVC.navigationController pushViewController:vc animated:YES];
}

@end
