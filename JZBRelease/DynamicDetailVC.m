//
//  DynamicDetailVC.m
//  JZBRelease
//
//  Created by zjapple on 16/5/9.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "DynamicDetailVC.h"
#import "ChatKeyBoard.h"
#import "DynamicDetailHeaderView.h"
#import "MoreItem.h"
#import "ChatToolBarItem.h"
#import "FaceSourceManager.h"
#import "FaceThemeModel.h"
#import "SelecterToolsScrolView.h"
#import "SelecterContentScrollView.h"
#import "ChatKeyBoardMacroDefine.h"
#import "DetailListModel.h"
#import "DynamicLayout.h"
#import "DynamicCell.h"
#import "LWImageBrowserModel.h"
#import "LWImageBrowser.h"
#import "Defaults.h"
#import "TableViewCell.h"
#import "GetDynamicDetailVM.h"
#import "ChildEvaluateModel.h"
#import "SendEvaluateModel.h"
#import "Defaults.h"
#import "ChildEvaluateModel.h"
//#import "OtherPersonCentralVC.h"
#import "PublicOtherPersonVC.h"

#import "RewardModel.h"
#import "RewardAlertView.h"
#import "PasswordView.h"
#import "CustomAlertView.h"
#import "LewPopupViewAnimationSpring.h"
#import "ZanModel.h"
#import "ZanCommentModel.h"
@interface DynamicDetailVC()<ChatKeyBoardDataSource, ChatKeyBoardDelegate>{
    CellLayout *cellLayout;
    int preSelector;
    BOOL subComment,Update;
    CGSize keyboardSize;
    
    NSInteger updateRow;
    DetailCommentVC *detailVC;
}


/** chatkeyBoard */
@property (nonatomic, strong) ChatKeyBoard *chatKeyBoard;
@property (nonatomic, strong) DynamicDetailHeaderView *dydHeaderView;

@property(nonatomic, retain) NSArray *titleArr;
@property(nonatomic, retain) SelecterToolsScrolView *selectTools;
@property(nonatomic, strong) NSMutableArray *goodAry,*rewardAry,*shareAry,*commentAry,*dataAry;
@property (nonatomic, strong) PasswordView *passwordView;
@end

@implementation DynamicDetailVC
@synthesize updateDetailComment;
-(instancetype)init{
    self = [super init];
    if (self) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        self = [story instantiateViewControllerWithIdentifier:@"DynamicDetailVC"];
    }
    return self;
}



-(void)viewDidLoad{
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.decelerationRate = 1.0f;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.commentAry = [self cellWithDataAry:self.statusModel.evaluate];
    [self downDetailData];
    [self configNav];
    
    if (!self.indexPath) {
        self.chatKeyBoard = [ChatKeyBoard keyBoard];
        self.chatKeyBoard.delegate = self;
        self.chatKeyBoard.dataSource = self;
        self.chatKeyBoard.placeHolder = [NSString stringWithFormat:@"回复:%@",self.statusModel.user.nickname];
        self.chatKeyBoard.allowVoice = NO;
        self.chatKeyBoard.allowMore = NO;
        self.chatKeyBoard.allowFace = NO;
        [self.view addSubview:self.chatKeyBoard];
    }
    
    _titleArr = @[[NSString stringWithFormat:@"评论 %@",self.statusModel.evaluation_count],[NSString stringWithFormat:@"打赏 %@",self.statusModel.reward_count],];
    preSelector = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name :UIKeyboardWillShowNotification object:nil];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(UITableView *)tableView{
    if (_tableView) {
        return _tableView;
    }
    _tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    return _tableView;
}

-(DynamicDetailHeaderView *)dydHeaderView{
    if (_dydHeaderView) {
        return _dydHeaderView;
    }
    _dydHeaderView = [[DynamicDetailHeaderView alloc]init];
    _dydHeaderView.delegate = self;
    if (self.statusModel) {
        cellLayout = [self layoutWithStatusModel:self.statusModel index:0 isDynamicDe:YES];
        _dydHeaderView.cellLayout = cellLayout;
    }
    return _dydHeaderView;
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    subComment = NO;
    [self.chatKeyBoard keyboardDown];
    self.chatKeyBoard.placeHolder = [NSString stringWithFormat:@"回复:%@",self.statusModel.user.nickname];
    [UIView animateWithDuration:0.3 animations:^{
        [self.tableView setFrame:[UIScreen mainScreen].bounds];
    } completion:^(BOOL finished) {
            
    }];
}

-(void) downDetailData{
    dispatch_async(dispatch_queue_create("", nil), ^{
        GetDynamicDetailVM *dd = [[GetDynamicDetailVM alloc]init];
        [dd getDynamicDetailFromNet:self.statusModel];
        dd.returnStatusModel = ^(StatusModel *model){
            self.statusModel = model;
            if (!model) {
                return;
            }
//            if (!detailVC) {
//                return;
//            }
            if (updateDetailComment) {
                if (self.statusModel.evaluate.count <= updateRow) {
                    return;
                }
                detailVC.evaluateModel = [[detailVC.evaluateModel class] mj_objectWithKeyValues:[self.statusModel.evaluate objectAtIndex:updateRow]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateDetail" object:self userInfo:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DetailCommentVC" object:self userInfo:nil];
                _titleArr = @[[NSString stringWithFormat:@"评论 %@",self.statusModel.evaluation_count],[NSString stringWithFormat:@"打赏 %@",self.statusModel.reward_count],];
                self.chatKeyBoard.placeHolder = [NSString stringWithFormat:@"回复:%@",self.statusModel.user.nickname];
                self.dydHeaderView = nil;
                self.selectTools = nil;
            }
            cellLayout = nil;
            self.dydHeaderView = nil;
            cellLayout = [self layoutWithStatusModel:self.statusModel index:0 isDynamicDe:YES];
            self.dydHeaderView.cellLayout = cellLayout;
            [self.commentAry removeAllObjects];
            self.commentAry = [self cellWithDataAry:model.evaluate];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView  reloadData];
                [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(answerUpKeyboard) userInfo:nil repeats:NO];
             });
        };
    });
}

-(void) viewDidAppear:(BOOL)animated{
   
}

- (void) keyboardWasShown:(NSNotification *) notif
{
    if (keyboardSize.height > 0) {
        return;
    }
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    keyboardSize = [value CGRectValue].size;
    
    NSLog(@"keyBoard:%f", keyboardSize.height);  //216
}

-(void) keyboardUps{
    if (subComment) {
        
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            [self.tableView setFrame:CGRectMake(0, - self.chatKeyBoard.frame.size.height, self.tableView.frame.size.width, self.tableView.frame.size.height)];
        } completion:^(BOOL finished) {
            if (self.statusModel.evaluate.count > 0) {
                [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height -self.tableView.bounds.size.height + 60) animated:YES];
            }
        }];
    }
    if (self.indexPath) {
        return;
    }
    
}

-(void) answerUpKeyboard{
    self.chatKeyBoard.hidden = NO;
    if (self.indexPath) {
        if (!self.chatKeyBoard) {
            self.chatKeyBoard = [ChatKeyBoard keyBoard];
            self.chatKeyBoard.delegate = self;
            self.chatKeyBoard.dataSource = self;
            self.chatKeyBoard.placeHolder = [NSString stringWithFormat:@"回复:%@",self.statusModel.user.nickname];
            self.chatKeyBoard.allowVoice = NO;
            self.chatKeyBoard.allowMore = NO;
            [self.view addSubview:self.chatKeyBoard];
        }
        [self.chatKeyBoard keyboardUp];
        if (self.statusModel.evaluate.count > self.which) {
            EvaluateModel *evaluate = [EvaluateModel mj_objectWithKeyValues:[self.statusModel.evaluate objectAtIndex:self.which]];
            self.chatKeyBoard.placeHolder = [NSString stringWithFormat:@"回复:%@",evaluate.eval_u_nickname];
        }
        NSIndexPath *subIndexPath = [NSIndexPath indexPathForRow:self.indexPath.row inSection:1];
        CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:subIndexPath];
        DynamicCell *cell = [self.tableView cellForRowAtIndexPath:subIndexPath];
        NSLog(@"%ld,%ld",self.indexPath.row,self.indexPath.section);
        CGRect rect = [self.tableView convertRect:rectInTableView toView:[self.tableView superview]];
        NSLog(@"%f",self.chatKeyBoard.frame.size.height);
        if ((rect.origin.y + cell.cellLayout.cellHeight) > self.chatKeyBoard.frame.origin.y) {
            float moveSet = rectInTableView.origin.y + cell.cellLayout.cellHeight - (float)self.chatKeyBoard.frame.origin.y;
            [self.tableView setContentOffset:CGPointMake(0.0, moveSet) animated:NO];
        }

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

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
}


-(SelecterToolsScrolView *)selectTools
{
    if (_selectTools) {
        return _selectTools;
    }
    __weak typeof(self) weakSelf = self;
    
    _selectTools = [[SelecterToolsScrolView alloc]initWithSeleterConditionTitleArr:_titleArr andBtnBlock:^(UIButton * btn,BOOL hit) {
        //[weakSelf updateVCViewFrom:btn.tag];
        [weakSelf updateSelectToolsIndex:btn.tag];
    } WithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    return _selectTools;
}

-(void)updateSelectToolsIndex:(NSInteger)index
{
    [_selectTools updateSelecterToolsIndex:index];
    if (3 == index) {
        
        [UIView animateWithDuration:0.3 animations:^{
            self.chatKeyBoard.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - kChatToolBarHeight, kScreenWidth, kChatKeyBoardHeight);
        } completion:^(BOOL finished) {
            
        }];
    }else if (preSelector == 3){
        [UIView animateWithDuration:0.3 animations:^{
            self.chatKeyBoard.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, kScreenWidth, kChatKeyBoardHeight);
        } completion:^(BOOL finished) {
            
        }];
    }
    preSelector = (int)index;
    switch (index) {
        case 0:
            self.dataAry = self.commentAry;
            [self.tableView reloadData];
            break;
        case 1:
            self.dataAry = self.rewardAry;
            [self.tableView reloadData];
            break;
        case 2:
            self.dataAry = self.goodAry;
            [self.tableView reloadData];
            break;
        case 3:
            
            break;
            
        default:
            break;
    }
}

- (void)tableViewCell:(TableViewCell *)cell didClickedCommentWithCellLayout:(CellLayout *)layout
          atIndexPath:(NSIndexPath *)indexPath clinkType:(Clink_Type)clink_type{
    if (clink_type == Clink_Type_One) {
        if ([cell isKindOfClass:[DynamicDetailHeaderView class]]) {
            [self.chatKeyBoard keyboardUp];
        }else{
            subComment = YES;
            [self.chatKeyBoard keyboardUp];
            self.chatKeyBoard.placeHolder = [NSString stringWithFormat:@"回复:%@",((DynamicLayout *)layout).evaluateModel.user.nickname];
            self.chatKeyBoard.indexPath = cell.indexPath;
            CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:indexPath];
            NSLog(@"%ld",indexPath.row);
            CGRect rect = [self.tableView convertRect:rectInTableView toView:self.view];
            
            NSLog(@"%f",self.chatKeyBoard.frame.origin.y);
             NSLog(@"%f",self.chatKeyBoard.frame.size.height);
            NSLog(@"%f",self.view.frame.size.height);
            NSInteger keyOrginY = self.view.frame.size.height - self.chatKeyBoard.frame.size.height;
            if ((rect.origin.y + layout.cellHeight) > keyOrginY) {
                NSInteger moveSet = rect.origin.y + layout.cellHeight - keyOrginY + 49;
                [UIView animateWithDuration:0.3 animations:^{
                    [self.tableView setFrame:CGRectMake(0, self.tableView.frame.origin.y - moveSet, self.tableView.frame.size.width, self.tableView.frame.size.height)];
                } completion:^(BOOL finished) {
                    //[self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height -self.tableView.bounds.size.height + 60) animated:YES];
                        //subComment = NO;
                }];
                    
                    //[self.tableView setContentOffset:CGPointMake(0.0, moveSet) animated:NO];
            }
        }
    }else if (clink_type == Clink_Type_Two){
        [self dianZanCell:cell WithLayout:layout AtIndexPath:indexPath];
    }else if (clink_type == Clink_Type_Three){
        [self rewardAction:cell didClickedCommentWithCellLayout:layout atIndexPath:indexPath];
    }else if (clink_type == Clink_Type_Six){
        EvaluateModel *evaluateModel = ((DynamicLayout *)(cell.cellLayout)).evaluateModel;
//        OtherPersonCentralVC* vc = [[OtherPersonCentralVC alloc] init];
        PublicOtherPersonVC *vc = [[UIStoryboard storyboardWithName:@"PublicOtherPersonVC" bundle:nil]instantiateInitialViewController];
        
        vc.view.backgroundColor = [UIColor whiteColor];
        vc.user = evaluateModel.user;
        vc.fromDynamicDetailVC = YES;
        
        if ([vc.user.uid isEqualToString:[LoginVM getInstance].readLocal._id] || vc.user.uid == nil) {
            return ;
        }
        
        self.navigationController.navigationBar.hidden = YES;
        self.tabBarController.tabBar.hidden = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (clink_type == Clink_Type_Seven){
        StatusModel *statusModel = cell.cellLayout.statusModel;
//        OtherPersonCentralVC* vc = [[OtherPersonCentralVC alloc] init];
        PublicOtherPersonVC *vc = [[UIStoryboard storyboardWithName:@"PublicOtherPersonVC" bundle:nil]instantiateInitialViewController];
        
        vc.fromDynamicDetailVC = YES;
        vc.view.backgroundColor = [UIColor whiteColor];
        vc.user = statusModel.user;
        
        if ([vc.user.uid isEqualToString:[LoginVM getInstance].readLocal._id] || vc.user.uid == nil) {
            return ;
        }
        
        self.navigationController.navigationBar.hidden = YES;
        self.tabBarController.tabBar.hidden = YES;
        [self.navigationController pushViewController:vc animated:YES];

    }
}

-(void) dianZanCell:(TableViewCell *)cell WithLayout:(CellLayout *) layout AtIndexPath:(NSIndexPath *) indexPath{
    if ([layout isKindOfClass:[CellLayout class]] && ![cell isKindOfClass:[DynamicCell class]]) {
        ZanModel *zanModel = [[ZanModel alloc]init];
        zanModel.access_token = [[LoginVM getInstance] readLocal].token;
        zanModel.dynamic_id = layout.statusModel.id;
        SendAndGetDataFromNet *sendAndGet = [[SendAndGetDataFromNet alloc]init];
        __block CellLayout *wlayout = layout;
        __block DynamicDetailVC *wself = self;
        sendAndGet.returnModel = ^(GetValueObject *obj,int state){
            if (1 == state) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                    
                    if ([wlayout.statusModel.iszan intValue] == 1) {
                        wlayout.statusModel.zan_count = [NSNumber numberWithInteger:[wlayout.statusModel.zan_count integerValue] - 1];
                        wlayout.statusModel.iszan = [NSNumber numberWithInt:0];
                    }else{
                        wlayout.statusModel.zan_count = [NSNumber numberWithInteger:[wlayout.statusModel.zan_count integerValue] + 1];
                        wlayout.statusModel.iszan = [NSNumber numberWithInt:1];
                    }
                    wlayout = [self layoutWithStatusModel:self.statusModel index:0 isDynamicDe:YES];
                    wself.dydHeaderView.cellLayout = wlayout;
                    [wself.tableView reloadData];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if ([wlayout.statusModel.iszan intValue] == 1) {
                            [Toast makeShowCommen:@"您为该条动态," ShowHighlight:@"成功点赞" HowLong:1.5];
                        }else{
                            [Toast makeShowCommen:@"您为该条动态," ShowHighlight:@"取消点赞" HowLong:1.5];
                        }
                    });
                });
            }else{
                
            }
        };
        [sendAndGet commenDataFromNet:zanModel WithRelativePath:@"Zan_Dynamic"];
    }else{
        DynamicLayout *wlayout = (DynamicLayout *)layout;
        ZanCommentModel *zanModel = [[ZanCommentModel alloc]init];
        zanModel.access_token = [[LoginVM getInstance] readLocal].token;
        zanModel.eval_id = wlayout.evaluateModel.eval_id;
        SendAndGetDataFromNet *sendAndGet = [[SendAndGetDataFromNet alloc]init];
        
        __block typeof (wlayout) wwlayout = wlayout;
        
        sendAndGet.returnModel = ^(GetValueObject *obj,int state){
            if (1 == state) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                    
                    if ([wwlayout.evaluateModel.is_like intValue] == 1) {
                        wwlayout.evaluateModel.like_count = [NSNumber numberWithInteger:[wwlayout.evaluateModel.like_count integerValue] - 1];
                        wwlayout.evaluateModel.is_like = @"0";
                    }else{
                        wwlayout.evaluateModel.like_count = [NSNumber numberWithInteger:[wwlayout.evaluateModel.like_count integerValue] + 1];
                        wwlayout.evaluateModel.is_like = @"1";
                    }
                    wwlayout = [self layoutWithDetailListModel:wwlayout.evaluateModel index:indexPath.row];
                    [self.commentAry replaceObjectAtIndex:indexPath.row withObject:wwlayout];
                    DynamicCell *wcell = (DynamicCell *)cell;
                    [wcell.tabItemBarView.zanCountLabel setText:[NSString stringWithFormat:@"%@",wwlayout.evaluateModel.like_count]];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if ([wwlayout.evaluateModel.is_like intValue] == 1) {
                            [Toast makeShowCommen:@"您为该条评论," ShowHighlight:@"成功点赞" HowLong:1.5];
                        }else{
                            [Toast makeShowCommen:@"您为该条评论," ShowHighlight:@"取消点赞" HowLong:1.5];
                        }
                    });
                });
            }else{
                
            }
        };
        [sendAndGet commenDataFromNet:zanModel WithRelativePath:@"Zan_Comment"];
    }
}


-(void) rewardAction:(TableViewCell *)cell didClickedCommentWithCellLayout:(CellLayout *)layout
         atIndexPath:(NSIndexPath *)indexPath{
    RewardAlertView *view = [RewardAlertView defaultPopupView];
    view.parentVC = self;
    Users *users = [[Users alloc]init];
    users.uid = [[LoginVM getInstance] readLocal]._id;
    users = (Users *)[[DataBaseHelperSecond getInstance] getModelFromTabel:users];
    StatusModel *statusModel = self.statusModel;
    if ([users.nickname isEqualToString:statusModel.user.nickname]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"打赏失败" message:@"原因：不能对自己打赏" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    [view.balanceLabel setText:users.money];
    __weak DynamicDetailVC *wself = self;
    __block CellLayout *wlayout = layout;
    view.sendAction = ^(Clink_Type clink_type,NSString *howMuch){
        if (clink_type == Clink_Type_One) {
            self.passwordView = [[PasswordView alloc]initWithFrame:self.view.frame];
            self.tabBarController.tabBar.hidden = YES;
            self.passwordView.vc = self;
            self.passwordView.returnData = ^(NSString *passwordStr){
                NSLog(@"%@",passwordStr);
                if ([users.score integerValue] < [howMuch integerValue]) {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"打赏失败" message:@"原因：您的余额不足" delegate:wself cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                    return ;
                }
                CustomAlertView *alertView = [CustomAlertView defaultCustomAlertView:@"打赏中..."];
                [wself lew_presentPopupView:alertView animation:[LewPopupViewAnimationSpring new]];
                [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
                RewardModel *rewardModel = [[RewardModel alloc]init];
                rewardModel.access_token = [[LoginVM getInstance] readLocal].token;
                rewardModel.dynamic_id = statusModel.id;
                rewardModel.score = howMuch;
                SendAndGetDataFromNet *sendAndGet = [[SendAndGetDataFromNet alloc]init];
                sendAndGet.returnModel = ^(GetValueObject *obj,int state){
                    if (1 == state) {
                        [alertView.label setText:@"打赏完成"];
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
                                _titleArr = @[[NSString stringWithFormat:@"评论 %@",self.statusModel.evaluation_count],[NSString stringWithFormat:@"打赏 %@",statusModel.reward_count],];
                                wself.dydHeaderView = nil;
                                wself.selectTools = nil;
                                [wself.tableView reloadData];
                            }];
                        });
                    }else{
                        [alertView.label setText:@"打赏失败"];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [wself lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
                            [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                        });
                    }
                };
                [sendAndGet commenDataFromNet:rewardModel WithRelativePath:@"Reward_Data"];
            };
            [self.view addSubview:self.passwordView];
            [self.passwordView Action];
        }
    };
    [self lew_presentPopupView:view animation:[LewPopupViewAnimationSpring new] dismissed:^{
        NSLog(@"动画结束");
    }];

}
#pragma mark -- begin edit
- (void)chatKeyBoardTextViewDidBeginEditing:(UITextView *)textView{
    if (!subComment) {
        [self keyboardUps];
    }
    NSLog(@"pop");
}
#pragma mark -- 发送文本
- (void)chatKeyBoardSendText:(NSString *)text
{
    if (!(text.length > 0)) {
        return;
    }
    Update = YES;
    [self.chatKeyBoard keyboardDown];
    if (!self.indexPath) {
        if (subComment) {
            if (self.commentAry.count <= self.chatKeyBoard.indexPath.row) {
                return;
            }
            EvaluateModel *evaluateModel = ((DynamicLayout *)[self.commentAry objectAtIndex:self.chatKeyBoard.indexPath.row]).evaluateModel;
            SendEvaluateModel *sendModel = [[SendEvaluateModel alloc]init];
            sendModel.access_token = [[LoginVM getInstance] readLocal].token;
            sendModel.dynamic_id = self.statusModel.id;
            sendModel.eval_id = evaluateModel.eval_id;
            sendModel.content = text;
            SendAndGetDataFromNet *sendAndGet = [[SendAndGetDataFromNet alloc]init];
            sendAndGet.returnModel = ^(GetValueObject *obj,int state){
                if (1 == state) {
                    ChildEvaluateModel *child = [[ChildEvaluateModel alloc]init];
                    child.eval_id = evaluateModel.eval_id;
                    child.dynamic_id = self.statusModel.id;
                    DataBaseHelperSecond *db = [DataBaseHelperSecond getInstance];
                    Users *users = [[Users alloc]init];
                    users.uid = [[LoginVM getInstance] readLocal]._id;
                    users = (Users *)[db getModelFromTabel:users];
                    child.eval_uid = users.uid;
                    child.eval_u_nickname = users.nickname;
                    child.eval_to_uid = evaluateModel.user.uid;
                    child.eval_to_u_nickname = evaluateModel.user.nickname;
                    child.eval_content = text;
                    child.create_time = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
                    DynamicLayout* layout = [self.commentAry objectAtIndex:self.chatKeyBoard.indexPath.row];
                    NSMutableArray* newCommentLists = [[NSMutableArray alloc] initWithArray:evaluateModel._child];
                    NSDictionary *evDict = [[child class] entityToDictionary:child];
                    [newCommentLists insertObject:evDict atIndex:0];
                    evaluateModel._child = newCommentLists;
                    layout = [self layoutWithDetailListModel:evaluateModel index:preSelector];
                    [self.commentAry replaceObjectAtIndex:self.chatKeyBoard.indexPath.row withObject:layout];
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.chatKeyBoard.indexPath.row inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [UIView animateWithDuration:0.3 animations:^{
                        [self.tableView setFrame:[UIScreen mainScreen].bounds];
                    } completion:^(BOOL finished) {
                        
                    }];

                }
            };
            [sendAndGet commenDataFromNet:sendModel WithRelativePath:@"Send_Evaluate"];
        }else{
            SendEvaluateModel *sendModel = [[SendEvaluateModel alloc]init];
            sendModel.access_token = [[LoginVM getInstance] readLocal].token;
            sendModel.dynamic_id = self.statusModel.id;
            sendModel.eval_id = @"0";
            sendModel.content = text;
            SendAndGetDataFromNet *sendAndGet = [[SendAndGetDataFromNet alloc]init];
            sendAndGet.returnModel = ^(GetValueObject *obj,int state){
                if (1 == state) {
                    DataBaseHelperSecond *db = [DataBaseHelperSecond getInstance];
                    Users *users = [[Users alloc]init];
                    users.uid = [[LoginVM getInstance] readLocal]._id;
                    users = (Users *)[db getModelFromTabel:users];
                    EvaluateModel *evaluateModel = [[EvaluateModel alloc]init];
                    evaluateModel.eval_id = @"";
                    evaluateModel.dynamic_id = self.statusModel.id;
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
                    [self postFirstCommentWithCommentModel:evaluateModel WithIndex:0];
                }
            };
            [sendAndGet commenDataFromNet:sendModel WithRelativePath:@"Send_Evaluate"];
            
        }
        
    }
   
}

//二级评论
- (void)postFirstCommentWithCommentModel:(GetValueObject *)model WithIndex : (NSInteger) index {
    DynamicLayout *layout = [self layoutWithDetailListModel:(EvaluateModel *)model index:preSelector];
    [self.commentAry insertObject:layout atIndex:0];
    self.statusModel.evaluation_count = [NSNumber numberWithInteger:[self.statusModel.evaluation_count integerValue] + 1];
    _titleArr = @[[NSString stringWithFormat:@"评论 %@",self.statusModel.evaluation_count],[NSString stringWithFormat:@"打赏 %@",self.statusModel.reward_count],];
    self.dydHeaderView = nil;
    self.selectTools = nil;
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height - self.tableView.bounds.size.height + 49) animated:YES];
    [UIView animateWithDuration:0.3 animations:^{
        [self.tableView setFrame:[UIScreen mainScreen].bounds];
    } completion:^(BOOL finished) {
        
    }];
}

-(void) backAction{
    if (self.pushFromMessageListVC) {
        [self.navigationController popViewControllerAnimated:YES];
        if (self.returnAction) {
            self.returnAction();
        }
        return;
    }
    if (self.pushFromPersonalVC) {
        [self.navigationController popViewControllerAnimated:YES];
        self.navigationController.navigationBar.hidden = YES;
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
    self.tabBarController.tabBar.hidden = NO;
    if (Update) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateDetail" object:self userInfo:nil];
        Update = NO;
    }
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (0 == section) {
        return 0;
    }else{
        if (0 == preSelector) {
            return self.commentAry.count;
        }else if (1 == preSelector){
            return self.rewardAry.count;
        }else{
            return self.goodAry.count;
        }
    }
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (0 == indexPath.section) {
        return nil;
    }
    DynamicCell *cell;
    if (0 == preSelector) {
        static NSString *commentIdentifier = @"commentIdentifier";
        cell = [tableView dequeueReusableCellWithIdentifier:commentIdentifier];
        if (!cell) {
            cell = [[DynamicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentIdentifier];
        }
        if (self.commentAry.count > indexPath.row) {
            DynamicLayout* cellLayouts = self.commentAry[indexPath.row];
            cell.cellLayout = cellLayouts;
        }
    }else{
        static NSString *otherIdentifier = @"otherCellIdentifier";
        cell = [tableView dequeueReusableCellWithIdentifier:otherIdentifier];
        if (!cell) {
            cell = [[DynamicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:otherIdentifier];
        }
        if (self.goodAry.count > indexPath.row) {
            DynamicLayout* cellLayouts = self.goodAry[indexPath.row];
            cell.cellLayout = cellLayouts;
        }
    }
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    detailVC = [[DetailCommentVC alloc]init];
    __block DynamicDetailVC *wself = self;
    detailVC.updateData = ^(NSInteger row){
        updateDetailComment = YES;
        updateRow = row;
        [wself downDetailData];
    };
    detailVC.indexPath2 = indexPath;
    DynamicLayout* cellLayouts = self.commentAry[indexPath.row];
    detailVC.evaluateModel = cellLayouts.evaluateModel;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(NSMutableArray *)goodAry{
    if (_goodAry) {
        return _goodAry;
    }
    _goodAry = [self cellWithDataAry:self.statusModel.goodAry];
    return _goodAry;
}

-(NSMutableArray *)cellWithDataAry:(NSArray *) dataAry{
    NSMutableArray *ary = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < dataAry.count ; i ++) {
        EvaluateModel *detailListModel = [EvaluateModel mj_objectWithKeyValues:[dataAry objectAtIndex:i]];
        if (detailListModel) {
            DynamicLayout *layout = [self layoutWithDetailListModel:detailListModel index:preSelector];
            if (layout) {
                [ary addObject:layout];
            }
        }
    }
    return ary;
}


- (DynamicLayout *)layoutWithDetailListModel:(EvaluateModel *)detilModel index:(NSInteger)index {
    //生成Storage容器
    LWStorageContainer* container = [[LWStorageContainer alloc] init];
    //生成Layout
    DynamicLayout* layout = [[DynamicLayout alloc]initWithContainer:container Model:detilModel dateFormatter:[self dateFormatter] index:index WithDynamic:NO];
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

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (0 == section) {
        return self.dydHeaderView;
    }else{
        return nil;
        //return self.selectTools;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (0 == indexPath.section) {
        return 0;
    }
    if (0 == preSelector) {
        if (self.commentAry.count > indexPath.row) {
            DynamicLayout *dy = [self.commentAry objectAtIndex:indexPath.row];
            return dy.cellHeight + 64 + 44 +10;
        }
    }else{
        if (self.goodAry.count > 0) {
            DynamicLayout *dy = [self.goodAry objectAtIndex:0];
            return dy.cellHeight;
        }
    }
    return 0;
}

/**
 *  点击图片
 *
 */
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



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (0 == section) {
        return self.dydHeaderView.cellLayout.cellHeight + 64 + 44 + 10;
    }else{
        return 0;
        //return self.selectTools.frame.size.height;
    }
}


- (CellLayout *)layoutWithStatusModel:(StatusModel *)statusModel index:(NSInteger)index isDynamicDe : (BOOL) idynamicDe{
    //生成Storage容器
    LWStorageContainer* container = [[LWStorageContainer alloc] init];
    //生成Layout
    CellLayout* layout = [[CellLayout alloc] initWithContainer:container
                                                   statusModel:statusModel
                                                         index:index
                                                 dateFormatter:self.dateFormatter isDynamicDe:YES];
    return layout;
}


-(void)tableViewCell:(UITableViewCell *)cell didClickedLinkWithData:(id)data clinkType:(Clink_Type)clink_type{

    if (clink_type == Clink_Type_One) {
//        OtherPersonCentralVC* vc = [[OtherPersonCentralVC alloc] init];
        PublicOtherPersonVC *vc = [[UIStoryboard storyboardWithName:@"PublicOtherPersonVC" bundle:nil]instantiateInitialViewController];
        
        if ([cell isKindOfClass:[DynamicDetailHeaderView class]]) {
            StatusModel *statusModel = (((TableViewCell *)cell).cellLayout).statusModel;
            vc.user = statusModel.user;
        }else{
            EvaluateModel *evaluateModel = ((DynamicLayout *)(((DynamicCell *)cell).cellLayout)).evaluateModel;
            vc.user = evaluateModel.user;
        }
        vc.fromDynamicDetailVC = YES;
        
        if ([vc.user.uid isEqualToString:[LoginVM getInstance].readLocal._id] || vc.user.uid == nil) {
            return ;
        }
        
        self.navigationController.navigationBar.hidden = YES;
        self.tabBarController.tabBar.hidden = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (clink_type == Clink_Type_Two){
       
    }else if (clink_type == Clink_Type_Three){
        EvaluateModel *evaluateModel = ((DynamicLayout *)(((DynamicCell *)cell).cellLayout)).evaluateModel;
        ChildEvaluateModel *child = [ChildEvaluateModel mj_objectWithKeyValues: [evaluateModel._child objectAtIndex:0]];
//        OtherPersonCentralVC* vc = [[OtherPersonCentralVC alloc] init];
        PublicOtherPersonVC *vc = [[UIStoryboard storyboardWithName:@"PublicOtherPersonVC" bundle:nil]instantiateInitialViewController];
        
        vc.view.backgroundColor = [UIColor whiteColor];
        vc.fromDynamicDetailVC = YES;
        Users *user = [[Users alloc]init];
        user.uid = child.eval_uid;
        user.nickname = child.eval_u_nickname;
        vc.user = user;
        
        if ([vc.user.uid isEqualToString:[LoginVM getInstance].readLocal._id] || vc.user.uid == nil) {
            return ;
        }
        
        self.navigationController.navigationBar.hidden = YES;
        self.tabBarController.tabBar.hidden = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (clink_type == Clink_Type_Four){
        
    }else if (clink_type == Clink_Type_Five){
        EvaluateModel *evaluateModel = ((DynamicLayout *)(((TableViewCell *)cell).cellLayout)).evaluateModel;
        ChildEvaluateModel *child = [ChildEvaluateModel mj_objectWithKeyValues: [evaluateModel._child objectAtIndex:1]];
//        OtherPersonCentralVC* vc = [[OtherPersonCentralVC alloc] init];
        PublicOtherPersonVC *vc = [[UIStoryboard storyboardWithName:@"PublicOtherPersonVC" bundle:nil]instantiateInitialViewController];
        
        vc.view.backgroundColor = [UIColor whiteColor];
        vc.fromDynamicDetailVC = YES;
        Users *user = [[Users alloc]init];
        user.uid = child.eval_uid;
        user.nickname = child.eval_u_nickname;
        vc.user = user;
        
        if ([vc.user.uid isEqualToString:[LoginVM getInstance].readLocal._id] || vc.user.uid == nil) {
            return ;
        }
        
        self.navigationController.navigationBar.hidden = YES;
        self.tabBarController.tabBar.hidden = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (clink_type == Clink_Type_Six){
        
    }else if (clink_type == Clink_Type_Seven){
        
    }else if (clink_type == Clink_Type_Eight){
        
    }else{
        
    }
    
}


- (void)clickBtnUp:(UIButton *)btn
{
    [self.chatKeyBoard keyboardUp];
}

- (void)clickBtnDown:(UIButton *)btn
{
    [self.chatKeyBoard keyboardDown];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DetailCommentVC" object:nil];
    [self.dataAry removeAllObjects];
    self.dataAry = nil;
    [self.commentAry removeAllObjects];
    self.commentAry = nil;
    [self.goodAry removeAllObjects];
    self.goodAry = nil;
}

@end
