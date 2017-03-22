//
//  NewBusinessListVC.m
//  JZBRelease
//
//  Created by Apple on 16/11/2.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "FocusBusinessListVC.h"
#import "CommerChanceCell.h"

#import "MoreCommerChanceVC.h"
#import "BBActivityDetailVC.h"
#import "CommerChanceCellModel.h"
#import "MJRefresh.h"

#import "GLNAVC.h"
#import "UIImageView+CreateImageView.h"

@interface FocusBusinessListVC ()<UITableViewDelegate,UITableViewDataSource>

/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataSource;

/** tableView */
@property (nonatomic, weak) UITableView *tableView;

///** num */
@property (nonatomic, assign) int pageN;

@end

@implementation FocusBusinessListVC

static NSString *ID = @"FocusBusinessListCell";

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关注的商机";
    
//    self.pageN = 1;
    self.pageN = 0;
    
    [self setupTableView];
    
    [self loadData];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
//    self.tabBarController.tabBar.hidden = YES;
//    
//    
//}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    GLLog(@"%@",self.navigationController);
    if ([self.navigationController isKindOfClass:[GLNAVC class]]) {
        
    }else {
        [self configNav];
    }
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

#pragma mark - 更新数据源-数据
- (void)loadData
{
    NSDictionary *parameters;
    if (self.isOther) {
//        return;
        parameters = @{
                                     @"access_token":[LoginVM getInstance].readLocal.token,
                                     @"page":[NSString stringWithFormat:@"%d",self.pageN],
                                     @"user_id":self.user.uid
                                     //                                 @"id":arr[arr.count - 1 - self.pageN]
                                     };
    }else {
        
        parameters = @{
                                     @"access_token":[LoginVM getInstance].readLocal.token,
                                     @"page":[NSString stringWithFormat:@"%d",self.pageN],
                                     @"user_id":[LoginVM getInstance].readLocal._id
                                     //                                 @"id":arr[arr.count - 1 - self.pageN]
                                     };
    }
    
//    NSDictionary *parameters = @{
//                                 @"access_token":[LoginVM getInstance].readLocal.token,
//                                 @"page":@"0",
//                                 @"user_id":[LoginVM getInstance].readLocal._id
////                                 @"id":arr[arr.count - 1 - self.pageN]
//                                 };
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"/Web/Activity/getLike"] parameters:parameters success:^(id json) {
        [self.tableView.mj_header endRefreshing];
        jsonBaseItem *item = [jsonBaseItem mj_objectWithKeyValues:json];
        
        if ([item.state isEqual:@(0)]) {
            [SVProgressHUD showInfoWithStatus:item.info];
        }
        
        
        NSMutableArray *arrM = [NSMutableArray array];
        if (self.dataSource) {
            [arrM addObjectsFromArray:self.dataSource];
            
            if (self.pageN == 0) {
                [arrM removeAllObjects];
            }
            
        }
        
        [arrM addObjectsFromArray:[CommerChanceCellModel mj_objectArrayWithKeyValuesArray:item.data]];
        
        self.dataSource = arrM;
        
//        self.dataSource = [CommerChanceCellModel mj_objectArrayWithKeyValuesArray:item.data];
//
//        self.dataSource = ;
//
//        
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        //            NSLog(@"TTT--json%@",json);
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

//- (void)downloadData:(NSInteger)num
//{
//    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"Message_activity_new"];
//
//
//
//}

- (void)setupTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, GLScreenW, GLScreenH - 64) style:UITableViewStylePlain];
    
    //    [tableView registerClass:[JSCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    
    //    [tableView registerNib:[UINib nibWithNibName:@"gaolinaaa" bundle:nil] forCellReuseIdentifier:ID];
    
    //    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //有数据才有分割线
//    tableView.tableFooterView = [[UIImageView alloc]init];
    
    tableView.dataSource = self;
    tableView.delegate = self;
    
    tableView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f8f8f8"];
    //    tableView.backgroundColor = [UIColor redColor];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    // 告诉tabelView在编辑模式下可以多选
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.pageN = 0;
        
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
        [self loadData];
    }];
    
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{

        self.pageN++;
        
        [self loadData];
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

- (CommerChanceCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellIdentifier = @"cellIdentifier";
    CommerChanceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[CommerChanceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (self.dataSource.count > indexPath.row) {
        [cell updateDetail:[self.dataSource objectAtIndex:indexPath.row]];
        cell.typebtn.tag = indexPath.row;
        [cell.typebtn addTarget:self action:@selector(typebtnaction:) forControlEvents:UIControlEventTouchUpInside];
        cell.lookforbtn.tag = indexPath.row;
        [cell.lookforbtn addTarget:self action:@selector(lookforbtnaction:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 207;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CommerChanceCellModel *model = [self.dataSource objectAtIndex:indexPath.row];
    BBActivityDetailVC *vc = [[BBActivityDetailVC alloc]init];
    vc.model = model;
    vc.activity_id = model.activity_id;
    
    [self.navigationController pushViewController:vc animated:YES];
    [self setHidesBottomBarWhenPushed:YES];
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

- (void)typebtnaction:(UIButton *)btn{
    if (self.dataSource.count > btn.tag) {
        CommerChanceCellModel *model = [self.dataSource objectAtIndex:btn.tag];
        MoreCommerChanceVC *vc = [[MoreCommerChanceVC alloc]init];
        vc.model = model;
        
        [self.navigationController pushViewController:vc animated:YES];
        
        //        [ZJBHelp getInstance].bbRootVC.tabBarController.tabBar.hidden = YES;
        //[ZJBHelp getInstance].bbRootVC.navigationController.navigationBar.hidden = YES;
        //        [[ZJBHelp getInstance].bbRootVC.navigationController pushViewController:vc animated:YES];
        
    }
}

- (void)lookforbtnaction:(UIButton *)btn{
    if (self.dataSource.count > btn.tag) {
        CommerChanceCellModel *model = [self.dataSource objectAtIndex:btn.tag];
        BBActivityDetailVC *vc = [[BBActivityDetailVC alloc]init];
        vc.activity_id = model.activity_id;
        vc.model = model;
        
        [self.navigationController pushViewController:vc animated:YES];
        
        //        [ZJBHelp getInstance].bbRootVC.tabBarController.tabBar.hidden = YES;
        //[ZJBHelp getInstance].bbRootVC.navigationController.navigationBar.hidden = YES;
        //        [[ZJBHelp getInstance].bbRootVC.navigationController pushViewController:vc animated:YES];
    }
}


@end
