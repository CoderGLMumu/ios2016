//
//  CusAddOrReduceBtnView.h
//  JZBRelease
//
//  Created by cl z on 16/9/5.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ReturnActionBlock)(NSInteger tag);
@interface CusAddOrReduceBtnView : UIView

@property(nonatomic, strong) NSMutableArray *dataAry;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, copy) ReturnActionBlock returnBlock;
@property(nonatomic, strong) UIButton *addBtn;
+ (instancetype)cusAddOrReduceBtnView:(NSMutableArray *) dataAry;
- (void)initAllViews;
@end
