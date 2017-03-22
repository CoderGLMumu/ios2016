//
//  TitleToolsView.h
//  JZBRelease
//
//  Created by cl z on 16/8/24.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleToolsView : UIView

@property(nonatomic, strong) UIButton *preBtn;

+ (TitleToolsView *)getInstanceWithTitleAry:(NSArray *)titleAry
                         DefaultSelectIndex:(NSInteger)selectIndex
                           SelectTitleColor:(UIColor *)selectTitleColor
                        NotSelectTitleColor:(UIColor *)notSelectTitleColor
                            SelectTitleFont:(UIFont *)selectTitleFont
                         NotSelectTitleFont:(UIFont *)notSelectTitleFont;

@property(nonatomic,copy) void (^returnAction)(NSInteger);

- (void)updateState:(NSInteger)index;

@end
