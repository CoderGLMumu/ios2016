//
//  NewFeatureViewController.m
//  JZBRelease
//
//  Created by Apple on 16/11/7.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "NewFeatureViewController.h"
#import "NewFeatureCellCollectionViewCell.h"

#define GLItemCount 3

@interface NewFeatureViewController ()

//上一次的offset.x
@property (nonatomic ,assign) CGFloat preOffsetX;

//guide1ImageV
@property (nonatomic , weak) UIImageView *guide1ImageV;

@property (nonatomic,strong) UIPageControl* pageControl;

/**
 *  当前页码
 */
@property (nonatomic,assign) NSInteger currentIndex;

@end

@implementation NewFeatureViewController

#define kPageControlHeight 40.0f

static NSString * const reuseIdentifier = @"FeatureViewControllerCell";



- (instancetype)init {
    //流水布局
    UICollectionViewFlowLayout *flowL = [[UICollectionViewFlowLayout alloc] init];
    //设置每一个格子的大小
    flowL.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    //设置最小行间距
    flowL.minimumLineSpacing = 0;
    //设置每个格子之间的间距
    flowL.minimumInteritemSpacing = 0;
    
    //设置滚动的方向
    flowL.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    return [super initWithCollectionViewLayout:flowL];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //使用CollectionView时必须得要注册Cell
    [self.collectionView registerClass:[NewFeatureCellCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    //取消弹簧效果
    self.collectionView.bounces = NO;
    self.collectionView.pagingEnabled = YES;
    
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    //添加子控件
    [self setUp];
}

- (void)setUp {
    
    [self.view addSubview:self.pageControl];
    
//    //guideLine
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guideLine"]];
    imageV.glx_x -= 150;
    [self.collectionView addSubview:imageV];
//
//    //guide1
    UIImageView *guide1ImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide1"]];
    
    guide1ImageV.glx_x += 50;
    self.guide1ImageV = guide1ImageV;
    [self.collectionView addSubview:guide1ImageV];
//
//    //guideLargeText3
//    //guide1
//    UIImageView *largeTextImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guideLargeText3"]];
//    largeTextImageV.center = CGPointMake(self.view.width * 0.5, self.view.height * 0.7);
//    [self.collectionView addSubview:largeTextImageV];
//    
//    //guideSmallText1
//    UIImageView *smallTextImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guideSmallText1"]];
//    smallTextImageV .center = CGPointMake(self.view.width * 0.5, self.view.height * 0.8);
//    [self.collectionView addSubview:smallTextImageV];
   
}

//当scorllVeiw减速时调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView  {
    
//    CGFloat offset = scrollView.contentOffset.x - self.preOffsetX;
//    
//    //NSLog(@"%f",scrollView.contentOffset.x);
//    
//    self.preOffsetX = scrollView.contentOffset.x;
//    self.guide1ImageV.x += 2 * offset;
//    
//    [UIView animateWithDuration:0.5 animations:^{
//        self.guide1ImageV.x -= offset;
//    }];
//    
//    // NSLog(@"--offset--%f",offset);
//    
//    //计算当前是多少页
//    int page = scrollView.contentOffset.x / self.collectionView.width;
//    NSLog(@"%d",page);
//    //给guide1ImageV重新设置图片
//    
//    self.guide1ImageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"guide%d",page + 1]];
}

#pragma mark <UICollectionViewDataSource>
//总共有多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

//每一组里有多少个格子(Item)
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return GLItemCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //创建自定义的Cel
    NewFeatureCellCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    
    //设置Cell的图片
    
    NSString *filename = [NSString stringWithFormat:@"guideBG%ld@3x",indexPath.item + 1];
    NSString *file = [[NSBundle mainBundle] pathForResource:filename ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:file];
    cell.image = image;
//    cell.image = [UIImage imageNamed:[NSString stringWithFormat:@"guideBG%ld",indexPath.item + 1]];
    //设置立即体验按钮是否隐藏显示
    [cell setStartBtnHidden:indexPath count:GLItemCount];
    
    //NSLog(@"%ld",indexPath.item);
    //NSLog(@"%p",cell);
    return cell;
}


- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0f,
                                                                       GLScreenH - kPageControlHeight - 72.0f,
                                                                       GLScreenW,
                                                                       kPageControlHeight)];
        _pageControl.numberOfPages = GLItemCount;
        _pageControl.currentPage = self.currentIndex;
        _pageControl.userInteractionEnabled = NO;
        _pageControl.currentPageIndicatorTintColor = [UIColor hx_colorWithHexRGBAString:@"FF9800"];
    }
    return _pageControl;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.x;
    NSInteger index = offset / GLScreenW;
    self.currentIndex = index;
    self.pageControl.currentPage = self.currentIndex;
    
}

- (BOOL)shouldAutorotate
{
    
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
