//
//  SixWdRootVC.m
//  JZBRelease
//
//  Created by Apple on 16/11/3.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "SixWdRootVC.h"

#import "WDPushCell.h"
#import "WDQDCell.h"
#import "WDPainCell.h"

#import "DataBaseHelperSecond.h"

#import "FansListVC.h"
#import "AttentionListVC.h"
#import "AppDelegate.h"
#import "IntegralDetailVC.h"

#import "UserQSItem.h"
#import "WDPersonInfoVC.h"
#import "FocusContentVC.h"
#import "BQDynamicVC.h"
#import "PerActivityVC.h"
#import "PerAskAndAnswerVC.h"
#import "MyCourseVC.h"

#import "ApplyVipVC.h"
#import "MYSettingVC.h"
#import "BQRMRootVC.h"

#import "BCH_Alert.h"
#import "PainTableViewCell.h"

#import "LWImageBrowserModel.h"
#import "LWImageBrowser.h"

#import "AppDelegate.h"

#import "CommChanceVC.h"

@interface SixWdRootVC ()<UITableViewDelegate,UITableViewDataSource>{
    CGFloat cellHeight;
    UILabel *label;
    NSInteger count;
}

/** fengexianbot */
@property (nonatomic, weak) UIView *fengexianbot;

@property (nonatomic, strong) UIView *painView;
@property (nonatomic, strong) UILabel *painLabel;

@property (weak, nonatomic) IBOutlet UILabel *LeftContributionName;
@property (weak, nonatomic) IBOutlet UILabel *contribution_this_levelNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contribution_next_levelNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *type_nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobLabel;
//@property (weak, nonatomic) IBOutlet UILabel *painLabel;
//@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
//@property (weak, nonatomic) IBOutlet UILabel *panNameLabel;


@property (weak, nonatomic) IBOutlet UIImageView *userAvaImageView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansLabel;
@property (weak, nonatomic) IBOutlet UILabel *focusLabel;
/** 贡献值 */
@property (weak, nonatomic) IBOutlet UILabel *contributionLabel;
//@property (weak, nonatomic) IBOutlet UIButton *focusButton;
//@property (weak, nonatomic) IBOutlet UIButton *fansButton;
//@property (weak, nonatomic) IBOutlet UIButton *MoneyButton;
//@property (weak, nonatomic) IBOutlet UIButton *contributionButton;

@property (weak, nonatomic) IBOutlet UILabel *zntLabel;
@property (weak, nonatomic) IBOutlet UIView *type_nameLView;
@property (weak, nonatomic) IBOutlet UIView *compLView;

@property (weak, nonatomic) IBOutlet UIImageView *vipIconImageV;

/** userInfo */
@property (nonatomic, strong) UserInfo *userInfo;
/** user */
@property (nonatomic, strong) Users *users;
@property(nonatomic, assign) BOOL isZLT;
/** panNameS */
@property (nonatomic, strong) NSString *panNameS;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (strong, nonatomic)  NSString *contQS_str;
@property (weak, nonatomic) IBOutlet UIButton *grjjButton;
@property (weak, nonatomic) IBOutlet UIButton *cyhtButton;
@property (weak, nonatomic) IBOutlet UIButton *gznrButton;
@property (weak, nonatomic) IBOutlet UIButton *sjnrButton;

/** startLock */
@property (nonatomic, assign) BOOL startLock;
@property (weak, nonatomic) IBOutlet UILabel *bangBiNameLabel;

@end

@implementation SixWdRootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /***********************************************/
    /** 这里是app启动跳转首页 【跳的学吧Index0】*/
//    if (!self.startLock) {
//        [self.tabBarController setSelectedIndex:0];
//        self.startLock = YES;
//        
//        //        [SVProgressHUD showSuccessWithStatus:@"登陆成功，增加积分 +2"];
////        [Toast makeShowCommen:@"欢迎," ShowHighlight:@"登陆成功" HowLong:0.8];
//    }
    /***********************************************/
    
    self.userAvaImageView.layer.cornerRadius = self.userAvaImageView.glw_width * 0.5;
    self.userAvaImageView.clipsToBounds = YES;
    self.userAvaImageView.layer.borderWidth = 2;
    self.userAvaImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userAvaImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapUserAvaImageView)];
    [self.userAvaImageView addGestureRecognizer:tap];
    
    [self setupTableView];
    
    [self setupSubView];
    
    self.nickNameLabel.text = @"正在加载数据";
    
    /** 会刷新数据 */
    [self loadDBAndDown];
    
    [[NSNotificationCenter defaultCenter]addObserverForName:@"putUserLocation" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        AppDelegate *appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        [self.addressButton setTitle:appD.userCurrentLocal forState:UIControlStateNormal];
    }];
    AppDelegate *appD = (AppDelegate*)[UIApplication sharedApplication].delegate;

   // if (appD.checkpay) {
        self.bangBiNameLabel.text = @"帮币";
//    }else {
//        self.bangBiNameLabel.text = @"店员";
//    }

}

- (void)setupSubView
{
//    [self.grjjButton setTitleEdgeInsets:UIEdgeInsetsMake(30, 0, 0, 1)];
//    [self.grjjButton setImageEdgeInsets:UIEdgeInsetsMake(0, (GLScreenW * 0.25 * 0.5 -28), 30, 0)];
//    
//    [self.cyhtButton setTitleEdgeInsets:UIEdgeInsetsMake(30, 0, 0, 1)];
//    [self.cyhtButton setImageEdgeInsets:UIEdgeInsetsMake(0, (GLScreenW * 0.25 * 0.5 -27), 30, 0)];
//    
//    [self.gznrButton setTitleEdgeInsets:UIEdgeInsetsMake(30, 0, 0, 1)];
//    [self.gznrButton setImageEdgeInsets:UIEdgeInsetsMake(0, (GLScreenW * 0.25 * 0.5 -26), 30, 0)];
//    
//    [self.sjnrButton setTitleEdgeInsets:UIEdgeInsetsMake(30, 0, 0, 1)];
//    [self.sjnrButton setImageEdgeInsets:UIEdgeInsetsMake(0, (GLScreenW * 0.25 * 0.5 -25), 30, 0)];
    
    self.type_nameLView.hidden = YES;
    self.compLView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tabBarController.tabBar setHidden:NO];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.view.frame = CGRectMake(0, 0, GLScreenW, GLScreenH);
    
    self.tabBarController.tabBar.gly_y = GLScreenH - 49;
    self.tabBarController.tabBar.hidden = NO;
    
    /** 会刷新数据 */
    [self loadDBAndDown];
}

- (void)setupTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //有数据才有分割线
    self.tableView.tableFooterView = [[UIImageView alloc]init];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f8f8f8"];
    //    tableView.backgroundColor = [UIColor redColor];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    
//    UIView *fengexianbot = [UIView new];
//    self.fengexianbot = fengexianbot;
//    [self.view addSubview:fengexianbot];
//    fengexianbot.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"dfdfdf"];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
//    GLLog(@"self.tableView.glh_height%f",self.tableView.glh_height);
    self.fengexianbot.frame = CGRectMake(0,self.tableView.glh_height - 11, GLScreenW, 1);
}

- (void)loadDBAndDown
{
    /** 缓存数据库 */
    DataBaseHelperSecond *db = [DataBaseHelperSecond getInstance];
    [db initDataBaseDB];
    
    self.userInfo = [[LoginVM getInstance]readLocal];
    
    __block Users *model = [Users new];
    
    model.uid = self.userInfo._id;
    model = (Users *)[db getModelFromTabel:model];
    
    self.users = model;
    
    AppDelegate *appD = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (appD.user.nickname) {
        self.users = appD.user;
        [self setupSubViewData];
    }
    
    //    [self setupSubViewData];
    if (!self.userInfo) {
        return;
    }
    NSDictionary *parameters = @{
                                 @"access_token":self.userInfo.token,
                                 @"uid":@"0"
                                 };
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/user/info"] parameters:parameters success:^(id json) {
        
        model = [Users mj_objectWithKeyValues:json[@"data"]];
        
        self.users = model;
        
        if ([db isExistInTable:model]) {
            [db delteModelFromTabel:model];
            [db insertModelToTabel:model];
        }else{
            if ([db createTabel:model]) {
                [db insertModelToTabel:model];
            };
        }
        
        [self setupSubViewData];
        //            NSLog(@"TTT--json%@",json);
        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - 刷新数据
- (void)setupSubViewData
{

    if ([self.users.type isEqualToString:@"2"]) {
        self.isZLT = YES;
    }else{
        //        self.lastButton = self.wdkcButton;
    }
    
    if (self.isZLT) {
        self.panNameS = @"擅长领域：";
    }else{
        self.panNameS = @"经营痛点：";
    }
    [self.painLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"212121"]];

//    NSString *imagePath = [[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:self.users.avatar];
//    [self.userAvaImageView setImage:[LocalDataRW getImageWithDirectory:Directory_RM RetalivePath:imagePath]];
    
    [self.userAvaImageView sd_setImageWithURL:[NSURL URLWithString:[LocalDataRW getImageAllStr:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:self.users.avatar]]] placeholderImage:[UIImage imageNamed:@"ZCCG_TX"]];
    
    self.scoreLabel.text = self.users.money;
    self.fansLabel.text = self.users.fans_count;
    self.focusLabel.text = self.users.fllow_count;
    
    if (self.users.nickname) {
        self.nickNameLabel.text = self.users.nickname;
    }else {
        self.nickNameLabel.text = @"正在加载数据";
    }
    
    if (self.users.nickname) {
        self.type_nameLView.hidden = NO;
    }else {
        self.type_nameLView.hidden = YES;
    }
    
    if (self.users.contribution == nil || [self.users.contribution isEqualToString:@"nil"]) {
        self.users.contribution = @"";
    }
    
//    self.contributionLabel.text = [NSString stringWithFormat:@"贡献值：%@",self.users.contribution];
//    ;
    
    self.contributionLabel.text = [NSString stringWithFormat:@"%@",self.users.contribution];
    ;
    
    if (self.users.contribution_level.this_level.name == nil || [self.users.contribution_level.this_level.name isEqualToString:@"nil"]) {
        self.users.contribution_level.this_level.name = @"";
    }
    
    if (self.users.contribution_level.next_level.name == nil || [self.users.contribution_level.next_level.name isEqualToString:@"nil"]) {
        self.users.contribution_level.next_level.name = @"";
    }
    
    self.LeftContributionName.text = self.users.contribution_level.this_level.name;
    self.contribution_this_levelNameLabel.text = self.users.contribution_level.this_level.name;
    self.contribution_next_levelNameLabel.text = self.users.contribution_level.next_level.name;
    self.type_nameLabel.text = self.users.type_name;
    self.painLabel.text = self.users.pain;
    self.painLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",self.panNameS,self.users.pain]];
//    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle1 setLineSpacing:6];
//    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [[NSString stringWithFormat:@"%@%@",self.panNameS,self.users.pain] length])];
//    [self.painLabel setAttributedText:attributedString1];
    
    /** 全局vip设置 */
    AppDelegate *appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appD.vip = self.users.vip;
    
    if (appD.userCurrentLocal) {
        [self.addressButton setTitle:appD.userCurrentLocal forState:UIControlStateNormal];
    }else{
        [self.addressButton setTitle:@"尚未定位" forState:UIControlStateNormal];
    }
    
//    self.addressLabel.text = self.users.address;
    
//    if (self.users.company.length >=8) {
//        self.companyLabel.text = [NSString stringWithFormat:@"%@...",[self.users.company substringToIndex:8]];
//    }else {
        self.companyLabel.text = self.users.company;
//    }
    if (!self.users.company) {
        self.companyLabel.text = @"暂无";
    }
    
    self.jobLabel.text = self.users.job;
    self.zntLabel.text = self.users.znt;
    
    
    if ([self.jobLabel.text isEqualToString:@""]) {
        self.jobLabel.text = @"暂无";
    }else {
        //        self.type_nameRightView.hidden = NO;
    }
    
    if ([self.companyLabel.text isEqualToString:@""]) {
        self.companyLabel.text = @"暂无";
    }else {
        //        self.type_nameRightView.hidden = NO;
    }
    
    //
    if ([self.type_nameLabel.text isEqualToString:@""]) {
        self.type_nameLabel.text = @"暂无";
    }else {
        //        self.type_nameRightView.hidden = NO;
    }
    
    if ([self.contribution_this_levelNameLabel.text isEqualToString:@""]) {
        self.contribution_this_levelNameLabel.text = @"暂无";
    }else {
        //        self.type_nameRightView.hidden = NO;
    }
    
    if ([self.jobLabel.text isEqualToString:@""]) {
        self.compLView.hidden = YES;
    }else {
        self.compLView.hidden = NO;
    }
    
//    if (self.users.is_sign.integerValue == 1) {
//        //        self.sing_monthButtonLabel.enabled = NO;
//        self.sing_monthButtonLabel.alpha = 0.75;
//    }else {
//        self.sing_monthButtonLabel.alpha = 1;
//        self.sing_monthButtonLabel.enabled = YES;
//    }
    
//    [self.painLabel sizeToFit];
//    [self.addressLabel sizeToFit];
//    
//    [self.view layoutIfNeeded];
//    
//    if (!self.isZLT) {
//        self.fwxmButton.hidden = YES;
//    }
//    
//    if (![self.painLabel.text isEqualToString:@""]){
//        self.PainAndAddressViewHCons.constant = 15 + 10 + self.painLabel.glh_height + self.addressLabel.glh_height + 10;
//        
//        self.painWCons.constant = GLScreenW - self.panNameLabel.glw_width - 35;
//    }else {
//        self.addressLToPainLConstrTop.constant = 25;
//    }
//    
//    //    NSLog(@"??sdfsdF?sDF? -%@ - %f- %f",self.painLabel,self.addressLabel.glh_height,self.PainAndAddressViewHCons.constant);
//    
//    [self.painLabel sizeToFit];
//    [self.addressLabel sizeToFit];
//    //    [self.fwxmButton sizeToFit];
//    [self.view layoutIfNeeded];
//    //    [self.fwxmButton sizeToFit];
//    
//    //    [self.addressNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//    //        make.top.equalTo(self.painLabel.mas_bottom).offset(10);
//    //    }];
//    
//    if (![self.painLabel.text isEqualToString:@""]){
//        
//        self.painWCons.constant = GLScreenW - self.panNameLabel.glw_width - 35;
//        
//        self.addressLToPainLConstrTop.constant = 10;
//        
//        self.PainAndAddressViewHCons.constant = 15 + 10 + self.painLabel.glh_height + self.addressLabel.glh_height + 10;
//        if ([self.addressLabel.text isEqualToString:@""]) {
//            self.PainAndAddressViewHCons.constant += 20;
//        }
//        
//    }else {
//        self.addressLToPainLConstrTop.constant = 25;
//        self.PainAndAddressViewHCons.constant = 75;
//    }
//    
//    GLLog(@"painWCons.constant = %f",self.painWCons.constant)
//    GLLog(@"PainAndAddressViewHCons.constant = %f",self.PainAndAddressViewHCons.constant)
//    
//    //    self.contentViewSH.constant = self.lastButton.glb_bottom;
//    //    self.contentScrV.contentSize = CGSizeMake(0, self.lastButton.glb_bottom + self.painLabel.glh_height + 12);
//    
//    //    if (!self.isZLT) {
//    //        self.contentViewSH.constant -= self.fwxmButton.glh_height;
//    //        self.contentViewSH.constant +=100;
//    //        self.lastbotSpeView.hidden = YES;
//    //    }
//    
//    [self.view layoutIfNeeded];
//    
//    //    self.contentViewSH.constant = self.lastButton.glb_bottom + 12;
//    //    self.contentScrV.contentSize = CGSizeMake(0, self.lastButton.glb_bottom + self.painLabel.glh_height);
//    
//    //    if (!self.isZLT) {
//    //        self.contentViewSH.constant -= self.fwxmButton.glh_height;
//    if ([self.addressLabel.text isEqualToString:@""]) {
//        //        self.contentViewSH.constant -= 50;
//    }else {
//        //        self.contentViewSH.constant -= 30;
//    }
//    //        self.contentViewSH.constant +=100;
//    self.lastbotSpeView.hidden = YES;
//    //    }
//    
//    [self setuptableView];
    
    if (self.users.vip) {
        self.vipIconImageV.hidden = NO;
    }else {
        self.vipIconImageV.hidden = YES;
    }
    
        [self.painView setBackgroundColor:[UIColor whiteColor]];
        self.painLabel.text = self.users.pain;
        self.painLabel.numberOfLines = 0;
        
        //        self.painLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
        //        self.painLabel.font = [UIFont systemFontOfSize:14];
    if (self.painLabel.text) {
        NSMutableAttributedString * attributedString2 = [[NSMutableAttributedString alloc] initWithString:self.painLabel.text];
        NSMutableParagraphStyle * paragraphStyle2 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle2 setLineSpacing:4];
        [attributedString2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle2 range:NSMakeRange(0, [self.painLabel.text length])];
        [self.painLabel setAttributedText:attributedString2];
    }
    
    
        self.painLabel.lineBreakMode = NSLineBreakByWordWrapping;
        CGSize subscribeInfoTviewsize = [self.painLabel sizeThatFits:CGSizeMake(GLScreenW - 85 - 20, MAXFLOAT)];
        [self.painLabel setFrame:CGRectMake(85,12, GLScreenW - 85 - 20, subscribeInfoTviewsize.height)];
        [self.painView setFrame:CGRectMake(0, 0, GLScreenW, subscribeInfoTviewsize.height + 12 + 10)];
        label.text = self.panNameS;
        [label sizeToFit];
    cellHeight = 0;
    if (self.users.pain && self.users.pain.length > 0) {
        cellHeight = subscribeInfoTviewsize.height + 12 + 10;
    }else{
        cellHeight = 18 + 12 + 10;
    }
    
    

    
    [[self tableView] reloadData];
}

- (NSDateFormatter *)dateFormatter {
    static NSDateFormatter* dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY年MM月dd日 hh:mm"];
    });
    return dateFormatter;
}

#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    /** 首页 必有数据 */
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    /** 首页 必有数据 */
    
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 1;
    }else if (section == 2) {
        return 3;
    }else if (section == 3) {
        
        AppDelegate *AppD = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
        
//        if (!AppD.checkpay) {
//            
//            return 2;
//            
//        }else {
            if (!self.isZLT) {
                return 2;
            }
            return 3;
     //   }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AppDelegate *AppD = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
    
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        
        if (self.panNameS == nil) {
            self.panNameS = @" ";
        }
        
        if (self.users.pain == nil) {
            self.users.pain = @" ";
        }
        
//        cell = [tableView dequeueReusableCellWithIdentifier:@"WDPainCell" forIndexPath:indexPath];
//        WDPainCell *WDcell = (WDPainCell *)cell;
//        WDcell.painLabel.text = [NSString stringWithFormat:@"%@",self.panNameS];
//        WDcell.painValueLabel.text = [NSString stringWithFormat:@"%@",self.users.pain];
//        [WDcell.painValueLabel setFrame:CGRectMake(85, 12, GLScreenW - 105, cellHeight - 15)];
        PainTableViewCell *paincell = [tableView dequeueReusableCellWithIdentifier:@"PainCell"];
        if (!paincell) {
            paincell = [[PainTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PainCell"];
        }
        if (!paincell.painView) {
            paincell.painView = self.painView;
            [paincell.contentView addSubview:paincell.painView];
        }
        [self.painLabel setFrame:CGRectMake(85,12, GLScreenW - 85 - 20, cellHeight - 22)];
        [self.painView setFrame:CGRectMake(0, 0, GLScreenW, cellHeight)];
        label.text = self.panNameS;
        [label sizeToFit];
        paincell.selectionStyle = UITableViewCellSelectionStyleNone;
        return paincell;

        
    }else if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"WDQDCell" forIndexPath:indexPath];
        
        WDQDCell *QDcell = (WDQDCell *)cell;
//        Dcell.numLabel.text = @"+998";
        
        if (self.users.sign_count) {
            QDcell.numLabel.text = [NSString stringWithFormat:@"+%@",self.users.sign_count];
        }
        
        if (self.users.is_sign.integerValue == 1) {
            QDcell.TtitleLabel.text = @"已经签到";
        }else {
            QDcell.TtitleLabel.text = @"点击签到";
        }
        
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"WDPushCell" forIndexPath:indexPath];
        
        WDPushCell *Pushcell = (WDPushCell *)cell;
        Pushcell.rightLabel.hidden = YES;
        if (indexPath.section == 2) {
            
            if (indexPath.row == 0) {
                Pushcell.iconImageVIew.image = [UIImage imageNamed:@"WDZY_HY"];
                Pushcell.TtitleLabel.text = @"成为建众帮会员";
                
                if (self.users.vip == nil) {
                    
                }else {
                    NSTimeInterval time= [self.users.vip.end_time doubleValue];
                    Pushcell.rightLabel.text = [[self dateFormatter] stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
                    Pushcell.rightLabel.hidden = NO;

                    Pushcell.rightImageV.hidden = YES;
                    
//                    if (!AppD.checkpay) {
//                        Pushcell.TtitleLabel.text = @"关注人脉";
//                        Pushcell.rightLabel.hidden = YES;
//                        Pushcell.rightImageV.hidden = NO;
//                        Pushcell.iconImageVIew.image = [UIImage imageNamed:@"WDZY_CWHY"];
//                    }else{
                        Pushcell.TtitleLabel.text = @"会员到期";
                   // }

                    //            cell.rightLabel.text = @"1";
                    
                }
                
//                if (!delegate.checkpay) {
//                    Pushcell.TtitleLabel.text = @"建众帮";
//                }else{
//                    Pushcell.TtitleLabel.text = @"会员到期";
//                }
                
            }else if (indexPath.row == 1) {
                Pushcell.iconImageVIew.image = [UIImage imageNamed:@"WDZY_JZRM"];
                Pushcell.TtitleLabel.text = @"帮圈人脉";
            }else if (indexPath.row == 2) {
                Pushcell.iconImageVIew.image = [UIImage imageNamed:@"WDZY_BBSJ"];
                Pushcell.TtitleLabel.text = @"帮吧商机";
            }
            
            
        }else if (indexPath.section == 3) {
            if (indexPath.row == 0) {
                Pushcell.iconImageVIew.image = [UIImage imageNamed:@"WDZY_KC"];
                Pushcell.TtitleLabel.text = @"我的课程";
            }else if (indexPath.row == 1) {
                Pushcell.iconImageVIew.image = [UIImage imageNamed:@"WDZY_SQ"];
                Pushcell.TtitleLabel.text = @"参与社群";
            }else if (indexPath.row == 2) {
                Pushcell.iconImageVIew.image = [UIImage imageNamed:@"WDZY_XM"];
                Pushcell.TtitleLabel.text = @"服务项目";
            }
//        }else if (indexPath.row == 4) {
//                    }else if (indexPath.row == 5) {
//            Pushcell.iconImageVIew.image = [UIImage imageNamed:@"WDZY_SQ"];
//            Pushcell.TtitleLabel.text = @"参与社群";
//        }else if (indexPath.row == 6) {
//            Pushcell.iconImageVIew.image = [UIImage imageNamed:@"WDZY_XM"];
//            Pushcell.TtitleLabel.text = @"服务项目";
        }
        
    }
    
//    cell.model = self.dataSource[indexPath.row];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)painView{
    if (!_painView) {
        _painView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GLScreenW, 20)];
        [_painView setBackgroundColor:[UIColor whiteColor]];
        label = [[UILabel alloc]initWithFrame:CGRectMake(20, 12, 0, 0)];
        [label setTextColor:[UIColor hx_colorWithHexRGBAString:@"212121"]];
        [label setFont:[UIFont systemFontOfSize:13]];
        [_painView addSubview:label];
        
        self.painLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, 12, 0, 0)];
        [self.painLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"212121"]];
        [self.painLabel setFont:[UIFont systemFontOfSize:13]];
        [_painView addSubview:self.painLabel];
    }
    return _painView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        // 设置文字属性 要和label的一致
        
        
        return cellHeight;
        
    }else if (indexPath.section == 1) {
        return 44;
    }else  {
        return 44;
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (indexPath.section == 1) {
        
        // 点击签到
        
        [self ClickQSCell];
        
    }else if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            //if (appDelegate.checkpay) {
                ApplyVipVC *applyVipVC = [[ApplyVipVC alloc]init];
                [self.navigationController pushViewController:applyVipVC animated:YES];
//            }else{
////                [SVProgressHUD showInfoWithStatus:@"功能暂未开发,敬请期待"];
//                AttentionListVC *vc = [AttentionListVC new];
//                
//                vc.title = @"关注列表";
//                vc.user = self.users;
//                
//                
//                [self.navigationController pushViewController:vc animated:YES];
//            }
        }else if (indexPath.row == 1){
            // 人脉
           // if (appDelegate.checkpay) {
                if (self.users.vip) {
                    BQRMRootVC *rmRootVC = [[UIStoryboard storyboardWithName:@"BQRMRootVC" bundle:nil] instantiateInitialViewController];
                    
                    [self.navigationController pushViewController:rmRootVC animated:YES];
                }else {
                    
                    [UIView bch_showWithTitle:@"提示" message:@"进入建众人脉要先加入建众帮会员哦！" buttonTitles:@[@"取消",@"确定"] callback:^(id sender, NSUInteger buttonIndex) {
                        if (1 == buttonIndex) {
                          //  AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                            
                           // if (appDelegate.checkpay) {
                                ApplyVipVC *applyVipVC = [[ApplyVipVC alloc]init];
                                [self.navigationController pushViewController:applyVipVC animated:YES];
                           // }
                        }
                    }];
                    
                    //                [UIView bch_showWithTitle:@"title" cancelTitle:@"cancel" destructiveTitle:@"des" otherTitles:@[@"1",@"2"] callback:^(id sender, NSInteger buttonIndex) {
                    //
                    //                }];
                    
                    //                [EMAlertView showAlertWithTitle:@"title" message:@"mess" completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
                    //                    
                    //                } cancelButtonTitle:@"取消" otherButtonTitles:@"其他"];
                }

            }else if (indexPath.row == 1){
                BQRMRootVC *rmRootVC = [[UIStoryboard storyboardWithName:@"BQRMRootVC" bundle:nil] instantiateInitialViewController];
                
                [self.navigationController pushViewController:rmRootVC animated:YES];

            }else if (indexPath.row == 2) {
                CommChanceVC *commChanceVC = [[CommChanceVC alloc]init];
                
                [self.navigationController pushViewController:commChanceVC animated:YES];
            }
            
      //  }
        
    }else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            [self pushMyCourseVC];
        }else if (indexPath.row == 1){
            //  [self pushMyCourseVC];
            
            [SVProgressHUD showInfoWithStatus:@"功能暂未开发,敬请期待"];
            
            
        }else if (indexPath.row == 2){
            //  [self pushMyCourseVC];
            
            [SVProgressHUD showInfoWithStatus:@"功能暂未开发,敬请期待"];
            
            
        }
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, GLScreenW, GLScreenH);
    view.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f8f8f8"];
    
    UIView *fengexian99 = [UIView new];
    if (section == 1) {
        fengexian99.frame = CGRectMake(0, 15, GLScreenW, 1);
    }else {
        fengexian99.frame = CGRectMake(0, 10, GLScreenW, 1);
    }
    
    [view addSubview:fengexian99];
    fengexian99.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"dfdfdf"];
    
    UIView *fengexian00 = [UIView new];
    
    fengexian00.frame = CGRectMake(0,0, GLScreenW, 1);
    
    [view addSubview:fengexian00];
    fengexian00.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"dfdfdf"];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }else if (section == 1) {
        return 15;
    }else if (section == 2) {
        return 10;
    }else if (section == 3) {
        return 10;
    }
    return 0;
}


/** 跳转粉丝列表 */
- (IBAction)clickFasnList:(UIControl *)sender {
    
    FansListVC *vc = [FansListVC new];
    
    vc.title = @"粉丝列表";
    vc.user = self.users;
    
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)clickAttentionList:(UIControl *)sender {
    
    AttentionListVC *vc = [AttentionListVC new];
    
    vc.title = @"关注列表";
    vc.user = self.users;
    
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

/** 跳转积分充值列表 */
- (IBAction)clickMoney:(UIControl *)sender {
    
//    AppDelegate *appDelegate = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
//    
//    if (!appDelegate.checkpay) {
//        return ;
//    }
    IntegralDetailVC *vc = [[UIStoryboard storyboardWithName:@"IntegralDetailVC" bundle:nil] instantiateInitialViewController];
    vc.bangbiCount = self.users.money;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 点击个人简介
- (IBAction)ClickgrjjButton:(UIButton *)sender {
    
    WDPersonInfoVC *vc = [[UIStoryboard storyboardWithName:@"WDPersonInfoVC" bundle:nil]instantiateInitialViewController];
    vc.isZLT = self.isZLT;
    vc.user = self.users;
    
    vc.isMine = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 点击参与话题
- (IBAction)ClickcyhtButton:(UIButton *)sender {
    
    [self pushPerAskAndAnswerVC];
    
}

#pragma mark - 点击关注内容
- (IBAction)ClickgznrButton:(UIButton *)sender {
    
    FocusContentVC *vc = [FocusContentVC new];
    
    self.navigationController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 点击商机资源
- (IBAction)ClicksjbrButton:(UIButton *)sender {
    
    [self pushPerActivityVC];
    
}

- (void)pushBQDynamicVC
{
    BQDynamicVC *bqRoot = [[BQDynamicVC alloc]init];
    bqRoot.fromPernoal = YES;
    Users *user = [[Users alloc]init];
    user.uid = [[LoginVM getInstance] readLocal]._id;
    user = (Users *)[[DataBaseHelperSecond getInstance]getModelFromTabel:user];
    bqRoot.user = user;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //self.navigationController.navigationBar.hidden = NO;
    [self.navigationController pushViewController:bqRoot animated:YES];
    
}

- (void)pushPerActivityVC
{
    PerActivityVC *perActivityVC = [[PerActivityVC alloc]init];
    Users *user = [[Users alloc]init];
    user.uid = [[LoginVM getInstance] readLocal]._id;
    user = (Users *)[[DataBaseHelperSecond getInstance]getModelFromTabel:user];
    perActivityVC.user = user;
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController pushViewController:perActivityVC animated:YES];
}

- (void)pushPerAskAndAnswerVC
{
    PerAskAndAnswerVC *perAAVC = [[PerAskAndAnswerVC alloc]init];
    Users *user = [[Users alloc]init];
    user.uid = [[LoginVM getInstance] readLocal]._id;
    user = (Users *)[[DataBaseHelperSecond getInstance]getModelFromTabel:user];
    perAAVC.user = user;
    //[self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController pushViewController:perAAVC animated:YES];
}

- (void)pushMyCourseVC
{
    MyCourseVC *myVC = [[MyCourseVC alloc]init];
    //[self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //[self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:myVC animated:YES];
}

- (void)pushJZRM
{
    
    
    
    
//    self.navigationController.hidesBottomBarWhenPushed = YES;
//    
//    [self.navigationController pushViewController:myVC animated:YES];
}

/** 设置 - 更多 */
- (IBAction)settingButtonClick:(UIButton *)btn
{
    MYSettingVC *settingVC = [[UIStoryboard storyboardWithName:@"MYSettingVC" bundle:nil] instantiateInitialViewController];
    
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)ClickQSCell
{
    UserInfo *userInfo = [[LoginVM getInstance]readLocal];
    
    NSDictionary *parameters = @{
                                 @"access_token":userInfo.token,
                                 
                                 };
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/user/sign"] parameters:parameters success:^(id json) {
        
        [SVProgressHUD setMinimumDismissTimeInterval:1.5];
        
        UserQSItem *item = [UserQSItem mj_objectWithKeyValues:json];
        
        
        if (![item.state isEqual:@(1)]) {
            [SVProgressHUD showInfoWithStatus:item.info];
        }else {
            
            NSNumber *num = item.contribution;
            
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"签到成功,贡献值 + %@",num]];
        }
        
        self.users.is_sign = @(1);
        
        [self loadDBAndDown];
        
        /** 日历 */
        //        [self setupCalendarView];
        
    } failure:^(NSError *error) {
        
    }];
}

- (CGSize)getStringRect:(NSString*)aString

{
    
    CGSize size;
    
    NSAttributedString* atrString = [[NSAttributedString alloc] initWithString:aString];
    
    NSRange range = NSMakeRange(0, atrString.length);
    
    NSDictionary* dic = [atrString attributesAtIndex:0 effectiveRange:&range];
    
    CGFloat textW;
    
    
        textW = [UIScreen mainScreen].bounds.size.width - 88;
    
    
    size = [aString boundingRectWithSize:CGSizeMake(textW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    return  size;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //    if (path.row == self.dataSource.count - 1) {
    //        self.tableView.bounces = YES;
    //    }
    if (((int)scrollView.contentOffset.y) < 10) {
        self.tableView.bounces = NO;
    }else{
        self.tableView.bounces = YES;
    }
    
}

//分隔线左对齐
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

//    GLLog(@"indexPath.section==%ld",(long)indexPath.section);
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

- (void)tapUserAvaImageView
{
    GLLog(@"%@",self.users.avatar);
    if (![self.users.avatar isEqualToString:@" "]) return;
    if (![self.users.avatar isEqualToString:@""]) return;
    
    CGRect rect1 = self.userAvaImageView.frame;
    
    NSMutableArray* tmp = [NSMutableArray array];
    
//    [[LWImageBrowser alloc] initWithParentViewController:self style:LWImageBrowserAnimationStyleScale imageModels:tmp currentIndex:0];
   
    
    LWImageBrowserModel *imageModel = [[LWImageBrowserModel alloc]initWithLocalImage:[LocalDataRW getImageWithDirectory:Directory_BQ RetalivePath:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:self.users.avatar]] imageViewSuperView:self.userAvaImageView.superview positionAtSuperView:CGRectFromString(NSStringFromCGRect(rect1)) index:0];
        [tmp addObject:imageModel];
    
     LWImageBrowser* imageBrowser = [[LWImageBrowser alloc] initWithParentViewController:self style:LWImageBrowserAnimationStyleScale imageModels:tmp currentIndex:0];

    imageBrowser.view.backgroundColor = [UIColor blackColor];
    
    [imageBrowser show];
}


//static SixWdRootVC *_instance;
//
////类方法，返回一个单例对象
//+ (instancetype)shareSixWdRootVC
//{
//
//    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SixWdRootVC"];
//}
//
////保证永远只分配一次存储空间
//+ (instancetype)allocWithZone:(struct _NSZone *)zone
//{
//    //    使用GCD中的一次性代码
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _instance = [super allocWithZone:zone];
//    });
//    
//    //使用加锁的方式，保证只分配一次存储空间
//    //    @synchronized(self) {
//    //        if (_instance == nil) {
//    //            _instance = [super allocWithZone:zone];
//    //        }
//    //    }
//    return _instance;
//}

@end
