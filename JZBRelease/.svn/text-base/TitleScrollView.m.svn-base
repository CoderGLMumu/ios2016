//
//  TitleScrollView.m
//  JZBRelease
//
//  Created by cl z on 16/8/24.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "TitleScrollView.h"
#import "Defaults.h"

@interface TitleScrollView()<UIScrollViewDelegate>{
    int pre;
}

@property(nonatomic,retain)NSArray *vcArr;
@property(nonatomic,retain)NSMutableArray *vcArray;
@property(nonatomic,copy)ScrollPage scrollPage;
@property(nonatomic,assign) BOOL zero,first,two,three;
@end

@implementation TitleScrollView

-(instancetype)initWithSeleterConditionTitleArr:(NSArray *)vcArr
                                  withDefaultVC:(UIViewController *) vc
                                    andBtnBlock:(ScrollPage)page
                                      withFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        self.vcArray = [[NSMutableArray alloc]init];
        [self.vcArray addObject:vc];
        pre = 0;
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        _vcArr = vcArr;
        [self lazyLoadVcFromIndex:0];
        self.pagingEnabled = YES;
        NSLog(@"self.frame.size.height%f",self.frame.size.height);
        self.contentSize = CGSizeMake(SCREEN_WIDTH * vcArr.count,0);
        self.delegate = self;
        self.scrollPage = page;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}



-(void)updateVCViewFromIndex:(NSInteger )index
{
    //    [self lazyLoadVcFromIndex:index];
    [self setContentOffset:CGPointMake(index*SCREEN_WIDTH, 0) animated:YES];
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
        vc.view.frame = CGRectMake(0,0, SCREEN_WIDTH,self.frame.size.height);
        [self addSubview:vc.view];
        
        self.zero = YES;
    }else{
        if (1 == index) {
            if (self.first) {
                return;
            }
            vc = [[NSClassFromString([self.vcArr objectAtIndex:index]) alloc]init];
//            vc = [[UIStoryboard storyboardWithName:@"BQRMRootVC" bundle:nil]instantiateInitialViewController];
            [self.superVC addChildViewController:vc];
            vc.view.frame = CGRectMake(SCREEN_WIDTH*index,0, SCREEN_WIDTH,self.frame.size.height);
            [self addSubview:vc.view];
            self.first = YES;
        }
        if (2 == index) {
            if (self.two) {
                return;
            }
            vc = [[NSClassFromString([self.vcArr objectAtIndex:index]) alloc]init];
            vc.view.frame = CGRectMake(SCREEN_WIDTH*index,0, SCREEN_WIDTH,self.frame.size.height);
            [self addSubview:vc.view];
            self.two = YES;
        }
        if (3 == index) {
            if (self.three) {
                return;
            }
            vc = [[NSClassFromString([self.vcArr objectAtIndex:index]) alloc]init];
            vc.view.frame = CGRectMake(SCREEN_WIDTH*index,0, SCREEN_WIDTH,self.frame.size.height);
            [self addSubview:vc.view];
            self.three = YES;
        }
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    int page = (scrollView.contentOffset.x)/SCREEN_WIDTH;
    if (page == pre) {
        return;
    }
    [self lazyLoadVcFromIndex:page];
    pre = page;
    self.hit = NO;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = (scrollView.contentOffset.x + SCREEN_WIDTH/2)/SCREEN_WIDTH;
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


@end
