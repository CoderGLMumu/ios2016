//
//  NewQuestionListVC.m
//  JZBRelease
//
//  Created by Apple on 16/11/7.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "NewQuestionListVC.h"

#import "QuestionCell.h"
#import "MJRefresh.h"
#import "ApplyVipVC.h"
#import "BCH_Alert.h"
#import "BBQuestionDetailVC.h"
#import "TableViewCell.h"
#import "LWImageBrowserModel.h"
#import "OtherPersonCentralVC.h"
#import "LWImageBrowser.h"

#import "pushNotificationCell.h"

#import "PublicLogOutUser.h"

@interface NewQuestionListVC ()<UITableViewDelegate,UITableViewDataSource>

/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataSource;

/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** num */
@property (nonatomic, assign) int pageN;

@end

@implementation NewQuestionListVC

static NSString *ID = @"NewQuestionCell";

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"提问动态";
    
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
    
    NSArray *arr2 = [NSKeyedUnarchiver unarchiveObjectWithFile:CachesNotificationQuestion];
    
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
    if ([LoginVM getInstance].users) {
        
    }else {
//        [PublicLogOutUser logOutUser:self.navigationController];
        [PublicLogOutUser logOutUser:self.navigationController netWorkLoOut:YES];
        return ;
    }
    GLLog(@"%@",[LoginVM getInstance].users);
    GLLog(@"%@",[LoginVM getInstance].users);
    GLLog(@"%@",[LoginVM getInstance].users);
    
    AppDelegate *appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (!appD.vip) {
        [UIView bch_showWithTitle:@"提示" message:@"查看问答详情要先加入建众帮会员哦！" buttonTitles:@[@"取消",@"确定"] callback:^(id sender, NSUInteger buttonIndex) {
            if (1 == buttonIndex) {
                //AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                
              //  if (appDelegate.checkpay) {
                    ApplyVipVC *applyVipVC = [[ApplyVipVC alloc]init];
                    [self.navigationController pushViewController:applyVipVC animated:YES];
             //   }
            }
        }];
        return;
    };
    
    if (self.dataSource.count > indexPath.row) {
        PushextrasItem *item = self.dataSource[indexPath.row];
   
        QuestionsModel *model = [QuestionsModel new];
        model.question_id = item.id;
        
        BBQuestionDetailVC *vc = [[BBQuestionDetailVC alloc]init];
        vc.IsFromGLNavPush = YES;
        vc.questionModel = model;
        vc.fromPerSon = YES;
        [self.navigationController pushViewController:vc animated:YES];
//        self.navigationController.tabBar.hidden = YES;
//        [[ZJBHelp getInstance].bbRootVC.navigationController pushViewController:vc animated:YES];
        [self setHidesBottomBarWhenPushed:YES];
    }
    
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


//左滑删除按钮:(实现delegate)
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [UIView bch_showWithTitle:@"确认删除" message:nil buttonTitles:@[@"取消",@"删除"] callback:^(id sender, NSUInteger buttonIndex) {
        if (buttonIndex == 0) {
            return ;
        }else if (buttonIndex == 1){
        
            PushextrasItem *item = self.dataSource[indexPath.row];
            NSMutableArray *arr1 = [NSKeyedUnarchiver unarchiveObjectWithFile:CachesNotificationQuestion];
            
            
            [arr1 enumerateObjectsUsingBlock:^(PushextrasItem *item1, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([item1.id isEqualToString:item.id]) {
                    [arr1 removeObjectAtIndex:idx];
                }
            }];
            
            
            [NSKeyedArchiver archiveRootObject:arr1 toFile:CachesNotificationQuestion];
            
            // 修改模型
            [self.dataSource removeObjectAtIndex:indexPath.row];
            // 局部刷新
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        }
    }];
    
   
}
//删除文字:
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
    //    return [NSString stringWithFormat:@"删除-%zd",indexPath.row];
}


@end
