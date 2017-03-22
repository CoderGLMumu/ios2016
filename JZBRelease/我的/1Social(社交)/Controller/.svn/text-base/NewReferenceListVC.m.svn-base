//
//  NewBusinessListVC.m
//  JZBRelease
//
//  Created by Apple on 16/11/2.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "NewReferenceListVC.h"
#import "CommerChanceCell.h"

#import "MoreCommerChanceVC.h"
#import "BBActivityDetailVC.h"
#import "CommerChanceCellModel.h"
#import "MJRefresh.h"
#import "pushNotificationCell.h"
#import "BCH_Alert.h"
#import "ApplyVipVC.h"

@interface NewReferenceListVC ()<UITableViewDelegate,UITableViewDataSource>

/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataSource;

/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** num */
@property (nonatomic, assign) int pageN;

@end

@implementation NewReferenceListVC

static NSString *ID = @"NewReferenceCell";

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"推荐人";
    
    self.pageN = 1;
    self.pageN = 0;
    
    [self setupTableView];
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
    
}

- (void)setupTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, GLScreenW, GLScreenH - 64) style:UITableViewStylePlain];
    
    //    [tableView registerClass:[JSCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    
    [tableView registerNib:[UINib nibWithNibName:@"pushNotificationCell" bundle:nil] forCellReuseIdentifier:ID];
    
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
    
    // 告诉tabelView在编辑模式下可以多选
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    //    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    //
    //
    //        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:CachesNotificationQuestion];
    //
    //        if (arr.count > self.pageN + 1) {
    //            self.pageN ++;
    //        }else {
    //            [SVProgressHUD showInfoWithStatus:@"没有更多数据了"];
    //            [self.tableView.mj_header endRefreshing];
    //            return ;
    //        }
    //
    //        [self loadData];
    //    }];
}

#pragma mark - 更新数据源-数据
- (void)loadData
{
    //    NSMutableArray *arrM = [NSMutableArray array];
    
    NSArray *arr2 = [NSKeyedUnarchiver unarchiveObjectWithFile:CachesNotificationReference];
    
    [self.dataSource removeAllObjects];
    
    [self.dataSource addObjectsFromArray:arr2];
    
    [self.tableView reloadData];
    
    //    //    [self downloadData:self.pageN];
    //    if (arr.count <= 0) return;
    //
    //    NSDictionary *parameters = @{
    //                                 @"access_token":[LoginVM getInstance].readLocal.token,
    //                                 @"id":arr[arr.count - 1 - self.pageN]
    //                                 };
    //
    //    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/Question/get"] parameters:parameters success:^(id json) {
    //
    //        publicBaseDJsonItem *item = [publicBaseDJsonItem mj_objectWithKeyValues:json];
    //
    //        if ([item.state isEqual:@(0)]) {
    //            [SVProgressHUD show];
    //        }
    //
    ////        CommerChanceCellModel *model = [CommerChanceCellModel mj_objectWithKeyValues:item.data];
    ////
    ////        [arrM addObject:model];
    ////
    ////        //    [self.dataSource removeAllObjects];
    ////        [self.dataSource addObjectsFromArray:arrM];
    ////
    //
    //
    //
    //        [self.dataSource addObjectsFromArray:arrM];
    //
    //        [self.tableView reloadData];
    //
    //        [self.tableView.mj_header endRefreshing];
    //
    //        //            NSLog(@"TTT--json%@",json);
    //    } failure:^(NSError *error) {
    //
    //    }];
    
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

- (pushNotificationCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    pushNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.item = self.dataSource[indexPath.row];
    
    
    //    if (!cell) {
    //        cell = [[QuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    //    }
    //    if (self.dataSource.count > indexPath.row) {
    //        QuestionsLayout* cellLayouts = self.dataSource[indexPath.row];
    //        cell.cellLayout = cellLayouts;
    //    }
    //    cell.delegate = self;
    //    cell.indexPath = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    AppDelegate *appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    if (!appD.vip) {
//        [UIView bch_showWithTitle:@"请加入建众帮" message:@"我要加入" buttonTitles:@[@"取消",@"确定"] callback:^(id sender, NSUInteger buttonIndex) {
//            if (1 == buttonIndex) {
//                AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//                
//                if (appDelegate.checkpay) {
//                    ApplyVipVC *applyVipVC = [[ApplyVipVC alloc]init];
//                    [self.navigationController pushViewController:applyVipVC animated:YES];
//                }
//            }
//        }];
//        return;
//    };
    
    [UIView bch_showWithTitle:@"用户通过确认" message:@"请确定是否通过推荐该用户" buttonTitles:@[@"通过",@"拒绝",@"取消"] callback:^(id sender, NSUInteger buttonIndex) {
        
        if (buttonIndex == 0 || buttonIndex == 1) {
            NSString *status;
            if (buttonIndex == 0) {
                status = @"1";
            }else if (buttonIndex == 1){
                status = @"2";
            }
            
            if (self.dataSource.count > indexPath.row) {
                PushextrasItem *item = self.dataSource[indexPath.row];
//                GLLog(@"%@",item.id)
                
                // 调用 业务 确定通过推荐，进入建众帮
                NSDictionary *parameters = @{
                                             @"access_token":[LoginVM getInstance].readLocal.token,
                                             @"user_id":item.id,
                                             @"status":status
                                             };
                
                [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/Friend/get"] parameters:parameters success:^(id json) {
                    
//                    publicBaseJsonItem *item = [publicBaseJsonItem mj_objectWithKeyValues:json];
//                    
//                    if ([item.state isEqual:@(0)]) {
//                        [SVProgressHUD showInfoWithStatus:@""];
//                    }else {
//                        [SVProgressHUD showInfoWithStatus:@"操作完成"];
//                    }
                    
                    //            NSLog(@"TTT--json%@",json);
                } failure:^(NSError *error) {
                    
                }];
                //
                //    
            }
        }
        
    }];
    
    
    
        
        
        //        layout.questionsModel.row = [NSNumber numberWithInteger:indexPath.row];
        //        BBQuestionDetailVC *vc = [[BBQuestionDetailVC alloc]init];
        //        vc.questionModel = layout.questionsModel;
        //        [ZJBHelp getInstance].bbRootVC.tabBarController.tabBar.hidden = YES;
        //        [[ZJBHelp getInstance].bbRootVC.navigationController pushViewController:vc animated:YES];
        //        [self setHidesBottomBarWhenPushed:YES];
//    }
    
    //    CommerChanceCellModel *model = [self.dataSource objectAtIndex:indexPath.row];
    //    BBActivityDetailVC *vc = [[BBActivityDetailVC alloc]init];
    //    vc.model = model;
    //    vc.activity_id = model.activity_id;
    //
    //    [self.navigationController pushViewController:vc animated:YES];
    //    [self setHidesBottomBarWhenPushed:YES];
    //    [ZJBHelp getInstance].bbRootVC.tabBarController.tabBar.hidden = YES;
    //[ZJBHelp getInstance].bbRootVC.navigationController.navigationBar.hidden = YES;
    //    [[ZJBHelp getInstance].bbRootVC.navigationController pushViewController:vc animated:YES];
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
    
    if (self.dataSource.count > indexPath.row) {
        
        PushextrasItem *item = self.dataSource[indexPath.row];
        
        return 47 + [self getStringRect:item.content].height;
    }
    return 0;
}


- (CGSize)getStringRect:(NSString*)aString

{
    
    CGSize size;
    
    NSAttributedString* atrString = [[NSAttributedString alloc] initWithString:aString];
    
    NSRange range = NSMakeRange(0, atrString.length);
    
    NSDictionary* dic = [atrString attributesAtIndex:0 effectiveRange:&range];
    
    CGFloat textW;
    
    
    textW = [UIScreen mainScreen].bounds.size.width - 88;
    
    
    size = [aString boundingRectWithSize:CGSizeMake(textW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    return  size;
    
}


/**
 
 
 下面是注释过的代码
 
 
 
 
 */

//static NSString *ID = @"NewBusinessCell";
//
//- (NSMutableArray *)dataSource
//{
//    if (_dataSource == nil) {
//        _dataSource = [NSMutableArray array];
//    }
//    return _dataSource;
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    self.title = @"新商机";
//
//    self.pageN = 1;
//    self.pageN = 0;
//
//    [self setupTableView];
//
//    [self loadData];
//}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//
//    self.tabBarController.tabBar.hidden = YES;
//
//
//}
//
//#pragma mark - 更新数据源-数据
//- (void)loadData
//{
//    NSMutableArray *arrM = [NSMutableArray array];
//
//    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"Message_activity_new"];
//
////    [self downloadData:self.pageN];
//    if (arr.count <= 0) return;
//
//    NSDictionary *parameters = @{
//                                 @"access_token":[LoginVM getInstance].readLocal.token,
//                                 @"id":arr[arr.count - 1 - self.pageN]
//                                 };
//
//    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/Activity/get"] parameters:parameters success:^(id json) {
//
//        publicBaseDJsonItem *item = [publicBaseDJsonItem mj_objectWithKeyValues:json];
//
//        if ([item.state isEqual:@(0)]) {
//            [SVProgressHUD show];
//        }
//
//        CommerChanceCellModel *model = [CommerChanceCellModel mj_objectWithKeyValues:item.data];
//
//        [arrM addObject:model];
//
//        //    [self.dataSource removeAllObjects];
//        [self.dataSource addObjectsFromArray:arrM];
//
//        [self.tableView reloadData];
//
//        [self.tableView.mj_header endRefreshing];
//
//        //            NSLog(@"TTT--json%@",json);
//    } failure:^(NSError *error) {
//
//    }];
//
//}
//
////- (void)downloadData:(NSInteger)num
////{
////    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"Message_activity_new"];
////
////
////
////}
//
//- (void)setupTableView
//{
//    self.automaticallyAdjustsScrollViewInsets = NO;
//
//    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, GLScreenW, GLScreenH - 64) style:UITableViewStylePlain];
//
//    //    [tableView registerClass:[JSCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
//
////    [tableView registerNib:[UINib nibWithNibName:@"gaolinaaa" bundle:nil] forCellReuseIdentifier:ID];
//
////    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    //有数据才有分割线
//    tableView.tableFooterView = [[UIImageView alloc]init];
//
//    tableView.dataSource = self;
//    tableView.delegate = self;
//
//    tableView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f8f8f8"];
////    tableView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:tableView];
//    self.tableView = tableView;
//
//    // 告诉tabelView在编辑模式下可以多选
//    self.tableView.allowsMultipleSelectionDuringEditing = YES;
//
//    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//
//
//        NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"Message_activity_new"];
//
//        if (arr.count > self.pageN + 1) {
//            self.pageN ++;
//        }else {
//            [SVProgressHUD showInfoWithStatus:@"没有更多数据了"];
//            [self.tableView.mj_header endRefreshing];
//            return ;
//        }
//
//        [self loadData];
//    }];
//}
//
//
//#pragma mark - 数据源方法
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    /** 全部列表页面的空数据占位图片 */
//    notDataShowView *view;
//
//    if (self.dataSource.count) {
//        if ([notDataShowView sharenotDataShowView].superview) {
//            [[notDataShowView sharenotDataShowView] removeFromSuperview];
//        }
//    }else {
//        view = [notDataShowView sharenotDataShowView:tableView];
//        [tableView addSubview:view];
//
//    }
//
//    return self.dataSource.count;
//}
//
//- (CommerChanceCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    static NSString* cellIdentifier = @"cellIdentifier";
//    CommerChanceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (!cell) {
//        cell = [[CommerChanceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//    }
//    if (self.dataSource.count > indexPath.row) {
//        [cell updateDetail:[self.dataSource objectAtIndex:indexPath.row]];
//        cell.typebtn.tag = indexPath.row;
//        [cell.typebtn addTarget:self action:@selector(typebtnaction:) forControlEvents:UIControlEventTouchUpInside];
//        cell.lookforbtn.tag = indexPath.row;
//        [cell.lookforbtn addTarget:self action:@selector(lookforbtnaction:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    return cell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 207;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    CommerChanceCellModel *model = [self.dataSource objectAtIndex:indexPath.row];
//    BBActivityDetailVC *vc = [[BBActivityDetailVC alloc]init];
//    vc.model = model;
//    vc.activity_id = model.activity_id;
//
//    [self.navigationController pushViewController:vc animated:YES];
//    [self setHidesBottomBarWhenPushed:YES];
////    [ZJBHelp getInstance].bbRootVC.tabBarController.tabBar.hidden = YES;
//    //[ZJBHelp getInstance].bbRootVC.navigationController.navigationBar.hidden = YES;
////    [[ZJBHelp getInstance].bbRootVC.navigationController pushViewController:vc animated:YES];
//}
//
////分隔线左对齐
//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [tableView setSeparatorInset:UIEdgeInsetsZero];
//    }
//
//    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [tableView setLayoutMargins:UIEdgeInsetsZero];
//    }
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}
//
//- (void)typebtnaction:(UIButton *)btn{
//    if (self.dataSource.count > btn.tag) {
//        CommerChanceCellModel *model = [self.dataSource objectAtIndex:btn.tag];
//        MoreCommerChanceVC *vc = [[MoreCommerChanceVC alloc]init];
//        vc.model = model;
//
//        [self.navigationController pushViewController:vc animated:YES];
//
////        [ZJBHelp getInstance].bbRootVC.tabBarController.tabBar.hidden = YES;
//        //[ZJBHelp getInstance].bbRootVC.navigationController.navigationBar.hidden = YES;
////        [[ZJBHelp getInstance].bbRootVC.navigationController pushViewController:vc animated:YES];
//
//    }
//}
//
//- (void)lookforbtnaction:(UIButton *)btn{
//    if (self.dataSource.count > btn.tag) {
//        CommerChanceCellModel *model = [self.dataSource objectAtIndex:btn.tag];
//        BBActivityDetailVC *vc = [[BBActivityDetailVC alloc]init];
//        vc.activity_id = model.activity_id;
//        vc.model = model;
//
//        [self.navigationController pushViewController:vc animated:YES];
//
////        [ZJBHelp getInstance].bbRootVC.tabBarController.tabBar.hidden = YES;
//        //[ZJBHelp getInstance].bbRootVC.navigationController.navigationBar.hidden = YES;
////        [[ZJBHelp getInstance].bbRootVC.navigationController pushViewController:vc animated:YES];
//    }
//}


@end
