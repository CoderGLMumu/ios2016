//
//  BQDynamicVC.m
//  JZBRelease
//
//  Created by zjapple on 16/4/28.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "BQDynamicVC.h"
#import "Defaults.h"
#import "RecommendCell.h"
#import "LWImageBrowser.h"
#import "TableViewCell.h"
#import "LWDefine.h"
#import "LWAlchemy.h"
#import "StatusModel.h"
#import "CellLayout.h"
#import "CommentView.h"
#import "CommentModel.h"
#import "BQFilterVC.h"
#import "PopupView.h"
#import "LewPopupViewAnimationDrop.h"
#import "DynamicDetailVC.h"
#import "SendDynamicVC.h"
#import "GetDynamicListVM.h"
#import "LoginVM.h"
#import "SendEvaluateModel.h"
#import "SendAndGetDataFromNet.h"
#import "DataBaseHelperSecond.h"
#import "RewardAlertView.h"
#import "LewPopupViewAnimationSpring.h"
#import "PasswordView.h"
#import "CustomAlertView.h"
#import "RewardModel.h"
#import "SendActivityVC.h"
#import "GetActivityListModel.h"
#import "MessageComeView.h"
#import "MessageListVC.h"
#import "MessageRequestModel.h"
#import "MesageCellModel.h"
#import "MJRefresh.h"
#import "DealNormalUtil.h"
#import "WJRefresh.h"
#import "ZanModel.h"
//#import "OtherPersonCentralVC.h"
#import "PublicOtherPersonVC.h"

#import "SendAndGetDataFromNet.h"
#import "ZJBHelp.h"

@interface BQDynamicVC ()<TableViewCellDelegate,UITableViewDataSource,UITableViewDelegate,ChatKeyBoardDataSource, ChatKeyBoardDelegate>{
    UISegmentedControl *segment;
    int inteval;
    int imageWidth;
    int avatarWidth;
    int fontSize;
    BOOL footerFresh;
    UIViewController *pushVC;
}
@property (nonatomic,strong) NSMutableArray* fakeDatasource;

//@property (nonatomic,strong) CommentView* commentView;
@property (nonatomic, strong) NSMutableArray *dataSource,*ActivityDataSource,*recommendAry;
@property (nonatomic, assign,getter = isNeedRefresh) BOOL needRefresh;
@property (nonatomic, strong) CommentModel* postComment;
@property (nonatomic, strong) WJRefresh *refresh;
@property (nonatomic, strong) ChatKeyBoard *chatKeyBoard;
@property (nonatomic, assign) float moveSet;
@property (nonatomic, strong) PasswordView *passwordView;
@property (nonatomic, assign) CGFloat kRefreshBoundary;
@property (nonatomic, assign) BOOL isUP;
@property (nonatomic, strong) MessageComeView *messageComeView;
@property (nonatomic, assign) NSInteger requestCount;
@end



@implementation BQDynamicVC
@synthesize kRefreshBoundary;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.requestCount = 0;
    kRefreshBoundary = 40.0f;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (!self.fromPernoal) {
        [self.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49)];
        pushVC = [ZJBHelp getInstance].bqRootVC;
    }else{
        self.navigationItem.title = [NSString stringWithFormat:@"%@动态",self.user.nickname];
        [self configNav];
        pushVC = self;
    }

    [self createTableView:0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.chatKeyBoard = [ChatKeyBoard keyBoardWithNavgationBarTranslucent:YES];
    self.chatKeyBoard.delegate = self;
    self.chatKeyBoard.dataSource = self;
    self.chatKeyBoard.placeHolder = @"请输入消息";
    self.chatKeyBoard.allowMore = NO;
    self.chatKeyBoard.allowVoice = NO;
    self.chatKeyBoard.allowFace = NO;
    self.chatKeyBoard.hidden = YES;
    [self.view addSubview:self.chatKeyBoard];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    //regist addObserve of UpdateDynamic;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshBegin) name:@"UpdateDynamic" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshBegin) name:@"UpdateDetail" object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MessageComing) name:@"MessageComing" object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MessageComed:) name:@"MessageComed" object:nil];
}


- (void)viewWillAppear:(BOOL)animated{
    if (self.fromPernoal) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
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

-(void) backAction{
    if (self.fromPernoal) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [pushVC.navigationController popViewControllerAnimated:YES];
    [ZJBHelp getInstance].bqRootVC.navigationController.navigationBar.hidden = YES;
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    if (self.chatKeyBoard.isUP) {
        self.isUP = YES;
    }
    [self.chatKeyBoard keyboardDown];
}

- (void)createTableView : (NSInteger) which{
    UITableView *tableView;
    if (self.fromPernoal) {
        tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
    }else{
        //tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 49) style:UITableViewStylePlain];
        
        tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    }
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Inteval_Color" WithKind:XMLTypeColors]];
    [self.view addSubview:tableView];

    self.tableView = tableView;

    _refresh = [[WJRefresh alloc]init];
    //self.needRefresh = YES;
    __weak typeof(self)weakSelf = self;
    [_refresh addHeardRefreshTo:tableView heardBlock:^{
        [weakSelf createData];
    } footBlok:^{
        [weakSelf createFootData];
    }];
    [_refresh beginHeardRefresh];
    
}

-(void)MessageComed:(id)sender{
    //[ZJBHelp getInstance].bqRootVC.navigationController.navigationBar.translucent = YES;
    if (self.messageComeView) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.tableView setFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 49)];
            self.messageComeView.alpha = 0;
        } completion:^(BOOL finished) {
            self.messageComeView.hidden = YES;
            [self.refresh beginHeardRefresh];
        }];
    }
    return;
}


-(void)MessageComing{
    self.automaticallyAdjustsScrollViewInsets = NO;
    MessageComeModel *messageComeModel = [[MessageComeModel alloc]init];
    messageComeModel.avatar = @"";
    NSNumber *messageCount = [LocalDataRW returnCountWithType:@"dynamic_reply"];
    if ([messageCount intValue] == 0) {
        if (self.messageComeView) {
            self.messageComeView.hidden = YES;
            [UIView animateWithDuration:0.5 animations:^{
                [self.tableView setFrame:CGRectMake(0, 64, self.tableView.frame.size.width, self.tableView.frame.size.height)];
            } completion:^(BOOL finished) {
                
            }];
        }
        return;
    }
    messageComeModel.messageCount = [NSString stringWithFormat:@"%d",[messageCount intValue]];
    [UIView animateWithDuration:0.5 animations:^{
        [self.tableView setFrame:CGRectMake(0, 64 + 49, self.tableView.frame.size.width, self.tableView.frame.size.height)];
        self.messageComeView.alpha = 1;
    } completion:^(BOOL finished) {
        if (!self.messageComeView) {
            self.messageComeView = [MessageComeView initWithModel:messageComeModel WithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 49)];
            __block typeof (pushVC) wpushVC = pushVC;
            self.messageComeView.returnAction = ^(Clink_Type clink_type){
                dispatch_async(dispatch_queue_create("", nil), ^{
                    SendAndGetDataFromNet *send = [[SendAndGetDataFromNet alloc]init];
                    send.returnArray = ^(NSArray *ary){
                        MessageListVC *messageListVC = [[MessageListVC alloc]init];
                        messageListVC.dataAry = [[NSMutableArray alloc]initWithArray:ary];
                        [wpushVC.navigationController pushViewController:messageListVC animated:YES];
                        wpushVC.tabBarController.tabBar.hidden = YES;
                    };
                    MessageRequestModel *requestModel = [[MessageRequestModel alloc]init];
                    requestModel.access_token = [[LoginVM getInstance] readLocal].token;
                    requestModel.type = @"2";
                    [send dictDataFromNet:requestModel WithRelativePath:@"Get_Dynamic_MessageList"];
                });
                
            };
            [self.view addSubview:self.messageComeView];
        }{
            [self.messageComeView initWithModel:messageComeModel];
            self.messageComeView.hidden = NO;
        }
    }];
}


/****************************************************************************/
/**
 *  在这里生成LWAsyncDisplayView的模型。
 */
/****************************************************************************/

- (CellLayout *)layoutWithStatusModel:(StatusModel *)statusModel index:(NSInteger)index {
    //生成Storage容器
    LWStorageContainer* container = [[LWStorageContainer alloc] init];
    //生成Layout
    CellLayout* layout = [[CellLayout alloc] initWithContainer:container
                                                   statusModel:statusModel
                                                         index:index
                                                 dateFormatter:self.dateFormatter isDynamicDe:NO];
    return layout;
}

//- (DynamicLayout *)layoutWithEvaluateModel:(EvaluateModel *)evaluateModel index:(NSInteger)index {
//    //生成Storage容器
//    LWStorageContainer* container = [[LWStorageContainer alloc] init];
//    //生成Layout
//    DynamicLayout* layout = [[DynamicLayout alloc]initWithContainer:container Model:evaluateModel dateFormatter:[self dateFormatter] index:index];
//    return layout;
//}

/****************************************************************************/


#pragma mark - Actions

- (void)tableViewCell:(TableViewCell *)cell didClickedImageWithCellLayout:(CellLayout *)layout atIndex:(NSInteger)index {

    NSMutableArray* tmp = [[NSMutableArray alloc] initWithCapacity:layout.imagePostionArray.count];
    for (NSInteger i = 0; i < layout.imagePostionArray.count; i ++) {
        NSString *rect = [layout.imagePostionArray objectAtIndex:i];
        CGRect rect1 = CGRectFromString(rect);
        rect1 = CGRectMake(rect1.origin.x, rect1.origin.y + 64, rect1.size.width, rect1.size.height);
        LWImageBrowserModel *imageModel = [[LWImageBrowserModel alloc]initWithLocalImage:[LocalDataRW getImageWithDirectory:Directory_BQ RetalivePath:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:[layout.statusModel.images objectAtIndex:i]]] imageViewSuperView:cell.contentView positionAtSuperView:CGRectFromString(NSStringFromCGRect(rect1)) index:index];
        [tmp addObject:imageModel];
    }
    LWImageBrowser* imageBrowser = [[LWImageBrowser alloc] initWithParentViewController:self
                                                                                  style:LWImageBrowserAnimationStyleScale
                                                                            imageModels:tmp
                                                                           currentIndex:index];
    imageBrowser.view.backgroundColor = [UIColor blackColor];
    [imageBrowser show];
}

/**
 *  点击链接
 *
 */
- (void)tableViewCell:(TableViewCell *)cell didClickedLinkWithData:(id)data clinkType:(Clink_Type)clink_type{
    StatusModel *statusModel = cell.cellLayout.statusModel;
    if (clink_type == Clink_Type_One) {
//        OtherPersonCentralVC *vc = [[OtherPersonCentralVC alloc] init];
        PublicOtherPersonVC *vc = [[UIStoryboard storyboardWithName:@"PublicOtherPersonVC" bundle:nil]instantiateInitialViewController];
        
        vc.view.backgroundColor = [UIColor whiteColor];
        vc.user = statusModel.user;
        
        if ([vc.user.uid isEqualToString:[LoginVM getInstance].readLocal._id] || vc.user.uid == nil) {
            return ;
        }
        
        [ZJBHelp getInstance].bqRootVC.navigationController.navigationBar.hidden = YES;
        self.tabBarController.tabBar.hidden = YES;
        [pushVC.navigationController pushViewController:vc animated:YES];
    }else if (clink_type == Clink_Type_Two){
        NSLog(@"goto content");
        DynamicDetailVC *vc = [[DynamicDetailVC alloc]init];
        vc.statusModel = statusModel;
        self.tabBarController.tabBar.hidden = YES;
        [pushVC.navigationController pushViewController:vc animated:YES];
        
    }else if (clink_type == Clink_Type_Three){
//        OtherPersonCentralVC *vc = [[OtherPersonCentralVC alloc] init];
        
        PublicOtherPersonVC *vc = [[UIStoryboard storyboardWithName:@"PublicOtherPersonVC" bundle:nil]instantiateInitialViewController];
        
        vc.view.backgroundColor = [UIColor whiteColor];
        EvaluateModel *evaluateModel = [EvaluateModel mj_objectWithKeyValues:[statusModel.evaluate objectAtIndex:0]];
        vc.user = evaluateModel.user;
        
        if ([vc.user.uid isEqualToString:[LoginVM getInstance].readLocal._id] || vc.user.uid == nil) {
            return ;
        }
        
        self.tabBarController.tabBar.hidden = YES;
        [ZJBHelp getInstance].bqRootVC.navigationController.navigationBar.hidden = YES;
        [pushVC.navigationController pushViewController:vc animated:YES];
    }else if (clink_type == Clink_Type_Four){
        DynamicDetailVC *vc = [[DynamicDetailVC alloc]init];
        StatusModel *statusModel = cell.cellLayout.statusModel;
        vc.which = 0;
        vc.indexPath = cell.indexPath;
        vc.statusModel = statusModel;
        self.tabBarController.tabBar.hidden = YES;
        [pushVC.navigationController pushViewController:vc animated:YES];
    }else if (clink_type == Clink_Type_Five){
//        OtherPersonCentralVC *vc = [[OtherPersonCentralVC alloc] init];
        
        PublicOtherPersonVC *vc = [[UIStoryboard storyboardWithName:@"PublicOtherPersonVC" bundle:nil]instantiateInitialViewController];
        
        vc.view.backgroundColor = [UIColor whiteColor];
        EvaluateModel *evaluateModel = [EvaluateModel mj_objectWithKeyValues:[statusModel.evaluate objectAtIndex:1]];
        vc.user = evaluateModel.user;
        
        if ([vc.user.uid isEqualToString:[LoginVM getInstance].readLocal._id] || vc.user.uid == nil) {
            return ;
        }
        
        self.tabBarController.tabBar.hidden = YES;
        [ZJBHelp getInstance].bqRootVC.navigationController.navigationBar.hidden = YES;
        [pushVC.navigationController pushViewController:vc animated:YES];
    }else if (clink_type == Clink_Type_Six){
        DynamicDetailVC *vc = [[DynamicDetailVC alloc]init];
        StatusModel *statusModel = cell.cellLayout.statusModel;
        vc.which = 1;
        vc.indexPath = cell.indexPath;
        vc.statusModel = statusModel;
        self.tabBarController.tabBar.hidden = YES;
        [pushVC.navigationController pushViewController:vc animated:YES];
    }else if (clink_type == Clink_Type_Seven){
        DynamicDetailVC *vc = [[DynamicDetailVC alloc]init];
        StatusModel *statusModel = cell.cellLayout.statusModel;
        vc.statusModel = statusModel;
        self.tabBarController.tabBar.hidden = YES;
        [pushVC.navigationController pushViewController:vc animated:YES];
    }
}

- (void)tableViewCell:(TableViewCell *)cell didClickedCommentWithCellLayout:(CellLayout *)layout
          atIndexPath:(NSIndexPath *)indexPath clinkType:(Clink_Type)clink_type{
    if (clink_type == Clink_Type_One) {
        DynamicDetailVC *vc = [[DynamicDetailVC alloc]init];
        vc.statusModel = layout.statusModel;
        self.tabBarController.tabBar.hidden = YES;
        [pushVC.navigationController pushViewController:vc animated:YES];
    }else if (clink_type == Clink_Type_Two){
        //点赞
        [self dianZanCell:cell WithLayout:layout AtIndexPath:indexPath];
    }else if (clink_type == Clink_Type_Three){
        [self rewardActionCell:cell WithLayout:layout AtIndexPath:indexPath];
    }else if (clink_type == Clink_Type_Four){
        
    }else{
        StatusModel *statusModel = cell.cellLayout.statusModel;
//        OtherPersonCentralVC* vc = [[OtherPersonCentralVC alloc] init];
        
        PublicOtherPersonVC *vc = [[UIStoryboard storyboardWithName:@"PublicOtherPersonVC" bundle:nil]instantiateInitialViewController];
        
        vc.view.backgroundColor = [UIColor whiteColor];
        vc.user = statusModel.user;
        
        if ([vc.user.uid isEqualToString:[LoginVM getInstance].readLocal._id] || vc.user.uid == nil) {
            return ;
        }
        
        [ZJBHelp getInstance].bqRootVC.navigationController.navigationBar.hidden = YES;
        self.tabBarController.tabBar.hidden = YES;
        [pushVC.navigationController pushViewController:vc animated:YES];
    }
}

-(void) dianZanCell:(TableViewCell *)cell WithLayout:(CellLayout *) layout AtIndexPath:(NSIndexPath *) indexPath{
    ZanModel *zanModel = [[ZanModel alloc]init];
    zanModel.access_token = [[LoginVM getInstance] readLocal].token;
    zanModel.dynamic_id = layout.statusModel.id;
    SendAndGetDataFromNet *sendAndGet = [[SendAndGetDataFromNet alloc]init];
    __weak typeof(sendAndGet) wsend = sendAndGet;
    __block CellLayout *wlayout = layout;
    __weak BQDynamicVC *wself = self;
    sendAndGet.returnModel = ^(GetValueObject *obj,int state){
        if (!obj) {
            [Toast makeShowCommen:@"您的网络有问题 " ShowHighlight:@"请重置" HowLong:0.8];
        }else{
            if (1 == state) {
                wself.requestCount = 0;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                    
                        if ([wlayout.statusModel.iszan intValue] == 1) {
                            wlayout.statusModel.zan_count = [NSNumber numberWithInteger:[wlayout.statusModel.zan_count integerValue] - 1];
                            wlayout.statusModel.iszan = [NSNumber numberWithInt:0];
                        }else{
                            wlayout.statusModel.zan_count = [NSNumber numberWithInteger:[wlayout.statusModel.zan_count integerValue] + 1];
                            wlayout.statusModel.iszan = [NSNumber numberWithInt:1];
                        }
                    NSLog(@"indexPath.row %ld",indexPath.row);
                        CellLayout *subLayout = [wself layoutWithStatusModel:wlayout.statusModel index:indexPath.row];
                        [wself.dataSource replaceObjectAtIndex:indexPath.row withObject:subLayout];
                        [wself.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]]
                                               withRowAnimation:UITableViewRowAnimationAutomatic];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            if ([wlayout.statusModel.iszan intValue] == 1) {
                                [Toast makeShowCommen:@"您为该条动态," ShowHighlight:@"成功点赞" HowLong:1.5];
                            }else{
                                [Toast makeShowCommen:@"您为该条动态," ShowHighlight:@"取消点赞" HowLong:1.5];
                            }
                        });
                   
                });
            }else{
                if (wself.requestCount > 1) {
                    [Toast makeShowCommen:@"您的网络有问题 " ShowHighlight:@"请重置" HowLong:0.8];
                    return ;
                }
                [LoginVM getInstance].isGetToken = ^(){
                    zanModel.access_token = [[LoginVM getInstance] readLocal].token;
                    [wsend commenDataFromNet:zanModel WithRelativePath:@"Zan_Dynamic"];
                    wself.requestCount ++;
                };
                [[LoginVM getInstance] loginWithUserInfoForGetNewToken:[[LoginVM getInstance] readLocal]];
            }
        }
    };
    [sendAndGet commenDataFromNet:zanModel WithRelativePath:@"Zan_Dynamic"];
}

-(void) rewardActionCell:(TableViewCell *)cell WithLayout:(CellLayout *) layout AtIndexPath:(NSIndexPath *) indexPath{
    RewardAlertView *view = [RewardAlertView defaultPopupView];
    view.parentVC = self;
    Users *users = [[Users alloc]init];
    users.uid = [[LoginVM getInstance] readLocal]._id;
    users = (Users *)[[DataBaseHelperSecond getInstance] getModelFromTabel:users];
    StatusModel *statusModel = layout.statusModel;
    if ([users.nickname isEqualToString:statusModel.user.nickname]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"打赏失败" message:@"原因：不能对自己打赏" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    [view.balanceLabel setText:users.money];
    __block BQDynamicVC *wself = self;
    __block CellLayout *wlayout = layout;
    view.sendAction = ^(Clink_Type clink_type,NSString *howMuch){
        if (clink_type == Clink_Type_One) {
//            self.passwordView = [[PasswordView alloc]initWithFrame:self.view.frame];
//            self.tabBarController.tabBar.hidden = YES;
//            self.passwordView.vc = self;
//            self.passwordView.returnData = ^(NSString *passwordStr){
//                NSLog(@"%@",passwordStr);
            
                if ([users.score integerValue] < [howMuch integerValue]) {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"打赏失败" message:@"原因：您的余额不足" delegate:wself cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                    return ;
                }
                CustomAlertView *alertView = [CustomAlertView defaultCustomAlertView:@"打赏中..."];
                [self lew_presentPopupView:alertView animation:[LewPopupViewAnimationSpring new]];
                [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
                RewardModel *rewardModel = [[RewardModel alloc]init];
                rewardModel.access_token = [[LoginVM getInstance] readLocal].token;
                rewardModel.dynamic_id = statusModel.id;
                rewardModel.score = howMuch;
                SendAndGetDataFromNet *sendAndGet = [[SendAndGetDataFromNet alloc]init];
                __block typeof(sendAndGet) wsend = sendAndGet;
                sendAndGet.returnModel = ^(GetValueObject *obj,int state){
                    if (!obj) {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [wself lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
                            [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                            [Toast makeShowCommen:@"您的网络有问题 " ShowHighlight:@"请重置" HowLong:0.8];
                        });
                    }else{
                        if (1 == state) {
                            [alertView.label setText:@"打赏完成"];
                            users.score = [NSString stringWithFormat:@"%ld",[users.score integerValue] - [howMuch integerValue]];
                            [[DataBaseHelperSecond getInstance] delteModelFromTabel:users];
                            [[DataBaseHelperSecond getInstance] insertModelToTabel:users];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [wself lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
                                [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(wlayout.rewardNumPosition.origin.x, wlayout.rewardNumPosition.origin.y - 2 * wlayout.rewardNumPosition.size.width, wlayout.rewardNumPosition.size.width, wlayout.rewardNumPosition.size.height)];
                                [label setTextColor:[UIColor redColor]];
                                [label setText:@"+1"];
                                [cell addSubview:label];
                                [UIView animateWithDuration:1 animations:^{
                                    label.frame = wlayout.rewardNumPosition;
                                } completion:^(BOOL finished) {
                                    [label removeFromSuperview];
                                    statusModel.reward_count = [NSNumber numberWithInteger:[statusModel.reward_count integerValue] + 1];
                                    wlayout = [wself layoutWithStatusModel:statusModel index:indexPath.row];
                                    [wself.dataSource replaceObjectAtIndex:indexPath.row withObject:wlayout];
                                    [wself.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                                    [Toast makeShowCommen:@"" ShowHighlight:@"打赏成功" HowLong:0.8];
                                }];
                            });
                        }else{
                            if (wself.requestCount > 1) {
                                [alertView.label setText:@"打赏失败"];
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    [wself lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
                                    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                                });
                                [Toast makeShowCommen:@"您的网络有问题 " ShowHighlight:@"请重置" HowLong:0.8];
                                return ;
                            }
                            [LoginVM getInstance].isGetToken = ^(){
                                rewardModel.access_token = [[LoginVM getInstance] readLocal].token;
                                [wsend commenDataFromNet:rewardModel WithRelativePath:@"Reward_Data"];
                                wself.requestCount ++;
                            };
                            [[LoginVM getInstance] loginWithUserInfoForGetNewToken:[[LoginVM getInstance] readLocal]];

                        }
                    }
                };
                [sendAndGet commenDataFromNet:rewardModel WithRelativePath:@"Reward_Data"];
            //};
//            [self.view addSubview:self.passwordView];
//            [self.passwordView Action];
        }
    };
    [self lew_presentPopupView:view animation:[LewPopupViewAnimationSpring new] dismissed:^{
        NSLog(@"动画结束");
    }];
}

#pragma 文本改变
- (void)chatKeyBoardTextViewDidChange:(UITextView *)textView{
    if (textView.text.length > 200) {
        [Toast makeShowCommen:@"抱歉，您的评论字数已超" ShowHighlight:@"200" HowLong:1.5];
        return;
    }
}

#pragma mark -- 发送文本
- (void)chatKeyBoardSendText:(NSString *)text
{
    if (text.length <= 0) {
        //[Toast makeShowCommen:@"抱歉，您还未写下评论" ShowHighlight:@"不能评论" HowLong:1];
        return;
    }
    if (text.length > 200) {
        [Toast makeShowCommen:@"抱歉，您的评论字数已超" ShowHighlight:@"200" HowLong:1];
        return;
    }
    [self.chatKeyBoard keyboardDown];
    
    CellLayout *layout = [self.dataSource objectAtIndex:self.chatKeyBoard.indexPath.row];
    if (layout && [layout isKindOfClass:[CellLayout class]]) {
        StatusModel *statusModel = layout.statusModel;
        SendEvaluateModel *sendModel = [[SendEvaluateModel alloc]init];
        sendModel.access_token = [[LoginVM getInstance] readLocal].token;
        sendModel.dynamic_id = statusModel.id;
        sendModel.eval_id = @"0";
        sendModel.content = text;
        SendAndGetDataFromNet *sendAndGet = [[SendAndGetDataFromNet alloc]init];
        __weak BQDynamicVC *wself = self;
        sendAndGet.returnModel = ^(GetValueObject *obj,int state){
            if (1 == state) {
                DataBaseHelperSecond *db = [DataBaseHelperSecond getInstance];
                Users *users = [[Users alloc]init];
                users.uid = [[LoginVM getInstance] readLocal]._id;
                users = (Users *)[db getModelFromTabel:users];
                EvaluateModel *evaluateModel = [[EvaluateModel alloc]init];
                evaluateModel.eval_id = @"";
                evaluateModel.dynamic_id = statusModel.id;
                evaluateModel.eval_uid = [[LoginVM getInstance] readLocal]._id;
                if (!evaluateModel.eval_uid || evaluateModel.eval_uid.length <= 0) {
                    DataBaseHelperSecond *db = [DataBaseHelperSecond getInstance];
                    Users *users = [[Users alloc]init];
                    users.uid = [[LoginVM getInstance] readLocal]._id;
                    users = (Users *)[db getModelFromTabel:users];
                    evaluateModel.eval_uid = users.uid;
                }
                evaluateModel.eval_u_nickname = users.nickname;
                evaluateModel.eval_to_uid = @"0";
                evaluateModel.eval_to_u_nickname = @"";
                evaluateModel.eval_content = text;
                evaluateModel.create_time = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
                evaluateModel.user = users;
                evaluateModel._child = nil;
                [wself postCommentWithCommentModel:evaluateModel WithIndex:self.chatKeyBoard.indexPath.row];
                [Toast makeShowCommen:@"恭喜您，" ShowHighlight:@"评论成功" HowLong:1.5];
            }else{
                [Toast makeShowCommen:@"抱歉，您的网络出现故障，" ShowHighlight:@"评论失败" HowLong:1.5];
            }
        };
        [sendAndGet commenDataFromNet:sendModel WithRelativePath:@"Send_Evaluate"];
    }
}
/**
 *  发表评论
 *
 */
- (void)postCommentWithCommentModel:(GetValueObject *)model WithIndex : (NSInteger) index {
    CellLayout* layout = [self.dataSource objectAtIndex:index];
    NSMutableArray* newCommentLists = [[NSMutableArray alloc] initWithArray:layout.statusModel.evaluate];
    NSDictionary *evDict = [[model class] entityToDictionary:model];
    [newCommentLists insertObject:evDict atIndex:0];
    StatusModel* statusModel = layout.statusModel;
    statusModel.evaluate = newCommentLists;
    statusModel.evaluation_count = [NSNumber numberWithInteger:[statusModel.evaluation_count integerValue] + 1];
    layout = [self layoutWithStatusModel:statusModel index:index];
    [self.dataSource replaceObjectAtIndex:index withObject:layout];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)refreshComplete {
    //[self.tableViewHeader refreshingAnimateStop];
    [UIView animateWithDuration:0.35f animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(64.0f, 0.0f, 0.0f, 0.0f);
    } completion:^(BOOL finished) {
        [self.tableView reloadData];
        self.needRefresh = NO;
        [self.refresh endRefresh];
        //[self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - KeyboardNotifications

//- (void)tapView:(id)sender {
//    [self.commentView endEditing:YES];
//}


- (void)createData{
    NSLog(@"-----------头部刷新数据-----------");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self downloadData];
    });
    
}

- (void)createFootData{
    NSLog(@"-----------尾部加载更多数据-----------");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        footerFresh = YES;
        [self downloadData];
    });
}

-(void)selectSetting{
    NSLog(@"hello,btn widht is ");
    BQFilterVC *vc = [[BQFilterVC alloc]init];
    [pushVC.navigationController pushViewController:vc animated:YES];
    
}

-(void)sendQuestion{
    SendDynamicVC *sendVC = [[SendDynamicVC alloc]init];
    [pushVC.navigationController pushViewController:sendVC animated:YES];
    self.tabBarController.tabBar.hidden = YES;
//    PopupView *view = [PopupView defaultPopupView];
//    view.parentVC = self;
//    
//    view.sendAction = ^(Clink_Type clink_type){
//        if (clink_type == Clink_Type_One) {
//            
//        }else if (clink_type == Clink_Type_Two){
//            
//        }else{
//            SendActivityVC *sendAcVC = [[SendActivityVC alloc]init];
//            [pushVC.navigationController pushViewController:sendAcVC animated:YES];
//            self.tabBarController.tabBar.hidden = YES;
//
//        }
//    };
//    [self lew_presentPopupView:view animation:[LewPopupViewAnimationDrop new] dismissed:^{
//        NSLog(@"动画结束");
//    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

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
    
    return (long)self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentifier = @"cellIdentifier";
    TableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    if (self.dataSource.count > indexPath.row) {
        CellLayout* cellLayout = self.dataSource[indexPath.row];
        cell.cellLayout = cellLayout;
    }
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isUP) {
        self.isUP = NO;
        return;
    }
    
    if (self.dataSource.count > indexPath.row) {
        CellLayout* cellLayout = self.dataSource[indexPath.row];
        DynamicDetailVC *vc = [[DynamicDetailVC alloc]init];
        vc.statusModel = cellLayout.statusModel;
        self.tabBarController.tabBar.hidden = YES;
        [pushVC.navigationController pushViewController:vc animated:YES];
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"self.ActivityDataSource.count is %ld",self.dataSource.count);
    if (self.dataSource.count >= indexPath.row) {
        CellLayout* layout = self.dataSource[indexPath.row];
        return layout.cellHeight + 64 + 44 + 10;
    }else{
        return 0;
    }
    
}

#pragma mark - UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self.commentView endEditing:YES];
//    CGFloat offset = scrollView.contentOffset.y;
//    // [self.tableViewHeader loadingViewAnimateWithScrollViewContentOffset:offset];
//}
//
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
//    CGFloat offset = scrollView.contentOffset.y;
//    if (offset <= -kRefreshBoundary) {
//        [self refreshBegin];
//    }
//}

- (void)refreshBegin {
    [UIView animateWithDuration:0.2f animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(kRefreshBoundary, 0.0f, 0.0f, 0.0f);
    } completion:^(BOOL finished) {
        // [self.tableViewHeader refreshingAnimateBegin];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self downloadData];
        });
    }];
}

- (void)downloadData {
    
        [[HttpManager shareManager] netStatus:^(AFNetworkReachabilityStatus status) {
                if(status == AFNetworkReachabilityStatusReachableViaWWAN || status ==AFNetworkReachabilityStatusReachableViaWiFi){
                    GetDynamicListModel *model = [[GetDynamicListModel alloc]init];
                    model.access_token = [[LoginVM getInstance] readLocal].token;
                    model.id = @"0";
                    if (footerFresh) {
                        CellLayout *layout = [self.dataSource lastObject];
                        model.pid = layout.statusModel.id;
                    }else{
                        model.pid = @"0";
                    }
                    
                    if (self.fromPernoal) {
                        model.user_id = self.user.uid;
                    }
                
                    SendAndGetDataFromNet *send = [[SendAndGetDataFromNet alloc]init];
                    __block typeof (send) wsend = send;
                    __block typeof (self) wself = self;
                    send.returnArray = ^(NSArray *ary){
                        if (!ary) {
                            if (wself.requestCount > 1) {
                                [wself refreshComplete];
                                [Toast makeShowCommen:@"您的网络有问题 " ShowHighlight:@"请重置" HowLong:0.8];
                                return ;
                            }
                            [LoginVM getInstance].isGetToken = ^(){
                                model.access_token = [[LoginVM getInstance] readLocal].token;
                                [wsend commenDataFromNet:model WithRelativePath:@"Get_DynamicList"];
                                wself.requestCount ++;
                            };
                            [[LoginVM getInstance] loginWithUserInfoForGetNewToken:[[LoginVM getInstance] readLocal]];

                        }else{
                            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                            wself.requestCount = 0;
                            
                            if (footerFresh) {
                                NSInteger beginCount = self.dataSource.count - 1;
                                [self.fakeDatasource insertObjects:ary atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(beginCount, ary.count)]];
                                for (NSInteger i = beginCount; i < self.fakeDatasource.count; i ++) {
                                    StatusModel* statusModel = [StatusModel mj_objectWithKeyValues:self.fakeDatasource[i]];
                                    LWLayout* layout = [self layoutWithStatusModel:statusModel index:i];
                                    [self.dataSource addObject:layout];
                                }
                                footerFresh = NO;
                            }else{
                                [self.fakeDatasource removeAllObjects];
                                [self.dataSource removeAllObjects];
                                self.fakeDatasource = [[NSMutableArray alloc]initWithArray:ary];
                                for (NSInteger i = 0; i < self.fakeDatasource.count; i ++) {
                                    StatusModel* statusModel = [StatusModel mj_objectWithKeyValues:self.fakeDatasource[i]];
                                    LWLayout* layout = [self layoutWithStatusModel:statusModel index:i];
                                    [self.dataSource addObject:layout];
                                }

                            }
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self refreshComplete];
                            });
                                });
                        }
                    };
                    [send dictDataFromNet:model WithRelativePath:@"Get_DynamicList"];

            }else{
                [Toast makeShowCommen:@"您的网络有问题 " ShowHighlight:@"请重置" HowLong:1.2];
            }
        }];
    
}


#pragma mark - Getter

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            for (int i = 0; i < self.fakeDatasource.count; i ++) {
                StatusModel* statusModel = self.fakeDatasource[i];
                LWLayout* layout = [self layoutWithStatusModel:statusModel index:i];
                [self.dataSource addObject:layout];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        });
    }
    
    return _dataSource;
}

-(NSMutableArray *)fakeDatasource{
    if (_fakeDatasource) {
        return _fakeDatasource;
    }
    _fakeDatasource = [[[GetDynamicListVM alloc]init] getDynamicListFromLocal];
    return _fakeDatasource;
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

- (CommentModel *)postComment {
    if (_postComment) {
        return _postComment;
    }
    _postComment = [[CommentModel alloc] init];
    return _postComment;
}

#pragma mark -- ChatKeyBoardDataSource
- (NSArray<MoreItem *> *)chatKeyBoardMorePanelItems
{
    MoreItem *item1 = [MoreItem moreItemWithPicName:@"sharemore_location" highLightPicName:nil itemName:@"位置"];
    MoreItem *item2 = [MoreItem moreItemWithPicName:@"sharemore_pic" highLightPicName:nil itemName:@"图片"];
    MoreItem *item3 = [MoreItem moreItemWithPicName:@"sharemore_video" highLightPicName:nil itemName:@"拍照"];
    MoreItem *item4 = [MoreItem moreItemWithPicName:@"sharemore_location" highLightPicName:nil itemName:@"位置"];
    MoreItem *item5 = [MoreItem moreItemWithPicName:@"sharemore_pic" highLightPicName:nil itemName:@"图片"];
    MoreItem *item6 = [MoreItem moreItemWithPicName:@"sharemore_video" highLightPicName:nil itemName:@"拍照"];
    MoreItem *item7 = [MoreItem moreItemWithPicName:@"sharemore_location" highLightPicName:nil itemName:@"位置"];
    MoreItem *item8 = [MoreItem moreItemWithPicName:@"sharemore_pic" highLightPicName:nil itemName:@"图片"];
    MoreItem *item9 = [MoreItem moreItemWithPicName:@"sharemore_video" highLightPicName:nil itemName:@"拍照"];
    return @[item1, item2, item3, item4, item5, item6, item7, item8, item9];
}
- (NSArray<ChatToolBarItem *> *)chatKeyBoardToolbarItems
{
    ChatToolBarItem *item1 = [ChatToolBarItem barItemWithKind:kBarItemFace normal:@"face" high:@"face_HL" select:@"keyboard"];
    
    ChatToolBarItem *item2 = [ChatToolBarItem barItemWithKind:kBarItemVoice normal:@"voice" high:@"voice_HL" select:@"keyboard"];
    
    ChatToolBarItem *item3 = [ChatToolBarItem barItemWithKind:kBarItemMore normal:@"more_ios" high:@"more_ios_HL" select:nil];
    
    ChatToolBarItem *item4 = [ChatToolBarItem barItemWithKind:kBarItemSwitchBar normal:@"switchDown" high:nil select:nil];
    
    return @[item1, item2, item3, item4];
}

- (NSArray<FaceThemeModel *> *)chatKeyBoardFacePanelSubjectItems
{
    return [FaceSourceManager loadFaceSource];
}

-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UpdateDynamic" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UpdateDetail" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MessageComing" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MessageComed" object:nil];
}

@end
