//
//  PopupView.h
//  LewPopupViewController
//
//  Created by deng on 15/3/5.
//  Copyright (c) 2015年 pljhonglu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWTextStorage.h"
@interface PopupView : UIView
@property (nonatomic, strong)IBOutlet UIView *innerView;
@property (nonatomic, weak)UIViewController *parentVC;

@property (nonatomic, copy) void (^sendAction)(Clink_Type clink_type);

+ (instancetype)defaultPopupView;
@end
