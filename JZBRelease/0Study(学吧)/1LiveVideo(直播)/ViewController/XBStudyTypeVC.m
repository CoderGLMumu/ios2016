//
//  XBStudyTypeVC.m
//  JZBRelease
//
//  Created by cl z on 16/10/13.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "XBStudyTypeVC.h"
#import "Defaults.h"
#import "XBTypeListVC.h"
@interface XBStudyTypeVC (){
    NSInteger preHeight;
    GetValueObject *value;
}

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) NSArray *dataAry;
@end

@implementation XBStudyTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"分类";
    [self.view addSubview:self.scrollView];
    [self DownLoadData];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(UIScrollView *)scrollView{
    if (_scrollView) {
        return _scrollView;
    }
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _scrollView.directionalLockEnabled = YES; //只能一个方向滑动
    _scrollView.pagingEnabled = NO; //是否翻页
    _scrollView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f2f2f2"];
    _scrollView.showsVerticalScrollIndicator =YES; //垂直方向的滚动指示
    _scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;//滚动指示的风格
    _scrollView.showsHorizontalScrollIndicator = NO;//水平方向的滚动指示
    return _scrollView;
}
- (void)DownLoadData
{
    NSDictionary *parameters = @{
                                 @"access_token":[[LoginVM getInstance]readLocal].token
                                 };
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"/Web/Study/type"] parameters:parameters success:^(id json) {

        self.dataAry = json;
        [self initAllViews:self.dataAry];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)initAllViews:(NSArray *) ary{
    for (int i = 0; i < ary.count; i ++) {
        NSDictionary *dict = [ary objectAtIndex:i];
        NSArray *subAry = [dict objectForKey:@"datalist"];
        NSInteger count;
        if (subAry.count % 3 == 0) {
            count = subAry.count / 3;
        }else{
            count = subAry.count / 3 + 1;
        }
        NSInteger height = 50 + 38 + 46 * (count - 1);
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, preHeight, SCREEN_WIDTH, height)];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, (50 - 17.5) / 2, 5.5, 17.5)];
        [imageView setImage:[UIImage imageNamed:@"WD_titleicon"]];
        [view addSubview:imageView];

        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.5 + 6, 0, 160, 50)];
        [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
        [titleLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"212121"]];
        [titleLabel setText:[dict objectForKey:@"title"]];
        [view addSubview:titleLabel];
        
        NSInteger width;
        if (!value) {
            value = [[GetValueObject alloc]init];
        }
        width = (SCREEN_WIDTH - 20 - 16) / 3;
        NSInteger inteval = 10;
        int m = 0,n = 0;
        for (int j = 0; j < subAry.count; j ++) {
            NSDictionary *subDict = [subAry objectAtIndex:j];
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((8 + width) * n + inteval, 50 + m *(38 + 8), width, 38)];
            [btn setBackgroundColor:[UIColor whiteColor]];
            [btn setTitle:[subDict objectForKey:@"name"] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"212121"] forState:UIControlStateNormal];
            btn.tag = i * 10 + 3 * m + n;
            [view addSubview:btn];
            if (n < 2) {
                n ++;
            }else{
                m ++;
                n = 0;
            }
        }
        preHeight += view.frame.size.height;
        [self.scrollView addSubview:view];
        if (i == ary.count - 1) {
            [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, view.frame.origin.y + view.frame.size.height + 50)];
        }
    }
}


- (void) btnAction:(UIButton *)btn{
    XBTypeListVC *typeListVC = [[XBTypeListVC alloc]init];
    NSInteger m = btn.tag / 10;
    NSInteger n = btn.tag % 10;
    if (self.dataAry.count > m) {
        NSDictionary *dict = [self.dataAry objectAtIndex:m];
        typeListVC.tag = [dict objectForKey:@"tag"];
        NSArray *subAry = [dict objectForKey:@"datalist"];
        if (subAry.count > n) {
            NSDictionary *subDict = [subAry objectAtIndex:n];
            typeListVC.code_id = [subDict objectForKey:@"id"];
            typeListVC.title = [subDict objectForKey:@"name"];
            [self.navigationController pushViewController:typeListVC animated:YES];
        }
        
    }
    
    
}

@end
