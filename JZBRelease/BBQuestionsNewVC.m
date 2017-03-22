//
//  AskAnswerVC.m
//  JZBRelease
//
//  Created by zjapple on 16/7/13.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "BBQuestionsNewVC.h"
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
#import "CusAddOrReduceBtnView.h"
#import "YZSortViewController.h"
#import "LocalDataRW.h"
#import "SDCycleScrollView.h"
#import "LWImageBrowserModel.h"
#import "LWImageBrowser.h"
#import "RMNearbyPersontVC.h"
#import "CusSearchView.h"
#import "BBQuestionSearchVC.h"

#import "ApplyVipVC.h"
#import "BCH_Alert.h"
#import "QuestionEditVC.h"

#import "PublicOtherPersonVC.h"
#import "PublicLogOutUser.h"

@interface BBQuestionsNewVC ()<UITableViewDelegate,UITableViewDataSource,TableViewCellDelegate,SDCycleScrollViewDelegate>{
    NSInteger preSelector;
    BOOL footerFresh;
    NSInteger cusSelector;
    NSInteger footerCount;
    NSString *industryID;
}
@property (nonatomic, strong) CusAddOrReduceBtnView *cusAORView;
@property (nonatomic, strong) WJRefresh *refresh;
@property (nonatomic, strong) NSMutableArray *dataAry,*questionsAry,*cusDataAry,*circleAry;
@property (nonatomic, assign) CGFloat kRefreshBoundary;
@property (nonatomic, assign,getter = isNeedRefresh) BOOL needRefresh;
@property (nonatomic, strong) SDCycleScrollView *sdCycleScrollView;
@property (nonatomic, assign) int requestCount;

@property (nonatomic, strong) NSArray *industryAry;

@property (nonatomic, strong) CusSearchView *cusSearchView;

@end

@implementation BBQuestionsNewVC
@synthesize kRefreshBoundary;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
   // [self.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49)];
    self.automaticallyAdjustsScrollViewInsets = NO;
    kRefreshBoundary = 40.0f;
    self.title = @"全部问答";
    [self configNav];
    
    self.requestCount = 0;
    footerCount = 0;
    self.cusDataAry = [LocalDataRW readDataFromLocalOfDocument:@"focusedTags.plist" WithDirectory_Type:Directory_BB];
    cusSelector = 0;
    self.industryAry = [LocalDataRW readDataFromLocalOfDocument:@"AllTags.plist" WithDirectory_Type:Directory_BB];
    if (!self.cusDataAry) {
        self.cusDataAry = [[NSMutableArray alloc]initWithArray:@[@"推荐",@"最新"]];
        [LocalDataRW writeDataToLocaOfDocument:self.cusDataAry WithDirectory_Type:Directory_BB AtFileName:@"focusedTags.plist"];
    }
    industryID = [self.cusDataAry objectAtIndex:0];
    self.cusAORView = [CusAddOrReduceBtnView cusAddOrReduceBtnView:self.cusDataAry];
    [self.cusAORView setFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40)];
    [self.cusAORView initAllViews];
    __weak typeof (self) wself = self;
    self.cusAORView.returnBlock = ^(NSInteger tag){
        cusSelector = tag;
        if (wself.cusDataAry.count > tag) {
            NSString *industryStr = [wself.cusDataAry objectAtIndex:tag];
//            for (int i = 0; i < self.industryAry.count; i ++) {
//                IndustryModel *industryModel = [IndustryModel mj_objectWithKeyValues:[wself.industryAry objectAtIndex:i]];
//                if ([industryStr isEqualToString:industryModel.name]) {
//                    industryID = industryModel.id;
//                    break;
//                }
//            }
            //行业改成标签
            industryID = industryStr;
            if (wself.tableView) {
                [wself.tableView.mj_header beginRefreshing];
            }
        }
    };
    [self.cusAORView.addBtn addTarget:self action:@selector(addBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cusAORView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSameAsk:) name:@"UpdateSameAsk" object:nil];
    
    [self createTableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)configNav
{
    //11 20
    
    [[ZJBHelp getInstance] configNav:self WithLOrR:RIGHT ImageName:@"BR_FB" Action:@selector(sendQuestion)];
    
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

- (void)sendQuestion{
    QuestionEditVC *sendVC = [[QuestionEditVC alloc]init];
    [self.navigationController pushViewController:sendVC animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}


- (SDCycleScrollView *)sdCycleScrollView{
    if (!_sdCycleScrollView) {
        if (!self.circleAry) {
            self.circleAry = [[NSMutableArray alloc]init];
        }
        // >>>>>>>>>>>>>>>>>>>>>>>>> demo轮播图2 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        
        // 网络加载 --- 创建带标题的图片轮播器
        _sdCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.glw_width / 2.419) delegate:self placeholderImage:[UIImage imageNamed:@"WD_bannerPIC"]];
        
        _sdCycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _sdCycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
        __weak typeof (self) wself = self;
        _sdCycleScrollView.clickItemOperationBlock = ^(NSInteger index) {
            
            
            if ([LoginVM getInstance].users) {
                
            }else {
//                [PublicLogOutUser logOutUser:wself.navigationController];
                [PublicLogOutUser logOutUser:wself.navigationController netWorkLoOut:YES];
                return ;
            }
            
            GLLog(@"%@",[LoginVM getInstance].users);
            GLLog(@"%@",[LoginVM getInstance].users);
            GLLog(@"%@",[LoginVM getInstance].users);
            
            AppDelegate *appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
            if (!appD.vip) {
                [UIView bch_showWithTitle:@"提示" message:@"查看问答详情要先加入建众帮会员哦！" buttonTitles:@[@"取消",@"确定"] callback:^(id sender, NSUInteger buttonIndex) {
                    if (1 == buttonIndex) {
                       // AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                        
                       // if (appDelegate.checkpay) {
                            ApplyVipVC *applyVipVC = [[ApplyVipVC alloc]init];
                            [wself.navigationController pushViewController:applyVipVC animated:YES];
                        //}
                    }
                }];
                return;
            };
            
            BBQuestionDetailVC *vc = [[BBQuestionDetailVC alloc]init];
            if (wself.circleAry.count > index) {
                vc.questionModel = [wself.circleAry objectAtIndex:index];
            }
            [ZJBHelp getInstance].bbRootVC.tabBarController.tabBar.hidden = YES;
            [[ZJBHelp getInstance].bbRootVC.navigationController pushViewController:vc animated:YES];
        };
        [self downloadDataForCycle];
    }
    return _sdCycleScrollView;
}

- (void)downloadDataForCycle {
    
    [[HttpManager shareManager] netStatus:^(AFNetworkReachabilityStatus status) {
        if(status == AFNetworkReachabilityStatusReachableViaWWAN || status ==AFNetworkReachabilityStatusReachableViaWiFi){
            GetQuestionsModel *model = [[GetQuestionsModel alloc]init];
            model.access_token = [[LoginVM getInstance] readLocal].token;
            model.id = @"0";
            model.position = @"1";
            model.my = @"0";
            
            SendAndGetDataFromNet *sendAndget = [[SendAndGetDataFromNet alloc]init];
            __block SendAndGetDataFromNet *wsend = sendAndget;
            sendAndget.returnDict = ^(NSDictionary *dict){
                if (1 == [[dict objectForKey:@"state"] intValue]) {
                    //dispatch_async(dispatch_queue_create("question_queue", nil), ^{
                    
                        self.requestCount = 0;
                        NSArray *ary = [dict objectForKey:@"data"];
                        NSMutableArray *imagePathAry = [[NSMutableArray alloc]init];
                        NSMutableArray *titleAry = [[NSMutableArray alloc]init];
                        for (int i = 0; i < ary.count; i ++) {
                            QuestionsModel *questionsModel = [QuestionsModel mj_objectWithKeyValues:[ary objectAtIndex:i]];
                            if (questionsModel.images && questionsModel.images.count > 0) {
                                NSString *path = [questionsModel.images objectAtIndex:0];
                                [imagePathAry addObject:path];
                            }else{
                                [imagePathAry addObject:@"WD_bannerPIC"];
                            }
                            NSString *title;
                            if (questionsModel.title.length > 21) {
                                title = [questionsModel.title substringToIndex:21];
                            }else{
                                title = questionsModel.title;
                            }
                            [titleAry addObject:title];
                            [self.circleAry addObject:questionsModel];
                        }
                        self.sdCycleScrollView.titlesGroup = titleAry;
                        self.sdCycleScrollView.imageURLStringsGroup = imagePathAry;
                   // });
                    
                }else{
                    if (self.requestCount > 0) {
                        [Toast makeShowCommen:@"您的网络有问题, " ShowHighlight:@"请重置" HowLong:0.8];
                        self.requestCount = 0;
                        return ;
                    }
                    [LoginVM getInstance].isGetToken = ^(){
                        model.access_token = [[LoginVM getInstance] readLocal].token;
                        [wsend dictFromNet:model WithRelativePath:@"Get_Question_List"];
                        self.requestCount ++;
                    };
                    [[LoginVM getInstance] loginWithUserInfoForGetNewToken:[[LoginVM getInstance] readLocal]];
                }
            };
            [sendAndget dictFromNet:model WithRelativePath:@"Get_Question_List"];
        }else{
            [Toast makeShowCommen:@"您的网络有问题 " ShowHighlight:@"请重置" HowLong:0.8];
        }
    }];
    
}


- (void)addBtnAction{
    YZSortViewController *yzVC = [[YZSortViewController alloc]init];
    yzVC.focusedAry = self.cusDataAry;
    yzVC.returnData = ^(NSMutableArray *dataAry){
        self.cusDataAry = dataAry;
        self.industryAry = [LocalDataRW readDataFromLocalOfDocument:@"AllTags.plist" WithDirectory_Type:Directory_BB];
        [self.cusAORView removeFromSuperview];
        self.cusAORView = nil;
        self.cusAORView = [CusAddOrReduceBtnView cusAddOrReduceBtnView:self.cusDataAry];
        [self.cusAORView setFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40)];
        [self.cusAORView initAllViews];
        __weak typeof (self) wself = self;
        self.cusAORView.returnBlock = ^(NSInteger tag){
            cusSelector = tag;
            if (wself.cusDataAry.count > tag) {
                NSString *industryStr = [wself.cusDataAry objectAtIndex:tag];
//                for (int i = 0; i < self.industryAry.count; i ++) {
//                    IndustryModel *industryModel = [IndustryModel mj_objectWithKeyValues:[wself.industryAry objectAtIndex:i]];
//                    if ([industryStr isEqualToString:industryModel.name]) {
//                        industryID = industryModel.name;
//                        break;
//                    }
//                }
                //改成标签
                industryID = industryStr;
                if (wself.tableView) {
                    [wself.tableView.mj_header beginRefreshing];
                }
            }
        };
        [self.cusAORView.addBtn addTarget:self action:@selector(addBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.cusAORView];
    };
    [ZJBHelp getInstance].bbRootVC.tabBarController.tabBar.hidden = YES;
    [[ZJBHelp getInstance].bbRootVC.navigationController pushViewController:yzVC animated:YES];
}

- (void)createTableView{
    NSLog(@"self.view.frame.size.height %f",self.view.frame.size.height);
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64 + 40, self.view.frame.size.width, self.view.frame.size.height - 64 - 40) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f2f2f2"];
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    __unsafe_unretained UITableView *tableView1 = self.tableView;
    
    // 下拉刷新
    tableView1.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        footerFresh = NO;
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

- (NSMutableArray *)cellWithDataAry:(NSArray *) dataAry{
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
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self downloadData];
        });
    }];
}

- (UIView *)cusSearchView{
    if (!_cusSearchView) {
        _cusSearchView = [[CusSearchView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 58)];
        [_cusSearchView setLabelText:@"请输入你要搜索的问题"];
        //__weak typeof ([ZJBHelp getInstance].bbRootVC) wself = [ZJBHelp getInstance].bbRootVC;
        _cusSearchView.returnAction = ^(NSInteger tag){
            BBQuestionSearchVC *searchVC = [[BBQuestionSearchVC alloc]init];
            [ZJBHelp getInstance].bbRootVC.navigationController.navigationBar.hidden = YES;
            [ZJBHelp getInstance].bbRootVC.tabBarController.tabBar.hidden = YES;
            [[ZJBHelp getInstance].bbRootVC.navigationController pushViewController:searchVC animated:YES];
        };
    }
    return _cusSearchView;
}

- (void)downloadData {
    
        [[HttpManager shareManager] netStatus:^(AFNetworkReachabilityStatus status) {
            if(status == AFNetworkReachabilityStatusReachableViaWWAN || status ==AFNetworkReachabilityStatusReachableViaWiFi){
                GetQuestionsModel *model = [[GetQuestionsModel alloc]init];
                model.access_token = [[LoginVM getInstance] readLocal].token;
                model.id = @"0";
                if (footerFresh) {
                    footerCount++;
                    model.page = [NSString stringWithFormat:@"%ld",footerCount];
                }else{
                    model.page = @"0";
                }
                if (industryID) {
                    model.tag = industryID;
                }
                model.my = @"0";
                SendAndGetDataFromNet *sendAndget = [[SendAndGetDataFromNet alloc]init];
                __block SendAndGetDataFromNet *wsend = sendAndget;
                sendAndget.returnDict = ^(NSDictionary *dict){
                    if (1 == [[dict objectForKey:@"state"] intValue]) {
                        dispatch_async(dispatch_queue_create("question_queue", nil), ^{
                            self.requestCount = 0;
//                            industryID = nil;
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
                        });
                        
                    }else{
                        if (self.requestCount > 0) {
                            [Toast makeShowCommen:@"您的网络有问题, " ShowHighlight:@"请重置" HowLong:0.8];
                            self.requestCount = 0;
                            if (footerFresh) {
                                footerFresh = NO;
                                [self.tableView.mj_footer endRefreshing];
                            }else{
                                [self.tableView.mj_header endRefreshing];
                            }
                            return ;
                        }
                        [LoginVM getInstance].isGetToken = ^(){
                            model.access_token = [[LoginVM getInstance] readLocal].token;
                            [wsend dictFromNet:model WithRelativePath:@"Get_Question_List"];
                            self.requestCount ++;
                        };
                        [[LoginVM getInstance] loginWithUserInfoForGetNewToken:[[LoginVM getInstance] readLocal]];
                    }
                };
                [sendAndget dictFromNet:model WithRelativePath:@"Get_Question_List"];
            }else{
                [Toast makeShowCommen:@"您的网络有问题 " ShowHighlight:@"请重置" HowLong:0.8];
                if (footerFresh) {
                    footerFresh = NO;
                    [self.tableView.mj_footer endRefreshing];
                }else{
                    [self.tableView.mj_header endRefreshing];
                }

            }
        }];
}

- (void)refreshComplete {
    //[self.tableViewHeader refreshingAnimateStop];
    [UIView animateWithDuration:0.35f animations:^{
        //self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    } completion:^(BOOL finished) {
        [self.tableView reloadData];
        self.needRefresh = NO;
        if (footerFresh) {
            footerFresh = NO;
            [self.tableView.mj_footer endRefreshing];
        }else{
            [self.tableView.mj_header endRefreshing];
        }
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.questionsAry) {
//        if (0 == cusSelector) {
//            return self.questionsAry.count + 1;
//        }
        return self.questionsAry.count + 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifier = @"QuestionCellIdentifier";
    //if (cusSelector == 0) {
        if (indexPath.row == 0) {
//            static NSString* cuscellIdentifier = @"CusQuestionCellIdentifier";
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cuscellIdentifier];
//            if (!cell) {
//                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cuscellIdentifier];
//                [cell.contentView addSubview:self.sdCycleScrollView];
//            }
//            [cell setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            return cell;
        //}else if (indexPath.row == 1){
            static NSString* cuscellIdentifier = @"CusTwoIdentifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cuscellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cuscellIdentifier];
                [cell.contentView addSubview:self.cusSearchView];
            }
            [cell setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        QuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[QuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        if (self.questionsAry.count > indexPath.row - 1) {
            QuestionsLayout* cellLayouts = self.questionsAry[indexPath.row - 1];
            cell.cellLayout = cellLayouts;
        }
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
   // }
//    QuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (!cell) {
//        cell = [[QuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//    }
//    if (self.questionsAry.count > indexPath.row) {
//        QuestionsLayout* cellLayouts = self.questionsAry[indexPath.row];
//        cell.cellLayout = cellLayouts;
//    }
//    cell.delegate = self;
//    cell.indexPath = indexPath;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AppDelegate *appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (!appD.vip) {
        [UIView bch_showWithTitle:@"提示" message:@"查看问答详情要先加入建众帮会员哦！" buttonTitles:@[@"取消",@"确定"] callback:^(id sender, NSUInteger buttonIndex) {
            if (1 == buttonIndex) {
                //AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                
                //if (appDelegate.checkpay) {
                    ApplyVipVC *applyVipVC = [[ApplyVipVC alloc]init];
                    [self.navigationController pushViewController:applyVipVC animated:YES];
                //}
            }
        }];
        return;
    };
    
   // if (0 == cusSelector) {
        if (indexPath.row == 0) {
            return;
        //}else if(indexPath.row == 1){
            
        }else
        {
            if (self.questionsAry.count > indexPath.row - 1) {
                QuestionsLayout *layout = self.questionsAry[indexPath.row - 1];
                layout.questionsModel.row = [NSNumber numberWithInteger:indexPath.row - 1];
                BBQuestionDetailVC *vc = [[BBQuestionDetailVC alloc]init];
                __weak typeof (self) wself = self;
                vc.updateData = ^(){
                    [wself.tableView.mj_header beginRefreshing];
                };
                vc.questionModel = layout.questionsModel;
                self.tabBarController.tabBar.hidden = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            return;
        }
}

#pragma mark - Actions

- (void)tableViewCell:(TableViewCell *)cell didClickedImageWithCellLayout:(CellLayout *)layout atIndex:(NSInteger)index {
    
    NSMutableArray* tmp = [[NSMutableArray alloc] initWithCapacity:layout.imagePostionArray.count];
    QuestionsLayout *lay = (QuestionsLayout *)layout;
    for (NSInteger i = 0; i < layout.imagePostionArray.count; i ++) {
        LWImageBrowserModel *imageModel = [[LWImageBrowserModel alloc]initWithLocalImage:[LocalDataRW getImageWithDirectory:Directory_BQ RetalivePath:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:[lay.questionsModel.images objectAtIndex:i]]] imageViewSuperView:cell.contentView positionAtSuperView:CGRectFromString(layout.imagePostionArray[i]) index:index];
        [tmp addObject:imageModel];
    }
    LWImageBrowser* imageBrowser = [[LWImageBrowser alloc] initWithParentViewController:self
                                                                                  style:LWImageBrowserAnimationStyleScale
                                                                            imageModels:tmp
                                                                           currentIndex:index];
    imageBrowser.view.backgroundColor = [UIColor blackColor];
    [imageBrowser show];
}

- (void)tableViewCell:(UITableViewCell *)cell didClickedLinkWithData:(id)data clinkType:(Clink_Type)clink_type{
    if (clink_type == Clink_Type_One) {
        QuestionsModel *model = ((QuestionCell *)cell).cellLayout.questionsModel;
//        OtherPersonCentralVC *vc = [[OtherPersonCentralVC alloc]init];
        PublicOtherPersonVC *vc = [[UIStoryboard storyboardWithName:@"PublicOtherPersonVC" bundle:nil]instantiateInitialViewController];
        vc.user = model.user;
        [ZJBHelp getInstance].bbRootVC.tabBarController.tabBar.hidden = YES;
        [ZJBHelp getInstance].bbRootVC.navigationController.navigationBar.hidden = YES;
        [[ZJBHelp getInstance].bbRootVC.navigationController pushViewController:vc animated:YES];
    }else if (clink_type == Clink_Type_Two){
        //线下
        [self searchMinePosition:(TableViewCell *)cell WithLayout:((QuestionCell *)cell).cellLayout AtIndexPath:((QuestionCell *)cell).indexPath];
    }
}

- (void)tableViewCell:(TableViewCell *)cell didClickedCommentWithCellLayout:(CellLayout *)layout
          atIndexPath:(NSIndexPath *)indexPath clinkType:(Clink_Type)clink_type{
    if (clink_type == Clink_Type_One) {
        
    }else if (clink_type == Clink_Type_Two){
        
    }else if (clink_type == Clink_Type_Three){
        [self sameAsk:cell WithLayout:layout AtIndexPath:indexPath];
    }else if (clink_type == Clink_Type_Four){
        
    }else if (clink_type == Clink_Type_Six){
        
        PublicOtherPersonVC *vc = [[UIStoryboard storyboardWithName:@"PublicOtherPersonVC" bundle:nil]instantiateInitialViewController];
        
        QuestionsModel *model = ((QuestionsLayout *)layout).questionsModel;
        vc.user = model.user;
        
        //    vc.fromDynamicDetailVC = YES;
        vc.isSecVCPush = YES;
        
        if ([vc.user.uid isEqualToString:[LoginVM getInstance].readLocal._id] || vc.user.uid == nil) {
            return ;
        }
        
//        [self.navigationController setHidesBottomBarWhenPushed:YES];
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
//        [self.navigationController pushViewController:vc animated:YES];
        

        [ZJBHelp getInstance].bbRootVC.tabBarController.tabBar.hidden = YES;
        [ZJBHelp getInstance].bbRootVC.navigationController.navigationBar.hidden = YES;
        [[ZJBHelp getInstance].bbRootVC.navigationController pushViewController:vc animated:YES];
    }
}

//- (void)viewWillAppear:(BOOL)animated{
//    //[[ZJBHelp getInstance].bbRootVC.navigationController setNavigationBarHidden:NO animated:YES];
//    self.tabBarController.tabBar.hidden = YES;
//}

//进入地图，查看发问者与自己距离
- (void)searchMinePosition:(TableViewCell *) cell WithLayout:(CellLayout *) layout AtIndexPath:(NSIndexPath *) indexPath{
    QuestionsModel *questionModel = ((QuestionsLayout *)layout).questionsModel;
    RMSearchAroundItemList *rMSearchAroundItemList = [[RMSearchAroundItemList alloc]init];
    rMSearchAroundItemList.user = questionModel.user;
    rMSearchAroundItemList.city = questionModel.city;
    rMSearchAroundItemList.lng = questionModel.lng;
    rMSearchAroundItemList.lat = questionModel.lat;
    rMSearchAroundItemList.address = questionModel.address;
    rMSearchAroundItemList.province = questionModel.province;
    rMSearchAroundItemList.uid = questionModel.uid;
    RMNearbyPersontVC *rmNearByPersontVC = [[RMNearbyPersontVC alloc]init];
    rmNearByPersontVC.rMSearchAroundItemList = rMSearchAroundItemList;
    [ZJBHelp getInstance].bbRootVC.tabBarController.tabBar.hidden = YES;
    [[ZJBHelp getInstance].bbRootVC.navigationController pushViewController:rmNearByPersontVC animated:YES];
}

- (void)sameAsk:(TableViewCell *) cell WithLayout:(CellLayout *) layout AtIndexPath:(NSIndexPath *) indexPath{
    SameAskModel *sameAskModel = [[SameAskModel alloc]init];
    sameAskModel.access_token = [[LoginVM getInstance] readLocal].token;
    QuestionsLayout *layout1 = (QuestionsLayout *)layout;
    QuestionsModel *questionsModel = layout1.questionsModel;
    sameAskModel.question_id = questionsModel.question_id;
    if ([questionsModel.is_sameAsk intValue] == 1) {
        return;
    }
    SendAndGetDataFromNet *send = [[SendAndGetDataFromNet alloc]init];
    __weak BBQuestionsNewVC *wself = self;
    __block SendAndGetDataFromNet *wsend = send;
    send.returnModel = ^(GetValueObject *model,int state){
        if (!model) {
            [Toast makeShowCommen:@"您的网络 " ShowHighlight:@"出现故障" HowLong:0.8];
        }else{
            if (1 == state) {
                questionsModel.is_sameAsk = @"1";
                questionsModel.sameAsk_count = [NSString stringWithFormat:@"%d",[questionsModel.sameAsk_count intValue] + 1];
                QuestionsLayout *newLayout = [self layoutWithDetailListModel:questionsModel index:preSelector IsDetail:NO IsLast:YES];
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

- (void)updateSameAsk:(NSNotification *)noti{
    NSDictionary *dict = noti.userInfo;
    NSNumber *row = [dict objectForKey:@"ROW"];
    QuestionsLayout *layout = self.questionsAry[[row integerValue]];
    QuestionsModel *questionsModel = layout.questionsModel;
    questionsModel.is_sameAsk = @"1";
    questionsModel.sameAsk_count = [NSString stringWithFormat:@"%d",[questionsModel.sameAsk_count intValue] + 1];
    QuestionsLayout *newLayout = [self layoutWithDetailListModel:questionsModel index:preSelector IsDetail:NO IsLast:YES];
    [self.questionsAry replaceObjectAtIndex:[row integerValue] withObject:newLayout];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[row integerValue] inSection:0]]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (0 == cusSelector) {
        if (indexPath.row == 0) {
//            return self.view.glw_width / 2.419;
//        }else if(indexPath.row == 1){
            return 58;
        }else{
            if (self.questionsAry.count > indexPath.row - 1) {
                QuestionsLayout *layout = self.questionsAry[indexPath.row - 1];
                return layout.cellHeight;
            }
        }
//    }
//    if (self.questionsAry.count > indexPath.row) {
//        QuestionsLayout *layout = self.questionsAry[indexPath.row];
//        return layout.cellHeight + 10;
//    }
    return 0;
}

- (NSMutableArray *)dataAry{
    if (_dataAry) {
        return _dataAry;
    }
    _dataAry = [[NSMutableArray alloc]init];
    return _dataAry;
}

@end
