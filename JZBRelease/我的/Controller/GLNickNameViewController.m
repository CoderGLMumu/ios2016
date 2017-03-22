//
//  GLNickNameViewController.m
//  huanxinFullDemo
//
//  Created by zjapple on 16/7/26.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "GLNickNameViewController.h"
#import "HttpToolSDK.h"
#import "SVProgressHUD.h"
#import "GetUserInfoModel.h"
#import "LoginVM.h"
#import "SendAndGetDataFromNet.h"

#import "CuiPickerView.h"

@interface GLNickNameViewController ()<UITextFieldDelegate,CuiPickViewDelegate,UITextViewDelegate>
@property (weak, nonatomic) UITextField *nickNameLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTFConstraintsHeight;
@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (weak, nonatomic) IBOutlet UITextView *titleTV;

@property (nonatomic, strong) CuiPickerView *cuiPickerView;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

/** 上传参数 field */
@property (nonatomic, strong) NSString *field;

//@property (nonatomic, strong) UILabel *uilabel;

@end

@implementation GLNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tipLabel.hidden = YES;
    
    self.titleTF.delegate = self;
    self.titleTV.delegate = self;
    
    if ([self.VCtitle isEqualToString:@"生日"]) {
        _cuiPickerView = [[CuiPickerView alloc]init];
        _cuiPickerView.isEditBirthday = YES;
        _cuiPickerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200);
        
        //这一步很重要
        _cuiPickerView.myTextField = self.titleTF;
        _cuiPickerView.isBirthday = YES;
        
        _cuiPickerView.delegate = self;
        _cuiPickerView.curDate=[NSDate date];
        [self.view addSubview:_cuiPickerView];
    
    }else {
        [self.nickNameLabel becomeFirstResponder];
    }
    
    self.title = self.VCtitle;
    
    self.nickNameLabel.text = self.info;
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
    self.navigationItem.rightBarButtonItem = left;
    
//    updatenickName
    [self setupSaveInfo];
    
}

- (void)textViewDidChange:(UITextView *)textView {
    NSInteger number = [textView.text length];
    if (number > 50) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"字符个数不能大于50" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        textView.text = [textView.text substringToIndex:50];
        number = 50;
        
    }
//    self.statusLabel.text = [NSString stringWithFormat:@"%ld/128",(long)number];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_cuiPickerView showInView:self.view];
}

- (void)setupSaveInfo
{
    
    if ([self.title isEqualToString:@"姓名"]) {
        self.field = @"nickname";
    }else if ([self.title isEqualToString:@"公司"]) {
        self.field = @"company";
    }else if ([self.title isEqualToString:@"公司服务"] || [self.title isEqualToString:@"公司规模"]) {
        self.field = @"company_gm";
    }else if ([self.title isEqualToString:@"员工数量"]) {
        self.field = @"company_num";
        [self setupInputIsNum];
    }else if ([self.title isEqualToString:@"品牌名称"]) {
        self.field = @"brand";
    }else if ([self.title isEqualToString:@"门店数量"]) {
        self.field = @"shop_num";
        [self setupInputIsNum];
    }else if ([self.title isEqualToString:@"兴趣爱好"]) {
        self.field = @"interest";
    }else if ([self.title isEqualToString:@"职位"]) {
        self.field = @"job";
    }else if ([self.title isEqualToString:@"所在地"]) {
//                [self setupWeiZi];
        self.field = @"address";
    }else if ([self.title isEqualToString:@"通信地址"]) {
        //        [self setupWeiZi];
        self.field = @"address2";
    }else if ([self.title isEqualToString:@"生日"]) {
        self.field = @"birthday";
    }else if ([self.title isEqualToString:@"手机号"]) {
        self.field = @"mobile";
    }else if ([self.title isEqualToString:@"微信号"]) {
        self.field = @"wechat";
    }else if ([self.title isEqualToString:@"邮箱"]) {
        self.field = @"email";
    }else if ([self.title isEqualToString:@"主营"]) {
        self.field = @"business";
    }else if ([self.title isEqualToString:@"擅长领域"]) {
        self.field = @"pain";
    }else if ([self.title isEqualToString:@"我的需求"]) {
        self.field = @"signature";
        self.titleTFConstraintsHeight.constant = 100;
        self.titleTF.hidden = YES;
        self.titleTV.hidden = NO;
        self.titleTV.text = self.info;
    }else if ([self.title isEqualToString:@"经营痛点"]) {
        self.field = @"pain";
        self.titleTFConstraintsHeight.constant = 100;
        self.titleTF.hidden = YES;
        self.titleTV.hidden = NO;
        self.titleTV.text = self.info;
        
        //其次在UITextView上面覆盖个UILable,UILable设置为全局变量。
//        self.uilabel = [UILabel new];
//        self.uilabel.frame =CGRectMake(17, 8, self.view.bounds.size.width -20 , 20);
//        self.uilabel.text = @"输入内容现在50字内...";
//        self.uilabel.enabled = NO;//lable必须设置为不可用
//        self.uilabel.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
//        self.uilabel.backgroundColor = [UIColor clearColor];
//        [self.view addSubview:self.uilabel];
        
        self.tipLabel.hidden = NO;
        
    }else if ([self.title isEqualToString:@"个人简介"]) {
        self.field = @"teacher_desc";
        self.titleTFConstraintsHeight.constant = 100;
        self.titleTF.hidden = YES;
        self.titleTV.hidden = NO;
        self.titleTV.text = self.info;
        
        self.tipLabel.hidden = NO;
    }
}

- (void)setupInputIsNum
{
    self.nickNameLabel.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)setupWeiZi
{
    
    self.nickNameLabel.delegate = self;
    self.nickNameLabel.textAlignment = NSTextAlignmentCenter;
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [self.nickNameLabel.pickV selectRow:self.nickNameLabel.ProvinceIndex inComponent:self.nickNameLabel.CityIndex animated:NO];
    //    });
}

- (void)save:(UIButton *)sender
{
    //    保存信息
    //    接口：/Web/user/update
    //    参数：access_token，field,value
    //    field = (nicknname,sex,avatar,mobile,email,job,industry,company,signature,birthday)
    //    返回：
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *access_token = [defaults stringForKey:@"access_token"];
    
    GetUserInfoModel *model = [[GetUserInfoModel alloc]init];
    model.access_token = [[LoginVM getInstance] readLocal].token;
    
    if (!self.field) {
        [SVProgressHUD showErrorWithStatus:@"不能保存233"];
        return;
    }
    
    if (![self.titleTV.text isEqualToString:@""]) {
        self.nickNameLabel.text = self.titleTV.text;
    }
    
    NSDictionary *parameters = @{
                                 @"access_token":model.access_token,
                                 @"field":self.field,
                                 @"value":self.nickNameLabel.text
                                 };
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/user/update"] parameters:parameters success:^(id json) {
        
        if (![json[@"state"] isEqual:@(0)]){
            
            if (self.updatenickName) {
                self.updatenickName(self.nickNameLabel.text);
            }
            
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [SVProgressHUD showSuccessWithStatus:@"完善资料，增加积分 +2"];
                [Toast makeShowCommen:@"成功," ShowHighlight:@"完善资料" HowLong:0.8];
            });
            
        }else{
            if (json[@"error"]) {
                [SVProgressHUD showErrorWithStatus:@"登录过期,请重新登录"];
            }
            [SVProgressHUD showErrorWithStatus:json[@"info"]];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"-网络错误-"];
    }];
}

//是否允许
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([self.VCtitle isEqualToString:@"生日"]) {
        [_cuiPickerView showInView:self.view];
    }
    if ([self.VCtitle isEqualToString:@"生日"]) {
        return NO;
    }
    return YES;
}

//开始编辑时调用
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    //    NSLog(@"%s",__func__);
    if ([self.VCtitle isEqualToString:@"生日"]) {
        [_cuiPickerView showInView:self.view];
    }
}


//是否允许结束编辑
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

//当结束编辑时调用
- (void)textFieldDidEndEditing:(UITextField *)textField {
    //    NSLog(@"%s",__func__);
}

//是否允许改变文本的内容
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([self.VCtitle isEqualToString:@"生日"]) {
        return NO;
    }
    return YES;
}


#pragma mark - CuiPickViewDelegate 日期选择器的代理
/** 点击 选择器上面的确定按钮调用 */
- (void)didFinishPickView:(NSString*)date
{
    self.titleTF.text = [date substringToIndex:10];
}

- (void)pickerviewbuttonclick:(UIButton *)sender
{

}

- (void)hiddenPickerView
{

}


@end
