//
//  CustomAlertView.h
//  JZBRelease
//
//  Created by zjapple on 16/6/13.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetValueObject.h"
@interface CustomAlertView : UIAlertView

+ (instancetype)defaultCustomAlertView:(NSString *) type;

@property(nonatomic, strong)UILabel *label;
@end
