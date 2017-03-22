//
//  RankTableVC.m
//  JZBRelease
//
//  Created by zjapple on 16/9/26.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "FocusContentVC.h"

#import "Defaults.h"
#import "FocusContentCell.h"

#import "AttentionListVC.h"
#import "FocusedCourseTimeListVC.h"

#import "FocusBusinessListVC.h"
#import "FocusQuestionListVC.h"

#import "GLNAVC.h"

@interface FocusContentVC ()<UITableViewDelegate,UITableViewDataSource>{
     UIView *backView;
}

// tableView
@property(nonatomic , weak)UITableView *tableView;

// dataSource
@property(nonatomic , strong)NSArray *dataSource;
// imgdataSource
@property(nonatomic , strong)NSArray *imgdataSource;

@end

static NSString *ID = @"FocusContentCellID";

@implementation FocusContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.view.frame = CGRectMake(0, 0, GLScreenW, GLScreenH - 49 * 2 - 64);
    
    self.title = @"关注内容";
    
    self.dataSource = @[@"关注的人",@"关注的课程",@"关注的商机",@"关注的问答"];
    self.imgdataSource = @[@"WOGZ_man",@"WOGZ_study",@"WOGZ_business",@"GZNR_question"];
    
    [self setupTableView];
    
    
    
//    [self downLoadData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
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
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11 + 5 + 40, 35)];
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


- (void)downLoadData
{
    //类型 1本周 2本月 3本年
//    
//    NSDictionary *parameters1 = @{
//                                  @"type":self.type
//                                  };
//    
//    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/User/rank"] parameters:parameters1 success:^(id json) {
//        
//        self.dataSource = [rankItem mj_objectArrayWithKeyValuesArray:json];
//        
//        //        [self tableViewreloadData];
//        
//        [self.tableView reloadData];
//        
//        
//    } failure:^(NSError *error) {
//        [SVProgressHUD showErrorWithStatus:@"网络不通顺"];
//    }];
//    
}

- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, GLScreenW, GLScreenH) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerNib:[UINib nibWithNibName:@"FocusContentCell" bundle:nil] forCellReuseIdentifier:ID];
    [self.view addSubview:tableView];
    tableView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f8f8f8"];
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
    
    //    tableView.scrollEnabled = YES;
    //    tableView.alwaysBounceVertical = YES;
    //    tableView.alwaysBounceHorizontal = YES;
    //    tableView.scrollEnabled = YES;
    //    tableView.pagingEnabled = YES;
    //    tableView.showsHorizontalScrollIndicator = YES;
    //    tableView.showsVerticalScrollIndicator = YES;
    
    tableView.tableFooterView = [[UIView alloc]init];
    
    tableView.contentInset = UIEdgeInsetsMake(10, 0, 64 + 44 + 49, 0);
    
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    /** 全部列表页面的空数据占位图片 */
//    notDataShowView *view;
    
//    if (self.dataSource.count) {
//        if ([notDataShowView sharenotDataShowView].superview) {
//            [[notDataShowView sharenotDataShowView] removeFromSuperview];
//        }
//    }else {
//        view = [notDataShowView sharenotDataShowView:tableView];
//        [tableView addSubview:view];
//        
//    }
    
    return self.dataSource.count;
}

- (FocusContentCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FocusContentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.twoLabel.text = self.dataSource[indexPath.row];
    cell.firstImageView.image = [UIImage imageNamed:self.imgdataSource[indexPath.row]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    NSLog(@"123123123");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    rankItem *model = self.dataSource[indexPath.row];
//    
//    PublicOtherPersonVC *vc = [[UIStoryboard storyboardWithName:@"PublicOtherPersonVC" bundle:nil]instantiateInitialViewController];
//    vc.user = model.user;
//    
//    //    vc.fromDynamicDetailVC = YES;
//    vc.isSecVCPush = YES;
//    [self.navigationController setHidesBottomBarWhenPushed:YES];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    [self.navigationController pushViewController:vc animated:YES];
    
    if (indexPath.row == 0) {
        
        AttentionListVC *vc = [AttentionListVC new];
        
        vc.title = @"关注列表";
        Users *user = [Users new];
        if (self.isOther) {
            user.uid = self.user.uid;
        }else {
            user.uid = [LoginVM getInstance].readLocal._id;
        }
        
        if (self.isOther) {
            vc.user = self.user;
        }else {
            vc.user = user;
        }
        
        vc.isSecVCPush = YES;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row == 1) {
        
        FocusedCourseTimeListVC *focusedVC = [[FocusedCourseTimeListVC alloc]init];
        
        focusedVC.isOther = self.isOther;
        if (self.isOther) {
            focusedVC.user = self.user;
        }
        
        [self.navigationController pushViewController:focusedVC animated:YES];
    
    }else if (indexPath.row == 2) {
        
        
        FocusBusinessListVC *focusedVC = [[FocusBusinessListVC alloc]init];
        
        focusedVC.isOther = self.isOther;
        if (self.isOther) {
            focusedVC.user = self.user;
        }
        
        [self.navigationController pushViewController:focusedVC animated:YES];

        
    }else if (indexPath.row == 3) {
        
        // 跳转关注的问答
        FocusQuestionListVC *focusedVC = [[FocusQuestionListVC alloc]init];
        
        if (self.isOther) {
            focusedVC.user = self.user;
        }
        
        [self.navigationController pushViewController:focusedVC animated:YES];
        
    }
    
    
}


@end
