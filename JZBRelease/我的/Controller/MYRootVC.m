//
//  MYRootVCTableViewController.m
//  JZBRelease
//
//  Created by zjapple on 16/7/28.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "MYRootVC.h"
#import "SignInDayVC.h"
#import "MYSettingVC.h"

#import "UIImageView+CreateImageView.h"
#import "UILabel+CreateLabel.h"
#import "UIImageView+WebCache.h"

#import "ValuesFromXML.h"

#import "PersonalHeaderView.h"

#import "Defaults.h"
#import "GetValueObject.h"
#import "PersonalInformationViewController.h"
#import "LoginVM.h"
#import "AddHostToLoadPIC.h"
#import "HttpToolSDK.h"
#import "SVProgressHUD.h"
#import "SocialViewController.h"

#import "MYIntegralVC.h"
#import "PerAskAndAnswerVC.h"
#import "PerActivityVC.h"
#import "BQDynamicVC.h"
#import "IntegralDetailVC.h"

#import "MyCourseVC.h"
#import "SendAndGetDataFromNet.h"
#import "FocusedCourseTimeListVC.h"

@interface MYRootVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIView *headView;

@property (strong, nonatomic) PersonalHeaderView *personView;

/** top悬浮View */
@property (strong, nonatomic) UIView *barBackground;
@property (strong, nonatomic) UIImageView *backImageView;
@property (strong, nonatomic) UILabel *backLabel;

/** user */
@property (nonatomic, strong) Users *users;
/** userInfo */
@property (nonatomic, strong) UserInfo *userInfo;

@property(nonatomic, strong) NSData *fileData;

@end

@implementation MYRootVC

- (UserInfo *)userInfo
{
    if (_userInfo == nil) {
        _userInfo = [[UserInfo alloc] init];
    }
    return _userInfo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /** 缓存数据库 */
    DataBaseHelperSecond *db = [DataBaseHelperSecond getInstance];
    [db initDataBaseDB];
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    self.userInfo._id = [defaults objectForKey:@"self.userInfo._id"];
//    self.userInfo.account = [defaults objectForKey:@"self.userInfo.account"];
//    self.userInfo.password = [defaults objectForKey:@"self.userInfo.password"];
//    self.userInfo.token = [defaults objectForKey:@"self.userInfo.token"];
    self.userInfo = [[LoginVM getInstance]readLocal];
    
    Users *model = [Users new];
    
    model.uid = self.userInfo._id;
    model = (Users *)[db getModelFromTabel:model];
    
    self.users = model;
    
    self.personView = [[PersonalHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 293)];
    
    __weak typeof(self) weakSelf = self;
    self.personView.btnAction = ^(Clink_Type clink_type){
        if (clink_type == Clink_Type_UserIcon) {
            [weakSelf takePictureClick];
        }else if (clink_type == Clink_Type_Seven){
            /** 背景切换 跳转 */
            [weakSelf personViewBtnActionToBackground];
        }else if (clink_type == Clink_Type_Three){
            /** 积分 跳转 */
            [weakSelf personViewBtnActionToJifen];
        }else if (clink_type == Clink_Type_Six){
            /** 签到 跳转 */
//            [weakSelf personViewBtnActionToQiandao];
        }
    };
    
    [self.personView initWithData:model];
    
    NSUserDefaults *udefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *addressCity = [udefaults objectForKey:@"MyNowCity"];
    if (addressCity.length) {
        self.personView.locationLabel.text = addressCity;
    }else {
//        self.personView.locationLabel.text = @"尚未定位";
        self.personView.locationLabel.text = @"";
    }
//    [udefaults setObject:pl1.administrativeArea forKey:@"MyNowProvince"];
//    [udefaults setObject:pl1.locality forKey:@"MyNowCity"];
    
//    if (model.address) {
//        self.personView.locationLabel.text = @"尚未定位";
//        self.users.address.city = self.personView.locationLabel.text;
//    }else {
//        self.personView.locationLabel.text = model.address.city;
//    }
    
    if (model.nickname) {
        self.personView.nameLabel.text = model.nickname;
    }
    if (!(model.company == nil)) {
        model.company = @" ";
    }
    if (!(model.job == nil)) {
        model.job = @" ";
    }
    
    self.personView.gangLabel.text = @"建众帮";
    self.personView.avatarImageView.image = [UIImage imageNamed:@"bq_img_head"];
    self.personView.backImageView.image = [UIImage imageNamed:@"grzx_head_img"];
    
    self.personView.nameLabel.text = model.nickname;
    self.personView.companyLabel.text = [NSString stringWithFormat:@"%@%@",model.company,model.job];
    //[self.personView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[AddHostToLoadPIC AddHostToLoadPICWithString:model.avatar]] placeholderImage:[UIImage imageNamed:@"login_user"]];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    /** imageFilePath 是保存图片的沙盒地址 用UIImage的imageWithContentsOfFile方法加载 */
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
    
    if ([UIImage imageWithContentsOfFile:imageFilePath]) {
        self.personView.backImageView.image = [UIImage imageWithContentsOfFile:imageFilePath];
    }
    
    [self.headView addSubview:self.personView];
    
    [self setupLocationLabel];
    
    [self setupNavView];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(-20, 0, 10, 0)];
}

- (void)setupLocationLabel
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *location_str = [defaults stringForKey:@"location_str"];
    if (location_str) {
        self.personView.locationLabel.text = location_str;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.barBackground removeFromSuperview];
//    [self.backLabel removeFromSuperview];
//    [self.backImageView removeFromSuperview];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

/** top透明View */
- (void)setupNavView
{
    self.barBackground = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    self.barBackground.backgroundColor = [ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Personal_XM_Color" WithKind:XMLTypeColors]];
    self.barBackground.alpha = 0.3;
//    [[UIApplication sharedApplication].keyWindow addSubview:self.barBackground];
    [self.view addSubview:self.barBackground];
    
//    UIButton *backView = [[UIButton alloc] initWithFrame:CGRectMake(18, 20 + 4.5, 11 + 5 + 40, 35)];
//    self.backImageView = [UIImageView createImageViewWithFrame:CGRectMake(0, (35-20)/2, 20, 20) ImageName:@"back.png"];
//    self.backImageView.userInteractionEnabled = YES;
//    [backView addSubview:self.backImageView];
    
    /** 注释了左上角的返回按钮 */
//    self.backLabel = [UILabel createLabelWithFrame:CGRectMake(11 + 5,(35-20)/2, 40, 20) Font:17 Text:@"返回" andLCR:0 andColor:[UIColor whiteColor]];
    //    [backView addTarget:self action:@selector(actionBtn:) forControlEvents:UIControlEventTouchUpInside];
    
//    [backView addSubview:self.backLabel];
//    backView.tag = 0;

//    [[UIApplication sharedApplication].keyWindow addSubview:backView];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    UILabel *label = [UILabel new];
    [self.view addSubview:label];
    label.text = @"个人中心";
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    label.glcx_centerX = self.barBackground.glw_width * 0.5;
    label.glcy_centerY = 88 * 0.5;
    label.font = [UIFont systemFontOfSize:17];
    
    UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:navRightBtn];
    [navRightBtn setImage:[UIImage imageNamed:@"grzx_grzx_more"] forState:UIControlStateNormal];
    [navRightBtn sizeToFit];
    navRightBtn.glw_width = 20;
    navRightBtn.glcx_centerX = self.barBackground.glw_width - navRightBtn.glw_width;
    navRightBtn.glcy_centerY = 88 * 0.5;
    [navRightBtn addTarget:self action:@selector(ClicknavRightBtn:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)ClicknavRightBtn:(UIButton *)btn
{
    NSLog(@"点击了更多按钮");
//    MYSettingVC
    MYSettingVC *settingVC = [[UIStoryboard storyboardWithName:@"MYSettingVC" bundle:nil] instantiateInitialViewController];
    [self.navigationController pushViewController:settingVC animated:YES];
}

/** 更改个人信息 */
- (void)takePictureClick
{
    /** 跳转个人资料 */
    PersonalInformationViewController *PIVC = [[UIStoryboard storyboardWithName:@"PersonalInformationViewController" bundle:nil] instantiateInitialViewController];
    
    PIVC.MyPrelocal = self.users.address;
    
    /** 头像回调消息 */
    
    PIVC.updataavatarImageView = ^(UIImage *selfPhoto){
        self.personView.avatarImageView.image = selfPhoto;
    };
    
    /** 名字回调消息 */
    PIVC.updatenickName = ^(NSString *nickName){
        self.personView.nameLabel.text = nickName;
    };
    
    /** 名字回调消息 */
    PIVC.updateIdentity = ^(NSString *nickName){
        self.personView.companyLabel.text = nickName;
    };
    
    /** 地址回调消息 */
    PIVC.updateAddress = ^(NSString *address){
        self.personView.locationLabel.text = address;
        self.users.address = address;
    };
    
    
    [self.navigationController pushViewController:PIVC animated:YES];
}

/** push至积分界面 */
- (void)personViewBtnActionToJifen
{
    
    //MYIntegralVC *mYIntegralVC = [MYIntegralVC new];
//    IntegralDetailVC *vc = [[IntegralDetailVC alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
    
}

/** push至签到界面 */
- (void)personViewBtnActionToQiandao
{
    SignInDayVC *signInDayVC = [SignInDayVC new];
    
    [self.navigationController pushViewController:signInDayVC animated:YES];
   
    
}

/** 更改头部视图背景 */
- (void)personViewBtnActionToBackground
{
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"请选择文件来源"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"本地相簿",nil];
    actionSheet.title = @"更改背景";
    
    [actionSheet showInView:self.view];
}

#pragma mark -
#pragma UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([actionSheet.title isEqualToString:@"更改背景"]) {
        if (buttonIndex == 0) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            /** push的控制器返回有 BUG */
            [self presentViewController:imagePicker animated:YES completion:nil];
            
        }
    }
    
//    else{
//        switch (buttonIndex) {
//            case 0://照相机
//            {
//                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//                imagePicker.delegate = self;
//                imagePicker.allowsEditing = YES;
//                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//                [self presentViewController:imagePicker animated:YES completion:nil];
//                
//            }
//                break;
//            case 1://本地相簿
//            {
//                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//                imagePicker.delegate = self;
//                imagePicker.allowsEditing = YES;
//                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//                [self presentViewController:imagePicker animated:YES completion:nil];
//            }
//                break;
//            default:
//                break;
//        }
//    }
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
    //    NSLog(@"保存背景！");
    //    [userPhotoButton setImage:image forState:UIControlStateNormal];
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    /** imageFilePath 是保存图片的沙盒地址 用UIImage的imageWithContentsOfFile方法加载 */
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
    //    NSLog(@"imageFile->>%@",imageFilePath);
    success = [fileManager fileExistsAtPath:imageFilePath];
    if(success) {
        success = [fileManager removeItemAtPath:imageFilePath error:&error];
    }
    
    /** 注释了生存小图 */
    //    UIImage *smallImage=[self scaleFromImage:image toSize:CGSizeMake(80.0f, 80.0f)];//将图片尺寸改为80*80
    //    UIImage *smallImage = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(93, 93)];
    
    //    [UIImageJPEGRepresentation(smallImage, 1.0f) writeToFile:imageFilePath atomically:YES];//写入文件
    
    [UIImageJPEGRepresentation(image, 1.0f) writeToFile:imageFilePath atomically:YES];//写入文件
    
    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件
    //    [userPhotoButton setImage:selfPhoto forState:UIControlStateNormal];
    //    self.img.image = selfPhoto;
    self.personView.backImageView.image = selfPhoto;
    //    [self uploadImg:selfPhoto];
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
                                 @"access_token":self.userInfo.token,
                                 @"field":@"avatar",
                                 @"value":data
                                 };
    
//    NSString *str = [@"http://192.168.10.154/bang/index.php" ];
    
//    NSString *str11 = [[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/user/update"];
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/user/update"] parameters:parameters fromDataArray:dataArr success:^(id json) {
        //         NSLog(@"json= %@",json);
        if (![json[@"state"] isEqual:@(0)]){
            [SVProgressHUD showSuccessWithStatus:@"图片保存成功"];
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


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 21;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
//            SocialViewController *socialVC = [[SocialViewController alloc]init];
//            socialVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:socialVC animated:YES];
            PerAskAndAnswerVC *perAAVC = [[PerAskAndAnswerVC alloc]init];
            Users *user = [[Users alloc]init];
            user.uid = [[LoginVM getInstance] readLocal]._id;
            user = (Users *)[[DataBaseHelperSecond getInstance]getModelFromTabel:user];
            perAAVC.user = user;
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            [self.navigationController pushViewController:perAAVC animated:YES];
            
        }else if (indexPath.row == 1){
            
            PerActivityVC *perActivityVC = [[PerActivityVC alloc]init];
            Users *user = [[Users alloc]init];
            user.uid = [[LoginVM getInstance] readLocal]._id;
            user = (Users *)[[DataBaseHelperSecond getInstance]getModelFromTabel:user];
            perActivityVC.user = user;
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            [self.navigationController pushViewController:perActivityVC animated:YES];
            
            //self.tabBarController.tabBar.hidden = YES;
        }else if (indexPath.row == 2){
            //#import "PerActivityVC.h"
            
            MyCourseVC *myVC = [[MyCourseVC alloc]init];
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            [self.navigationController pushViewController:myVC animated:YES];
            
        }else{
            
        }
    }else if (indexPath.section == 1){
        //#import "BQDynamicVC.h"
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

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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



@end

