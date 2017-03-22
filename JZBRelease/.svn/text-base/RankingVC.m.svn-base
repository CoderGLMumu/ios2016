//
//  RankingVC.m
//  JZBRelease
//
//  Created by cl z on 16/9/23.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "RankingVC.h"
#import "SelecterToolsScrolView.h"
#import "Defaults.h"
#import "rankItem.h"
#import "RankingCell.h"
#import "RankTableVC.h"

#import "RankTableTableViewController.h"

#import "GLViewController.h"
#import "LBColorScale.h"

#define titleH 45

@interface RankingVC () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *TitleScrollV;
@property (weak, nonatomic) UIScrollView *contentScrollV;


///** dataSource */
//@property (nonatomic, strong) NSArray *dataSourceW;
///** dataSource */
//@property (nonatomic, strong) NSArray *dataSourceM;
///** dataSource */
//@property (nonatomic, strong) NSArray *dataSourceY;
/** dataSource */
//@property (nonatomic, strong) NSArray *titles;

// 按钮数组
@property(nonatomic , strong)NSMutableArray *btnArr;

// 上一个选中的按钮
@property(nonatomic , strong)UIButton *preBtn;

// 下划线
@property(nonatomic , weak)UIView *underLineView;

// tableViewW
//@property(nonatomic , weak)UITableView *tableViewW;
// tableViewM
//@property(nonatomic , weak)UITableView *tableViewM;
// tableViewY
//@property(nonatomic , weak)UITableView *tableViewY;


/** pages */
@property (nonatomic, assign) NSInteger pages;

@end

@implementation RankingVC

static NSString *ID = @"RankingCellID";

#pragma mark -  懒加载数组
- (NSMutableArray *)btnArr
{
    if (_btnArr == nil) {
        _btnArr = [NSMutableArray array];
    }
    return _btnArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f8f8f8"];
    
    self.pages = 0;
    
//    self.titles = @[@"本周",@"本月",@"年度"];
    [self configNav];
    
    /** 设置导航标题 */
    [self setupchildVC_tableV];
    
    [self setuptitleView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.contentScrollV.contentSize = CGSizeMake(GLScreenW * 3, 0);
    
    self.contentScrollV.pagingEnabled = YES;
    // 设置代理,用来调用滚动完毕触发的方法
    self.contentScrollV.delegate = self;
    
    self.contentScrollV.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f8f8f8"];
    
    // 设置标题按钮
    [self setupTitleScrollView];
    // 设置下划线
    [self setUpUnderLine];
    
}

-(void)configNav
{
    //11 20
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11 + 5 + 40, 35)];
    UIImageView *backImageView = [UIImageView createImageViewWithFrame:CGRectMake(0, (35-20)/2, 20, 20) ImageName:@"DL_light_ARROW"];
    backImageView.userInteractionEnabled = YES;
    [backView addSubview:backImageView];
    //    UILabel *backLabel = [UILabel createLabelWithFrame:CGRectMake(11 + 5,(35-20)/2, 40, 20) Font:17 Text:@"返回" andLCR:0 andColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]]];
    //    [backView addSubview:backLabel];
    UIControl *back = [[UIControl alloc] initWithFrame:backView.bounds];
    [back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:back];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
}

#pragma mark - action
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupchildVC_tableV
{
    
    UIScrollView *scrView = [UIScrollView new];
    [self.view addSubview:scrView];
    scrView.frame = CGRectMake(0, 64 + 44, GLScreenW, GLScreenH - 64 + 44);
    scrView.backgroundColor = [UIColor purpleColor];
    self.contentScrollV = scrView;
//    // 设置frame
    CGFloat x = 0;
//
    RankTableVC *talbe_weekVC = [[RankTableVC alloc]init];
    talbe_weekVC.type = @"1";
    
    talbe_weekVC.title = @"本周";
    
    talbe_weekVC.view.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f8f8f8"];
    x = 0;
    talbe_weekVC.view.frame = CGRectMake(x, 0, GLScreenW, GLScreenH);
    [self.contentScrollV addSubview:talbe_weekVC.view];
    [self addChildViewController:talbe_weekVC];
    
    RankTableVC *talbe_MonthVC = [[RankTableVC alloc]init];
    talbe_MonthVC.type = @"2";
    [self.contentScrollV addSubview:talbe_MonthVC.view];
    [self addChildViewController:talbe_MonthVC];
    talbe_MonthVC.title = @"本月";
    
    talbe_MonthVC.view.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f8f8f8"];;
    x = GLScreenW;
    talbe_MonthVC.view.frame = CGRectMake(x, 0, GLScreenW, GLScreenH);
    talbe_MonthVC.view.userInteractionEnabled = YES;
    
    RankTableVC *talbe_YearVC = [[RankTableVC alloc]init];
    talbe_YearVC.type = @"3";
    [self.contentScrollV addSubview:talbe_YearVC.view];
    [self addChildViewController:talbe_YearVC];
    talbe_YearVC.title = @"年度";
    
    talbe_YearVC.view.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f8f8f8"];;
    x = GLScreenW * 2;
    talbe_YearVC.view.frame = CGRectMake(x, 0, GLScreenW, self.contentScrollV.glh_height);
    
    
}

- (void)setupTableViews
{
    
//    UITableView *tableView_week = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, GLScreenW, GLScreenH) style:UITableViewStylePlain];
//    tableView_week.delegate = self;
//    tableView_week.dataSource = self;
//    [tableView_week registerNib:[UINib nibWithNibName:@"RankingCell" bundle:nil] forCellReuseIdentifier:ID];
//    [self.contentScrollV addSubview:tableView_week];
////    tableView_week.backgroundColor = [UIColor purpleColor];
//    self.tableViewW = tableView_week;
//    
//    UITableView *tableView_month = [[UITableView alloc]initWithFrame:CGRectMake(GLScreenW, 0, GLScreenW, GLScreenH) style:UITableViewStylePlain];
//    tableView_month.delegate = self;
//    tableView_month.dataSource = self;
//    [tableView_week registerNib:[UINib nibWithNibName:@"RankingCell" bundle:nil] forCellReuseIdentifier:ID];
//    [self.contentScrollV addSubview:tableView_month];
////    tableView_month.backgroundColor = [UIColor redColor];
//    self.tableViewM = tableView_month;
//    
//    UITableView *tableView_year = [[UITableView alloc]initWithFrame:CGRectMake(GLScreenW * 2, 0, GLScreenW, GLScreenH) style:UITableViewStylePlain];
//    tableView_year.delegate = self;
//    tableView_year.dataSource = self;
//    [tableView_week registerNib:[UINib nibWithNibName:@"RankingCell" bundle:nil] forCellReuseIdentifier:ID];
//    [self.contentScrollV addSubview:tableView_year];
////    tableView_year.backgroundColor = [UIColor yellowColor];
//    self.tableViewY = tableView_year;
    
    
//    GLViewController *vc = [GLViewController new];
//    
//    [self addChildViewController:vc];
//    [self.contentScrollV addSubview:vc.view];

}

#pragma mark - 【设置】标题按钮
- (void)setupTitleScrollView
{
    NSInteger count = self.childViewControllers.count;
    
    // 设置按钮的frame
    CGFloat btnW = GLScreenW / count;  // 暂时就4个.由于平分,暂时没有滚动效果.
    CGFloat btnH = titleH;
    
    CGFloat btnY = 0;
    
    for (int i = 0; i < count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        // 设置按钮角标
        btn.tag = i;
        
        CGFloat btnX = i * btnW;
        // 按钮尺寸
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [btn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"212121"] forState:UIControlStateNormal];
        [btn setTitle:self.childViewControllers[i].title forState:UIControlStateNormal];
        [btn setFont:[UIFont systemFontOfSize:15]];
        
        // 选中状态的颜色要放到按钮点击事件里面做,不然无法实现按钮颜色的渐变.(被选中的按钮会一直是粉红色)
        //[btn setTitleColor:[UIColor colorWithRed:242/255.0 green:98/255.0 blue:140/255.0 alpha:1] forState:UIControlStateSelected];
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.TitleScrollV addSubview:btn];
        
        // 把按钮放到数组中,是为了让按钮有序地排位,方便在外面通过脚标获取对应按钮
        [self.btnArr addObject:btn];
        
        // 默认按钮选中 "直播"
        if (i == 1) {
            [self btnClick:btn];
            self.contentScrollV.contentOffset = CGPointMake(GLScreenW, 0);
        }
    }
    
#pragma mark -  设置标题滚动区域的滚动范围,尺寸
    // 知道了多少个btn,才能设置scrollView的滚动范围
    self.TitleScrollV.contentSize = CGSizeMake(count * btnW, 0);
    self.TitleScrollV.showsHorizontalScrollIndicator = NO;
    
#pragma mark -  设置内容滚动区域的滚动范围,尺寸
    // 既然是一个btn对应一个界面,那么内容界面的滚动范围也可以在这设置了.
    self.contentScrollV.contentSize = CGSizeMake(count * GLScreenW, 0);
    // 设置为可翻页
    self.contentScrollV.pagingEnabled = YES;
    //清空水平滚动指示条
    self.contentScrollV.showsHorizontalScrollIndicator = NO;
    //取消弹簧效果
    self.contentScrollV.bounces = NO;
    
}

#pragma mark -  标题按钮点击事件
- (void)btnClick:(UIButton *)currentButton
{
    // 恢复上一个按钮选中标题
    [_preBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"212121"] forState:UIControlStateNormal];
    _preBtn.transform = CGAffineTransformIdentity;
    [currentButton setTitleColor:[UIColor hx_colorWithHexRGBAString:@"2195f3"] forState:UIControlStateNormal];
    self.preBtn = currentButton;
    
    // 点击的时候,对文字也进行缩放
    // 标题缩放 -> 如何让标题缩放 改形变
    currentButton.transform = CGAffineTransformMakeScale(1.3, 1.3);
    
    
    // 角标最好从tag取,性能好过遍历数组
    NSInteger index = currentButton.tag;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        // 点击按钮,切换对应角标的子控制器的view
        
            [self changeChildVCInMainSCV:index];
        
        // 让内容滚动条滚动对应位置,就是"直播"出现在第一个位置
        
    } completion:^(BOOL finished) {
        // 动画结束的时候,加载控制器(方便实现懒加载)
        //        [self addCurrentChildView:index];
    }];
}

#pragma mark - 切换内容滚动区域中的View
- (void)changeChildVCInMainSCV:(NSInteger) i
{
    
    // 让内容滚动条滚动对应位置,就是"直播"出现在第一个位置
    CGFloat x = i * GLScreenW;
    // 获得偏移量
    self.contentScrollV.contentOffset = CGPointMake(x, 0);
}

#pragma mark -  设置下划线
- (void)setUpUnderLine
{
    // 获取第一个按钮.因为一开始就是选中的第一个按钮.要的是这个按钮的颜色,文字宽度
    UIButton *secButton = self.btnArr[1];
    
    UIView *underLineView = [[UIView alloc] init];
    CGFloat underLineH = 2;
    CGFloat underLineY = self.TitleScrollV.glh_height - underLineH;
    underLineView.frame = CGRectMake(0, underLineY, GLScreenW / 4, underLineH);
    underLineView.backgroundColor = [secButton titleColorForState:UIControlStateNormal];
//    underLineView.backgroundColor = [UIColor redColor];
    [self.TitleScrollV addSubview:underLineView];
    self.underLineView = underLineView;
    
    //    // 新点击的按钮 -> 红色
    //    firstButton.selected = YES;
    //    self.preButton = firstButton;
    
    // 下划线
    
    self.underLineView.glcx_centerX = secButton.glcx_centerX;
    
}

#pragma mark - ScrollViewDelegate 内容滚动区域滚动完毕调用的代理方法,用来把子控制器添加到内容滚动区域中
// 其实滚动切换mainSCV中的内容,和点击标题按钮切换内容是一样的.不如做成滚动完毕的时候,就相当于点击了对应角标的标题按钮
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 获取当前偏移量和屏幕宽度的商,就是角标
    NSInteger i = scrollView.contentOffset.x / GLScreenW;
    
    self.pages = i;
    
    // 根据对应的角标,获得对应的按钮
    UIButton *btn = self.btnArr[i];
    
    // 调用按钮选中方法.
    // 就相当于滚动完毕后,调用了标题的按钮点击事件.
    [self btnClick:btn];
    
}


#pragma mark -  开始滚动的时候,对按钮文字进行缩放,对颜色进行渐变
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 对字体和颜色进行渐变
    [LBColorScale scaleColor:scrollView withButtonArray:self.btnArr];
    [LBColorScale scaleTitle:scrollView withButtonArray:self.btnArr];
    
    // 下划线随内容scrollView的滚动而滚动,发生位移
    // CGAffineTransformMakeTranslation 方法
    // 左滑: 0到1;
    // 右滑: 0到-1;
    
    CGFloat offset = scrollView.contentOffset.x / GLScreenW - 1;
    
    self.underLineView.transform = CGAffineTransformMakeTranslation(offset * GLScreenW / 3, 0);
}

/** 设置导航标题 */
- (void)setuptitleView
{
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
    titleLable.text = @"排行榜";
    [titleLable sizeToFit];
    titleLable.textColor = [UIColor hx_colorWithHexRGBAString:@"ffffff"];
    titleLable.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLable;
}

@end
