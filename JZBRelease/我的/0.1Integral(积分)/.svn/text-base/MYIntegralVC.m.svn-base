//
//  MYIntegralVC.m
//  JZBRelease
//
//  Created by zjapple on 16/8/1.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "MYIntegralVC.h"

#import "HttpToolSDK.h"
#import "Users.h"
#import "UserInfo.h"
#import "GetUserInfoModel.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "AddHostToLoadPIC.h"
#import "SendAndGetDataFromNet.h"

@interface MYIntegralVC ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *UserNameWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ChengHuWidth;
@property (weak, nonatomic) IBOutlet UILabel *chengHuLabel;
@property (weak, nonatomic) IBOutlet UILabel *UserNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userPic;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;



/** user */
@property (nonatomic, strong) Users *users;

@end

@implementation MYIntegralVC

- (Users *)users
{
    if (_users == nil) {
        _users = [[Users alloc] init];
    }
    return _users;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userPic.layer.cornerRadius = self.userPic.frame.size.width * 0.5;
    self.userPic.clipsToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.tabBarController.tabBar setHidden:YES];
    
    
    /** 获取个人信息 */
    //    获取用户信息
    //    接口：/Web/user/info
    //    参数：access_token,uid(0:表示获取自己的信息)
    //    返回：用户信息，例如（{"state":1,"info":"","data":{"nickname":"rink00","sex":"0","userid":"","avatar":"","mobile":"","birthday":"0000-00-00","signature":"","address":"","company":"","score":"0","frozen_score":"0","level":"\u96f6\u7ea7"}}）
    GetUserInfoModel *model = [[GetUserInfoModel alloc]init];
    model.access_token = [[LoginVM getInstance] readLocal].token;
    NSLog(@"access_token%@",model.access_token);
    NSDictionary *parameters = @{
                                 @"access_token":model.access_token,
                                 @"uid":@"0"
                                 };
    
    //    NSLog(@"parameters = %@",parameters);
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/user/info"] parameters:parameters success:^(id json) {
        
        if ([json[@"state"] isEqual:@(0)]) {
            [SVProgressHUD showInfoWithStatus:@"网络不顺,稍后再试"];
            return ;
        }
        //        self.glPersonInfo = [GLPersonInfo mj_objectWithKeyValues:json[@"data"]];
        self.users = [Users mj_objectWithKeyValues:json[@"data"]];
        
        if (self.users) {
            self.UserNameLabel.text = self.users.nickname;
            self.chengHuLabel.text = [NSString stringWithFormat:@"%@%@",self.users.company,self.users.job];
            self.scoreLabel.text = self.users.score;
//            [self.userPic sd_setImageWithURL:[NSURL URLWithString:[AddHostToLoadPIC AddHostToLoadPICWithString:self.users.avatar]] placeholderImage:[UIImage imageNamed:@"ZCCG_TX"]];
            
            [LocalDataRW getImageWithDirectory:Directory_WD RetalivePath:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:self.users.avatar] WithContainerImageView:self.userPic];

        }
    } failure:^(NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"网络不顺,稍后再试"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.UserNameLabel sizeToFit];
    self.UserNameWidth.constant = self.UserNameLabel.frame.size.width;
    [self.chengHuLabel sizeToFit];
    self.ChengHuWidth.constant = self.chengHuLabel.frame.size.width;
    if (self.chengHuLabel.frame.size.width < self.scoreLabel.glw_width) {
        self.ChengHuWidth.constant = self.scoreLabel.glw_width;
    }
}

- (IBAction)ClickChongZhiBtn:(UIButton *)sender {
    
    
}

- (IBAction)ClickDuiHuanBtn:(UIButton *)sender {
    
}


@end
