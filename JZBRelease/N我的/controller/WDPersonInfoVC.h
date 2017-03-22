//
//  WDPersonInfoVC.h
//  JZBRelease
//
//  Created by zjapple on 16/9/3.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDPersonInfoVC : UITableViewController

/** 是自己的信息么 */
@property (nonatomic, assign) BOOL isMine;
/** isZLT */
@property (nonatomic, assign) BOOL isZLT;

@property(nonatomic, strong) Users *user;

/** MyPrelocal */
@property (nonatomic, strong) NSString *MyPrelocal;

@end
