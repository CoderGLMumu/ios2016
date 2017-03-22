//
//  BBQuestionDetailVC.m
//  JZBRelease
//
//  Created by cl z on 16/7/24.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "BBQuestionDetailVC.h"
#import "Defaults.h"
#import "QuestionsModel.h"
#import "QuestionDetailCell.h"
#import "QuestionsDetailLayout.h"
#import "GetQuestionsModel.h"
#import "ChatKeyBoard.h"
#import "MoreItem.h"
#import "FaceSourceManager.h"
#import "FaceThemeModel.h"
#import "ChatToolBarItem.h"
#import "SendEvaluateForQuestionModel.h"
#import "SendAndGetDataFromNet.h"
#import "TableViewCell.h"
#import "ZanModel.h"
#import "QuestionEvaluateModel.h"
#import "RewardAlertView.h"
#import "PasswordView.h"
#import "CustomAlertView.h"
#import "RewardModel.h"
#import "LewPopupViewAnimationSpring.h"
#import "BBZanModel.h"
#import "BBCommentDetailVC.h"
#import "SameAskModel.h"
//#import "OtherPersonCentralVC.h"
#import "PublicOtherPersonVC.h"

#import "CommentDetailLayout.h"
#import "CainaModel.h"
#import "QuestionDetailCell.h"
#import "QuestionDetailCommentCell.h"
#import "LWImageBrowser.h"
#import "LWImageBrowserModel.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import "RMNearbyPersontVC.h"
#import "CollectQuestionModel.h"
#import "QuestionsLayout.h"
#import "QuestionCell.h"
#import "IntegralDetailVC.h"

#import "GLRecorderTool.h"

#import "recorderPlayView.h"
#import "HSDownloadManager.h"
#import "FFDropDownMenuView.h"
#import "DelQuestionModel.h"

#import "ShareCustom.h"

#import "GLNAVC.h"

@interface BBQuestionDetailVC ()<UITableViewDelegate,UITableViewDataSource,ChatKeyBoardDataSource, ChatKeyBoardDelegate,TableViewCellDelegate,UIAlertViewDelegate,FFDropDownMenuViewDelegate>{
    NSInteger updateRow;
    NSInteger clickPre;
    int preSelector;
    NSInteger state;
    BOOL sameAs;
    NSMutableArray *recordArray;
}

/** 下拉菜单 */
@property (nonatomic, strong) FFDropDownMenuView *dropdownMenu;

@property(nonatomic,strong) NSMutableArray *questionsAry;
@property (nonatomic, strong) ChatKeyBoard *chatKeyBoard;
@property (nonatomic, strong) PasswordView *passwordView;
@property (nonatomic, assign) BOOL isUP;
@property (nonatomic, assign) int requestCount;

/** Recorder */
@property (nonatomic, strong) GLRecorderTool *Recorder;

/**
 *  面板
 */
@property (nonatomic, strong) UIView *panelView;

/**
 *  加载视图
 */
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;

/** timer */
@property (nonatomic, strong) NSTimer *timer;
/** timeNum */
@property (nonatomic, assign) float timeNum;

@end

@implementation BBQuestionDetailVC
@synthesize updateDetailComment;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.requestCount = 0;
    updateRow = -1;
    state = 0;
    if (!self.fromPerSon) {
        [self configNav];
    }
    [self initMoreRightBtn];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.chatKeyBoard = [ChatKeyBoard keyBoardWithNavgationBarTranslucent:YES];
    self.chatKeyBoard.delegate = self;
    self.chatKeyBoard.dataSource = self;
    self.chatKeyBoard.placeHolder = @"我也要回答";
    self.chatKeyBoard.allowMore = NO;
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (appDelegate.audioSwitch) {
        self.chatKeyBoard.allowVoice = YES;
    }else{
        self.chatKeyBoard.allowVoice = NO;
    }
    
    self.chatKeyBoard.allowFace = NO;
    [self.view addSubview:self.chatKeyBoard];
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.title = [self.questionModel.user.nickname stringByAppendingString:@"的问题"];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [self setupShareView];
    
    [self gaolintest];
    
    /** 初始化下拉菜单 */
    if ([self.questionModel.user.uid isEqualToString:[LoginVM getInstance].users.uid]) {
        [self setupDropDownMenu];
    }
    
}

/** 初始化下拉菜单 */
- (void)setupDropDownMenu {
    NSArray *modelsArray = [self getMenuModelsArray];
    
    self.dropdownMenu = [FFDropDownMenuView ff_DefaultStyleDropDownMenuWithMenuModelsArray:modelsArray menuWidth:FFDefaultFloat eachItemHeight:FFDefaultFloat menuRightMargin:FFDefaultFloat triangleRightMargin:FFDefaultFloat];
    
    //如果有需要，可以设置代理（非必须）
    self.dropdownMenu.delegate = self;
    
    self.dropdownMenu.ifShouldScroll = NO;
    
    
    [self.dropdownMenu setup];
}



/** 获取菜单模型数组 */
- (NSArray *)getMenuModelsArray {
  //  __weak typeof(self) weakSelf = self;
    
    //菜单模型0
    FFDropDownMenuModel *menuModel0 = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:@"分享" menuItemIconName:@"WD_FX"  menuBlock:^{
        //    [self showShareActionSheet:self.view];
        [self goShare];
    }];
    
    
    //菜单模型1
    FFDropDownMenuModel *menuModel1 = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:@"删除" menuItemIconName:@"WD_delete" menuBlock:^{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"删除该提问" message:@"您确定删除该提问吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 10;
        [alertView show];
    }];
    
    
    NSArray *menuModelArr = @[menuModel0, menuModel1];
    return menuModelArr;
}



/** 显示下拉菜单 */
- (void)showDropDownMenu {
    [self.dropdownMenu showMenu];
}


//=================================================================
//                      FFDropDownMenuViewDelegate
//=================================================================
#pragma mark - FFDropDownMenuViewDelegate

/** 可以在这个代理方法中稍微小修改cell的样式，比如是否需要下划线之类的 */
/** you can modify menu cell style, Such as if should show underline */
- (void)ffDropDownMenuView:(FFDropDownMenuView *)menuView WillAppearMenuCell:(FFDropDownMenuBasedCell *)menuCell index:(NSInteger)index {
    
    //若果自定义cell的样式，则在这里将  menuCell 转换成你自定义的cell
    FFDropDownMenuCell *cell = (FFDropDownMenuCell *)menuCell;
    
    //如果自定义cell,你可以在这里进行一些小修改，比如是否需要下划线之类的
    //最后一个菜单选项去掉下划线（FFDropDownMenuCell 内部已经做好处理，最后一个是没有下划线的，以下代码只是举个例子）
    if (menuView.menuModelsArray.count - 1 == index) {
        cell.separaterView.hidden = YES;
    }
    
    else {
        cell.separaterView.hidden = NO;
    }
    
}


- (void)setupShareView
{
    //加载等待视图
    self.panelView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.panelView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.panelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.loadingView.frame = CGRectMake((self.view.frame.size.width - self.loadingView.frame.size.width) / 2, (self.view.frame.size.height - self.loadingView.frame.size.height) / 2, self.loadingView.frame.size.width, self.loadingView.frame.size.height);
    self.loadingView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    [self.panelView addSubview:self.loadingView];
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

- (void)initMoreRightBtn{
    //11 20
    UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11 + 5 + 40, 35)];
    UIImageView *shareImageView;
    if ([self.questionModel.user.uid isEqualToString:[LoginVM getInstance].users.uid]) {
        shareImageView = [UIImageView createImageViewWithFrame:CGRectMake(45 - 20, (35-20)/2, 20, 20) ImageName:@"WD_menu"];
    }else{
        shareImageView = [UIImageView createImageViewWithFrame:CGRectMake(45 - 20, (35-20)/2, 20, 20) ImageName:@"WDXQ_share"];
    }
    shareImageView.userInteractionEnabled = YES;
    [shareView addSubview:shareImageView];
    //    UILabel *backLabel = [UILabel createLabelWithFrame:CGRectMake(11 + 5,(35-20)/2, 40, 20) Font:17 Text:@"返回" andLCR:0 andColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]]];
    //    [backView addSubview:backLabel];
    UIControl *share = [[UIControl alloc] initWithFrame:shareView.bounds];
    [share addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:share];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    
    /**
     width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和  边界间距为5pix，所以width设为-5时，间距正好调整为0；width为正数 时，正好相反，相当于往左移动width数值个像素
     */
    negativeSpacer.width = -10;
    
    UIBarButtonItem *rifhtBtnItem = [[UIBarButtonItem alloc] initWithCustomView:shareView];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, rifhtBtnItem, nil];
}


-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    if (self.chatKeyBoard.isUP) {
        self.isUP = YES;
    }
    [self.chatKeyBoard keyboardDown];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden = YES;
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    
    GLLog(@"%@",self.navigationController);
    if ([self.navigationController isKindOfClass:[GLNAVC class]]) {
        
    }else {
//        [self configNav];
        if (!self.fromPerSon) {
            [self configNav];
        }
    }
}

-(void) backAction{
    for (int i = 0; i < recordArray.count; i ++) {
        NSIndexPath *path = [recordArray objectAtIndex:i];
        QuestionDetailCommentCell *cellPre = [self.tableView cellForRowAtIndexPath:path];
        [cellPre.audioPlayView.tool stopPlaylayRecord];
    }
    [recordArray removeAllObjects];
    [self.questionsAry removeAllObjects];
    [self.tableView reloadData];
    if (self.tableView) {
        [self.tableView removeFromSuperview];
        self.tableView = nil;
    }
    self.questionsAry = nil;
    if (self.updateDetailComment) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)shareAction
{
    if ([self.questionModel.user.uid isEqualToString:[LoginVM getInstance].users.uid]) {
        [self showDropDownMenu];
    }else{
        //    [self showShareActionSheet:self.view];
        [self goShare];
    }
}

#pragma mark - Private Method
- (void)goShare {
    
    NSString *shareUrl_str = [[ValuesFromXML getValueWithName:@"ZiXun_Sever_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"/Share/Question/info/id/%@.html",self.questionModel.question_id]];
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[UIImage imageNamed:@"shareImage"]];
    [shareParams SSDKSetupShareParamsByText:self.questionModel.content
                                     images:imageArray
                                        url:[NSURL URLWithString:shareUrl_str]
                                      title:self.questionModel.title//title:@"分享标题-欢迎下载【建众帮】"
                                       type:SSDKContentTypeWebPage];
    
    //1、创建分享参数
    //    NSArray* imageArray = @[[UIImage imageNamed:@"share_icon"]];
    if (imageArray) {
        
        //        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        //        [shareParams SSDKSetupShareParamsByText:@"11111"
        //                                         images:imageArray
        //                                            url:[NSURL URLWithString:@"http://baidu.com"]
        //                                          title:@"2222"
        //                                           type:SSDKContentTypeAuto];
        
        
        //调用自定义分享
        [ShareCustom shareWithContent:shareParams];
    }
    
}

- (void)createTableView{
    NSLog(@"self.view.frame.size.height %f",self.view.frame.size.height);
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 49) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [SVProgressHUD showWithStatus:@"正在加载..."];
    dispatch_async(dispatch_queue_create("", nil), ^{
        //self.questionsAry = [self cellWithModel:self.questionModel];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.tableView) {
                [self.tableView reloadData];
            }
        });
    });
    
    [self createData];
   
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

- (void)tableViewCell:(TableViewCell *)cell didClickedImageWithCellLayout:(CellLayout *)layout atIndex:(NSInteger)index {
    
    NSMutableArray* tmp = [[NSMutableArray alloc] initWithCapacity:layout.imagePostionArray.count];
    for (NSInteger i = 0; i < layout.imagePostionArray.count; i ++) {
        NSString *rect = [layout.imagePostionArray objectAtIndex:i];
        CGRect rect1 = CGRectFromString(rect);
        rect1 = CGRectMake(rect1.origin.x, rect1.origin.y, rect1.size.width, rect1.size.height);
        LWImageBrowserModel *imageModel = [[LWImageBrowserModel alloc]initWithLocalImage:[LocalDataRW getImageWithDirectory:Directory_BQ RetalivePath:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:[self.questionModel.images objectAtIndex:i]]] imageViewSuperView:cell.contentView positionAtSuperView:CGRectFromString(NSStringFromCGRect(rect1)) index:index];
        [tmp addObject:imageModel];
    }
    LWImageBrowser* imageBrowser = [[LWImageBrowser alloc] initWithParentViewController:self
                                                                                  style:LWImageBrowserAnimationStyleScale
                                                                            imageModels:tmp
                                                                           currentIndex:index];
    imageBrowser.view.backgroundColor = [UIColor blackColor];
    [imageBrowser show];
}

-(NSMutableArray *)cellWithModel:(QuestionsModel *) qestionModel{
    NSMutableArray *ary = [[NSMutableArray alloc]init];
    QuestionsLayout *layout = [self layoutWithDetailListModel:qestionModel index:0 IsDetail:YES IsLast:NO];
    [ary addObject:layout];
    for (NSInteger i = 0; i < qestionModel.evaluate.count; i ++) {
        QuestionsDetailLayout *layout = [self layoutWithDetailListModel:qestionModel index:i IsDetail:NO];
        if (layout) {
            [ary addObject:layout];
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

- (QuestionsDetailLayout *)layoutWithDetailListModel:(QuestionsModel *)questionsModel index:(NSInteger)index IsDetail:(BOOL)isDetail {
    //生成Storage容器
    LWStorageContainer* container = [[LWStorageContainer alloc] init];
    //生成Layout
    QuestionsDetailLayout* layout = [[QuestionsDetailLayout alloc]initWithContainer:container Model:questionsModel dateFormatter:[self dateFormatter] index:index IsDetail:isDetail];
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


- (void)downloadData {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[HttpManager shareManager] netStatus:^(AFNetworkReachabilityStatus status) {
            if(status == AFNetworkReachabilityStatusReachableViaWWAN || status ==AFNetworkReachabilityStatusReachableViaWiFi){
                GetQuestionsModel *model = [[GetQuestionsModel alloc]init];
                model.access_token = [[LoginVM getInstance] readLocal].token;
                model.id = self.questionModel.question_id;
                model.my = @"0";
                SendAndGetDataFromNet *sendAndget = [[SendAndGetDataFromNet alloc]init];
                __block SendAndGetDataFromNet *wsend = sendAndget;
                __weak BBQuestionDetailVC *wself = self;
                sendAndget.returnDict = ^(NSDictionary *dict){
                    NSLog(@"%@",dict);
                    if ([[dict objectForKey:@"state"] intValue] == 1 ) {
                        wself.requestCount = 0;
                        NSNumber *row = self.questionModel.row;
                        self.questionModel = [QuestionsModel mj_objectWithKeyValues:[dict objectForKey:@"data"]];
                        self.questionModel.row = row;
                        
                        if ([self.questionModel isKindOfClass:[QuestionsModel class]]) {
                            if (self.questionsAry) {
                                [self.questionsAry removeAllObjects];
                            }
                            self.questionsAry = [self cellWithModel:self.questionModel];
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self refreshComplete];
                            [SVProgressHUD dismiss];
                        });
                    }else{
                        [SVProgressHUD dismiss];
                        if (wself.requestCount > 1) {
                            [Toast makeShowCommen:@"您的网络有问题 " ShowHighlight:@"请重置" HowLong:0.8];
                            
                            return ;
                        }
                        [LoginVM getInstance].isGetToken = ^(){
                            model.access_token = [[LoginVM getInstance] readLocal].token;
                            [wsend commenDataFromNet:model WithRelativePath:@"Get_Question_List"];
                            wself.requestCount ++;
                        };
                        [[LoginVM getInstance] loginWithUserInfoForGetNewToken:[[LoginVM getInstance] readLocal]];
                    }
                };
                [sendAndget dictFromNet:model WithRelativePath:@"Get_Question_List"];
            }else{
                [SVProgressHUD dismiss];
                [Toast makeShowCommen:@"您的网络有问题 " ShowHighlight:@"请重置" HowLong:0.8];
            }
        }];
    });
}

- (void)refreshComplete {
    
    self.title = [self.questionModel.user.nickname stringByAppendingString:@"的问题"];
    
    //[self.tableViewHeader refreshingAnimateStop];
    [UIView animateWithDuration:0.35f animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    } completion:^(BOOL finished) {
        [self.tableView reloadData];
       
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
    if (0 == indexPath.row) {
        static NSString* cellIdentifier = @"QuestionCell";
        QuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[QuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.isDetail = YES;
        if (self.questionsAry.count > indexPath.row) {
            QuestionsLayout* cellLayouts = self.questionsAry[indexPath.row];
            cell.cellLayout = cellLayouts;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString* cellIdentifier = @"QuestionDetailCellIdentifier1";
        QuestionDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[QuestionDetailCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.indexPath = indexPath;
        cell.delegate = self;
        if (self.questionsAry.count > indexPath.row) {
            QuestionsDetailLayout* cellLayouts = self.questionsAry[indexPath.row];
            cell.cellLayout = cellLayouts;
        }
        if (cell.audioPlayView) {
            __block typeof (cell) wcell = cell;

            cell.audioPlayView.tool = [GLRecorderTool getInstance];
            cell.audioPlayView.tool.stopanima = ^(){
                for (int i = 0; i < recordArray.count; i ++) {
                    NSIndexPath *path = [recordArray objectAtIndex:i];
                    QuestionDetailCommentCell *cellPre = [tableView cellForRowAtIndexPath:path];
                    [cellPre.audioPlayView stopAnima];
                }
                [recordArray removeAllObjects];
                
            };
            
            cell.audioPlayView.playBlock = ^(){
                if (!recordArray) {
                    recordArray = [[NSMutableArray alloc]init];
                    [self downAudioAndPlayWithCell:wcell];
                    [recordArray addObject:indexPath];
                }else{
                    if (recordArray.count > 0) {
                        for (int i = 0; i < recordArray.count; i ++) {
                            NSIndexPath *path = [recordArray objectAtIndex:i];
                            QuestionDetailCommentCell *cellPre = [tableView cellForRowAtIndexPath:path];
                            [cellPre.audioPlayView.tool stopPlaylayRecord];
                        }
                        //[recordArray removeAllObjects];
                    }else{
                        [self downAudioAndPlayWithCell:wcell];
                        [recordArray addObject:indexPath];
                    }
                }
            };

        }
        
        if (!cell.infoView.delBtn.hidden) {
            cell.infoView.delBtn.tag = indexPath.row;
            [cell.infoView.delBtn addTarget:self action:@selector(delBtnSender:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

//删除评论
- (void)delBtnSender:(UIButton *)btn{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"删除该评论" message:@"您确定要删除自己的评论吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 2000 + btn.tag;
    [alertView show];

}



- (void)downAudioAndPlayWithCell:(QuestionDetailCommentCell *) cell{
    
    NSString *url = cell.audioPlayView.playLocalStr;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist;
    isExist = [fileManager fileExistsAtPath:HSFileFullpath(url)];
    
    
    // [self.tool stopPlaylayRecord];
    //[self stopAnima];
    // 这里是测试的， 传入 self.playLocalStr  进行播放
    
    if (isExist) {
        
        //            GLLog(@"%@", ZFFileFullpath(@"http://120.77.48.254/Bang/Uploads/Audio/2016-11-1423634/58297292ce62d16448.amr"))
        
        [cell.audioPlayView.tool playRecordWithJZBPath:HSFileFullpath(url)];
        [cell.audioPlayView startAnima];
        return;
    }
    [[HSDownloadManager sharedInstance] download:url progress:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            
        });
    } state:^(DownloadState states) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (states == DownloadStateCompleted) {
                GLLog(@"下载完成下载完成下载完成下载完成下载完成下载完成下载完成下载完成下载完成下载完成下载完成")
                //  播放音频
                
                
                //            GLLog(@"%@", ZFFileFullpath(@"http://120.77.48.254/Bang/Uploads/Audio/2016-11-1423634/58297292ce62d16448.amr"))
                
                [cell.audioPlayView.tool playRecordWithJZBPath:HSFileFullpath(url)];
                [cell.audioPlayView startAnima];
            }
            
        });
    }];

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.questionsAry.count > indexPath.row) {
        if (0 == indexPath.row) {
            QuestionsLayout *layout = self.questionsAry[indexPath.row];
            QuestionsModel *questionModel = layout.questionsModel;
            return layout.cellHeight + questionModel.inteval * 1.67;
        }else{
            QuestionsDetailLayout *layout = self.questionsAry[indexPath.row];
            QuestionsModel *questionModel = layout.questionsModel;
            AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            
            if (appDelegate.audioSwitch) {
                QuestionEvaluateModel *evaluateModel = [QuestionEvaluateModel mj_objectWithKeyValues:[layout.questionsModel.evaluate objectAtIndex:layout.index]];
                if (evaluateModel.audio && evaluateModel.audio.length > 0) {
                    if (questionModel.inteval != 4) {
                        return layout.cellHeight + questionModel.inteval * 7.333 + questionModel.inteval * 7.333 + questionModel.inteval * 1.67 + 48;
                    }else{
                        return layout.cellHeight + questionModel.inteval * 7.333 + questionModel.inteval * 7.333 + questionModel.inteval * 1.67 + 39;
                    }
                }
            }
            return layout.cellHeight + questionModel.inteval * 7.333 + questionModel.inteval * 7.333 + questionModel.inteval * 1.67;
        } 
    }
    return 0;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return;
    }
    if (self.questionsAry.count > indexPath.row) {
        QuestionsDetailLayout *layout = self.questionsAry[indexPath.row];
        BBCommentDetailVC *vc = [[BBCommentDetailVC alloc]init];
        
        vc.IsFromGLNavPush = self.IsFromGLNavPush;
        
        vc.questionModel = self.questionModel;
        vc.row = indexPath.row;
        vc.evaluateModel = [QuestionEvaluateModel mj_objectWithKeyValues:[layout.questionsModel.evaluate objectAtIndex:indexPath.row - 1]];
        __weak BBQuestionDetailVC *wself = self;
        vc.updateData = ^(QuestionsModel *questionModel,BOOL isDelete){
            if (isDelete) {
                [wself downloadData];
                return ;
            }
            wself.questionModel = questionModel;
            if ([self.questionModel isKindOfClass:[QuestionsModel class]]) {
                if (self.questionsAry) {
                    [self.questionsAry removeAllObjects];
                }
                self.questionsAry = [self cellWithModel:self.questionModel];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self refreshComplete];
            });
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)tableViewCell:(TableViewCell *)cell didClickedCommentWithCellLayout:(CellLayout *)layout
          atIndexPath:(NSIndexPath *)indexPath clinkType:(Clink_Type)clink_type{
    if (clink_type == Clink_Type_One) {
        //评论
        if (indexPath.row == 0) {
            return;
        }
        if (self.questionsAry.count > indexPath.row) {
            QuestionsDetailLayout *layout = self.questionsAry[indexPath.row];
            BBCommentDetailVC *vc = [[BBCommentDetailVC alloc]init];
            
            vc.IsFromGLNavPush = self.IsFromGLNavPush;
            
            vc.questionModel = self.questionModel;
            vc.row = indexPath.row;
            vc.evaluateModel = [QuestionEvaluateModel mj_objectWithKeyValues:[layout.questionsModel.evaluate objectAtIndex:indexPath.row - 1]];
            __weak BBQuestionDetailVC *wself = self;
            vc.updateData = ^(QuestionsModel *questionModel,BOOL isDel){
                if (isDel) {
                    [wself downloadData];
                    return ;
                }
                wself.questionModel = questionModel;
                if ([self.questionModel isKindOfClass:[QuestionsModel class]]) {
                    if (self.questionsAry) {
                        [self.questionsAry removeAllObjects];
                    }
                    self.questionsAry = [self cellWithModel:self.questionModel];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self refreshComplete];
                });
            };
            [self.navigationController pushViewController:vc animated:YES];
        }

    }else if (clink_type == Clink_Type_Two){
        //点赞
        [self dianZanCell:cell WithLayout:layout AtIndexPath:indexPath];
    }else if (clink_type == Clink_Type_Three){
        if (indexPath.row == 0) {
            [self sameAsk:cell WithLayout:layout AtIndexPath:indexPath];
        }else{
//            AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//            
//            if (appDelegate.checkpay) {
                [self rewardActionCell:cell WithLayout:layout AtIndexPath:indexPath];
//            }else{
//                [SVProgressHUD showSuccessWithStatus:@"该功能暂未开发，敬请期待"];
//            }
        }
    }else if (clink_type == Clink_Type_Four){
        [self caina:cell WithLayout:layout AtIndexPath:indexPath];
    }else if (clink_type == Clink_Type_Five){
        [self collectedCell:cell WithLayout:layout AtIndexPath:indexPath];
    }else if (clink_type == Clink_Type_Six){
        
//        OtherPersonCentralVC *othervc = [[OtherPersonCentralVC alloc]init];
        
        PublicOtherPersonVC *othervc = [[UIStoryboard storyboardWithName:@"PublicOtherPersonVC" bundle:nil]instantiateInitialViewController];
        
        
        othervc.view.backgroundColor = [UIColor whiteColor];
        QuestionsModel *model = ((QuestionsDetailLayout *)layout).questionsModel;
        Users *user;
        if (cell.indexPath.row == 0) {
            user = model.user;
        }else{
            QuestionEvaluateModel *evaluate = [QuestionEvaluateModel mj_objectWithKeyValues:[model.evaluate objectAtIndex:indexPath.row - 1]];
            user = evaluate.user;
        }
        if (self.fromPerSon) {
            if ([user.uid isEqualToString:self.questionModel.uid]) {
                return;
            }
        }
        othervc.user = user;
        othervc.fromDynamicDetailVC = YES;
        
        if ([othervc.user.uid isEqualToString:[LoginVM getInstance].readLocal._id] || othervc.user.uid == nil) {
            return ;
        }
        
        self.navigationController.navigationBar.hidden = YES;
        self.tabBarController.tabBar.hidden = YES;
        [self.navigationController pushViewController:othervc animated:YES];
    }
}

-(void) collectedCell:(TableViewCell *)cell WithLayout:(CellLayout *) layout AtIndexPath:(NSIndexPath *) indexPath{
    CollectQuestionModel *collectModel = [[CollectQuestionModel alloc]init];
    collectModel.access_token = [[LoginVM getInstance] readLocal].token;
    collectModel.question_id = self.questionModel.question_id;
    SendAndGetDataFromNet *sendAndGet = [[SendAndGetDataFromNet alloc]init];
    __block SendAndGetDataFromNet *wsend = sendAndGet;
    __weak BBQuestionDetailVC *wself = self;
    sendAndGet.returnModel = ^(GetValueObject *obj,int state){
        if (!obj) {
            [Toast makeShowCommen:@"您的网络 " ShowHighlight:@"出现故障" HowLong:0.8];
        }else{
            if (1 == state) {
                wself.requestCount = 0;
                if ([self.questionModel.is_like intValue] == 1) {
                    self.questionModel.is_like = @"0";
                    self.questionModel.like_count = [NSString stringWithFormat:@"%ld",[self.questionModel.like_count integerValue] - 1];
                }else{
                    self.questionModel.is_like = @"1";
                    self.questionModel.like_count = [NSString stringWithFormat:@"%ld",[self.questionModel.like_count integerValue] + 1];
                }
                
                QuestionsLayout *layout = [self layoutWithDetailListModel:self.questionModel index:0 IsDetail:YES IsLast:NO];
                [self.questionsAry replaceObjectAtIndex:indexPath.row withObject:layout];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]]
                                      withRowAnimation:UITableViewRowAnimationAutomatic];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([self.questionModel.is_like intValue] == 1) {
                        
                        [SVProgressHUD showSuccessWithStatus:@"亲，您太喜欢学习了，已经成功关注了该话题，请记得及时关注话题动态，并积极参与讨论喔！"];
                           
                    }else{
                        [SVProgressHUD showInfoWithStatus:@"亲，您取消了话题的关注，要记得思考和体会大家的讨论喔！"];
                    }
                });
            }else{
                if (wself.requestCount > 1) {
                    return ;
                }
                [LoginVM getInstance].isGetToken = ^(){
                    collectModel.access_token = [[LoginVM getInstance] readLocal].token;
                    [wsend commenDataFromNet:collectModel WithRelativePath:@"Collect_Question_URL"];
                    wself.requestCount ++;
                };
                [[LoginVM getInstance] loginWithUserInfoForGetNewToken:[[LoginVM getInstance] readLocal]];
            }
        }
    };
    [sendAndGet commenDataFromNet:collectModel WithRelativePath:@"Collect_Question_URL"];
    
}

-(void) caina:(TableViewCell *)cell WithLayout:(CellLayout *) layout AtIndexPath:(NSIndexPath *) indexPath{
    CainaModel *cainaModel = [[CainaModel alloc]init];
    cainaModel.access_token = [[LoginVM getInstance] readLocal].token;
    
    QuestionEvaluateModel *evaluate = [QuestionEvaluateModel mj_objectWithKeyValues:[self.questionModel.evaluate objectAtIndex:cell.indexPath.row - 1]];
    if ([evaluate.eval_uid isEqualToString:[[LoginVM getInstance] readLocal]._id]) {
        [Toast makeShowCommen:@"很抱歉 " ShowHighlight:@"您不能采纳自己的回答！！！" HowLong:1];
        return;
    }
    if (self.questionModel.reward_eval_id) {
        [Toast makeShowCommen:@"很抱歉 " ShowHighlight:@"您已经采纳别人了！！！" HowLong:1];
        return;
    }
    cainaModel.question_id = evaluate.question_id;
    cainaModel.eval_id = evaluate.eval_id;
    SendAndGetDataFromNet *sendAndGet = [[SendAndGetDataFromNet alloc]init];
    __block SendAndGetDataFromNet *wsend = sendAndGet;
    __weak BBQuestionDetailVC *wself = self;
    sendAndGet.returnModel = ^(GetValueObject *obj,int state){
        if (!obj) {
            [Toast makeShowCommen:@"您的网络 " ShowHighlight:@"出现故障" HowLong:0.8];
        }else{
            if (1 == state) {
                wself.requestCount = 0;
                wself.questionModel.reward_eval_id = evaluate.eval_id;
                [wself.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]]
                                      withRowAnimation:UITableViewRowAnimationAutomatic];
                [wself.tableView exchangeSubviewAtIndex:1 withSubviewAtIndex:indexPath.row];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [Toast makeShowCommen:@"恭喜您找到想要的答案，" ShowHighlight:@"成功采纳！" HowLong:1.5];
                });
            }else{
                if (wself.requestCount > 1) {
                    [Toast makeShowCommen:@"您的悬赏截止时间已过期，" ShowHighlight:@"不能采纳" HowLong:0.8];
                    return ;
                }
                [LoginVM getInstance].isGetToken = ^(){
                    cainaModel.access_token = [[LoginVM getInstance] readLocal].token;
                    [wsend commenDataFromNet:cainaModel WithRelativePath:@"CaiNa_Evaluate_For_Question"];
                    wself.requestCount ++;
                };
                [[LoginVM getInstance] loginWithUserInfoForGetNewToken:[[LoginVM getInstance] readLocal]];
            }
        }
    };
    [sendAndGet commenDataFromNet:cainaModel WithRelativePath:@"CaiNa_Evaluate_For_Question"];
}

-(void) tableViewCell:(UITableViewCell *)cell didClickedLinkWithData:(id)data clinkType:(Clink_Type)clink_type{
    if (clink_type == Clink_Type_One) {
//        OtherPersonCentralVC *othervc = [[OtherPersonCentralVC alloc]init];
        
        PublicOtherPersonVC *othervc = [[UIStoryboard storyboardWithName:@"PublicOtherPersonVC" bundle:nil]instantiateInitialViewController];
        
        othervc.view.backgroundColor = [UIColor whiteColor];
        QuestionDetailCell *acell =(QuestionDetailCell *)cell;
        QuestionsDetailLayout *layout = acell.cellLayout;
        QuestionsModel *model = layout.questionsModel;
        Users *user;
        if (acell.indexPath.row == 0) {
            user = model.user;
        }else{
            QuestionEvaluateModel *evaluate = [QuestionEvaluateModel mj_objectWithKeyValues:[model.evaluate objectAtIndex:acell.indexPath.row - 1]];
            user = evaluate.user;
        }
        othervc.user = user;
        if (self.fromPerSon) {
            if ([user.uid isEqualToString:self.questionModel.uid]) {
                return;
            }
        }
        othervc.fromDynamicDetailVC = YES;
        
        if ([othervc.user.uid isEqualToString:[LoginVM getInstance].readLocal._id] || othervc.user.uid == nil) {
            return ;
        }
        
        self.navigationController.navigationBar.hidden = YES;
        self.tabBarController.tabBar.hidden = YES;
        [self.navigationController pushViewController:othervc animated:YES];
    }else if (clink_type == Clink_Type_Two){
        [self searchMinePosition:nil WithLayout:nil AtIndexPath:nil];
    }else if (clink_type == Clink_Type_Four){
        PublicOtherPersonVC *othervc = [[UIStoryboard storyboardWithName:@"PublicOtherPersonVC" bundle:nil]instantiateInitialViewController];
        
        othervc.view.backgroundColor = [UIColor whiteColor];
        QuestionDetailCell *acell =(QuestionDetailCell *)cell;
        QuestionsDetailLayout *layout = acell.cellLayout;
        QuestionsModel *model = layout.questionsModel;
        Users *user;
        if (acell.indexPath.row == 0) {
            user = model.user;
        }else{
            QuestionEvaluateModel *evaluate = [QuestionEvaluateModel mj_objectWithKeyValues:[model.evaluate objectAtIndex:acell.indexPath.row - 1]];
            user = evaluate.user;
        }
        othervc.user = user;
        if (self.fromPerSon) {
            if ([user.uid isEqualToString:self.questionModel.uid]) {
                return;
            }
        }
        othervc.fromDynamicDetailVC = YES;
        
        if ([othervc.user.uid isEqualToString:[LoginVM getInstance].readLocal._id] || othervc.user.uid == nil) {
            return ;
        }
        
        self.navigationController.navigationBar.hidden = YES;
        self.tabBarController.tabBar.hidden = YES;
        [self.navigationController pushViewController:othervc animated:YES];

    }
}


//进入地图，查看发问者与自己距离
- (void)searchMinePosition:(TableViewCell *) cell WithLayout:(CellLayout *) layout AtIndexPath:(NSIndexPath *) indexPath{
    QuestionsModel *questionModel = self.questionModel;
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
    //[ZJBHelp getInstance].bbRootVC.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:rmNearByPersontVC animated:YES];
}

-(void) dianZanCell:(TableViewCell *)cell WithLayout:(CellLayout *) layout AtIndexPath:(NSIndexPath *) indexPath{
    BBZanModel *zanModel = [[BBZanModel alloc]init];
    zanModel.access_token = [[LoginVM getInstance] readLocal].token;
    QuestionEvaluateModel *evaluate = [QuestionEvaluateModel mj_objectWithKeyValues:[self.questionModel.evaluate objectAtIndex:cell.indexPath.row - 1]];
    zanModel.eval_id = evaluate.eval_id;
    NSLog(@"%@",evaluate.eval_id);
    SendAndGetDataFromNet *sendAndGet = [[SendAndGetDataFromNet alloc]init];
    __weak SendAndGetDataFromNet *wsend = sendAndGet;
    __weak BBQuestionDetailVC *wself = self;
    sendAndGet.returnModel = ^(GetValueObject *obj,int state){
        if (!obj) {
            [Toast makeShowCommen:@"您的网络 " ShowHighlight:@"出现故障" HowLong:0.8];
        }else{
            if (1 == state) {
                wself.requestCount = 0;
                if ([evaluate.is_like intValue] == 1) {
                    evaluate.like_count = [NSNumber numberWithInteger:[evaluate.like_count integerValue] - 1];
                    evaluate.is_like = @"0";
                }else{
                    evaluate.like_count = [NSNumber numberWithInteger:[evaluate.like_count integerValue] + 1];
                    evaluate.is_like = @"1";
                }
                [self.questionModel.evaluate replaceObjectAtIndex:indexPath.row - 1 withObject:evaluate];
                QuestionsDetailLayout *layout = [self layoutWithDetailListModel:self.questionModel index:cell.indexPath.row - 1 IsDetail:YES];
                [self.questionsAry replaceObjectAtIndex:indexPath.row withObject:layout];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]]
                                      withRowAnimation:UITableViewRowAnimationAutomatic];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([evaluate.is_like intValue] == 1) {
                        [SVProgressHUD showSuccessWithStatus:@"分享是一种功德，点赞是一种美德！您的参与棒棒哒！"];
                       // [Toast makeShowCommen:@"您为该条评论," ShowHighlight:@"成功点赞" HowLong:1.5];
                    }else{
                        [SVProgressHUD showInfoWithStatus:@"取消点赞"];
                     //   [Toast makeShowCommen:@"您为该条评论," ShowHighlight:@"取消点赞" HowLong:1.5];
                    }
                });
            }else{
                if (wself.requestCount > 1) {
                    return ;
                }
                [LoginVM getInstance].isGetToken = ^(){
                    zanModel.access_token = [[LoginVM getInstance] readLocal].token;
                    [wsend commenDataFromNet:zanModel WithRelativePath:@"Zan_Evaluate_For_Question"];
                    wself.requestCount ++;
                };
                [[LoginVM getInstance] loginWithUserInfoForGetNewToken:[[LoginVM getInstance] readLocal]];
            }
        }
    };
    [sendAndGet commenDataFromNet:zanModel WithRelativePath:@"Zan_Evaluate_For_Question"];
    
}

-(void)sameAsk:(TableViewCell *) cell WithLayout:(CellLayout *) layout AtIndexPath:(NSIndexPath *) indexPath{
    SameAskModel *sameAskModel = [[SameAskModel alloc]init];
    sameAskModel.access_token = [[LoginVM getInstance] readLocal].token;
    QuestionsDetailLayout *layout1 = (QuestionsDetailLayout *)layout;
    QuestionsModel *questionsModel = layout1.questionsModel;
    sameAskModel.question_id = questionsModel.question_id;
    if ([questionsModel.is_sameAsk intValue] == 1) {
        return;
    }
    SendAndGetDataFromNet *send = [[SendAndGetDataFromNet alloc]init];
    __weak BBQuestionDetailVC *wself = self;
    __weak SendAndGetDataFromNet *wsend = send;
    send.returnModel = ^(GetValueObject *model,int state){
        if (!model) {
            [Toast makeShowCommen:@"您的网络 " ShowHighlight:@"出现故障" HowLong:0.8];
        }else{
            if (1 == state) {
                wself.requestCount = 0;
                questionsModel.is_sameAsk = @"1";
                questionsModel.sameAsk_count = [NSString stringWithFormat:@"%d",[questionsModel.sameAsk_count intValue] + 1];
                QuestionsDetailLayout *newLayout = [self layoutWithDetailListModel:questionsModel index:0 IsDetail:YES];
                [wself.questionsAry replaceObjectAtIndex:indexPath.row withObject:newLayout];
                [wself.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]]
                                       withRowAnimation:UITableViewRowAnimationAutomatic];
                if (self.questionModel.row) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateSameAsk" object:self userInfo:@{@"ROW":self.questionModel.row}];
                }
            }else{
                if (wself.requestCount > 1) {
                    return ;
                }
                [LoginVM getInstance].isGetToken = ^(){
                    sameAskModel.access_token = [[LoginVM getInstance] readLocal].token;
                    [wsend commenDataFromNet:model WithRelativePath:@"Send_SameAsk_For_Question"];
                    wself.requestCount ++;
                };
                [[LoginVM getInstance] loginWithUserInfoForGetNewToken:[[LoginVM getInstance] readLocal]];
            }
        }
    };
    [send commenDataFromNet:sameAskModel WithRelativePath:@"Send_SameAsk_For_Question"];
}



-(void) rewardActionCell:(TableViewCell *)cell WithLayout:(CellLayout *) layout AtIndexPath:(NSIndexPath *) indexPath{
    RewardAlertView *view = [RewardAlertView defaultPopupView];
    view.parentVC = self;
    Users *users = [[Users alloc]init];
    users.uid = [[LoginVM getInstance] readLocal]._id;
    users = (Users *)[[DataBaseHelperSecond getInstance] getModelFromTabel:users];
    QuestionEvaluateModel *evaluate = [QuestionEvaluateModel mj_objectWithKeyValues:[self.questionModel.evaluate objectAtIndex:cell.indexPath.row - 1]];
    if ([users.nickname isEqualToString:evaluate.user.nickname]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"打赏失败" message:@"原因：您不能打赏自己" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    [view.balanceLabel setText:users.money];
    
    
    __block BBQuestionDetailVC *wself = self;
    __block QuestionsDetailLayout *wlayout = (QuestionsDetailLayout *)layout;
    view.sendAction = ^(Clink_Type clink_type,NSString *howMuch){
        if (clink_type == Clink_Type_One) {
//            self.passwordView = [[PasswordView alloc]initWithFrame:self.view.frame];
//            self.tabBarController.tabBar.hidden = YES;
//            self.passwordView.vc = self;
//            self.passwordView.returnData = ^(NSString *passwordStr){
//                NSLog(@"%@",passwordStr);
                if ([users.money integerValue] < [howMuch integerValue]) {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"打赏失败" message:@"原因：您的余额不足，是否充值" delegate:wself cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    [alertView show];

                    return ;
                }
            
//                CustomAlertView *alertView = [CustomAlertView defaultCustomAlertView:@"打赏中..."];
//                [wself lew_presentPopupView:alertView animation:[LewPopupViewAnimationSpring new]];
//                [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
                RewardModel *rewardModel = [[RewardModel alloc]init];
                rewardModel.access_token = [[LoginVM getInstance] readLocal].token;
                rewardModel.eval_id = evaluate.eval_id;
                rewardModel.score = howMuch;
                SendAndGetDataFromNet *sendAndGet = [[SendAndGetDataFromNet alloc]init];
                __block SendAndGetDataFromNet *wsend = sendAndGet;
                sendAndGet.returnModel = ^(GetValueObject *obj,int state){
                    if (!obj) {
//                        [alertView setTitle:@"打赏失败"];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                            [wself lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
//                            [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                                [SVProgressHUD showInfoWithStatus:obj.info];
                            });
                        });
                    }else{
                        if (1 == state) {
                            wself.requestCount = 0;
//                            [alertView.label setText:@"打赏完成"];
                            [SVProgressHUD showInfoWithStatus:obj.info];
                            users.money = [NSString stringWithFormat:@"%ld",[users.money integerValue] - [howMuch integerValue]];
                            [LoginVM getInstance].users = users;
                            [[DataBaseHelperSecond getInstance] delteModelFromTabel:users];
                            [[DataBaseHelperSecond getInstance] insertModelToTabel:users];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                                [wself lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
//                                [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                                evaluate.reward_count = [NSNumber numberWithInteger:[evaluate.reward_count integerValue] + 1];
                                evaluate.is_reward = [NSNumber numberWithInt:1];
                                [wself.questionModel.evaluate replaceObjectAtIndex:indexPath.row - 1 withObject:evaluate];
                                wlayout = [wself layoutWithDetailListModel:wself.questionModel index:cell.indexPath.row - 1 IsDetail:YES];
                                [wself.questionsAry replaceObjectAtIndex:indexPath.row withObject:wlayout];
                                [wself.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                                
                            });
                        }else{
                            if (wself.requestCount > 1) {
//                                [alertView setTitle:@"打赏失败"];
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                                    [wself lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
//                                    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                                        [SVProgressHUD showInfoWithStatus:obj.info];
                                    });
                                });
                                return ;
                            }
                            [LoginVM getInstance].isGetToken = ^(){
                                rewardModel.access_token = [[LoginVM getInstance] readLocal].token;
                                [wsend commenDataFromNet:rewardModel WithRelativePath:@"Reward_Evaluate_For_Question"];
                                wself.requestCount ++;
                            };
                            [[LoginVM getInstance] loginWithUserInfoForGetNewToken:[[LoginVM getInstance] readLocal]];
                        }

                    }
                };
                [sendAndGet commenDataFromNet:rewardModel WithRelativePath:@"Reward_Evaluate_For_Question"];
//            };
//            [self.view addSubview:self.passwordView];
//            [self.passwordView Action];
        }
    };
    [self lew_presentPopupView:view animation:[LewPopupViewAnimationSpring new] dismissed:^{
        NSLog(@"动画结束");
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag / 2000 == 1) {
        if (1 == buttonIndex) {
            //[SVProgressHUD showInfoWithStatus:@"删除中..."];
            NSInteger tag = alertView.tag % 2000;
            if (self.questionsAry.count > tag ) {
                QuestionsDetailLayout *cellLayout = [self.questionsAry objectAtIndex:tag];
                QuestionEvaluateModel *evaluateModel = [QuestionEvaluateModel mj_objectWithKeyValues:[ cellLayout.questionsModel.evaluate objectAtIndex:cellLayout.index]];
                [self delQuestionOrComment:NO WithRelativePath:@"Question_Comment_Del_URL" WithID:evaluateModel.eval_id];
            }
        }
        return;
    }
    if (alertView.tag == 10) {
        if (1 == buttonIndex) {
            //[SVProgressHUD showInfoWithStatus:@"删除中..."];
            [self delQuestionOrComment:YES WithRelativePath:@"Question_Del_URL" WithID:self.questionModel.question_id];
        }
        return;
    }
    if (1 == buttonIndex) {
        [self gotoInteralDetailVC];
    }
}


- (void)delQuestionOrComment:(BOOL)isQuestion WithRelativePath:(NSString *)path WithID:(NSString *) _id{
    [SVProgressHUD showWithStatus:@"正在删除..."];
    dispatch_async(dispatch_queue_create("", nil), ^{
        DelQuestionModel *model = [[DelQuestionModel alloc]init];
        model.access_token = [[LoginVM getInstance] readLocal].token;
        if (isQuestion) {
            model.question_id = _id;
        }else{
            model.eval_id = _id;
        }
        
        SendAndGetDataFromNet *sendAndget = [[SendAndGetDataFromNet alloc]init];
        __block SendAndGetDataFromNet *wsend = sendAndget;
        __weak BBQuestionDetailVC *wself = self;
        sendAndget.returnDict = ^(NSDictionary *dict){
            NSLog(@"%@",dict);
            if ([[dict objectForKey:@"state"] intValue] == 1 ) {
                wself.requestCount = 0;
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (isQuestion) {
                        [wself.navigationController popViewControllerAnimated:YES];
                        if (wself.updateData) {
                            wself.updateData();
                        }
                    }else{
                        [self downloadData];
                    }
                });
            }else{
                if (wself.requestCount > 1) {
                    [SVProgressHUD showInfoWithStatus:@"您的网络有问题,请重置"];
                    return ;
                }
                [LoginVM getInstance].isGetToken = ^(){
                    model.access_token = [[LoginVM getInstance] readLocal].token;
                    [wsend commenDataFromNet:(GetValueObject *)model WithRelativePath:path];
                    wself.requestCount ++;
                };
                [[LoginVM getInstance] loginWithUserInfoForGetNewToken:[[LoginVM getInstance] readLocal]];
            }
        };
        [sendAndget dictFromNet:(GetValueObject *)model WithRelativePath:path];
        
    });
}

- (void) gotoInteralDetailVC{
    IntegralDetailVC *vc = [[UIStoryboard storyboardWithName:@"IntegralDetailVC" bundle:nil] instantiateInitialViewController];
    vc.bangbiCount = [LoginVM getInstance].users.money;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma 文本改变
- (void)chatKeyBoardTextViewDidChange:(UITextView *)textView{
    if (textView.text.length > 255) {
        [Toast makeShowCommen:@"您问题描述字数已超 " ShowHighlight:@"255" HowLong:0.8];
        [textView setText:[textView.text substringToIndex:255]];
    }
}

#pragma mark -- 发送文本
- (void)chatKeyBoardSendText:(NSString *)text
{
    [self.chatKeyBoard keyboardDown];
    [[HttpManager shareManager] netStatus:^(AFNetworkReachabilityStatus status) {
        if(status == AFNetworkReachabilityStatusReachableViaWWAN || status ==AFNetworkReachabilityStatusReachableViaWiFi){
            
        }else{
            [Toast makeShowCommen:@"您的网络有问题 " ShowHighlight:@"请重置" HowLong:1.2];
            return ;
        }
    }];

    if (!(text.length > 0)) {
        return;
    }
    SendEvaluateForQuestionModel *model = [[SendEvaluateForQuestionModel alloc]init];
    model.access_token = [[LoginVM getInstance] readLocal].token;
    model.question_id = self.questionModel.question_id;
    model.eval_id = @"0";
    model.content = text;
    SendAndGetDataFromNet *send = [[SendAndGetDataFromNet alloc]init];
    __block SendAndGetDataFromNet *wsend = send;
    send.returnDict = ^(NSDictionary *dict){
        if (!dict) {
            [Toast makeShowCommen:@"抱歉，您的网络出现故障，" ShowHighlight:@"评论失败" HowLong:1.5];
        }else{
            if (1 == [[dict objectForKey:@"state"] intValue]) {
                [self downloadData];//
                [SVProgressHUD showInfoWithStatus:@"您的高见已经成功发布，感谢您的参与和分享，相信这样精彩的观点一定会让更多的伙伴受益！"];
            }else{
                [LoginVM getInstance].isGetToken = ^(){
                    model.access_token = [[LoginVM getInstance] readLocal].token;
                    [wsend dictFromNet:model WithRelativePath:@"Send_Evaluate_For_Question"];
                };
                [[LoginVM getInstance] loginWithUserInfoForGetNewToken:[[LoginVM getInstance] readLocal]];
            }
        }
    };
    [send dictFromNet:model WithRelativePath:@"Send_Evaluate_For_Question"];
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

/**
 *  显示分享菜单
 *
 *  @param view 容器视图
 */
- (void)showShareActionSheet:(UIView *)view
{
    /**
     * 在简单分享中，只要设置共有分享参数即可分享到任意的社交平台
     **/
    __weak BBQuestionDetailVC *theController = self;
    
    NSString *shareUrl_str = [[ValuesFromXML getValueWithName:@"ZiXun_Sever_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"/Share/Question/info/id/%@.html",self.questionModel.question_id]];
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[UIImage imageNamed:@"shareImage"]];
    [shareParams SSDKSetupShareParamsByText:self.questionModel.content
                                     images:imageArray
                                        url:[NSURL URLWithString:shareUrl_str]
                                      title:self.questionModel.title//title:@"分享标题-欢迎下载【建众帮】"
                                       type:SSDKContentTypeWebPage];
    
    //1.2、自定义分享平台（非必要）
    NSMutableArray *activePlatforms = [NSMutableArray arrayWithArray:[ShareSDK activePlatforms]];
    //添加一个自定义的平台（非必要）
    SSUIShareActionSheetCustomItem *item = [SSUIShareActionSheetCustomItem itemWithIcon:[UIImage imageNamed:@"Icon.png"]
                                                                                  label:@"自定义"
                                                                                onClick:^{
                                                                                    
                                                                                    //自定义item被点击的处理逻辑
                                                                                    NSLog(@"=== 自定义item被点击 ===");
                                                                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"自定义item被点击"
                                                                                                                                        message:nil
                                                                                                                                       delegate:nil
                                                                                                                              cancelButtonTitle:@"确定"
                                                                                                                              otherButtonTitles:nil];
                                                                                    [alertView show];
                                                                                }];
    [activePlatforms addObject:item];
    
    //设置分享菜单栏样式（非必要）
//            [SSUIShareActionSheetStyle setActionSheetBackgroundColor:[UIColor colorWithRed:249/255.0 green:0/255.0 blue:12/255.0 alpha:0.5]];
//            [SSUIShareActionSheetStyle setActionSheetColor:[UIColor colorWithRed:21.0/255.0 green:21.0/255.0 blue:21.0/255.0 alpha:1.0]];
//            [SSUIShareActionSheetStyle setCancelButtonBackgroundColor:[UIColor colorWithRed:21.0/255.0 green:21.0/255.0 blue:21.0/255.0 alpha:1.0]];
//            [SSUIShareActionSheetStyle setCancelButtonLabelColor:[UIColor whiteColor]];
//            [SSUIShareActionSheetStyle setItemNameColor:[UIColor whiteColor]];
//            [SSUIShareActionSheetStyle setItemNameFont:[UIFont systemFontOfSize:10]];
//            [SSUIShareActionSheetStyle setCurrentPageIndicatorTintColor:[UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1.0]];
//            [SSUIShareActionSheetStyle setPageIndicatorTintColor:[UIColor colorWithRed:62/255.0 green:62/255.0 blue:62/255.0 alpha:1.0]];
    
    //2、分享
    [ShareSDK showShareActionSheet:view
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                           
                       case SSDKResponseStateBegin:
                       {
                           [theController showLoadingView:YES];
                           break;
                       }
                       case SSDKResponseStateSuccess:
                       {
                           //Facebook Messenger、WhatsApp等平台捕获不到分享成功或失败的状态，最合适的方式就是对这些平台区别对待
                           if (platformType == SSDKPlatformTypeFacebookMessenger)
                           {
                               break;
                           }
                           
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           if (platformType == SSDKPlatformTypeSMS && [error code] == 201)
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:@"失败原因可能是：1、短信应用没有设置帐号；2、设备不支持短信应用；3、短信应用在iOS 7以上才能发送带附件的短信。"
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           else if(platformType == SSDKPlatformTypeMail && [error code] == 201)
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:@"失败原因可能是：1、邮件应用没有设置帐号；2、设备不支持邮件应用；"
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           else
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           break;
                       }
                       case SSDKResponseStateCancel:
                       {
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
//                           [alertView show];
                           break;
                       }
                       default:
                           break;
                   }
                   
                   if (state != SSDKResponseStateBegin)
                   {
                       [theController showLoadingView:NO];
                       [theController.tableView reloadData];
                   }
                   
               }];
    
    //另附：设置跳过分享编辑页面，直接分享的平台。
    //        SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:view
    //                                                                         items:nil
    //                                                                   shareParams:shareParams
    //                                                           onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
    //                                                           }];
    //
    //        //删除和添加平台示例
    //        [sheet.directSharePlatforms removeObject:@(SSDKPlatformTypeWechat)];
    //        [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSinaWeibo)];
    
}

/**
 *  显示加载动画
 *
 *  @param flag YES 显示，NO 不显示
 */
- (void)showLoadingView:(BOOL)flag
{
    if (flag)
    {
        [self.view addSubview:self.panelView];
        [self.loadingView startAnimating];
    }
    else
    {
        [self.panelView removeFromSuperview];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    for (int i = 0; i < recordArray.count; i ++) {
        NSIndexPath *path = [recordArray objectAtIndex:i];
        QuestionDetailCommentCell *cellPre = [self.tableView cellForRowAtIndexPath:path];
        [cellPre.audioPlayView.tool stopPlaylayRecord];
    }
    [recordArray removeAllObjects];

}

- (void)dealloc{
    [self.questionsAry removeAllObjects];
}

- (void)AddTime:(NSTimer *)timer
{
    self.timeNum++;
    
    if (self.timeNum >= 298) {
        
        [SVProgressHUD showInfoWithStatus:@"发布评论语音最多5分钟"];
        [self chatKeyBoardDidFinishRecoding:self.chatKeyBoard];
        [self invalidateTimer];
    }
    
}

- (void)setUpTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(AddTime:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
    self.timeNum = 0;
}

- (void)invalidateTimer
{
    [self.timer invalidate];
    GLLog(@"定时器销毁时间%f",self.timeNum)
    self.timer = nil;
}

- (void)gaolintest
{
//    recorderPlayView *view = [[recorderPlayView alloc]initWithFrameAndContent:CGRectMake(10, 250, 260, 40) Content:@"1232131"];
//    [self.view addSubview:view];
//    view.frame = CGRectMake(150, 150, 60, 40);
//    view.backgroundColor = [UIColor redColor];
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
//    [self.view addSubview:btn];
//    btn.frame = CGRectMake(150, 150, 150, 150);
//    btn.backgroundColor = [UIColor blueColor];
//    
//    [btn addTarget:self action:@selector(gaolinttt) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)gaolinttt
{
//    [self.Recorder playRecordWithJZBPath:ZFFileFullpath(@"http://120.77.48.254/Bang/Uploads/Audio/2016-11-1423634/58297292ce62d16448.amr")];
//    
//    [self.Recorder playRecordWithJZBPath:ZFFileFullpath(@"http://120.77.48.254/Bang/Uploads/Audio/2016-11-1423634/58297292ce62d16448.amr")];
}


/** 以下是 高林增加的 输入语音 的回调 */
- (void)chatKeyBoardDidStartRecording:(ChatKeyBoard *)chatKeyBoard
{
    GLLog(@"GL语音开始 GL语音开始 GL语音开始 GL语音开始")
    
    [self setUpTimer];
    // 显示图层
//    [SVProgressHUD show];
    
    self.Recorder = [[GLRecorderTool alloc] init];
    [self.Recorder showVC];
    self.Recorder.showVC = self;
    [self.Recorder startRecord];
}
- (void)chatKeyBoardDidCancelRecording:(ChatKeyBoard *)chatKeyBoard
{
    GLLog(@"GL语音取消 GL语音取消 GL语音取消 GL语音取消")
    
    // 隐藏图层 不发送语音
//    [SVProgressHUD dismiss];
    [self.Recorder cancelRecord];
    [self.Recorder hiddenVoiceView];
    
    [self invalidateTimer];
    
}
- (void)chatKeyBoardDidFinishRecoding:(ChatKeyBoard *)chatKeyBoard
{
    GLLog(@"GL语音完成 GL语音完成 GL语音完成 GL语音完成")
    
    // 隐藏图层 发送语音
//    [SVProgressHUD dismiss];
    
    [self.Recorder stopRecord];
    [self.Recorder uploadRecordWithquestion_id:self.questionModel.question_id Audio_length:@"" eval_id:@"0"];
    __weak typeof (self) wself = self;
    self.Recorder.updateUI = ^(){
        [wself downloadData];
    };
    [self invalidateTimer];
    
}
- (void)chatKeyBoardWillCancelRecoding:(ChatKeyBoard *)chatKeyBoard
{
    GLLog(@"GL语音要取消 GL语音要取消 GL语音要取消 GL语音要取消")
    
    [self.Recorder changeBotLabelText:BotLabel1];
    
    // 显示提示要取消了
//    [SVProgressHUD showProgress:1 status:@"要取消了"];
    
}
- (void)chatKeyBoardContineRecording:(ChatKeyBoard *)chatKeyBoard
{
    GLLog(@"GL语音继续 GL语音继续 GL语音继续 GL语音继续")
    
    // 显示提示 继续 录制
//    [SVProgressHUD showProgress:1 status:@"继续录制"];
    [self.Recorder changeBotLabelText:BotLabel0];
    
}

@end
