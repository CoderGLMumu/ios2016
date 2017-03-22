//
//  CusGroupBtnView.h
//  JZBRelease
//
//  Created by cl z on 16/9/20.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CusGroupBtnView : UIView
@property (nonatomic, copy) void (^ returnAction)(NSInteger tag);

- (instancetype)initWithSeleterConditionTitleArr:(NSArray *)titleArr WithImageAry:(NSArray *)imageAry WithFrame:(CGRect)frame;



@end
