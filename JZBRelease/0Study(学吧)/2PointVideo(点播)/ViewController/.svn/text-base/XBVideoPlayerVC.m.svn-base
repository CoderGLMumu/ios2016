//
//  XBVideoPlayerVC.m
//  JZBRelease
//
//  Created by zjapple on 16/9/21.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "XBVideoPlayerVC.h"
#import "AliVcMoiveViewController.h"
#import "AskAnswerList.h"
#import "PushToVideoPopView.h"

#import "AliVcMoiveViewController.h"

#import "RewardAlertView.h"
#import "DataBaseHelperSecond.h"
#import "StatusModel.h"
#import "AskAnswerList.h"

#import "AppDelegate.h"

@interface XBVideoPlayerVC ()
@property (weak, nonatomic) IBOutlet UIButton *pushVideoButton;

@property (weak, nonatomic) IBOutlet UIView *videoView;

@property (strong, nonatomic) TBMoiveViewController* currentView;

@end

@implementation XBVideoPlayerVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    TBMoiveViewController* currentView = [[TBMoiveViewController alloc] init];
    self.currentView = currentView;
    
    //    NSURL *url = [NSURL URLWithString:@"http://live2.jianzhongbang.com/tset/aaa1234.m3u8"];
    
    /** 利哥的直播间 */
//        NSURL *url = [NSURL URLWithString:@"http://live2.jianzhongbang.com/test/aaa.flv"];
    
//    NSURL *url = [NSURL URLWithString:@"http://cn-gdjm4-dx.acgvideo.com/vg6/8/a7/10303387-1.flv?expires=1474477500&ssig=z1cj7n4hQqtW9Yb31CN_yA&oi=2004961372&rate=0"];
    
    [currentView SetMoiveSource:[NSURL URLWithString:self.playUrl]];
    
//        [self.view layoutIfNeeded];
    
    currentView.videoFrame = CGRectMake(0, 0, GLScreenW, GLScreenH);
    
    if (!self.playUrl) {
        self.pushVideoButton.enabled = NO;
    }
    
    currentView.callBack = ^(NSString *timeLabel,VideoActionType type){
    
//        NSLog(@"12312312%@",timeLabel);
        if ([timeLabel isEqualToString:@"timeLabel"]) {
            self.pushVideoButton.enabled = NO;
        }
    
    };
    
    [self addChildViewController:currentView];
    [self.videoView addSubview:currentView.view];
    
    if ([self.detailItem.type isEqualToString:@"1"]) {
        self.pushVideoButton.enabled = NO;
    }
    
//    [self setupTopInfo];
}

/** 点击问答列表 */
- (IBAction)ClickQuestionListButton:(UIButton *)sender {
    
    return ;
    
    AskAnswerList *list = [AskAnswerList new];
    
    list.teacher = self.teacher;
    list.dataSource = self.question;
    list.class_id = self.class_id;
    
    list.callBackDataS = ^(NSArray *dataSource){
        self.question = dataSource;
    };
    
    [self presentViewController:list animated:YES completion:^{
        
    }];
    
}


/** 点击关闭 */
- (IBAction)ClickCloseButton:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self.currentView closePlayer];
    }];
    
}

/** 点击推送到点播列表 */
- (IBAction)ClickPayButton:(UIButton *)sender {
    
    
    PushToVideoPopView *popView = [PushToVideoPopView pushToVideoPopView];
    popView.class_id = self.detailItem.aid;
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.6;
    view.frame = self.view.frame;
    [self.view addSubview:view];
    
    popView.frame = CGRectMake(10 ,self.view.glh_height * 0.5 - (popView.glh_height * 0.5) - 100,GLScreenW - 20 ,200);
    
//    if (self.liveitem.score || self.myInfo.score) {
//        popView.payScore = self.liveitem.score;
//        popView.stillScore = self.myInfo.score;
//        [popView updateData];
//    }
    
    [self.view addSubview:popView];
    
    popView.layer.cornerRadius = 5;
    popView.clipsToBounds = YES;
    
  //  __weak typeof(self) weakSelf = self;
    
    popView.clickCloseWindow = ^{
        [view removeFromSuperview];
    };
    
    popView.clickPayUp = ^{
        
//        AppDelegate *delegate = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
//        
//        if (delegate.checkpay) {
//            
////            IntegralDetailVC *vc = [[UIStoryboard storyboardWithName:@"IntegralDetailVC" bundle:nil] instantiateInitialViewController];
////            
////            [weakSelf.navigationController pushViewController:vc animated:YES];
//            
//        }else{
////            self.addMoneyButton.hidden = YES;
//        }

        
        
    };
    
    popView.passToLive = ^{
        
        self.pushVideoButton.enabled = NO;
    };
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.videoView removeFromSuperview];
    [self.currentView removeFromParentViewController];
    
    if (self.callBackDataS) {
        self.callBackDataS(self.question);
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
