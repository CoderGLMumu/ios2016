//
//  CusNaviVC.m
//  JZBRelease
//
//  Created by cl z on 16/8/31.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "CusNaviVC.h"

@interface CusNaviVC ()

@end

@implementation CusNaviVC
-(instancetype)init{
    self = [super init];
    if (self) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        self = [story instantiateViewControllerWithIdentifier:@"CusNaviVC"];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}



@end
