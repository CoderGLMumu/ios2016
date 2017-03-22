//
//  SelecterContentScrollView.m
//  SelecterTools
//
//  Created by zhao on 16/3/15.
//  Copyright © 2016年 xincheng. All rights reserved.
//

#import "SelecterContentScrollView.h"


#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height


@interface SelecterContentScrollView ()<UIScrollViewDelegate>

@property(nonatomic,retain)NSArray *vcArr;
@property(nonatomic,retain)NSMutableArray *vcArray;
@property(nonatomic,copy)ScrollPage scrollPage;
@property(nonatomic,assign) BOOL zero,first,two,three;
@end

@implementation SelecterContentScrollView{
    int pre;
}



-(instancetype)initWithSeleterConditionTitleArr:(NSArray *)vcArr withDefaultVC:(UIViewController *) vc andBtnBlock:(ScrollPage)page
{
    self = [super init];
    if (self) {
        self.vcArray = [[NSMutableArray alloc]init];
        [self.vcArray addObject:vc];
        pre = 0;
        self.frame = CGRectMake(0,108,WIDTH,HEIGHT-108 - 49);
        self.backgroundColor = [UIColor whiteColor];
        _vcArr = vcArr;
        [self lazyLoadVcFromIndex:0];
        self.pagingEnabled = YES;
        NSLog(@"self.frame.size.height%f",self.frame.size.height);
        self.contentSize = CGSizeMake(WIDTH * vcArr.count,self.frame.size.height);
        self.delegate = self;
        self.scrollPage = page;
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}



-(void)updateVCViewFromIndex:(NSInteger )index
{
//    [self lazyLoadVcFromIndex:index];
    [self setContentOffset:CGPointMake(index*WIDTH, 0) animated:YES];
//    [self lazyLoadVcFromIndex:index];
//    pre = (int)index;
}

//懒加载策略
-(void)lazyLoadVcFromIndex:(NSInteger )index
{
    UIViewController *vc;
    if (0 == index) {
        if (self.zero) {
            return;
        }
        vc = [self.vcArray objectAtIndex:index];
        vc.view.frame = CGRectMake(0,0, WIDTH,self.frame.size.height);
        [self addSubview:vc.view];
        self.zero = YES;
    }else{
        if (1 == index) {
            if (self.first) {
                return;
            }
            vc = [[NSClassFromString([self.vcArr objectAtIndex:index]) alloc]init];
            vc.view.frame = CGRectMake(WIDTH*index,0, WIDTH,self.frame.size.height);
            [self addSubview:vc.view];
            self.first = YES;
        }
        if (2 == index) {
            if (self.two) {
                return;
            }
            vc = [[NSClassFromString([self.vcArr objectAtIndex:index]) alloc]init];
            vc.view.frame = CGRectMake(WIDTH*index,0, WIDTH,self.frame.size.height);
            [self addSubview:vc.view];
            self.two = YES;
        }
        if (3 == index) {
            if (self.three) {
                return;
            }
            vc = [[NSClassFromString([self.vcArr objectAtIndex:index]) alloc]init];
            vc.view.frame = CGRectMake(WIDTH*index,0, WIDTH,self.frame.size.height);
            [self addSubview:vc.view];
            self.three = YES;
        }
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    int page = (scrollView.contentOffset.x)/WIDTH;
    if (page == pre) {
        return;
    }
    [self lazyLoadVcFromIndex:page];
    pre = page;
    self.hit = NO;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = (scrollView.contentOffset.x + WIDTH/2)/WIDTH;
    if (page == pre) {
        return;
    }
    if (self.hit) {
        return;
    }
    self.scrollPage(page);
    NSLog(@"pre is %d",pre);
    NSLog(@"pre is %d",page);
    [self lazyLoadVcFromIndex:page];
    pre = page;

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
