//
//  SendActivityVC.m
//  JZBRelease
//
//  Created by zjapple on 16/6/14.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "SendActivityVC.h"
#import "Defaults.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "PictureCollectionViewCell.h"
#import "PictureAddCell.h"
#import "ELCImagePickerController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/ALAsset.h>
#import "Masonry.h"
#import "SendNineImageView.h"
#import "UIPlaceHolderTextView.h"
#import "ValuesFromXML.h"
#import "HttpManager.h"
#import "UserInfo.h"
#import "SendDynamicModel.h"
#import "SendDynamicVM.h"
#import "LoginVM.h"
#import "CuiPickerView.h"
#import "SendActivityModel.h"
#import "SendAndGetDataFromNet.h"
#import "CustomAlertView.h"
#import "LewPopupViewAnimationSpring.h"
#import "SelectAdressVC.h"
#import "HKModelMarco.h"
#import "HKImageClipperViewController.h"
#import "BanerImageVC.h"
@interface SendActivityVC ()<MJPhotoBrowserDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UITextFieldDelegate,CuiPickViewDelegate,UITextViewDelegate,UIScrollViewDelegate>{
    int offY;
    int descriptionHeight;
    int which;
    int offSet;
    BOOL beginOrEnd,isImagePicker;
    GetValueObject *valueObj;
    UIView *contentView;
    UIView *activityDetailView;
    UIView *activityTopicView;
    CGRect keyboardRect;
    UIView *temp;
}

@property(nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) ChatKeyBoard *chatKeyBoard;
@property(nonatomic, strong) NSMutableArray *itemsSectionPictureArray,*picIDAry;
@property(nonatomic, strong) SendNineImageView *containerView;
@property(nonatomic, strong) UIView *allBtnViews;
@property(nonatomic, strong) NSArray *imageAry;

@property (nonatomic, strong) CuiPickerView *cuiPickerView;
@property(nonatomic, strong) UITextField *topicTextField;
@property(nonatomic, strong) UIPlaceHolderTextView *contentTextView;
@property(nonatomic, strong) UIButton *beginTime,*endTime,*activityType,*addressBtn;
@property(nonatomic, strong) UITextField *activityPay,*activityMenCount,*adressName;
@property(nonatomic, strong) UIView *activitySettingView;
@property(strong, nonatomic)  UIButton *clippedBtn;

@property (nonatomic, strong) UILabel *beginTimeLabel;
@property (nonatomic, strong) UILabel *endTimeLabel;
@property (nonatomic, strong) UILabel *activityTypeLabel;
@property (nonatomic, strong) cityModel *cityModel;
@end

@implementation SendActivityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    valueObj = [[GetValueObject alloc]init];
    which = -1;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self configNav];
    
    
    
    //[self.clippedImageView setImage:nil];
    [self.view addSubview:self.scrollView];
    
    self.scrollView.delegate = self;
    
    [self initActivityTopic];
    [self initActivityDetail];
    [self initActivityDecription];
    [self initActivitySetting];
    NSLog(@"%fld",SCREEN_WIDTH);
    
    _cuiPickerView = [[CuiPickerView alloc]init];
    _cuiPickerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200);
    
    //这一步很重要
//    _cuiPickerView.myTextField = _textField;
    
    _cuiPickerView.delegate = self;
    _cuiPickerView.curDate=[NSDate date];
    [self.view addSubview:_cuiPickerView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}


-(void)configNav
{
    //11 20
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11 + 5 + 40, 35)];
    UIImageView *backImageView = [UIImageView createImageViewWithFrame:CGRectMake(0, (35-20)/2, 20, 20) ImageName:@"DL_light_ARROW"];
    backImageView.userInteractionEnabled = YES;
    [backView addSubview:backImageView];
//    UILabel *backLabel = [UILabel createLabelWithFrame:CGRectMake(11 + 5,(35-20)/2, 40, 20) Font:17 Text:@"返回" andLCR:0 andColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]]];
//    [backView addSubview:backLabel];
    UIControl *back = [[UIControl alloc] initWithFrame:backView.bounds];
    [back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:back];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    UIButton *sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 35, 28)];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    sendBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendActionSender) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    UIBarButtonItem *sendBarBtn = [[UIBarButtonItem alloc]initWithCustomView:sendBtn];
    self.navigationItem.rightBarButtonItem = sendBarBtn;

}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    keyboardRect = [aValue CGRectValue];
    
    if (which == 0) {
        CGRect rect = [self.activityPay convertRect:self.activityPay.frame toView:nil];
        if (rect.origin.y + rect.size.height > keyboardRect.origin.y) {
            [UIView animateWithDuration:0.5 animations:^{
                self.scrollView.frame = CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y - (rect.origin.y + rect.size.height - keyboardRect.origin.y), self.scrollView.frame.size.width, self.scrollView.frame.size.height);
            } completion:^(BOOL finished) {
                offSet = rect.origin.y + rect.size.height - keyboardRect.origin.y;
                which = -1;
                [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
            }];
        }
    }else if (which == 1){
        CGRect rect = [self.activityMenCount convertRect:self.activityMenCount.frame toView:nil];
        if (rect.origin.y + rect.size.height > keyboardRect.origin.y) {
            [UIView animateWithDuration:0.5 animations:^{
                self.scrollView.frame = CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y - (rect.origin.y + rect.size.height - keyboardRect.origin.y), self.scrollView.frame.size.width, self.scrollView.frame.size.height);
            } completion:^(BOOL finished) {
                offSet = rect.origin.y + rect.size.height - keyboardRect.origin.y;
                which = -1;
                [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
            }];
        }
    }
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (_cuiPickerView.isShow) {
        [_cuiPickerView hiddenPickerView];
    }
    if (textField == self.activityMenCount) {
        which = 1;
        if (keyboardRect.size.height != 0) {
            CGRect rect = [self.activityMenCount convertRect:self.activityMenCount.frame toView:nil];
            if (rect.origin.y + rect.size.height > keyboardRect.origin.y) {
                [UIView animateWithDuration:0.5 animations:^{
                    self.scrollView.frame = CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y - (rect.origin.y + rect.size.height - keyboardRect.origin.y), self.scrollView.frame.size.width, self.scrollView.frame.size.height);
                } completion:^(BOOL finished) {
                    offSet = rect.origin.y + rect.size.height - keyboardRect.origin.y;
                    which = -1;
                    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
                }];
            }
        }
    }else if (textField == self.activityPay){
        which = 0;
        if (keyboardRect.size.height != 0) {
            CGRect rect = [self.activityPay convertRect:self.activityPay.frame toView:nil];
            if (rect.origin.y + rect.size.height > keyboardRect.origin.y) {
                [UIView animateWithDuration:0.5 animations:^{
                    self.scrollView.frame = CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y - (rect.origin.y + rect.size.height - keyboardRect.origin.y), self.scrollView.frame.size.width, self.scrollView.frame.size.height);
                } completion:^(BOOL finished) {
                    offSet = rect.origin.y + rect.size.height - keyboardRect.origin.y;
                    which = -1;
                }];
            }
        }
    }
    
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
//    if (_cuiPickerView.isShow) {
//        [_cuiPickerView hiddenPickerView];
//    }
    if ([self.topicTextField isFirstResponder]) {
        [self.topicTextField resignFirstResponder];
    }
    if (offSet > 0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            } completion:^(BOOL finished) {
            offSet = 0;
        }];
    }
    if ([self.addressBtn isFirstResponder]) {
        [self.addressBtn resignFirstResponder];
    }
    if ([self.activityPay isFirstResponder]) {
        [self.activityPay resignFirstResponder];
    }
    if ([self.activityMenCount isFirstResponder]) {
        [self.activityMenCount resignFirstResponder];
    }
    if ([self.contentTextView isFirstResponder]) {
        [self.contentTextView resignFirstResponder];
    }
}
//赋值给textField
-(void)didFinishPickView:(NSString *)date
{
    
    if (beginOrEnd) {
        [self.beginTimeLabel setText:date];
    }else{
        [self.endTimeLabel setText:date];
    }
    NSLog(@"%@",date);
}
-(UIScrollView *)scrollView{
    if (_scrollView) {
        return _scrollView;
    }
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scrollView.directionalLockEnabled = YES; //只能一个方向滑动
    _scrollView.pagingEnabled = NO; //是否翻页
    _scrollView.backgroundColor = [ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Inteval_Color" WithKind:XMLTypeColors]];
    _scrollView.showsVerticalScrollIndicator =YES; //垂直方向的滚动指示
    _scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;//滚动指示的风格
    _scrollView.showsHorizontalScrollIndicator = NO;//水平方向的滚动指示
    return _scrollView;
}

-(void) backAction{
    [self.navigationController popViewControllerAnimated:YES];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)sendActionSender{
    if (self.topicTextField.text.length == 0) {
        [Toast makeShowCommen:@"您未填写 " ShowHighlight:@"活动主题" HowLong:0.8];
        return;
    }
//    if (self.beginTimeLabel.text.length == 0) {
//        [Toast makeShowCommen:@"您未选择 " ShowHighlight:@"开始时间" HowLong:0.8];
//        return;
//    }
    if (self.endTimeLabel.text.length == 0) {
        [Toast makeShowCommen:@"您未选择 " ShowHighlight:@"结束时间" HowLong:0.8];
        return;
    }
//    if (self.addressBtn.titleLabel.text.length == 0) {
//        [Toast makeShowCommen:@"您未选择 " ShowHighlight:@"活动地址" HowLong:0.8];
//        return;
//    }
    if (self.contentTextView.text.length == 0) {
        [Toast makeShowCommen:@"您未填写 " ShowHighlight:@"活动描述" HowLong:0.8];
        return;
    }
        if (self.activityPay.text.length == 0) {
        [Toast makeShowCommen:@"您未填写 " ShowHighlight:@"活动费用" HowLong:0.8];
        return;
    }
    if (self.activityMenCount.text.length == 0) {
        [Toast makeShowCommen:@"您未填写 " ShowHighlight:@"活动人数" HowLong:0.8];
        return;
    }
    if (!self.clippedBtn.imageView.image) {
        [Toast makeShowCommen:@"您未选择 " ShowHighlight:@"主题海报封面" HowLong:0.8];
        return;
    }
    
    UserInfo *userInfo = [[LoginVM getInstance] readLocal];
    if (!userInfo && !userInfo.token) {
        return;
    }
    NSLog(@"%@",userInfo);
    SendActivityModel *sendActivityModel = [[SendActivityModel alloc]init];
    sendActivityModel.access_token = userInfo.token;
    sendActivityModel.activity_type = self.activityType.titleLabel.text;
    sendActivityModel.activity_title = self.topicTextField.text;
    sendActivityModel.activity_content = self.contentTextView.text;
    sendActivityModel.activity_start_date = self.beginTimeLabel.text;
    sendActivityModel.activity_end_date = self.endTimeLabel.text;
    sendActivityModel.max_count = self.activityMenCount.text;
    sendActivityModel.activity_score = self.activityPay.text;
    sendActivityModel.lng = [NSString stringWithFormat:@"%f",self.cityModel.longitude];
    sendActivityModel.lat = [NSString stringWithFormat:@"%f",self.cityModel.latitude];
    sendActivityModel.city = self.cityModel.city;
    sendActivityModel.activity_address = [self.addressBtn.titleLabel.text stringByAppendingString:self.cityModel.name];
    
    self.picIDAry = [[NSMutableArray alloc]init];
    CustomAlertView *alertView = [CustomAlertView defaultCustomAlertView:@"发布中..."];
    [self lew_presentPopupView:alertView animation:[LewPopupViewAnimationSpring new]];
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
    NSString *absolutePath = [ValuesFromXML getValueWithName:@"Sever_Absolute_Address" WithKind:XMLTypeNetPort];
    NSString *path = [absolutePath stringByAppendingPathComponent:[ValuesFromXML getValueWithName:@"UPLoad_Picture" WithKind:XMLTypeNetPort]];
    
    NSMutableArray *tempImageAry = [[NSMutableArray alloc]init];
    [tempImageAry addObject:self.clippedBtn.imageView.image];
    for (int j = 0; j < self.containerView.imageAry.count; j ++) {
        [tempImageAry addObject:[self.containerView.imageAry objectAtIndex:j]];
    }
    [self uploadPicAndOtherInfo:tempImageAry WithPath:path WithModel:sendActivityModel WithQueue:queue WithAlertView:alertView];
}

- (void)uploadPicAndOtherInfo:(NSMutableArray *) tempImageAry WithPath:(NSString *) path WithModel:(SendActivityModel *)sendActivityModel WithQueue:(dispatch_queue_t) queue WithAlertView:(CustomAlertView *) alertView{
    __block SendActivityVC *wself = self;
    dispatch_async(queue, ^{
        NSLog(@"%ld",self.picIDAry.count);
        [HttpManager uploadPictures:nil WithUrlString:path Image:[tempImageAry objectAtIndex:self.picIDAry.count
                                                                  ]];
        [HttpManager shareManager].returnData = ^(NSDictionary *dict){
            int state = [[dict objectForKey:@"state"] intValue];
            if (1 == state) {
                NSDictionary *data = [dict objectForKey:@"data"];
                if (data) {
                    NSString *picID = [data objectForKey:@"id"];
                    if (picID) {
                        [self.picIDAry addObject:[NSString stringWithFormat:@"%@|",picID]];
                        if (self.picIDAry.count == tempImageAry.count) {
                            NSMutableString *picString = [[NSMutableString alloc]init];
                            for (int i = 0; i < self.picIDAry.count; i ++) {
                                [picString appendString:[self.picIDAry objectAtIndex:i]];
                            }
                            sendActivityModel.pic = picString;
                            SendAndGetDataFromNet *send = [[SendAndGetDataFromNet alloc]init];
                            send.returnModel = ^(GetValueObject *obj,int state){
                                if (1 == state) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        //                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateDynamic" object:self userInfo:nil];
                                        [alertView setTitle:@"发布成功"];
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            [wself lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
                                            [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                [wself backAction];
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
                            [send commenDataFromNet:sendActivityModel WithRelativePath:@"Send_Activity"];
                        }else{
                            [wself uploadPicAndOtherInfo:tempImageAry WithPath:path WithModel:sendActivityModel WithQueue:queue WithAlertView:alertView];
                        }
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

-(void) initActivityTopic{
    activityTopicView = [[UIView alloc]initWithFrame:CGRectMake(0, 16, self.view.frame.size.width, 44)];
    activityTopicView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:activityTopicView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 80, activityTopicView.frame.size.height)];
    titleLabel.font = [UIFont systemFontOfSize:15];
    [titleLabel setTextColor:RGB(136, 136, 136, 1)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [titleLabel setText:@"活动主题 :"];
    [activityTopicView addSubview:titleLabel];
    
    self.topicTextField = [[UITextField alloc]init];
    self.topicTextField.font = [UIFont systemFontOfSize:15];
    self.topicTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.topicTextField.delegate = self;
    [self.topicTextField setFont:[UIFont systemFontOfSize:15]];
    [self.topicTextField setTextColor:RGB(76, 76, 76, 1)];
    [activityTopicView addSubview:self.topicTextField];
    [self.topicTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(activityTopicView);
        make.left.equalTo(activityTopicView).offset(102);
        make.size.mas_equalTo(CGSizeMake(activityTopicView.frame.size.width - 102 - 64, 21));
    }];
    
    UIButton *imageBtn = [[UIButton alloc]init];
    [activityTopicView addSubview:imageBtn];
    [imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.centerY.equalTo(activityTopicView);
        make.right.equalTo(activityTopicView).with.offset(-20);
    }];
    [imageBtn addTarget:self action:@selector(imageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageView = [[UIImageView alloc]init];
    [imageBtn addSubview:imageView];
    [imageView setImage:[UIImage imageNamed:@"grzx_activity-edut_time"]];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.centerY.equalTo(imageBtn);
        make.right.equalTo(imageBtn).with.offset(0);
    }];
    
}

-(void)imageBtnAction:(UIButton *)btn{
    isImagePicker = YES;
    [self takePhoto];
}

-(UIButton *)clippedBtn{
    if (!_clippedBtn) {
        _clippedBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT / 3)];
        [self.scrollView addSubview:_clippedBtn];
        [_clippedBtn addTarget:self action:@selector(clippedBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _clippedBtn.hidden = YES;
    }
    return _clippedBtn;
}

-(void)clippedBtnAction:(UIButton *)btn{
    BanerImageVC *banerVC = [[BanerImageVC alloc]init];
    banerVC.image = btn.imageView.image;
    __weak typeof (self) wself = self;
    banerVC.returnImage = ^(UIImage *image,int state){
        if (0 == state) {
            [UIView animateWithDuration:0.6 animations:^{
                [_clippedBtn setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
                [activityTopicView setFrame:CGRectMake(0, - SCREEN_HEIGHT / 3 + activityTopicView.frame.origin.y, SCREEN_WIDTH, activityTopicView.frame.size.height)];
                [activityDetailView setFrame:CGRectMake(0, - SCREEN_HEIGHT / 3 + activityDetailView.frame.origin.y, SCREEN_WIDTH, activityDetailView.frame.size.height)];
                [contentView setFrame:CGRectMake(contentView.frame.origin.x, - SCREEN_HEIGHT / 3 + contentView.frame.origin.y, contentView.frame.size.width, contentView.frame.size.height)];
                [wself.containerView setFrame:CGRectMake(wself.containerView.frame.origin.x, wself.containerView.frame.origin.y - SCREEN_HEIGHT / 3, wself.containerView.frame.size.width, wself.containerView.frame.size.height)];
                [wself.activitySettingView setFrame:CGRectMake(wself.activitySettingView.frame.origin.x, wself.activitySettingView.frame.origin.y - SCREEN_HEIGHT / 3, wself.activitySettingView.frame.size.width, wself.activitySettingView.frame.size.height)];
                [wself.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, wself.scrollView.contentSize.height - SCREEN_HEIGHT / 3)];
                [wself.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                [_clippedBtn removeFromSuperview];
                _clippedBtn = nil;
            }];
        }else if (1 == state){
            [self photoWithSourceType:UIImagePickerControllerSourceTypeCamera];
        }else if (2 == state){
            [self photoWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }else if (3 == state){
            
        }
    };
    [self.navigationController pushViewController:banerVC animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    //自定义裁剪方式
    UIImage*image = [self turnImageWithInfo:info];
    HKImageClipperViewController *clipperVC = [[HKImageClipperViewController alloc]initWithBaseImg:image
                                                                                         resultImgSize:self.clippedBtn.frame.size clipperType:ClipperTypeImgMove];
    __weakSelf(self);
    clipperVC.cancelClippedHandler = ^(){
        [picker dismissViewControllerAnimated:YES completion:nil];
    };
    clipperVC.successClippedHandler = ^(UIImage *clippedImage){
        __strongSelf(weakSelf);
        [strongSelf.clippedBtn setImage:clippedImage forState:UIControlStateNormal];
        if (strongSelf.clippedBtn.hidden) {
            strongSelf.clippedBtn.hidden = NO;
            [UIView animateWithDuration:0.4 animations:^{
                [temp setFrame:CGRectMake(0, SCREEN_HEIGHT / 3 + temp.frame.origin.y, SCREEN_WIDTH, temp.frame.size.height)];
                [activityTopicView setFrame:CGRectMake(0, SCREEN_HEIGHT / 3 + activityTopicView.frame.origin.y, SCREEN_WIDTH, activityTopicView.frame.size.height)];
                [activityDetailView setFrame:CGRectMake(0, SCREEN_HEIGHT / 3 + activityDetailView.frame.origin.y, SCREEN_WIDTH, activityDetailView.frame.size.height)];
                [contentView setFrame:CGRectMake(contentView.frame.origin.x, SCREEN_HEIGHT / 3 + contentView.frame.origin.y, contentView.frame.size.width, contentView.frame.size.height)];
                [strongSelf.containerView setFrame:CGRectMake(strongSelf.containerView.frame.origin.x, strongSelf.containerView.frame.origin.y + SCREEN_HEIGHT / 3, strongSelf.containerView.frame.size.width, strongSelf.containerView.frame.size.height)];
                [strongSelf.activitySettingView setFrame:CGRectMake(strongSelf.activitySettingView.frame.origin.x, strongSelf.activitySettingView.frame.origin.y + SCREEN_HEIGHT / 3, strongSelf.activitySettingView.frame.size.width, strongSelf.activitySettingView.frame.size.height)];
                [strongSelf.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, strongSelf.scrollView.contentSize.height + SCREEN_HEIGHT / 3)];
                [strongSelf.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                
            }];
        }
        
        
                    //            strongSelf.layerView.layer.contents =(__bridge id _Nullable)(clippedImage.CGImage);
            //            strongSelf.layerView.contentMode = UIViewContentModeScaleAspectFit;
            //            strongSelf.layerView.layer.contentsGravity = kCAGravityResizeAspect;
        [picker dismissViewControllerAnimated:YES completion:nil];
    };
        
    [picker pushViewController:clipperVC animated:YES];
    
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


- (void)photoWithSourceType:(UIImagePickerControllerSourceType)type{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = type;
    //imagePicker.allowsEditing = self.systemEditing;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}


- (void)takePhoto {
    UIActionSheet *_sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"拍照", @"从手机选择", nil];
    [_sheet showInView:[UIApplication sharedApplication].keyWindow];
}

-(void) initActivityDetail{

    activityDetailView = [[UIView alloc]initWithFrame:CGRectMake(0, 54 + 26, self.view.frame.size.width, 134)];
    descriptionHeight = 54 + 26 + 134;
    activityDetailView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:activityDetailView];
    
    UILabel *titleLabel1 = [UILabel createMyLabelWithFrame:CGRectMake(20, 0, 80, 44) Font:15 Text:@"开始时间 :" andLCR:0 andColor:RGB(136, 136, 136, 1)];
    [activityDetailView addSubview:titleLabel1];
    self.beginTime = [[UIButton alloc]initWithFrame:CGRectMake(102, 0, activityDetailView.frame.size.width - 102, 44)];
    [self.beginTime addTarget:self action:@selector(datePickSender:) forControlEvents:UIControlEventTouchUpInside];
    self.beginTime.tag = 0;
    [activityDetailView addSubview:self.beginTime];
    UIImageView *rowImageView = [[UIImageView alloc]init];
    [self.beginTime addSubview:rowImageView];
    [rowImageView setImage:[UIImage imageNamed:@"grzx_activity-edut_time"]];
    [rowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.centerY.equalTo(self.beginTime);
        make.right.equalTo(self.beginTime).with.offset(-20);
    }];
    self.beginTimeLabel = [[UILabel alloc]init];
    [self.beginTime addSubview:self.beginTimeLabel];
    self.beginTimeLabel.textColor = RGB(76, 76, 76, 1);
    self.beginTimeLabel.font = [UIFont systemFontOfSize:15];
    self.beginTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self.beginTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.beginTime.frame.size.width, 21));
        make.centerY.equalTo(self.beginTime);
        make.right.equalTo(self.beginTime).with.offset(-40);
    }];

    UILabel *interal1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 44, activityDetailView.frame.size.width - 40, .5)];
    interal1.backgroundColor = RGB(180, 180, 180, 1);
    [activityDetailView addSubview:interal1];
    
    UILabel *titleLabel2 = [UILabel createMyLabelWithFrame:CGRectMake(20, 44.5, 80, 44) Font:15 Text:@"结束时间 :" andLCR:0 andColor:RGB(136, 136, 136, 1)];
    [activityDetailView addSubview:titleLabel2];
    self.endTime = [[UIButton alloc]initWithFrame:CGRectMake(102, 44.5, activityDetailView.frame.size.width - 102, 44)];
    [self.endTime addTarget:self action:@selector(datePickSender:) forControlEvents:UIControlEventTouchUpInside];
    self.endTime.tag = 1;
    [activityDetailView addSubview:self.endTime];
    UIImageView *rowImageView2 = [[UIImageView alloc]init];
    [self.endTime addSubview:rowImageView2];
    [rowImageView2 setImage:[UIImage imageNamed:@"grzx_activity-edut_time"]];
    [rowImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.centerY.equalTo(self.endTime);
        make.right.equalTo(self.endTime).with.offset(-20);
    }];
    self.endTimeLabel = [[UILabel alloc]init];
    [self.endTime addSubview:self.endTimeLabel];
    self.endTimeLabel.textColor = RGB(76, 76, 76, 1);
    self.endTimeLabel.font = [UIFont systemFontOfSize:15];
    self.endTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self.endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.endTime.frame.size.width, 21));
        make.centerY.equalTo(self.endTime);
        make.right.equalTo(self.endTime).with.offset(-40);
    }];
    UILabel *interal2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 44 + 44.5, activityDetailView.frame.size.width - 40, .5)];
    interal2.backgroundColor = RGB(180, 180, 180, 1);
    [activityDetailView addSubview:interal2];
    
    UILabel *titleLabel3 = [UILabel createMyLabelWithFrame:CGRectMake(20, 44.5 * 2, 80, 44) Font:15 Text:@"活动地址 :" andLCR:0 andColor:RGB(136, 136, 136, 1)];
    [activityDetailView addSubview:titleLabel3];
    self.addressBtn = [[UIButton alloc]init];
    self.addressBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.addressBtn setTitleColor:RGB(76, 76, 76, 1) forState:UIControlStateNormal];
    [self.addressBtn addTarget:self action:@selector(adressAction) forControlEvents:UIControlEventTouchUpInside];
    [activityDetailView addSubview:self.addressBtn];
    [self.addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(activityDetailView).offset(44.5 * 2 + (44 - 21) / 2);
        make.left.equalTo(activityDetailView).offset(102);
        make.size.mas_equalTo(CGSizeMake(activityDetailView.frame.size.width - 102 - 20, 21));
    }];

    UILabel *interal3 = [[UILabel alloc]initWithFrame:CGRectMake(20, 44 + 44.5 * 2, activityDetailView.frame.size.width - 40, .5)];
    interal3.backgroundColor = RGB(180, 180, 180, 1);
    [activityDetailView addSubview:interal3];
}

-(void)adressAction{
    SelectAdressVC *selectVC = [[SelectAdressVC alloc]init];
    selectVC.returnAdress = ^(cityModel *model){
        self.cityModel = model;
        if (!self.adressName) {
            if (self.clippedBtn && !self.clippedBtn.hidden) {
                descriptionHeight += SCREEN_HEIGHT / 3;
            }
            temp = [[UIView alloc]initWithFrame:CGRectMake(0, descriptionHeight, SCREEN_WIDTH, 44)];
            [temp setBackgroundColor:[UIColor whiteColor]];
            [self.scrollView addSubview:temp];
            self.adressName = [[UITextField alloc]init];
            self.adressName.delegate = self;
            self.adressName.keyboardType = UIKeyboardTypeNumberPad;
            [self.adressName setFont:[UIFont systemFontOfSize:15]];
            [self.adressName setTextAlignment:NSTextAlignmentLeft];
            [self.adressName setTextColor:RGB(76, 76, 76, 1)];
            [self.adressName setFrame:CGRectMake(102, (44 - 21) / 2, SCREEN_WIDTH - 102 - 20, 21)];
            [temp addSubview:self.adressName];
            
            UIView *interal = [[UIView alloc]initWithFrame:CGRectMake(20, 43.5, SCREEN_WIDTH - 40, .5)];
            interal.backgroundColor = RGB(180, 180, 180, 1);
            [temp addSubview:interal];
            
            descriptionHeight += 44;
            [contentView setFrame:CGRectMake(contentView.frame.origin.x, descriptionHeight, contentView.frame.size.width, contentView.frame.size.height)];
            [self.containerView setFrame:CGRectMake(self.containerView.frame.origin.x, self.containerView.frame.origin.y + 44, self.containerView.frame.size.width, self.containerView.frame.size.height)];
            [self.activitySettingView setFrame:CGRectMake(self.activitySettingView.frame.origin.x, self.activitySettingView.frame.origin.y + 44, self.activitySettingView.frame.size.width, self.activitySettingView.frame.size.height)];
            [self.view layoutIfNeeded];
        }
        
        [self.addressBtn setTitle:model.address forState:UIControlStateNormal];
        [self.adressName setText:model.name];
    };
    [self presentViewController:selectVC animated:YES completion:^{
        
    }];
}

-(void) datePickSender:(UIButton *) btn{
    
    if (0 == btn.tag) {
        beginOrEnd = YES;
    }else{
        beginOrEnd = NO;
    }
    [_cuiPickerView showInView:self.view];
}

-(void)initActivityDecription{
    contentView = [[UIView alloc]initWithFrame:CGRectMake(0, descriptionHeight, SCREEN_WIDTH, 83)];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    [self.scrollView addSubview:contentView];
    self.contentTextView = [[UIPlaceHolderTextView alloc]initWithFrame:CGRectMake(13, 3, SCREEN_WIDTH - 26, 80)];
    self.contentTextView.font = [UIFont systemFontOfSize:15];
    self.contentTextView.textColor = RGB(76, 76, 76, 1);
    self.contentTextView.placeholder = @"活动描述";
    self.contentTextView.delegate = self;
    [contentView addSubview:self.contentTextView];
    [self initContainerView];
}

-(void)initContainerView{
    self.containerView = [[SendNineImageView alloc]initWithFrame:CGRectMake(0, descriptionHeight + 83, SCREEN_WIDTH, (SCREEN_WIDTH - 50 - 3 * valueObj.inteval) / 4 + 3 * valueObj.inteval)];
    self.containerView.backgroundColor = [UIColor whiteColor];
    
    [self.containerView initViews:(SCREEN_WIDTH - 50 - 3 * valueObj.inteval) / 4 Inteval:1.5 *valueObj.inteval];
    __weak SendActivityVC *wself = self;
    self.containerView.clickAction = ^(NSInteger tag){
        if (wself.containerView.imageAry.count > 9) {
            return;
        }
        if (10 == tag) {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:wself cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机选择", @"拍照", nil];
            sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            [sheet showInView:wself.view];
        }else{
            NSMutableArray *photoArray = [[NSMutableArray alloc] init];
            for (int i = 0;i< wself.containerView.imageAry.count; i ++) {
                UIImage *image = wself.containerView.imageAry[i];
                
                MJPhoto *photo = [MJPhoto new];
                photo.image = image;
                photo.srcImageView = [wself.containerView.viewsAry objectAtIndex:tag];
                [photoArray addObject:photo];
            }
            
            MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
            browser.photoBrowserdelegate = wself;
            browser.currentPhotoIndex = tag;
            browser.photos = photoArray;
            [browser show];
            
        }
    };
    [self.scrollView addSubview:self.containerView];
}

-(void) initActivitySetting{
    self.activitySettingView = [[UIView alloc]initWithFrame:CGRectMake(0, self.containerView.frame.origin.y + self.containerView.frame.size.height, SCREEN_WIDTH, 39 + 3 * 44)];
    [self.scrollView addSubview:self.activitySettingView];
    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, self.containerView.frame.origin.y + self.containerView.frame.size.height + 39 + 3 * 44)];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 29, self.activitySettingView.frame.size.width, 44.5)];
    [self.activitySettingView addSubview:view1];
    [view1 setBackgroundColor:[UIColor whiteColor]];
    UILabel *titleLabel1 = [UILabel createMyLabelWithFrame:CGRectMake(20, 0, 80, 44) Font:15 Text:@"活动类型 :" andLCR:0 andColor:RGB(136, 136, 136, 1)];
    [titleLabel1 setBackgroundColor:[UIColor whiteColor]];
    [view1 addSubview:titleLabel1];
    self.activityType = [[UIButton alloc]initWithFrame:CGRectMake(100, 0, self.activitySettingView.frame.size.width - 100, 44)];
    [self.activityType addTarget:self action:@selector(activityTypeAction) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:self.activityType];
    UIImageView *rowImageView = [[UIImageView alloc]init];
    [self.activityType addSubview:rowImageView];
    [rowImageView setImage:[UIImage imageNamed:@"grzx_grzx_right"]];
    [rowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(9, 16));
        make.centerY.equalTo(self.activityType);
        make.right.equalTo(self.activityType).with.offset(-20);
    }];
    self.activityTypeLabel = [[UILabel alloc]init];
    [self.activityType addSubview:self.activityTypeLabel];
    self.activityTypeLabel.textColor = RGB(76, 76, 76, 1);
    self.activityTypeLabel.text = @"类型一   -200帮币";
    self.activityTypeLabel.font = [UIFont systemFontOfSize:15];
    self.activityTypeLabel.textAlignment = NSTextAlignmentCenter;
    [self.activityTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.activitySettingView.frame.size.width - 100 - 35, 21));
        make.centerY.equalTo(self.activityType);
        make.right.equalTo(self.activityType).with.offset(-35);
    }];
    
    UILabel *interal1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 44, self.activitySettingView.frame.size.width - 40, .5)];
    interal1.backgroundColor = RGB(180, 180, 180, 1);
    [view1 addSubview:interal1];
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 29 + 44.5, self.activitySettingView.frame.size.width, 44)];
    [self.activitySettingView addSubview:view2];
    [view2 setBackgroundColor:[UIColor whiteColor]];
    UILabel *titleLabel2 = [UILabel createMyLabelWithFrame:CGRectMake(20, 0, 80, 44) Font:15 Text:@"活动费用 :" andLCR:0 andColor:RGB(136, 136, 136, 1)];
    [titleLabel2 setBackgroundColor:[UIColor whiteColor]];
    [view2 addSubview:titleLabel2];
    self.activityPay = [[UITextField alloc]init];
    self.activityPay.delegate = self;
    self.activityPay.keyboardType = UIKeyboardTypeNumberPad;
    [self.activityPay setTextAlignment:NSTextAlignmentCenter];
    [self.activityPay setFont:[UIFont systemFontOfSize:15]];
    [self.activityPay setTextColor:RGB(234, 128, 17, 1)];
    [view2 addSubview:self.activityPay];
    [self.activityPay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view2);
        make.left.equalTo(view2).offset(100);
        make.size.mas_equalTo(CGSizeMake(self.activitySettingView.frame.size.width - 102, 21));
    }];
    
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(0, 29 + 44.5 + 44 + 10, self.activitySettingView.frame.size.width, 44)];
    [self.activitySettingView addSubview:view3];
    [view3 setBackgroundColor:[UIColor whiteColor]];
    UILabel *titleLabel3 = [UILabel createMyLabelWithFrame:CGRectMake(20, 0, 80, 44) Font:15 Text:@"活动人数 :" andLCR:0 andColor:RGB(136, 136, 136, 1)];
    [titleLabel3 setBackgroundColor:[UIColor whiteColor]];
    [view3 addSubview:titleLabel3];
    self.activityMenCount = [[UITextField alloc]init];
    self.activityMenCount.delegate = self;
    self.activityMenCount.keyboardType = UIKeyboardTypeNumberPad;
    [self.activityMenCount setFont:[UIFont systemFontOfSize:15]];
    [self.activityMenCount setTextAlignment:NSTextAlignmentCenter];
    [self.activityMenCount setTextColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]]];
    [view3 addSubview:self.activityMenCount];
    [self.activityMenCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view3);
        make.left.equalTo(view3).offset(100);
        make.size.mas_equalTo(CGSizeMake(self.activitySettingView.frame.size.width - 102, 21));
    }];
}

-(void) activityTypeAction{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"类型一   -200帮币", @"类型二   -400帮币",@"类型三   -800帮币", nil];
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    sheet.tag = 20;
    [sheet showInView:self.view];
}

-(void)deletedPictures:(NSSet *)set
{
    NSMutableArray *delArray = [NSMutableArray array];
    
    for (NSString *index1 in set) {
        [delArray addObject:index1];
    }
    
    if (delArray.count == 0) {
        
    }else{
        NSMutableArray *tempAry = [[NSMutableArray alloc]init];
        for (int i = 0; i < self.containerView.imageAry.count; i ++) {
            BOOL isEqual = NO;
            for (int j = 0; j < delArray.count; j ++) {
                NSInteger tag = [[delArray objectAtIndex:j] integerValue] - 1;
                if (i == tag) {
                    isEqual = YES;
                    break;
                }else if (tag < 0){
                    isEqual = YES;
                    break;
                }
            }
            if (!isEqual) {
                [tempAry addObject:[self.containerView.imageAry objectAtIndex:i]];
            }
        }
        [self.containerView.imageAry removeAllObjects];
        self.containerView.imageAry = tempAry;
        [self.containerView removeAllViews];
        if (self.containerView.imageAry.count < 4) {
            self.containerView.frame = CGRectMake(0, self.containerView.frame.origin.y, SCREEN_WIDTH, (SCREEN_WIDTH - 50 - 3 * valueObj.inteval) / 4 + 3 * valueObj.inteval);
        }else if (self.containerView.imageAry.count <8)
        {
            self.containerView.frame = CGRectMake(0, self.containerView.frame.origin.y, SCREEN_WIDTH, 2 * (SCREEN_WIDTH - 50 - 3 * valueObj.inteval) / 4 + 4.5 * valueObj.inteval);
        }else
        {
            self.containerView.frame = CGRectMake(0, self.containerView.frame.origin.y, SCREEN_WIDTH, 3 * (SCREEN_WIDTH - 50 - 3 * valueObj.inteval) / 4 + 6 * valueObj.inteval);
        }
        
        [self.containerView initViews:(SCREEN_WIDTH - 50 - 3 * valueObj.inteval) / 4 Inteval:1.5 *valueObj.inteval];
    
        [UIView animateWithDuration:.25 animations:^{
            self.activitySettingView.frame = CGRectMake(0, self.containerView.frame.origin.y + self.containerView.frame.size.height, SCREEN_WIDTH, self.activitySettingView.frame.size.height);
        } completion:^(BOOL finished) {
            [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, self.activitySettingView.frame.origin.y + self.activitySettingView.frame.size.height + 100)];
        }];
        [self.containerView layoutIfNeeded];
    }
}

#pragma mark - 相册、相机调用方法
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (isImagePicker) {
        dispatch_after(0., dispatch_get_main_queue(), ^{
            if (buttonIndex == 0) {
                [self photoWithSourceType:UIImagePickerControllerSourceTypeCamera];
            }
            else if(buttonIndex == 1) {
                [self photoWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            }else if (buttonIndex == 2){
                
            }
        });
        isImagePicker = NO;
        return;
    }
    if (actionSheet.tag == 20) {
        if (buttonIndex != 0) {
            [self.activityTypeLabel setText:[actionSheet buttonTitleAtIndex:buttonIndex]];
        }
        return;
    }
    if (buttonIndex == 0) {
        NSLog(@"点击了从手机选择");
        
        ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
        elcPicker.maximumImagesCount = 8 - self.containerView.imageAry.count;
        elcPicker.returnsOriginalImage = YES;
        elcPicker.returnsImage = YES;
        elcPicker.onOrder = NO;
        elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie];
        elcPicker.imagePickerDelegate = self;
        //    elcPicker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;//过渡特效
        [self presentViewController:elcPicker animated:YES completion:nil];
        
    }else if (buttonIndex == 1)
    {
        NSLog(@"点击了拍照");
        
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            //设置拍照后的图片可被编辑
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            
            picker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            
            [self presentViewController:picker animated:YES completion:nil];
        }else{
            NSLog(@"模拟无效,请真机测试");
        }
        
    }else if (buttonIndex == 2)
    {
    }
}

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    
    __weak SendActivityVC *wself = self;
    [self dismissViewControllerAnimated:YES completion:^{
        //[wself.itemsSectionPictureArray removeAllObjects];
        BOOL hasVideo = NO;
        //[self.containerView removeAllViews];
        for (NSDictionary *dict in info) {
            if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
                if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                    UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                    CGSize newSize;
//                    if (image.size.height > image.size.width) {
//                        newSize = [UIScreen mainScreen].bounds.size;
//                    }else{
//                        
//                    }
                    newSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * image.size.height / image.size.width);
                    [wself.containerView.imageAry addObject:[UIImage imageWithData:[[ZJBHelp getInstance] compressImage:image toMaxFileSize:100 * 1024 ScaledToSize:newSize]]];
                } else {
                    NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
                }
            } else if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypeVideo){
                if (!hasVideo) {
                    hasVideo = YES;
                }
            } else {
                NSLog(@"Uknown asset type");
            }
        }
        //[wself.itemsSectionPictureArray addObject:[UIImage imageNamed:@"添加.png"]];
        [UIView animateWithDuration:.25 delay:0 options:7 animations:^{
            
            if (self.containerView.imageAry.count < 4) {
                self.containerView.frame = CGRectMake(0, self.containerView.frame.origin.y, SCREEN_WIDTH, (SCREEN_WIDTH - 50 - 3 * valueObj.inteval) / 4 + 3 * valueObj.inteval);
            }else if (self.containerView.imageAry.count <8)
            {
                self.containerView.frame = CGRectMake(0, self.containerView.frame.origin.y, SCREEN_WIDTH, 2 * (SCREEN_WIDTH - 50 - 3 * valueObj.inteval) / 4 + 4.5 * valueObj.inteval);
            }else
            {
                self.containerView.frame = CGRectMake(0, self.containerView.frame.origin.y, SCREEN_WIDTH, 3 * (SCREEN_WIDTH - 50 - 3 * valueObj.inteval) / 4 + 6 * valueObj.inteval);
            }
            [self.containerView initViews:(SCREEN_WIDTH - 50 - 3 * valueObj.inteval) / 4 Inteval:1.5 *valueObj.inteval];
            [UIView animateWithDuration:.25 animations:^{
                self.activitySettingView.frame = CGRectMake(0, self.containerView.frame.origin.y + self.containerView.frame.size.height, SCREEN_WIDTH, self.activitySettingView.frame.size.height);
            } completion:^(BOOL finished) {
                [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, self.activitySettingView.frame.origin.y + self.activitySettingView.frame.size.height + 100)];
            }];
            [wself.view layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            // 添加新选择的图片
            
        }];
    }];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
     
    [self.itemsSectionPictureArray addObject:image];
    __weak SendActivityVC *wself = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        CGSize newSize;
        if (image.size.height > image.size.width) {
            newSize = [UIScreen mainScreen].bounds.size;
        }else{
            newSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * image.size.height / image.size.width);
        }
        [self.containerView.imageAry addObject:[UIImage imageWithData:[[ZJBHelp getInstance] compressImage:image toMaxFileSize:100 * 1024 ScaledToSize:newSize]]];
        
        [UIView animateWithDuration:.25 delay:0 options:7 animations:^{
            
            if (self.containerView.imageAry.count < 4) {
                self.containerView.frame = CGRectMake(0, self.containerView.frame.origin.y, SCREEN_WIDTH, (SCREEN_WIDTH - 50 - 3 * valueObj.inteval) / 4 + 3 * valueObj.inteval);
            }else if (self.containerView.imageAry.count <8)
            {
                self.containerView.frame = CGRectMake(0, self.containerView.frame.origin.y, SCREEN_WIDTH, 2 * (SCREEN_WIDTH - 50 - 3 * valueObj.inteval) / 4 + 4.5 * valueObj.inteval);
            }else
            {
                self.containerView.frame = CGRectMake(0, self.containerView.frame.origin.y, SCREEN_WIDTH, 3 * (SCREEN_WIDTH - 50 - 3 * valueObj.inteval) / 4 + 6 * valueObj.inteval);
            }
           
            [self.containerView initViews:(SCREEN_WIDTH - 50 - 3 * valueObj.inteval) / 4 Inteval:1.5 *valueObj.inteval];
            [UIView animateWithDuration:.25 animations:^{
                self.activitySettingView.frame = CGRectMake(0, self.containerView.frame.origin.y + self.containerView.frame.size.height, SCREEN_WIDTH, self.activitySettingView.frame.size.height);
            } completion:^(BOOL finished) {
                [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, self.activitySettingView.frame.origin.y + self.activitySettingView.frame.size.height + 100)];
            }];
            [wself.view layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            // 添加新选择的图片
            
        }];
    }];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 发送文本
- (void)chatKeyBoardSendText:(NSString *)text
{
    self.contentTextView.text = text;
}

- (void)clickBtnUp:(UIButton *)btn
{
    [self.chatKeyBoard keyboardUp];
}

- (void)clickBtnDown:(UIButton *)btn
{
    [self.chatKeyBoard keyboardDown];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

@end
