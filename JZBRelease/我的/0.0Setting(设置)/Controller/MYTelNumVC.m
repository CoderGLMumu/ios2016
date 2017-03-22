//
//  MYTelNumVC.m
//  JZBRelease
//
//  Created by zjapple on 16/8/23.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "MYTelNumVC.h"

@interface MYTelNumVC ()
@property (weak, nonatomic) IBOutlet UIButton *ConfirmButton;

@end

@implementation MYTelNumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
}

- (void)setUpView
{
    self.ConfirmButton.layer.cornerRadius = 25;
    self.ConfirmButton.clipsToBounds = YES;
}

@end
