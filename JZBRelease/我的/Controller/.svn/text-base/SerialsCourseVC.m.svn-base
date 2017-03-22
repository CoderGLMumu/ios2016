//
//  SerialsCourseVC.m
//  JZBRelease
//
//  Created by cl z on 16/9/13.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "SerialsCourseVC.h"
#import "Defaults.h"
#import "UIPlaceHolderTextView.h"
#import "HKModelMarco.h"
#import "HKImageClipperViewController.h"
#import "SendSerialsModel.h"
#import "LewPopupViewAnimationSpring.h"
#import "SendAndGetDataFromNet.h"
@interface SerialsCourseVC ()<UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    NSMutableArray *allAry,*emerBtnAry,*courseProAry;
    NSInteger pre,emerPre,coursePro;
    UIView *typeView,*coursePropertyView,*courseNameView,*courseIntroduceView;
    NSInteger offSet,which;
    
}

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIImageView *banarView;
@property(nonatomic, strong) UITextField *courseNameTextView;
@property(nonatomic, strong) UIPlaceHolderTextView *courseIntroduceTextView;
@end

@implementation SerialsCourseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    emerPre = 0;
    coursePro = 0;
    [self.view addSubview:self.scrollView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.scrollView addSubview:[self returnTitleView:@"课程海报" WithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)]];
    [self.scrollView addSubview:self.banarView];
    //[self initCourseType];
    [self initCourseProType];
    [self initCourseNameView];
    [self initCourseIntroduceView];
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
    [sendBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(okBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    UIBarButtonItem *sendBarBtn = [[UIBarButtonItem alloc]initWithCustomView:sendBtn];
    self.navigationItem.rightBarButtonItem = sendBarBtn;
    
}

- (void)okBtnAction{
    
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
    
    SendSerialsModel *sendSerialsModel = [[SendSerialsModel alloc]init];
    sendSerialsModel.access_token = [[LoginVM getInstance] readLocal].token;
//    if (0 == emerPre) {
//        sendSerialsModel.type = @"1";
//    }else{
//        sendSerialsModel.type = @"3";
//    }
    sendSerialsModel.type = @"2";
    if (0 == coursePro) {
        sendSerialsModel.tag = @"1";
    }else if(1 == coursePro){
        sendSerialsModel.tag = @"2";
    }else{
        sendSerialsModel.tag = @"3";
    }
    sendSerialsModel.title = self.courseNameTextView.text;
    sendSerialsModel.industry_id = @"";
    sendSerialsModel.content = self.courseIntroduceTextView.text;
    
    CustomAlertView *alertView = [CustomAlertView defaultCustomAlertView:@"发布中..."];
    [self lew_presentPopupView:alertView animation:[LewPopupViewAnimationSpring new]];
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
    NSString *absolutePath = [ValuesFromXML getValueWithName:@"Sever_Absolute_Address" WithKind:XMLTypeNetPort];
    NSString *path = [absolutePath stringByAppendingPathComponent:[ValuesFromXML getValueWithName:@"UPLoad_Picture" WithKind:XMLTypeNetPort]];
    
    [self uploadPicAndOtherInfo:self.banarView.image WithPath:path WithModel:sendSerialsModel WithQueue:queue WithAlertView:alertView];
}

- (void)uploadPicAndOtherInfo:(UIImage *) image WithPath:(NSString *) path WithModel:(SendSerialsModel *)sendSerialsModel WithQueue:(dispatch_queue_t) queue WithAlertView:(CustomAlertView *) alertView{
    __weak SerialsCourseVC *wself = self;
    dispatch_async(queue, ^{
        [HttpManager uploadPictures:nil WithUrlString:path Image:image];
        [HttpManager shareManager].returnData = ^(NSDictionary *dict){
            int state = [[dict objectForKey:@"state"] intValue];
            if (1 == state) {
                NSDictionary *data = [dict objectForKey:@"data"];
                if (data) {
                    NSString *picID = [data objectForKey:@"id"];
                    if (picID) {
                        sendSerialsModel.thumb = picID;
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
                        [send commenDataFromNet:sendSerialsModel WithRelativePath:@"Add_Course_URL"];
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
    _scrollView.directionalLockEnabled = YES; //只能一个方向滑动
    _scrollView.pagingEnabled = NO; //是否翻页
    _scrollView.backgroundColor = [ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Inteval_Color" WithKind:XMLTypeColors]];
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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self photoWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    else if(buttonIndex == 1) {
        [self photoWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }else if (buttonIndex == 2){
        
    }
}

- (void)photoWithSourceType:(UIImagePickerControllerSourceType)type{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = type;
    //imagePicker.allowsEditing = self.systemEditing;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:imagePicker animated:YES completion:nil];
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



/*- (void) initCourseType{
    CGRect frame = CGRectMake(0, self.banarView.frame.origin.y + self.banarView.frame.size.height, SCREEN_WIDTH, 35 + 61);
    
    typeView = [[UIView alloc]initWithFrame:frame];
    [typeView setBackgroundColor:[UIColor whiteColor]];
    [self.scrollView addSubview:typeView];
    [typeView addSubview:[self returnTitleView:@"开课方式" WithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)]];
    NSArray *typeAry = @[@"线上",@"线下"];
    for (int i = 0; i < 2; i ++) {
        UIView *subView = [[UIView alloc]init];
        if (0 == i) {
            subView.frame = CGRectMake(40, 20 + 35, 70, 21);
        }else{
            subView.frame = CGRectMake(SCREEN_WIDTH - 110, 20  + 35, 70, 21);
        }
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 21, 21)];
        if (i == 0) {
            [btn setImage:[UIImage imageNamed:@"bangba_questions_select"] forState:UIControlStateNormal];
        }else{
            [btn setImage:[UIImage imageNamed:@"bangba_questions_select2"] forState:UIControlStateNormal];
        }
        [btn setImage:[UIImage imageNamed:@"bangba_questions_select"] forState:UIControlStateHighlighted];
        [subView addSubview:btn];
        btn.tag = i;
        btn.userInteractionEnabled = NO;
        if (!emerBtnAry) {
            emerBtnAry = [[NSMutableArray alloc]init];
        }
        [emerBtnAry addObject:btn];
        [typeView addSubview:subView];
        subView.tag = i;
        
        UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(emergencyTap:)];
        subView.userInteractionEnabled = YES;
        [subView addGestureRecognizer:tap];
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(21 + 12, 0, 36, 21)];
        [label1 setText:[typeAry objectAtIndex:i]];
        [label1 setTextColor:RGB(76, 76, 76, 1)];
        [label1 setFont:[UIFont systemFontOfSize:14]];
        label1.textAlignment = NSTextAlignmentLeft;
        [subView addSubview:label1];
    }
}

-(void)emergencyTap:(UIGestureRecognizer *)sender{
    if (emerPre == sender.view.tag) {
        return;
    }
    if (emerBtnAry.count <= emerPre) {
        return;
    }
    UIButton *preBtn = [emerBtnAry objectAtIndex:emerPre];
    UIView *view = sender.view;
    UIButton *btn = [view.subviews objectAtIndex:0];
    [preBtn setImage:[UIImage imageNamed:@"bangba_questions_select2"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"bangba_questions_select"] forState:UIControlStateNormal];
    emerPre = sender.view.tag;
}*/

- (void) initCourseProType{
    CGRect frame = CGRectMake(0, self.banarView.frame.origin.y + self.banarView.frame.size.height, SCREEN_WIDTH, 35 + 61);
    
    coursePropertyView = [[UIView alloc]initWithFrame:frame];
    [coursePropertyView setBackgroundColor:[UIColor whiteColor]];
    [self.scrollView addSubview:coursePropertyView];
    [coursePropertyView addSubview:[self returnTitleView:@"课程类型" WithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)]];
    NSArray *typeAry = @[@"建众",@"行业",@"跨行"];
    for (int i = 0; i < 3; i ++) {
        UIView *subView = [[UIView alloc]init];
        if (0 == i) {
            subView.frame = CGRectMake(20, 20 + 35, 70, 21);
        }else if(1 == i){
            subView.frame = CGRectMake((SCREEN_WIDTH - 70) / 2, 20  + 35, 70, 21);
        }else{
            subView.frame = CGRectMake(SCREEN_WIDTH - 90, 20 + 35, 70, 21);
        }
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 21, 21)];
        if (i == 0) {
            [btn setImage:[UIImage imageNamed:@"bangba_questions_select"] forState:UIControlStateNormal];
        }else{
            [btn setImage:[UIImage imageNamed:@"bangba_questions_select2"] forState:UIControlStateNormal];
        }
        [btn setImage:[UIImage imageNamed:@"bangba_questions_select"] forState:UIControlStateHighlighted];
        [subView addSubview:btn];
        btn.tag = i;
        btn.userInteractionEnabled = NO;
        if (!courseProAry) {
            courseProAry = [[NSMutableArray alloc]init];
        }
        [courseProAry addObject:btn];
        [coursePropertyView addSubview:subView];
        subView.tag = i;
        
        UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(courseProTap:)];
        subView.userInteractionEnabled = YES;
        [subView addGestureRecognizer:tap];
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(21 + 12, 0, 36, 21)];
        [label1 setText:[typeAry objectAtIndex:i]];
        [label1 setTextColor:RGB(76, 76, 76, 1)];
        [label1 setFont:[UIFont systemFontOfSize:14]];
        label1.textAlignment = NSTextAlignmentLeft;
        [subView addSubview:label1];
    }
}

-(void)courseProTap:(UIGestureRecognizer *)sender{
    if (coursePro == sender.view.tag) {
        return;
    }
    if (courseProAry.count <= coursePro) {
        return;
    }
    UIButton *preBtn = [courseProAry objectAtIndex:coursePro];
    UIView *view = sender.view;
    UIButton *btn = [view.subviews objectAtIndex:0];
    [preBtn setImage:[UIImage imageNamed:@"bangba_questions_select2"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"bangba_questions_select"] forState:UIControlStateNormal];
    coursePro = sender.view.tag;
}


- (void)initCourseNameView{
    courseNameView = [[UIView alloc]initWithFrame:CGRectMake(0, coursePropertyView.frame.origin.y + coursePropertyView.frame.size.height, SCREEN_WIDTH, 79)];
    [courseNameView setBackgroundColor:[UIColor whiteColor]];
    [self.scrollView addSubview:courseNameView];
    
    [courseNameView addSubview:[self returnTitleView:@"课程名称" WithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)]];
    
    self.courseNameTextView = [[UITextField alloc]initWithFrame:CGRectMake(15, 35, SCREEN_WIDTH - 30, 44)];
    [self.courseNameTextView setFont:[UIFont systemFontOfSize:14]];
    [self.courseNameTextView setTextColor:[UIColor hx_colorWithHexRGBAString:@"212121"]];
    self.courseNameTextView.placeholder = @"请输入课程名称，20字内";
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
    
    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, courseIntroduceView.frame.origin.y + courseIntroduceView.frame.size.height)];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    
    if ([self.courseNameTextView isFirstResponder]) {
        [self.courseNameTextView resignFirstResponder];
    }
    if (offSet > 0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.scrollView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        } completion:^(BOOL finished) {
            offSet = 0;
        }];
    }
    if ([self.courseIntroduceTextView isFirstResponder]) {
        [self.courseIntroduceTextView resignFirstResponder];
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

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    if (which == 0) {
        //CGRect rect = [self.fateTextField convertRect:self.fateTextField.frame toView:nil];
        CGRect rect = CGRectMake(0, courseIntroduceView.frame.origin.y + courseIntroduceView.frame.size.height, SCREEN_WIDTH, 0);
        if (rect.origin.y + rect.size.height > keyboardRect.origin.y) {
            [UIView animateWithDuration:0.5 animations:^{
                self.scrollView.frame = CGRectMake(self.scrollView.frame.origin.x, - (rect.origin.y + rect.size.height - keyboardRect.origin.y), self.scrollView.frame.size.width, self.scrollView.frame.size.height);
            } completion:^(BOOL finished) {
                offSet = rect.origin.y + rect.size.height - keyboardRect.origin.y;
                which = -1;
            }];
        }
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

@end
