//
//  BBCommentDetailVC.m
//  JZBRelease
//
//  Created by cl z on 16/7/26.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "BBCommentDetailVC.h"
#import "ChatKeyBoard.h"
#import "DynamicDetailHeaderView.h"
#import "MoreItem.h"
#import "ChatToolBarItem.h"
#import "FaceSourceManager.h"
#import "FaceThemeModel.h"
#import "SelecterToolsScrolView.h"
#import "SelecterContentScrollView.h"
#import "ChatKeyBoardMacroDefine.h"
#import "CommentDetailLayout.h"
#import "BBCommentDetailCell.h"
#import "SendEvaluateModel.h"
#import "LoginVM.h"
#import "ChildEvaluateModel.h"
#import "TableViewCell.h"
#import "QuestionDetailCommentCell.h"
#import "QuestionsDetailLayout.h"
#import "CainaModel.h"
#import "BBZanModel.h"
#import "RewardAlertView.h"
#import "PasswordView.h"
#import "RewardModel.h"
//#import "OtherPersonCentralVC.h"
#import "PublicOtherPersonVC.h"
#import "GetQuestionsModel.h"
#import "SendEvaluateForQuestionModel.h"
#import "DelQuestionModel.h"


@interface BBCommentDetailVC()<ChatKeyBoardDataSource, ChatKeyBoardDelegate>{
    NSString *ansID;
}

@property(nonatomic, strong) PasswordView *passwordView;
@property(nonatomic, strong) NSMutableArray *commentAry;
@property (nonatomic, strong) ChatKeyBoard *chatKeyBoard;
@property (nonatomic, assign) BOOL isUP,isUpdate;
@property (nonatomic, assign) NSInteger requestCount;

@end

@implementation BBCommentDetailVC{
    BOOL subComment;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    
    
//    [self configNav];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    ansID = self.evaluateModel.eval_id;
    self.title = [self.evaluateModel.user.nickname stringByAppendingString:@"的答案"];
    
    [self createTableView];
    
    self.chatKeyBoard = [ChatKeyBoard keyBoard];
    self.chatKeyBoard.delegate = self;
    self.chatKeyBoard.dataSource = self;
    self.chatKeyBoard.placeHolder = [NSString stringWithFormat:@"回复:%@",self.evaluateModel.user.nickname];
    self.chatKeyBoard.allowVoice = NO;
    self.chatKeyBoard.allowMore = NO;
    self.chatKeyBoard.allowFace = NO;
    [self.view addSubview:self.chatKeyBoard];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];

//    [self setupShareView];
    
//    [self configNav];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    GLLog(@"%@",self.navigationController);
    if ([self.navigationController isKindOfClass:[GLNAVC class]]) {
        if (self.IsFromGLNavPush) {
//            [self configNav];
        }else{
            [self configNav];
        }
    }else {
        [self configNav];
    }
}

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [self.commentAry removeAllObjects];
    self.commentAry = nil;
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

- (void)createTableView{
    NSLog(@"self.view.frame.size.height %f",self.view.frame.size.height);
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 49) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    dispatch_async(dispatch_queue_create("", nil), ^{
        self.commentAry = [self cellWithDataModel:self.evaluateModel];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
    
}


-(void) backAction{
    if (self.isUpdate) {
        if (self.updateData) {
            self.updateData(self.questionModel,NO);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    if (self.chatKeyBoard.isUP) {
        self.isUP = YES;
    }
    ansID = self.evaluateModel.eval_id;
    self.chatKeyBoard.placeHolder = [NSString stringWithFormat:@"回复:%@",self.evaluateModel.user.nickname];
    [self.chatKeyBoard keyboardDown];}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    /** 全部列表页面的空数据占位图片 */
    notDataShowView *view;
    
    if (self.commentAry.count) {
        if ([notDataShowView sharenotDataShowView].superview) {
            [[notDataShowView sharenotDataShowView] removeFromSuperview];
        }
    }else {
        view = [notDataShowView sharenotDataShowView:tableView];
        [tableView addSubview:view];
        
    }
    
    return self.commentAry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (0 == indexPath.row) {
        static NSString *commentIdentifier = @"CommentDetailIdentifier0";
        QuestionDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentIdentifier];
        if (!cell) {
            cell = [[QuestionDetailCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentIdentifier];
        }
        if (self.commentAry.count > indexPath.row) {
            QuestionsDetailLayout *cellLayouts = self.commentAry[indexPath.row];
            cell.cellLayout = cellLayouts;
        }
        if (!cell.infoView.delBtn.hidden) {
            cell.infoView.delBtn.tag = indexPath.row;
            [cell.infoView.delBtn addTarget:self action:@selector(delBtnSender:) forControlEvents:UIControlEventTouchUpInside];
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.indexPath = indexPath;
        
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
        
        
        return cell;
    }
    static NSString *commentIdentifier = @"CommentDetailIdentifier";
    BBCommentDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:commentIdentifier];
    if (!cell) {
        cell = [[BBCommentDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentIdentifier];
    }
    if (self.commentAry.count > indexPath.row) {
        CommentDetailLayout *cellLayouts = self.commentAry[indexPath.row];
        cell.cellLayout = cellLayouts;
    }
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;

    
    return cell;
}

//删除评论
- (void)delBtnSender:(UIButton *)btn{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"删除该评论" message:@"您确定要删除自己的评论吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 2000 + btn.tag;
    [alertView show];
    
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (0 == indexPath.row) {
        if (self.commentAry) {
            QuestionsDetailLayout *cellLayouts = self.commentAry[indexPath.row];
            AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            QuestionEvaluateModel *evaluateModel = [QuestionEvaluateModel mj_objectWithKeyValues:[cellLayouts.questionsModel.evaluate objectAtIndex:cellLayouts.index]];
            if (appDelegate.audioSwitch) {
                
                if (evaluateModel.audio && evaluateModel.audio.length > 0) {
                    return cellLayouts.cellHeight + evaluateModel.inteval * 7.333 + evaluateModel.inteval * 7.333 + evaluateModel.inteval * 1.67 + 48;
                }
            }
            return cellLayouts.cellHeight + evaluateModel.inteval * 7.333 + evaluateModel.inteval * 7.333 + evaluateModel.inteval * 1.67;
        }
    }
    if (self.commentAry) {
        CommentDetailLayout *cellLayouts = self.commentAry[indexPath.row];
        return cellLayouts.cellHeight;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return;
    }
    CommentDetailLayout *cellLayouts = self.commentAry[indexPath.row];
    QuestionEvaluateModel *model = cellLayouts.questionsModel;
    if ([model.eval_uid isEqualToString:[LoginVM getInstance].users.uid]) {
        [Toast makeShowCommen:@"" ShowHighlight:@"不能回复自己" HowLong:1];
        return;
    }else{
        NSString *ansStr = @"回复：";
        self.chatKeyBoard.placeHolder = [ansStr stringByAppendingString:model.eval_u_nickname];
        ansID = model.eval_id;
        [self.chatKeyBoard keyboardUp];
    }
}

-(NSMutableArray *)cellWithDataModel:(QuestionEvaluateModel *) evaluateModel{
    NSMutableArray *ary = [[NSMutableArray alloc]init];
    NSInteger count = 0;
    QuestionsDetailLayout *questionDetailLayout = [self layoutWithDetailListModel:self.questionModel index:self.row - 1 IsDetail:YES];
    [ary addObject:questionDetailLayout];
    count = evaluateModel._child.count;
    for (NSInteger i = count - 1; i >= 0; i --) {
        CommentDetailLayout *layout = [self layoutWithEvaluateModel:evaluateModel index:i];
        if (layout) {
            [ary addObject:layout];
        }
    }
    return ary;
}

- (QuestionsDetailLayout *)layoutWithDetailListModel:(QuestionsModel *)questionsModel index:(NSInteger)index IsDetail:(BOOL)isDetail {
    //生成Storage容器
    LWStorageContainer* container = [[LWStorageContainer alloc] init];
    //生成Layout
    QuestionsDetailLayout* layout = [[QuestionsDetailLayout alloc]initWithContainer:container Model:questionsModel dateFormatter:[self dateFormatter] index:index IsDetail:isDetail];
    return layout;
}

- (CommentDetailLayout *)layoutWithEvaluateModel:(QuestionEvaluateModel *) evaluateModel index:(NSInteger)index {
    //生成Storage容器
    LWStorageContainer* container = [[LWStorageContainer alloc] init];
    //生成Layout
    CommentDetailLayout* layout = [[CommentDetailLayout alloc]initWithContainer:container Model:evaluateModel dateFormatter:[self dateFormatter] index:index IsDetail:NO];
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

- (void)tableViewCell:(TableViewCell *)cell didClickedCommentWithCellLayout:(CellLayout *)layout
          atIndexPath:(NSIndexPath *)indexPath clinkType:(Clink_Type)clink_type{
    if (clink_type == Clink_Type_Six) {
//        OtherPersonCentralVC *vc = [[OtherPersonCentralVC alloc] init];
        PublicOtherPersonVC *vc = [[UIStoryboard storyboardWithName:@"PublicOtherPersonVC" bundle:nil]instantiateInitialViewController];
        if (0 == indexPath.row) {
             vc.user = self.evaluateModel.user;
        }else{
            QuestionEvaluateModel *evaluateModel = ((CommentDetailLayout *)(((BBCommentDetailCell *)cell).cellLayout)).questionsModel;
            
            if (!evaluateModel.user) {
                Users *user = [[Users alloc]init];
                user.uid = evaluateModel.eval_uid;
                vc.user = user;
            }else{
                vc.user = evaluateModel.user;
            }
        }
        vc.fromDynamicDetailVC = YES;
        
        if ([vc.user.uid isEqualToString:[LoginVM getInstance].readLocal._id] || vc.user.uid == nil) {
            return ;
        }
        
        self.navigationController.navigationBar.hidden = YES;
        self.tabBarController.tabBar.hidden = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (clink_type == Clink_Type_Two){
        //点赞
        [self dianZanCell:cell WithLayout:layout AtIndexPath:indexPath];
    }else if (clink_type == Clink_Type_Three){
 //       AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
 //       if (appDelegate.checkpay) {
            [self rewardActionCell:cell WithLayout:layout AtIndexPath:indexPath];
//        }else{
//            [SVProgressHUD showSuccessWithStatus:@"该功能暂未开发，敬请期待"];
//        }
        
    }else if (clink_type == Clink_Type_Four){
        [self caina:cell WithLayout:layout AtIndexPath:indexPath];
    }
}

-(void) caina:(TableViewCell *)cell WithLayout:(CellLayout *) layout AtIndexPath:(NSIndexPath *) indexPath{
    CainaModel *cainaModel = [[CainaModel alloc]init];
    cainaModel.access_token = [[LoginVM getInstance] readLocal].token;
    
    QuestionEvaluateModel *evaluate = self.evaluateModel;
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
    __weak BBCommentDetailVC *wself = self;
    sendAndGet.returnModel = ^(GetValueObject *obj,int state){
        if (!obj) {
            [Toast makeShowCommen:@"您的网络 " ShowHighlight:@"出现故障" HowLong:0.8];
        }else{
            if (1 == state) {
                wself.requestCount = 0;
                wself.isUpdate = YES;
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag / 2000 == 1) {
        if (1 == buttonIndex) {
            //[SVProgressHUD showInfoWithStatus:@"删除中..."];
           
            NSInteger tag = alertView.tag % 2000;
            if (self.commentAry.count > tag ) {
                QuestionsDetailLayout *cellLayout = [self.commentAry objectAtIndex:tag];
                QuestionEvaluateModel *evaluateModel = [QuestionEvaluateModel mj_objectWithKeyValues:[ cellLayout.questionsModel.evaluate objectAtIndex:cellLayout.index]];
                [self delQuestionOrComment:NO WithRelativePath:@"Question_Comment_Del_URL" WithID:evaluateModel.eval_id];
            }
        }
        return;
    }
}

- (void)delQuestionOrComment:(BOOL)isQuestion WithRelativePath:(NSString *)path WithID:(NSString *) _id{
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
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
        __weak BBCommentDetailVC *wself = self;
        sendAndget.returnDict = ^(NSDictionary *dict){
            NSLog(@"%@",dict);
            if ([[dict objectForKey:@"state"] intValue] == 1 ) {
                wself.requestCount = 0;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD showInfoWithStatus:@"删除成功"];
                    [wself.navigationController popViewControllerAnimated:YES];
                    if (self.updateData) {
                        self.updateData(nil,YES);
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



-(void) dianZanCell:(TableViewCell *)cell WithLayout:(CellLayout *) layout AtIndexPath:(NSIndexPath *) indexPath{
    BBZanModel *zanModel = [[BBZanModel alloc]init];
    zanModel.access_token = [[LoginVM getInstance] readLocal].token;
    QuestionEvaluateModel *evaluate = self.evaluateModel;
    zanModel.eval_id = evaluate.eval_id;
    NSLog(@"%@",evaluate.eval_id);
    SendAndGetDataFromNet *sendAndGet = [[SendAndGetDataFromNet alloc]init];
    __weak SendAndGetDataFromNet *wsend = sendAndGet;
    __weak BBCommentDetailVC *wself = self;
    sendAndGet.returnModel = ^(GetValueObject *obj,int state){
        if (!obj) {
            [Toast makeShowCommen:@"您的网络 " ShowHighlight:@"出现故障" HowLong:0.8];
        }else{
            if (1 == state) {
                wself.requestCount = 0;
                wself.isUpdate = YES;
                if ([evaluate.is_like intValue] == 1) {
                    evaluate.like_count = [NSNumber numberWithInteger:[evaluate.like_count integerValue] - 1];
                    evaluate.is_like = [NSNumber numberWithInt:0];
                }else{
                    evaluate.like_count = [NSNumber numberWithInteger:[evaluate.like_count integerValue] + 1];
                    evaluate.is_like = [NSNumber numberWithInt:1];
                }
                [self.questionModel.evaluate replaceObjectAtIndex:indexPath.row withObject:evaluate];
                QuestionsDetailLayout *layout = [self layoutWithDetailListModel:self.questionModel index:cell.indexPath.row IsDetail:YES];
                [self.commentAry replaceObjectAtIndex:indexPath.row withObject:layout];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]]
                                      withRowAnimation:UITableViewRowAnimationAutomatic];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([evaluate.is_like intValue] == 1) {
                        [SVProgressHUD showInfoWithStatus:@"成功点赞"];
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




-(void) rewardActionCell:(TableViewCell *)cell WithLayout:(CellLayout *) layout AtIndexPath:(NSIndexPath *) indexPath{
    RewardAlertView *view = [RewardAlertView defaultPopupView];
    view.parentVC = self;
    Users *users = [[Users alloc]init];
    users.uid = [[LoginVM getInstance] readLocal]._id;
    users = (Users *)[[DataBaseHelperSecond getInstance] getModelFromTabel:users];
    QuestionEvaluateModel *evaluate = self.evaluateModel;
    if ([users.nickname isEqualToString:evaluate.user.nickname]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"打赏失败" message:@"原因：不能对自己打赏" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    [view.balanceLabel setText:users.money];
    
    __block BBCommentDetailVC *wself = self;
    __block QuestionsDetailLayout *wlayout = (QuestionsDetailLayout *)layout;
    view.sendAction = ^(Clink_Type clink_type,NSString *howMuch){
        if (clink_type == Clink_Type_One) {
//            self.passwordView = [[PasswordView alloc]initWithFrame:self.view.frame];
//            self.tabBarController.tabBar.hidden = YES;
//            self.passwordView.vc = self;
//            self.passwordView.returnData = ^(NSString *passwordStr){
//                NSLog(@"%@",passwordStr);
                if ([users.money integerValue] < [howMuch integerValue]) {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"打赏失败" message:@"原因：您的余额不足" delegate:wself cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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
                __weak SendAndGetDataFromNet *wsend = sendAndGet;
                sendAndGet.returnModel = ^(GetValueObject *obj,int state){
                    if (!obj) {
  //                      [alertView setTitle:@"打赏失败"];
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
                            wself.isUpdate = YES;
   //                         [alertView.label setText:@"打赏完成"];
                            [SVProgressHUD showInfoWithStatus:obj.info];
                            users.money = [NSString stringWithFormat:@"%ld",[users.money integerValue] - [howMuch integerValue]];
                            [[DataBaseHelperSecond getInstance] delteModelFromTabel:users];
                            [[DataBaseHelperSecond getInstance] insertModelToTabel:users];
                            [LoginVM getInstance].users = users;
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                                [wself lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
//                                [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                                evaluate.reward_count = [NSNumber numberWithInteger:[evaluate.reward_count integerValue] + 1];
                                evaluate.is_reward = [NSNumber numberWithInt:1];
                                [wself.questionModel.evaluate replaceObjectAtIndex:indexPath.row  withObject:evaluate];
                                wlayout = [wself layoutWithDetailListModel:wself.questionModel index:cell.indexPath.row IsDetail:YES];
                                [wself.commentAry replaceObjectAtIndex:indexPath.row withObject:wlayout];
                                [wself.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                                
                            });
                        }else{
                            if (wself.requestCount > 1) {
 //                               [alertView setTitle:@"打赏失败"];
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


#pragma mark -- begin edit
- (void)chatKeyBoardTextViewDidBeginEditing:(UITextView *)textView{
    
    NSLog(@"pop");
}


-(void)tableViewCell:(UITableViewCell *)cell didClickedLinkWithData:(id)data clinkType:(Clink_Type)clink_type{
    
    if (Clink_Type_One == clink_type) {
//        OtherPersonCentralVC *vc = [[OtherPersonCentralVC alloc] init];
        QuestionEvaluateModel *evaluateModel = ((CommentDetailLayout *)(((BBCommentDetailCell *)cell).cellLayout)).questionsModel;
//        vc.user = evaluateModel.user;
        
        PublicOtherPersonVC *vc = [[UIStoryboard storyboardWithName:@"PublicOtherPersonVC" bundle:nil]instantiateInitialViewController];
        vc.user = evaluateModel.user;
        
        vc.fromDynamicDetailVC = YES;
        
        if ([vc.user.uid isEqualToString:[LoginVM getInstance].readLocal._id] || vc.user.uid == nil) {
            return ;
        }
        
        self.navigationController.navigationBar.hidden = YES;
        self.tabBarController.tabBar.hidden = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (Clink_Type_Two == clink_type){
        
    }else if(Clink_Type_Three == clink_type){
//        OtherPersonCentralVC *vc = [[OtherPersonCentralVC alloc] init];
        CommentDetailLayout *commentLayout = [self.commentAry objectAtIndex:((BBCommentDetailCell *)cell).indexPath.row];
        ChildEvaluateModel *childModel = [ChildEvaluateModel mj_objectWithKeyValues:[commentLayout.questionsModel._child objectAtIndex:((BBCommentDetailCell *)cell).indexPath.row - 1]];
        Users *user = [[Users alloc]init];
        user.uid = childModel.eval_uid;
        user.nickname = childModel.eval_u_nickname;
//        vc.user = user;
        
        PublicOtherPersonVC *vc = [[UIStoryboard storyboardWithName:@"PublicOtherPersonVC" bundle:nil]instantiateInitialViewController];
        vc.user = user;
        
        vc.fromDynamicDetailVC = YES;
        
        if ([vc.user.uid isEqualToString:[LoginVM getInstance].readLocal._id] || vc.user.uid == nil) {
            return ;
        }
        
        self.navigationController.navigationBar.hidden = YES;
        self.tabBarController.tabBar.hidden = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        subComment = YES;
        [self.chatKeyBoard keyboardUp];
        NSLog(@"((TableViewCell *)cell).indexPath.row) %ld",((TableViewCell *)cell).indexPath.row - 1);
        if (!(self.evaluateModel._child.count > ((TableViewCell *)cell).indexPath.row - 1)) {
            return;
        }
        ChildEvaluateModel *child = [ChildEvaluateModel mj_objectWithKeyValues: [self.evaluateModel._child objectAtIndex:((TableViewCell *)cell).indexPath.row - 1]];
        
        self.chatKeyBoard.placeHolder = [NSString stringWithFormat:@"回复:%@",child.eval_u_nickname];
        self.chatKeyBoard.indexPath = ((TableViewCell *)cell).indexPath;
        CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:self.chatKeyBoard.indexPath];
        NSLog(@"%ld",self.chatKeyBoard.indexPath.row);
        CGRect rect = [self.tableView convertRect:rectInTableView toView:self.view];
        
        NSLog(@"%f",self.chatKeyBoard.frame.origin.y);
        NSLog(@"%f",self.chatKeyBoard.frame.size.height);
        NSLog(@"%f",self.view.frame.size.height);
        NSInteger keyOrginY = self.view.frame.size.height - self.chatKeyBoard.frame.size.height;
        CommentDetailLayout *layout = [self.commentAry objectAtIndex:self.chatKeyBoard.indexPath.row];
        if ((rect.origin.y + layout.cellHeight) > keyOrginY) {
            NSInteger moveSet = rect.origin.y + layout.cellHeight - keyOrginY + 49;
            [UIView animateWithDuration:0.3 animations:^{
                [self.tableView setFrame:CGRectMake(0, self.tableView.frame.origin.y - moveSet, self.tableView.frame.size.width, self.tableView.frame.size.height)];
            } completion:^(BOOL finished) {
                //[self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height -self.tableView.bounds.size.height + 60) animated:YES];
            }];
            
            //[self.tableView setContentOffset:CGPointMake(0.0, moveSet) animated:NO];
        }
    }
}

#pragma 文本改变
- (void)chatKeyBoardTextViewDidChange:(UITextView *)textView{
    if (textView.text.length > 255) {
        [Toast makeShowCommen:@"抱歉，您的评论字数已超" ShowHighlight:@"255" HowLong:1.5];
        return;
    }
}

#pragma mark -- 发送文本
- (void)chatKeyBoardSendText:(NSString *)text
{
    if (text.length > 255) {
        [Toast makeShowCommen:@"抱歉，您的评论字数已超" ShowHighlight:@"255" HowLong:1];
        return;
    }
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
    model.question_id = self.evaluateModel.question_id;
    
    model.eval_id = ansID;
    model.content = text;
    SendAndGetDataFromNet *send = [[SendAndGetDataFromNet alloc]init];
    __weak SendAndGetDataFromNet *wsend = send;
    __weak typeof (self) wself = self;
    send.returnDict = ^(NSDictionary *dict){
        if (!dict) {
            [Toast makeShowCommen:@"抱歉，您的网络出现故障，" ShowHighlight:@"评论失败" HowLong:1.5];
        }else{
            if (1 == [[dict objectForKey:@"state"] intValue]) {
                wself.requestCount = 0;
                wself.isUpdate = YES;
                
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [[HttpManager shareManager] netStatus:^(AFNetworkReachabilityStatus status) {
                        if(status == AFNetworkReachabilityStatusReachableViaWWAN || status ==AFNetworkReachabilityStatusReachableViaWiFi){
                            GetQuestionsModel *model = [[GetQuestionsModel alloc]init];
                            model.access_token = [[LoginVM getInstance] readLocal].token;
                            model.id = self.questionModel.question_id;
                            model.my = @"0";
                            SendAndGetDataFromNet *sendAndget = [[SendAndGetDataFromNet alloc]init];
                            __weak SendAndGetDataFromNet *wsend = sendAndget;
                            __weak BBCommentDetailVC *wself = self;
                            sendAndget.returnDict = ^(NSDictionary *dict){
                                NSLog(@"%@",dict);
                                if ([[dict objectForKey:@"state"] intValue] == 1 ) {
                                    wself.requestCount = 0;
                                    ansID = wself.evaluateModel.eval_id;
                                    //NSNumber *row = self.questionModel.row;
                                    wself.questionModel = [QuestionsModel mj_objectWithKeyValues:[dict objectForKey:@"data"]];
                                    wself.evaluateModel = [QuestionEvaluateModel mj_objectWithKeyValues:[wself.questionModel.evaluate objectAtIndex:wself.row - 1]];
                                    [self.commentAry removeAllObjects];
                                    self.commentAry = [self cellWithDataModel:wself.evaluateModel];
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self.tableView reloadData];
                                        [Toast makeShowCommen:@"恭喜您，" ShowHighlight:@"评论成功" HowLong:1.5];
                                    });
                                }else{
                                    if (wself.requestCount > 1) {
                                        ansID = wself.evaluateModel.eval_id;
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
                            ansID = wself.evaluateModel.eval_id;
                            [Toast makeShowCommen:@"您的网络有问题 " ShowHighlight:@"请重置" HowLong:0.8];
                        }
                    }];
                });
                
                
                
            }else{
                if (wself.requestCount > 1) {
                    [Toast makeShowCommen:@"很遗憾，" ShowHighlight:@"评论失败" HowLong:1.5];
                    ansID = wself.evaluateModel.eval_id;
                    return ;
                }
                [LoginVM getInstance].isGetToken = ^(){
                    model.access_token = [[LoginVM getInstance] readLocal].token;
                    wself.requestCount ++;
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




@end
