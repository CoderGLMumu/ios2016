//
//  NewBusinessListVC.m
//  JZBRelease
//
//  Created by Apple on 16/11/2.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "NewReferrerVC.h"
#import "CommerChanceCell.h"

#import "MoreCommerChanceVC.h"
#import "BBActivityDetailVC.h"
#import "CommerChanceCellModel.h"
#import "MJRefresh.h"
#import "WDFansCell.h"
#import "BCH_Alert.h"
#import "ApplyVipVC.h"

#import "MySaleList.h"
#import "BCH_Alert.h"

#import "PublicOtherPersonVC.h"

@interface NewReferrerVC ()<UITableViewDelegate,UITableViewDataSource>

/** 数据源 */
@property (nonatomic, strong) NSArray *dataSource;

/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** num */
//@property (nonatomic, assign) int pageN;

@end

@implementation NewReferrerVC

static NSString *ID = @"NewReferrerCell";

//- (NSMutableArray *)dataSource
//{
//    if (_dataSource == nil) {
//        _dataSource = [NSMutableArray array];
//    }
//    return _dataSource;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"审核列表";
    
//    self.pageN = 1;
//    self.pageN = 0;
    
    [self setupTableView];
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)setupTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, GLScreenW, GLScreenH - 64) style:UITableViewStylePlain];
    
    //    [tableView registerClass:[JSCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    
    [tableView registerNib:[UINib nibWithNibName:@"WDFansCell" bundle:nil] forCellReuseIdentifier:ID];
    
    //    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    //    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //有数据才有分割线
    tableView.tableFooterView = [[UIImageView alloc]init];
    
    tableView.dataSource = self;
    tableView.delegate = self;
    
    tableView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f8f8f8"];
    //    tableView.backgroundColor = [UIColor redColor];
    [self.view addSubview:tableView];
    self.tableView = tableView;

}

#pragma mark - 更新数据源-数据
- (void)loadData
{
    
      HttpBaseRequestItem *item = [HttpBaseRequestItem new];
      item.access_token = [[LoginVM getInstance]readLocal].token;
      item.type = @"0";
      NSDictionary *parameters = item.mj_keyValues;
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/User/getMySaleList"] parameters:parameters success:^(id json) {

        jsonBaseItem *item = [jsonBaseItem mj_objectWithKeyValues:json];

        if ([item.state isEqual:@(0)]) {
            [SVProgressHUD showInfoWithStatus:item.info];
        }

//        CommerChanceCellModel *model = [CommerChanceCellModel mj_objectWithKeyValues:item.data];
//
//        [arrM addObject:model];
//
//        //    [self.dataSource removeAllObjects];
//        [self.dataSource addObjectsFromArray:arrM];

        self.dataSource = [MySaleList mj_objectArrayWithKeyValuesArray:item.data];
        
//        MySaleList *test = self.dataSource[0];
//        GLLog(@"%@",test.user.nickname)
//        GLLog(@"%@",test.user.nickname)

        [self.tableView reloadData];

        [self.tableView.mj_header endRefreshing];

        //            NSLog(@"TTT--json%@",json);
    } failure:^(NSError *error) {

    }];
    
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WDFansCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.dataSource.count > indexPath.row) {
        
        
        cell.model = self.dataSource[indexPath.row];
        cell.isReferrer = YES;
    }
    
    __weak typeof(self) wself = self;
    
    cell.callActiveBtn = ^{
    
        // 刷新界面
        [wself loadData];
        
    };
    
    return cell;
    
}

//{
//
//    MySaleList *model = self.dataSource[indexPath.row];
//    
//    if (![model.status isEqualToString:@"0"]) {
//        return ;
//    }
//    
//    [UIView bch_showWithTitle:[NSString stringWithFormat:@"确认用户%@,完成注册建众帮",model.user.nickname] message:@"是否通过注册" buttonTitles:@[@"通过",@"拒绝",@"返回"] callback:^(id sender, NSUInteger buttonIndex) {
//        if (buttonIndex == 0) {
//            
//            HttpBaseRequestItem *item = [HttpBaseRequestItem new];
//            item.access_token = [[LoginVM getInstance]readLocal].token;
//            item.user_id = model.uid;
//            item.status = @"1";
//            NSDictionary *parameters = item.mj_keyValues;
//            
//            [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/User/setSaleStatus"] parameters:parameters success:^(id json) {
//                
//                jsonBaseItem *item = [jsonBaseItem mj_objectWithKeyValues:json];
//                
//                [SVProgressHUD showInfoWithStatus:item.info];
//                
//                [self loadData];
//                
//            } failure:^(NSError *error) {
//                
//            }];
//            
//        }else if (buttonIndex == 1){
//            
//            HttpBaseRequestItem *item = [HttpBaseRequestItem new];
//            item.access_token = [[LoginVM getInstance]readLocal].token;
//            item.user_id = model.uid;
//            item.status = @"2";
//            NSDictionary *parameters = item.mj_keyValues;
//            
//            [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/User/setSaleStatus"] parameters:parameters success:^(id json) {
//                
//                jsonBaseItem *item = [jsonBaseItem mj_objectWithKeyValues:json];
//                
//                [SVProgressHUD showInfoWithStatus:item.info];
//                
//                [self loadData];
//                
//            } failure:^(NSError *error) {
//                
//            }];
//            
//            
//        }
//        
//    }];
//    
//
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     MySaleList *model = self.dataSource[indexPath.row];
    PublicOtherPersonVC *vc = [[UIStoryboard storyboardWithName:@"PublicOtherPersonVC" bundle:nil]instantiateInitialViewController];
    
    Users *user = [Users new];
    user.uid = model.uid;
    
    vc.user = user;
    
    //    vc.fromDynamicDetailVC = YES;
    vc.isSecVCPush = YES;
    vc.isnotRegister = YES;
    
    if ([vc.user.uid isEqualToString:[LoginVM getInstance].readLocal._id] || vc.user.uid == nil) {
        return ;
    }
    
    [self.navigationController setHidesBottomBarWhenPushed:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController pushViewController:vc animated:YES];
    
}

//分隔线左对齐
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 64;
}

@end
