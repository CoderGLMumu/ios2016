//
//  BBQuestionSearchVC.m
//  JZBRelease
//
//  Created by cl z on 16/8/11.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "BBQuestionSearchVC.h"
#import "Defaults.h"
#import "MJRefresh.h"
#import "TableViewCell.h"
#import "QuestionsModel.h"
#import "QuestionsLayout.h"
#import "GetQuestionsModel.h"
#import "QuestionCell.h"
#import "SameAskModel.h"
#import "BBQuestionDetailVC.h"
#import "CusSearchVC.h"
#import "ApplyVipVC.h"
#import "BCH_Alert.h"
#import "PublicLogOutUser.h"

@interface BBQuestionSearchVC ()<UITableViewDelegate,UITableViewDataSource,CusSearchDelegate,TableViewCellDelegate>{
    NSString *searchKeyWord;
    NSInteger preSelector;
}
@property (nonatomic, strong) NSMutableArray *dataAry,*questionsAry;
@property (nonatomic, assign) CGFloat kRefreshBoundary;
@property (nonatomic, strong) CusSearchVC *cusSearchVC;

@end

@implementation BBQuestionSearchVC
@synthesize kRefreshBoundary;
- (void)viewDidLoad {
    [super viewDidLoad];
    kRefreshBoundary = 40.0f;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view setBackgroundColor:[UIColor whiteColor]];

    //初始搜索
    self.cusSearchVC = [[CusSearchVC alloc]initWithplaceholder:@"请输入你要搜索的课程内容" WithAdresaName:@"BBQuestionSearchVC" WithParentOrDeleagteVC:self];
}


- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}

// CusSearchDelegate 代理方法
- (void)gobackAction{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 清除功能
 */
- (void) clearBtnAction{
    self.cusSearchVC.keyWordTableView.hidden = NO;
    [self.cusSearchVC.keyWordTableView reloadData];
    if (self.tableView) {
        self.tableView.hidden = YES;
    }
}

/**
 搜索

 @param keyWord 搜索关键词
 */
- (void) beginSearch:(NSString *)keyWord{
    searchKeyWord = keyWord;
    self.cusSearchVC.keyWordTableView.hidden = YES;
    
    if (!self.tableView) {
        [self createTableView];
    }else{
        [self downloadData];
    }
    self.tableView.hidden = NO;
}




- (void)createTableView{
    NSLog(@"self.view.frame.size.height %f",self.view.frame.size.height);
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Inteval_Color" WithKind:XMLTypeColors]];
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    __unsafe_unretained UITableView *tableView1 = self.tableView;
    
    // 下拉刷新
    tableView1.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self createData];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView1.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
//    tableView1.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            // 结束刷新
//            [tableView1.mj_footer endRefreshing];
//        });
//    }];
    [tableView1.mj_header beginRefreshing];

}

- (void)createData{
    NSLog(@"-----------头部刷新数据-----------");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self downloadData];
    });
    
}

- (void)createFootData{
    NSLog(@"-----------尾部加载更多数据-----------");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //        for (int i = 200; i < 210; i ++) {
        //            [self.dataSource addObject:[NSString stringWithFormat:@"%d",i]];
        //        }
        [self.tableView reloadData];
        //        [_refresh endRefresh];
    });
}

-(NSMutableArray *)cellWithDataAry:(NSArray *) dataAry{
    NSMutableArray *ary = [[NSMutableArray alloc]init];
    BOOL isLast = NO;
    for (NSInteger i = 0; i < dataAry.count ; i ++) {
        QuestionsModel *questionsModel = [QuestionsModel mj_objectWithKeyValues:[dataAry objectAtIndex:i]];
        if (questionsModel) {
            if (i == dataAry.count - 1) {
                isLast = YES;
            }
            QuestionsLayout *layout = [self layoutWithDetailListModel:questionsModel index:i IsDetail:NO IsLast:isLast];
            if (layout) {
                [ary addObject:layout];
            }
        }
    }
    return ary;
}

- (QuestionsLayout *)layoutWithDetailListModel:(QuestionsModel *)questionsModel index:(NSInteger)index IsDetail:(BOOL)isDetail IsLast:(BOOL)isLast{
    //生成Storage容器
    LWStorageContainer* container = [[LWStorageContainer alloc] init];
    //生成Layout
    QuestionsLayout* layout = [[QuestionsLayout alloc]initWithContainer:container Model:questionsModel dateFormatter:[self dateFormatter] index:index IsDetail:isDetail IsLast:isLast];
    return layout;
}

- (NSDateFormatter *)dateFormatter {
    static NSDateFormatter* dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM月dd日 hh:mm"];
    });
    return dateFormatter;
}

- (void)refreshBegin {
    [UIView animateWithDuration:0.2f animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(kRefreshBoundary, 0.0f, 0.0f, 0.0f);
    } completion:^(BOOL finished) {
        // [self.tableViewHeader refreshingAnimateBegin];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self downloadData];
        });
    }];
}

- (void)downloadData {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[HttpManager shareManager] netStatus:^(AFNetworkReachabilityStatus status) {
            if(status == AFNetworkReachabilityStatusReachableViaWWAN || status ==AFNetworkReachabilityStatusReachableViaWiFi){
                GetQuestionsModel *model = [[GetQuestionsModel alloc]init];
                model.access_token = [[LoginVM getInstance] readLocal].token;
                model.id = @"0";
                model.keyword = searchKeyWord;
                SendAndGetDataFromNet *sendAndget = [[SendAndGetDataFromNet alloc]init];
                __block SendAndGetDataFromNet *wsend = sendAndget;
                sendAndget.returnDict = ^(NSDictionary *dict){
                    if (1 == [[dict objectForKey:@"state"] intValue]) {
                        NSArray *ary = [dict objectForKey:@"data"];
                        if (!ary || ary.count == 0) {
                            [SVProgressHUD showInfoWithStatus:@"亲，很抱歉暂时没有您需要的内容！我们会不断努力，提供更多有价值的干货！"];
                            //                            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"亲，很抱歉暂时没有您需要的内容！我们会不断努力，提供更多有价值的干货！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                            //                            [alertView show];
                            
                        }
                        if (self.questionsAry) {
                            [self.questionsAry removeAllObjects];
                        }
                        self.questionsAry = [self cellWithDataAry:ary];
                        NSLog(@"%@",ary);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self refreshComplete];
                        });
                        
                    }else{
                        [LoginVM getInstance].isGetToken = ^(){
                            model.access_token = [[LoginVM getInstance] readLocal].token;
                            [wsend dictFromNet:model WithRelativePath:@"Get_Question_List"];
                        };
                        [[LoginVM getInstance] loginWithUserInfoForGetNewToken:[[LoginVM getInstance] readLocal]];
                    }
                };
                [sendAndget dictFromNet:model WithRelativePath:@"Get_Question_List"];
            }else{
                [Toast makeShowCommen:@"您的网络有问题 " ShowHighlight:@"请重置" HowLong:0.8];
            }
        }];
    });
}

- (void)refreshComplete {
    //[self.tableViewHeader refreshingAnimateStop];
    [UIView animateWithDuration:0.35f animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    } completion:^(BOOL finished) {
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.questionsAry) {
        
        /** 全部列表页面的空数据占位图片 */
        notDataShowView *view;
        
        if (self.questionsAry.count) {
            if ([notDataShowView sharenotDataShowView].superview) {
                [[notDataShowView sharenotDataShowView] removeFromSuperview];
            }
        }else {
            view = [notDataShowView sharenotDataShowView:tableView];
            [tableView addSubview:view];
            
        }
        
        return self.questionsAry.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* cellIdentifier = @"QuestionCellIdentifier";
    QuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[QuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (self.questionsAry.count > indexPath.row) {
        QuestionsLayout* cellLayouts = self.questionsAry[indexPath.row];
        cell.cellLayout = cellLayouts;
    }
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
              //  AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
              
               // if (appDelegate.checkpay) {
                    ApplyVipVC *applyVipVC = [[ApplyVipVC alloc]init];
                    [self.navigationController pushViewController:applyVipVC animated:YES];
              //  }
            }
        }];
        return;
    };
    
    if (self.questionsAry.count > indexPath.row) {
        QuestionsLayout *layout = self.questionsAry[indexPath.row];
        layout.questionsModel.row = [NSNumber numberWithInteger:indexPath.row];
        BBQuestionDetailVC *vc = [[BBQuestionDetailVC alloc]init];
        vc.questionModel = layout.questionsModel;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}

//- (void)tableViewCell:(UITableViewCell *)cell didClickedLinkWithData:(id)data clinkType:(Clink_Type)clink_type{
//    if (clink_type == Clink_Type_One) {
//        QuestionsModel *model = ((QuestionCell *)cell).cellLayout.questionsModel;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"OtherPersonCentralVC" object:self userInfo:[[model.user class] entityToDictionary:model.user]];
//    }
//}
//
//- (void)tableViewCell:(TableViewCell *)cell didClickedCommentWithCellLayout:(CellLayout *)layout
//          atIndexPath:(NSIndexPath *)indexPath clinkType:(Clink_Type)clink_type{
//    if (clink_type == Clink_Type_One) {
//        
//    }else if (clink_type == Clink_Type_Two){
//        //点赞
//        // [self dianZanCell:cell WithLayout:layout AtIndexPath:indexPath];
//    }else if (clink_type == Clink_Type_Three){
//        [self sameAsk:cell WithLayout:layout AtIndexPath:indexPath];
//    }else if (clink_type == Clink_Type_Four){
//        
//    }else if (clink_type == Clink_Type_Six){
//        QuestionsModel *model = ((QuestionsLayout *)layout).questionsModel;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"OtherPersonCentralVC" object:self userInfo:[[model.user class] entityToDictionary:model.user]];
//    }
//}
////
//
//-(void)sameAsk:(TableViewCell *) cell WithLayout:(CellLayout *) layout AtIndexPath:(NSIndexPath *) indexPath{
//    SameAskModel *sameAskModel = [[SameAskModel alloc]init];
//    sameAskModel.access_token = [[LoginVM getInstance] readLocal].token;
//    QuestionsLayout *layout1 = (QuestionsLayout *)layout;
//    QuestionsModel *questionsModel = layout1.questionsModel;
//    sameAskModel.question_id = questionsModel.question_id;
//    if ([questionsModel.is_sameAsk intValue] == 1) {
//        return;
//    }
//    SendAndGetDataFromNet *send = [[SendAndGetDataFromNet alloc]init];
//    __weak BBQuestionSearchVC *wself = self;
//    __weak SendAndGetDataFromNet *wsend = send;
//    send.returnModel = ^(GetValueObject *model,int state){
//        if (!model) {
//            [Toast makeShowCommen:@"您的网络 " ShowHighlight:@"出现故障" HowLong:0.8];
//        }else{
//            if (1 == state) {
//                questionsModel.is_sameAsk = @"1";
//                questionsModel.sameAsk_count = [NSString stringWithFormat:@"%d",[questionsModel.sameAsk_count intValue] + 1];
//                QuestionsLayout *newLayout = [self layoutWithDetailListModel:questionsModel index:preSelector IsDetail:NO IsLast:YES];
//                [wself.questionsAry replaceObjectAtIndex:indexPath.row withObject:newLayout];
//                [wself.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]]
//                                       withRowAnimation:UITableViewRowAnimationAutomatic];
//            }else{
//                [LoginVM getInstance].isGetToken = ^(){
//                    sameAskModel.access_token = [[LoginVM getInstance] readLocal].token;
//                    [wsend commenDataFromNet:model WithRelativePath:@"Send_SameAsk_For_Question"];
//                };
//                [[LoginVM getInstance] loginWithUserInfoForGetNewToken:[[LoginVM getInstance] readLocal]];
//            }
//        }
//    };
//    [send commenDataFromNet:sameAskModel WithRelativePath:@"Send_SameAsk_For_Question"];
//}
//
//-(void)updateSameAsk:(NSNotification *)noti{
//    NSDictionary *dict = noti.userInfo;
//    NSNumber *row = [dict objectForKey:@"ROW"];
//    QuestionsLayout *layout = self.questionsAry[[row integerValue]];
//    QuestionsModel *questionsModel = layout.questionsModel;
//    questionsModel.is_sameAsk = @"1";
//    questionsModel.sameAsk_count = [NSString stringWithFormat:@"%d",[questionsModel.sameAsk_count intValue] + 1];
//    QuestionsLayout *newLayout = [self layoutWithDetailListModel:questionsModel index:preSelector IsDetail:NO IsLast:YES];
//    [self.questionsAry replaceObjectAtIndex:[row integerValue] withObject:newLayout];
//    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[row integerValue] inSection:0]]
//                          withRowAnimation:UITableViewRowAnimationAutomatic];
//    
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.questionsAry.count > indexPath.row) {
        QuestionsLayout *layout = self.questionsAry[indexPath.row];
        return layout.cellHeight;
    }
    return 0;
}


-(NSMutableArray *)dataAry{
    if (_dataAry) {
        return _dataAry;
    }
    _dataAry = [[NSMutableArray alloc]init];
    return _dataAry;
}


@end
