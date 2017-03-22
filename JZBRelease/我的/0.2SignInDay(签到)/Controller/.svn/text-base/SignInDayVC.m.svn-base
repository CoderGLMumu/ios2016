//
//  SignInDayVC.m
//  JZBRelease
//
//  Created by zjapple on 16/8/19.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "SignInDayVC.h"
#import "CalendarView.h"
#import "CalendarView.h"
#import "DataBaseHelperSecond.h"
#import "SendAndGetDataFromNet.h"

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface SignInDayVC ()
@property (weak, nonatomic) IBOutlet UIView *QDCalendarView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *QDCalendarViewConstraintHeight;

@property (strong, nonatomic) CalendarView *calendarView;
@property (nonatomic, strong) NSDate *date;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIView *QSDayByDayView;
@property (strong, nonatomic) IBOutlet UIScrollView *ScrollView;

/** backgroupImageView */
@property (nonatomic, strong) UIImageView *backgroupImageView;
@property (nonatomic, strong) UIImageView *progressImageView;
@property (nonatomic, strong) UIImageView *progressImageViewDT;
@end

@implementation SignInDayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    /** top */
    [self setUpUserInfo];
    /** 进度 */
    [self setUpQSDayByDayView];
    /** 日历 */
    [self setupCalendarView];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.ScrollView.contentSize = CGSizeMake(375, 2000);
}

- (void)setUpUserInfo
{
    Users *users = [[Users alloc]init];
    users.uid = [[LoginVM getInstance] readLocal]._id;
    users = (Users *)[[DataBaseHelperSecond getInstance] getModelFromTabel:users];

//    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[AddHostToLoadPIC AddHostToLoadPICWithString:users.avatar]] placeholderImage:[UIImage imageNamed:@"HX_img_head"]];
    
    [LocalDataRW getImageWithDirectory:Directory_WD RetalivePath:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:users.avatar] WithContainerImageView:self.avatarImageView];
    
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.glw_width * 0.5;
    self.avatarImageView.clipsToBounds = YES;
}

- (void)setUpQSDayByDayView
{
    self.backgroupImageView = [[UIImageView alloc]init];
    self.backgroupImageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.QSDayByDayView.glh_height);
    self.backgroupImageView.image = [UIImage imageNamed:@"grzx_qiandao_progressBG"];
    [self.QSDayByDayView addSubview:self.backgroupImageView];
    
//    [[UIImageView alloc]initWithImage:[UIImage originImage:[UIImage imageNamed:@"grzx_qiandao_progressBG"] scaleToSize:self.backgroupImageView.gls_size]];
//    [self.QSDayByDayView addSubview:self.backgroupImageView];
//    backgroupImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    if (1) {
        self.progressImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"QD_progress_5"]];
        self.progressImageView.frame = CGRectMake(31, self.QSDayByDayView.glh_height * 0.5 - 16, self.progressImageView.glw_width * 0.5, self.progressImageView.glh_height * 0.5);
        [self.QSDayByDayView addSubview:self.progressImageView];
        
        self.progressImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.progressImageViewDT = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"QD_progress_15"]];
        
        self.progressImageViewDT.contentMode = UIViewContentModeLeft;
        
        self.progressImageViewDT.frame = CGRectMake(31, self.QSDayByDayView.glh_height * 0.5 - 16, self.progressImageView.glw_width * 0.5, self.progressImageView.glh_height * 0.5);
        [self.QSDayByDayView addSubview:self.progressImageViewDT];
        
        self.progressImageViewDT.hidden = YES;
        
        // 加载所有的动画图片
        NSMutableArray *images = [NSMutableArray array];
        
        NSString *filenamePrefix = @"QD_progress_";
        
        for (int i = 6; i<=15; i++) {
            NSString *filename = [NSString stringWithFormat:@"%@%d", filenamePrefix, i];
//            NSString *file = [[NSBundle mainBundle] pathForResource:filename ofType:@"png"];
            UIImage *image = [UIImage imageNamed:filename];
            [images addObject:image];
        }
        // 设置动画图片
        self.progressImageViewDT.animationImages = images;
        self.progressImageViewDT.animationRepeatCount = 1;
        self.progressImageViewDT.animationDuration = 1;
    }
    
}

- (void)setupCalendarView {
    [self DownLoadMonthlyDayData];
    //    self.calendarView.isShowOnlyMonthDays = NO;
//    self.calendarView.date = [NSDate dateWithTimeIntervalSinceNow:(24*60*60 * 50)];
    
    
//    NSLog(@"gaolinaaaaaaa%@",[NSDate dateWithTimeIntervalSince1970:(1471418471)]);
    
    
    
//    WS(weakSelf)
//    self.calendarView.nextMonthBlock = ^(){
//        [weakSelf setupNextMonth];
//    };
//    self.calendarView.lastMonthBlock = ^(){
//        [weakSelf setupLastMonth];
//    };
}

- (void)DownLoadMonthlyDayData
{
    
//    接口：/Web/user/get_sign
//    参数：access_token
//    返回：
//access_token:
//    MTQ3MjAzNjk3M5zer6WLeqyZtLinysV3nKiMh3xnsoyElH2eddyIuJyYhN7cnouPy9rGvXrNxGFppJSdfGezsnzYfXxkoA
//time:
//    (空值：本月，2016-10-5：10月数据)
    
    UserInfo *userInfo = [[LoginVM getInstance]readLocal];
    
    NSDictionary *parameters = @{
                                 @"access_token":userInfo.token,
                                 
                                 };
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/user/get_sign"] parameters:parameters success:^(id json) {
        
        if (![json[@"state"] isEqual:@(1)]) return ;
        
        NSArray *daysData = json[@"data"];
        NSMutableArray *arrM = [NSMutableArray array];
        
        if (daysData.count) {
            
            for (NSDictionary *dictT in daysData) {
                NSString *time_str = dictT[@"time"];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:(time_str.doubleValue)];
                NSCalendar *calendar1 = [NSCalendar currentCalendar];//日历
                NSCalendarUnit type = NSCalendarUnitYear |
                NSCalendarUnitMonth |
                NSCalendarUnitDay |
                NSCalendarUnitHour |
                NSCalendarUnitMinute |
                NSCalendarUnitSecond;
                NSDateComponents *cmps = [calendar1 components:type fromDate:date];
//                NSLog(@"gaolin2333ttt%ld",(long)cmps.day);
                [arrM addObject:[NSString stringWithFormat:@"%ld",(long)cmps.day]];
            }
            
            
            self.calendarView = [[CalendarView alloc] initWithFrame:CGRectMake(14, 0, [UIScreen mainScreen].bounds.size.width - 28, 272)];
            
        }
        //日期状态
        self.calendarView.allDaysArr = [NSArray arrayWithArray:arrM];
        self.calendarView.allDaysColor = [UIColor clearColor];
        self.calendarView.allDaysImage = [UIImage imageNamed:@"grzx_qiandao_select"];
        //    self.calendarView.partDaysArr = [NSArray arrayWithObjects:@"1", @"2", @"26", @"12",@"15", @"19",nil];
        self.calendarView.date = [NSDate date];
        self.calendarView.calendarBlock =  ^(NSInteger day, NSInteger month, NSInteger year){
            NSLog(@"%li-%li-%li", (long)year,(long)month,(long)day);
        };

        self.QDCalendarViewConstraintHeight.constant = self.calendarView.monthlyLastDay.glb_bottom;
        
        [self.QDCalendarView addSubview:self.calendarView];
        
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)ClickQianDaoButton:(UIButton *)sender {
    
    self.progressImageViewDT.hidden = NO;
    [self.progressImageViewDT startAnimating];
//    http://192.168.10.154/bang/index.php/Web/user/get_sign
    UserInfo *userInfo = [[LoginVM getInstance]readLocal];
    
    NSDictionary *parameters = @{
                                 @"access_token":userInfo.token,
                                 
                                 };

    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/user/sign"] parameters:parameters success:^(id json) {
        
        if (![json[@"state"] isEqual:@(1)]) {
            [SVProgressHUD showInfoWithStatus:@"已经签到过了"];
        }else {
            [SVProgressHUD showInfoWithStatus:@"签到成功"];
        }
        
        /** 日历 */
        [self setupCalendarView];
        
    } failure:^(NSError *error) {
        
    }];
}


//- (void)setupNextMonth {
//    [self.calendarView removeFromSuperview];
//    self.calendarView = [[CalendarView alloc] initWithFrame:CGRectMake(0, 0, self.QDCalendarView.glw_width - 20, self.QDCalendarView.glh_height - 20)];
//    [self.QDCalendarView addSubview:self.calendarView];
//    self.calendarView.allDaysArr = [NSArray arrayWithObjects:  @"17",  @"21", @"25",  @"30", nil];
//    self.calendarView.partDaysArr = [NSArray arrayWithObjects:@"1", @"2", @"26", @"19",nil];
//    self.date = [self.calendarView nextMonth:self.date];
//    [self.calendarView createCalendarViewWith:self.date];
//    self.calendarView.calendarBlock =  ^(NSInteger day, NSInteger month, NSInteger year){
//        NSLog(@"%li-%li-%li", (long)year,(long)month,(long)day);
//    };
//    WS(weakSelf)
//    self.calendarView.nextMonthBlock = ^(){
//        [weakSelf setupNextMonth];
//    };
//    self.calendarView.lastMonthBlock = ^(){
//        [weakSelf setupLastMonth];
//    };
//}
//
//- (void)setupLastMonth {
//    [self.calendarView removeFromSuperview];
//    self.calendarView = [[CalendarView alloc] initWithFrame:CGRectMake(0, 0, self.QDCalendarView.glw_width - 20, self.QDCalendarView.glh_height - 20)];
//    [self.QDCalendarView addSubview:self.calendarView];
//    self.calendarView.allDaysArr = [NSArray arrayWithObjects: @"5", @"6", @"8", @"9", @"11", @"16", @"17", @"21", @"25",  @"30", nil];
//    self.calendarView.partDaysArr = [NSArray arrayWithObjects:@"1", @"2", @"26", @"29", @"12",@"15", @"18", @"19",nil];
//    self.date = [self.calendarView lastMonth:self.date];
//    [self.calendarView createCalendarViewWith:self.date];
//    self.calendarView.calendarBlock =  ^(NSInteger day, NSInteger month, NSInteger year){
//        NSLog(@"%li-%li-%li", (long)year,(long)month,(long)day);
//    };
//    WS(weakSelf)
//    self.calendarView.lastMonthBlock = ^(){
//        [weakSelf setupLastMonth];
//    };
//    self.calendarView.nextMonthBlock = ^(){
//        [weakSelf setupNextMonth];
//    };
//}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
//    self.progressImageView.center = CGPointMake(self.QSDayByDayView.glcx_centerX, self.QSDayByDayView.glh_height * 0.5);
//    
////    self.progressImageView.glcx_centerX = self.QSDayByDayView.glcx_centerX;
////    self.progressImageView.glcy_centerY = self.QSDayByDayView.glh_height * 0.5;
    
}

@end
