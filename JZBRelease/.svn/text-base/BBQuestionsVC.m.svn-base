//
//  AskAnswerVC.m
//  JZBRelease
//
//  Created by zjapple on 16/7/13.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "BBQuestionsVC.h"
//#import "WJRefresh.h"
#import "Defaults.h"
#import "GetQuestionsModel.h"
#import "QuestionCell.h"
#import "QuestionsLayout.h"
#import "MJRefresh.h"
#import "BBQuestionDetailVC.h"
#import "TableViewCellDelegate.h"
#import "TableViewCell.h"
#import "SameAskModel.h"
#import "OtherPersonCentralVC.h"

#import "PublicOtherPersonVC.h"

@interface BBQuestionsVC ()<UITableViewDelegate,UITableViewDataSource,TableViewCellDelegate>{
    NSInteger preSelector;
    BOOL footerFresh;
    NSInteger footerCount;
}

@property (nonatomic, strong) WJRefresh *refresh;
@property (nonatomic, strong) NSMutableArray *dataAry,*questionsAry;
@property (nonatomic, assign) CGFloat kRefreshBoundary;
@property (nonatomic, assign,getter = isNeedRefresh) BOOL needRefresh;

@end

@implementation BBQuestionsVC
@synthesize kRefreshBoundary;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49)];
    self.automaticallyAdjustsScrollViewInsets = NO;
    kRefreshBoundary = 40.0f;
    footerCount = 0;
    [self createTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSameAsk:) name:@"UpdateSameAsk" object:nil];
}

- (void)createTableView{
    NSLog(@"self.view.frame.size.height %f",self.view.frame.size.height);
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor whiteColor];
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
    tableView1.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            // 结束刷新
//            [tableView1.mj_footer endRefreshing];
//        });
        footerFresh = YES;
        [self createFootData];
    }];
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //        for (int i = 200; i < 210; i ++) {
        //            [self.dataSource addObject:[NSString stringWithFormat:@"%d",i]];
        //        }
        [self downloadData];
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
                if (footerFresh) {
                    model.page = [NSString stringWithFormat:@"%ld",footerCount];
                }else{
                    model.page = @"0";
                }
                model.my = @"0";
                SendAndGetDataFromNet *sendAndget = [[SendAndGetDataFromNet alloc]init];
                __block SendAndGetDataFromNet *wsend = sendAndget;
                sendAndget.returnDict = ^(NSDictionary *dict){
                    if (1 == [[dict objectForKey:@"state"] intValue]) {
                        NSArray *ary = [dict objectForKey:@"data"];
                        if (footerFresh) {
                            NSMutableArray *nextAry = [self cellWithDataAry:ary];
                            NSInteger beginCount = self.questionsAry.count - 1;
                            [self.questionsAry insertObjects:nextAry atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(beginCount, nextAry.count)]];
                        }else{
                            if (self.questionsAry) {
                                [self.questionsAry removeAllObjects];
                                footerCount = 0;
                            }
                            self.questionsAry = [self cellWithDataAry:ary];
                        }
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
        self.needRefresh = NO;
        if (footerFresh) {
            footerFresh = NO;
            footerCount ++;
            [self.tableView.mj_footer endRefreshing];
        }else{
            [self.tableView.mj_header endRefreshing];
        }
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
    if (self.questionsAry.count > indexPath.row) {  
        QuestionsLayout *layout = self.questionsAry[indexPath.row];
        layout.questionsModel.row = [NSNumber numberWithInteger:indexPath.row];
        BBQuestionDetailVC *vc = [[BBQuestionDetailVC alloc]init];
        vc.questionModel = layout.questionsModel;
        [ZJBHelp getInstance].bbRootVC.tabBarController.tabBar.hidden = YES;
        [[ZJBHelp getInstance].bbRootVC.navigationController pushViewController:vc animated:YES];
        
    }
    
}

- (void)tableViewCell:(UITableViewCell *)cell didClickedLinkWithData:(id)data clinkType:(Clink_Type)clink_type{
    if (clink_type == Clink_Type_One) {
        QuestionsModel *model = ((QuestionCell *)cell).cellLayout.questionsModel;
//        OtherPersonCentralVC *vc = [[OtherPersonCentralVC alloc]init];
        
        PublicOtherPersonVC *vc = [[UIStoryboard storyboardWithName:@"PublicOtherPersonVC" bundle:nil]instantiateInitialViewController];
        
        vc.user = model.user;
        
        if ([vc.user.uid isEqualToString:[LoginVM getInstance].readLocal._id] || vc.user.uid == nil) {
            return ;
        }
        
        [ZJBHelp getInstance].bbRootVC.tabBarController.tabBar.hidden = YES;
        [ZJBHelp getInstance].bbRootVC.navigationController.navigationBar.hidden = YES;
        [[ZJBHelp getInstance].bbRootVC.navigationController pushViewController:vc animated:YES];
    }
}

- (void)tableViewCell:(TableViewCell *)cell didClickedCommentWithCellLayout:(CellLayout *)layout
          atIndexPath:(NSIndexPath *)indexPath clinkType:(Clink_Type)clink_type{
    if (clink_type == Clink_Type_One) {
        
    }else if (clink_type == Clink_Type_Two){
        //点赞
       // [self dianZanCell:cell WithLayout:layout AtIndexPath:indexPath];
    }else if (clink_type == Clink_Type_Three){
        [self sameAsk:cell WithLayout:layout AtIndexPath:indexPath];
    }else if (clink_type == Clink_Type_Four){
        
    }else if (clink_type == Clink_Type_Six){
        QuestionsModel *model = ((QuestionsLayout *)layout).questionsModel;
//        OtherPersonCentralVC *vc = [[OtherPersonCentralVC alloc]init];
        PublicOtherPersonVC *vc = [[UIStoryboard storyboardWithName:@"PublicOtherPersonVC" bundle:nil]instantiateInitialViewController];
        
        vc.user = model.user;
        
        if ([vc.user.uid isEqualToString:[LoginVM getInstance].readLocal._id] || vc.user.uid == nil) {
            return ;
        }
        
        [ZJBHelp getInstance].bbRootVC.tabBarController.tabBar.hidden = YES;
        [ZJBHelp getInstance].bbRootVC.navigationController.navigationBar.hidden = YES;
        [[ZJBHelp getInstance].bbRootVC.navigationController pushViewController:vc animated:YES];
    }
}
//

-(void)sameAsk:(TableViewCell *) cell WithLayout:(CellLayout *) layout AtIndexPath:(NSIndexPath *) indexPath{
    SameAskModel *sameAskModel = [[SameAskModel alloc]init];
    sameAskModel.access_token = [[LoginVM getInstance] readLocal].token;
    QuestionsLayout *layout1 = (QuestionsLayout *)layout;
    QuestionsModel *questionsModel = layout1.questionsModel;
    sameAskModel.question_id = questionsModel.question_id;
    if ([questionsModel.is_sameAsk intValue] == 1) {
        return;
    }
    SendAndGetDataFromNet *send = [[SendAndGetDataFromNet alloc]init];
    __weak BBQuestionsVC *wself = self;
    __block SendAndGetDataFromNet *wsend = send;
    send.returnModel = ^(GetValueObject *model,int state){
        if (!model) {
            [Toast makeShowCommen:@"您的网络 " ShowHighlight:@"出现故障" HowLong:0.8];
        }else{
            if (1 == state) {
                questionsModel.is_sameAsk = @"1";
                questionsModel.sameAsk_count = [NSString stringWithFormat:@"%d",[questionsModel.sameAsk_count intValue] + 1];
                QuestionsLayout *newLayout = [self layoutWithDetailListModel:questionsModel index:preSelector IsDetail:NO IsLast:NO];
                [wself.questionsAry replaceObjectAtIndex:indexPath.row withObject:newLayout];
                [wself.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]]
                                       withRowAnimation:UITableViewRowAnimationAutomatic];
            }else{
                [LoginVM getInstance].isGetToken = ^(){
                    sameAskModel.access_token = [[LoginVM getInstance] readLocal].token;
                    [wsend commenDataFromNet:model WithRelativePath:@"Send_SameAsk_For_Question"];
                };
                [[LoginVM getInstance] loginWithUserInfoForGetNewToken:[[LoginVM getInstance] readLocal]];
            }
        }
    };
    [send commenDataFromNet:sameAskModel WithRelativePath:@"Send_SameAsk_For_Question"];
}

-(void)updateSameAsk:(NSNotification *)noti{
    NSDictionary *dict = noti.userInfo;
    NSNumber *row = [dict objectForKey:@"ROW"];
    QuestionsLayout *layout = self.questionsAry[[row integerValue]];
    QuestionsModel *questionsModel = layout.questionsModel;
    questionsModel.is_sameAsk = @"1";
    questionsModel.sameAsk_count = [NSString stringWithFormat:@"%d",[questionsModel.sameAsk_count intValue] + 1];
    QuestionsLayout *newLayout = [self layoutWithDetailListModel:questionsModel index:preSelector IsDetail:NO IsLast:NO];
    [self.questionsAry replaceObjectAtIndex:[row integerValue] withObject:newLayout];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[row integerValue] inSection:0]]
                           withRowAnimation:UITableViewRowAnimationAutomatic];
 
}

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
