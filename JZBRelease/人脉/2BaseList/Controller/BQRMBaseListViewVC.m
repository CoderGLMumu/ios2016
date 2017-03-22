//
//  BQRMJXSVC.m
//  JZBRelease
//
//  Created by zjapple on 16/8/25.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "BQRMBaseListViewVC.h"
#import "BQRMBaseListCell.h"

#import "UIImageView+CreateImageView.h"
#import "UILabel+CreateLabel.h"
#import "ZJBHelp.h"

#import "JXSarea.h"
#import "JXSindustry.h"
#import "JXSbrand.h"
#import "PPCSarea.h"
#import "PPCSindustry.h"
#import "ZLTjz_expert.h"
#import "ZLTother_expert.h"

#import "BQRMResultListVC.h"
#import "MJRefresh.h"

#import "BQRMResultCell.h"
#import "PublicOtherPersonVC.h"

@interface BQRMBaseListViewVC ()<UITableViewDelegate,UITableViewDataSource>
/** scrollView */
@property (nonatomic, weak) UIScrollView *scrollView;
/** hottableView */
@property (nonatomic, weak) UITableView *hottableView;
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** page */
@property (nonatomic, assign) int page;

/** title数据源 */
@property (nonatomic, strong) NSArray *hotDataSource;

@end

@implementation BQRMBaseListViewVC

static NSString *ID = @"BQRMBaseListCell";
static NSString *HotID = @"BQRMResultCell";

//- (NSMutableArray *)titleDataSource
//{
//    if (_titleDataSource == nil) {
//        _titleDataSource = [NSMutableArray array];
//    }
//    return _titleDataSource;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.page = 0;
    
    [self downLoadData];
    
    [self setupScrollView];
    
    [self setupTableView];
    [self setupHotTableView];
    
    self.view.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"F8F8F8"];
    
    //    self.titles = @[@"地区",@"行业",@"品牌厂商"];
    
    //    self.title = @"经销商";
    [self setuptitleView];
    
    [self configNav:self.navigationController];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - 加载hot数据
- (void)downLoadData
{
    HttpBaseRequestItem *item = [HttpBaseRequestItem new];
    item.uid = [LoginVM getInstance].readLocal._id;
    item.type = self.tid;
    item.page = [NSString stringWithFormat:@"%d",self.page];
    NSDictionary *parameters = item.mj_keyValues;
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/User/search_type"] parameters:parameters success:^(id json) {
        
        NSMutableArray *arrT = [NSMutableArray array];
        if (self.page != 0) {
            [arrT addObjectsFromArray:self.hotDataSource];
        }
        
        NSArray *item = [Users mj_objectArrayWithKeyValuesArray:json];
        
        [arrT addObjectsFromArray:item];
        
        self.hotDataSource = arrT;
        
        self.scrollView.contentSize = CGSizeMake(GLScreenW,10 + 64 +self.tableView.glh_height + self.hotDataSource.count * 64);
        
        self.hottableView.glh_height = self.hotDataSource.count * 64 + 64;
        
        [self.hottableView reloadData];
        [self endMJRefresh];
        
        //            NSLog(@"TTT--json%@",json);
    } failure:^(NSError *error) {
        [self endMJRefresh];
    }];
}

- (void)setupScrollView
{
    UIScrollView *scrollView = [UIScrollView new];
    [self.view addSubview:scrollView];
    scrollView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f2f2f2"];
    scrollView.frame = self.view.frame;
    scrollView.gly_y = 64;
    scrollView.glh_height -= 58;
    //    scrollView.glh_height += 64;
    self.scrollView = scrollView;
    
    scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.page = 0;
        [self downLoadData];
    }];
    
    scrollView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        [self downLoadData];
    }];
    
}

- (void)endMJRefresh
{
    [self.scrollView.mj_header endRefreshing];
    [self.scrollView.mj_footer endRefreshing];
}

- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, GLScreenW, self.titles.count * 44) style:UITableViewStylePlain];
    
    tableView.scrollEnabled = NO;
    
    //    [tableView registerClass:[JSCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    
    [tableView registerNib:[UINib nibWithNibName:@"BQRMBaseListCell" bundle:nil] forCellReuseIdentifier:ID];
    
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //有数据才有分割线
    //    tableView.tableFooterView = [[UIImageView alloc]init];
    
    tableView.dataSource = self;
    tableView.delegate = self;
    
    tableView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f8f8f8"];
    
    //    [tableView addObserver:self forKeyPath:@"indexPathsForSelectedRows" options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(tableView)];
    
    [self.scrollView addSubview:tableView];
    self.tableView = tableView;
    
}

- (void)setupHotTableView
{
    UITableView *hottableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.tableView.glh_height, GLScreenW, 0) style:UITableViewStylePlain];
    
    hottableView.scrollEnabled = NO;
    
    //    [tableView registerClass:[JSCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    
    [hottableView registerNib:[UINib nibWithNibName:@"BQRMResultCell" bundle:nil] forCellReuseIdentifier:HotID];
    
    hottableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    hottableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //有数据才有分割线
    //    hottableView.tableFooterView = [[UIImageView alloc]init];
    
    hottableView.dataSource = self;
    hottableView.delegate = self;
    
    hottableView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f8f8f8"];
    
    //    [tableView addObserver:self forKeyPath:@"indexPathsForSelectedRows" options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(tableView)];
    
    [self.scrollView addSubview:hottableView];
    self.hottableView = hottableView;
}

- (void)setuptitleView
{
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.glw_width - 112 * 2, 40)];
    titleLable.text = self.title;
    //    titleLable.textColor = [UIColor hx_colorWithHexRGBAString:@"ffffff"];
    titleLable.textColor = [UIColor whiteColor];
    titleLable.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLable;
}

- (void)configNav:(UIViewController *)vc
{
    //11 20
    
    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setImage:[UIImage imageNamed:@"ZCCG_NAV_ARROW"] forState:UIControlStateNormal];
    back.frame = CGRectMake(0, 0, 20, 20);
    [back setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 0)]; // 向左边拉伸
    
    [back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItems = @[leftItem];
    //    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11 + 5 + 40, 35)];
    //    UIImageView *backImageView = [UIImageView createImageViewWithFrame:CGRectMake(0, (35-20)/2, 11, 20) ImageName:@"bq_detail_left"];
    //    backImageView.userInteractionEnabled = YES;
    //    [backView addSubview:backImageView];
    //    UILabel *backLabel = [UILabel createLabelWithFrame:CGRectMake(11 + 5,(35-20)/2, 40, 20) Font:17 Text:@"返回" andLCR:0 andColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]]];
    //    [backView addSubview:backLabel];
    //    UIControl *back = [[UIControl alloc] initWithFrame:backView.bounds];
    //    [back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    //    [backView addSubview:back];
    //    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    //    self.navigationItem.leftBarButtonItem = leftBtnItem;
}
- (void) backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //    /** 全部列表页面的空数据占位图片 */
    //    notDataShowView *view;
    //
    //    if (self.titles.count) {
    //        if ([notDataShowView sharenotDataShowView].superview) {
    //            [[notDataShowView sharenotDataShowView] removeFromSuperview];
    //        }
    //    }else {
    //        view = [notDataShowView sharenotDataShowView:tableView];
    //        [tableView addSubview:view];
    //
    //    }
    
    if ([tableView isEqual:self.tableView]) {
        
        return self.titles.count;
        
    }
    
    else if ([tableView isEqual:self.hottableView])
        
    {
        
        return self.hotDataSource.count;
        
    }
    
    return 0;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    //    if (indexPath.row == 0) {
    //        cell.titleLabel.text = @"地区";
    //    }else if (indexPath.row == 1) {
    //        cell.titleLabel.text = @"行业";
    //    }else if (indexPath.row == 2) {
    //        cell.titleLabel.text = @"品牌厂商";
    //    }
    
    if ([tableView isEqual:self.tableView]) {
        BQRMBaseListCell *basecell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
        basecell.RMtitle = self.titles[indexPath.row];
        
        if (self.dataSource.count) {
            basecell.tag = self.tag;
            basecell.model = self.dataSource[indexPath.row];
        }
        basecell.selectionStyle = UITableViewCellSelectionStyleNone;
        return basecell;
        
    }
    
    else if ([tableView isEqual:self.hottableView])
        
    {
        BQRMResultCell *hotcell = [tableView dequeueReusableCellWithIdentifier:HotID forIndexPath:indexPath];
        //        return self.hotDataSource.count;
        hotcell.model = self.hotDataSource[indexPath.row];
        hotcell.selectionStyle = UITableViewCellSelectionStyleNone;
        return hotcell;
        
    }
    
    //    cell.RMtitle = self.titles[indexPath.row];
    //
    //    if (self.dataSource.count) {
    //        cell.tag = self.tag;
    //        cell.model = self.dataSource[indexPath.row];
    //    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.tableView]) {
        BQRMBaseListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (cell.model) {
            BQRMResultListVC *vc = [BQRMResultListVC new];
            vc.tid = self.tid;
            
            if ([NSStringFromClass([cell.model class]) isEqualToString:@"JXSindustry"]) {
                JXSindustry *model= (JXSindustry *)cell.model;
                vc.aid = model.aid;
            }else if ([NSStringFromClass([cell.model class]) isEqualToString:@"JXSbrand"]){
                JXSbrand *model= (JXSbrand *)cell.model;
                vc.aid = model.aid;
            }else if ([NSStringFromClass([cell.model class]) isEqualToString:@"JXSarea"]){
                JXSarea *model= (JXSarea *)cell.model;
                vc.aid = model.area;
            }else if ([NSStringFromClass([cell.model class]) isEqualToString:@"PPCSarea"]){
                PPCSarea *model= (PPCSarea *)cell.model;
                vc.aid = model.area;
            }else if ([NSStringFromClass([cell.model class]) isEqualToString:@"PPCSindustry"]){
                PPCSindustry *model= (PPCSindustry *)cell.model;
                vc.aid = model.aid;
            }else if ([NSStringFromClass([cell.model class]) isEqualToString:@"ZLTjz_expert"]){
                ZLTjz_expert *model= (ZLTjz_expert *)cell.model;
                vc.aid = model.aid;
            }else if ([NSStringFromClass([cell.model class]) isEqualToString:@"ZLTother_expert"]){
                ZLTother_expert *model= (ZLTother_expert *)cell.model;
                vc.aid = model.aid;
            }
            
            //
            //        [[cell model] class] *model = ([cell.model class] *)cell.model;
            //        NSClassFromString([[cell model] class]) model = (NSClassFromString([[cell model] class]))* cell.model;
            
            //        NSStringFromClass([[cell model] class])* model
            
            vc.tag = self.tag;
            vc.title = cell.RMtitle;
            
            //        [[ZJBHelp getInstance].bqRootVC.navigationController pushViewController:vc animated:YES];
            
            [self.navigationController pushViewController:vc animated:YES];
            
            return;
        }
        
        BQRMBaseListViewVC *vc;
        
        if ([self.tid isEqualToString:@"1"]) {
            if ([cell.RMtitle isEqualToString:@"行业"]) {
                vc = [BQRMBaseListViewVC new];
                
                NSMutableArray *arrM = [NSMutableArray array];
                
                if (self.JXSindustryDataSource.count) {
                    for (JXSindustry *model in self.JXSindustryDataSource) {
                        [arrM addObject:model.name];
                    }
                    vc.titles = arrM;
                    vc.dataSource = self.JXSindustryDataSource;
                    vc.tag = @"industry";
                }
                //            if (self.titleDataSource.count) {
                //                vc.dataSource = self.titleDataSource;
                //            }
                
                vc.title = cell.RMtitle;
                
                //            [[ZJBHelp getInstance].bqRootVC.navigationController pushViewController:vc animated:YES];
            }else if ([cell.RMtitle isEqualToString:@"地区"]){
                vc = [BQRMBaseListViewVC new];
                
                NSMutableArray *arrM = [NSMutableArray array];
                
                if (self.JXSareaDataSource.count) {
                    for (JXSarea *model in self.JXSareaDataSource) {
                        if (model.area) {
                            [arrM addObject:model.area];
                        }
                    }
                    vc.titles = arrM;
                    vc.dataSource = self.JXSareaDataSource;
                    vc.tag = @"area";
                }
                
                vc.title = cell.RMtitle;
                
                //            [[ZJBHelp getInstance].bqRootVC.navigationController pushViewController:vc animated:YES];
            }else if ([cell.RMtitle isEqualToString:@"品牌"]){
                vc = [BQRMBaseListViewVC new];
                
                NSMutableArray *arrM = [NSMutableArray array];
                
                if (self.JXSbrandDataSource.count) {
                    for (JXSbrand *model in self.JXSbrandDataSource) {
                        [arrM addObject:model.name];
                    }
                    vc.titles = arrM;
                    vc.dataSource = self.JXSbrandDataSource;
                    vc.tag = @"brand";
                }
                
                vc.title = cell.RMtitle;
                
                //            [[ZJBHelp getInstance].bqRootVC.navigationController pushViewController:vc animated:YES];
            }
        }else if ([self.tid isEqualToString:@"3"]){
            if ([cell.RMtitle isEqualToString:@"地区"]) {
                vc = [BQRMBaseListViewVC new];
                
                NSMutableArray *arrM = [NSMutableArray array];
                
                if (self.PPCSareaSource.count) {
                    for (PPCSarea *model in self.PPCSareaSource) {
                        if (model.area) {
                            [arrM addObject:model.area];
                            //                        vc.aid = model.area;
                        }
                    }
                    vc.titles = arrM;
                    vc.dataSource = self.PPCSareaSource;
                    vc.tag = @"area";
                    //                vc.aid = model.area;
                }
                
                vc.title = cell.RMtitle;
                
                //            [[ZJBHelp getInstance].bqRootVC.navigationController pushViewController:vc animated:YES];
            }else if ([cell.RMtitle isEqualToString:@"行业"]) {
                vc = [BQRMBaseListViewVC new];
                
                NSMutableArray *arrM = [NSMutableArray array];
                
                if (self.PPCSindustryDataSource.count) {
                    for (PPCSindustry *model in self.PPCSindustryDataSource) {
                        [arrM addObject:model.name];
                    }
                    vc.titles = arrM;
                    vc.dataSource = self.PPCSindustryDataSource;
                    vc.tag = @"industry";
                }
                
                vc.title = cell.RMtitle;
                
                //            [[ZJBHelp getInstance].bqRootVC.navigationController pushViewController:vc animated:YES];
            }
        }else if ([self.tid isEqualToString:self.ZLTDict[@"id"]]) {
            
            if ([cell.RMtitle isEqualToString:@"智囊团"]) {
                vc = [BQRMBaseListViewVC new];
                
                NSMutableArray *arrM = [NSMutableArray array];
                
                if (self.ZLTDataSource.count) {
                    for (JXSbrand *model in self.ZLTDataSource) {
                        if (model.name) {
                            [arrM addObject:model.name];
                            //                        vc.aid = model.area;
                        }
                    }
                    vc.titles = arrM;
                    vc.dataSource = self.ZLTDataSource;
                    vc.tag = @"expert";
                    //                vc.aid = model.area;
                }
                
                vc.title = cell.RMtitle;
                
                //            [[ZJBHelp getInstance].bqRootVC.navigationController pushViewController:vc animated:YES];
            }
        }
        
        
        
        //    else if ([self.tid isEqualToString:self.ZLTDict[@"id"]]) {
        //        if ([cell.RMtitle isEqualToString:self.ZLTDict[@"list"][0][@"li"][0][@"name"]]) {
        //            vc = [BQRMBaseListViewVC new];
        //
        //            NSMutableArray *arrM = [NSMutableArray array];
        //
        //            if (self.ZLTjz_expertDataSource.count) {
        //                for (ZLTjz_expert *model in self.ZLTjz_expertDataSource) {
        //                    [arrM addObject:model.name];
        //                }
        //                vc.titles = arrM;
        //                vc.dataSource = self.ZLTjz_expertDataSource;
        //                vc.tag = @"expert";
        //            }
        //
        //            vc.title = cell.RMtitle;
        //
        //            //            [[ZJBHelp getInstance].bqRootVC.navigationController pushViewController:vc animated:YES];
        //        }else if ([cell.RMtitle isEqualToString:self.ZLTDict[@"list"][0][@"li"][1][@"name"]]) {
        //            vc = [BQRMBaseListViewVC new];
        //
        //            NSMutableArray *arrM = [NSMutableArray array];
        //
        //            if (self.ZLTother_expertDataSource.count) {
        //                for (ZLTother_expert *model in self.ZLTother_expertDataSource) {
        //                    [arrM addObject:model.name];
        //                }
        //                vc.titles = arrM;
        //                vc.dataSource = self.ZLTother_expertDataSource;
        //                vc.tag = @"expert";
        //            }
        //
        //            vc.title = cell.RMtitle;
        //
        //            //            [[ZJBHelp getInstance].bqRootVC.navigationController pushViewController:vc animated:YES];
        //        }
        //    }
        
        vc.tid = self.tid;
        
        //    [[ZJBHelp getInstance].bqRootVC.navigationController pushViewController:vc animated:YES];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    else if ([tableView isEqual:self.hottableView])
        
    {
        BQRMResultCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        PublicOtherPersonVC *vc = [[UIStoryboard storyboardWithName:@"PublicOtherPersonVC" bundle:nil]instantiateInitialViewController];
        
        //    OtherPersonCentralVC *vc = [[OtherPersonCentralVC alloc]init];
        Users *user = [[Users alloc]init];
        user.uid = cell.model.uid;
        vc.user = user;
        
        if ([vc.user.uid isEqualToString:[LoginVM getInstance].readLocal._id] || vc.user.uid == nil) {
            return ;
        }
        
        vc.isSecVCPush = YES;
        vc.hidesBottomBarWhenPushed = YES;
        //        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.tableView]) {
        
        return 44;
        
    }
    
    else if ([tableView isEqual:self.hottableView])
        
    {
        
        return 64;
        
    }
    
    return 64;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.hottableView]) {
        
        return 52;
        
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    
    
    UILabel *text = [UILabel new];
    text.text = @"热门推荐";
    text.font = [UIFont systemFontOfSize:15];
    text.frame = CGRectMake(20, 22, 20, 20);
    [text sizeToFit];
    text.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
    [view addSubview:text];
    
    return view;
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


@end
