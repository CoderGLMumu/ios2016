//
//  YZSortInfomationVC.h
//  JZBRelease
//
//  Created by cl z on 16/11/25.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZSortInfomationVC : UIViewController
@property(nonatomic, strong) NSMutableArray *focusedAry;
@property(nonatomic, copy) void (^returnData)(NSMutableArray *focusedAry);
@end
