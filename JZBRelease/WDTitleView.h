//
//  WDTitleView.h
//  JZBRelease
//
//  Created by cl z on 16/11/2.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDTitleView : UIView
+ (WDTitleView *) initTypeStr:(NSString *) str WithFrame:(CGRect) frame;

@property(nonatomic, strong) UIButton *btn;
@property(nonatomic, strong) GetValueObject *model;
- (void) updateTypeWithModel:(GetValueObject *) model;
@end
