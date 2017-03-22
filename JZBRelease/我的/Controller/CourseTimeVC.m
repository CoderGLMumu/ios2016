//
//  CourseTimeVC.m
//  JZBRelease
//
//  Created by cl z on 16/9/13.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "CourseTimeVC.h"
#import "UIPlaceHolderTextView.h"
#import "Defaults.h"
#import "UIPlaceHolderTextView.h"
#import "HKModelMarco.h"
#import "HKImageClipperViewController.h"
#import "SendSerialsModel.h"
#import "LewPopupViewAnimationSpring.h"
#import "SendAndGetDataFromNet.h"
#import "Masonry.h"
#import "CuiPickerView.h"
#import "SelectAdressVC.h"
#import "cityModel.h"
#import "SendCourseTimeModel.h"
@interface CourseTimeVC ()<UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,CuiPickViewDelegate,UIScrollViewDelegate>{
    NSMutableArray *allAry,*emerBtnAry;
    NSInteger pre,emerPre;
    UIView *courseNameView,*courseIntroduceView,*detailView;
    NSInteger offSet,which;
    BOOL beginOrEnd,isExtend;
    
}

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIImageView *banarView;
@property(nonatomic, strong) UITextField *courseNameTextView;
@property(nonatomic, strong) UIPlaceHolderTextView *courseIntroduceTextView;
@property(nonatomic, strong) UIButton *startTime;
@property(nonatomic, strong) UILabel *startimeLabel;
@property(nonatomic, strong) UIButton *endTime;
@property(nonatomic, strong) UILabel *endTimeLabel;
@property(nonatomic, strong) UIButton *adressBtn;
@property(nonatomic, strong) UILabel *adressLabel;
@property(nonatomic, strong) UITextField *fateTextField;
@property(nonatomic, strong) CuiPickerView *cuiPickerView;
@property(nonatomic, strong) cityModel *cityModel;
@end

@implementation CourseTimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    emerPre = 0;
    [self.view addSubview:self.scrollView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.scrollView addSubview:[self returnTitleView:@"课程海报" WithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)]];
    [self.scrollView addSubview:self.banarView];
    [self initCourseNameView];
    [self initCourseIntroduceView];
    [self initRewardViews];
    _cuiPickerView = [[CuiPickerView alloc]init];
    _cuiPickerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200);
    _cuiPickerView.delegate = self;
    _cuiPickerView.curDate=[NSDate date];
    [self.view addSubview:_cuiPickerView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    [self configNav];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

}


-(void)configNav
{
    
    UIButton *sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 35, 28)];
    [sendBtn setTitle:@"发布" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendCourseTimeAction) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    UIBarButtonItem *sendBarBtn = [[UIBarButtonItem alloc]initWithCustomView:sendBtn];
    self.navigationItem.rightBarButtonItem = sendBarBtn;
    
}

- (void)sendCourseTimeAction{
    if (!self.banarView.image) {
        [Toast makeShowCommen:@"您未选择 " ShowHighlight:@"课程海报" HowLong:0.8];
        return;
    }
    
    if (self.courseNameTextView.text.length <= 0) {
        [Toast makeShowCommen:@"您未填写 " ShowHighlight:@"课程名称" HowLong:0.8];
        return;
    }
    
    if (self.courseIntroduceTextView.text.length <= 0) {
        [Toast makeShowCommen:@"您未填写 " ShowHighlight:@"课程介绍" HowLong:0.8];
        return;
    }
    
    
    
    if (self.fateTextField.text.length <= 0) {
        [Toast makeShowCommen:@"您未填写 " ShowHighlight:@"课程价格" HowLong:0.8];
        return;
    }
    if (self.startimeLabel.text.length <= 0) {
        [Toast makeShowCommen:@"您未选择 " ShowHighlight:@"开课程间" HowLong:0.8];
        return;
    }
    if (self.endTimeLabel.text.length <= 0) {
        [Toast makeShowCommen:@"您未选择 " ShowHighlight:@"结课程间" HowLong:0.8];
        return;
    }
    
    SendCourseTimeModel *sendCourseTimeModel = [[SendCourseTimeModel alloc]init];
    sendCourseTimeModel.access_token = [[LoginVM getInstance] readLocal].token;
    sendCourseTimeModel.course_id = self.course_id;
    sendCourseTimeModel.title = self.courseNameTextView.text;
    sendCourseTimeModel.score = self.fateTextField.text;
    sendCourseTimeModel.content = self.courseIntroduceTextView.text;
    sendCourseTimeModel.start_time = self.startimeLabel.text;
    sendCourseTimeModel.end_time = self.endTimeLabel.text;
    if ([self.adressLabel.text isEqualToString:@"视频直播"]) {
        sendCourseTimeModel.type = @"3";
    }else if ([self.adressLabel.text isEqualToString:@"音频直播"]){
        sendCourseTimeModel.type = @"4";
    }
    if (self.cityModel) {
        sendCourseTimeModel.lng = [NSString stringWithFormat:@"%f",self.cityModel.longitude];
        sendCourseTimeModel.lat = [NSString stringWithFormat:@"%f",self.cityModel.latitude];
        sendCourseTimeModel.city = self.cityModel.city;
        sendCourseTimeModel.address = [self.adressLabel.text stringByAppendingString:self.cityModel.name];
    }
    

    CustomAlertView *alertView = [CustomAlertView defaultCustomAlertView:@"发布中..."];
    [self lew_presentPopupView:alertView animation:[LewPopupViewAnimationSpring new]];
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
    NSString *absolutePath = [ValuesFromXML getValueWithName:@"Sever_Absolute_Address" WithKind:XMLTypeNetPort];
    NSString *path = [absolutePath stringByAppendingPathComponent:[ValuesFromXML getValueWithName:@"UPLoad_Picture" WithKind:XMLTypeNetPort]];
    
    [self uploadPicAndOtherInfo:self.banarView.image WithPath:path WithModel:sendCourseTimeModel WithQueue:queue WithAlertView:alertView];

}

- (void)uploadPicAndOtherInfo:(UIImage *) image WithPath:(NSString *) path WithModel:(SendCourseTimeModel *)sendCourseTimeModel WithQueue:(dispatch_queue_t) queue WithAlertView:(CustomAlertView *) alertView{
    __weak CourseTimeVC *wself = self;
    dispatch_async(queue, ^{
        [HttpManager uploadPictures:nil WithUrlString:path Image:image];
        [HttpManager shareManager].returnData = ^(NSDictionary *dict){
            int state = [[dict objectForKey:@"state"] intValue];
            if (1 == state) {
                NSDictionary *data = [dict objectForKey:@"data"];
                if (data) {
                    NSString *picID = [data objectForKey:@"id"];
                    if (picID) {
                        sendCourseTimeModel.thumb = picID;
                        SendAndGetDataFromNet *send = [[SendAndGetDataFromNet alloc]init];
                        send.returnModel = ^(GetValueObject *obj,int state){
                            if (1 == state) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [alertView setTitle:@"发布成功"];
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                        [wself lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
                                        [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            if (wself.returnAction) {
                                                wself.returnAction();
                                            }
                                            [wself.navigationController popViewControllerAnimated:YES];
                                            
                                        });

                                    });
                                });
                            }else{
                                [alertView.label setText:@"发布失败"];
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    [wself lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
                                    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                                });
                            }
                        };
                        [send commenDataFromNet:sendCourseTimeModel WithRelativePath:@"Add_CourseTime_URL"];
                    }
                }
            }else{
                [alertView.label setText:@"发布失败"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [wself lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
                    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                });
            }
        };
    });
}


-(UIScrollView *)scrollView{
    if (_scrollView) {
        return _scrollView;
    }
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    //_scrollView.directionalLockEnabled = YES; //只能一个方向滑动
    _scrollView.pagingEnabled = NO; //是否翻页
    _scrollView.backgroundColor = [ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Inteval_Color" WithKind:XMLTypeColors]];
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator =YES; //垂直方向的滚动指示
    _scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;//滚动指示的风格
    _scrollView.showsHorizontalScrollIndicator = NO;//水平方向的滚动指示
    return _scrollView;
}

- (UIView *) returnTitleView:(NSString *) title WithFrame:(CGRect) frame{
    UIView *titleView = [[UIView alloc]initWithFrame:frame];
    [titleView setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f8f8f8"]];
    UILabel *label = [UILabel createLabelWithFrame:CGRectMake(15, 0, 120, frame.size.height) Font:13 Text:title andLCR:NSTextAlignmentLeft andColor:[UIColor hx_colorWithHexRGBAString:@"757575"]];
    [titleView addSubview:label];
    return titleView;
}

- (UIImageView *)banarView{
    if (!_banarView) {
        _banarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH, 150)];
        [_banarView setBackgroundColor:[UIColor whiteColor]];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, (150 - 60) / 2, 60, 60)];
        [imageView setImage:[UIImage imageNamed:@"WD_FB_TJ"]];
        _banarView.userInteractionEnabled = YES;
        imageView.userInteractionEnabled = NO;
        [_banarView addSubview:imageView];
        UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(exchangeImage:)];
        [_banarView addGestureRecognizer:tap];
    }
    return _banarView;
}

- (void)exchangeImage:(UITapGestureRecognizer *)tap{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机选择", nil];
    [actionSheet showInView:self.view];
}

- (UIImage *)turnImageWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    //类型为 UIImagePickerControllerOriginalImage 时调整图片角度
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        UIImageOrientation imageOrientation=image.imageOrientation;
        if(imageOrientation!=UIImageOrientationUp) {
            // 原始图片可以根据照相时的角度来显示，但 UIImage无法判定，于是出现获取的图片会向左转90度的现象。
            UIGraphicsBeginImageContext(image.size);
            [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
    }
    return image;
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    //自定义裁剪方式
    UIImage*image = [self turnImageWithInfo:info];
    HKImageClipperViewController *clipperVC = [[HKImageClipperViewController alloc]initWithBaseImg:image
                                                                                     resultImgSize:self.banarView.frame.size clipperType:ClipperTypeImgMove];
    __weakSelf(self);
    clipperVC.cancelClippedHandler = ^(){
        [picker dismissViewControllerAnimated:YES completion:nil];
    };
    clipperVC.successClippedHandler = ^(UIImage *clippedImage){
        __strongSelf(weakSelf);
        UIImageView *addImageView = [strongSelf.banarView.subviews objectAtIndex:0];
        if (!addImageView.hidden) {
            addImageView.hidden = YES;
        }
        [strongSelf.banarView setImage:clippedImage];
        
        //            strongSelf.layerView.layer.contents =(__bridge id _Nullable)(clippedImage.CGImage);
        //            strongSelf.layerView.contentMode = UIViewContentModeScaleAspectFit;
        //            strongSelf.layerView.layer.contentsGravity = kCAGravityResizeAspect;
        [picker dismissViewControllerAnimated:YES completion:nil];
    };
    
    [picker pushViewController:clipperVC animated:YES];
    
}

- (void)initCourseNameView{
    courseNameView = [[UIView alloc]initWithFrame:CGRectMake(0, self.banarView.frame.origin.y + self.banarView.frame.size.height, SCREEN_WIDTH, 79)];
    [courseNameView setBackgroundColor:[UIColor whiteColor]];
    [self.scrollView addSubview:courseNameView];
    
    [courseNameView addSubview:[self returnTitleView:@"课程名时" WithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)]];
    
    self.courseNameTextView = [[UITextField alloc]initWithFrame:CGRectMake(15, 35, SCREEN_WIDTH - 15, 44)];
    [self.courseNameTextView setFont:[UIFont systemFontOfSize:14]];
    [self.courseNameTextView setTextColor:[UIColor hx_colorWithHexRGBAString:@"212121"]];
    self.courseNameTextView.placeholder = @"请输入课程名时，20字内";
    [courseNameView addSubview:self.courseNameTextView];
}

- (void)initCourseIntroduceView{
    courseIntroduceView = [[UIView alloc]initWithFrame:CGRectMake(0, courseNameView.frame.origin.y + courseNameView.frame.size.height, SCREEN_WIDTH, 171)];
    [courseIntroduceView setBackgroundColor:[UIColor whiteColor]];
    [self.scrollView addSubview:courseIntroduceView];
    
    [courseIntroduceView addSubview:[self returnTitleView:@"课程介绍" WithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)]];
    
    self.courseIntroduceTextView = [[UIPlaceHolderTextView alloc]initWithFrame:CGRectMake(15, 53, SCREEN_WIDTH - 30, 100)];
    [self.courseIntroduceTextView setFont:[UIFont systemFontOfSize:14]];
    [self.courseIntroduceTextView setTextColor:[UIColor hx_colorWithHexRGBAString:@"212121"]];
    self.courseIntroduceTextView.delegate = self;
    self.courseIntroduceTextView.layer.cornerRadius = 3.0;
    self.courseIntroduceTextView.placeholderColor = [UIColor hx_colorWithHexRGBAString:@"d0d0d0"];
    self.courseIntroduceTextView.layer.borderColor = [ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Inteval_Color" WithKind:XMLTypeColors]].CGColor;
    self.courseIntroduceTextView.layer.borderWidth = 0.8;
    self.courseIntroduceTextView.placeholder = @"请输入课程介绍，200字内";
    [courseIntroduceView addSubview:self.courseIntroduceTextView];
}

-(void)initRewardViews{
    detailView = [[UIView alloc]initWithFrame:CGRectMake(0, courseIntroduceView.frame.origin.y + courseIntroduceView.frame.size.height, SCREEN_WIDTH, 97.6 + 20 + 10 + 48.6 + 48.6)];
    [detailView setBackgroundColor:[UIColor whiteColor]];
    [self.scrollView addSubview:detailView];
    
    
    UIView *inteval4 = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 10)];
    [inteval4 setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f8f8f8"]];
    [detailView addSubview:inteval4];
    
    int width = [@"课程类型 :" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width + 3;
    UILabel *titleLabel1 = [UILabel createMyLabelWithFrame:CGRectMake(15, 12 + 10, width, 36) Font:14 Text:@"课程类型 :" andLCR:0 andColor:[UIColor hx_colorWithHexRGBAString:@"757575"]];
    [detailView addSubview:titleLabel1];
    self.adressBtn = [[UIButton alloc]initWithFrame:CGRectMake(width + 15, 12 + 10, detailView.frame.size.width - 30 - width, 36)];
    [self.adressBtn addTarget:self action:@selector(adressBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.adressBtn.tag = 0;
    [detailView addSubview:self.adressBtn];
    UIImageView *rowImageView = [[UIImageView alloc]init];
    [self.adressBtn addSubview:rowImageView];
    [rowImageView setImage:[UIImage imageNamed:@"WD_location"]];
    [rowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.centerY.equalTo(self.adressBtn);
        make.right.equalTo(self.adressBtn).with.offset(0);
    }];
    self.adressLabel = [[UILabel alloc]init];
    [self.adressBtn addSubview:self.adressLabel];
    self.adressLabel.textColor = [ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]];
    self.adressLabel.font = [UIFont systemFontOfSize:14];
    self.adressLabel.textAlignment = NSTextAlignmentCenter;
    self.adressLabel.numberOfLines = 0;
    [self.adressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.adressBtn.frame.size.width - 16, 21));
        make.centerY.equalTo(self.adressBtn);
        make.left.equalTo(self.adressBtn).with.offset(0);
    }];
    UIView *inteval = [[UIView alloc]initWithFrame:CGRectMake(15,48 + 10, SCREEN_WIDTH - 30, 0.8)];
    [inteval setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"dfdfdf"]];
    [detailView addSubview:inteval];
    
    
    UILabel *titleLabel2 = [UILabel createMyLabelWithFrame:CGRectMake(15, 48.8 + 12 + 10, width, 36) Font:14 Text:@"开课程间 :" andLCR:0 andColor:[UIColor hx_colorWithHexRGBAString:@"757575"]];
    [detailView addSubview:titleLabel2];
    self.startTime = [[UIButton alloc]initWithFrame:CGRectMake(width + 15, 48.8 + 12 + 10, detailView.frame.size.width - 30 - width, 36)];
    [self.startTime addTarget:self action:@selector(datePickSender:) forControlEvents:UIControlEventTouchUpInside];
    self.startTime.tag = 0;
    [detailView addSubview:self.startTime];
    UIImageView *rowImageView1 = [[UIImageView alloc]init];
    [self.startTime addSubview:rowImageView1];
    [rowImageView1 setImage:[UIImage imageNamed:@"bangba_edit_rili"]];
    [rowImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.centerY.equalTo(self.startTime);
        make.right.equalTo(self.startTime).with.offset(0);
    }];
    self.startimeLabel = [[UILabel alloc]init];
    [self.startTime addSubview:self.startimeLabel];
    self.startimeLabel.textColor = [ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]];
    self.startimeLabel.font = [UIFont systemFontOfSize:14];
    self.startimeLabel.textAlignment = NSTextAlignmentCenter;
    [self.startimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(160, 21));
        make.centerY.equalTo(self.startTime);
        make.left.equalTo(self.startTime).with.offset((self.startTime.frame.size.width - 16 - 160) / 2);
    }];
    UILabel *inteval1 = [[UILabel alloc]initWithFrame:CGRectMake(15,96.8 + 10, SCREEN_WIDTH - 30, 0.8)];
    [inteval1 setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"dfdfdf"]];
    [detailView addSubview:inteval1];
    
    UILabel *titleLabel3 = [UILabel createMyLabelWithFrame:CGRectMake(15, 48.8 + 12 + 10 + 48.8, width, 36) Font:14 Text:@"结课程间 :" andLCR:0 andColor:[UIColor hx_colorWithHexRGBAString:@"757575"]];
    [detailView addSubview:titleLabel3];
    self.endTime = [[UIButton alloc]initWithFrame:CGRectMake(width + 15, 48.8 + 12 + 10 + 48.8, detailView.frame.size.width - 30 - width, 36)];
    [self.endTime addTarget:self action:@selector(datePickSender:) forControlEvents:UIControlEventTouchUpInside];
    self.endTime.tag = 1;
    [detailView addSubview:self.endTime];
    UIImageView *rowImageView2 = [[UIImageView alloc]init];
    [self.endTime addSubview:rowImageView2];
    [rowImageView2 setImage:[UIImage imageNamed:@"bangba_edit_rili"]];
    [rowImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.centerY.equalTo(self.endTime);
        make.right.equalTo(self.endTime).with.offset(0);
    }];
    self.endTimeLabel = [[UILabel alloc]init];
    [self.endTime addSubview:self.endTimeLabel];
    self.endTimeLabel.textColor = [ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]];
    self.endTimeLabel.tag = 1;
    self.endTimeLabel.font = [UIFont systemFontOfSize:14];
    self.endTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self.endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(160, 21));
        make.centerY.equalTo(self.endTime);
        make.left.equalTo(self.endTime).with.offset((self.endTime.frame.size.width - 16 - 160) / 2);
    }];
    UILabel *inteval2 = [[UILabel alloc]initWithFrame:CGRectMake(15,96.8 + 10 + 48.8, SCREEN_WIDTH - 30, 0.8)];
    [inteval2 setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"dfdfdf"]];
    [detailView addSubview:inteval2];
    
    UILabel *titleLabel4 = [UILabel createMyLabelWithFrame:CGRectMake(15, 48.8 + 12 + 48.8 + 10 + 48.8, width, 36) Font:14 Text:@"课程价格 :" andLCR:0 andColor:[UIColor hx_colorWithHexRGBAString:@"757575"]];
    [detailView addSubview:titleLabel4];
    
    self.fateTextField = [[UITextField alloc]initWithFrame:CGRectMake(15 + width, 48.8 + 12 + 48.8 + 10 + 48.8, SCREEN_WIDTH - 30 - 16 - width, 36)];
    self.fateTextField.textAlignment = NSTextAlignmentCenter;
    [self.fateTextField setTextColor:RGB(234, 128, 17, 1)];
    [self.fateTextField setFont:[UIFont systemFontOfSize:14]];
    self.fateTextField.delegate = self;
    self.fateTextField.keyboardType = UIKeyboardTypeNumberPad;
   // AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    //if (appDelegate.checkpay) {
        [self.fateTextField setPlaceholder:@"请输入课程帮币"];
   // }
    
    [self.fateTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [detailView addSubview:self.fateTextField];
    UIImageView *fateImageView = [[UIImageView alloc]init];
    [detailView addSubview:fateImageView];
    [fateImageView setImage:[UIImage imageNamed:@"grzx_tiwen_jifen"]];
    [fateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.centerY.equalTo(self.fateTextField);
        make.right.equalTo(self.endTime).with.offset(0);
    }];
    UILabel *inteval3 = [[UILabel alloc]initWithFrame:CGRectMake(15,96.8 + 48.8 + 10 + 48.8, SCREEN_WIDTH - 30, 0.8)];
    [inteval3 setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"dfdfdf"]];
    [detailView addSubview:inteval3];
    
    [self.scrollView setContentSize:CGSizeMake(0, detailView.frame.origin.y + detailView.frame.size.height + 50)];
}

- (void)adressBtnAction{
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"视频直播", @"音频直播", nil];
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    sheet.tag = 100;
    [sheet showInView:self.view];
    
}

-(void) datePickSender:(UIButton *) btn{
    CGRect rect = CGRectMake(0, detailView.frame.origin.y + detailView.frame.size.height - 36, SCREEN_WIDTH, 36);
    [UIView animateWithDuration:0.25 animations:^{
        self.scrollView.frame = CGRectMake(self.scrollView.frame.origin.x, - (rect.origin.y + rect.size.height - (self.view.frame.size.height - 200)), self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    } completion:^(BOOL finished) {
        offSet = rect.origin.y + rect.size.height - (self.view.frame.size.height - 200);
        if (0 == btn.tag) {
            beginOrEnd = YES;
        }else{
            beginOrEnd = NO;
        }
        [_cuiPickerView showInView:self.view];
        _cuiPickerView.isShow = YES;
    }];
}

//赋值给textField
-(void)didFinishPickView:(NSString *)date
{
    if (beginOrEnd) {
        [self.startimeLabel setText:date];
    }else{
        [self.endTimeLabel setText:date];
    }
    NSLog(@"%@",date);
}


-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    
    if ([self.courseNameTextView isFirstResponder]) {
        [self.courseNameTextView resignFirstResponder];
    }
    if (offSet > 0 || -2 == which) {
        [UIView animateWithDuration:0.5 animations:^{
            self.scrollView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        } completion:^(BOOL finished) {
            offSet = 0;
        }];
    }
    if ([self.courseIntroduceTextView isFirstResponder]) {
        [self.courseIntroduceTextView resignFirstResponder];
    }
    if ([self.fateTextField isFirstResponder]) {
        [self.fateTextField resignFirstResponder];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.courseNameTextView isFirstResponder]) {
        [self.courseNameTextView resignFirstResponder];
    }
    if (offSet > 0 || -2 == which) {
        [UIView animateWithDuration:0.5 animations:^{
            self.scrollView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        } completion:^(BOOL finished) {
            offSet = 0;
        }];
    }
    if ([self.courseIntroduceTextView isFirstResponder]) {
        [self.courseIntroduceTextView resignFirstResponder];
    }
    if ([self.fateTextField isFirstResponder]) {
        [self.fateTextField resignFirstResponder];
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (textView == self.courseIntroduceTextView) {
        which = 0;
        return YES;
    }else{
        which = -1;
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;{
    if (textField == self.fateTextField) {
        which = -2;
    }
    return YES;
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    if (![self isPureInt:theTextField.text]) {
        [Toast makeShowCommen:@"请正确输入 " ShowHighlight:@"数字" HowLong:0.8];
        [theTextField setText:@""];
        [theTextField setPlaceholder:@"请输入课程分数"];
    }
}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

- (void)photoWithSourceType:(UIImagePickerControllerSourceType)type{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = type;
    //imagePicker.allowsEditing = self.systemEditing;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (100 == actionSheet.tag) {
        if (buttonIndex == 0) {
            [self.adressLabel setText:@"视频直播"];
        }else if(buttonIndex == 1){
            [self.adressLabel setText:@"音频直播"];
        }
        return;
    }
    
    if (buttonIndex == 0) {
        [self photoWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    else if(buttonIndex == 1) {
        [self photoWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }else if (buttonIndex == 2){
        
    }
}




//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    if (which == 0) {
        CGRect rect = [self.fateTextField convertRect:self.fateTextField.bounds toView:nil];
        //CGRect rect = CGRectMake(0, courseIntroduceView.frame.origin.y + courseIntroduceView.frame.size.height, SCREEN_WIDTH, 0);
        if (rect.origin.y + rect.size.height > keyboardRect.origin.y) {
            [UIView animateWithDuration:0.5 animations:^{
                self.scrollView.frame = CGRectMake(self.scrollView.frame.origin.x, - (rect.origin.y + rect.size.height - keyboardRect.origin.y), self.scrollView.frame.size.width, self.scrollView.frame.size.height);
            } completion:^(BOOL finished) {
                offSet = rect.origin.y + rect.size.height - keyboardRect.origin.y;
                which = -1;
            }];
        }
    }else if (-2 == which){
        
            [UIView animateWithDuration:0.5 animations:^{
                self.scrollView.frame = CGRectMake(self.scrollView.frame.origin.x, - keyboardRect.size.height, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
            } completion:^(BOOL finished) {
                offSet = - keyboardRect.origin.y + 50;
               
            }];
        

    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}



@end
