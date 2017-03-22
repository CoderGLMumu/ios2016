//
//  LiveVideoViewController.m
//  JZBRelease
//
//  Created by zjapple on 16/9/12.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "LiveVideoViewController.h"
#import "AliVcMoiveViewController.h"
#import <AliyunPlayerSDK/AliVcMediaPlayer.h>
#import "AlivcLiveViewController.h"
#import <AlivcLiveVideo/AlivcLiveVideo.h>
#import "AlivcLiveRoomViewController.h"

#import "Masonry.h"
#import "XBLiveVideoShowVC.h"
#import "XBLiveMobileVideoShowVC.h"
#import "LiveVideoDetailItem.h"
#import "DealNormalUtil.h"
#import "SignUpPopView.h"
#import "IntegralDetailVC.h"
#import "AskAnswerItem.h"

#import "LocalDataRW.h"
#import "ZJBHelp.h"
#import "TeacherInfoView.h"

#import "VideoDetailXGKCCell.h"
#import "PublicOtherPersonVC.h"

#import "AppDelegate.h"

#import "XBOffLiveVideoShowVC.h"
#import "XBOffLiveVoiceShowVC.h"

#import "payForWechat.h"
#import "payForAlipay.h"
#import "payAlipayItem.h"
#import "XBVideoAndVoiceVC.h"
#import "CourseTimeEvaluateModel.h"

#import "ZFPlayer.h"
#import "Defaults.h"
#import "VideoCommentCell.h"
#import "ChatKeyBoard.h"
#import "ChatToolBarItem.h"
#import "MoreItem.h"
#import "FaceSourceManager.h"
#import "SendEvaluateForQuestionModel.h"
#import "ZanVideoModel.h"
#import "PushToVideoPopView.h"

#import "XBLiveComputerShowVC.h"
#import "reward_rankItem.h"

@interface LiveVideoViewController () <UIScrollViewDelegate ,UITableViewDelegate , UITableViewDataSource,UIActionSheetDelegate,ChatKeyBoardDelegate,ChatKeyBoardDataSource,UIAlertViewDelegate>{
    BOOL isRight;
    int topHeight;
    UIWebView *web;
    NSInteger state;
    UILabel *courseTimeview;
    NSInteger inteval;
    NSInteger font;
    NSInteger imageWidth;
    BOOL isSendComment;
    BOOL isZan;
    NSInteger whichCell;
    NSInteger waitHit;
    BOOL gotoVIPVC;
    UIView *liveView;
}


/** topImageView */
@property (nonatomic, weak) UIImageView *topImageView;
/** isAccessPlay */
@property (nonatomic, assign) BOOL isAccessPlay;
/** isLive */
@property (nonatomic, assign) BOOL isLive;

@property (strong, nonatomic) ZFPlayerView *playerVie;
/** 判断是音频或者视频 点播 */
@property (nonatomic, assign) BOOL videoOrVoice;
@property (nonatomic, weak) UIImageView *BGimageV;

/** contentView */
@property (nonatomic, strong) UIScrollView *contentView;
/** topView */
@property (nonatomic, strong) UIView *topView;
/** top2View */
@property (nonatomic, strong) UIView *top2View;

@property (nonatomic, strong) UIView *exchangeView;

/** midView */
@property (nonatomic, strong) UIView *midView;

/** 进入按钮 */
@property (nonatomic, strong) UIButton *LiveEnterButton;
/** 收藏按钮 */
@property (nonatomic, strong) UIButton *collectButton;

/** 购买按钮 */
@property (nonatomic, strong) UIButton *buyButton;

/** 返回按钮 */
@property (nonatomic, weak) UIButton *backButton;
/** item */
@property (nonatomic, strong) LiveVideoDetailItem *liveitem;

/** myInfo */
@property (nonatomic, strong) Users *myInfo;

/** JGContentLabel */
@property (nonatomic, strong) UIView *JGContentLabel;

/** rightView */
@property (nonatomic, strong) UIView *rightView;

/** leftView */
@property (nonatomic, weak) UIView *leftView;

/** huadongView0 */
@property (nonatomic, strong) UIView *huadongView0;

/** subscribeInfoTview */
@property (nonatomic, strong) UITextView *subscribeInfoTview;

/** tableView */
@property (nonatomic, strong) UITableView *tableView;

/** scrollView */
@property (nonatomic, strong) UIScrollView *left_rightContentScrV;

/** dataSource */
@property (nonatomic, strong) NSArray *dataSource;
/** reward_rankDataSource */
@property (nonatomic, strong) NSArray *reward_rankDataSource;

@property(nonatomic, strong) NSMutableArray *commentAry;

@property (nonatomic, strong) ChatKeyBoard *chatKeyBoard;

@property(nonatomic, assign) NSInteger requestCount;

@property(nonatomic, assign) ThemeListModel *theme;

@end

@implementation LiveVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.item.type isEqualToString:@"1"] || [self.item.type isEqualToString:@"2"]) {
        self.isLive = NO;
        [self setupPlayer];
 //       [self.view addSubview:self.topView];
    }else {
       self.isLive = YES;
    }
    
    self.view.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f8f8f8"];
    
    [self GetMyInfo];
    
    [self setuptitleView];

    self.automaticallyAdjustsScrollViewInsets = NO;
    [self DownLoadData];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];

}


-(void)configNav
{
    
    UIButton *sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 35, 28)];
    //[sendBtn setImage:[UIImage imageNamed:@"BQ_DT_release"] forState:UIControlStateNormal];
    [sendBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(editCourseTime) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    UIBarButtonItem *sendBarBtn = [[UIBarButtonItem alloc]initWithCustomView:sendBtn];
    self.navigationItem.rightBarButtonItem = sendBarBtn;
}



- (void)editCourseTime{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您确定您满意该课程吗？如确定系统将会把该课程发布到系统平台" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (1 == buttonIndex) {
        PushToVideoPopView *popView = [PushToVideoPopView pushToVideoPopView];
        popView.type = self.liveitem.type;
        popView.class_id = self.liveitem.aid;
        
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.6;
        view.frame = self.view.frame;
        [self.view addSubview:view];
        
        popView.frame = CGRectMake(10 ,self.view.glh_height * 0.5 - (popView.glh_height * 0.5) - 100,GLScreenW - 20 ,200);

        [self.view addSubview:popView];
        
        popView.layer.cornerRadius = 5;
        popView.clipsToBounds = YES;
        
        __weak typeof(self) weakSelf = self;
        
        popView.clickCloseWindow = ^{
            [view removeFromSuperview];
        };
        
        popView.clickPayUp = ^{

        };
        
        popView.passToLive = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
            //self.pushVideoButton.enabled = NO;
        };
        
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if ([self.item.type isEqualToString:@"1"] || [self.item.type isEqualToString:@"2"]) {
        self.isLive = NO;
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }else {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.isLive = YES;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

//    [self.playerVie resetPlayer]
}

- (void)setuptitleView
{
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.glw_width - 112 * 2, 40)];
    
    titleLable.text = @"课程详情";
    
    if (self.isBackVideo) {
        titleLable.text = @"课程详情";
    }
    
    if (self.isLineDown) {
        titleLable.text = @"课程详情";
    }
    
    titleLable.textColor = [UIColor hx_colorWithHexRGBAString:@"ffffff"];
    
    titleLable.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLable;
}

- (void)DownLoadData
{
//    NSDictionary *parameters = @{
//                                 @"access_token":[LoginVM getInstance].readLocal.token,
//                                 @"id":self.item.id,
//                                 @"my":@"1"
//                                 };
    
      HttpBaseRequestItem *item = [HttpBaseRequestItem new];
      item.access_token = [[LoginVM getInstance]readLocal].token;
      item.id = self.item.id;
      item.my = @"1";
      NSDictionary *parameters = item.mj_keyValues;
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/Study/getClass"] parameters:parameters success:^(id json) {
    
    if ([json[@"state"] isEqual:@(0)]) {
        [SVProgressHUD showInfoWithStatus:json[@"info"]];
        return ;
    }
        if (isSendComment) {
            self.liveitem = [LiveVideoDetailItem mj_objectWithKeyValues:json[@"data"]];
            self.reward_rankDataSource = [reward_rankItem mj_objectArrayWithKeyValuesArray:self.liveitem.reward_rank];
            
            if (self.liveitem.evaluate) {
                dispatch_async(dispatch_queue_create("", nil), ^{
                    if (!self.commentAry) {
                        self.commentAry = [[NSMutableArray alloc]init];
                    }
                    [self.commentAry removeAllObjects];
                    [self cellWithDataModel:self.liveitem.evaluate];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                });
            }
            isSendComment = NO;
            return;
        }
        
        
        self.liveitem = [LiveVideoDetailItem mj_objectWithKeyValues:json[@"data"]];
        self.reward_rankDataSource = [reward_rankItem mj_objectArrayWithKeyValuesArray:self.liveitem.reward_rank];
        if (([self.liveitem.type isEqualToString:@"3"] || [self.liveitem.type isEqualToString:@"4"]) && self.liveitem.video_url.length > 0 && [self.liveitem.teacher.uid isEqualToString:[LoginVM getInstance].users.uid]) {
            [self configNav];
        }
        if (self.liveitem.evaluate) {
            dispatch_async(dispatch_queue_create("", nil), ^{
                if (!self.commentAry) {
                    self.commentAry = [[NSMutableArray alloc]init];
                }
                [self.commentAry removeAllObjects];
                [self cellWithDataModel:self.liveitem.evaluate];
            });
        }
       //        self.playerVie.videoURL = [NSURL URLWithString:self.liveitem.play_path];
        if ([self.liveitem.type isEqualToString:@"1"] || [self.liveitem.type isEqualToString:@"2"]) {
            
            if ([self.liveitem.score isEqualToString:@"0"] || [self.liveitem.is_pay isEqualToNumber:@(1)] || [[LoginVM getInstance].readLocal._id isEqualToString:self.liveitem.teacher.uid] || [LoginVM getInstance].users.vip) {
                self.isAccessPlay = YES;
            }else {
                [self setupBotView];
            }
        }else {
                [self setupBotView];
        }
        
        [self DownLoadListData];

//        NSLog(@"TTT--json%@",json);
    } failure:^(NSError *error) {
        
    }];
}

- (void)DownLoadListData
{
    if (!self.liveitem.objects.id) {
        
        UILabel *label = [UILabel new];
        label.frame = self.rightView.frame;
        label.text = @"暂无数据";
        [self.rightView addSubview:label];
        
    }
    UserInfo *info = [[LoginVM getInstance] readLocal];
    if (!info.token || !self.liveitem) {
        [[LoginVM getInstance] loginWithUserInfoForGetNewToken:info];
    }
    NSDictionary *parameters = @{
                                 @"access_token":[LoginVM getInstance].readLocal.token,
                                 @"theme":self.liveitem.theme.id,
                                 };
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/Study/getClass"] parameters:parameters success:^(id json) {
        
        if ([json[@"state"] isEqual:@(0)]) {
            [SVProgressHUD showInfoWithStatus:json[@"info"]];
            return ;
        }
        
        self.dataSource = [XBLiveListItem mj_objectArrayWithKeyValuesArray:json[@"data"]];
        
//        if ([self.item.content hasPrefix:@"http"]) {
//            NSString *path = [self.item.content stringByReplacingOccurrencesOfString:@"amp;" withString:@""];
//            web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, GLScreenW, GLScreenH - 64 - 52)];
//            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
//            [web loadRequest:request];
//            [self.view addSubview:web];
//        }else{
             [self setupRightView:self.view];
        if (self.isLive) {
            
        }else{
            [self topView];
        }
        
        
        //}

    } failure:^(NSError *error) {
        
    }];
}

- (void)GetMyInfo
{
    NSDictionary *parameters = @{
                                 @"access_token":[LoginVM getInstance].readLocal.token,
                                 };
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/user/info"] parameters:parameters success:^(id json) {
        
        if ([json[@"state"] isEqual:@(0)]) {
            [SVProgressHUD showInfoWithStatus:json[@"info"]];
            return ;
        }
        
        self.myInfo = [Users mj_objectWithKeyValues:json[@"data"]];
        
//        NSLog(@"TTT--json%@",json);
    } failure:^(NSError *error) {
        
    }];
}

- (NSDateFormatter *)dateFormatter {
    static NSDateFormatter* dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YY年MM月dd日 hh:mm"];
    });
    return dateFormatter;
}

- (void)cellWithDataModel:(NSArray *) array{
    if (!courseTimeview) {
        if (fabs((double)MAX(Main_Screen_Width, Main_Screen_Height) - (double)568) < DBL_EPSILON) {
            inteval = 4;
            font = 13;
            imageWidth = 36;
        }else if (fabs((double)MAX(Main_Screen_Width, Main_Screen_Height) - (double)736) < DBL_EPSILON){
            inteval = 8;
            font = 16;
            imageWidth = 44;
            
        }else if (fabs((double)MAX(Main_Screen_Width, Main_Screen_Height) - (double)667) < DBL_EPSILON){
            inteval = 6;
            font = 15;
            imageWidth = 40;
        }

        
        courseTimeview = [[UILabel alloc]init];
        courseTimeview.font = [UIFont systemFontOfSize:font];
        courseTimeview.numberOfLines = 0;
        courseTimeview.lineBreakMode = NSLineBreakByWordWrapping;
    }
    for (int i = 0; i < array.count; i ++) {
        CourseTimeEvaluateModel *model = [CourseTimeEvaluateModel mj_objectWithKeyValues:[array objectAtIndex:i]];
        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:model.eval_content];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:inteval];
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [model.eval_content length])];
        [courseTimeview setAttributedText:attributedString1];
        CGSize size = [courseTimeview sizeThatFits:CGSizeMake(SCREEN_WIDTH - 35 - imageWidth, MAXFLOAT)];
        model.height = 13 + imageWidth + size.height + 6 + 35;
        [self.commentAry addObject:model];
    }
}


- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc]init];
        [_topView setBackgroundColor:[UIColor whiteColor]];
        
        if ([self.item.type isEqualToString:@"1"] || [self.item.type isEqualToString:@"2"]) {
            
            /** 在viewdidLoad初始化 */
//            [self setupPlayer];
            
            [self addPlayerInfo];
            
            if (self.videoOrVoice) {
   
                self.playerVie.glh_height = ScreenWidth / 16 * 9;
                
            }else{
                self.playerVie.glh_height = 155;
            }
            
            
            [_topView setFrame:CGRectMake(0, 0, GLScreenW, self.playerVie.glh_height)];
            
            // 返回按钮
//            UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            self.backButton = backButton;
//            backButton.alpha = 0;
//            [backButton setImage:[UIImage imageNamed:@"KC_back"] forState:UIControlStateNormal];
//            [self.view addSubview:backButton];
//            backButton.frame = CGRectMake(15, 32, 0, 0);
//            [backButton sizeToFit];
//            
//            [backButton addTarget:self action:@selector(BackActive) forControlEvents:UIControlEventTouchUpInside];
            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [UIView animateWithDuration:0.25 animations:^{
//                    backButton.alpha = 1;
//                }];
//            });
            
            return _topView;
        }
        
        /** 顶部banner图 */
        UIImageView *topImageView = [UIImageView new];
        [_topView addSubview:topImageView];
        self.topImageView = topImageView;
        topImageView.frame = CGRectMake(0, 0, self.view.glw_width, 155);
        /** 给顶部imageView赋值 */
        //    [topImageView sd_setImageWithURL:[NSURL URLWithString:[AddHostToLoadPIC AddHostToLoadPICWithString:self.liveitem.thumb]] placeholderImage:[UIImage imageNamed:@"VideoPlaceholder"]];
        
        NSString *path = [[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:self.liveitem.thumb2];
        dispatch_async(dispatch_queue_create("queue_content", nil), ^{
            UIImage *image = [LocalDataRW getImageWithDirectory:Directory_XB RetalivePath:path];
            
            image = [ZJBHelp handleImage:image withSize:topImageView.frame.size withFromStudy:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [topImageView setImage:image];
            });
        });
        
//        /** 顶部白色biew */
//        UIView *top2View = [UIView new];
//        [_topView addSubview:top2View];
//        self.top2View = top2View;
//        /** top2View.frame 为了适应内容大小 后面应该修改高度 【181动态】 */
//        top2View.frame = CGRectMake(0, topImageView.glb_bottom, self.view.glw_width, 171);
//        top2View.backgroundColor = [UIColor whiteColor];
//        
//        UILabel *topLabel = [UILabel new];
//        [top2View addSubview:topLabel];
//        topLabel.text = self.liveitem.title;
//        topLabel.font = [UIFont systemFontOfSize:17];
//        topLabel.numberOfLines = 2;
//        topLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        
//        
//        CGSize size = [topLabel sizeThatFits:CGSizeMake(GLScreenW - 40, MAXFLOAT)];
//        
//        topLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"222222"];
//        [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(@(12));
//            make.left.equalTo(@(20));
//            make.right.equalTo(@(-20));
//        }];
//        
//        UILabel *moneyLabel = [UILabel new];
//        [top2View addSubview:moneyLabel];
//        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//        
//        if (appDelegate.checkpay) {
//            moneyLabel.text = [NSString stringWithFormat:@"%@元(会员免费)",self.liveitem.score];
//        }else{
//            moneyLabel.text = [NSString stringWithFormat:@"%@帮币(会员免费)",self.liveitem.score];
//        }
//
//        if ([self.liveitem.score isEqualToString:@"0"]) {
//            moneyLabel.text = @"免费观看";
//        }
//            
//        if ([self.liveitem.score isEqualToString:@"0"]) {
//            moneyLabel.text = [self.liveitem.score stringByAppendingString:@" (会员免费)"];
//        }
//        
//        moneyLabel.font = [UIFont systemFontOfSize:15];
//        moneyLabel.numberOfLines = 1;
//        moneyLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"ff9800"];
//        [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(topLabel.mas_bottom).offset(9);
//            make.left.equalTo(topLabel);
//        }];
//        
//        UIImageView *timeIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"KCXQ_time"]];
//        [top2View addSubview:timeIcon];
//        [timeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(moneyLabel.mas_bottom).offset(12);
//            make.left.equalTo(topLabel);
//        }];
//        
//        UILabel *timeLabelDay = [UILabel new];
//        [top2View addSubview:timeLabelDay];
//        //    timeLabelDay.text = @"99年12月12日";
//        timeLabelDay.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
//        timeLabelDay.font = [UIFont systemFontOfSize:13];
//        [timeLabelDay mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(timeIcon);
//            make.left.equalTo(timeIcon.mas_right).offset(7);
//        }];
//        
//        NSTimeInterval time= [self.liveitem.start_time doubleValue];
//        timeLabelDay.text = [[self dateFormatter] stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
//        
//        if (!self.liveitem.start_time) {
//            timeLabelDay.text = @"即刻观看";
//        }
//        
//        UIImageView *onlineIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"KCXQ_xskc"]];
//        [top2View addSubview:onlineIcon];
//        [onlineIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(timeIcon.mas_bottom).offset(12);
//            make.left.equalTo(topLabel);
//        }];
//        
//        UILabel *onlineLabel = [UILabel new];
//        [top2View addSubview:onlineLabel];
//        if ([self.item.type integerValue] == 5) {
//            onlineLabel.text = @"线下课程";
//        }else{
//            onlineLabel.text = @"线上课程";
//        }
//        
//        onlineLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
//        onlineLabel.font = [UIFont systemFontOfSize:13];
//        [onlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(onlineIcon);
//            make.left.equalTo(onlineIcon.mas_right).offset(7);
//        }];
//        
//        UIImageView *KCXQ_SCIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"KCXQ_SC"]];
//        [top2View addSubview:KCXQ_SCIcon];
//        [KCXQ_SCIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(onlineIcon.mas_bottom).offset(12);
//            make.left.equalTo(topLabel);
//        }];
//        
//        UILabel *KCXQ_SCLabel = [UILabel new];
//        [top2View addSubview:KCXQ_SCLabel];
//        KCXQ_SCLabel.text = [NSString stringWithFormat:@"%@人已收藏",self.liveitem.zan_count];
//        KCXQ_SCLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
//        KCXQ_SCLabel.font = [UIFont systemFontOfSize:13];
//        [KCXQ_SCLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(KCXQ_SCIcon);
//            make.left.equalTo(KCXQ_SCIcon.mas_right).offset(7);
//        }];
//        
//        UIImageView *peopleIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"KCXQ_BM"]];
//        [top2View addSubview:peopleIcon];
//        [peopleIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(KCXQ_SCIcon.mas_bottom).offset(12);
//            make.left.equalTo(topLabel);
//        }];
//        
//        
//        UILabel *peopleLabel1 = [UILabel new];
//        [top2View addSubview:peopleLabel1];
//        peopleLabel1.text = @"已有";
//        peopleLabel1.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
//        peopleLabel1.font = [UIFont systemFontOfSize:13];
//        [peopleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(peopleIcon);
//            make.left.equalTo(peopleIcon.mas_right).offset(7);
//        }];
//        
//        UILabel *peopleLabel2 = [UILabel new];
//        [top2View addSubview:peopleLabel2];
//        peopleLabel2.text = self.liveitem.join_count;
//        peopleLabel2.textColor = [UIColor hx_colorWithHexRGBAString:@"ff9800"];
//        peopleLabel2.font = [UIFont systemFontOfSize:13];
//        [peopleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(peopleIcon);
//            make.left.equalTo(peopleLabel1.mas_right);
//        }];
//        
//        UILabel *peopleLabel3 = [UILabel new];
//        [top2View addSubview:peopleLabel3];
//        peopleLabel3.text = @"人购买";
//        peopleLabel3.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
//        peopleLabel3.font = [UIFont systemFontOfSize:13];
//        [peopleLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(peopleIcon);
//            make.left.equalTo(peopleLabel2.mas_right);
//        }];
//        if ([self.liveitem.type integerValue] == 5) {
//            peopleLabel1.hidden = NO;
//            if (!self.liveitem.appointment_count) {
//                self.liveitem.appointment_count = @(0);
//            }
//            peopleLabel2.text = [NSString stringWithFormat:@"%@",self.liveitem.appointment_count];
//            peopleLabel2.hidden = NO;
//            peopleLabel3.text = @"预约报名体验";
//        }else{
//            
//            if ([LoginVM getInstance].users.vip) {
//                peopleLabel2.text = self.liveitem.show_count;
//                peopleLabel3.text = @"人观看";
//            }else{
//                if ([self.liveitem.score isEqualToString:@"0"]) {
//                    peopleLabel2.text = self.liveitem.show_count;
//                    peopleLabel3.text = @"人观看";
//                }
//            }
//            
//        }
        
        
//        UIImageView *peopleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"KCXQ_arrow"]];
//        
//        [top2View addSubview:peopleImageView];
//        peopleImageView.contentMode = UIViewContentModeRight;
//        [peopleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(peopleLabel1);
//            make.left.equalTo(self.view).offset(20);
//            make.right.equalTo(self.view).offset(-20);
//            make.height.equalTo(peopleLabel1);
//        }];
//        
//        peopleImageView.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappeopleImageView:)];
//        
//        [peopleImageView addGestureRecognizer:tap];
        
        //    UIButton *peopleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //    peopleBtn.backgroundColor = [UIColor redColor];
        //    [top2View addSubview:peopleBtn];
        //    peopleBtn.imageView.contentMode = UIViewContentModeRight;
        ////    [peopleBtn.imageView ];
        //    [peopleBtn setImage:[UIImage imageNamed:@"KCXQ_arrow"] forState:UIControlStateNormal];
        //    [peopleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.centerY.equalTo(peopleLabel1);
        //        make.left.equalTo(self.view).offset(20);
        //        make.right.equalTo(self.view).offset(-20);
        //    }];
        
       // [self.view layoutIfNeeded];
        
//        UIView *fengexian99 = [UIView new];
//        top2View.glh_height = peopleLabel3.glb_bottom + 14;
//        if (size.height > 40) {
//            [_topView setFrame:CGRectMake(0, 0, GLScreenW, 155 + 201 + 12)];
//            fengexian99.frame = CGRectMake(0, 155 + 191 + 10, GLScreenW, 12);
////        }else{
//            [_topView setFrame:CGRectMake(0, 0, GLScreenW, 155 + 181 + 12)];
//            fengexian99.frame = CGRectMake(0, 155 + 171 + 10, GLScreenW, 12);
//        }
        [_topView setFrame:CGRectMake(0, 0, GLScreenW, topImageView.glh_height)];
//        fengexian99.frame = CGRectMake(0, 155 + 10, GLScreenW, 12);
//        [_topView addSubview:fengexian99];
//        fengexian99.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f2f2f2"];
    }
    return _topView;
}


- (UIView *)exchangeView{
    if ([self.liveitem.type isEqualToString:@"3"] || [self.liveitem.type isEqualToString:@"4"]) {
        if (!_exchangeView) {
            _exchangeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GLScreenW, 44)];
            [_exchangeView setBackgroundColor:[UIColor whiteColor]];
            UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_exchangeView addSubview:detailButton];
            [detailButton setFrame:CGRectMake(0, 0, SCREEN_WIDTH / 2, 44)];
            [detailButton setFont:[UIFont systemFontOfSize:14]];
            [detailButton setTitleColor:[UIColor hx_colorWithHexRGBAString:@"212121"] forState:UIControlStateNormal];
            [detailButton setTitle:@"详 情" forState:UIControlStateNormal];
            [detailButton addTarget:self action:@selector(clickdetailB:) forControlEvents:UIControlEventTouchUpInside];
            
//            UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            [_exchangeView addSubview:commentButton];
//            [commentButton setFrame:CGRectMake(SCREEN_WIDTH / 3, 0, SCREEN_WIDTH / 3, 44)];
//            [commentButton setFont:[UIFont systemFontOfSize:14]];
//            [commentButton setTitleColor:[UIColor hx_colorWithHexRGBAString:@"212121"] forState:UIControlStateNormal];
//            [commentButton setTitle:@"评 论" forState:UIControlStateNormal];
//            [commentButton addTarget:self action:@selector(clickCommentB:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *XGKCButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_exchangeView addSubview:XGKCButton];
            [XGKCButton setFrame:CGRectMake(SCREEN_WIDTH  / 2, 0, SCREEN_WIDTH / 2, 44)];
            [XGKCButton setFont:[UIFont systemFontOfSize:14]];
            [XGKCButton setTitleColor:[UIColor hx_colorWithHexRGBAString:@"212121"] forState:UIControlStateNormal];
            [XGKCButton setTitle:@"相关课程" forState:UIControlStateNormal];
            [XGKCButton addTarget:self action:@selector(clickxgkc:) forControlEvents:UIControlEventTouchUpInside];
            
            self.huadongView0 = [[UIView alloc]initWithFrame:CGRectMake(40, 40, GLScreenW / 2 - 80, 3)];
            [self.huadongView0 setBackgroundColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]]];
            [_exchangeView addSubview:self.huadongView0];
            
            UIView *intevalView = [[UIView alloc]initWithFrame:CGRectMake(0, 43, GLScreenW, 1)];
            [intevalView setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
            [_exchangeView addSubview:intevalView];
            
        }

    }else{
        if (!_exchangeView) {
            _exchangeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GLScreenW, 44)];
            [_exchangeView setBackgroundColor:[UIColor whiteColor]];
            UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_exchangeView addSubview:detailButton];
            [detailButton setFrame:CGRectMake(0, 0, SCREEN_WIDTH / 3, 44)];
            [detailButton setFont:[UIFont systemFontOfSize:14]];
            [detailButton setTitleColor:[UIColor hx_colorWithHexRGBAString:@"212121"] forState:UIControlStateNormal];
            [detailButton setTitle:@"详 情" forState:UIControlStateNormal];
            [detailButton addTarget:self action:@selector(clickdetailB:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_exchangeView addSubview:commentButton];
            [commentButton setFrame:CGRectMake(SCREEN_WIDTH / 3, 0, SCREEN_WIDTH / 3, 44)];
            [commentButton setFont:[UIFont systemFontOfSize:14]];
            [commentButton setTitleColor:[UIColor hx_colorWithHexRGBAString:@"212121"] forState:UIControlStateNormal];
            [commentButton setTitle:@"评 论" forState:UIControlStateNormal];
            [commentButton addTarget:self action:@selector(clickCommentB:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *XGKCButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_exchangeView addSubview:XGKCButton];
            [XGKCButton setFrame:CGRectMake(SCREEN_WIDTH * 2 / 3, 0, SCREEN_WIDTH / 3, 44)];
            [XGKCButton setFont:[UIFont systemFontOfSize:14]];
            [XGKCButton setTitleColor:[UIColor hx_colorWithHexRGBAString:@"212121"] forState:UIControlStateNormal];
            [XGKCButton setTitle:@"相关课程" forState:UIControlStateNormal];
            [XGKCButton addTarget:self action:@selector(clickxgkc:) forControlEvents:UIControlEventTouchUpInside];
            
            self.huadongView0 = [[UIView alloc]initWithFrame:CGRectMake((GLScreenW / 3 - 80) / 2, 40, 80, 3)];
            [self.huadongView0 setBackgroundColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]]];
            [_exchangeView addSubview:self.huadongView0];
            
            UIView *intevalView = [[UIView alloc]initWithFrame:CGRectMake(0, 43, GLScreenW, 1)];
            [intevalView setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
            [_exchangeView addSubview:intevalView];
            
        }
    }
    return _exchangeView;
}


- (UIView *)midView
{
    if(!_midView){
    /** 中部白色biew */
        UIView *midView = [UIView new];
        _midView = midView;
//        if ([self.item.content hasPrefix:@"http"]) {
////            [midView setFrame:CGRectMake(0, 0, GLScreenW, self.dataSource.count * 120)];
////            NSString *path = [self.item.content stringByReplacingOccurrencesOfString:@"amp;" withString:@""];
////            web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, GLScreenW, self.dataSource.count * 120)];
////            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
////            [web loadRequest:request];
////            [_midView addSubview:web];
//            
//        }else{
            /** top2View.frame 为了适应内容大小 后面应该修改高度 【255动态】 */
            midView.frame = CGRectMake(0, 155, self.view.glw_width, 255);
            midView.backgroundColor = [UIColor whiteColor];
        
        
        /** 顶部白色biew */
        UIView *top2View = [UIView new];
        [midView addSubview:top2View];
        self.top2View = top2View;
        /** top2View.frame 为了适应内容大小 后面应该修改高度 【181动态】 */
        top2View.frame = CGRectMake(0, 5, self.view.glw_width, 201);
        top2View.backgroundColor = [UIColor whiteColor];
        
        UILabel *topLabel = [UILabel new];
        [top2View addSubview:topLabel];
        topLabel.text = self.liveitem.title;
        topLabel.font = [UIFont systemFontOfSize:17];
        topLabel.numberOfLines = 2;
        topLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        
        CGSize size2 = [topLabel sizeThatFits:CGSizeMake(GLScreenW - 40, MAXFLOAT)];
        
        topLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"222222"];
        [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(12));
            make.left.equalTo(@(20));
            make.right.equalTo(@(-20));
        }];
        
        UILabel *moneyLabel = [UILabel new];
        [top2View addSubview:moneyLabel];
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        if (appDelegate.checkpay) {
            moneyLabel.text = [NSString stringWithFormat:@"%@元(会员免费)",self.liveitem.score];
        }else{
            moneyLabel.text = [NSString stringWithFormat:@"%@帮币(会员免费)",self.liveitem.score];
        }
        
        if ([self.liveitem.score isEqualToString:@"0"]) {
            moneyLabel.text = @"免费观看";
        }
        
        if ([self.liveitem.score isEqualToString:@"0"]) {
            moneyLabel.text = [self.liveitem.score stringByAppendingString:@" (会员免费)"];
        }
        
        moneyLabel.font = [UIFont systemFontOfSize:15];
        moneyLabel.numberOfLines = 1;
        moneyLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"ff9800"];
        [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topLabel.mas_bottom).offset(9);
            make.left.equalTo(topLabel);
        }];
        
        UIImageView *timeIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"KC_time"]];
        [top2View addSubview:timeIcon];
        [timeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(moneyLabel.mas_bottom).offset(12);
            make.left.equalTo(topLabel);
        }];
        
        UILabel *timeLabelDay = [UILabel new];
        [top2View addSubview:timeLabelDay];
        //    timeLabelDay.text = @"99年12月12日";
        timeLabelDay.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
        timeLabelDay.font = [UIFont systemFontOfSize:13];
        [timeLabelDay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(timeIcon);
            make.left.equalTo(timeIcon.mas_right).offset(7);
        }];
        
        NSTimeInterval time= [self.liveitem.start_time doubleValue];
        timeLabelDay.text = [[self dateFormatter] stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
        
        if (!self.liveitem.start_time) {
            timeLabelDay.text = @"即刻观看";
        }
        
        UIImageView *onlineIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"KC_xskc"]];
        [top2View addSubview:onlineIcon];
        [onlineIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(timeIcon.mas_bottom).offset(12);
            make.left.equalTo(topLabel);
        }];
        
        UILabel *onlineLabel = [UILabel new];
        [top2View addSubview:onlineLabel];
        if ([self.item.type integerValue] == 5) {
            onlineLabel.text = @"线下课程";
        }else{
            onlineLabel.text = @"线上课程";
        }
        
        onlineLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
        onlineLabel.font = [UIFont systemFontOfSize:13];
        [onlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(onlineIcon);
            make.left.equalTo(onlineIcon.mas_right).offset(7);
        }];
        
        UIImageView *KCXQ_SCIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"KC_SC"]];
        [top2View addSubview:KCXQ_SCIcon];
        [KCXQ_SCIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(onlineIcon.mas_bottom).offset(12);
            make.left.equalTo(topLabel);
        }];
        
        UILabel *KCXQ_SCLabel = [UILabel new];
        [top2View addSubview:KCXQ_SCLabel];
        KCXQ_SCLabel.text = [NSString stringWithFormat:@"%@人已收藏",self.liveitem.zan_count];
        KCXQ_SCLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
        KCXQ_SCLabel.font = [UIFont systemFontOfSize:13];
        [KCXQ_SCLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(KCXQ_SCIcon);
            make.left.equalTo(KCXQ_SCIcon.mas_right).offset(7);
        }];
        
        UIImageView *peopleIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"KC_BM"]];
        [top2View addSubview:peopleIcon];
        [peopleIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(KCXQ_SCIcon.mas_bottom).offset(12);
            make.left.equalTo(topLabel);
        }];
        
        
        UILabel *peopleLabel1 = [UILabel new];
        [top2View addSubview:peopleLabel1];
        peopleLabel1.text = @"已有";
        peopleLabel1.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
        peopleLabel1.font = [UIFont systemFontOfSize:13];
        [peopleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(peopleIcon);
            make.left.equalTo(peopleIcon.mas_right).offset(7);
        }];
        
        UILabel *peopleLabel2 = [UILabel new];
        [top2View addSubview:peopleLabel2];
        peopleLabel2.text = self.liveitem.join_count;
        peopleLabel2.textColor = [UIColor hx_colorWithHexRGBAString:@"ff9800"];
        peopleLabel2.font = [UIFont systemFontOfSize:13];
        [peopleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(peopleIcon);
            make.left.equalTo(peopleLabel1.mas_right);
        }];
        
        UILabel *peopleLabel3 = [UILabel new];
        [top2View addSubview:peopleLabel3];
        peopleLabel3.text = @"人购买";
        peopleLabel3.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
        peopleLabel3.font = [UIFont systemFontOfSize:13];
        [peopleLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(peopleIcon);
            make.left.equalTo(peopleLabel2.mas_right);
        }];
        if ([self.liveitem.type integerValue] == 5) {
            peopleLabel1.hidden = NO;
            if (!self.liveitem.appointment_count) {
                self.liveitem.appointment_count = @(0);
            }
            peopleLabel2.text = [NSString stringWithFormat:@"%@",self.liveitem.appointment_count];
            peopleLabel2.hidden = NO;
            peopleLabel3.text = @"预约报名体验";
        }else{
            
            if ([LoginVM getInstance].users.vip) {
                peopleLabel2.text = self.liveitem.show_count;
                peopleLabel3.text = @"人观看";
            }else{
                if ([self.liveitem.score isEqualToString:@"0"]) {
                    peopleLabel2.text = self.liveitem.show_count;
                    peopleLabel3.text = @"人观看";
                }
            }
            
        }
        
        [self.view layoutIfNeeded];
        
        UIView *fengexian1 = [[UIView alloc]initWithFrame:CGRectMake(10, peopleLabel3.frame.origin.y + peopleLabel3.frame.size.height + 23, GLScreenW - 20, 1)];
        [fengexian1 setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
        [midView addSubview:fengexian1];
        
            UIView *jgView;
        
            if (self.liveitem.is_mechanism.integerValue == 0) {
                
            }else {
                
                
                jgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GLScreenW, 100)];
                UIImageView *JGIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"WD_titleicon"]];
                [JGIcon setFrame:CGRectMake(10, 22, 4, 12)];
                [midView addSubview:jgView];
                [jgView addSubview:JGIcon];
                
                /** 机构简介 */
                UILabel *JGTitleLabel = [[UILabel alloc]init];
                [jgView addSubview:JGTitleLabel];
                JGTitleLabel.text = @"机构简介";
                JGTitleLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"2196f3"];
                JGTitleLabel.font = [UIFont systemFontOfSize:15];
                [JGTitleLabel setFrame:CGRectMake(20, 18, 120, 21)];
                
                UILabel *JGContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, JGTitleLabel.frame.origin.y + JGTitleLabel.frame.size.height, GLScreenW - 40, 60)];
                [jgView addSubview:JGContentLabel];
                self.JGContentLabel = JGContentLabel;
                JGContentLabel.backgroundColor = [UIColor clearColor]; //背景色
                JGContentLabel.userInteractionEnabled = NO;
                JGContentLabel.text = self.liveitem.mechanism.content;
                JGContentLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
                JGContentLabel.font = [UIFont systemFontOfSize:14];
                JGContentLabel.numberOfLines = 0;
                JGContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
                
                /** 设置行距 */
                NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:self.liveitem.mechanism.content];
                NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle1 setLineSpacing:8];
                [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [self.liveitem.mechanism.content length])];
                [JGContentLabel setAttributedText:attributedString1];
                
                /** ********* */
                
                CGSize size = [JGContentLabel sizeThatFits:CGSizeMake(JGContentLabel.frame.size.width, MAXFLOAT)];
                [JGContentLabel setFrame:CGRectMake(20, JGTitleLabel.frame.origin.y + JGTitleLabel.frame.size.height + 20, GLScreenW - 40, size.height)];
                
                UIView *intevalView = [[UIView alloc]initWithFrame:CGRectMake(10, JGContentLabel.frame.origin.y + JGContentLabel.frame.size.height + 23, GLScreenW - 20, 1)];
                [intevalView setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
                [jgView addSubview:intevalView];
                [jgView setFrame:CGRectMake(0, top2View.glh_height, GLScreenW, intevalView.frame.origin.y + intevalView.frame.size.height)];
                
            }
            
            
            UIView *teacherView = [UIView new];
            if (jgView) {
                [teacherView setFrame:CGRectMake(0, jgView.frame.origin.y + jgView.frame.size.height, GLScreenW, 155)];
            }else{
                [teacherView setFrame:CGRectMake(0, top2View.glh_height, GLScreenW, 150)];
            }
            [midView addSubview:teacherView];
            UIImageView *teacherIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"WD_titleicon"]];
            [teacherIcon setFrame:CGRectMake(10, 22, 4, 12)];
            [teacherView addSubview:teacherIcon];
            /** 老师简介 */
            UILabel *teacherLabel = [[UILabel alloc]initWithFrame:CGRectMake(23, 18, 120, 21)];
            [teacherView addSubview:teacherLabel];
            teacherLabel.text = @"老师简介";
            teacherLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"2196f3"];
            teacherLabel.font = [UIFont systemFontOfSize:15];
            [teacherView addSubview:teacherLabel];
            
            
            TeacherInfoView *TinfoView = [TeacherInfoView TeacherInfoView];
            [teacherView addSubview:TinfoView];
            [TinfoView mas_makeConstraints:^(MASConstraintMaker *make) {
                //        make.height.equalTo(@(GLScreenW));
                make.height.equalTo(@(110));
                make.top.equalTo(teacherLabel.mas_bottom).offset(0);
                make.left.equalTo(teacherView).offset(0);
                make.right.equalTo(teacherView).offset(0);
            }];
            
            TinfoView.teacherInfo = self.liveitem.teacher;
            [TinfoView addTarget:self action:@selector(pushPublicPersonInfo:) forControlEvents:UIControlEventTouchUpInside];
            TinfoView.userInteractionEnabled = YES;
            
            UIImageView *imageView_clickhud = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"KCXQ_BIGarrow"]];
            [teacherView addSubview:imageView_clickhud];
            [imageView_clickhud mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(TinfoView).offset(0);
                make.right.equalTo(teacherView).offset(-20);
            }];
            UIView *intevalView2 = [[UIView alloc]initWithFrame:CGRectMake(10, 154, GLScreenW - 20, 1)];
            [intevalView2 setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
            [teacherView addSubview:intevalView2];
            
            
            
            
            UIView *courseIntroView = [[UIView alloc]initWithFrame:CGRectMake(0, teacherView.frame.origin.y + teacherView.frame.size.height, GLScreenW, 100)];
            [midView addSubview:courseIntroView];
            UIImageView *courseIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"WD_titleicon"]];
            [courseIcon setFrame:CGRectMake(10, 22, 4, 12)];
            [courseIntroView addSubview:courseIcon];
            
            /** 课程简介 */
            UILabel *courseLabel = [[UILabel alloc]initWithFrame:CGRectMake(23, 18, 120, 21)];
            [courseIntroView addSubview:courseLabel];
            courseLabel.text = @"课程简介";
            courseLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"2196f3"];
            courseLabel.font = [UIFont systemFontOfSize:15];
            
            
            
            UILabel *courseTview = [[UILabel alloc]init];
            [courseIntroView addSubview:courseTview];
            courseTview.backgroundColor = [UIColor clearColor]; //背景色
            courseTview.userInteractionEnabled = NO;
            courseTview.text = self.liveitem.content;
            courseTview.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
            courseTview.font = [UIFont systemFontOfSize:14];
            courseTview.numberOfLines = 0;
            courseTview.lineBreakMode = NSLineBreakByWordWrapping;
            NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:self.liveitem.content];
            NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle1 setLineSpacing:8];
            [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [self.liveitem.content length])];
            [courseTview setAttributedText:attributedString1];

            CGSize size = [courseTview sizeThatFits:CGSizeMake(GLScreenW - 40, MAXFLOAT)];
            [courseTview setFrame:CGRectMake(20, courseLabel.frame.origin.y + courseLabel.frame.size.height + 20, GLScreenW - 40, size.height)];
            UIView *intevalView = [[UIView alloc]initWithFrame:CGRectMake(10, courseTview.frame.origin.y + courseTview.frame.size.height + 18, GLScreenW - 20, 1)];
            [intevalView setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
            [courseIntroView addSubview:intevalView];
            
            [courseIntroView setFrame:CGRectMake(0, teacherView.frame.origin.y + teacherView.frame.size.height, GLScreenW, intevalView.frame.origin.y + intevalView.frame.size.height)];
            
            
            
            UIView *payKnowView = [[UIView alloc]initWithFrame:CGRectMake(0, courseIntroView.frame.origin.y + courseIntroView.frame.size.height, GLScreenW, 100)];
            [midView addSubview:payKnowView];
            
            UIImageView *subscribeInfoIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"WD_titleicon"]];
            [subscribeInfoIcon setFrame:CGRectMake(10, 22, 4, 12)];
            [payKnowView addSubview:subscribeInfoIcon];
            
            /** 订阅须知 */
            UILabel *subscribeInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(23, 18, 120, 21)];
            [payKnowView addSubview:subscribeInfoLabel];
            subscribeInfoLabel.text = @"观看须知";
            subscribeInfoLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"2196f3"];
            subscribeInfoLabel.font = [UIFont systemFontOfSize:15];
            
            
            UILabel *subscribeInfoTview = [[UILabel alloc]initWithFrame:CGRectMake(20, subscribeInfoLabel.frame.origin.y + subscribeInfoLabel.frame.size.height + 20, GLScreenW - 40, 60)];
            [payKnowView addSubview:subscribeInfoTview];
            subscribeInfoTview.backgroundColor = [UIColor clearColor]; //背景色
            subscribeInfoTview.userInteractionEnabled = NO;
        subscribeInfoTview.numberOfLines = 0;
            if (![self.item.score isEqualToString:@"0"]) {
                if ([LoginVM getInstance].users.vip) {
                    subscribeInfoTview.text = @"本课程可以免费观看";
                }else{
                    subscribeInfoTview.text = [NSString stringWithFormat:@"本课程为付费订阅产品,%@元,订阅成功概不退款,敬请谅解",self.item.score];
                }
            }else {
                subscribeInfoTview.text = @"本课程可以免费观看";
            }
        
        
            subscribeInfoTview.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
            subscribeInfoTview.font = [UIFont systemFontOfSize:14];
            NSMutableAttributedString * attributedString2 = [[NSMutableAttributedString alloc] initWithString:subscribeInfoTview.text];
            NSMutableParagraphStyle * paragraphStyle2 = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle2 setLineSpacing:8];
            [attributedString2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle2 range:NSMakeRange(0, [subscribeInfoTview.text length])];
            [subscribeInfoTview setAttributedText:attributedString2];
            
            subscribeInfoTview.lineBreakMode = NSLineBreakByWordWrapping;
            CGSize subscribeInfoTviewsize = [subscribeInfoTview sizeThatFits:CGSizeMake(subscribeInfoTview.frame.size.width, MAXFLOAT)];
            [subscribeInfoTview setFrame:CGRectMake(20, subscribeInfoLabel.frame.origin.y + subscribeInfoLabel.frame.size.height + 20, GLScreenW - 40, subscribeInfoTviewsize.height)];
            
            UIView *intevalView3 = [[UIView alloc]initWithFrame:CGRectMake(10, subscribeInfoTview.frame.origin.y + subscribeInfoTview.frame.size.height + 20, GLScreenW - 20, 1)];
            [intevalView3 setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
            [payKnowView addSubview:intevalView3];
            
            [payKnowView setFrame:CGRectMake(0, courseIntroView.frame.origin.y + courseIntroView.frame.size.height, GLScreenW, intevalView3.frame.origin.y + intevalView3.frame.size.height)];
            
            [midView setFrame:CGRectMake(0, 0, GLScreenW, payKnowView.frame.origin.y + payKnowView.frame.size.height )];
            
//        }

    }
    return _midView;
}

/** 点击报名列表 */
//- (void)tappeopleImageView:(UITapGestureRecognizer *)tap
//{
////    [SVProgressHUD showInfoWithStatus:@"点击了多少个人报名"];
//    
//    if (self.liveitem.join_count) {
//        //
////        跳转报名列表
//    }
//
//    
////    CauLabelH.text = subscribeInfoTview.text;
////    [CauLabelH sizeToFit];
//    UILabel *CauLabelH3 = [UILabel new];
//    CauLabelH3.frame = CGRectMake(10, 0, GLScreenW -10, 0);
//    CauLabelH3.numberOfLines = 0;
//    CauLabelH3.text = subscribeInfoTview.text;
//    [CauLabelH3 sizeToFit];
//    
//    subscribeInfoTview.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
//    subscribeInfoTview.font = [UIFont systemFontOfSize:14];
//    [subscribeInfoTview sizeToFit];
//    [self.view layoutIfNeeded];
//    [subscribeInfoTview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(subscribeInfoLabel.mas_bottom).offset(10);
//        make.left.equalTo(leftView).offset(20);
//        make.right.equalTo(leftView).offset(-20);
//        make.height.equalTo(@(CauLabelH3.glh_height));
//    }];
//    
//    [self.view layoutIfNeeded];
//    
//    midView.glh_height = subscribeInfoTview.glb_bottom + 18 + 49 + 18;
//    
//    [self.view layoutIfNeeded];
//    
//    self.contentView.contentSize = CGSizeMake(0, midView.glb_bottom + 22);
//    
//    left_rightContentScrV.glh_height = midView.glh_height;
//    leftView.glh_height = midView.glh_height;
//    rightView.glh_height = midView.glh_height;
//    
//    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(left_rightContentScrV).offset(0);
//        make.left.equalTo(left_rightContentScrV).offset(0);
//        make.width.equalTo(@(GLScreenW));
//        make.height.equalTo(@(midView.glh_height));
//    }];
////    leftView.backgroundColor = [UIColor redColor];
//    
//
//}

- (void)setupBotView
{
    [self.view layoutIfNeeded];
    UIView *intevalView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.glh_height - 52, GLScreenW, 1)];
    [intevalView setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"dfdfdf"]];
    [self.view addSubview:intevalView];
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setTitle:@"收藏" forState:UIControlStateNormal];
    
    if (self.liveitem.is_zan.integerValue == 1) {
        [btn1 setTitle:@"已收藏" forState:UIControlStateNormal];
    }
    
    [btn1 setTitleColor:[UIColor hx_colorWithHexRGBAString:@"212121"] forState:UIControlStateNormal];
    btn1.frame = CGRectMake(0, self.view.glh_height - 51, self.view.glw_width * 0.5, 51);
    [self.view addSubview:btn1];
    btn1.backgroundColor = [UIColor whiteColor];
    [btn1 addTarget:self action:@selector(ClickCommentButton:) forControlEvents:UIControlEventTouchUpInside];
    self.collectButton = btn1;
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setTitle:@"购买" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn2.frame = CGRectMake(self.view.glw_width * 0.5, self.view.glh_height - 51, self.view.glw_width * 0.5, 51);
    [self.view addSubview:btn2];
    self.buyButton = btn2;
    btn2.backgroundColor = [UIColor orangeColor];
    [btn2 addTarget:self action:@selector(ClickApplicationButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.LiveEnterButton = btn3;
    
    if ([self.item.type isEqualToString:@"1"]) {
        [btn3 setTitle:@"观看视频" forState:UIControlStateNormal];
    }
    
    if ([self.item.type isEqualToString:@"2"]) {
        [btn3 setTitle:@"进入课程" forState:UIControlStateNormal];
    }
    
    if ([self.item.type isEqualToString:@"3"] || [self.item.type isEqualToString:@"4"]) {
        [btn3 setTitle:@"进入直播" forState:UIControlStateNormal];
    }
    
    if ([self.liveitem.is_appointment integerValue] == 1) {
        if ([self.item.type isEqualToString:@"5"]) {
            [btn3 setTitle:@"进入体验" forState:UIControlStateNormal];
        }
    }else{
        if ([self.item.type isEqualToString:@"5"]) {
            [btn3 setTitle:@"预约体验" forState:UIControlStateNormal];
        }
    }
    
    [btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn3.frame = CGRectMake(self.view.glw_width * 0.5, self.view.glh_height - 52, self.view.glw_width * 0.5, 52);
    [self.view addSubview:btn3];
    btn3.backgroundColor = [UIColor orangeColor];
    [btn3 addTarget:self action:@selector(ClickEnterButton:) forControlEvents:UIControlEventTouchUpInside];
    
    btn2.hidden = NO;
    self.LiveEnterButton.hidden = YES;
    
    if ([self.liveitem.score isEqualToString:@"0"]) {
        btn2.hidden = YES;
        btn3.hidden = NO;
    }
    
    if ([self.liveitem.is_pay isEqualToNumber:@(1)] || [[LoginVM getInstance].readLocal._id isEqualToString:self.liveitem.teacher.uid]) {
        btn2.hidden = YES;
        btn3.hidden = NO;
    }
    
    if ([self.item.type isEqualToString:@"5"]) {
        [btn2 setTitle:@"预约体验" forState:UIControlStateNormal];
        if ([self.liveitem.is_appointment isEqualToNumber:@(1)]) {
            btn2.hidden = YES;
            btn3.hidden = NO;
        }
    }
    
    if ([LoginVM getInstance].users.vip) {
        btn2.hidden = YES;
        btn3.hidden = NO;
    }
    
    if ([[LoginVM getInstance].readLocal._id isEqualToString:self.liveitem.teacher.uid] && ([self.liveitem.type integerValue] == 3 || [self.liveitem.type integerValue] == 4)) {
        if ([self.liveitem.label isEqualToString:@"直播已结束"]) {
            if (self.liveitem.video_url && self.liveitem.video_url.length > 0) {
                btn2.hidden = YES;
                btn3.hidden = NO;
                [btn3 setTitle:@"观看视频" forState:UIControlStateNormal];
            }else{
                btn2.hidden = YES;
                btn3.hidden = NO;
                [btn3 setTitle:@"观看视频" forState:UIControlStateNormal];
                [SVProgressHUD showInfoWithStatus:@"播放地址不存在，无法播放！"];
            }
            
        }else{
            btn2.hidden = YES;
            btn3.hidden = NO;
            [btn3 setTitle:@"开始直播" forState:UIControlStateNormal];
        }
        
    }
    
}

- (void)setupRightView:(UIView *)view
{

    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.playerVie.frame.origin.y + self.playerVie.frame.size.height, GLScreenW, GLScreenH - self.playerVie.frame.origin.y - self.playerVie.frame.size.height) style:UITableViewStylePlain];
    

    
//    if (self.isAccessPlay) {
//        tableView.glh_height = GLScreenH - 20;
//    }
//    
//    if (!self.isLive) {
//        tableView.gly_y = 20;
//    }else {
//        tableView.glh_height = GLScreenH - 52 - 64;
//    }
//    

    if (self.isAccessPlay) {
        
    }else {
        tableView.glh_height -= 52;
    }
//
    if (!self.isLive) {
//        tableView.gly_y = 20 + 64;
//        tableView.glh_height = GLScreenH - 52  - 64;
    }else {
        tableView.glh_height = GLScreenH - 52  - 64;
        tableView.gly_y = 64;
    }
//

    self.tableView = tableView;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    
//    rightView.glh_height = self.dataSource.count * 120 + 15;
    
    
    
    tableView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f8f8f8"];
    
    //tableView.scrollEnabled = NO;

}

//
//- (void)setupEnterLiveVideo
//{
//    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setTitle:@"测试按钮" forState:UIControlStateNormal];
//    btn.frame = CGRectMake(150, 150, 150, 150);
//    [self.view addSubview:btn];
//    btn.backgroundColor = [UIColor purpleColor];
//    [btn addTarget:self action:@selector(testgaolinhahaha:) forControlEvents:UIControlEventTouchUpInside];
//    
//}

#pragma mark - 点击 跳转老师信息 按钮
- (void)pushPublicPersonInfo:(UIControl *)btn
{
    PublicOtherPersonVC *vc = [[UIStoryboard storyboardWithName:@"PublicOtherPersonVC" bundle:nil]instantiateInitialViewController];
    
    vc.user = self.liveitem.teacher;
    vc.fromDynamicDetailVC = YES;
    
    if ([vc.user.uid isEqualToString:[LoginVM getInstance].readLocal._id] || vc.user.uid == nil) {
        return ;
    }
    
    [self.navigationController setHidesBottomBarWhenPushed:YES];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 点击 收藏 按钮
- (void)ClickCommentButton:(UIButton *)btn
{
    
//    NSLog(@"点击了收藏按钮");
    
    
    NSDictionary *parameters = @{
                                 @"access_token":[LoginVM getInstance].readLocal.token,
                                 @"id":self.liveitem.aid
                                 };
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/Study/zan"] parameters:parameters success:^(id json) {
        
        publicBaseJsonItem *item = [publicBaseJsonItem mj_objectWithKeyValues:json];
    
    if ([item.state isEqual:@(0)]) {
        [SVProgressHUD showInfoWithStatus:item.info];
    }else {
        
        btn.selected = !btn.selected;
        
        if (self.liveitem.is_zan.integerValue == 1) {
            [btn setTitle:@"收藏" forState:UIControlStateNormal];
            self.liveitem.is_zan = @(0);
            [SVProgressHUD showInfoWithStatus:@"亲，课程已经成功取消收藏，您是否已经掌握课程的精髓和方法，记得实践喔！"];
        }else {
            [btn setTitle:@"已收藏" forState:UIControlStateNormal];
            self.liveitem.is_zan = @(1);
            [SVProgressHUD showSuccessWithStatus:@"亲，课程已经成功收藏，您记得及时学习喔！知识的价值在于分享，分享的意义在于力行！"];
        }
    }
    
//        NSLog(@"TTT--json%@",json);
    } failure:^(NSError *error) {
        
    }];
    
        //    self.pushUrl = @"rtmp://192.168.30.69/live/movie";
    
//        NSString *str = @"rtmp://video-center.alivecdn.com/test/aaa?vhost=live2.jianzhongbang.com";
    
//        NSString *str = self.liveitem.push_path;
//    
//        if (![str containsString:@"rtmp://"]) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"推流地址格式错误，无法直播" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//            return;
//        }
//    
//        AlivcLiveViewController *live = [[AlivcLiveViewController alloc] initWithNibName:@"AlivcLiveViewController" bundle:nil url:str];
//        live.isScreenHorizontal = NO;
//        [self presentViewController:live animated:YES completion:nil];
}

#pragma mark - 点击 收藏 按钮
- (void)ClickCommentButton2:(UIButton *)btn
{
    
    //    NSLog(@"点击了收藏按钮");
    
    
    NSDictionary *parameters = @{
                                 @"access_token":[LoginVM getInstance].readLocal.token,
                                 @"id":self.liveitem.aid
                                 };
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/Study/zan"] parameters:parameters success:^(id json) {
        
        publicBaseJsonItem *item = [publicBaseJsonItem mj_objectWithKeyValues:json];
        
        if ([item.state isEqual:@(0)]) {
            [SVProgressHUD showInfoWithStatus:item.info];
        }else {
            
            btn.selected = !btn.selected;
            
            if (self.liveitem.is_zan.integerValue == 1) {
                //            [btn setTitle:@"收藏" forState:UIControlStateNormal];
                self.liveitem.is_zan = @(0);
                [SVProgressHUD showInfoWithStatus:@"亲，课程已经成功取消收藏，您是否已经掌握课程的精髓和方法，记得实践喔！"];
            }else {
                //            [btn setTitle:@"已收藏" forState:UIControlStateNormal];
                self.liveitem.is_zan = @(1);
                [SVProgressHUD showSuccessWithStatus:@"亲，课程已经成功收藏，您记得及时学习喔！知识的价值在于分享，分享的意义在于力行！"];
            }
        }
        
        //        NSLog(@"TTT--json%@",json);
    } failure:^(NSError *error) {
        
    }];
    
    //    self.pushUrl = @"rtmp://192.168.30.69/live/movie";
    
    //        NSString *str = @"rtmp://video-center.alivecdn.com/test/aaa?vhost=live2.jianzhongbang.com";
    
    //        NSString *str = self.liveitem.push_path;
    //
    //        if (![str containsString:@"rtmp://"]) {
    //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"推流地址格式错误，无法直播" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //            [alert show];
    //            return;
    //        }
    //
    //        AlivcLiveViewController *live = [[AlivcLiveViewController alloc] initWithNibName:@"AlivcLiveViewController" bundle:nil url:str];
    //        live.isScreenHorizontal = NO;
    //        [self presentViewController:live animated:YES completion:nil];
}

#pragma mark - 点击 申请【购买】 按钮
- (void)ClickApplicationButton:(UIButton *)btn
{
    
    if ([self.liveitem.teacher.uid isEqualToString:[LoginVM getInstance].readLocal._id]) {
    
        [SVProgressHUD showInfoWithStatus:@"不能购买自己的课程"];
        return ;
    }
    
    if ([self.item.type isEqualToString:@"5"]) {
        
        NSDictionary *parameters = @{
                                     @"access_token":[LoginVM getInstance].readLocal.token,
                                     @"id":self.liveitem.aid
                                     };
        
        [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/Study/appointment"] parameters:parameters success:^(id json) {
        
        if ([json[@"state"] isEqual:@(0)]) {
//            [SVProgressHUD show];
        }else {
            [btn setTitle:@"进入课程" forState:UIControlStateNormal];
            
            
            self.playerVie.videoURL = [NSURL URLWithString:self.liveitem.play_path];
            
            if (self.isBackVideo) {
                self.playerVie.videoURL = [NSURL URLWithString:self.liveitem.play_paths[0]];
            }
            
            //    [self.topImageView removeFromSuperview];
            self.tableView.glh_height = GLScreenH -64;
            self.LiveEnterButton.hidden = YES;
            self.collectButton.hidden = YES;
            self.isAccessPlay = YES;
            btn.hidden = YES;
        }
        
            
        } failure:^(NSError *error) {
            
        }];
        
    }
    
    UIActionSheet *sheetView = [[UIActionSheet alloc]initWithTitle:@"请选择支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"微信",@"支付宝", nil];
    [sheetView showInView:[UIApplication sharedApplication].keyWindow];
    
    /** 
     
     SignUpPopView *popView = [SignUpPopView signUpPopView];
     popView.class_id = self.liveitem.aid;
     
     UIView *view = [UIView new];
     view.backgroundColor = [UIColor blackColor];
     view.alpha = 0.6;
     view.frame = self.view.frame;
     [self.view addSubview:view];
     
     popView.frame = CGRectMake(10 ,self.view.glh_height * 0.5 - (popView.glh_height * 0.5),GLScreenW - 20 ,200);
     
     if (self.liveitem.score || self.myInfo.score) {
     popView.payScore = self.liveitem.score;
     popView.stillScore = self.myInfo.score;
     [popView updateData];
     }
     
     [self.view addSubview:popView];
     
     popView.layer.cornerRadius = 5;
     popView.clipsToBounds = YES;
     
     __weak typeof(self) weakSelf = self;
     
     popView.clickCloseWindow = ^{
     [view removeFromSuperview];
     };
     
     popView.clickPayUp = ^{
     // 进行充值
     
     AppDelegate *delegate = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
     
     if (delegate.checkpay) {
     
     IntegralDetailVC *vc = [[UIStoryboard storyboardWithName:@"IntegralDetailVC" bundle:nil] instantiateInitialViewController];
     vc.bangbiCount = [LoginVM getInstance].users.money;
     [weakSelf.navigationController pushViewController:vc animated:YES];
     
     }else{
     
     }
     
     };
     
     popView.passToLive = ^{
     
     btn.hidden = YES;
     self.LiveEnterButton.hidden = NO;
     };
     
     */
    
    [self setupNote:btn];
    
}

- (void)setupNote:(UIButton *)btn
{
    
    
    //发布对象在特定时候发现通知中心我说了已经做了某事,你也要做某事了
    [[NSNotificationCenter defaultCenter] addObserverForName:@"IntegralDetailVCPay" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        GLLog(@"%@",note.userInfo);
        if ([note.userInfo.allKeys[0] hasPrefix:@"WX"]) {
            btn.hidden = YES;
            self.LiveEnterButton.hidden = NO;
        }else {
            payAlipayItem *item = [payAlipayItem mj_objectWithKeyValues:note.userInfo];
            
            if (item.resultStatus.integerValue == AlipayCallBackType9000) {
                btn.hidden = YES;
                self.LiveEnterButton.hidden = NO;
            }
        }
        
        //        [self popoverPresentationController];
        //do some think
    }];//可以拿到object(A)的数据
    
    
    
    
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        {
            NSLog(@"选择微信");
            
            [payForWechat payForWechat:self.liveitem.score type:@"3" class_id:self.liveitem.aid];
            
            break;
        }
            
        case 1:
        {
            NSLog(@"选择支付宝");
            
            [payForAlipay payForAlipay:self.liveitem.score type:@"3" class_id:self.liveitem.aid];
            
            break;
        }
            
        default:
            NSLog(@"取消");
            break;
    }
}

#pragma mark - 点击进入课程、观看直播 按钮
- (void)ClickEnterButton:(UIButton *)btn
{
    
    if ([btn.currentTitle isEqualToString:@"开始直播"]) {
        if ([self.liveitem.push_type isEqualToString:@"2"]) {
            [SVProgressHUD showInfoWithStatus:@"亲，您本次直播设置在电脑上执行。"];
            return;
        }
    }
    
//    XBLiveVideoShowVC *videoShowVC = [[XBLiveVideoShowVC alloc] init];
//    
//    [self presentViewController:videoShowVC animated:YES completion:nil ];
    
//    NSURL *url = [NSURL URLWithString:@"http://live2.jianzhongbang.com/test/aaa.flv"];
//    
//    [currentView SetMoiveSource:url];
    
    if ([[LoginVM getInstance].readLocal._id isEqualToString:self.liveitem.teacher.uid] && ([self.liveitem.type integerValue] == 3 || [self.liveitem.type integerValue] == 4)) {
        
        //XBLiveMobileVideoShowVC
        if ([self.liveitem.label isEqualToString:@"直播已结束"]) {
            if (self.liveitem.video_url && self.liveitem.video_url.length > 0) {
                XBLiveMobileVideoShowVC *xbLiveVC = [[XBLiveMobileVideoShowVC alloc]init];
                if ([self.liveitem.type isEqualToString:@"3"]) {
                    self.liveitem.type = @"1";
                }else{
                    self.liveitem.type = @"2";
                }
                
                xbLiveVC.liveitem = self.liveitem;
                xbLiveVC.playUrl = self.liveitem.video_url;
                [self.navigationController pushViewController:xbLiveVC animated:YES];

            }else{
                [SVProgressHUD showInfoWithStatus:@"播放地址不存在，无法播放！"];
            }

            return;
        }
        // 进入推流界面
        
        if (![self.liveitem.push_path containsString:@"rtmp://"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"推流地址格式错误，无法直播" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }

        AlivcLiveViewController *live = [[AlivcLiveViewController alloc] initWithNibName:@"AlivcLiveViewController" bundle:nil url:self.liveitem.push_path];
        
        live.liveitem = self.liveitem;
        live.teacher = self.liveitem.teacher;
        live.isScreenHorizontal = NO;
        live.question = [AskAnswerItem mj_objectArrayWithKeyValuesArray:self.liveitem.question];
        live.loveRankDataSource = self.reward_rankDataSource;
        live.class_id = self.liveitem.aid;
        live.join_list_user = self.liveitem.join_list;
        live.start_time = self.liveitem.start_time;
        live.end_time = self.liveitem.end_time;
        
        UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:live];
        
        [self presentViewController:navVC animated:YES completion:nil];

        return ;
    }
    
    //课时类型 1视频 2音频 3直播 4语音直播 5线下
    if ([self.liveitem.type isEqualToString:@"1"] || [self.liveitem.type isEqualToString:@"2"]){
    
        XBVideoAndVoiceVC *vc = [XBVideoAndVoiceVC new];
        if ([self.liveitem.type isEqualToString:@"1"]) {
            vc.videoOrVoice = YES;
        }
        vc.videoURL = [NSURL URLWithString:self.liveitem.play_path];
        
        if (self.isBackVideo) {
            vc.videoURL = [NSURL URLWithString:self.liveitem.play_paths[0]];
        }
        
        vc.teacher = self.liveitem.teacher;
        vc.join_list_user = self.liveitem.online_user;
        vc.class_id = self.liveitem.aid;
        
        self.liveitem.question = [CourseTimeEvaluateModel mj_objectArrayWithKeyValuesArray:self.liveitem.evaluate];
        vc.question = [[self.liveitem.question reverseObjectEnumerator] allObjects];
        vc.liveitem = self.liveitem;
        
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }else if ([self.liveitem.type isEqualToString:@"2"]){

        
        XBOffLiveVoiceShowVC *vc = [XBOffLiveVoiceShowVC new];

        vc.videoURL = [NSURL URLWithString:self.liveitem.play_path];

        if (self.isBackVideo) {
            vc.videoURL = [NSURL URLWithString:self.liveitem.play_paths[0]];
        }


        vc.teacher = self.liveitem.teacher;
        vc.join_list_user = self.liveitem.online_user;
        vc.class_id = self.liveitem.aid;

        self.liveitem.question = [AskAnswerItem mj_objectArrayWithKeyValuesArray:self.liveitem.question];

        vc.question = self.liveitem.question;
        
        vc.liveitem = self.liveitem;

        
        [self presentViewController:vc animated:YES completion:nil ];
        
        
    }else if ([self.liveitem.type isEqualToString:@"3"]){

//        XBLiveMobileVideoShowVC *mobilevideoShowVC = [[XBLiveMobileVideoShowVC alloc] init];
//        
//        mobilevideoShowVC.playUrl = self.liveitem.play_path;
//        mobilevideoShowVC.teacher = self.liveitem.teacher;
//        mobilevideoShowVC.join_list_user = self.liveitem.online_user;
//        mobilevideoShowVC.class_id = self.liveitem.aid;
//        
//        self.liveitem.question = [AskAnswerItem mj_objectArrayWithKeyValuesArray:self.liveitem.question];
//        
//        mobilevideoShowVC.question = self.liveitem.question;
//        
//        mobilevideoShowVC.liveitem = self.liveitem;
//        
//        UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:mobilevideoShowVC];
//        
//        [self presentViewController:navVC animated:YES completion:nil ];
        
        // 1是手机 2是电脑
        if ([self.liveitem.push_type isEqualToString:@"1"]) {
            
            XBLiveMobileVideoShowVC *mobilevideoShowVC = [[XBLiveMobileVideoShowVC alloc] init];
    
            mobilevideoShowVC.playUrl = self.liveitem.play_path;
            mobilevideoShowVC.teacher = self.liveitem.teacher;
            mobilevideoShowVC.join_list_user = self.liveitem.online_user;
            mobilevideoShowVC.class_id = self.liveitem.aid;
    
            self.liveitem.question = [AskAnswerItem mj_objectArrayWithKeyValuesArray:self.liveitem.question];
    
            mobilevideoShowVC.question = self.liveitem.question;
            mobilevideoShowVC.loveRankDataSource = self.reward_rankDataSource;
            mobilevideoShowVC.liveitem = self.liveitem;
            
            UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:mobilevideoShowVC];
            
            [self presentViewController:navVC animated:YES completion:nil ];
        }else if ([self.liveitem.push_type isEqualToString:@"2"]) {
            
            XBLiveComputerShowVC *computerShowVC = [XBLiveComputerShowVC new];
            
            computerShowVC.playUrl = self.liveitem.play_path;
            
            computerShowVC.liveitem = self.liveitem;
            
            self.liveitem.question = [AskAnswerItem mj_objectArrayWithKeyValuesArray:self.liveitem.question];
            computerShowVC.question = self.liveitem.question;
            computerShowVC.teacher = self.liveitem.teacher;
            computerShowVC.class_id = self.liveitem.aid;
            computerShowVC.loveRankDataSource = self.reward_rankDataSource;
            
            UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:computerShowVC];
            
            [self presentViewController:navVC animated:YES completion:nil ];
        }
        

    }else if ([self.liveitem.type isEqualToString:@"4"]) {
    
        XBLiveVideoShowVC *vc = [[XBLiveVideoShowVC alloc]init];
        
        vc.playUrl = self.liveitem.play_path;
        
        if (self.isBackVideo) {
            vc.playUrl = self.liveitem.play_paths[0];
            vc.isBackVideo = self.isBackVideo;
        }
        
        vc.teacher = self.liveitem.teacher;
        vc.join_list_user = self.liveitem.online_user;
        vc.class_id = self.liveitem.aid;
        
        
        self.liveitem.question = [AskAnswerItem mj_objectArrayWithKeyValuesArray:self.liveitem.question];
        
        vc.question = self.liveitem.question;
        vc.loveRankDataSource = self.reward_rankDataSource;
        
        vc.liveitem = self.liveitem;
        
        UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:vc];
        
        [self presentViewController:navVC animated:YES completion:nil ];

//        [self presentViewController:vc animated:YES completion:nil ];
        
        
    }else if ([self.liveitem.type isEqualToString:@"5"]) {
        
        if ([self.liveitem.is_appointment integerValue] == 1) {
            
            XBLiveMobileVideoShowVC *mobilevideoShowVC = [[XBLiveMobileVideoShowVC alloc] init];
            
            mobilevideoShowVC.playUrl = self.liveitem.play_path;
            
            if (self.isBackVideo) {
                mobilevideoShowVC.playUrl = self.liveitem.play_paths[0];
                mobilevideoShowVC.isBackVideo = self.isBackVideo;
            }
            
            mobilevideoShowVC.teacher = self.liveitem.teacher;
            mobilevideoShowVC.join_list_user = self.liveitem.online_user;
            mobilevideoShowVC.class_id = self.liveitem.aid;
            
            self.liveitem.question = [AskAnswerItem mj_objectArrayWithKeyValuesArray:self.liveitem.question];
            
            mobilevideoShowVC.question = self.liveitem.question;
            
            mobilevideoShowVC.liveitem = self.liveitem;
            
            [self presentViewController:mobilevideoShowVC animated:YES completion:nil ];
        }else{
            //预约体验
            NSDictionary *parameters = @{
                                         @"access_token":[LoginVM getInstance].readLocal.token,
                                         @"id":self.item.id,
                                         };
            
            [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"/Web/Study/appointment"] parameters:parameters success:^(id json) {
                
                if ([json[@"state"] isEqual:@(0)]) {
                    [SVProgressHUD showInfoWithStatus:json[@"info"]];
                    return ;
                }
                
                self.liveitem.is_appointment = @(1);
                [btn setTitle:@"进入体验" forState:UIControlStateNormal];
                [Toast makeShowCommen:@"" ShowHighlight:@"预约成功，敬请期待" HowLong:1];
                
                //        NSLog(@"TTT--json%@",json);
            } failure:^(NSError *error) {
                 [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",error]];
            }];

        }

    }
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (0 == section) {
//        return self.topView.frame.size.height;
//    }else{
//        return 44;
//    }
    
    
    if (self.isLive) {
        if (0 == section) {
            return self.topView.frame.size.height + self.midView.frame.size.height;
        }else {
            return 44;
        }
    }else {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (0 == state) {
            return self.midView.frame.size.height;
        }else if (1 == state){
            if (self.commentAry.count > indexPath.row) {
                CourseTimeEvaluateModel *model = [self.commentAry objectAtIndex:indexPath.row];
                return model.height;
            }
            
        }
        return 120;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.isLive) {
            return 0;
        }
        if (0 == state) {
            return 1;
        }else if (1 == state){
            if (self.commentAry.count > 0) {
                return self.commentAry.count;
            }else{
                return 0;
            }
        }else{
            /** 全部列表页面的空数据占位图片 */
//            notDataShowView *view;
//            
//            if (self.dataSource.count) {
//                if ([notDataShowView sharenotDataShowView].superview) {
//                    [[notDataShowView sharenotDataShowView] removeFromSuperview];
//                }
//            }else {
//                view = [notDataShowView sharenotDataShowView:tableView];
//                [tableView addSubview:view];
//                
//            }
            
            return self.dataSource.count;
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (0 == section) {
//        return self.topView;
//    }else{
//        return self.exchangeView;
    //}
    
    if (self.isLive) {
        if (0 == section) {
            if (!liveView) {
                liveView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.topView.frame.size.height + self.midView.frame.size.height)];
//                [self.topView setBackgroundColor:[UIColor yellowColor]];
                [liveView addSubview:self.topView];
//                [self.midView setBackgroundColor:[UIColor redColor]];
                [self.midView setFrame:CGRectMake(0, 155, ScreenWidth, self.midView.frame.size.height)];
                
                [liveView addSubview:self.midView];

            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                self.midView.gly_y = 155;
            });
            
            return liveView;
        }else {
            return self.exchangeView;
        }
    }else {
        return self.exchangeView;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (0 == state) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeftCellID"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LeftCellID"];
                [cell.contentView addSubview:self.midView];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if(1 == state){
            VideoCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoCommentCell"];
            if (!cell) {
                cell = [[VideoCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"VideoCommentCell"];
            }
            if (self.commentAry.count > indexPath.row) {
                cell.model = self.commentAry[indexPath.row];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.zanBtn addTarget:self action:@selector(zanBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                cell.zanBtn.tag = indexPath.row;
            }
            return cell;

        }else{
            VideoDetailXGKCCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoDetailXGKCCell"];
            if (!cell) {
                [tableView registerNib:[UINib nibWithNibName:@"VideoDetailXGKCCell" bundle:nil] forCellReuseIdentifier:@"VideoDetailXGKCCell"];
                cell = [tableView dequeueReusableCellWithIdentifier:@"VideoDetailXGKCCell"];
            }
            cell.item = self.dataSource[indexPath.row];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }
    return nil;
}

//给评论点赞
- (void)zanBtnAction:(UIButton *)btn{
    if (waitHit == 1) {
        return;
    }
    waitHit = 1;
    [[HttpManager shareManager] netStatus:^(AFNetworkReachabilityStatus status) {
        if(status == AFNetworkReachabilityStatusReachableViaWWAN || status ==AFNetworkReachabilityStatusReachableViaWiFi){
            ZanVideoModel *model = [[ZanVideoModel alloc]init];
            model.access_token = [[LoginVM getInstance] readLocal].token;
            CourseTimeEvaluateModel *evalModel = [self.commentAry objectAtIndex:btn.tag];
            model.eval_id = evalModel.eval_id;
            SendAndGetDataFromNet *sendAndget = [[SendAndGetDataFromNet alloc]init];
            __block SendAndGetDataFromNet *wsend = sendAndget;
            sendAndget.returnDict = ^(NSDictionary *dict){
                if (1 == [[dict objectForKey:@"state"] intValue]) {
                    VideoCommentCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag inSection:0]];
                    UIImageView *imageView = [cell.zanBtn.subviews objectAtIndex:0];
                    CGRect rect = imageView.frame;
                    if ([evalModel.is_like integerValue] == 1) {
                        evalModel.is_like = @"0";
                        evalModel.like_count = [NSString stringWithFormat:@"%ld",[evalModel.like_count integerValue] - 1];
                        [imageView setImage:[UIImage imageNamed:@"WDXQ_DZ"]];
                        [cell.zanCountLabel setText:evalModel.like_count];
                    }else{
                        evalModel.is_like = @"1";
                        evalModel.like_count = [NSString stringWithFormat:@"%ld",[evalModel.like_count integerValue] + 1];
                        [imageView setImage:[UIImage imageNamed:@"WDXQ_YDZ"]];
                        [cell.zanCountLabel setText:evalModel.like_count];
                    }
                    [UIView animateWithDuration:0.5 animations:^{
                        [imageView setFrame:CGRectMake(imageView.frame.origin.x - 4, imageView.frame.origin.y - 4, imageView.frame.size.width + 8, imageView.frame.size.height + 8)];
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.5 animations:^{
                            imageView.frame = rect;
                        } completion:^(BOOL finished) {
                            waitHit = 0;
                            //[SVProgressHUD showInfoWithStatus:dict[@"info"]];
                        }];
                    }];

                    
                    //
                }else{
                    if (self.requestCount > 0) {
                        [SVProgressHUD showInfoWithStatus:@"您的网络有问题,请重置"];
                        self.requestCount = 0;
                        return ;
                    }
                    [LoginVM getInstance].isGetToken = ^(){
                        model.access_token = [[LoginVM getInstance] readLocal].token;
                        [wsend dictFromNet:model WithRelativePath:@"Zan_Evaluate_CourseTime_URL"];
                        self.requestCount ++;
                    };
                    [[LoginVM getInstance] loginWithUserInfoForGetNewToken:[[LoginVM getInstance] readLocal]];
                }
            };
            [sendAndget dictFromNet:model WithRelativePath:@"Zan_Evaluate_CourseTime_URL"];
        }else{
            [SVProgressHUD showInfoWithStatus:@"您的网络有问题,请重置"];
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (2 == state) {
        XBLiveListItem *item = self.dataSource[indexPath.row];
        
        LiveVideoViewController *vc = [LiveVideoViewController new];
        vc.item = (CourseTimeModel *)item;
        //    vc.item.id = item.aid;
        
        vc.isBackVideo = YES;
        GLLog(@"navigationController")
        self.navigationController.navigationBarHidden = YES;
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }

}

//分隔线左对齐
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }

    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!self.chatKeyBoard.hidden) {
        [self.chatKeyBoard keyboardDown];
    }
    if (scrollView.contentOffset.y <= 45) {
        self.tableView.bounces = NO;
    }else{
        self.tableView.bounces = YES;
    }
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    
//}
//
//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
//{
//    
//    NSLog(@"%f",scrollView.contentOffset.x);
//    
//    
//}

#pragma mark - 点击详情按钮
- (void)clickdetailB:(UIButton *)btn
{
    if (![self.liveitem.is_pay isEqualToNumber:@(1)] && ![LoginVM getInstance].users.vip) {
        self.buyButton.hidden = NO;
        self.collectButton.hidden = NO;
    }
    
    if (!self.chatKeyBoard.hidden) {
        [self.chatKeyBoard keyboardDown];
    }
    
    self.chatKeyBoard.hidden = YES;
    state = 0;
    
    if (self.isLive) {
        [UIView animateWithDuration:0.3 animations:^{
            
            [self.huadongView0 setFrame:CGRectMake(40, 40, GLScreenW / 2 - 80, 3)];
        } completion:^(BOOL finished) {
            [self.tableView reloadData];
        }];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            
            [self.huadongView0 setFrame:CGRectMake((GLScreenW / 3 - 80) / 2, 40, 80, 3)];
        } completion:^(BOOL finished) {
            [self.tableView reloadData];
        }];
    }
    
//    [UIView animateWithDuration:0.3 animations:^{
//        
//        [self.huadongView0 setFrame:CGRectMake((GLScreenW / 3 - 80) / 2, 40, 80, 3)];
//    } completion:^(BOOL finished) {
//        [self.tableView reloadData];
//    }];
    
}

#pragma mark - 点击评论按钮
- (void)clickCommentB:(UIButton *)btn
{
    
    if (!self.chatKeyBoard.hidden) {
        [self.chatKeyBoard keyboardDown];
    }
    
    self.buyButton.hidden = YES;
    self.collectButton.hidden = YES;
    
    if (!self.chatKeyBoard) {
        self.chatKeyBoard = [ChatKeyBoard keyBoardWithNavgationBarTranslucent:YES];
        self.chatKeyBoard.delegate = self;
        self.chatKeyBoard.dataSource = self;
        self.chatKeyBoard.placeHolder = @"说点什么";
        self.chatKeyBoard.allowMore = NO;
        self.chatKeyBoard.allowVoice = NO;
        self.chatKeyBoard.allowFace = NO;
        self.chatKeyBoard.hidden = YES;
        [self.view addSubview:self.chatKeyBoard];
    }
    self.chatKeyBoard.hidden = NO;
    self.chatKeyBoard.alpha = 0;
    state = 1;
    [UIView animateWithDuration:0.3 animations:^{
        [self.huadongView0 setFrame:CGRectMake((GLScreenW / 3 - 80) / 2 + GLScreenW / 3, 40, 80, 3)];
        self.chatKeyBoard.alpha = 1;
    } completion:^(BOOL finished) {
        [self.tableView reloadData];
    }];
    
}

#pragma mark - 点击相关课程按钮
- (void)clickxgkc:(UIButton *)btn
{
    if (![self.liveitem.is_pay isEqualToNumber:@(1)] && ![LoginVM getInstance].users.vip) {
        self.buyButton.hidden = NO;
        self.collectButton.hidden = NO;
    }
    self.chatKeyBoard.hidden = YES;
    state = 2;
    
    if (self.isLive) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.huadongView0 setFrame:CGRectMake(40 + GLScreenW / 2, 40, GLScreenW / 2 -80, 3)];
        } completion:^(BOOL finished) {
            [self.tableView reloadData];
        }];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            [self.huadongView0 setFrame:CGRectMake((GLScreenW / 3 - 80) / 2 + GLScreenW / 3 * 2, 40, 80, 3)];
        } completion:^(BOOL finished) {
            [self.tableView reloadData];
        }];
    }
    
//    [UIView animateWithDuration:0.3 animations:^{
//        [self.huadongView0 setFrame:CGRectMake((GLScreenW / 3 - 80) / 2 + GLScreenW / 3 * 2, 40, 80, 3)];
//    } completion:^(BOOL finished) {
//        [self.tableView reloadData];
//    }];

}

- (void)addPlayerInfo
{
    self.playerVie.liveitem = self.liveitem;
    
    // 收藏状态
    if (self.liveitem.is_zan.integerValue == 1) {
        self.playerVie.panel.collectBtn.selected = YES;
    }
    
    // 收藏功能
    [self.playerVie.panel.collectBtn addTarget:self action:@selector(ClickCommentButton2:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.isAccessPlay) {
        
        self.playerVie.videoURL = [NSURL URLWithString:self.liveitem.play_path];
        
        if (self.isBackVideo) {
            self.playerVie.videoURL = [NSURL URLWithString:self.liveitem.play_paths[0]];
        }
        
    }
    
    // 判断 如果是m3u8 直播录下的视频 不缓存
    if ([self.playerVie.videoURL.absoluteString hasSuffix:@"m3u8"]) {
        self.playerVie.panel.downLoadBtn.selected = YES;
    }
    
    
    /** 音频插入 占位图片 */
    
    UIView *view = [UIView new];
    
    //    view.backgroundColor = [UIColor redColor];
    [self.playerVie insertSubview:view atIndex:0];
    view.backgroundColor = [UIColor blackColor];
    view.backgroundColor = [UIColor blackColor];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.playerVie);
    }];
    
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"视频占位图片"]];
    imageV.image = nil;
    self.BGimageV = imageV;
    if (self.videoOrVoice) {
        
    }else {
        [view addSubview:imageV];
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
        }];
        [self setImageToView:self.liveitem.thumb2 SetImageV:imageV InView:view OrSize:view.gls_size];
    }
    
    //    imageV.frame = view.frame;
    
    
    //    [imageV sd_setImageWithURL:[NSURL URLWithString:[AddHostToLoadPIC AddHostToLoadPICWithString:self.liveitem.thumb2]] placeholderImage:[UIImage imageNamed:@"VideoPlaceholder"]];
    
    
    //self.playerVie.panel.backBtn.hidden = YES;
    
    if (!self.videoOrVoice) {
        self.playerVie.panel.fullScreenBtn.hidden = YES;
    }

    [self.view bringSubviewToFront:self.playerVie];
}

- (void)setupPlayer
{
    
    UIView *topBlackView = [UIView new];
    [self.view addSubview:topBlackView];
    //        topBlackView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"2196f3"];
    
    topBlackView.backgroundColor = [UIColor blackColor];
    
    topBlackView.frame = CGRectMake(0, 0, GLScreenW, 20);
    
    self.playerVie = [[ZFPlayerView alloc]init];
    
    [self.view addSubview:self.playerVie];
    
    self.playerVie.backgroundColor = [UIColor blackColor];
    
    if ([self.item.type isEqualToString:@"1"]) {
        self.videoOrVoice = YES;
    }
    
    if (self.videoOrVoice) {
        //            _playerVie = [[ZFPlayerView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth / 16 * 9)];
        
        [self.playerVie mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(20);
            make.left.right.equalTo(self.view);
            // 注意此处，宽高比16：9优先级比1000低就行，在因为iPhone 4S宽高比不是16：9
            make.height.equalTo(_playerVie.mas_width).multipliedBy(9.0f/16.0f).with.priority(750);
        }];
    }else{
        //            _playerVie = [[ZFPlayerView alloc]initWithFrame:CGRectMake(0, 0, self.view.glw_width, 155)];
        
        [self.playerVie mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(20);
            make.left.right.equalTo(self.view);
            // 注意此处，宽高比16：9优先级比1000低就行，在因为iPhone 4S宽高比不是16：9
            make.height.equalTo(@(155));
        }];
    }
    
    
//    if (self.playerVie.videoURL) {
//        [self.backButton removeFromSuperview];
//    }
    
    // （可选设置）可以设置视频的填充模式，内部设置默认（ZFPlayerLayerGravityResizeAspect：等比例填充，直到一个维度到达区域边界）
    self.playerVie.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
    // 打开断点下载功能（默认没有这个功能）
    self.playerVie.hasDownload = YES;
//    self.playerVie.panel.backBtn.hidden = YES;
    
    [self.playerVie.panel.backBtn addTarget:self action:@selector(BackActive:) forControlEvents:UIControlEventTouchUpInside];
    
    // 如果想从xx秒开始播放视频
    //self.playerView.seekTime = 15;
    //__weak typeof(self) weakSelf = self;
    //    self.playerVie.goBackBlock = ^{
    //        [weakSelf dismissViewControllerAnimated:YES completion:^{
    //            [weakSelf.playerVie cancelAutoFadeOutControlBar];
    //            [weakSelf.playerVie pause];
    //            [weakSelf.noticeview removeFromSuperview];
    //        }];
    //    };
    
}

- (void)setImageToView:(NSString *)imagePath SetImageV:(UIImageView *)Imageview InView:(UIView *)inView OrSize:(CGSize)size
{
    NSString *path = [[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:imagePath];
    dispatch_async(dispatch_queue_create("queue_content", nil), ^{
        UIImage *image = [LocalDataRW getImageWithDirectory:Directory_XB RetalivePath:path];
        
        __block typeof (image) wimage = image;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (inView) {
                wimage = [ZJBHelp handleImage:wimage withSize:inView.frame.size withFromStudy:YES];
                [Imageview setImage:wimage];
            }else{
                wimage = [ZJBHelp handleImage:wimage withSize:size withFromStudy:YES];
                [Imageview setImage:wimage];
            }
        });
    });
    
}

- (void)dealloc
{
    NSLog(@"%@释放了",self.class);
    [self.playerVie pause];
    [self.playerVie cancelAutoFadeOutControlBar];
//    [self.commentAry removeAllObjects];
//    self.commentAry = nil;
    [self.playerVie resetPlayer];
    [web loadHTMLString:@"" baseURL:nil];
    [web stopLoading];
    [web setDelegate:nil];
    [web removeFromSuperview];
    web = nil;
    [[NSURLCache sharedURLCache]removeAllCachedResponses];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    
    if (self.playerVie.panel.startBtn.selected) {
        [self.playerVie startAction:self.playerVie.panel.startBtn];
    }
    
    [self.playerVie pause];
    
//    [self.playerVie cancelAutoFadeOutControlBar];
    if (!gotoVIPVC) {
//        [self.playerVie pause];
//        [self.playerVie cancelAutoFadeOutControlBar];
        //    [self.commentAry removeAllObjects];
        //    self.commentAry = nil;
//        [self.playerVie resetPlayer];
    }else{
        gotoVIPVC = YES;
    }
    
}

- (BOOL)shouldAutorotate
{
    return !self.playerVie.panel.fullScreenBtn.hidden;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}


#pragma mark - 旋转
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
    /** 高林修改了 旋转屏幕后 9：16 view 没有返回按钮 */
    if (self.playerVie.isFullScreen == YES) {
        // 这里 YES / NO  是反的 是转换前
        self.playerVie.panel.backBtn.hidden = NO;
    }else {
        self.playerVie.panel.backBtn.hidden = NO;
    }
    
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        self.view.backgroundColor = [UIColor whiteColor];
        //if use Masonry,Please open this annotation
        
        [self.playerVie mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(20);
        }];
        
    }else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        self.view.backgroundColor = [UIColor blackColor];
        //if use Masonry,Please open this annotation
        
        [self.playerVie mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(0);
        }];
    }
}

- (void)BackActive:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    GLLog(@"123321%d",self.playerVie.panel.fullScreenBtn.selected)
    GLLog(@"123321%d",self.playerVie.panel.fullScreenBtn.selected)
    if (self.playerVie.panel.fullScreenBtn.selected) {
        
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
//    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 发送文本
- (void)chatKeyBoardSendText:(NSString *)text
{
    
    AppDelegate *appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (!appD.vip) {
        [UIView bch_showWithTitle:@"请加入建众帮" message:@"成为建众帮会员才能评论！" buttonTitles:@[@"取消",@"确定"] callback:^(id sender, NSUInteger buttonIndex) {
            if (1 == buttonIndex) {
                //  AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                
                // if (appDelegate.checkpay) {
                gotoVIPVC = YES;
                ApplyVipVC *applyVipVC = [[ApplyVipVC alloc]init];
                [self.navigationController pushViewController:applyVipVC animated:YES];
                //  }
            }
        }];
        return;
    };
    
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
    model.class_id = self.liveitem.aid;
    model.eval_id = @"";
    model.content = text;
    SendAndGetDataFromNet *send = [[SendAndGetDataFromNet alloc]init];
    __block SendAndGetDataFromNet *wsend = send;
    __weak typeof (self) wself = self;
    send.returnDict = ^(NSDictionary *dict){
        if (!dict) {
            [Toast makeShowCommen:@"抱歉，您的网络出现故障，" ShowHighlight:@"评论失败" HowLong:1.5];
        }else{
            if (1 == [[dict objectForKey:@"state"] intValue]) {
                wself.requestCount = 0;
                isSendComment = YES;
                [wself DownLoadData];
                [SVProgressHUD showInfoWithStatus:dict[@"info"]];
            }else{
                if (wself.requestCount > 1) {
                    return ;
                }
                [LoginVM getInstance].isGetToken = ^(){
                    model.access_token = [[LoginVM getInstance] readLocal].token;
                    wself.requestCount ++;
                    [wsend dictFromNet:model WithRelativePath:@"Send_Evaluate_CourseTime_URL"];
                };
                [[LoginVM getInstance] loginWithUserInfoForGetNewToken:[[LoginVM getInstance] readLocal]];
            }
        }
    };
    [send dictFromNet:model WithRelativePath:@"Send_Evaluate_CourseTime_URL"];
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
