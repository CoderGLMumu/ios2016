//
//  TitleScrollView.h
//  JZBRelease
//
//  Created by cl z on 16/8/24.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ScrollPage)(int);
@interface TitleScrollView : UIScrollView
-(void)updateVCViewFromIndex:(NSInteger )index;

@property(nonatomic,assign)BOOL hit;

@property(nonatomic,strong) UIViewController *superVC;

-(instancetype)initWithSeleterConditionTitleArr:(NSArray *)vcArr
                                  withDefaultVC:(UIViewController *) vc
                                    andBtnBlock:(ScrollPage)page
                                      withFrame:(CGRect)frame;

@end
