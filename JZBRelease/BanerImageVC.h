//
//  BanerImageVC.h
//  JZBRelease
//
//  Created by cl z on 16/8/23.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BanerImageVC : UIViewController


@property(nonatomic, strong) UIImage *image;
@property(nonatomic, copy) void (^returnImage)(UIImage *image,int state);

@end
