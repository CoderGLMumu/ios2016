//
//  registerSecVC.m
//  JZBRelease
//
//  Created by zjapple on 16/8/26.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "registerSecVC.h"
#import "registerBaseListVC.h"
#import "registerJobsVC.h"
#import "HXProvincialCitiesCountiesPickerview.h"

#import "LoginVC.h"
#import "SendAndGetDataFromNet.h"

#import "RecommendPersonListVC.h"
#import "AppDelegate.h"

#import "UIDevice+UIDevice_DeviceModel.h"

#import "UserFollowViewController.h"

@interface registerSecVC () <UIScrollViewDelegate>
@property (nonatomic,strong) HXProvincialCitiesCountiesPickerview *regionPickerView;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *industryLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@property (weak, nonatomic) IBOutlet UITextField *nickNameTF;
@property (weak, nonatomic) IBOutlet UITextField *companyTF;
@property (weak, nonatomic) IBOutlet UILabel *jobTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *RecommendLabel;

/** JXSIndustryArr1 */
@property (nonatomic, strong) NSMutableArray *JXSIndustryArr1;
/** ZLTIndustryArr2 */
@property (nonatomic, strong) NSMutableArray *ZLTIndustryArr2;
/** PPSIndustryArr3 */
@property (nonatomic, strong) NSMutableArray *PPSIndustryArr3;

/** networkCitys */
@property (nonatomic, strong) NSArray *networkCitys;

/** jobListDict */
@property (nonatomic, strong) NSDictionary *jobListDict;

/** industryLabel_id */
@property (nonatomic, strong) NSString *type_id;
/** industryLabel_id */
@property (nonatomic, strong) NSString *industryLabel_id;
/** 推荐人id */
@property (nonatomic, strong) NSString *pid;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;


@end

@implementation registerSecVC



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    
    NSDictionary *parameters = @{
                                 @"id":@"0",
                                 @"tree":@"0"
                                 };
    
    self.JXSIndustryArr1 = [NSMutableArray array];
    self.ZLTIndustryArr2 = [NSMutableArray array];
    self.PPSIndustryArr3 = [NSMutableArray array];
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/User/industry"] parameters:parameters success:^(id json) {
        
//        for (NSDictionary *dictT in json) {
//            NSString *name = dictT[@"name"];
//            [self.arrT addObject:name];
//        }
        // "id":1, name":"经销商", "id":2,"name":"智囊团", "id":3,"name":"品牌商",
        [self.JXSIndustryArr1 addObjectsFromArray:json[0][@"list"]];
        [self.ZLTIndustryArr2 addObjectsFromArray:json[1][@"list"]];
        [self.PPSIndustryArr3 addObjectsFromArray:json[2][@"list"]];
        
        
        NSUserDefaults *udefaults = [NSUserDefaults standardUserDefaults];
        /** 存储所有的行业 */
//        [udefaults setObject:self.arrT forKey:@"ALLIndustry"];
        
    } failure:^(NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"网络有延时,请检查网络,稍后再试"];
    }];
    
    [self downloadNetWorkCitys];
    
    [self downloadjobList];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.contentView.gls_size = CGSizeMake(self.view.glw_width, GLScreenH * 1.73);
    self.scrollView.contentSize = CGSizeMake(self.view.glw_width, GLScreenH * 1.73);
    
    if (Device_iPhone5S || Device_iPhone5) {
        self.contentView.gls_size = CGSizeMake(self.view.glw_width, GLScreenH * 1.88);
        self.scrollView.contentSize = CGSizeMake(self.view.glw_width, GLScreenH * 1.88);
    }
    
    self.scrollView.delegate = self;
}

- (void)downloadjobList
{
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/User/jobs"] parameters:nil success:^(id json) {
        
        self.jobListDict = json;
        
    } failure:^(NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"网络有延时,请检查网络,稍后再试"];
    }];
}

- (void)downloadNetWorkCitys
{
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/User/area"] parameters:nil success:^(id json) {
        
        self.networkCitys = json;
        
    } failure:^(NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"网络有延时,请检查网络,稍后再试"];
    }];
}

#pragma mark - 点击 类型 view
- (IBAction)chooseType:(UIControl *)sender {
    
    registerBaseListVC *vc = [[UIStoryboard storyboardWithName:@"registerBaseListVC" bundle:nil] instantiateInitialViewController];
    
    vc.title = @"类型";
    
    vc.cellClick = ^(NSDictionary *uid_title){
        self.typeLabel.text = uid_title.allValues[0];
        self.type_id = uid_title.allKeys[0];
        self.typeLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"212121"];
        // 给type 文本赋值
        if ([self.typeLabel.text isEqualToString:@"类型"]) {
            /** 系统占位文字颜色 */
            self.typeLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"C7C7CD"];
        }
        
        // 清空下列数据
        self.industryLabel.text = @"行业";
        self.jobTitleLabel.text = @"职位";
        self.industryLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"C7C7CD"];
        self.jobTitleLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"C7C7CD"];
        self.industryLabel_id = nil;
        
    };
                        
    vc.dataSource = @[@{@"name":@"经销商",@"id":@"1"},@{@"name":@"智囊团",@"id":@"2"},@{@"name":@"品牌厂商",@"id":@"3"}];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 点击 职位 view
- (IBAction)choosejobs:(UIControl *)sender {
    
    if (self.typeLabel.text.length <= 0 || [self.typeLabel.text isEqualToString:@"类型"]) {
        [SVProgressHUD showInfoWithStatus:@"请先选择类型"];
        return ;
    }
    
    registerJobsVC *vc = [registerJobsVC new];
    
    vc.title = @"职位";
    
    vc.cellClick = ^(NSString *str){
        self.jobTitleLabel.text = str;
        
        self.jobTitleLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"212121"];
        // 给type 文本赋值
        if ([self.jobTitleLabel.text isEqualToString:@"职位"]) {
            /** 系统占位文字颜色 */
            self.jobTitleLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"C7C7CD"];
        }
    };

    
    if ([self.type_id isEqualToString:@"1"]) {
        
        vc.dataSource = self.jobListDict[@"1"][@"list"];
        
    } else if ([self.type_id isEqualToString:@"2"]) {
    
        vc.dataSource = self.jobListDict[@"2"][@"list"];
        
    } else if ([self.type_id isEqualToString:@"3"]) {
        
        vc.dataSource = self.jobListDict[@"3"][@"list"];
    }
    
    if (vc.dataSource.count) {
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark - 点击 行业区 view
- (IBAction)chooseIndustry:(UIControl *)sender {
    
    if (self.typeLabel.text.length <= 0 || [self.typeLabel.text isEqualToString:@"类型"]) {
        [SVProgressHUD showInfoWithStatus:@"请先选择类型"];
        return ;
    }
    
    registerBaseListVC *vc = [[UIStoryboard storyboardWithName:@"registerBaseListVC" bundle:nil] instantiateInitialViewController];
    
    vc.title = @"行业";
    if ([self.typeLabel.text isEqualToString:@"经销商"]) {
        vc.VCtype = VCTypeJXS;
    }else if ([self.typeLabel.text isEqualToString:@"智囊团"]) {
        vc.VCtype = VCTypeZLT;
    }else if ([self.typeLabel.text isEqualToString:@"品牌厂商"]) {
        vc.VCtype = VCTypePPCS;
    }
    
    vc.cellClick = ^(NSDictionary *uid_title){
        self.industryLabel.text = uid_title.allValues[0];
        self.industryLabel_id = uid_title.allKeys[0];
        self.industryLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"212121"];
        if ([self.industryLabel.text isEqualToString:@"行业"]) {
            /** 系统占位文字颜色 */
            self.industryLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"C7C7CD"];
        }
    };
    
    if (self.PPSIndustryArr3.count) {
//        vc.dataSource = self.arrT;
        if ([self.typeLabel.text isEqualToString:@"经销商"]) {
            vc.dataSource = self.JXSIndustryArr1;
        }else if ([self.typeLabel.text isEqualToString:@"智囊团"]) {
            vc.dataSource = self.ZLTIndustryArr2;
        }else if ([self.typeLabel.text isEqualToString:@"品牌厂商"]) {
            vc.dataSource = self.PPSIndustryArr3;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        NSDictionary *parameters = @{
                                     @"id":@"0",
                                     @"tree":@"0"
                                     };
        
        NSMutableArray *arrT = [NSMutableArray array];
        
        [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/User/industry"] parameters:parameters success:^(id json) {
            
//            for (NSDictionary *dictT in json) {
//                NSString *name = dictT[@"name"];
//                [arrT addObject:name];
//            }
            
            [self.JXSIndustryArr1 addObjectsFromArray:json[0][@"list"]];
            [self.ZLTIndustryArr2 addObjectsFromArray:json[1][@"list"]];
            [self.PPSIndustryArr3 addObjectsFromArray:json[2][@"list"]];
            
            if ([self.typeLabel.text isEqualToString:@"经销商"]) {
                vc.dataSource = self.JXSIndustryArr1;
            }else if ([self.typeLabel.text isEqualToString:@"智囊团"]) {
                vc.dataSource = self.ZLTIndustryArr2;
            }else if ([self.typeLabel.text isEqualToString:@"品牌厂商"]) {
                vc.dataSource = self.PPSIndustryArr3;
            }
            
            [self.navigationController pushViewController:vc animated:YES];
            
        } failure:^(NSError *error) {
            [SVProgressHUD showInfoWithStatus:@"网络有延时,请检查网络,稍后再试"];
        }];
    }
    
}

#pragma mark - 点击 地区 view
- (IBAction)chooseRegion:(UIControl *)sender {
    
    NSUserDefaults *udefaults = [NSUserDefaults standardUserDefaults];
    NSString *province = [udefaults objectForKey:@"MyNowProvince"];
    NSString *city = [udefaults objectForKey:@"MyNowCity"];
    
    [self.view endEditing:YES];
    [self.regionPickerView showPickerWithProvinceName:province cityName:city countyName:nil];
    
}

#pragma mark - 点击 推荐人 view
- (IBAction)chooseRecommendPerson:(UIControl *)sender {
    
//    RecommendPersonListVC *vc = [RecommendPersonListVC new];
    
    UserFollowViewController *vc = [UserFollowViewController new];
//    [self.navigationController pushViewController:vc animated:YES];
    
    vc.cellback = ^(Users *user){
    
        self.RecommendLabel.text = user.nickname;
        
        self.pid = user.uid;
        
        self.RecommendLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"212121"];
        if ([self.RecommendLabel.text isEqualToString:@"推荐人"]) {
            /** 系统占位文字颜色 */
            self.industryLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"C7C7CD"];
        }

        
    };
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (HXProvincialCitiesCountiesPickerview *)regionPickerView {
    if (!_regionPickerView) {
        _regionPickerView = [[HXProvincialCitiesCountiesPickerview alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        if (self.networkCitys) {
            _regionPickerView.networkCitys = self.networkCitys;
        }else {
            [self downloadNetWorkCitys];
        }
        
        __weak typeof(self) wself = self;
        _regionPickerView.completion = ^(NSString *provinceName,NSString *cityName,NSString *countyName) {
            __strong typeof(wself) self = wself;
            
            [self.cityLabel setText:[NSString stringWithFormat:@"%@ %@",provinceName,cityName]];
            self.cityLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"212121"];
            
//            if (cityName.length) {
//                
//            }
            
        };
        [self.view addSubview:_regionPickerView];
    }
    return _regionPickerView;
}

- (IBAction)loadRegister:(UIButton *)sender {
    
//    self.mobile = @"18278360000";
//    self.password = @"123456";
//    self.repassword = self.password;
    
    if (self.nickNameTF.text.length <= 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入姓名"];
        return ;
    }
    
    if (self.companyTF.text.length <= 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入公司"];
        return ;
    }
    
    if (self.typeLabel.text.length <= 0 || [self.typeLabel.text isEqualToString:@"类型"]) {
        [SVProgressHUD showInfoWithStatus:@"请选择类型"];
        return ;
    }
    
    if (self.jobTitleLabel.text.length <= 0 || [self.jobTitleLabel.text isEqualToString:@"职位"]) {
        [SVProgressHUD showInfoWithStatus:@"请选择职位"];
        return ;
    }
    
    if (self.industryLabel.text.length <= 0 || [self.industryLabel.text isEqualToString:@"行业"] || self.industryLabel_id == nil) {
        [SVProgressHUD showInfoWithStatus:@"请选择行业"];
        return ;
    }
    
    if (self.cityLabel.text.length <= 0 || [self.cityLabel.text isEqualToString:@"地区"]) {
        [SVProgressHUD showInfoWithStatus:@"请选择地区"];
        return ;
    }
    
//    [SVProgressHUD showProgress:<#(float)#> status:<#(NSString *)#>]
    
//    注册测试
//    接口：/Web/user/registe
//    参数：mobile,password,repassword,type,industry_id,company,job,nickname,area,avatar_id
    
    HttpBaseRequestItem *item = [HttpBaseRequestItem new];
    item.mobile = self.mobile;
    item.password = self.password;
    item.repassword = self.repassword;
    item.type = self.type_id;
    item.industry_id = self.industryLabel_id;
    item.company = self.companyTF.text;
    item.job = self.jobTitleLabel.text;
    item.nickname = self.nickNameTF.text;
    item.area = self.cityLabel.text;
    item.pid = self.pid;
    
    item.status = @"0";
    
    AppDelegate *appD = (AppDelegate*)[UIApplication sharedApplication].delegate;

    
   // if (appD.checkpay) {
        
        item.status = @"0";
        
    //}else {
        
        // 不需要填写推荐人 注册成功
        
      //  item.status = @"1";
  //  }
    
    NSDictionary *parameters = item.mj_keyValues;
    
//    NSDictionary *parameters = @{
//                                 @"mobile":self.mobile,
//                                 @"password":self.password,
//                                 @"repassword":self.repassword,
//                                 @"type":self.type_id,
//                                 @"industry_id":self.industryLabel_id,
//                                 @"company":self.companyTF.text,
//                                 @"job":self.jobTitleLabel.text,
//                                 @"nickname":self.nickNameTF.text,
//                                 @"area":self.cityLabel.text,
//                                 @"pid":self.pid
////                                 @"avatar_id":@""
//                                 };
    /** 开始注册账号 */
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/user/registe"] parameters:parameters success:^(id json) {
        
        if ([json[@"state"] isEqual:@(0)]) {
            
            [SVProgressHUD showInfoWithStatus:json[@"info"]];
            
        }else if ([json[@"state"] isEqual:@(1)]) {
            
            self.loginVC.passwordTF.text = self.password;
            self.loginVC.usernameTF.text = self.mobile;
            
            [self dismissViewControllerAnimated:YES completion:^{
//                [self.loginVC loginBtnSender];
                
                [SVProgressHUD showInfoWithStatus:json[@"info"]];
                
            }];
        }

    } failure:^(NSError *error) {
        
        if (error) {
//            [SVProgressHUD showInfoWithStatus:error.description];
            [SVProgressHUD showInfoWithStatus:@"网络不通,请检查自己的网络或者联系我们"];
        }
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
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
