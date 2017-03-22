//
//  SendCommerChanceVC.m
//  JZBRelease
//
//  Created by zcl on 2016/10/9.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "SendCommerChanceVC.h"
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
#import "RecommendPersonListVC.h"
#import "IntegralDetailVC.h"
@interface SendCommerChanceVC ()<MJPhotoBrowserDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UITextFieldDelegate,CuiPickViewDelegate,UITextViewDelegate,UIScrollViewDelegate>{
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
    UIView *temp,*detailView;
    NSMutableArray *courseProAry;
    NSInteger coursePro;
    NSArray *typeAry;
    UIAlertView *alert;
    SendActivityModel *sendActivityModel;
}

@property(nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) ChatKeyBoard *chatKeyBoard;
@property(nonatomic, strong) NSMutableArray *itemsSectionPictureArray,*picIDAry,*recomAry,*recomBtnAry;
@property(nonatomic, strong) SendNineImageView *containerView;
@property(nonatomic, strong) UIView *allBtnViews;
@property(nonatomic, strong) NSArray *imageAry;

@property(nonatomic, strong) UIView *typeview;
@property(nonatomic, strong) UIImageView *banarView;


@property (nonatomic, strong) CuiPickerView *cuiPickerView;
@property(nonatomic, strong) UITextField *topicTextField,*fateTextField;
@property(nonatomic, strong) UIPlaceHolderTextView *contentTextView;
@property(nonatomic, strong) UIButton *beginTime,*endTime,*activityType,*addressBtn;
@property(nonatomic, strong) UITextField *activityPay,*activityMenCount,*adressName;
@property(nonatomic, strong) UIView *activitySettingView;
@property(strong, nonatomic)  UIButton *clippedBtn;

@property (nonatomic, strong) UILabel *beginTimeLabel;
@property (nonatomic, strong) UILabel *endTimeLabel;
@property (nonatomic, strong) UILabel *activityTypeLabel;
@property (nonatomic, strong) cityModel *cityModel;
@property (nonatomic, strong) UILabel *recommenderlabel,*adressLabel;

@property (nonatomic, strong) UIButton *adressBtn,*recommendbtn;

@end

@implementation SendCommerChanceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    valueObj = [[GetValueObject alloc]init];
    which = -1;
    self.title = @"发商机";
    typeAry = @[@"招代理",@"找品牌",@"找合伙",@"找活动",@"找专家",@"找资源",@"招人才"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self configNav];
    //[self.clippedImageView setImage:nil];
    [self.view addSubview:self.scrollView];
    
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
    
    [self initTitleView];
    [self initCourseProType];
    [self.scrollView addSubview:[self returnTitleView:@"商机海报" WithFrame:CGRectMake(0, self.typeview.frame.origin.y + self.typeview.frame.size.height, SCREEN_WIDTH, 37)]];
    [self.scrollView addSubview:self.banarView];
    [self initdetailview];
   // [self initrecommenderview];
    [self initRewardViews];
    [self initsendview];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    GLLog(@"%@",self.navigationController);
    if ([self.navigationController isKindOfClass:[GLNAVC class]]) {
        
    }else {
        [self configNav];
    }
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
    
//    UIButton *sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 35, 28)];
//    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
//    sendBtn.titleLabel.textAlignment = NSTextAlignmentRight;
//    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [sendBtn addTarget:self action:@selector(sendActionSender) forControlEvents:UIControlEventTouchUpInside];
//    [sendBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
//    UIBarButtonItem *sendBarBtn = [[UIBarButtonItem alloc]initWithCustomView:sendBtn];
//    self.navigationItem.rightBarButtonItem = sendBarBtn;
    
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
    
    
    [self.endTimeLabel setText:date];
    
    NSLog(@"%@",date);
}
-(UIScrollView *)scrollView{
    if (_scrollView) {
        return _scrollView;
    }
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scrollView.directionalLockEnabled = YES; //只能一个方向滑动
    _scrollView.pagingEnabled = NO; //是否翻页
    _scrollView.backgroundColor = [UIColor whiteColor];
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
        [Toast makeShowCommen:@"" ShowHighlight:@"您未填写活动主题" HowLong:0.8];
        return;
    }
    
    
    
    if (self.endTimeLabel.text.length == 0) {
        [Toast makeShowCommen:@"" ShowHighlight:@"您未选择结束时间" HowLong:0.8];
        return;
    }
    
    if (self.contentTextView.text.length == 0) {
        [Toast makeShowCommen:@"" ShowHighlight:@"您未填写活动描述" HowLong:0.8];
        return;
    }
//    if (self.activityPay.text.length == 0) {
//        [Toast makeShowCommen:@"您未填写 " ShowHighlight:@"活动费用" HowLong:0.8];
//        return;
//    }
//    if (self.activityMenCount.text.length == 0) {
//        [Toast makeShowCommen:@"您未填写 " ShowHighlight:@"活动人数" HowLong:0.8];
//        return;
//    }
    if (!self.banarView.image) {
        [Toast makeShowCommen:@"" ShowHighlight:@"您未选择主题海报封面" HowLong:0.8];
        return;
    }
    
    UserInfo *userInfo = [[LoginVM getInstance] readLocal];
    if (!userInfo && !userInfo.token) {
        return;
    }
    NSLog(@"%@",userInfo);
    if (!sendActivityModel) {
        sendActivityModel = [[SendActivityModel alloc]init];
    }
    sendActivityModel.access_token = userInfo.token;
    if (typeAry.count > coursePro) {
        sendActivityModel.activity_type = [typeAry objectAtIndex:coursePro];
    }
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    sendActivityModel.activity_start_date = dateString;
    sendActivityModel.activity_title = self.topicTextField.text;
    sendActivityModel.activity_content = self.contentTextView.text;
    sendActivityModel.activity_end_date = self.endTimeLabel.text;
    sendActivityModel.activity_score = self.activityPay.text;
    if (!self.cityModel) {
        sendActivityModel.lng = [NSString stringWithFormat:@"%f",self.cityModel.longitude];
        sendActivityModel.lat = [NSString stringWithFormat:@"%f",self.cityModel.latitude];
        sendActivityModel.city = self.cityModel.city;
        sendActivityModel.activity_address = [self.addressBtn.titleLabel.text stringByAppendingString:self.cityModel.name];
    }
    NSMutableString *reference = [[NSMutableString alloc]init];
    for (int i = 0; i < self.recomAry.count; i ++) {
        Users *user = [self.recomAry objectAtIndex:i];
        if (i == self.recomAry.count - 1) {
            [reference appendString:[NSString stringWithFormat:@"%@",user.uid]];
        }else{
            [reference appendString: [NSString stringWithFormat:@"%@,",user.uid]];
        }
    }
    sendActivityModel.reference = reference;
    
    
//    AppDelegate *appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    if (!appD.checkpay) {
//         [SVProgressHUD showSuccessWithStatus:@"发送失败"];
//        return;
//    }
    
    
    if ([[LoginVM getInstance].users.money integerValue] > 10) {
        if (alert) {
            alert = nil;
        }
        alert = [[UIAlertView alloc]initWithTitle:@"请注意" message:@"您一旦发布商机，系统将扣除您10帮币，是否发布？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 10;
        [alert show];
    }else{
        if (alert) {
            alert = nil;
        }
        alert = [[UIAlertView alloc]initWithTitle:@"请注意" message:@"发布商机需要10帮币，但是您的余额不足10帮币，是否充值帮币？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 20;
        [alert show];

    }
    
    
}



- (void)uploadPicAndOtherInfo:(NSMutableArray *) tempImageAry WithPath:(NSString *) path WithModel:(SendActivityModel *)sendActivityModel WithQueue:(dispatch_queue_t) queue WithAlertView:(CustomAlertView *) alertView{
    __block SendCommerChanceVC *wself = self;
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
                                                
                                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                                                    [SVProgressHUD showSuccessWithStatus:@"发布商机，增加积分 +2"];
                                                    [Toast makeShowCommen:@"成功发布商机," ShowHighlight:@"请等待系统审核！" HowLong:0.8];
                                                });
                                                
                                            });
                                        });
                                        
                                    });
                                }else{
                                    [alertView.label setText:@"发布失败"];
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                        [wself lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
                                        [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                                        if (obj.info) {
                                            [SVProgressHUD showInfoWithStatus:obj.info];
                                            //[Toast makeShowCommen:@"" ShowHighlight:obj.info HowLong:0.8];
                                        }
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

- (UIView *) returnTitleView:(NSString *) title WithFrame:(CGRect) frame{
    UIView *titleView = [[UIView alloc]initWithFrame:frame];
    [titleView setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
    UILabel *label = [UILabel createLabelWithFrame:CGRectMake(10, 0, 120, frame.size.height) Font:14 Text:title andLCR:NSTextAlignmentLeft andColor:[UIColor hx_colorWithHexRGBAString:@"212121"]];
    [titleView addSubview:label];
    return titleView;
}

- (void)initTitleView{
    [self.scrollView addSubview:[self returnTitleView:@"标题" WithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 37)]];
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 37, SCREEN_WIDTH, 44)];
//    [view setBackgroundColor:[UIColor whiteColor]];
    self.topicTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 37, SCREEN_WIDTH - 20, 44)];
    self.topicTextField.placeholder = @"请输入20个字内的标题";
    [self.topicTextField setBackgroundColor:[UIColor whiteColor]];
    [self.topicTextField setFont:[UIFont systemFontOfSize:14]];
    //[view addSubview:self.topicTextField];
    [self.scrollView addSubview:self.topicTextField];
    
    self.scrollView.delegate = self;
}

- (void) initCourseProType{
    [self.scrollView addSubview:[self returnTitleView:@"类型" WithFrame:CGRectMake(0, self.topicTextField.frame.origin.y + self.topicTextField.frame.size.height, SCREEN_WIDTH, 37)]];
    CGRect frame = CGRectMake(0, self.topicTextField.frame.origin.y + self.topicTextField.frame.size.height + 37, SCREEN_WIDTH, 102);
    
    self.typeview = [[UIView alloc]initWithFrame:frame];
    [self.typeview setBackgroundColor:[UIColor whiteColor]];
    [self.scrollView addSubview:self.typeview];
    
    
    int width = SCREEN_WIDTH / 4;
    for (int i = 0; i < typeAry.count; i ++) {
        UIView *subView = [[UIView alloc]init];
        if (i < 4) {
            subView.frame = CGRectMake(width * i, 20, width, 21);
        }else{
            subView.frame = CGRectMake(width * (i - 4), 20 + 20 + 21, width, 21);
        }
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(16, 2.5, 16, 16)];
        if (i == 0) {
            [btn setImage:[UIImage imageNamed:@"SJ_choose"] forState:UIControlStateNormal];
        }else{
            [btn setImage:[UIImage imageNamed:@"SJ_WX"] forState:UIControlStateNormal];
        }
        [btn setImage:[UIImage imageNamed:@"SJ_choose"] forState:UIControlStateHighlighted];
        [subView addSubview:btn];
        btn.tag = i;
        btn.userInteractionEnabled = NO;
        if (!courseProAry) {
            courseProAry = [[NSMutableArray alloc]init];
        }
        [courseProAry addObject:btn];
        [self.typeview addSubview:subView];
        subView.tag = i;
        
        UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(courseProTap:)];
        subView.userInteractionEnabled = YES;
        [subView addGestureRecognizer:tap];
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(18.5 + 24, 0, width - 42.5, 21)];
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
    [preBtn setImage:[UIImage imageNamed:@"SJ_WX"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"SJ_choose"] forState:UIControlStateNormal];
    coursePro = sender.view.tag;
}

- (UIImageView *)banarView{
    if (!_banarView) {
        
        _banarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.typeview.frame.origin.y + self.typeview.frame.size.height + 37, SCREEN_WIDTH, 200)];
        [_banarView setBackgroundColor:[UIColor whiteColor]];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, (200 - 60) / 2, 60, 60)];
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

- (void)initdetailview{
    [self.scrollView addSubview:[self returnTitleView:@"详情描述" WithFrame:CGRectMake(0, self.banarView.frame.origin.y + self.banarView.frame.size.height, SCREEN_WIDTH, 37)]];
    self.contentTextView = [[UIPlaceHolderTextView alloc]initWithFrame:CGRectMake(10, self.banarView.frame.origin.y + self.banarView.frame.size.height + 37, SCREEN_WIDTH - 20, 80)];
    self.contentTextView.placeholder = @"请输入200字内的详情描述";
    [self.contentTextView setTextAlignment:NSTextAlignmentLeft];
    [self.contentTextView setFont:[UIFont systemFontOfSize:14]];
    [self.contentTextView setTextColor:[UIColor hx_colorWithHexRGBAString:@"212121"]];
    [self.scrollView addSubview:self.contentTextView];
}

- (void)initrecommenderview{
    [self.scrollView addSubview:[self returnTitleView:@"推荐人" WithFrame:CGRectMake(0, self.contentTextView.frame.origin.y + self.contentTextView.frame.size.height, SCREEN_WIDTH, 37)]];
    self.recommendbtn = [[UIButton alloc]initWithFrame:CGRectMake(10, self.contentTextView.frame.origin.y + self.contentTextView.frame.size.height + 37, SCREEN_WIDTH - 20, 44)];
    [self.recommendbtn addTarget:self action:@selector(recommendBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.recommendbtn setBackgroundColor:[UIColor whiteColor]];
    self.recommenderlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.recommendbtn.frame.size.width, 44)];
    self.recommenderlabel.font = [UIFont systemFontOfSize:14];
    [self.recommenderlabel setText:@"请选择推荐人,最多选择两位"];
    [self.recommenderlabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"bdbdbd"]];
    [self.recommendbtn addSubview: self.recommenderlabel];
    [self.scrollView addSubview:self.recommendbtn];
}

- (void)recommendBtnAction{
    if (self.recomAry.count < 2) {
        RecommendPersonListVC *rpVC = [[RecommendPersonListVC alloc]init];
        [rpVC.navigationController setNavigationBarHidden:YES animated:YES];
        rpVC.cellback = ^(Users *user){
            [self.recommenderlabel setText:@""];
            if (self.recomAry) {
                BOOL isExist;
                for (int i = 0; i < self.recomAry.count; i ++) {
                    Users *oldUser = [self.recomAry objectAtIndex:i];
                    if ([oldUser.nickname isEqualToString:user.nickname]) {
                        isExist = YES;
                        break;
                    }
                }
                if (isExist) {
                    [Toast makeShowCommen:@"" ShowHighlight:@"你不能选择同一个人，请重新选择" HowLong:0.8];
                    return ;
                }
                UIButton *btn = [self loadNameBtn:user WithFrame:CGRectMake(self.recomAry.count * 80, 0, 80,44)];
                btn.tag = self.recomAry.count;
                [self.recommendbtn addSubview:btn];
            }else{
                self.recomAry = [[NSMutableArray alloc]init];
                UIButton *btn = [self loadNameBtn:user WithFrame:CGRectMake(self.recomAry.count * 80, 0, 80,44)];
                btn.tag = self.recomAry.count;
                [self.recommendbtn addSubview:btn];
            }
            [self.recomAry addObject:user];
        };
        [[ZJBHelp getInstance].bbRootVC.navigationController pushViewController:rpVC animated:YES];
    }else{
        [Toast makeShowCommen:@"" ShowHighlight:@"最多选择2个推荐人" HowLong:0.8];
    }
}

- (UIButton *)loadNameBtn:(Users *)user WithFrame:(CGRect)frame{
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, frame.size.height)];
    [label setText:user.nickname];
    [label setFont:[UIFont systemFontOfSize:14]];
    label.textAlignment = NSTextAlignmentCenter;
    [label setTextColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]]];
    [btn addSubview:label];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(label.frame.origin.x + label.frame.size.width,(frame.size.height - 10) / 2, 10, 10)];
    [imageView setImage:[UIImage imageNamed:@"bq_shangtk_close"]];
    [btn addSubview:imageView];
    [btn addTarget:self action:@selector(deleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    if (!self.recomBtnAry) {
        self.recomBtnAry = [[NSMutableArray alloc]init];
    }
    [self.recomBtnAry addObject:btn];
    return btn;
}

- (void) deleteBtn:(UIButton *)btn{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"删除" message:@"是否真的删除该推荐人" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = btn.tag;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (10 == alertView.tag) {
        if (buttonIndex == 1) {
            self.picIDAry = [[NSMutableArray alloc]init];
            CustomAlertView *alertView = [CustomAlertView defaultCustomAlertView:@"发布中..."];
            [self lew_presentPopupView:alertView animation:[LewPopupViewAnimationSpring new]];
            [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
            dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
            NSString *absolutePath = [ValuesFromXML getValueWithName:@"Sever_Absolute_Address" WithKind:XMLTypeNetPort];
            NSString *path = [absolutePath stringByAppendingPathComponent:[ValuesFromXML getValueWithName:@"UPLoad_Picture" WithKind:XMLTypeNetPort]];
            
            NSMutableArray *tempImageAry = [[NSMutableArray alloc]init];
            [tempImageAry addObject:self.banarView.image];
            for (int j = 0; j < self.containerView.imageAry.count; j ++) {
                [tempImageAry addObject:[self.containerView.imageAry objectAtIndex:j]];
            }
            [self uploadPicAndOtherInfo:tempImageAry WithPath:path WithModel:sendActivityModel WithQueue:queue WithAlertView:alertView];
        }
        return;
    }else if (20 == alertView.tag){
        if (buttonIndex == 1) {
            IntegralDetailVC *vc = [[UIStoryboard storyboardWithName:@"IntegralDetailVC" bundle:nil] instantiateInitialViewController];
            vc.bangbiCount = [LoginVM getInstance].users.money;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        return;
    }
    if (0 == buttonIndex) {
        
    }else{
        if (self.recomAry.count > alertView.tag) {
            [self.recomAry removeObjectAtIndex:alertView.tag];
            for (int i = 0; i < self.recomBtnAry.count; i ++) {
                UIButton *btn = [self.recomBtnAry objectAtIndex:i];
                [btn removeFromSuperview];
                
            }
            [self.recomBtnAry removeAllObjects];

            for (int j = 0; j < self.recomAry.count; j ++) {
                UIButton *btn = [self loadNameBtn:[self.recomAry objectAtIndex:j] WithFrame:CGRectMake(j * 80, 0, 80,44)];
                btn.tag = j;
                [self.recommendbtn addSubview:btn];
                [self.recomBtnAry addObject:btn];
            }
            if (self.recomAry.count == 0) {
                [self.recommenderlabel setText:@"请选择推荐人,最多选择两位"];
            }
        }
    }
}

-(void)initRewardViews{
    if (self.recommendbtn) {
        detailView = [[UIView alloc]initWithFrame:CGRectMake(0, self.recommendbtn.frame.origin.y + self.recommendbtn.frame.size.height, SCREEN_WIDTH, 97.6 + 12)];
    }else{
        detailView = [[UIView alloc]initWithFrame:CGRectMake(0, self.contentTextView.frame.origin.y + self.contentTextView.frame.size.height, SCREEN_WIDTH, 97.6 + 12)];
    }
    
    [detailView setBackgroundColor:[UIColor whiteColor]];
    [self.scrollView addSubview:detailView];
    
    
    UIView *inteval3 = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 12)];
    [inteval3 setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
    [detailView addSubview:inteval3];
    
    int width = [@"结束时间 :" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width + 3;
//    UILabel *titleLabel1 = [UILabel createMyLabelWithFrame:CGRectMake(15, 12 + 10, width, 36) Font:14 Text:@"推荐人 :" andLCR:0 andColor:RGB(180, 180, 180, 1)];
//    [detailView addSubview:titleLabel1];
//    self.adressBtn = [[UIButton alloc]initWithFrame:CGRectMake(width + 15, 12 + 10, detailView.frame.size.width - 30 - width, 36)];
//    [self.adressBtn addTarget:self action:@selector(adressBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    self.adressBtn.tag = 0;
//    [detailView addSubview:self.adressBtn];
//    UIImageView *rowImageView = [[UIImageView alloc]init];
//    [self.adressBtn addSubview:rowImageView];
//    [rowImageView setImage:[UIImage imageNamed:@"WD_location"]];
//    [rowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(16, 16));
//        make.centerY.equalTo(self.adressBtn);
//        make.right.equalTo(self.adressBtn).with.offset(0);
//    }];
//    self.adressLabel = [[UILabel alloc]init];
//    [self.adressBtn addSubview:self.adressLabel];
//    self.adressLabel.textColor = [ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]];
//    self.adressLabel.font = [UIFont systemFontOfSize:14];
//    self.adressLabel.textAlignment = NSTextAlignmentCenter;
//    self.adressLabel.numberOfLines = 0;
//    [self.adressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(self.adressBtn.frame.size.width - 16, 21));
//        make.centerY.equalTo(self.adressBtn);
//        make.left.equalTo(self.adressBtn).with.offset(0);
//    }];
//    UIView *inteval = [[UIView alloc]initWithFrame:CGRectMake(15,48 + 10, SCREEN_WIDTH - 30, 0.8)];
//    [inteval setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"dfdfdf"]];
//    [detailView addSubview:inteval];
    
    
    UILabel *titleLabel2 = [UILabel createMyLabelWithFrame:CGRectMake(10, 12 + 12, width, 36) Font:14 Text:@"结束时间 :" andLCR:0 andColor:RGB(180, 180, 180, 1)];
    [detailView addSubview:titleLabel2];
    self.endTime = [[UIButton alloc]initWithFrame:CGRectMake(width + 10,  12 + 12, detailView.frame.size.width - 20 - width, 36)];
    [self.endTime addTarget:self action:@selector(datePickSender:) forControlEvents:UIControlEventTouchUpInside];
    self.endTime.tag = 0;
    [detailView addSubview:self.endTime];
    UIImageView *rowImageView1 = [[UIImageView alloc]init];
    [self.endTime addSubview:rowImageView1];
    [rowImageView1 setImage:[UIImage imageNamed:@"bangba_edit_rili"]];
    [rowImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.centerY.equalTo(self.endTime);
        make.right.equalTo(self.endTime).with.offset(0);
    }];
    self.endTimeLabel = [[UILabel alloc]init];
    [self.endTime addSubview:self.endTimeLabel];
    self.endTimeLabel.textColor = [ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]];
    self.endTimeLabel.font = [UIFont systemFontOfSize:14];
    self.endTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self.endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(160, 21));
        make.centerY.equalTo(self.endTime);
        make.left.equalTo(self.endTime).with.offset((self.endTime.frame.size.width - 16 - 160) / 2);
    }];
    UILabel *inteval1 = [[UILabel alloc]initWithFrame:CGRectMake(10,48.8 + 12, SCREEN_WIDTH - 20, 0.8)];
    [inteval1 setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"dfdfdf"]];
    [detailView addSubview:inteval1];
    
    UILabel *titleLabel3 = [UILabel createMyLabelWithFrame:CGRectMake(10,  12 + 48.8 + 12, width, 36) Font:14 Text:@"悬赏金额 :" andLCR:0 andColor:RGB(180, 180, 180, 1)];
    [detailView addSubview:titleLabel3];
    
    self.fateTextField = [[UITextField alloc]initWithFrame:CGRectMake(10 + width, 12 + 48.8 + 12, SCREEN_WIDTH - 20 - 16 - width, 36)];
    self.fateTextField.textAlignment = NSTextAlignmentCenter;
    [self.fateTextField setTextColor:RGB(234, 128, 17, 1)];
    [self.fateTextField setFont:[UIFont systemFontOfSize:14]];
    self.fateTextField.delegate = self;
    self.fateTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.fateTextField setPlaceholder:@"请输入悬赏金额"];
    //[self.fateTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [detailView addSubview:self.fateTextField];
    UIImageView *fateImageView = [[UIImageView alloc]init];
    [detailView addSubview:fateImageView];
    [fateImageView setImage:[UIImage imageNamed:@"grzx_tiwen_jifen"]];
    [fateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.centerY.equalTo(self.fateTextField);
        make.right.equalTo(self.endTime).with.offset(0);
    }];
    UILabel *inteval2 = [[UILabel alloc]initWithFrame:CGRectMake(10,96.8 + 12, SCREEN_WIDTH - 20, 0.8)];
    [inteval2 setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"dfdfdf"]];
    [detailView addSubview:inteval2];
    
    
}

- (void)initsendview{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, detailView.frame.origin.y + detailView.frame.size.height + 60, SCREEN_WIDTH - 20, 44)];
    [btn setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"1976d2"]];
    [btn setTitle:@"确认发布" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sendActionSender) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 3.0;
    [self.scrollView addSubview:btn];
    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, btn.frame.origin.y + btn.frame.size.height + 140)];
}

-(void) datePickSender:(UIButton *) btn{
    CGRect rect = CGRectMake(0, detailView.frame.origin.y + detailView.frame.size.height - 36, SCREEN_WIDTH, 36);
    [UIView animateWithDuration:0.25 animations:^{
        self.scrollView.frame = CGRectMake(self.scrollView.frame.origin.x, - (rect.origin.y + rect.size.height - (self.view.frame.size.height - 200)), self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    } completion:^(BOOL finished) {
        offSet = rect.origin.y + rect.size.height - (self.view.frame.size.height - 200);
        [_cuiPickerView showInView:self.view];
        _cuiPickerView.isShow = YES;
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}



@end
