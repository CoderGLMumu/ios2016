//
//  GLAlertView_tip.h
//  JZBRelease
//
//  Created by Apple on 16/11/30.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLAlertView_tip : UIView

+ (instancetype)glAlertView_tip;

@property (weak, nonatomic) IBOutlet UILabel *TtitleView;

/** enterButtonClick */
@property (nonatomic, copy) void(^enterButtonClick)();

@end
