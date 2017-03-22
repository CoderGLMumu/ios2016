//
//  SelecterToolsScrolView.h
//  SelecterTools
//
//  Created by zhao on 16/3/15.
//  Copyright © 2016年 xincheng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^BtnClick)(UIButton *,BOOL hit);


typedef enum : NSUInteger {
    TriggerTypeOfBtnClick,
    TriggerTypeOfScrViewScroll,
} TriggerType;

@interface SelecterToolsScrolView : UIView


-(void)updateSelecterToolsIndex:(NSInteger )index;


-(instancetype)initWithSeleterConditionTitleArr:(NSArray *)titleArr andBtnBlock:(BtnClick)btnClick WithFrame:(CGRect)frame;

@end
