//
//  AskAndAnswerVC.m
//  JZBRelease
//
//  Created by cl z on 16/8/9.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "FocusQuestionListVC.h"
#import "MJRefresh.h"
#import "Defaults.h"
#import "GetQuestionsModel.h"
#import "QuestionsLayout.h"
#import "QuestionCell.h"
#import "TableViewCellDelegate.h"
#import "TableViewCell.h"
#import "SameAskModel.h"
#import "BBQuestionDetailVC.h"
//#import "OtherPersonCentralVC.h"
#import "PublicOtherPersonVC.h"
#import "GLNAVC.h"

@interface FocusQuestionListVC ()<UITableViewDelegate,UITableViewDataSource,TableViewCellDelegate>{
    NSInteger preSelector;
    BOOL footerFresh;
    NSInteger footerCount;
}

@property(nonatomic, strong) NSMutableArray *questionsAry,*answerAry;
@property(nonatomic, strong) UISegmentedControl *segment;

@end

@implementation FocusQuestionListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self.navigationController setNavigationBarHidden:<#(BOOL)#> animated:<#(BOOL)#>]
    [self.view setBackgroundColor:[UIColor whiteColor]];
    footerFresh = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
//    [self configNav];
    
    self.title = @"关注的问答";
    
//    self.segment = [[UISegmentedControl alloc]initWithItems:@[@"提问",@"回答"]];
//    self.segment.frame = CGRectMake(0, 0, 120, 28);
//    self.segment.selectedSegmentIndex = 0;
//    self.segment.tintColor= [UIColor whiteColor];
//    [self.segment addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
//    self.navigationItem.titleView = self.segment;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    GLLog(@"%@",self.navigationController);
    if ([self.navigationController isKindOfClass:[GLNAVC class]]) {
        
    }else {
        [self configNav];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self createTableView];
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

-(void) backAction{
//    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
    [self.questionsAry removeAllObjects];
    self.questionsAry = nil;
    [self.answerAry removeAllObjects];
    self.answerAry = nil;
    [self.tableView removeFromSuperview];
    self.tableView = nil;
    //self.tabBarController.tabBar.hidden = NO;
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
        footerFresh = NO;
        [self createData];
        //模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        //                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //                    // 结束刷新
        //
        //                });
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView1.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    tableView1.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            //[tableView1.mj_footer endRefreshing];
            footerFresh = YES;
            [self createFootData];
        });
    }];
    [tableView1.mj_header beginRefreshing];
}

//-(void) segmentChange:(UISegmentedControl *) segment{
//    
//    if (segment.selectedSegmentIndex == 1) {
//        if (!self.answerAry) {
//            [self.tableView.mj_header beginRefreshing];
//            return;
//        }
//    }
//    [self.tableView reloadData];
//}


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

- (NSDateFormatter *)dateFormatter {
    static NSDateFormatter* dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM月dd日 hh:mm"];
    });
    return dateFormatter;
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
- (void)downloadData {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[HttpManager shareManager] netStatus:^(AFNetworkReachabilityStatus status) {
            if(status == AFNetworkReachabilityStatusReachableViaWWAN || status ==AFNetworkReachabilityStatusReachableViaWiFi){
                GetQuestionsModel *model = [[GetQuestionsModel alloc]init];
                model.access_token = [[LoginVM getInstance] readLocal].token;
                model.page = @"0";
                //model.my = @"0";
                if (self.user.uid) {
                    model.user_id = self.user.uid;
                }
                
                
                if (footerFresh) {
                    footerCount++;
                    model.page = [NSString stringWithFormat:@"%ld",footerCount];
                }else{
                    model.page = @"0";
                }

                SendAndGetDataFromNet *sendAndget = [[SendAndGetDataFromNet alloc]init];
                __block SendAndGetDataFromNet *wsend = sendAndget;
                sendAndget.returnDict = ^(NSDictionary *dict){
                    if (1 == [[dict objectForKey:@"state"] intValue]) {
                        NSArray *ary = [dict objectForKey:@"data"];
                       
                        if (footerFresh) {
                            if (ary.count == 0) {
                                [self.tableView.mj_footer endRefreshing];
                                return ;
                            }
                            NSMutableArray *nextAry = [self cellWithDataAry:ary];
                            NSInteger beginCount = self.questionsAry.count;
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
                            
                        [wsend dictFromNet:model WithRelativePath:@"Get_Collect_Question_URL"];
                            
                            
                        };
                        [[LoginVM getInstance] loginWithUserInfoForGetNewToken:[[LoginVM getInstance] readLocal]];
                    }
                };
                [wsend dictFromNet:model WithRelativePath:@"Get_Collect_Question_URL"];
                
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
        footerFresh = NO;
        [self.tableView.mj_header endRefreshing];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.segment.selectedSegmentIndex == 0) {
        if (self.questionsAry) {
            
            /** 全部列表页面的空数据占位图片 */
            notDataShowView *view;
            
            if (self.questionsAry.count) {
                if ([notDataShowView sharenotDataShowView].superview) {
                    [[notDataShowView sharenotDataShowView] removeFromSuperview];
                }
            }else {
                view = [notDataShowView sharenotDataShowView:tableView];
                [self.view addSubview:view];
                
            }
            
            return self.questionsAry.count;
        }
    }else{
        if (self.answerAry) {
            
            /** 全部列表页面的空数据占位图片 */
            notDataShowView *view;
            
            if (self.answerAry.count) {
                if ([notDataShowView sharenotDataShowView].superview) {
                    [[notDataShowView sharenotDataShowView] removeFromSuperview];
                }
            }else {
                view = [notDataShowView sharenotDataShowView:tableView];
                [self.view addSubview:view];
                
            }
            
            return self.answerAry.count;
        }
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifier = @"QuestionCellIdentifier";
    QuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[QuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (self.segment.selectedSegmentIndex == 0) {
        if (self.questionsAry.count > indexPath.row) {
            QuestionsLayout* cellLayouts = self.questionsAry[indexPath.row];
            cell.cellLayout = cellLayouts;
        }
    }else{
        if (self.answerAry.count > indexPath.row) {
            QuestionsLayout* cellLayouts = self.answerAry[indexPath.row];
            cell.cellLayout = cellLayouts;
        }
    }
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.segment.selectedSegmentIndex == 0) {
        if (self.questionsAry.count > indexPath.row) {
            QuestionsLayout *layout = self.questionsAry[indexPath.row];
            layout.questionsModel.row = [NSNumber numberWithInteger:indexPath.row];
            BBQuestionDetailVC *questVC = [[BBQuestionDetailVC alloc]init];
            questVC.fromPerSon = YES;
            questVC.questionModel = layout.questionsModel;
            questVC.updateDetailComment = YES;
            [self.navigationController pushViewController:questVC animated:YES];
        }
    }else{
        if (self.answerAry.count > indexPath.row) {
            QuestionsLayout *layout = self.answerAry[indexPath.row];
            layout.questionsModel.row = [NSNumber numberWithInteger:indexPath.row];
            BBQuestionDetailVC *questVC = [[BBQuestionDetailVC alloc]init];
            questVC.questionModel = layout.questionsModel;
            questVC.updateDetailComment = YES;
            questVC.fromPerSon = YES;
            [self.navigationController pushViewController:questVC animated:YES];
        }
        
    }
}

- (void)tableViewCell:(UITableViewCell *)cell didClickedLinkWithData:(id)data clinkType:(Clink_Type)clink_type{
    if (clink_type == Clink_Type_One) {
        QuestionsLayout *layout = ((QuestionCell *)cell).cellLayout;
        QuestionsModel *model = layout.questionsModel;
        if (![model.user.uid isEqualToString:self.user.uid]) {
            //            OtherPersonCentralVC *otherVC = [[OtherPersonCentralVC alloc]init];
            PublicOtherPersonVC *otherVC = [[UIStoryboard storyboardWithName:@"PublicOtherPersonVC" bundle:nil]instantiateInitialViewController];
            
            otherVC.user = model.user;
            
            if ([otherVC.user.uid isEqualToString:[LoginVM getInstance].readLocal._id] || otherVC.user.uid == nil) {
                return ;
            }
            
            self.navigationController.navigationBar.hidden = YES;
            [self.navigationController pushViewController:otherVC animated:YES];
        }
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
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"OtherPersonCentralVC" object:self userInfo:[[model.user class] entityToDictionary:model.user]];
        
        if (![model.user.uid isEqualToString:self.user.uid]) {
            //            OtherPersonCentralVC *otherVC = [[OtherPersonCentralVC alloc]init];
            PublicOtherPersonVC *otherVC = [[UIStoryboard storyboardWithName:@"PublicOtherPersonVC" bundle:nil]instantiateInitialViewController];
            
            otherVC.user = model.user;
            
            if ([otherVC.user.uid isEqualToString:[LoginVM getInstance].readLocal._id] || otherVC.user.uid == nil) {
                return ;
            }
            
            self.navigationController.navigationBar.hidden = YES;
            [self.navigationController pushViewController:otherVC animated:YES];
        }
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
    __weak FocusQuestionListVC *wself = self;
    __block SendAndGetDataFromNet *wsend = send;
    send.returnModel = ^(GetValueObject *model,int state){
        if (!model) {
            [Toast makeShowCommen:@"您的网络 " ShowHighlight:@"出现故障" HowLong:0.8];
        }else{
            if (1 == state) {
                questionsModel.is_sameAsk = @"1";
                questionsModel.sameAsk_count = [NSString stringWithFormat:@"%d",[questionsModel.sameAsk_count intValue] + 1];
                QuestionsLayout *newLayout = [self layoutWithDetailListModel:questionsModel index:preSelector IsDetail:NO  IsLast:YES];
                if (self.segment.selectedSegmentIndex == 0) {
                    [wself.questionsAry replaceObjectAtIndex:indexPath.row withObject:newLayout];
                }else{
                    [wself.answerAry replaceObjectAtIndex:indexPath.row withObject:newLayout];
                }
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
    QuestionsLayout *layout;
    if (self.segment.selectedSegmentIndex == 0) {
        layout = self.questionsAry[[row integerValue]];
    }else{
        layout = self.answerAry[[row integerValue]];
    }
    QuestionsModel *questionsModel = layout.questionsModel;
    questionsModel.is_sameAsk = @"1";
    questionsModel.sameAsk_count = [NSString stringWithFormat:@"%d",[questionsModel.sameAsk_count intValue] + 1];
    QuestionsLayout *newLayout = [self layoutWithDetailListModel:questionsModel index:preSelector IsDetail:NO IsLast:YES];
    [self.questionsAry replaceObjectAtIndex:[row integerValue] withObject:newLayout];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[row integerValue] inSection:0]]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.segment.selectedSegmentIndex == 0) {
        if (self.questionsAry.count > indexPath.row) {
            QuestionsLayout *layout = self.questionsAry[indexPath.row];
            return layout.cellHeight;
        }
    }else{
        if (self.answerAry.count > indexPath.row) {
            QuestionsLayout *layout = self.answerAry[indexPath.row];
            return layout.cellHeight;
        }
    }
    return 0;
}

- (void)dealloc{
    
}

@end
