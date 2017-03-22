//
//  BQRMRootVC.m
//  JZBRelease
//
//  Created by zjapple on 16/8/24.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "BQRMRootVC.h"

#import "RMRootCell.h"
#import "BQRMDataItem.h"
#import "Defaults.h"
#import "BQRMButton.h"

#import "BQRMBaseListViewVC.h"
#import "RMNearbyPersontVC.h"

#import "JXSarea.h"
#import "JXSbrand.h"
#import "JXSindustry.h"
#import "PPCSarea.h"
#import "PPCSindustry.h"
#import "ZLTother_expert.h"
#import "ZLTjz_expert.h"

#import "MJRefresh.h"
#import "SendAndGetDataFromNet.h"
//#import "OtherPersonCentralVC.h"
#import "PublicOtherPersonVC.h"

#import "WDBListVC.h"

#import "CYLSearchController.h"
#import "CusSearchView.h"

#import "BQRMSearchVC.h"

@interface BQRMRootVC () <UITextFieldDelegate, CYLSearchControllerDelegate>

/** 数据源 */
@property (nonatomic, strong) NSMutableArray *RMdataSource;
@property (weak, nonatomic) IBOutlet BQRMButton *jingxiaoshangButton;
@property (weak, nonatomic) IBOutlet BQRMButton *zhinangtuanButton;
@property (weak, nonatomic) IBOutlet BQRMButton *pinpaiButton;
@property (weak, nonatomic) IBOutlet BQRMButton *wdbButton;

/** 经销商地区数据源 */
@property (nonatomic, strong) NSArray *JXSareaDataSource;
/** 经销商品牌厂商数据源 */
@property (nonatomic, strong) NSArray *JXSbrandDataSource;
/** 经销商行业数据源 */
@property (nonatomic, strong) NSArray *JXSindustryDataSource;

/** 品牌厂商地区数据源 */
@property (nonatomic, strong) NSArray *PPCSareaDataSource;
/** 品牌厂商行业数据源 */
@property (nonatomic, strong) NSArray *PPCSindustryDataSource;

/** zlt数据源 */
@property (nonatomic, strong) NSMutableArray *ZLTDataSource;
///** 品牌厂商地区数据源 */
//@property (nonatomic, strong) NSMutableArray *ZLTjz_expertDataSource;
///** 品牌厂商行业数据源 */
//@property (nonatomic, strong) NSMutableArray *ZLTother_expertDataSource;

/** 经销商帮NextTitle */
@property (nonatomic, strong) NSMutableArray *JXSNextTitles;
/** 智囊团NextTitle */
@property (nonatomic, strong) NSMutableArray *ZLTNextTitles;
/** 品牌帮NextTitle */
@property (nonatomic, strong) NSMutableArray *PPCSNextTitles;

/** 经销商帮NextDict */
@property (nonatomic, strong) NSDictionary *JXSDict;
/** 智囊团NextDict */
@property (nonatomic, strong) NSDictionary *ZLTDict;
/** 品牌帮NextDict */
@property (nonatomic, strong) NSDictionary *PPCSDict;
/** mid搜索TF */
@property (weak, nonatomic) IBOutlet UITextField *SearchTF;

@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (nonatomic, strong) CusSearchView *cusSearchView;
@end

@implementation BQRMRootVC

-(instancetype)init{
    self = [super init];
    if (self) {
        self = [[UIStoryboard storyboardWithName:@"BQRMRootVC" bundle:nil]instantiateInitialViewController];
    }
    return self;
}

- (NSMutableArray *)RMdataSource
{
    if (_RMdataSource == nil) {
        _RMdataSource = [NSMutableArray array];
    }
    return _RMdataSource;
}

//push 使用[ZJBHelp getInstance].bqRootVC.navigationController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"人脉";
    
    //[self setupSearchView];
    [self.searchView addSubview:self.cusSearchView];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.jingxiaoshangButton.direction = 1;
    self.zhinangtuanButton.direction = 2;
    self.pinpaiButton.direction = 3;
    self.wdbButton.direction = 4;
    
    [self.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49)];
    //self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self downLoadDataSource];
    
    /** 首页网络数据 */
    [self loadData];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"%@",self);
//    });
}

- (UIView *)cusSearchView{
    if (!_cusSearchView) {
        _cusSearchView = [[CusSearchView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 58)];
        [_cusSearchView setLabelText:@"请输入您要搜索的人"];
        __weak typeof (self) wself = self;
        _cusSearchView.returnAction = ^(NSInteger tag){
            
            BQRMSearchVC *bqrmSearch = [[BQRMSearchVC alloc]init];
            [wself.navigationController pushViewController:bqrmSearch animated:YES];

            
//            CYLSearchController *controller = [[CYLSearchController alloc] initWithNibName:@"CYLSearchController" bundle:nil];
//            controller.delegate = wself;
//            
//            controller.hidesBottomBarWhenPushed = YES;
//            [wself.navigationController pushViewController:controller animated:YES];
//            
//            //    self.searchController = [[UINavigationController alloc] initWithRootViewController:controller];
//            [controller showInViewController:wself];
        };
    }
    return _cusSearchView;
}

// 人脉搜索
- (void)setupSearchView
{
    self.SearchTF.placeholder = @"请输入您要搜索的人";
    self.SearchTF.delegate = self;
    self.SearchTF.inputView = [[UIView alloc]initWithFrame:CGRectZero];;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.SearchTF.glh_height , self.SearchTF.glh_height)];
    
    UIImageView *imageViewPwd=[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, self.SearchTF.glh_height - 12, self.SearchTF.glh_height - 12)];
    
    [view addSubview:imageViewPwd];
    
    imageViewPwd.image = [UIImage imageNamed:@"RM_SS"];
    self.SearchTF.leftView = view;
    self.SearchTF.leftViewMode = UITextFieldViewModeAlways; //此处用来设置leftview现实时机
    self.SearchTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
//    UITapGestureRecognizer *tapSearchTf = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushSearchVC)];
//    
//    [self.SearchTF addGestureRecognizer:tapSearchTf];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

    [self.tabBarController.tabBar setHidden:YES];
    
    self.navigationController.navigationBar.alpha = 1;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)downLoadDataSource
{
 
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/User/get_user_type"] parameters:nil success:^(id json) {
        
        if (![json[@"state"] isEqual:@(1)]) return ;
        
        for (NSDictionary *dictT in json[@"data"]) {
            if ([dictT[@"id"] isEqualToString:@"1"]) {
                // 添加到经销商
                NSArray *arrM = dictT[@"list"];
                self.JXSDict = dictT;
                self.JXSNextTitles = [NSMutableArray array];
                
                for (NSDictionary *dictM in arrM) {
                    
                    [self.JXSNextTitles addObject:dictM[@"title"]];
                    
                    if ([dictM[@"tag"] isEqualToString:@"area"]) {
                        
                        self.JXSareaDataSource = [JXSarea mj_objectArrayWithKeyValuesArray:dictM[@"li"]];
                    }else if ([dictM[@"tag"] isEqualToString:@"industry"]) {
                        self.JXSindustryDataSource = [JXSindustry mj_objectArrayWithKeyValuesArray:dictM[@"li"]];
                    }else if ([dictM[@"tag"] isEqualToString:@"brand"])
                        self.JXSbrandDataSource = [JXSbrand mj_objectArrayWithKeyValuesArray:dictM[@"li"]];
                }
                
//
//                self.JXSbrandDataSource = [JXSbrand mj_objectArrayWithKeyValuesArray:dictM[@"brand"]];
//                self.JXSindustryDataSource = [JXSindustry mj_objectArrayWithKeyValuesArray:dictM[@"industry"]];
                
//                dictM[@"area"];
//                dictM[@"industry"];
//                dictM[@"brand"];
                
            }else if ([dictT[@"id"] isEqualToString:@"2"]) {
                // 添加到智囊团
                
                NSArray *arrM = dictT[@"list"];
                
                self.ZLTDict = dictT;
                self.ZLTNextTitles = [NSMutableArray array];
                
                for (NSDictionary *dictM in arrM) {
                    
                    [self.ZLTNextTitles addObject:dictM[@"title"]];
                    
                    if ([dictM[@"tag"] isEqualToString:@"expert"]) {
                        
                    self.ZLTDataSource = [JXSbrand mj_objectArrayWithKeyValuesArray:dictM[@"li"]];
                        
//                        self.ZLTjz_expertDataSource = [NSMutableArray array];
//                        ZLTjz_expert *ZLTexpertItem = [ZLTjz_expert mj_objectWithKeyValues:dictM];
//                        
//                        [self.ZLTjz_expertDataSource addObject:ZLTexpertItem];
                    }
                }
                
//                for (NSDictionary *dictM in arrM[0][@"li"]) {
//                    
//                    [self.ZLTNextTitles addObject:dictM[@"name"]];
//                    
//                    if ([dictM[@"id"] isEqualToString:@"1"]) {
//                        self.ZLTjz_expertDataSource = [NSMutableArray array];
//                        ZLTjz_expert *ZLTexpertItem = [ZLTjz_expert mj_objectWithKeyValues:dictM];
//                        
//                        [self.ZLTjz_expertDataSource addObject:ZLTexpertItem];
//                    }else if ([dictM[@"id"] isEqualToString:@"2"]) {
//                        
//                        self.ZLTother_expertDataSource = [NSMutableArray array];
//                        
//                        ZLTother_expert *ZLTotherItem = [ZLTother_expert mj_objectWithKeyValues:dictM];
//                        [self.ZLTother_expertDataSource addObject:ZLTotherItem];
//                        self.ZLTother_expertDataSource = [ZLTother_expert mj_objectArrayWithKeyValuesArray:dictM[@"li"]];
//                    }
//                }
                
//                self.ZLTjz_expertDataSource = [ZLTjz_expert mj_objectArrayWithKeyValuesArray:dictM[@"area"]];
//                self.ZLTother_expertDataSource = [ZLTother_expert mj_objectArrayWithKeyValuesArray:dictM[@"industry"]];
                
            }else if ([dictT[@"id"] isEqualToString:@"3"]) {
                // 添加到品牌厂商B
                NSArray *arrM = dictT[@"list"];
                
                self.PPCSDict = dictT;
                self.PPCSNextTitles = [NSMutableArray array];
                
                for (NSDictionary *dictM in arrM) {
                    
                    [self.PPCSNextTitles addObject:dictM[@"title"]];
                    
                    if ([dictM[@"tag"] isEqualToString:@"area"]) {
                        self.PPCSareaDataSource = [PPCSarea mj_objectArrayWithKeyValuesArray:dictM[@"li"]];
//                        PPCSarea * test = self.PPCSareaDataSource[0];
//                        NSLog(@"%@",test.area);
//                        NSLog(@"%@",test.name);
                    }else if ([dictM[@"tag"] isEqualToString:@"industry"]) {
                        self.PPCSindustryDataSource = [JXSindustry mj_objectArrayWithKeyValuesArray:dictM[@"li"]];
                    }
                }
                
//                self.PPCSareaDataSource = [JXSbrand mj_objectArrayWithKeyValuesArray:dictM[@"area"]];
//                self.PPCSindustryDataSource = [JXSindustry mj_objectArrayWithKeyValuesArray:dictM[@"industry"]];
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}

/** 首页网络数据 */
- (void)loadData
{
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"BQRMData.plist" ofType:nil];
//    //        根据路径从plist文件当中加载数组
//    NSArray *dictArray  = [NSMutableArray arrayWithContentsOfFile:filePath];
//    
//    self.RMdataSource = [BQRMDataItem mj_objectArrayWithKeyValuesArray:dictArray];
//
//    for (int i = 1; i <= 6; ++i) {
//        BQRMDataItem *item = [BQRMDataItem new];
//        
//        
//        
//        NSString *strT = [NSString stringWithFormat:@"RMimg%d",i];
//        UIImage *image = [UIImage imageNamed:strT];
//        [self.RMdataSource addObject:image];
//    }
    
    UserInfo *userInfo = [[LoginVM getInstance]readLocal];
    
    NSDictionary *parameters = @{
                                 @"uid":userInfo._id,
                                 @"type":@"0"
                                 };
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/User/search_type"] parameters:parameters success:^(id json) {
        
        self.RMdataSource = [BQRMDataItem mj_objectArrayWithKeyValuesArray:json];
        
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    /** 全部列表页面的空数据占位图片 */
    notDataShowView *view;
    
    if (self.RMdataSource.count) {
        if ([notDataShowView sharenotDataShowView].superview) {
            [[notDataShowView sharenotDataShowView] removeFromSuperview];
        }
    }else {
        view = [notDataShowView sharenotDataShowView:tableView];
        [tableView addSubview:view];
        view.center = CGPointMake(GLScreenW * 0.5, GLScreenH * 0.6);
    }
    
    return self.RMdataSource.count;
}


- (RMRootCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RMRootCell *cell;
    
    if (indexPath.row % 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"BQRMcell1" forIndexPath:indexPath];
        
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"BQRMcell2" forIndexPath:indexPath];
    }
    
    cell.model = self.RMdataSource[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RMRootCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
//    OtherPersonCentralVC *vc = [[OtherPersonCentralVC alloc]init];
//    
//    Users *user = [[Users alloc]init];
//    user.uid = cell.model.uid;
//    vc.user = user;
    
    PublicOtherPersonVC *vc = [[UIStoryboard storyboardWithName:@"PublicOtherPersonVC" bundle:nil]instantiateInitialViewController];
    
    Users *user = [[Users alloc]init];
    user.uid = cell.model.uid;
    vc.user = user;
    
    if ([vc.user.uid isEqualToString:[LoginVM getInstance].readLocal._id] || vc.user.uid == nil) {
        return ;
    }
    
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BQRMDataItem *item = self.RMdataSource[indexPath.row];
    if (indexPath.row % 2) {
        item.cellnum = 1;
        
    }else {
        item.cellnum = 2;
    }

    
//    return item.cellHeight;
//    GLLog(@"glglglglglglglglglglglglgl%f",item.cellHeight);
    
    return item.cellHeight;
}

/** 点击了经销商 */
- (IBAction)JXSButtonClick:(BQRMButton *)sender {
    
    BQRMBaseListViewVC *vc = [BQRMBaseListViewVC new];
    
    vc.titles = self.JXSNextTitles;
    vc.title = self.JXSDict[@"name"];
    vc.tid = self.JXSDict[@"id"];
    
    vc.JXSindustryDataSource = self.JXSindustryDataSource;
    vc.JXSbrandDataSource = self.JXSbrandDataSource;
    vc.JXSareaDataSource = self.JXSareaDataSource;
    
    vc.JXSDict = self.JXSDict;
    
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
//    [[ZJBHelp getInstance].bqRootVC.navigationController pushViewController:vc animated:YES];
    
//    [[ZJBHelp getInstance].bqRootVC.navigationController pushViewController:vc animated:YES];
//        
//        //    获取行业列表
//        //    接口：/Web/User/industry
//        //    参数:id,tree
//        //    返回：行业列表
//        //    id:
//        //    0
//        //    （父级id，0：所有）
//        //tree:
//        //    0
//        //    (0:列表结构，1：树形结构)
//        
//        NSDictionary *parameters = @{
//                                     @"id":@"0",
//                                     @"tree":@"0"
//                                     };
//        
//        [HttpToolSDK postWithURL:@"http://192.168.10.154/bang/index.php/Web/User/industry" parameters:parameters success:^(id json) {
//            
//            for (NSDictionary *dictT in json) {
//                NSString *name = dictT[@"name"];
//                [vc.titleDataSource addObject:name];
//            }
//            
//            vc.dataSource = json;
//            
//        } failure:^(NSError *error) {
//            
//        }];
}

/** 点击了之智囊团 */
- (IBAction)ZLTBottonClick:(BQRMButton *)sender {
    
    BQRMBaseListViewVC *vc = [BQRMBaseListViewVC new];
    
    vc.titles = self.ZLTNextTitles;
    vc.title = self.ZLTDict[@"name"];
    vc.tid = self.ZLTDict[@"id"];
    
    vc.ZLTDataSource = self.ZLTDataSource;
//    vc.ZLTjz_expertDataSource = self.ZLTjz_expertDataSource;
//    vc.ZLTother_expertDataSource = self.ZLTother_expertDataSource;
//    
    vc.ZLTDict = self.ZLTDict;
    
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
//    [[ZJBHelp getInstance].bqRootVC.navigationController pushViewController:vc animated:YES];
    
}

/** 品牌商 */
- (IBAction)PPCSButtonClick:(BQRMButton *)sender {
    
    BQRMBaseListViewVC *vc = [BQRMBaseListViewVC new];
    
    vc.titles = self.PPCSNextTitles;
    vc.title = self.PPCSDict[@"name"];
    vc.tid = self.PPCSDict[@"id"];
    
    vc.PPCSareaSource = self.PPCSareaDataSource;
    vc.PPCSindustryDataSource = self.PPCSindustryDataSource;
    
    vc.PPCSDict = self.PPCSDict;
    
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
//    [[ZJBHelp getInstance].bqRootVC.navigationController pushViewController:vc animated:YES];
    
}

/** 点击了我的帮 */
- (IBAction)WDBButtonClick:(BQRMButton *)sender {
    
    [SVProgressHUD showInfoWithStatus:@"功能暂未开发,敬请期待"];
    
    return ;
    
    WDBListVC *vc = [WDBListVC new];
    
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
//    [[ZJBHelp getInstance].bqRootVC.navigationController pushViewController:vc animated:YES];
    
}

/** 点击了附近的人 */
- (IBAction)nearbyPersonControlClick:(UIControl *)sender {
    
    RMNearbyPersontVC *vc = [RMNearbyPersontVC new];
    
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
//    [[ZJBHelp getInstance].bqRootVC.navigationController pushViewController:vc animated:YES];
}




/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField        // return NO to disallow editing.
//{
//    return YES;
//}

- (void)textFieldDidBeginEditing:(UITextField *)textField           // became first responder
{
    // 进入搜索页面
    
    [self searchHeaderViewClicked:nil];
}

#pragma mark - 🔌 CYLSearchHeaderViewDelegate Method
/** 人脉点击了搜索 */
- (void)searchHeaderViewClicked:(id)sender {
    CYLSearchController *controller = [[CYLSearchController alloc] initWithNibName:@"CYLSearchController" bundle:nil];
    controller.delegate = self;
    
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    
    //    self.searchController = [[UINavigationController alloc] initWithRootViewController:controller];
    [controller showInViewController:self];
}

#pragma mark - 🔌 CYLSearchControllerDelegate Method

- (void)questionSearchCancelButtonClicked:(CYLSearchController *)controller
{
    [controller hide:^{
        NSLog(@"questionSearchCancelButtonClicked");
    }];
}


-(void)dealloc{
    NSLog(@"destroyed");
}

@end
