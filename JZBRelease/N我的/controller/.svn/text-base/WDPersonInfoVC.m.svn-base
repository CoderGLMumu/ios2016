//
//  WDPersonInfoVC.m
//  JZBRelease
//
//  Created by zjapple on 16/9/3.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "SendAndGetDataFromNet.h"

#import "WDPersonInfoVC.h"

#import "WDPersonInfoJZXXCell.h"
#import "JZXXItem.h"
#import "PersonalInformationViewController.h"

#import "UIButton+WebCache.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>

#import "LWImageBrowser.h"
#import "LWImageBrowserModel.h"

@interface WDPersonInfoVC () <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *vipIconImageV;

/** dataSource1 */
@property (nonatomic, strong) NSMutableArray *dataSource1;
/** dataSource2 */
@property (nonatomic, strong) NSMutableArray *dataSource2;
/** dataSource3 */
@property (nonatomic, strong) NSMutableArray *dataSource3;

@property (weak, nonatomic) IBOutlet UIButton *jzxxButton;
@property (weak, nonatomic) IBOutlet UIButton *grxxButton;

/** isgrxx */
//@property (nonatomic, assign) BOOL isZLT;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (weak, nonatomic) IBOutlet UILabel *ToptitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *avaImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userAvaImageView;

@property (weak, nonatomic) IBOutlet UILabel *contribution_this_levelNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *type_nameLabel;
@property (weak, nonatomic) IBOutlet UIView *type_nameLView;
@property (weak, nonatomic) IBOutlet UIView *compLView;

@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobLabel;


@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backGImageView;

@property (weak, nonatomic) UIView *blackView;
@property (weak, nonatomic) UIToolbar *toolbar;

/**
 *  面板
 */
@property (nonatomic, strong) UIView *panelView;

/**
 *  加载视图
 */
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;

@end

@implementation WDPersonInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 12, 0);
    
    if (self.isMine) {
        self.editButton.hidden = NO;
        self.shareButton.hidden = YES;
    }else {
        self.editButton.hidden = YES;
        self.shareButton.hidden = NO;
    }
    
    /** 分享功能还没有 */
    self.shareButton.hidden = YES;
    
    /** 去除多余的分割线 */
    self.tableView.tableFooterView = [[UIImageView alloc]init];
    
    [self setupSubView];
    
    [self setupData];
    
    self.dataSource1 = [NSMutableArray array];
    self.dataSource2 = [NSMutableArray array];
    self.dataSource3 = [NSMutableArray array];
//    self.type_nameLView.hidden = YES;
//    self.compLView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self downLoadData];
    
//    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:1.75 delay:0.45 usingSpringWithDamping:8 initialSpringVelocity:3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.blackView.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView animateWithDuration:5 delay:0.85 usingSpringWithDamping:6 initialSpringVelocity:6 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.toolbar.alpha = 0.3;
    } completion:nil];
    
    
    
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:18 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        self.blackView.alpha = 0;
//    } completion:nil];
}

- (void)setupSubView
{
    self.avaImageView.layer.cornerRadius = self.avaImageView.glw_width * 0.5;
    self.avaImageView.clipsToBounds = YES;
//    self.avaImageView.contentMode = UIViewContentModeScaleAspectFill;
//    self.avaImageView.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.avaImageView.layer.borderWidth = 2;
    self.avaImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.userAvaImageView.layer.cornerRadius = self.userAvaImageView.glw_width * 0.5;
    self.userAvaImageView.clipsToBounds = YES;

    self.userAvaImageView.layer.borderWidth = 2;
    self.userAvaImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapUserAvaImageView)];
    [self.userAvaImageView addGestureRecognizer:tap];
    self.userAvaImageView.userInteractionEnabled = YES;
    
//    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    /** imageFilePath 是保存图片的沙盒地址 用UIImage的imageWithContentsOfFile方法加载 */
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
    
    if ([UIImage imageWithContentsOfFile:imageFilePath]) {
        self.backGImageView.image = [UIImage imageWithContentsOfFile:imageFilePath];
    }
    
    self.backGImageView.frame = CGRectMake(0, 0, GLScreenW, self.backGImageView.frame.size.height);
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, GLScreenW, self.backGImageView.frame.size.height)];
    toolbar.hidden = YES;
    toolbar.barStyle = UIBarStyleBlackTranslucent;
//    toolbar.translucent = YES;
    toolbar.alpha = 0.96;
    [self.backGImageView addSubview:toolbar];
    self.toolbar = toolbar;
    toolbar.userInteractionEnabled = YES;
    
    UIView *blackView = [UIView new];
    blackView.hidden = YES;
    [self.backGImageView addSubview:blackView];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.frame = CGRectMake(0, 0, GLScreenW, self.backGImageView.frame.size.height);
    self.blackView = blackView;
    blackView.alpha = 0.9;
    
    // 加载完成后，再添加平移手势
    // 添加平移手势，用来控制音量、亮度、快进快退
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panDirection:)];
    
    pan.delegate = self;
    
    [toolbar addGestureRecognizer:pan];
    
}

- (void)setupData
{
//    self.type_nameLView.hidden = NO;
//    self.compLView.hidden = NO;
    
    if (!self.isMine) {
        if (self.user.nickname) {
            self.ToptitleLabel.text = [NSString stringWithFormat:@"%@的信息",self.user.nickname];
        }
    }
    
//    [self.avaImageView sd_setImageWithURL:[NSURL URLWithString:] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"ZCCG_TX"]];
    
//    NSString *imagePath = [[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:self.user.avatar];
//    [self.avaImageView setImage:[LocalDataRW getImageWithDirectory:Directory_RM RetalivePath:imagePath] forState:UIControlStateNormal];
//    [self.userAvaImageView setImage:[LocalDataRW getImageWithDirectory:Directory_RM RetalivePath:imagePath]];
    
    [self.userAvaImageView sd_setImageWithURL:[NSURL URLWithString:[LocalDataRW getImageAllStr:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:self.user.avatar]]] placeholderImage:[UIImage imageNamed:@"ZCCG_TX"]];
    
    if (self.user.nickname) {
        self.nickNameLabel.text = self.user.nickname;
    }
    
    if (self.user.vip) {
        self.vipIconImageV.hidden = NO;
    }else {
        self.vipIconImageV.hidden = YES;
    }
    
    self.contribution_this_levelNameLabel.text = self.user.contribution_level.this_level.name;
    self.type_nameLabel.text = self.user.type_name;
    self.jobLabel.text = self.user.job;
//    self.companyLabel.text = self.user.company;
//    if (self.user.company.length >=8) {
//        self.companyLabel.text = [NSString stringWithFormat:@"%@...",[self.user.company substringToIndex:8]];
//    }else {
        self.companyLabel.text = self.user.company;
//    }
    
    if ([self.jobLabel.text isEqualToString:@""]) {
        self.jobLabel.text = @"暂无";
    }else {
        //        self.type_nameRightView.hidden = NO;
    }
    
    if ([self.contribution_this_levelNameLabel.text isEqualToString:@""]) {
        self.contribution_this_levelNameLabel.text = @"暂无";
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
    
}

- (void)downLoadData
{
    if (!self.isMine) {
        if (self.isZLT) {
            [self setupZLTDataSource];
        }else {
            [self setupDataSource];
        }
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"access_token":[[LoginVM getInstance]readLocal].token,
                                 @"uid":@"0"
                                 };
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/user/info"] parameters:parameters success:^(id json) {
        
        if ([json[@"state"] isEqual:@(0)]) {
            [SVProgressHUD showInfoWithStatus:@"网络不顺,稍后再试"];
            return ;
        }
        
        self.user = [Users mj_objectWithKeyValues:json[@"data"]];
        
        if ([self.user.type isEqualToString:@"2"]) {
            self.isZLT = YES;
        }
        
        if (self.isZLT) {
            [self setupZLTDataSource];
        }else {
            [self setupDataSource];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)setupZLTDataSource
{
//    self.type_nameLView.hidden = NO;
//    self.compLView.hidden = NO;
    [self.dataSource1 removeAllObjects];
    [self.dataSource2 removeAllObjects];
    [self.dataSource3 removeAllObjects];
    
    JZXXItem *item1_1 = [JZXXItem new];
    item1_1.title = @"行业";
    //    item1.value = @"邹鲁";
    
    if (self.user.industry) {
        item1_1.value = self.user.industry;
    }
    
    [self.dataSource1 addObject:item1_1];
    
    JZXXItem *item1_2 = [JZXXItem new];
    item1_2.title = @"所在地";
    //    item1.value = @"邹鲁";
    
    if (self.user.address) {
        item1_2.value = self.user.address;
    }
    
    [self.dataSource1 addObject:item1_2];
    
    JZXXItem *item2_1 = [JZXXItem new];
    item2_1.title = @"公司名称";
    //    item2.value = @"男";
    
    if (self.user.company) {
        item2_1.value = self.user.company;
    }
    
    [self.dataSource2 addObject:item2_1];
    
    //    JZXXItem *item2 = [JZXXItem new];
    //    item2.title = @"性别";
    ////    item2.value = @"男";
    //
    //    if ([self.user.sex isEqualToString:@"1"]) {
    //        item2.value = @"男";
    //    }else{
    //        item2.value = @"女";
    //    }
    //
    //    [self.dataSource1 addObject:item2];
    
    JZXXItem *item2_2 = [JZXXItem new];
    item2_2.title = @"公司服务";
    //    item3.value = @"2333.12.12";
    
    if (self.user.company_gm) {
        item2_2.value = self.user.company_gm;
    }
    
    [self.dataSource2 addObject:item2_2];
    
//    JZXXItem *item2_3 = [JZXXItem new];
//    item2_3.title = @"员工数量";
//    item2_3.value = self.user.company_num;
//    [self.dataSource2 addObject:item2_3];
    
    JZXXItem *item3_1 = [JZXXItem new];
    item3_1.title = @"性别";
    if ([self.user.sex isEqualToString:@"1"]) {
        item3_1.value = @"男";
    }else{
        item3_1.value = @"女";
    }
    [self.dataSource3 addObject:item3_1];
    
//    JZXXItem *item3_2 = [JZXXItem new];
//    item3_2.title = @"手机号码";
//    item3_2.value = self.user.mobile;
//    [self.dataSource3 addObject:item3_2];
    
    JZXXItem *item3_3 = [JZXXItem new];
    item3_3.title = @"微信号";
    item3_3.value = self.user.wechat;
    [self.dataSource3 addObject:item3_3];
    
//    JZXXItem *item3_4 = [JZXXItem new];
//    item3_4.title = @"通讯地址";
//    item3_4.value = self.user.address2;
//    [self.dataSource3 addObject:item3_4];
    
    JZXXItem *item3_5 = [JZXXItem new];
    item3_5.title = @"兴趣爱好";
    item3_5.value = self.user.interest;
    [self.dataSource3 addObject:item3_5];
    
    [self setupfooterView];
    
    [self.tableView reloadData];
}

- (void)setupDataSource
{
//    self.type_nameLView.hidden = NO;
//    self.compLView.hidden = NO;
    [self.dataSource1 removeAllObjects];
    [self.dataSource2 removeAllObjects];
    [self.dataSource3 removeAllObjects];
    
    JZXXItem *item1_1 = [JZXXItem new];
    item1_1.title = @"行业";
    //    item1.value = @"邹鲁";
    
    if (self.user.industry) {
        item1_1.value = self.user.industry;
    }
    
    [self.dataSource1 addObject:item1_1];
    
    JZXXItem *item1_2 = [JZXXItem new];
    item1_2.title = @"所在地";
    //    item1.value = @"邹鲁";
    
    if (self.user.address) {
        item1_2.value = self.user.address;
    }
    
    [self.dataSource1 addObject:item1_2];
    
    JZXXItem *item2_1 = [JZXXItem new];
    item2_1.title = @"公司名称";
    //    item2.value = @"男";
    
    if (self.user.company) {
        item2_1.value = self.user.company;
    }
    
    [self.dataSource2 addObject:item2_1];
    
    //    JZXXItem *item2 = [JZXXItem new];
    //    item2.title = @"性别";
    ////    item2.value = @"男";
    //
    //    if ([self.user.sex isEqualToString:@"1"]) {
    //        item2.value = @"男";
    //    }else{
    //        item2.value = @"女";
    //    }
    //
    //    [self.dataSource1 addObject:item2];
    
    JZXXItem *item2_2 = [JZXXItem new];
    item2_2.title = @"公司规模";
    //    item3.value = @"2333.12.12";
    
    if (self.user.company_gm) {
        item2_2.value = self.user.company_gm;
    }
    
    [self.dataSource2 addObject:item2_2];
    
    JZXXItem *item2_3 = [JZXXItem new];
    item2_3.title = @"员工数量";
    item2_3.value = self.user.company_num;
    [self.dataSource2 addObject:item2_3];
    
    JZXXItem *item2_4 = [JZXXItem new];
    item2_4.title = @"经营品牌";
    item2_4.value = self.user.brand;
    [self.dataSource2 addObject:item2_4];
    
    JZXXItem *item2_5 = [JZXXItem new];
    item2_5.title = @"门店数量";
    item2_5.value = self.user.shop_num;
    [self.dataSource2 addObject:item2_5];
    
    JZXXItem *item3_1 = [JZXXItem new];
    item3_1.title = @"性别";
    if ([self.user.sex isEqualToString:@"1"]) {
        item3_1.value = @"男";
    }else{
        item3_1.value = @"女";
    }
    [self.dataSource3 addObject:item3_1];
    
//    JZXXItem *item3_2 = [JZXXItem new];
//    item3_2.title = @"手机号码";
//    item3_2.value = self.user.mobile;
//    [self.dataSource3 addObject:item3_2];
    
    JZXXItem *item3_3 = [JZXXItem new];
    item3_3.title = @"微信号";
    item3_3.value = self.user.wechat;
    [self.dataSource3 addObject:item3_3];
    
//    JZXXItem *item3_4 = [JZXXItem new];
//    item3_4.title = @"通讯地址";
//    item3_4.value = self.user.address2;
//    [self.dataSource3 addObject:item3_4];
    
    JZXXItem *item3_5 = [JZXXItem new];
    item3_5.title = @"兴趣爱好";
    item3_5.value = self.user.interest;
    [self.dataSource3 addObject:item3_5];
    
    [self.tableView reloadData];
}

- (void)setupfooterView
{
    
    UIView *footerView = [UIView new];
    footerView.frame = CGRectMake(0, 0, self.view.glw_width, 100);
    footerView.backgroundColor = [UIColor whiteColor];
    
    UIView *spe = [UIView new];
    spe.frame = CGRectMake(0, 0, self.view.glw_width, 14);
    spe.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f2f2f2"];
    [footerView addSubview:spe];
    
    UILabel *LtitleLabel = [UILabel new];
    LtitleLabel.frame = CGRectMake(20, 20, 0, 0);
    LtitleLabel.text = @"个人简介";
    LtitleLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
    LtitleLabel.font = [UIFont systemFontOfSize:15];
    [LtitleLabel sizeToFit];
    [footerView addSubview:LtitleLabel];
    
    UILabel *rightLabel = [UILabel new];
    rightLabel.numberOfLines = 0;
    rightLabel.frame = CGRectMake(20, 45, 0, 0);
    rightLabel.glw_width = self.view.glw_width - 40;
    rightLabel.text = self.user.teacher_desc;
    rightLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"212121"];
    rightLabel.font = [UIFont systemFontOfSize:14];
    [rightLabel sizeToFit];
    [footerView addSubview:rightLabel];
    
    footerView.glh_height = 50 + rightLabel.glh_height + 10;
    
    self.tableView.tableFooterView = footerView;
    
    
}

- (IBAction)clickBackButton:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

//- (IBAction)clickJZXXButton:(UIButton *)sender {
//    
//    self.isgrxx = NO;
//    
//    [self.jzxxButton setTitleColor:[UIColor hx_colorWithHexRGBAString:@"FF9B00"] forState:UIControlStateNormal];
//    [self.grxxButton setTitleColor:[UIColor hx_colorWithHexRGBAString:@"757575"] forState:UIControlStateNormal];
//    [self setupDataSource];
//    
//}
//
//- (IBAction)clickGRXXButton:(UIButton *)sender {
//    
//    self.isgrxx = YES;
//    
//    [self.jzxxButton setTitleColor:[UIColor hx_colorWithHexRGBAString:@"757575"] forState:UIControlStateNormal];
//    [self.grxxButton setTitleColor:[UIColor hx_colorWithHexRGBAString:@"FF9B00"] forState:UIControlStateNormal];
//    
//    [self setupGRXXDataSource];
//    
//}


/** 更改个人信息 */ /** 点击编辑按钮处理事件 */
- (IBAction)clickEditButton:(UIButton *)sender {
    
    /** 跳转个人资料 */
    if (self.isZLT) {
        PersonalInformationViewController *PIVC = [[UIStoryboard storyboardWithName:@"PersonalInformationViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"ZLT"];
        [self handleClickEditBtn:PIVC];
    }else {
        PersonalInformationViewController *PIVC = [[UIStoryboard storyboardWithName:@"PersonalInformationViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"NOZLT"];
        [self handleClickEditBtn:PIVC];
    }
    
}

/** 点击编辑按钮处理事件 */
- (void)handleClickEditBtn:(PersonalInformationViewController *)PIVC
{
    PIVC.MyPrelocal = self.user.address;
    
    /** 头像回调消息 */
    
    PIVC.updataavatarImageView = ^(UIImage *selfPhoto){
        self.userAvaImageView.image = selfPhoto;
    };
    
    /** 公司回调消息 */
    PIVC.updatenickName = ^(NSString *nickName){
        self.nickNameLabel.text = nickName;
    };
    
    
    /** 名字回调消息 */
    //        PIVC.updateIdentity = ^(NSString *nickName){
    //            self.personView.companyLabel.text = nickName;
    //        };
    
    /** 地址回调消息 */
    //        PIVC.updateAddress = ^(NSString *address){
    //            self.personView.locationLabel.text = address;
    //            self.users.address.city = address;
    //        };
    PIVC.isZLT = self.isZLT;
    
    [self.navigationController pushViewController:PIVC animated:YES];
}

- (IBAction)clickShareButton:(UIButton *)sender {
    
    [self showShareActionSheet:self.view];
    
//    [self goShare];
    
}

/**
 *  显示分享菜单
 *
 *  @param view 容器视图
 */
- (void)showShareActionSheet:(UIView *)view
{
    
    /** 还没有分享 */
    return ;
    
    /**
     * 在简单分享中，只要设置共有分享参数即可分享到任意的社交平台
     **/
    __weak WDPersonInfoVC *theController = self;
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[UIImage imageNamed:@"shareImage"]];
    [shareParams SSDKSetupShareParamsByText:nil
                                     images:imageArray
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"http://bang.jianzhongbang.com/index.php/Share/Question/info/id/%@.html",@"1"]]
                                      title:nil//title:@"分享标题-欢迎下载【建众帮】"
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

/*
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

//    if (self.isgrxx && !self.isMine) {
//        return 1;
//    }
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return self.dataSource1.count;
    }else if (section == 1) {
        return self.dataSource2.count;
    }else if (section == 2) {
        return self.dataSource3.count;
    }
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    
    if (section == 2) {
        if (self.dataSource3.count) {
            return 14;
        }
        return 0;
    }
    
    return 14;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.isgrxx) {
//        if (indexPath.row == 3) {
//            return 87;
//        }
//    }
    
    return 44;
}


- (WDPersonInfoJZXXCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (self.isZLT) {
//        if (indexPath.row == 3) {
//            WDPersonInfoJZXXCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WDPersonInfoJZXXCell" forIndexPath:indexPath];
//            
//            cell.model = self.dataSource2[indexPath.row];
//            
//            return cell;
//        }
//    }
    
    WDPersonInfoJZXXCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WDPersonInfoJZXXCell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        cell.model = self.dataSource1[indexPath.row];
    }else if (indexPath.section == 1) {
        cell.model = self.dataSource2[indexPath.row];
    }else if (indexPath.section == 2) {
        cell.model = self.dataSource3[indexPath.row];
    }
    
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

///**
// *  pan手势事件
// *
// *  @param pan UIPanGestureRecognizer
// */
//- (void)panDirection:(UIPanGestureRecognizer *)pan
//{
//    //根据在view上Pan的位置，确定是调音量还是亮度
//    CGPoint locationPoint = [pan locationInView:self.toolbar];
//    
//    // 我们要响应水平移动和垂直移动
//    // 根据上次和本次移动的位置，算出一个速率的point
//    CGPoint veloctyPoint = [pan velocityInView:self.toolbar];
//    
//    // 判断是垂直移动还是水平移动
//    switch (pan.state) {
//        case UIGestureRecognizerStateBegan:{ // 开始移动
//            // 使用绝对值来判断移动的方向
//            CGFloat x = fabs(veloctyPoint.x);
//            CGFloat y = fabs(veloctyPoint.y);
//            if (x > y) { // 水平移动
//                self.panDirection = PanDirectionHorizontalMoved;
//                break;
//            }
//            else if (x < y){ // 垂直移动
//                self.panDirection = PanDirectionVerticalMoved;
//                // 开始滑动的时候,状态改为正在控制音量
//                if (locationPoint.x > self.bounds.size.width / 2) {
//                    self.isVolume = YES;
//                }else { // 状态改为显示亮度调节
//                    self.isVolume = NO;
//                }
//            }
//            break;
//        }
//        case UIGestureRecognizerStateChanged:{ // 正在移动
//            switch (self.panDirection) {
//                case PanDirectionHorizontalMoved:{
//                    break;
//                }
//                case PanDirectionVerticalMoved:{
//                    [self verticalMoved:veloctyPoint.y]; // 垂直移动方法只要y方向的值
//                    break;
//                }
//                default:
//                    break;
//            }
//            break;
//        }
//        case UIGestureRecognizerStateEnded:{ // 移动停止
//            // 移动结束也需要判断垂直或者平移
//            // 比如水平移动结束时，要快进到指定位置，如果这里没有判断，当我们调节音量完之后，会出现屏幕跳动的bug
//            switch (self.panDirection) {
//                case PanDirectionHorizontalMoved:{
//                    break;
//                    
//                }
//                case PanDirectionVerticalMoved:{
//                    // 垂直移动结束后，把状态改为不再控制音量
//                    self.isVolume = NO;
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        //                        self.horizontalLabel.hidden = YES;
//                    });
//                    break;
//                }
//                default:
//                    break;
//            }
//            break;
//        }
//        default:
//            break;
//    }
//}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

- (void)tapUserAvaImageView
{
    
    GLLog(@"%@",self.user.avatar);
    if (![self.user.avatar isEqualToString:@" "]) return;
    if (![self.user.avatar isEqualToString:@""]) return;
    
    CGRect rect1 = self.userAvaImageView.frame;
    
    NSMutableArray* tmp = [NSMutableArray array];
    
    //    [[LWImageBrowser alloc] initWithParentViewController:self style:LWImageBrowserAnimationStyleScale imageModels:tmp currentIndex:0];
    
    
    LWImageBrowserModel *imageModel = [[LWImageBrowserModel alloc]initWithLocalImage:[LocalDataRW getImageWithDirectory:Directory_BQ RetalivePath:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:self.user.avatar]] imageViewSuperView:self.userAvaImageView.superview positionAtSuperView:CGRectFromString(NSStringFromCGRect(rect1)) index:0];
    [tmp addObject:imageModel];
    
    LWImageBrowser* imageBrowser = [[LWImageBrowser alloc] initWithParentViewController:self style:LWImageBrowserAnimationStyleScale imageModels:tmp currentIndex:0];
    
    imageBrowser.view.backgroundColor = [UIColor blackColor];
    
    [imageBrowser show];
}

@end
