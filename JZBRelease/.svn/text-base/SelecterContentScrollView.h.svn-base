//
//  SelecterContentScrollView.h
//  SelecterTools
//
//  Created by zhao on 16/3/15.
//  Copyright © 2016年 xincheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ScrollPage)(int);

@interface SelecterContentScrollView : UIScrollView

-(void)updateVCViewFromIndex:(NSInteger )index;

@property(nonatomic,assign)BOOL hit;

-(instancetype)initWithSeleterConditionTitleArr:(NSArray *)vcArr withDefaultVC:(UIViewController *) vc andBtnBlock:(ScrollPage)page;



@end
