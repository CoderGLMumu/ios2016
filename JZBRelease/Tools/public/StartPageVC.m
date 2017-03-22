//
//  StartPageVC.m
//  JZBRelease
//
//  Created by Apple on 16/12/5.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "StartPageVC.h"

@interface StartPageVC ()

@end

@implementation StartPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    
}

- (void)setupView
{
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"startpage1242"]];
    imageView.frame = CGRectMake(0, 0, GLScreenW, GLScreenH);
    [self.view addSubview:imageView];
    
    imageView.backgroundColor = [UIColor redColor];
    
}



@end
