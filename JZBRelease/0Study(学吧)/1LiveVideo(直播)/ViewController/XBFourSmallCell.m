//
//  XBFourSmallCell.m
//  JZBRelease
//
//  Created by cl z on 16/10/12.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "XBFourSmallCell.h"
#import "LiveVideoViewController.h"
#import "ZJBHelp.h"
#import "XBTypeListVC.h"
#import "ZBModel.h"

#import "AppDelegate.h"
#import "XBLiveMobileVideoShowVC.h"
#import "Defaults.h"
@implementation XBFourSmallCell{
    UIView *intevalView;
    int heights;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setHotModel:(HotModel *)hotModel{
    if (heights == 0) {
        if (fabs((double)MAX(Main_Screen_Width, Main_Screen_Height) - (double)568) < DBL_EPSILON) {
            heights = 95;
            
        }else if (fabs((double)MAX(Main_Screen_Width, Main_Screen_Height) - (double)736) < DBL_EPSILON){
            heights = 115;
            
        }else if (fabs((double)MAX(Main_Screen_Width, Main_Screen_Height) - (double)667) < DBL_EPSILON){
            heights = 115;
        }
    }
    int height;
    if (!self.titleView) {
        self.titleView = [XBTitleView initTypeStr:hotModel.title WithFrame:CGRectMake(0, 0, GLScreenW, 40)];
        [self.titleView.btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.titleView];
    }
    [self.titleView updateTypeWithModel:hotModel];
    if (!self.smallView0) {
        self.smallView0 = [[XBSmallView alloc]initWithFrame:CGRectMake(0, 40, GLScreenW / 2, heights + 8 + 39)];
        self.smallView0.isTwoSmall = NO;
        self.smallView0.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [self.smallView0 addGestureRecognizer:tap];
        [self.contentView addSubview:self.smallView0];
    }
    [self.smallView0 updateWithModel:[CourseTimeModel mj_objectWithKeyValues:[hotModel.hot_list objectAtIndex:0]]];
    height = 40 + heights + 8 + 39;
    if (hotModel.hot_list.count > 1) {
        if (!self.smallView1) {
            self.smallView1 = [[XBSmallView alloc]initWithFrame:CGRectMake(GLScreenW / 2, 40, GLScreenW / 2, heights + 8 + 39)];
            self.smallView1.isTwoSmall = YES;
            self.smallView1.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
            [self.smallView1 addGestureRecognizer:tap];
            [self.contentView addSubview:self.smallView1];
        }
        [self.smallView1 updateWithModel:[CourseTimeModel mj_objectWithKeyValues:[hotModel.hot_list objectAtIndex:1]]];
    }
    if (hotModel.hot_list.count > 2) {
        if (!self.smallView2) {
            self.smallView2 = [[XBSmallView alloc]initWithFrame:CGRectMake(0, 40 + heights + 39, GLScreenW / 2, heights  + 39)];
            self.smallView2.isTwoSmall = NO;
            self.smallView2.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
            [self.smallView2 addGestureRecognizer:tap];
            [self.contentView addSubview:self.smallView2];
        }
        [self.smallView2 updateWithModel:[CourseTimeModel mj_objectWithKeyValues:[hotModel.hot_list objectAtIndex:2]]];
        height = 40 + (heights + 8 + 39) * 2 - 8;
    }
    if (hotModel.hot_list.count > 3) {
        if (!self.smallView3) {
            self.smallView3 = [[XBSmallView alloc]initWithFrame:CGRectMake(GLScreenW / 2, 40 + heights  + 39, GLScreenW / 2, heights + 39)];
            self.smallView3.isTwoSmall = YES;
            self.smallView3.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
            [self.smallView3 addGestureRecognizer:tap];
            [self.contentView addSubview:self.smallView3];
        }
        [self.smallView3 updateWithModel:[CourseTimeModel mj_objectWithKeyValues:[hotModel.hot_list objectAtIndex:3]]];
    }
    if (!intevalView) {
        intevalView = [[UIView alloc]init];
        [intevalView setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
        UIView *top = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GLScreenW, 0.8)];
        [top setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"e2e2e2"]];
        [intevalView addSubview:top];
        UIView *bottom = [[UIView alloc]initWithFrame:CGRectMake(0, 11.2, GLScreenW, 0.8)];
        [bottom setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"e2e2e2"]];
        [intevalView addSubview:bottom];
        [self addSubview:intevalView];
    }
    [intevalView setFrame:CGRectMake(0, height, GLScreenW, 12)];
}


- (void)setJzcxModel:(JZCXModel *)jzcxModel{
    if (heights == 0) {
        if (fabs((double)MAX(Main_Screen_Width, Main_Screen_Height) - (double)568) < DBL_EPSILON) {
            heights = 95;
            
        }else if (fabs((double)MAX(Main_Screen_Width, Main_Screen_Height) - (double)736) < DBL_EPSILON){
            heights = 115;
            
        }else if (fabs((double)MAX(Main_Screen_Width, Main_Screen_Height) - (double)667) < DBL_EPSILON){
            heights = 115;
        }
    }
    int height;
    if (!self.titleView) {
        self.titleView = [XBTitleView initTypeStr:jzcxModel.title WithFrame:CGRectMake(0, 0, GLScreenW, 40)];
        [self.titleView.btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.titleView];
    }
    [self.titleView updateTypeWithModel:jzcxModel];
    if (!self.smallView0) {
        self.smallView0 = [[XBSmallView alloc]initWithFrame:CGRectMake(0, 40, GLScreenW / 2, heights + 8 + 39)];
        self.smallView0.isTwoSmall = NO;
        self.smallView0.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [self.smallView0 addGestureRecognizer:tap];
        [self.contentView addSubview:self.smallView0];
    }
    [self.smallView0 updateWithModel:[CourseTimeModel mj_objectWithKeyValues:[jzcxModel.jzcx_list objectAtIndex:0]]];
    height = 40 + heights + 8 + 39;
    if (jzcxModel.jzcx_list.count > 1) {
        if (!self.smallView1) {
            self.smallView1 = [[XBSmallView alloc]initWithFrame:CGRectMake(GLScreenW / 2, 40, GLScreenW / 2, heights + 8 + 39)];
            self.smallView1.isTwoSmall = YES;
            self.smallView1.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
            [self.smallView1 addGestureRecognizer:tap];
            [self.contentView addSubview:self.smallView1];
        }
        [self.smallView1 updateWithModel:[CourseTimeModel mj_objectWithKeyValues:[jzcxModel.jzcx_list objectAtIndex:1]]];
    }
    if (jzcxModel.jzcx_list.count > 2) {
        if (!self.smallView2) {
            self.smallView2 = [[XBSmallView alloc]initWithFrame:CGRectMake(0, 40 + heights  + 39, GLScreenW / 2, heights + 39)];
            self.smallView2.isTwoSmall = NO;
            self.smallView2.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
            [self.smallView2 addGestureRecognizer:tap];
            [self.contentView addSubview:self.smallView2];
        }
        [self.smallView2 updateWithModel:[CourseTimeModel mj_objectWithKeyValues:[jzcxModel.jzcx_list objectAtIndex:2]]];
        height = 40 + (heights + 8 + 39) * 2 - 8;
    }
    if (jzcxModel.jzcx_list.count > 3) {
        if (!self.smallView3) {
            self.smallView3 = [[XBSmallView alloc]initWithFrame:CGRectMake(GLScreenW / 2, 40 + heights  + 39, GLScreenW / 2, heights  + 39)];
            self.smallView3.isTwoSmall = YES;
            self.smallView3.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
            [self.smallView3 addGestureRecognizer:tap];
            [self.contentView addSubview:self.smallView3];
        }
        [self.smallView3 updateWithModel:[CourseTimeModel mj_objectWithKeyValues:[jzcxModel.jzcx_list objectAtIndex:3]]];
    }
    if (!intevalView) {
        intevalView = [[UIView alloc]init];
        [intevalView setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
        UIView *top = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GLScreenW, 0.8)];
        [top setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"e2e2e2"]];
        [intevalView addSubview:top];
        UIView *bottom = [[UIView alloc]initWithFrame:CGRectMake(0, 11.2, GLScreenW, 0.8)];
        [bottom setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"e2e2e2"]];
        [intevalView addSubview:bottom];
        [self addSubview:intevalView];
    }
    [intevalView setFrame:CGRectMake(0, height, GLScreenW, 12)];
}

- (void)setZdyxModel:(ZDYXModel *)zdyxModel{
    if (heights == 0) {
        if (fabs((double)MAX(Main_Screen_Width, Main_Screen_Height) - (double)568) < DBL_EPSILON) {
            heights = 95;
            
        }else if (fabs((double)MAX(Main_Screen_Width, Main_Screen_Height) - (double)736) < DBL_EPSILON){
            heights = 115;
            
        }else if (fabs((double)MAX(Main_Screen_Width, Main_Screen_Height) - (double)667) < DBL_EPSILON){
            heights = 115;
        }
    }

    int height;
    if (!self.titleView) {
        self.titleView = [XBTitleView initTypeStr:zdyxModel.title WithFrame:CGRectMake(0, 0, GLScreenW, 40)];
        [self.titleView.btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.titleView];
    }
    [self.titleView updateTypeWithModel:zdyxModel];
    if (!self.smallView0) {
        self.smallView0 = [[XBSmallView alloc]initWithFrame:CGRectMake(0, 40, GLScreenW / 2, heights + 8 + 39)];
        self.smallView0.isTwoSmall = NO;
        self.smallView0.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [self.smallView0 addGestureRecognizer:tap];
        [self.contentView addSubview:self.smallView0];
    }
    [self.smallView0 updateWithModel:[CourseTimeModel mj_objectWithKeyValues:[zdyxModel.zdyx_list objectAtIndex:0]]];
    height = 40 + heights + 8 + 39;
    
    if (zdyxModel.zdyx_list.count > 1) {
        if (!self.smallView1) {
            self.smallView1 = [[XBSmallView alloc]initWithFrame:CGRectMake(GLScreenW / 2, 40, GLScreenW / 2, heights + 8 + 39)];
            self.smallView1.isTwoSmall = YES;
            self.smallView1.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
            [self.smallView1 addGestureRecognizer:tap];
            [self.contentView addSubview:self.smallView1];
        }
        [self.smallView1 updateWithModel:[CourseTimeModel mj_objectWithKeyValues:[zdyxModel.zdyx_list objectAtIndex:1]]];
    }
    if (zdyxModel.zdyx_list.count > 2) {
        if (!self.smallView2) {
            self.smallView2 = [[XBSmallView alloc]initWithFrame:CGRectMake(0, 40 + heights  + 39, GLScreenW / 2, heights  + 39)];
            self.smallView2.isTwoSmall = NO;
            self.smallView2.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
            [self.smallView2 addGestureRecognizer:tap];
            [self.contentView addSubview:self.smallView2];
        }
        [self.smallView2 updateWithModel:[CourseTimeModel mj_objectWithKeyValues:[zdyxModel.zdyx_list objectAtIndex:2]]];
        height = 40 + (heights + 8 + 39) * 2 - 8;
        
    }
    if (zdyxModel.zdyx_list.count > 3) {
        if (!self.smallView3) {
            self.smallView3 = [[XBSmallView alloc]initWithFrame:CGRectMake(GLScreenW / 2, 40 + heights  + 39, GLScreenW / 2, heights + 39)];
            self.smallView3.isTwoSmall = YES;
            self.smallView3.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
            [self.smallView3 addGestureRecognizer:tap];
            [self.contentView addSubview:self.smallView3];
        }
        [self.smallView3 updateWithModel:[CourseTimeModel mj_objectWithKeyValues:[zdyxModel.zdyx_list objectAtIndex:3]]];
    }
//    if (!intevalView) {
//        intevalView = [[UIView alloc]init];
//        [intevalView setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
//        UIView *top = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GLScreenW, 0.8)];
//        [top setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"e2e2e2"]];
//        [intevalView addSubview:top];
//        UIView *bottom = [[UIView alloc]initWithFrame:CGRectMake(0, 11.2, GLScreenW, 0.8)];
//        [bottom setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"e2e2e2"]];
//        [intevalView addSubview:bottom];
//        [self addSubview:intevalView];
//    }
//    [intevalView setFrame:CGRectMake(0, height, GLScreenW, 12)];
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
//    if (!delegate.checkpay) {
//        XBLiveMobileVideoShowVC *mobilevideoShowVC = [[XBLiveMobileVideoShowVC alloc] init];
//        
//        mobilevideoShowVC.playUrl = @"http://bang.jianzhongbang.com/1.mp4";
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
