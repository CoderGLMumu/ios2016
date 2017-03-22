//
//  PersonalInformationViewController.m
//  huanxinFullDemo
//
//  Created by zjapple on 16/7/26.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "PersonalInformationViewController.h"
#import "HttpToolSDK.h"
#import "SVProgressHUD.h"
#import "MJExtension.h"
//#import "GLPersonInfo.h"
#import "LoginVM.h"
#import "Users.h"
#import "GetUserInfoModel.h"
#import "UIImageView+WebCache.h"

#import "GLNickNameViewController.h"

#import "DataBaseHelperSecond.h"
#import "SendAndGetDataFromNet.h"

#import "HXProvincialCitiesCountiesPickerview.h"
#import "registerJobsVC.h"

@interface PersonalInformationViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property (nonatomic,strong) HXProvincialCitiesCountiesPickerview *regionPickerView;
/** networkCitys */
@property (nonatomic, strong) NSArray *networkCitys;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;

@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobLabel;
//@property (weak, nonatomic) IBOutlet UILabel *businessLabel;
@property (weak, nonatomic) IBOutlet UILabel *wechatLabel;

@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *interestLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
//@property (weak, nonatomic) IBOutlet UILabel *chatLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *WDrequireLabel;

@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel2;
@property (weak, nonatomic) IBOutlet UILabel *company_gmLabel;
@property (weak, nonatomic) IBOutlet UILabel *company_numLabel;
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (weak, nonatomic) IBOutlet UILabel *shop_numLabel;
@property (weak, nonatomic) IBOutlet UILabel *painLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacher_descLabel;


@property(nonatomic, strong) UIImageView *img;
@property(nonatomic, strong) NSData *fileData;

/** 上传参数 field */
@property (nonatomic, strong) NSString *field;
/** 上传参数 value */
@property (strong, nonatomic) NSString *value;

/** GLPersonInfo */
//@property (nonatomic, strong) GLPersonInfo *glPersonInfo;
/** user */
@property (nonatomic, strong) Users *users;

@property (strong, nonatomic)  UILabel *numAddressL;

@property (strong, nonatomic)  UILabel *addressL;

@property (strong, nonatomic)  UILabel *addressL_first;

/** jobListDict */
@property (nonatomic, strong) NSDictionary *jobListDict;

@end

@implementation PersonalInformationViewController

- (Users *)users
{
    if (_users == nil) {
        _users = [[Users alloc] init];
    }
    return _users;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self downloadNetWorkCitys];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 12, 0);
    
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width * 0.5;
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.contentMode =  UIViewContentModeScaleAspectFit;
    
//    self.title = @"个人资料";
    self.title = @"编辑";
    
    if (![self.MyPrelocal isEqualToString:@"0"]) {
        self.addressLabel.text = self.MyPrelocal;
    }
    
    self.users.address = self.MyPrelocal;
    
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"PersonInfoCell"];
    
    [self downloadData];
    
    [self setupLocationLabel];
    
    [self downloadjobList];
}

- (void)downloadData
{
    /** 获取个人信息 */
    //    获取用户信息
    //    接口：/Web/user/info
    //    参数：access_token,uid(0:表示获取自己的信息)
    //    返回：用户信息，例如（{"state":1,"info":"","data":{"nickname":"rink00","sex":"0","userid":"","avatar":"","mobile":"","birthday":"0000-00-00","signature":"","address":"","company":"","score":"0","frozen_score":"0","level":"\u96f6\u7ea7"}}）
    GetUserInfoModel *model = [[GetUserInfoModel alloc]init];
    model.access_token = [[LoginVM getInstance] readLocal].token;
    
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
//      login_user 改成了 ZCCG_TX
//        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[AddHostToLoadPIC AddHostToLoadPICWithString:self.users.avatar]] placeholderImage:[UIImage imageNamed:@"ZCCG_TX"]];

        [LocalDataRW getImageWithDirectory:Directory_WD RetalivePath:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:self.users.avatar] WithContainerImageView:self.avatarImageView];
        
//        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:self.users.avatar]] placeholderImage:[UIImage imageNamed:@"ZCCG_TX"]];
        
        if (self.users) {
            self.nicknameLabel.text = self.users.nickname;
            self.companyLabel.text = self.users.company;
            self.jobLabel.text = self.users.job;
            self.birthdayLabel.text = self.users.birthday;
            self.mobileLabel.text = self.users.mobile;
            self.users.address = self.MyPrelocal;
            self.emailLabel.text = self.users.email;
//            self.businessLabel.text = self.users.business;
            self.wechatLabel.text = self.users.wechat;
            self.WDrequireLabel.text = self.users.signature;
            self.addressLabel.text = self.users.address;
            self.addressLabel2.text = self.users.address2;
            self.interestLabel.text = self.users.interest;
            self.company_gmLabel.text = self.users.company_gm;
            self.company_numLabel.text = self.users.company_num;
            self.shop_numLabel.text = self.users.shop_num;
            self.brandLabel.text = self.users.brand;
            self.painLabel.text = self.users.pain;
            self.teacher_descLabel.text = self.users.teacher_desc;
            
            /** 缓存 */
//            self.users.avatar = self.users.avatar];
            
            if (![self.users.sex isEqualToString:@"0"]) {
                self.sexLabel.text = self.users.sex;
//                self.addressLabel.text = self.glPersonInfo.address;
                self.sexLabel.text = @"男";
            }else{
                self.sexLabel.text = @"女";
//                self.addressLabel.text = @" ";
            }
        }
//        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - 缓存数据库
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    /** 缓存数据库 */
    DataBaseHelperSecond *db = [DataBaseHelperSecond getInstance];
    [db initDataBaseDB];
    if (self.users.uid != nil) {
        
        [db delteModelFromTabel:self.users];
//        [db delteTable:self.users];
        if ([db isExistInTable:self.users]) {
           [db createTabel:self.users];
        }
//
        [db insertModelToTabel:self.users];
        
        self.users = (Users *)[db getModelFromTabel:self.users];
    }
}

#pragma mark -
#pragma UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([actionSheet.title isEqualToString:@"性别"]) {
        if (buttonIndex == 0) {
            self.value = @"1";
            self.sexLabel.text = @"男";
        }else if (buttonIndex == 1) {
            self.value = @"0";
            self.sexLabel.text = @"女";
        }
        self.field = @"sex";
        self.users.sex = self.value;
        [self uploadData];
    }else{
        switch (buttonIndex) {
            case 1://照相机
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
                break;
            case 0://本地相簿
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
                break;
            default:
                break;
        }
    }
}

- (void)uploadData
{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *access_token = [defaults stringForKey:@"access_token"];
    
    if (!self.value) return;
    
    GetUserInfoModel *model = [[GetUserInfoModel alloc]init];
    model.access_token = [[LoginVM getInstance] readLocal].token;
    
    NSDictionary *parameters = @{
                                 @"access_token":model.access_token,
                                 @"field":self.field,
                                 @"value":self.value
                                 };
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/user/update"] parameters:parameters success:^(id json) {
        
        if (![json[@"state"] isEqual:@(0)]){
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        }else{
            [SVProgressHUD showErrorWithStatus:@"网络错误"];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showSuccessWithStatus:@"-网络错误-"];
    }];
}

#pragma mark -
#pragma UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
        [self performSelector:@selector(saveImage:)  withObject:img afterDelay:0.5];
    }
    else if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeMovie]) {
        NSString *videoPath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        self.fileData = [NSData dataWithContentsOfFile:videoPath];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage:(UIImage *)image {
    //    NSLog(@"保存头像！");
    //    [userPhotoButton setImage:image forState:UIControlStateNormal];
    BOOL success;
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSError *error;
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
////    NSLog(@"imageFile->>%@",imageFilePath);
//    success = [fileManager fileExistsAtPath:imageFilePath];
//    if(success) {
//        success = [fileManager removeItemAtPath:imageFilePath error:&error];
//    }
    //    UIImage *smallImage=[self scaleFromImage:image toSize:CGSizeMake(80.0f, 80.0f)];//将图片尺寸改为80*80
    UIImage *smallImage = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(650, 650)];
    
//    [UIImageJPEGRepresentation(smallImage, 1.0f) writeToFile:imageFilePath atomically:YES];//写入文件
//    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件
    //    [userPhotoButton setImage:selfPhoto forState:UIControlStateNormal];
    //    self.img.image = selfPhoto;
//    self.personView.avatarImageView.image = selfPhoto;
    if (self.updataavatarImageView) {
        self.updataavatarImageView(smallImage);
    }
    
    self.avatarImageView.image = smallImage;
    [self uploadImg:smallImage];
}

- (void)saveImg:(UIImage *)img
{
    
}

- (void)uploadImg:(UIImage *)img
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
    
    NSData *data = UIImagePNGRepresentation(img);
    
    //    NSData *imageData = UIImageJPEGRepresentation(img, 1.0);
    
    //添加要上传的文件，此处为图片
    
    //    [formData appendPartWithFileData:imageData name:@"file(看上面接口，服务器放图片的参数名Key）" fileName:@"图片名字(随便写一个，（注意后缀名）如果是UIImagePNGRepresentation写XXXX.png,如果是UIImageJPEGRepresentation写XXXX.jpeg)"mimeType:@"文件类型（此处为图片格式，如image/jpeg，对应前面的PNG/JPEG）"];
    
    // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
    // 要解决此问题，
    // 可以在上传时使用当前的系统事件作为文件名
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
    
    FromData * fromData = [FromData new];
    fromData.data = data;
    fromData.name = @"value";
    fromData.filename = fileName;
    fromData.mimeType = @"image/png";
    
    NSArray *dataArr = @[fromData];
    
    NSDictionary *parameters = @{
                                 @"access_token":model.access_token,
                                 @"field":@"avatar",
                                 @"value":data
                                 };
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/user/update"] parameters:parameters fromDataArray:dataArr success:^(id json) {
//        NSLog(@"json= %@",json);
        if (![json[@"state"] isEqual:@(0)]){
            
//            self.users.avatar = [AddHostToLoadPIC AddHostToLoadPICWithString:json[@"data"]];
            self.users.avatar = json[@"data"];
            
        }else{
            [SVProgressHUD showSuccessWithStatus:@"图片错误"];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showSuccessWithStatus:@"图片错误"];
    }];
}

// 改变图像的尺寸，方便上传服务器
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//2.保持原来的长宽比，生成一个缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 39)];
    
    [headerView setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f8f8f8"]];
    
    if (section == 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, tableView.bounds.size.width - 10, 18)];
        label.glcy_centerY = headerView.glcy_centerY;
        label.text = @"基本信息";
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor hx_colorWithHexRGBAString:@"bdbdbd"];
        label.backgroundColor = [UIColor clearColor];
        
        [headerView addSubview:label];

    }
    
    if (self.isZLT) {
        if (section == 4) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, tableView.bounds.size.width - 10, 18)];
            label.glcy_centerY = headerView.glcy_centerY;
            label.text = @"公司信息";
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = [UIColor hx_colorWithHexRGBAString:@"bdbdbd"];
            label.backgroundColor = [UIColor clearColor];
            
            [headerView addSubview:label];
            
        }
    }else {
        if (section == 2) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, tableView.bounds.size.width - 10, 18)];
            label.glcy_centerY = headerView.glcy_centerY;
            label.text = @"公司信息";
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = [UIColor hx_colorWithHexRGBAString:@"bdbdbd"];
            label.backgroundColor = [UIColor clearColor];
            
            [headerView addSubview:label];
            
        }
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 60;
    }
    
//    else if (indexPath.section == 0 && indexPath.row == 7) {
//        return 76;
//    }
    
    if (self.isZLT) {
        if (indexPath.section == 2 && indexPath.row == 0) {
            return 76;
        }else if (indexPath.section == 3 && indexPath.row == 0){
            return 145;
        }
    }else{
        if (indexPath.section == 3 && indexPath.row == 0) {
            return 88;
        }
    }
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 39;
    }
    
    if (self.isZLT) {
        if (section == 4) {
            return 39;
        }
    }else {
        if (section == 2) {
            return 39;
        }
    }
    
    return 14;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"基本信息";
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

#pragma mark - tableView代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"请选择文件来源"
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"从相册中选择",@"拍照",nil];
        actionSheet.title = @"更改头像";
        
        [actionSheet showInView:self.view];
    }else if (indexPath.section == 0 && indexPath.row == 1) {
        GLNickNameViewController *nickNameVC = [GLNickNameViewController new];
        nickNameVC.updatenickName = ^(NSString *nickName){
            self.nicknameLabel.text = nickName;
            
            if (self.updatenickName) {
                self.updatenickName(nickName);
            }
            
            self.users.nickname = nickName;
        };
        nickNameVC.VCtitle = @"姓名";
        nickNameVC.info = self.nicknameLabel.text;
        [self.navigationController pushViewController:nickNameVC animated:YES];
    }else if (indexPath.section == 0 && indexPath.row == 2) {
        /** 性别 */
        UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"性别"
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"男",@"女",nil];
        
        [actionSheet showInView:self.view];
    }else if (indexPath.section == 0 && indexPath.row == 3) {
        GLNickNameViewController *nickNameVC = [GLNickNameViewController new];
            nickNameVC.updatenickName = ^(NSString *nickName){
                self.interestLabel.text = nickName;
                self.users.interest = nickName;
            };
        nickNameVC.VCtitle = @"兴趣爱好";
        nickNameVC.info = self.interestLabel.text;
        [self.navigationController pushViewController:nickNameVC animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 0) {
//        GLNickNameViewController *nickNameVC = [GLNickNameViewController new];
//        nickNameVC.updatenickName = ^(NSString *nickName){
//            self.mobileLabel.text = nickName;
//            self.users.mobile = nickName;
//        };
//        nickNameVC.VCtitle = @"手机号";
//        nickNameVC.info = self.mobileLabel.text;
//        [self.navigationController pushViewController:nickNameVC animated:YES];
        
        GLNickNameViewController *nickNameVC = [GLNickNameViewController new];
        nickNameVC.updatenickName = ^(NSString *nickName){
            self.wechatLabel.text = nickName;
            self.users.wechat = nickName;
        };
        nickNameVC.VCtitle = @"微信号";
        nickNameVC.info = self.wechatLabel.text;
        [self.navigationController pushViewController:nickNameVC animated:YES];
        
    }else if (indexPath.section == 1 && indexPath.row == 1) {
        [self chooseRegion];
    }else if (indexPath.section == 1 && indexPath.row == 2) {
        
        
        
//        GLNickNameViewController *nickNameVC = [GLNickNameViewController new];
//        nickNameVC.updatenickName = ^(NSString *nickName){
//            self.addressLabel.text = nickName;
//            self.users.address = nickName;
//        };
//        nickNameVC.VCtitle = @"所在地";
//        nickNameVC.info = self.addressLabel.text;
//        [self.navigationController pushViewController:nickNameVC animated:YES];
    }
    
    if (self.isZLT) {
        if (indexPath.section == 2 && indexPath.row == 0) {
            GLNickNameViewController *nickNameVC = [GLNickNameViewController new];
            nickNameVC.updatenickName = ^(NSString *nickName){
                self.painLabel.text = nickName;
                self.users.pain = nickName;
            };
            nickNameVC.VCtitle = @"擅长领域";
            nickNameVC.info = self.painLabel.text;
            [self.navigationController pushViewController:nickNameVC animated:YES];
        }else if (indexPath.section == 3 && indexPath.row == 0) {
            GLNickNameViewController *nickNameVC = [GLNickNameViewController new];
            nickNameVC.updatenickName = ^(NSString *nickName){
                self.teacher_descLabel.text = nickName;
                self.users.teacher_desc = nickName;
            };
            nickNameVC.VCtitle = @"个人简介";
            nickNameVC.info = self.teacher_descLabel.text;
            [self.navigationController pushViewController:nickNameVC animated:YES];
        }else if (indexPath.section == 4 && indexPath.row == 0) {
            GLNickNameViewController *nickNameVC = [GLNickNameViewController new];
            nickNameVC.updatenickName = ^(NSString *nickName){
                self.companyLabel.text = nickName;
                self.users.company = nickName;
            };
            nickNameVC.VCtitle = @"公司";
            nickNameVC.info = self.companyLabel.text;
            [self.navigationController pushViewController:nickNameVC animated:YES];
        }else if (indexPath.section == 4 && indexPath.row == 1) {
//            GLNickNameViewController *nickNameVC = [GLNickNameViewController new];
//            nickNameVC.updatenickName = ^(NSString *nickName){
//                self.jobLabel.text = nickName;
//                self.users.job = nickName;
//            };
//            nickNameVC.VCtitle = @"职位";
//            nickNameVC.info = self.jobLabel.text;
//            [self.navigationController pushViewController:nickNameVC animated:YES];
            
            
            registerJobsVC *vc = [registerJobsVC new];
            
            vc.title = @"职位";
            
            vc.cellClick = ^(NSString *str){
                self.jobLabel.text = str;
                self.users.job = self.jobLabel.text;
                
                HttpBaseRequestItem *item = [HttpBaseRequestItem new];
                item.access_token = [LoginVM getInstance].readLocal.token;
                item.field = @"job";
                item.value = self.jobLabel.text;
                NSDictionary *parameters = item.mj_keyValues;
                
                [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/user/update"] parameters:parameters success:^(id json) {
                    
                    if (![json[@"state"] isEqual:@(0)]){
                        
                        
                        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
//                        [self.navigationController popViewControllerAnimated:YES];
                        
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
                
            };
            
            NSString *type = self.users.type;
            // 修改职位需要通过type判断，指定职位
            if ([type isEqualToString:@"1"]) {
                
                vc.dataSource = self.jobListDict[@"1"][@"list"];
                
            } else if ([type isEqualToString:@"2"]) {
                
                vc.dataSource = self.jobListDict[@"2"][@"list"];
                
            } else if ([type isEqualToString:@"3"]) {
                
                vc.dataSource = self.jobListDict[@"3"][@"list"];
            }
            
            if (vc.dataSource.count) {
                [self.navigationController pushViewController:vc animated:YES];
            }

        }else if (indexPath.section == 4 && indexPath.row == 2) {
            GLNickNameViewController *nickNameVC = [GLNickNameViewController new];
            nickNameVC.updatenickName = ^(NSString *nickName){
                self.company_gmLabel.text = nickName;
                self.users.company_gm = nickName;
            };
            nickNameVC.VCtitle = @"公司服务";
            nickNameVC.info = self.company_gmLabel.text;
            [self.navigationController pushViewController:nickNameVC animated:YES];
        }else if (indexPath.section == 4 && indexPath.row == 3) {
//            GLNickNameViewController *nickNameVC = [GLNickNameViewController new];
//            nickNameVC.updatenickName = ^(NSString *nickName){
//                self.company_numLabel.text = nickName;
//                self.users.company_num = nickName;
//            };
//            nickNameVC.VCtitle = @"员工数量";
//            nickNameVC.info = self.company_numLabel.text;
//            [self.navigationController pushViewController:nickNameVC animated:YES];
        }else if (indexPath.section == 4 && indexPath.row == 4) {
//            GLNickNameViewController *nickNameVC = [GLNickNameViewController new];
//            nickNameVC.updatenickName = ^(NSString *nickName){
//                self.addressLabel2.text = nickName;
//                self.users.address2 = nickName;
//            };
//            nickNameVC.VCtitle = @"通信地址";
//            nickNameVC.info = self.addressLabel2.text;
//            [self.navigationController pushViewController:nickNameVC animated:YES];
        }
    }else{
        if (indexPath.section == 2 && indexPath.row == 0) {
            GLNickNameViewController *nickNameVC = [GLNickNameViewController new];
            nickNameVC.updatenickName = ^(NSString *nickName){
                self.companyLabel.text = nickName;
                self.users.company = nickName;
            };
            nickNameVC.VCtitle = @"公司";
            nickNameVC.info = self.companyLabel.text;
            [self.navigationController pushViewController:nickNameVC animated:YES];
        }else if (indexPath.section == 2 && indexPath.row == 1) {
            //            GLNickNameViewController *nickNameVC = [GLNickNameViewController new];
            //            nickNameVC.updatenickName = ^(NSString *nickName){
            //                self.jobLabel.text = nickName;
            //                self.users.job = nickName;
            //            };
            //            nickNameVC.VCtitle = @"职位";
            //            nickNameVC.info = self.jobLabel.text;
            //            [self.navigationController pushViewController:nickNameVC animated:YES];
            
            
            registerJobsVC *vc = [registerJobsVC new];
            
            vc.title = @"职位";
            
            vc.cellClick = ^(NSString *str){
                self.jobLabel.text = str;
                self.users.job = self.jobLabel.text;
                
                HttpBaseRequestItem *item = [HttpBaseRequestItem new];
                item.access_token = [LoginVM getInstance].readLocal.token;
                item.field = @"job";
                item.value = self.jobLabel.text;
                NSDictionary *parameters = item.mj_keyValues;
                
                [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/user/update"] parameters:parameters success:^(id json) {
                    
                    if (![json[@"state"] isEqual:@(0)]){
                        
                        
                        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
//                        [self.navigationController popViewControllerAnimated:YES];
                        
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

            };
            
            NSString *type = self.users.type;
            // 修改职位需要通过type判断，指定职位
            if ([type isEqualToString:@"1"]) {
                
                vc.dataSource = self.jobListDict[@"1"][@"list"];
                
            } else if ([type isEqualToString:@"2"]) {
                
                vc.dataSource = self.jobListDict[@"2"][@"list"];
                
            } else if ([type isEqualToString:@"3"]) {
                
                vc.dataSource = self.jobListDict[@"3"][@"list"];
            }
            
            if (vc.dataSource.count) {
                [self.navigationController pushViewController:vc animated:YES];
            }
        
            
        }else if (indexPath.section == 2 && indexPath.row == 2) {
            GLNickNameViewController *nickNameVC = [GLNickNameViewController new];
            nickNameVC.updatenickName = ^(NSString *nickName){
                self.company_gmLabel.text = nickName;
                self.users.company_gm = nickName;
            };
            nickNameVC.VCtitle = @"公司规模";
            nickNameVC.info = self.company_gmLabel.text;
            [self.navigationController pushViewController:nickNameVC animated:YES];
        }else if (indexPath.section == 2 && indexPath.row == 3) {
            GLNickNameViewController *nickNameVC = [GLNickNameViewController new];
            nickNameVC.updatenickName = ^(NSString *nickName){
                self.company_numLabel.text = nickName;
                self.users.company_num = nickName;
            };
            nickNameVC.VCtitle = @"员工数量";
            nickNameVC.info = self.company_numLabel.text;
            [self.navigationController pushViewController:nickNameVC animated:YES];
        }else if (indexPath.section == 2 && indexPath.row == 4) {
            GLNickNameViewController *nickNameVC = [GLNickNameViewController new];
            nickNameVC.updatenickName = ^(NSString *nickName){
                self.brandLabel.text = nickName;
                self.users.brand = nickName;
            };
            nickNameVC.VCtitle = @"品牌名称";
            nickNameVC.info = self.brandLabel.text;
            [self.navigationController pushViewController:nickNameVC animated:YES];
        }else if (indexPath.section == 2 && indexPath.row == 5) {
            GLNickNameViewController *nickNameVC = [GLNickNameViewController new];
            nickNameVC.updatenickName = ^(NSString *nickName){
                self.shop_numLabel.text = nickName;
                self.users.shop_num = nickName;
            };
            nickNameVC.VCtitle = @"门店数量";
            nickNameVC.info = self.shop_numLabel.text;
            [self.navigationController pushViewController:nickNameVC animated:YES];
        }else if (indexPath.section == 2 && indexPath.row == 6) {
//            GLNickNameViewController *nickNameVC = [GLNickNameViewController new];
//            nickNameVC.updatenickName = ^(NSString *nickName){
//                self.addressLabel2.text = nickName;
//                self.users.address2 = nickName;
//            };
//            nickNameVC.VCtitle = @"通信地址";
//            nickNameVC.info = self.addressLabel2.text;
//            [self.navigationController pushViewController:nickNameVC animated:YES];
        }else if (indexPath.section == 3 && indexPath.row == 0) {
            GLNickNameViewController *nickNameVC = [GLNickNameViewController new];
            nickNameVC.updatenickName = ^(NSString *nickName){
                self.painLabel.text = nickName;
                self.users.pain = nickName;
            };
            nickNameVC.VCtitle = @"经营痛点";
            nickNameVC.info = self.painLabel.text;
            [self.navigationController pushViewController:nickNameVC animated:YES];
        }
    }
    
    /** 
     else if (indexPath.section == 1 && indexPath.row == 0) {
     GLNickNameViewController *nickNameVC = [GLNickNameViewController new];
     nickNameVC.updatenickName = ^(NSString *nickName){
     self.companyLabel.text = nickName;
     self.users.company = nickName;
     if (self.updateIdentity) {
     self.updateIdentity([NSString stringWithFormat:@"%@%@",nickName,self.jobLabel.text]);
     }
     };
     nickNameVC.VCtitle = @"公司";
     nickNameVC.info = self.companyLabel.text;
     [self.navigationController pushViewController:nickNameVC animated:YES];
     }else if (indexPath.section == 1 && indexPath.row == 1) {
     GLNickNameViewController *nickNameVC = [GLNickNameViewController new];
     nickNameVC.updatenickName = ^(NSString *nickName){
     self.businessLabel.text = nickName;
     self.users.business = nickName;
     };
     nickNameVC.VCtitle = @"主营";
     nickNameVC.info = self.businessLabel.text;
     [self.navigationController pushViewController:nickNameVC animated:YES];
     }else if (indexPath.section == 1 && indexPath.row == 2) {
     GLNickNameViewController *nickNameVC = [GLNickNameViewController new];
     nickNameVC.updatenickName = ^(NSString *nickName){
     self.jobLabel.text = nickName;
     self.users.job = nickName;
     if (self.updateIdentity) {
     self.updateIdentity([NSString stringWithFormat:@"%@%@",self.companyLabel.text,nickName]);
     }
     };
     nickNameVC.VCtitle = @"职位";
     nickNameVC.info = self.jobLabel.text;
     [self.navigationController pushViewController:nickNameVC animated:YES];
     }else if (indexPath.section == 1 && indexPath.row == 3) {
     GLNickNameViewController *nickNameVC = [GLNickNameViewController new];
     nickNameVC.updatenickName = ^(NSString *nickName){
     self.addressLabel.text = nickName;
     self.users.address = nickName;
     };
     nickNameVC.VCtitle = @"位置";
     nickNameVC.info = self.addressLabel.text;
     [self.navigationController pushViewController:nickNameVC animated:YES];
     }else if (indexPath.section == 2 && indexPath.row == 0) {
     //        GLNickNameViewController *nickNameVC = [GLNickNameViewController new];
     //        nickNameVC.updatenickName = ^(NSString *nickName){
     //            self.addressLabel.text = nickName;
     //        };
     //        nickNameVC.VCtitle = @"位置";
     //        nickNameVC.info = self.addressLabel.text;
     //        [self.navigationController pushViewController:nickNameVC animated:YES];
     
     }*/
    
}

/** 这个按钮的用户点击事件禁用了... 直接使用cell的点击 */
- (IBAction)clickEditRequirement:(UIButton *)sender {
    
    GLNickNameViewController *nickNameVC = [GLNickNameViewController new];
    nickNameVC.updatenickName = ^(NSString *nickName){
        self.painLabel.text = nickName;
        self.users.pain = nickName;
    };
    nickNameVC.VCtitle = @"经营痛点";
    nickNameVC.info = self.painLabel.text;
    [self.navigationController pushViewController:nickNameVC animated:YES];
    
}


- (void)setupLocationLabel
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *location_str = [defaults stringForKey:@"location_str"];
    
    self.addressLabel.text = location_str;
    
    /** 给位置cell的label赋值 */
    self.users.address = self.addressLabel.text;
    if (self.users.address) {
        if (self.updateAddress) {
            self.updateAddress(self.addressLabel.text);
        }
        
    }

}

#pragma mark - 点击 所在地 view
- (void)chooseRegion {
    
    NSUserDefaults *udefaults = [NSUserDefaults standardUserDefaults];
    NSString *province = [udefaults objectForKey:@"MyNowProvince"];
    NSString *city = [udefaults objectForKey:@"MyNowCity"];
    
    [self.view endEditing:YES];
    [self.regionPickerView showPickerWithProvinceName:province cityName:city countyName:nil];
    
    self.tableView.scrollEnabled = NO;
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [_regionPickerView removeFromSuperview];
    
}

- (HXProvincialCitiesCountiesPickerview *)regionPickerView {
    if (!_regionPickerView) {
        _regionPickerView = [[HXProvincialCitiesCountiesPickerview alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        if (self.networkCitys) {
            _regionPickerView.networkCitys = self.networkCitys;
        }else {
            [self downloadNetWorkCitys];
        }
        
        __weak __typeof(self)weakSelf = self;
        
//        __weak __typeof(HXProvincialCitiesCountiesPickerview *)weakPickerView = _regionPickerView;
        
        _regionPickerView.hiddenView = ^{
        
            weakSelf.tableView.scrollEnabled = YES;
            
        };
        
        __weak typeof(self) wself = self;
        _regionPickerView.completion = ^(NSString *provinceName,NSString *cityName,NSString *countyName) {
            __strong typeof(wself) self = wself;
            
            //  self.addressLabel.text = nickName;
            //  self.users.address = nickName;
            
            //            self.addressLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"212121"];
            
            //            if (cityName.length) {
            //
            //            }
            
            [self.addressLabel setText:[NSString stringWithFormat:@"%@ %@",provinceName,cityName]];
            
            
            NSDictionary *parameters = @{
                                         @"access_token":[[LoginVM getInstance] readLocal].token,
                                         @"field":@"address",
                                         @"value":self.addressLabel.text
                                         };
            
            [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/user/update"] parameters:parameters success:^(id json) {
                
                if (![json[@"state"] isEqual:@(0)]){
                    
                    
                    [SVProgressHUD showSuccessWithStatus:@"修改成功"];
//                    [self.navigationController popViewControllerAnimated:YES];
                    
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
            
            
        };
        
        [[UIApplication sharedApplication].keyWindow addSubview:_regionPickerView];
    }
    return _regionPickerView;
}

- (void)downloadNetWorkCitys
{
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/User/area"] parameters:nil success:^(id json) {
        
        self.networkCitys = json;
        
    } failure:^(NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"网络有延时,请检查网络,稍后再试"];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    
    NSLog(@"gerenziliaoVC deinit");
}

- (void)downloadjobList
{
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/User/jobs"] parameters:nil success:^(id json) {
        
        self.jobListDict = json;
        
    } failure:^(NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"网络有延时,请检查网络,稍后再试"];
    }];
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoCell" forIndexPath:indexPath];
//    
////    if (self.glPersonInfo) {
////        self.avatarImageView = nil;
////        self.nicknameLabel = nil;
////        self.companyLabel = nil;
////        self.signatureLabel = nil;
////        self.sexLabel = nil;
////        self.addressLabel = nil;
////    }
//    
////    self.avatarImageView.image = nil;
////    self.nicknameLabel.text = @"111";
////    self.companyLabel.text = @"222";
////    self.signatureLabel.text = @"111";
////    self.sexLabel.text = @"111";
////    self.addressLabel.text = @"111";
//    
//    return cell;
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

@end
