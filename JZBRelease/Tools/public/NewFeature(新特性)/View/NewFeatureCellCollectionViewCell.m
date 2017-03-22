//
//  NewFeatureCellCollectionViewCell.m
//  JZBRelease
//
//  Created by Apple on 16/11/7.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "NewFeatureCellCollectionViewCell.h"
#import "LoginVC.h"
#import "AppDelegate.h"
#import "HomeTabBarVC.h"

@interface NewFeatureCellCollectionViewCell ()

//背景图片ImageV
@property (nonatomic , weak) UIImageView *imageV;
//立即体验按钮
@property (nonatomic, weak) UIButton *startBtn;


@end

@implementation NewFeatureCellCollectionViewCell

//懒加载立即体验按钮
- (UIButton *)startBtn {
    
    if (_startBtn == nil) {
        UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [startBtn setImage:[UIImage imageNamed:@"guideStart"] forState:UIControlStateNormal];
        //自适应大小
        [startBtn sizeToFit];
        //设置按钮位置
        startBtn.center = CGPointMake(self.glw_width * 0.5, self.glh_height * 0.8);
        _startBtn = startBtn;
        [self.contentView addSubview:startBtn];
        //监听按钮的点击
        [startBtn addTarget:self action:@selector(startBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}

//点击开始按钮时调用
- (void)startBtnClick {
    //判断是否是游客进入
//     AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    if (!appDelegate.checkpay) {
//        HomeTabBarVC *tabVC = [[HomeTabBarVC alloc]init];
//        [tabVC.view setBackgroundColor:[UIColor whiteColor]];
//        tabVC.selectedIndex = 0;
//        [UIApplication sharedApplication].keyWindow.rootViewController = tabVC;
//        return;
//    }

    //跳到应用程序的主框架
    LoginVC *loginVC = [[LoginVC alloc]init];
    GLNAVC *naviVC = [[GLNAVC alloc]initWithRootViewController:loginVC];
    
    [UIApplication sharedApplication].keyWindow.rootViewController = naviVC;
}


//懒加载图片
- (UIImageView *)imageV {
    
    if (_imageV == nil) {
        UIImageView *imageV = [[UIImageView alloc] init];
        //设置图片的尺寸大小
        imageV.frame = self.bounds;
        [self.contentView addSubview:imageV];
        _imageV = imageV;
    }
    return _imageV;
}

////设置立即体验按钮是否隐藏显示
- (void)setStartBtnHidden:(NSIndexPath *)indexPath count:(int)count {
    
    //如果是最后一个item
    if (indexPath.item == count - 1) {
        //立即体验按钮显示
        self.startBtn.hidden = NO;
    }else {
        //立即体验按钮隐藏
        self.startBtn.hidden = YES;
    }
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageV.image = image;
}



@end
