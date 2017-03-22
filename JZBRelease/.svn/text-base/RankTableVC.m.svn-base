//
//  RankTableVC.m
//  JZBRelease
//
//  Created by zjapple on 16/9/26.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "RankTableVC.h"

#import "Defaults.h"
#import "rankItem.h"
#import "RankingCell.h"

#import "PublicOtherPersonVC.h"

@interface RankTableVC ()<UITableViewDelegate,UITableViewDataSource>

// tableView
@property(nonatomic , weak)UITableView *tableView;

// dataSource
@property(nonatomic , strong)NSArray *dataSource;

@end

static NSString *ID = @"RankingCellID";

@implementation RankTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.frame = CGRectMake(0, 0, GLScreenW, GLScreenH - 49 * 2 - 64);
    [self setupTableView];
    
    [self downLoadData];
    
    self.view.userInteractionEnabled = YES;
    
}

- (void)downLoadData
{
    //类型 1本周 2本月 3本年
    
    NSDictionary *parameters1 = @{
                                  @"type":self.type
                                  };
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/User/rank"] parameters:parameters1 success:^(id json) {
        
        self.dataSource = [rankItem mj_objectArrayWithKeyValuesArray:json];
        
        //        [self tableViewreloadData];
        
            [self.tableView reloadData];
        
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不通顺"];
    }];
    
}

- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, GLScreenW, GLScreenH) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerNib:[UINib nibWithNibName:@"RankingCell" bundle:nil] forCellReuseIdentifier:ID];
    [self.view addSubview:tableView];
    tableView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f8f8f8"];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
    
//    tableView.scrollEnabled = YES;
//    tableView.alwaysBounceVertical = YES;
//    tableView.alwaysBounceHorizontal = YES;
//    tableView.scrollEnabled = YES;
//    tableView.pagingEnabled = YES;
//    tableView.showsHorizontalScrollIndicator = YES;
//    tableView.showsVerticalScrollIndicator = YES;

    tableView.contentInset = UIEdgeInsetsMake(9, 0, 64 + 44 + 49, 0);
    
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    /** 全部列表页面的空数据占位图片 */
    notDataShowView *view;
    
    if (self.dataSource.count) {
        if ([notDataShowView sharenotDataShowView].superview) {
            [[notDataShowView sharenotDataShowView] removeFromSuperview];
        }
    }else {
        view = [notDataShowView sharenotDataShowView:tableView];
        [tableView addSubview:view];
        
    }
    
    return self.dataSource.count;
}

- (RankingCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RankingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.topNum = [NSString stringWithFormat:@"%ld",indexPath.row];
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"123123123");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    rankItem *model = self.dataSource[indexPath.row];
    
    PublicOtherPersonVC *vc = [[UIStoryboard storyboardWithName:@"PublicOtherPersonVC" bundle:nil]instantiateInitialViewController];
    vc.user = model.user;
    
    //    vc.fromDynamicDetailVC = YES;
    vc.isSecVCPush = YES;
    
    if ([vc.user.uid isEqualToString:[LoginVM getInstance].readLocal._id] || vc.user.uid == nil) {
        return ;
    }
    
    [self.navigationController setHidesBottomBarWhenPushed:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
