//
//  XBOffLiveVideoShowVC.m
//  JZBRelease
//
//  Created by zjapple on 16/10/21.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "XBOffLiveVideoShowVC.h"

#import "AskAnswerList.h"
#import "RewardAlertView.h"

#import "DataBaseHelperSecond.h"
#import "IntegralDetailVC.h"

#import "RewardModel.h"
#import "LewPopupViewAnimationSpring.h"

#import "startNoticeView.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Masonry.h"
#import "ZFPlayer.h"

@interface XBOffLiveVideoShowVC ()

@property (weak, nonatomic) IBOutlet ZFPlayerView *playerVie;

@property (weak, nonatomic) IBOutlet UIButton *payMoneyButton;

@property (atomic, assign) BOOL noticeViewBlock;
/** isMineInfo */
@property (nonatomic, assign) BOOL isMineInfo;

/** noticeview */
@property (nonatomic, weak) startNoticeView *noticeview;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *teacher_companyLabel_Widthconstraint;
@property (weak, nonatomic) IBOutlet UIImageView *teacher_avaImageView;
@property (weak, nonatomic) IBOutlet UILabel *teacher_nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacher_companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacher_jobLabel;
@property (weak, nonatomic) IBOutlet UILabel *liveNumLabel;

@end

@implementation XBOffLiveVideoShowVC

- (void)dealloc
{
    NSLog(@"%@释放了",self.class);
    [self.playerVie cancelAutoFadeOutControlBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if ([self.teacher.uid isEqualToString:[LoginVM getInstance].readLocal._id]) {
        self.isMineInfo = YES;
        self.payMoneyButton.enabled = NO;
    }
    
    [self setupPlayer];
    [self setupTopInfo];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
}

- (void)setupTopInfo
{
//    [self.teacher_avaImageView sd_setImageWithURL:[NSURL URLWithString:[AddHostToLoadPIC AddHostToLoadPICWithString:self.teacher.avatar]] placeholderImage:[UIImage imageNamed:@"ZCCG_TX"]];
    
    [LocalDataRW getImageWithDirectory:Directory_XB RetalivePath:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:self.teacher.avatar] WithContainerImageView:self.teacher_avaImageView];
    
    self.teacher_nickNameLabel.text = self.teacher.nickname;
    self.teacher_companyLabel.text = self.teacher.company;
    self.teacher_jobLabel.text = self.teacher.job;
    
    [self.teacher_companyLabel sizeToFit];
    [self.teacher_jobLabel sizeToFit];
    
    if (self.teacher_companyLabel.glw_width + self.teacher_jobLabel.glw_width < 120) {
        self.teacher_companyLabel_Widthconstraint.constant = self.teacher_companyLabel.glw_width;
    }
    
    self.liveNumLabel.text = self.liveitem.online_count;
    
    self.teacher_avaImageView.layer.cornerRadius = self.teacher_avaImageView.glw_width * 0.5;
    self.teacher_avaImageView.clipsToBounds = YES;
}

- (void)setupPlayer
{
    self.playerVie.liveitem = self.liveitem;
    
    self.playerVie.videoURL = self.videoURL;
    // （可选设置）可以设置视频的填充模式，内部设置默认（ZFPlayerLayerGravityResizeAspect：等比例填充，直到一个维度到达区域边界）
    self.playerVie.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
    // 打开断点下载功能（默认没有这个功能）
    self.playerVie.hasDownload = YES;
    
    // 如果想从xx秒开始播放视频
    //self.playerView.seekTime = 15;
    __weak typeof(self) weakSelf = self;
    self.playerVie.goBackBlock = ^{
//        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    self.playerVie.panel.backBtn.hidden = YES;
    
}

#pragma mark - 旋转
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
    /** 高林修改了 旋转屏幕后 9：16 view 没有返回按钮 */
    if (self.playerVie.isFullScreen == YES) {
        // 这里 YES / NO  是反的 是转换前
        self.playerVie.panel.backBtn.hidden = YES;
    }else {
        self.playerVie.panel.backBtn.hidden = NO;
    }
    
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        self.view.backgroundColor = [UIColor whiteColor];
        //if use Masonry,Please open this annotation
        /*
         [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(self.view).offset(20);
         }];
         */
    }else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        self.view.backgroundColor = [UIColor blackColor];
        //if use Masonry,Please open this annotation
        /*
         [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(self.view).offset(0);
         }];
         */
    }
}

/** 点击问答列表 */
- (IBAction)ClickQuestionListButton:(UIButton *)sender {
    
    AskAnswerList *list = [AskAnswerList new];
    
    list.teacher = self.teacher;
    list.dataSource = self.question;
    list.class_id = self.class_id;
    
    list.callBackDataS = ^(NSArray *dataSource){
        self.question = dataSource;
    };
    
    [self presentViewController:list animated:YES completion:^{
        self.noticeViewBlock = NO;
    }];
    
    
    
}

/** 点击评论 */
- (IBAction)ClickCommentButton:(UIButton *)sender {
    
    
    
}

/** 点击打赏 */
- (IBAction)ClickPayButton:(UIButton *)sender {
    
    RewardAlertView *view = [RewardAlertView defaultPopupView];
    view.parentVC = self;
    Users *users = [[Users alloc]init];
    users.uid = [[LoginVM getInstance] readLocal]._id;
    users = (Users *)[[DataBaseHelperSecond getInstance] getModelFromTabel:users];
    
    [view.balanceLabel setText:users.money];
    __weak XBOffLiveVideoShowVC *wself = self;
    
    view.sendAction = ^(Clink_Type clink_type,NSString *howmuch){
        
        if (clink_type == Clink_Type_Three) {
            IntegralDetailVC *vc = [[UIStoryboard storyboardWithName:@"IntegralDetailVC" bundle:nil] instantiateInitialViewController];
            
            vc.isFromPreseVC = YES;
            
            [self presentViewController:vc animated:YES completion:^{
                
            }];
        }
        
        if (clink_type == Clink_Type_One) {
            if ([users.score integerValue] < [howmuch integerValue]) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"打赏失败" message:@"原因：您的余额不足" delegate:wself cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                return ;
            }
            //            CustomAlertView *alertView = [CustomAlertView defaultCustomAlertView:@"支付中..."];
            //            [wself lew_presentPopupView:alertView animation:[LewPopupViewAnimationSpring new]];
            
            [SVProgressHUD showWithStatus:@"支付中..."];
            
            [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
            RewardModel *rewardModel = [[RewardModel alloc]init];
            rewardModel.access_token = [[LoginVM getInstance] readLocal].token;
            rewardModel.id = self.class_id;
            
            rewardModel.score = howmuch;
            
            SendAndGetDataFromNet *sendAndGet = [[SendAndGetDataFromNet alloc]init];
            sendAndGet.returnModel = ^(GetValueObject *obj,int state){
                if (1 == state) {
                    [SVProgressHUD showSuccessWithStatus:@"打赏完成"];
                    //                    [alertView.label setText:@"支付完成"];
                    [[DataBaseHelperSecond getInstance] delteModelFromTabel:users];
                    [[DataBaseHelperSecond getInstance] insertModelToTabel:users];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [wself lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
                        [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                    });
                }else{
                    if (self.isMineInfo) {
                        [SVProgressHUD showErrorWithStatus:@"不能打赏自己"];
                        return ;
                    }
                    //                    [alertView.label setText:@"支付失败"];
                    [SVProgressHUD showErrorWithStatus:@"没有打赏,有需要联系我们"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [wself lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
                        [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                    });
                }
            };
            
            [sendAndGet commenDataFromNet:rewardModel WithRelativePath:@"Reward_CourseTime_URL"];
        }
        
    };
    
    //    __block CellLayout *wlayout = layout;
    //    view.sendAction = ^(Clink_Type clink_type,NSString *howMuch){
    //        if (clink_type == Clink_Type_One) {
    ////            self.passwordView = [[PasswordView alloc]initWithFrame:self.view.frame];
    ////            self.tabBarController.tabBar.hidden = YES;
    ////            self.passwordView.vc = self;
    //            self.passwordView.returnData = ^(NSString *passwordStr){
    //                NSLog(@"%@",passwordStr);
    //                if ([users.score integerValue] < [howMuch integerValue]) {
    //                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"打赏失败" message:@"原因：您的余额不足" delegate:wself cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //                    [alertView show];
    //                    return ;
    //                }
    //                CustomAlertView *alertView = [CustomAlertView defaultCustomAlertView:@"支付中..."];
    //                [wself lew_presentPopupView:alertView animation:[LewPopupViewAnimationSpring new]];
    //                [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
    //                RewardModel *rewardModel = [[RewardModel alloc]init];
    //                rewardModel.access_token = [[LoginVM getInstance] readLocal].token;
    //                rewardModel.dynamic_id = statusModel.id;
    //                rewardModel.score = howMuch;
    //                SendAndGetDataFromNet *sendAndGet = [[SendAndGetDataFromNet alloc]init];
    //                sendAndGet.returnModel = ^(GetValueObject *obj,int state){
    //                    if (1 == state) {
    //                        [alertView.label setText:@"支付完成"];
    //                        [[DataBaseHelperSecond getInstance] delteModelFromTabel:users];
    //                        [[DataBaseHelperSecond getInstance] insertModelToTabel:users];
    //                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //                            [wself lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
    //                            [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
    //                            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(wlayout.rewardNumPosition.origin.x, wlayout.rewardNumPosition.origin.y - 2 * wlayout.rewardNumPosition.size.width, wlayout.rewardNumPosition.size.width, wlayout.rewardNumPosition.size.height)];
    //                            [label setTextColor:[UIColor redColor]];
    //                            [label setText:@"+1"];
    //                            [cell addSubview:label];
    //                            [UIView animateWithDuration:1 animations:^{
    //                                label.frame = wlayout.rewardNumPosition;
    //                            } completion:^(BOOL finished) {
    //                                [label removeFromSuperview];
    //                                statusModel.reward_count = [NSNumber numberWithInteger:[statusModel.reward_count integerValue] + 1];
    //                                _titleArr = @[[NSString stringWithFormat:@"评论 %@",self.statusModel.evaluation_count],[NSString stringWithFormat:@"打赏 %@",statusModel.reward_count],];
    //                                wself.dydHeaderView = nil;
    //                                wself.selectTools = nil;
    //                                [wself.tableView reloadData];
    //                            }];
    //                        });
    //                    }else{
    //                        [alertView.label setText:@"支付失败"];
    //                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //                            [wself lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
    //                            [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
    //                        });
    //                    }
    //                };
    //                [sendAndGet commenDataFromNet:rewardModel WithRelativePath:@"Reward_Data"];
    //            };
    //            [self.view addSubview:self.passwordView];
    //            [self.passwordView Action];
    //        }
    //    };
    
    [self lew_presentPopupView:view animation:[LewPopupViewAnimationSpring new] dismissed:^{
        NSLog(@"动画结束");
    }];
    
}

/** 点击分享 */
- (IBAction)ClickShareButton:(UIButton *)sender {
    
    
    
}

/** 点击关闭 */
- (IBAction)ClickCloseButton:(UIButton *)sender {
    
    [self.noticeview removeFromSuperview];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
//        [self.currentView closePlayer];
    }];
    
}

#pragma mark - 预告view
- (void)StartNotice
{
    [self.view layoutIfNeeded];
    
    if (self.noticeViewBlock) {
        return ;
    }else{
        self.noticeViewBlock = YES;
    }
    
    startNoticeView *noticeview = [startNoticeView startNoticeView];
    [self.view addSubview:noticeview];
    self.noticeview = noticeview;
    noticeview.glx_x = 0;
    noticeview.gly_y = GLScreenH * 0.5 - (155 / 2);
    noticeview.glw_width = GLScreenW;
    noticeview.glh_height = 155;
    
    noticeview.alpha = 0;
    
    noticeview.panelView.hidden = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        noticeview.alpha = 1;
    });
    
    
    
    /** 视频点播 也先【同上】这样吧 */
    if ([self.liveitem.type isEqualToString:@"1"]) {
        noticeview.isVoice = YES;
    }
    
    noticeview.liveitem = self.liveitem;
}

@end
