//
//  QuestionEditVC.m
//  JZBRelease
//
//  Created by cl z on 16/7/27.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "QuestionEditVC.h"
#import "ChatKeyBoard.h"
#import "MoreItem.h"
#import "ChatToolBarItem.h"
#import "FaceSourceManager.h"
#import "FaceThemeModel.h"
#import "ChatKeyBoardMacroDefine.h"
#import "Defaults.h"
#import "UIPlaceHolderTextView.h"
#import "Masonry.h"
#import "CuiPickerView.h"
#import "BBGetIndustryModel.h"
#import "SendAndGetDataFromNet.h"
#import "CustomAlertView.h"
#import "LewPopupViewAnimationSpring.h"
#import "IndustryModel.h"
#import "SendQuestionModel.h"
#import "SendNineImageView.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "PictureCollectionViewCell.h"
#import "PictureAddCell.h"
#import "ELCImagePickerController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/ALAsset.h>
#import "SelectAdressVC.h"
#import "IntegralDetailVC.h"
@interface QuestionEditVC ()<UITextFieldDelegate,CuiPickViewDelegate,UITextViewDelegate,MJPhotoBrowserDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIScrollViewDelegate,UIAlertViewDelegate>{
    NSInteger num;
    NSInteger labelHeight;
    UIView *view2,*detailView;
    BOOL beginOrEnd,isExtend;
    NSInteger which;
    NSInteger offSet;
    NSString *IndustryAllName,*IndustryForEightName;
    UIView *industryView,*industryView0;
    CGRect rect1;
    UIView *label;
    NSMutableArray *allAry,*emerBtnAry;
    UIButton *extendBtn;
    NSInteger pre,emerPre;
    GetValueObject *valueObj;
    UIView *xuanView;
    UISwitch *switchView;
}

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIPlaceHolderTextView *titleTextView;
@property(nonatomic, strong) UIPlaceHolderTextView *descTextView;
@property(nonatomic, strong) UIButton *endTime;
@property(nonatomic, strong) UILabel *endTimeLabel;
@property(nonatomic, strong) UIButton *adressBtn;
@property(nonatomic, strong) UILabel *adressLabel;
@property(nonatomic, strong) CuiPickerView *cuiPickerView;
@property(nonatomic, strong) UITextField *fateTextField;
@property (nonatomic, assign) NSInteger requestCount;
@property(nonatomic, strong) NSMutableArray *industryForEightAry;
@property(nonatomic, strong) SendNineImageView *containerView;
@property(nonatomic, strong) NSMutableArray *itemsSectionPictureArray,*picIDAry;
@property(nonatomic, strong) cityModel *cityModel;
@property(nonatomic, strong) NSArray *allTagAry;

@end

@implementation QuestionEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    valueObj = [[GetValueObject alloc]init];
    [self configNav];
    self.requestCount = 0;
    pre = -1;
    emerPre = 0;
    emerBtnAry = [[NSMutableArray alloc]init];
    [self.view addSubview:self.scrollView];
    IndustryForEightName = @"IndustryForEightName";
    IndustryAllName = @"IndustryAllName";
    self.industryForEightAry = [LocalDataRW readDataFromLocalOfDocument:IndustryForEightName];
    self.allTagAry = [LocalDataRW readDataFromLocalOfDocument:IndustryAllName];
    
    [self downloadData];
    
    self.title = @"发问";
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)initAllViews:(NSMutableArray *)industriesAry{
    [self initIndustryHeader];
    if (industriesAry.count % 4 == 0) {
        num = industriesAry.count / 4;
    }else{
        num = industriesAry.count / 4 + 1;
    }
    isExtend = NO;
    [self initIndustryViews:industriesAry IsExtend:isExtend];
    [self initQuestionViews];
    _cuiPickerView = [[CuiPickerView alloc]init];
    _cuiPickerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200);
    _cuiPickerView.delegate = self;
    _cuiPickerView.curDate=[NSDate date];
    [self.view addSubview:_cuiPickerView];
    
    [self initContainerView];
    [self initRewardViews];
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

- (void)downloadData {
    CustomAlertView *alertView = [CustomAlertView defaultCustomAlertView:@"加载中..."];
    [self lew_presentPopupView:alertView animation:[LewPopupViewAnimationSpring new]];
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[HttpManager shareManager] netStatus:^(AFNetworkReachabilityStatus status) {
            if(status == AFNetworkReachabilityStatusReachableViaWWAN || status ==AFNetworkReachabilityStatusReachableViaWiFi){
                BBGetIndustryModel *model = [[BBGetIndustryModel alloc]init];
                model.id = @"0";
                model.tree = @"0";
                SendAndGetDataFromNet *send = [[SendAndGetDataFromNet alloc]init];
                send.returnArray = ^(NSArray *ary){
                    if (ary && ary.count > 0) {
                        if (self.allTagAry.count == ary.count) {
                            if (self.industryForEightAry.count > 0) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self initAllViews:self.industryForEightAry];
                                    [self lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
                                    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                                });
                            }
                        }else{
                            if ([LocalDataRW writeDataToLocaOfDocument:ary AtFileName:IndustryAllName]) {
                                NSLog(@"write successfully");
                                self.allTagAry = ary;
                            }
                            NSMutableArray *subAry = [[NSMutableArray alloc]init];
                            if (!self.industryForEightAry) {
                                self.industryForEightAry = [[NSMutableArray alloc]init];
                            }
                            [self.industryForEightAry removeAllObjects];
                            for (NSInteger i = 0; i < ary.count; i ++) {
                                if (i < 8) {
                                    IndustryModel *industryModel = [IndustryModel mj_objectWithKeyValues:[ary objectAtIndex:i]];
                                    if (industryModel) {
                                        [self.industryForEightAry addObject:industryModel];
                                        [subAry addObject:[ary objectAtIndex:i]];
                                    }
                                }else{
                                    break;
                                }
                            }
                            if (self.industryForEightAry.count > 0) {
                                if ([LocalDataRW writeDataToLocaOfDocument:subAry AtFileName:IndustryForEightName]) {
                                    NSLog(@"write IndustryForEightName successfully");
                                }
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self initAllViews:self.industryForEightAry];
                                    [self lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
                                    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                                });
                            }

                        }
                        
                    }else{
                        if (self.industryForEightAry.count > 0) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self initAllViews:self.industryForEightAry];
                                [self lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
                                [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                            });
                        }else{
                            [Toast makeShowCommen:@"您的网络有问题 " ShowHighlight:@"请重置" HowLong:1.2];
                        }
                    }
                };
                [send arrayDataFromNet:model WithRelativePath:@"Get_Tag_List"];
                
            }else{
                [Toast makeShowCommen:@"您的网络有问题 " ShowHighlight:@"请重置" HowLong:1.2];
            }
        }];
    });
}

-(void)sendActionSender{
    if (pre == -1) {
        [SVProgressHUD showInfoWithStatus:@"您未选择标签"];
        return;
    }
    if (self.titleTextView.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"您未输入问题"];
        return;
    }
    if (switchView.isOn) {
        if (self.endTimeLabel.text.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"您未选择悬赏截止时间"];
            return;
        }
        if (self.fateTextField.text.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"您未输入悬赏帮币"];
            return;
        }
        if ([self.fateTextField.text integerValue] > [[LoginVM getInstance].users.money integerValue]) {
       //     AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            
            //if (appDelegate.checkpay) {
                 UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"您的帮币不够悬赏" message:@"是否前往充值？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alertView show];
                return;
            //}
           
        }
    }
    
    if (self.descTextView.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"您未输入问题描述"];
        return;
    }
    
    UserInfo *userInfo = [[LoginVM getInstance] readLocal];
    if (!userInfo && !userInfo.token) {
        return;
    }
    NSLog(@"%@",userInfo);
    SendQuestionModel *sendQuestionModel = [[SendQuestionModel alloc]init];
    sendQuestionModel.access_token = userInfo.token;
    IndustryModel *industryModel = [IndustryModel mj_objectWithKeyValues:[self.industryForEightAry objectAtIndex:pre]];
    sendQuestionModel.tag = industryModel.id;
    NSString *descContent;
    sendQuestionModel.title = self.titleTextView.text;
    if (self.descTextView && self.descTextView.text.length > 0) {
        descContent = self.descTextView.text;
    }else{
        descContent = @"";
    }
    sendQuestionModel.content = descContent;
    if (switchView.isOn) {
        sendQuestionModel.reward_score = self.fateTextField.text;
        sendQuestionModel.over_time = self.endTimeLabel.text;
    }
    
    if (self.cityModel) {
        sendQuestionModel.lng = [NSString stringWithFormat:@"%f",self.cityModel.longitude];
        sendQuestionModel.lat = [NSString stringWithFormat:@"%f",self.cityModel.latitude];
        sendQuestionModel.city = self.cityModel.city;
        sendQuestionModel.address = [self.adressLabel.text stringByAppendingString:self.cityModel.name];
    }
    if (emerPre == 0) {
        sendQuestionModel.type = @"1";
    }else if (emerPre == 1){
        sendQuestionModel.type = @"2";
    }else{
        sendQuestionModel.type = @"3";
    }

    self.picIDAry = [[NSMutableArray alloc]init];
    CustomAlertView *alertView = [CustomAlertView defaultCustomAlertView:@"发布中..."];
    [self lew_presentPopupView:alertView animation:[LewPopupViewAnimationSpring new]];
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
    NSString *absolutePath = [ValuesFromXML getValueWithName:@"Sever_Absolute_Address" WithKind:XMLTypeNetPort];
    NSString *path = [absolutePath stringByAppendingPathComponent:[ValuesFromXML getValueWithName:@"UPLoad_Picture" WithKind:XMLTypeNetPort]];
 
    [self uploadPicAndOtherInfo:self.containerView.imageAry WithPath:path WithModel:sendQuestionModel WithQueue:queue WithAlertView:alertView];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [Toast makeShowCommen:@"您最多只能悬赏" ShowHighlight:[NSString stringWithFormat:@" %@ 币",[LoginVM getInstance].users.money] HowLong:1];
       
    }else{
        IntegralDetailVC *vc = [[UIStoryboard storyboardWithName:@"IntegralDetailVC" bundle:nil] instantiateInitialViewController];
        vc.bangbiCount = [LoginVM getInstance].users.money;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)uploadPicAndOtherInfo:(NSMutableArray *) tempImageAry WithPath:(NSString *) path WithModel:(SendQuestionModel *)sendQuestionModel WithQueue:(dispatch_queue_t) queue WithAlertView:(CustomAlertView *) alertView{
    __block QuestionEditVC *wself = self;
    dispatch_async(queue, ^{
        NSLog(@"%ld",self.picIDAry.count);
        if (tempImageAry.count > 0) {
            [HttpManager uploadPictures:nil WithUrlString:path Image:[tempImageAry objectAtIndex:self.picIDAry.count
                                                                      ]];
            [HttpManager shareManager].returnData = ^(NSDictionary *dict){
                int state = [[dict objectForKey:@"state"] intValue];
                if (1 == state) {
                    NSDictionary *data = [dict objectForKey:@"data"];
                    if (data) {
                        NSString *picID = [data objectForKey:@"id"];
                        if (picID) {
                            [self.picIDAry addObject:[NSString stringWithFormat:@"%@,",picID]];
                            if (self.picIDAry.count == tempImageAry.count) {
                                NSMutableString *picString = [[NSMutableString alloc]init];
                                for (int i = 0; i < self.picIDAry.count; i ++) {
                                    [picString appendString:[self.picIDAry objectAtIndex:i]];
                                }
                                sendQuestionModel.images = picString;
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
//                                                        [SVProgressHUD showSuccessWithStatus:@"发布问题，增加积分 +2"];
                                                        [Toast makeShowCommen:@"成功," ShowHighlight:@"发布问题" HowLong:0.8];
                                                    });
                                                });
                                            });
                                            
                                        });
                                    }else{
                                        [alertView.label setText:[data objectForKey:@"info"]];
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            [wself lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
                                            [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                                        });
                                    }
                                };
                                [send commenDataFromNet:sendQuestionModel WithRelativePath:@"Send_Question"];
                            }else{
                                [wself uploadPicAndOtherInfo:tempImageAry WithPath:path WithModel:sendQuestionModel WithQueue:queue WithAlertView:alertView];
                            }
                        }
                    }
                }else{
                    [alertView.label setText:[dict objectForKey:@"info"]];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [wself lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
                        [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                    });
                }
            };
        }else{
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
            [send commenDataFromNet:sendQuestionModel WithRelativePath:@"Send_Question"];
        }
    });
    
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
    _scrollView.delegate = self;
    return _scrollView;
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    if (_cuiPickerView.isShow) {
        [_cuiPickerView hiddenPickerView];
    }
    if ([self.fateTextField isFirstResponder]) {
        [self.fateTextField resignFirstResponder];
    }
    //if (offSet > 0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        } completion:^(BOOL finished) {
            offSet = 0;
        }];
   // }
    if ([self.titleTextView isFirstResponder]) {
        [self.titleTextView resignFirstResponder];
    }
    if ([self.descTextView isFirstResponder]) {
        [self.descTextView resignFirstResponder];
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
        //CGRect rect = CGRectMake(0, detailView.frame.origin.y + detailView.frame.size.height + 20, SCREEN_WIDTH, 36);
        if (rect.origin.y + rect.size.height > keyboardRect.origin.y) {
            [UIView animateWithDuration:0.5 animations:^{
                self.scrollView.frame = CGRectMake(self.scrollView.frame.origin.x, - (rect.origin.y + rect.size.height - keyboardRect.origin.y), self.scrollView.frame.size.width, self.scrollView.frame.size.height);
            } completion:^(BOOL finished) {
                if (![self.fateTextField isFirstResponder]) {
                    [self.fateTextField becomeFirstResponder];
                }else{
                    offSet = rect.origin.y + rect.size.height - keyboardRect.origin.y;
                    which = -1;
                }
            }];
        }
    }else if (which == 1){
        
        //CGRect rect = CGRectMake(0, 64 + view2.frame.origin.y + self.descTextView.frame.origin.y, self.descTextView.frame.size.width, self.descTextView.frame.size.height);
        CGRect rect = [self.descTextView convertRect:self.descTextView.bounds toView:nil];
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



- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (_cuiPickerView.isShow) {
        [textField resignFirstResponder];
        return;
    }
    if (textField == self.fateTextField) {
        which = 0;
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (textView == self.descTextView) {
        which = 1;
        return YES;
    }else{
        which = -1;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView == self.descTextView) {
        if (textView.text.length > 200) {
            [Toast makeShowCommen:@"您问题描述字数已超 " ShowHighlight:@"255" HowLong:0.8];
            [textView setText:[textView.text substringToIndex:200]];
        }
    }else{
        if (textView.text.length > 100) {
            [Toast makeShowCommen:@"您问题字数已超 " ShowHighlight:@"50" HowLong:0.8];
            [textView setText:[textView.text substringToIndex:100]];
        }
    }
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    if (![self isPureInt:theTextField.text]) {
        [Toast makeShowCommen:@"请正确输入 " ShowHighlight:@"数字" HowLong:0.8];
        [theTextField setText:@""];
        [theTextField setPlaceholder:@"请输入悬赏帮币数"];
    }
}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

-(void)initIndustryHeader{
    
    label = [self returnTitleView:@"标签" WithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 37)];
    [self.scrollView addSubview:label];
    
    extendBtn = [UIButton createButtonWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 40, 0, 40, 37) ImageName:nil Target:self Action:@selector(extendBtnActionSender:) Title:nil];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, (37 - 10.7)/2, 20, 10.7)];
    [imageView setImage:[UIImage imageNamed:@"bangba_answer_down"]];
    [extendBtn addSubview:imageView];
    extendBtn.tag = Clink_Type_One;
    [label addSubview:extendBtn];

}

-(void)initIndustryViews:(NSArray *) industriesAry IsExtend:(BOOL) isExtends{
    if (isExtends) {
        if (industriesAry.count % 4 == 0) {
            num = industriesAry.count / 4;
        }else{
            num = industriesAry.count / 4 + 1;
        }
    }
    NSInteger industryBtnHeight = 25;
    NSInteger industryBtnWidth = (SCREEN_WIDTH - 40 - 39) / 4;
    UIView *view;
    if (!isExtends) {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 37, SCREEN_WIDTH, 20 + num * (25 + 20))];
    }else{
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 37, SCREEN_WIDTH, SCREEN_HEIGHT -  37)];
        rect1 = view.frame;
    }
    
    [view setBackgroundColor:[UIColor whiteColor]];
    [self.scrollView addSubview:view];
    if (!isExtends) {
        industryView0 = view;
    }else{
        industryView = view;
    }

    for (NSInteger i = 0; i < num; i ++) {
        if (i < num - 1) {
            for (NSInteger j = 0; j < 4; j ++) {
                UIButton *btn = [[UIButton alloc]init];
                [btn setFrame: CGRectMake(20 + (industryBtnWidth + 13) * j, 20 + i * 45, industryBtnWidth, industryBtnHeight)];
                IndustryModel *model = [IndustryModel mj_objectWithKeyValues:[industriesAry objectAtIndex:i * 4  + j]];
                [btn setTitle:model.name forState:UIControlStateNormal];
                [btn setTitleColor:RGB(76, 76, 76, 1) forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(industryBtnSender:) forControlEvents:UIControlEventTouchUpInside];
                [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
                btn.layer.cornerRadius = 3.0;
                btn.layer.borderColor = RGB(227, 227, 227, 1).CGColor;
                btn.layer.borderWidth = 0.8;
                [btn setTitleColor:RGB(93, 166, 252, 1) forState:UIControlStateHighlighted];
                btn.tag = i * 4 + j;
                [view addSubview:btn];
            }
        }else{
            for (NSInteger j = 0; j + (num - 1) * 4 < industriesAry.count; j ++) {
                UIButton *btn = [[UIButton alloc]init];
                [btn setFrame: CGRectMake(20 + (industryBtnWidth + 13) * j, 20 + i * 45, industryBtnWidth, industryBtnHeight)];
                [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
                IndustryModel *model = [IndustryModel mj_objectWithKeyValues:[industriesAry objectAtIndex:i * 4  + j]];
                [btn setTitle:model.name forState:UIControlStateNormal];
                [btn setTitleColor:RGB(76, 76, 76, 1) forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(industryBtnSender:) forControlEvents:UIControlEventTouchUpInside];
                btn.layer.cornerRadius = 3.0;
                btn.layer.borderColor = RGB(227, 227, 227, 1).CGColor;
                btn.layer.borderWidth = 0.8;
                [btn setTitleColor:RGB(93, 166, 252, 1) forState:UIControlStateHighlighted];
                btn.tag = i * 4 + j;
                [view addSubview:btn];
            }
        }
    }
}

-(void)extendBtnActionSender:(UIButton *)sender{
    if (sender.tag == Clink_Type_One) {
        [self startAnimation:sender];
        if (!isExtend) {
            isExtend = YES;
            if (!industryView) {
                allAry = [LocalDataRW readDataFromLocalOfDocument:IndustryAllName];
                if (allAry) {
                    [self initIndustryViews:allAry IsExtend:isExtend];
                }
            }
            industryView.hidden = NO;
            industryView.frame = CGRectMake(rect1.origin.x, rect1.origin.y, rect1.size.width, 0);
            [UIView animateWithDuration:0.8 animations:^{
                industryView.frame = rect1;
            } completion:^(BOOL finished) {
                
            }];
        }else{
            [UIView animateWithDuration:0.8 animations:^{
                industryView.frame = CGRectMake(rect1.origin.x, rect1.origin.y, rect1.size.width, 0);
            } completion:^(BOOL finished) {
                industryView.hidden = YES;
                isExtend = NO;
            }];
        }
    }
}

-(void)industryBtnSender:(UIButton *) sender{
    NSInteger tag = sender.tag;
    if (!isExtend) {
        if (pre != -1) {
            UIButton *prebtn = [industryView0.subviews objectAtIndex:pre];
            [prebtn setTitleColor:RGB(76, 76, 76, 1) forState:UIControlStateNormal];
            prebtn.layer.borderColor = RGB(227, 227, 227, 1).CGColor;
        }
        UIButton *btn = [industryView0.subviews objectAtIndex:tag];
        [btn setTitleColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]] forState:UIControlStateNormal];
        btn.layer.borderColor = [ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]].CGColor;
        pre = tag;
    }else{
        if (pre != -1) {
            UIButton *prebtn = [industryView0.subviews objectAtIndex:pre];
            [prebtn setTitleColor:RGB(76, 76, 76, 1) forState:UIControlStateNormal];
            prebtn.layer.borderColor = RGB(227, 227, 227, 1).CGColor;
        }
        if (tag >= 8) {
            UIButton *btn = [industryView0.subviews objectAtIndex:0];
            [btn setTitle:sender.titleLabel.text forState:UIControlStateNormal];
            [btn setTitleColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]] forState:UIControlStateNormal];
            btn.layer.borderColor = [ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]].CGColor;
            NSDictionary *dict = [allAry objectAtIndex:tag];
            [self.industryForEightAry replaceObjectAtIndex:0 withObject:dict];
            [allAry exchangeObjectAtIndex:0 withObjectAtIndex:tag];
            if ([LocalDataRW writeDataToLocaOfDocument:allAry AtFileName:IndustryAllName] && [LocalDataRW writeDataToLocaOfDocument:self.industryForEightAry AtFileName:IndustryForEightName]) {
                NSLog(@"write successfully!");
                [UIView animateWithDuration:0.8 animations:^{
                    industryView.frame = CGRectMake(rect1.origin.x, rect1.origin.y, rect1.size.width, 0);
                } completion:^(BOOL finished) {
                    industryView.hidden = YES;
                    isExtend = NO;
                    [industryView removeFromSuperview];
                    industryView = nil;
                }];
            }
            pre = 0;
        }else{
            UIButton *btn = [industryView0.subviews objectAtIndex:tag];
            [btn setTitleColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]] forState:UIControlStateNormal];
            btn.layer.borderColor = [ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]].CGColor;
            pre = tag;
            [UIView animateWithDuration:0.8 animations:^{
                industryView.frame = CGRectMake(rect1.origin.x, rect1.origin.y, rect1.size.width, 0);
            } completion:^(BOOL finished) {
                industryView.hidden = YES;
                isExtend = NO;
            }];
        }
        [self startAnimation:extendBtn];
        isExtend = NO;
    }
}

- (void)startAnimation:(UIButton *)btn
{
    CABasicAnimation* rotationAnimation =[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];//"z"还可以是“x”“y”，表示沿z轴旋转
    if (isExtend) {
        rotationAnimation.toValue = [NSNumber numberWithFloat:(2 * M_PI) * 1];
    }else{
        rotationAnimation.toValue = [NSNumber numberWithFloat:(2 * M_PI) * 0.5];
    }
    rotationAnimation.duration = 0.8f;
    rotationAnimation.fillMode=kCAFillModeForwards;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    if (btn.subviews.count > 0) {
        UIImageView *imageView = [btn.subviews objectAtIndex:0];
        [imageView.layer addAnimation:rotationAnimation forKey:nil];
    }
}

- (UIView *) returnTitleView:(NSString *) title WithFrame:(CGRect) frame{
    UIView *titleView = [[UIView alloc]initWithFrame:frame];
    [titleView setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
    UILabel *labels = [UILabel createLabelWithFrame:CGRectMake(10, 0, 120, frame.size.height) Font:14 Text:title andLCR:NSTextAlignmentLeft andColor:[UIColor hx_colorWithHexRGBAString:@"212121"]];
    [titleView addSubview:labels];
    return titleView;
}

-(void)initQuestionViews{
    view2 = [[UIView alloc]initWithFrame:CGRectMake(0, industryView0.frame.origin.y + industryView0.frame.size.height, SCREEN_WIDTH, 240)];
    [view2 setBackgroundColor:[UIColor whiteColor]];
    [self.scrollView addSubview:view2];
    
    [view2 addSubview:[self returnTitleView:@"类型" WithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 37)]];
    
    NSArray *typeAry = @[@"普通",@"急"];
    for (int i = 0; i < 2; i ++) {
        UIView *subView = [[UIView alloc]init];
        if (0 == i) {
            subView.frame = CGRectMake(40, 20 + 37, 70, 21);
        }else{
            subView.frame = CGRectMake(SCREEN_WIDTH - 90, 20 + 37, 70, 21);
        }
        [view2 addSubview:subView];
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
        [emerBtnAry addObject:btn];
        
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
    
    
    UIView *titleView = [self returnTitleView:@"标题" WithFrame:CGRectMake(0, 98, SCREEN_WIDTH, 37)];
    [view2 addSubview:titleView];
    
    self.titleTextView = [[ UIPlaceHolderTextView alloc]initWithFrame:CGRectMake(10, titleView.frame.origin.y + titleView.frame.size.height + 5, SCREEN_WIDTH - 30, 49)];
    self.titleTextView.placeholder = @"写下您的问题标题（字数不超过100）";
    [self.titleTextView setFont:[UIFont systemFontOfSize:14]];
    [self.titleTextView setTextColor:RGB(76, 76, 76, 1)];
    self.titleTextView.delegate = self;
//    self.titleTextView.layer.cornerRadius = 3.0;
//    
//    self.titleTextView.layer.borderColor = [ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Inteval_Color" WithKind:XMLTypeColors]].CGColor;
//    self.titleTextView.layer.borderWidth = 0.8;
    [view2 addSubview:self.titleTextView];
    
    UIView *descView = [self returnTitleView:@"描述" WithFrame:CGRectMake(0, self.titleTextView.frame.origin.y + self.titleTextView.frame.size.height + 5, SCREEN_WIDTH, 37)];
    [view2 addSubview:descView];
    
    self.descTextView = [[ UIPlaceHolderTextView alloc]initWithFrame:CGRectMake(10, descView.frame.origin.y + descView.frame.size.height + 5, SCREEN_WIDTH - 30, 100)];
    self.descTextView.placeholder = @"问题描述（字数不超过200）";
    [self.descTextView setFont:[UIFont systemFontOfSize:14]];
    [self.descTextView setTextColor:RGB(76, 76, 76, 1)];
    self.descTextView.delegate = self;
    self.descTextView.textAlignment = NSTextAlignmentLeft;
//    self.descTextView.layer.cornerRadius = 3.0;
//    
//    self.descTextView.layer.borderColor = [ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Inteval_Color" WithKind:XMLTypeColors]].CGColor;
//    self.descTextView.layer.borderWidth = 0.8;
    [view2 addSubview:self.descTextView];
    
    [view2 setFrame:CGRectMake(0, industryView0.frame.origin.y + industryView0.frame.size.height, SCREEN_WIDTH, self.descTextView.frame.origin.y + self.descTextView.frame.size.height + 5)];
}


-(void)initContainerView{
    
    UIView *picturesView = [self returnTitleView:@"图片描述" WithFrame:CGRectMake(0, view2.frame.origin.y + view2.frame.size.height, SCREEN_WIDTH, 37)];
    [self.scrollView addSubview:picturesView];
    
    self.containerView = [[SendNineImageView alloc]initWithFrame:CGRectMake(0, picturesView.frame.origin.y + picturesView.frame.size.height + 10, SCREEN_WIDTH, (SCREEN_WIDTH - 50 - 3 * valueObj.inteval) / 4 + 2 * valueObj.inteval)];
    self.containerView.backgroundColor = [UIColor whiteColor];
    
    [self.containerView initViews:(SCREEN_WIDTH - 50 - 3 * valueObj.inteval) / 4 Inteval:1.5 *valueObj.inteval];
    __weak QuestionEditVC *wself = self;
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
            self.containerView.frame = CGRectMake(0, self.containerView.frame.origin.y, SCREEN_WIDTH, (SCREEN_WIDTH - 50 - 3 * valueObj.inteval) / 4 + 4 * valueObj.inteval);
        }else if (self.containerView.imageAry.count <8)
        {
            self.containerView.frame = CGRectMake(0, self.containerView.frame.origin.y, SCREEN_WIDTH, 2 * (SCREEN_WIDTH - 50 - 3 * valueObj.inteval) / 4 + 4.5 * valueObj.inteval);
        }else
        {
            self.containerView.frame = CGRectMake(0, self.containerView.frame.origin.y, SCREEN_WIDTH, 3 * (SCREEN_WIDTH - 50 - 3 * valueObj.inteval) / 4 + 6 * valueObj.inteval);
        }
        
        [self.containerView initViews:(SCREEN_WIDTH - 50 - 3 * valueObj.inteval) / 4 Inteval:1.5 *valueObj.inteval];
        
        [UIView animateWithDuration:.25 animations:^{
            detailView.frame = CGRectMake(0, self.containerView.frame.origin.y + self.containerView.frame.size.height, SCREEN_WIDTH, detailView.frame.size.height);
        } completion:^(BOOL finished) {
            if (switchView.isOn) {
                [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, detailView.frame.origin.y + detailView.frame.size.height + 100)];
            }else{
                
                [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, xuanView.frame.origin.y + xuanView.frame.size.height + 100)];
            }
        }];
        [self.containerView layoutIfNeeded];
    }
}

#pragma mark - 相册、相机调用方法
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (100 == actionSheet.tag) {
        if (buttonIndex == 0) {
            [self.adressLabel setText:@"线上解决"];
        }else if(buttonIndex == 1){
            SelectAdressVC *adressVC = [[SelectAdressVC alloc]init];
            __weak typeof (self) wself = self;
            adressVC.returnAdress = ^(cityModel *cityModels){
                wself.cityModel = cityModels;
                [wself.adressLabel setText:cityModels.address];
            };
            [self presentViewController:adressVC animated:YES completion:^{
                
            }];
        }
        return;
    }
    
    if (buttonIndex == 0) {
        NSLog(@"点击了从手机选择");
        
        ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
        elcPicker.maximumImagesCount = 3 - self.containerView.imageAry.count;
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
    
    __weak QuestionEditVC *wself = self;
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
                self.containerView.frame = CGRectMake(0, self.containerView.frame.origin.y, SCREEN_WIDTH, (SCREEN_WIDTH - 50 - 3 * valueObj.inteval) / 4 + 4 * valueObj.inteval);
            }else if (self.containerView.imageAry.count <8)
            {
                self.containerView.frame = CGRectMake(0, self.containerView.frame.origin.y, SCREEN_WIDTH, 2 * (SCREEN_WIDTH - 50 - 3 * valueObj.inteval) / 4 + 4.5 * valueObj.inteval);
            }else
            {
                self.containerView.frame = CGRectMake(0, self.containerView.frame.origin.y, SCREEN_WIDTH, 3 * (SCREEN_WIDTH - 50 - 3 * valueObj.inteval) / 4 + 6 * valueObj.inteval);
            }
            [self.containerView initViews:(SCREEN_WIDTH - 50 - 3 * valueObj.inteval) / 4 Inteval:1.5 *valueObj.inteval];
            [UIView animateWithDuration:.25 animations:^{
                detailView.frame = CGRectMake(0, self.containerView.frame.origin.y + self.containerView.frame.size.height, SCREEN_WIDTH, detailView.frame.size.height);
            } completion:^(BOOL finished) {
                if (switchView.isOn) {
                    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, detailView.frame.origin.y + detailView.frame.size.height + 100)];
                }else{
                    
                    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, xuanView.frame.origin.y + xuanView.frame.size.height + 100)];
                }
            }];
            [wself.view layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            // 添加新选择的图片
            
        }];
    }];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
    [self.itemsSectionPictureArray addObject:image];
    __weak QuestionEditVC *wself = self;
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
                self.containerView.frame = CGRectMake(0, self.containerView.frame.origin.y, SCREEN_WIDTH, (SCREEN_WIDTH - 50 - 3 * valueObj.inteval) / 4 + 4 * valueObj.inteval);
            }else if (self.containerView.imageAry.count <8)
            {
                self.containerView.frame = CGRectMake(0, self.containerView.frame.origin.y, SCREEN_WIDTH, 2 * (SCREEN_WIDTH - 50 - 3 * valueObj.inteval) / 4 + 4.5 * valueObj.inteval);
            }else
            {
                self.containerView.frame = CGRectMake(0, self.containerView.frame.origin.y, SCREEN_WIDTH, 3 * (SCREEN_WIDTH - 50 - 3 * valueObj.inteval) / 4 + 6 * valueObj.inteval);
            }
            
            [self.containerView initViews:(SCREEN_WIDTH - 50 - 3 * valueObj.inteval) / 4 Inteval:1.5 *valueObj.inteval];
            [UIView animateWithDuration:.25 animations:^{
                detailView.frame = CGRectMake(0, self.containerView.frame.origin.y + self.containerView.frame.size.height, SCREEN_WIDTH, detailView.frame.size.height);
            } completion:^(BOOL finished) {
                if (switchView.isOn) {
                    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, detailView.frame.origin.y + detailView.frame.size.height + 100)];
                }else{
                    
                    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, xuanView.frame.origin.y + xuanView.frame.size.height + 100)];
                }
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
    if (sender.view.tag == 1) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请注意" message:@"您选择了’急‘类型，一旦您发布问题，系统将扣除您5帮币，同时您的问题将会优先推荐" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

-(void)initRewardViews{
    
    xuanView = [self returnTitleView:@"悬赏" WithFrame:CGRectMake(0, self.containerView.frame.origin.y + self.containerView.frame.size.height + 15, SCREEN_WIDTH, 37)];
    [self.scrollView addSubview:xuanView];
    switchView = [[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 50 - 15, (37 - 28)/2, 40, 28)];
    [xuanView addSubview:switchView];
    [switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];

    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, xuanView.frame.origin.y + xuanView.frame.size.height + 50)];
}

-(void) switchAction:(id)sender
{
    if (switchView.isOn) {
        [self initRewardSViews];
        detailView.hidden = NO;
        [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, detailView.frame.origin.y + detailView.frame.size.height + 50)];
    }else{
        if (detailView) {
            detailView.hidden = YES;
        }
        [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, xuanView.frame.origin.y + xuanView.frame.size.height + 50)];
    }

}

- (void) initRewardSViews{
    
    if (!detailView) {
        detailView = [[UIView alloc]initWithFrame:CGRectMake(0, xuanView.frame.origin.y + xuanView.frame.size.height + 12, SCREEN_WIDTH, 97.6 + 20 )];//+ 10 + 48.6
        [detailView setBackgroundColor:[UIColor whiteColor]];
        [self.scrollView addSubview:detailView];
        
        int width = [@"问题解决地址 :" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width + 3;
//        UILabel *titleLabel1 = [UILabel createMyLabelWithFrame:CGRectMake(15, 12 + 10, width, 36) Font:14 Text:@"问题解决地址 :" andLCR:0 andColor:RGB(180, 180, 180, 1)];
//        [detailView addSubview:titleLabel1];
//        self.adressBtn = [[UIButton alloc]initWithFrame:CGRectMake(width + 15, 12 + 10, detailView.frame.size.width - 30 - width, 36)];
//        [self.adressBtn addTarget:self action:@selector(adressBtnAction) forControlEvents:UIControlEventTouchUpInside];
//        self.adressBtn.tag = 0;
//        [detailView addSubview:self.adressBtn];
//        UIImageView *rowImageView = [[UIImageView alloc]init];
//        [self.adressBtn addSubview:rowImageView];
//        [rowImageView setImage:[UIImage imageNamed:@"WD_location"]];
//        [rowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(16, 16));
//            make.centerY.equalTo(self.adressBtn);
//            make.right.equalTo(self.adressBtn).with.offset(0);
//        }];
//        self.adressLabel = [[UILabel alloc]init];
//        [self.adressBtn addSubview:self.adressLabel];
//        self.adressLabel.textColor = [ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]];
//        self.adressLabel.font = [UIFont systemFontOfSize:14];
//        self.adressLabel.textAlignment = NSTextAlignmentCenter;
//        self.adressLabel.numberOfLines = 0;
//        [self.adressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(self.adressBtn.frame.size.width - 16, 21));
//            make.centerY.equalTo(self.adressBtn);
//            make.left.equalTo(self.adressBtn).with.offset(0);
//        }];
//        UIView *inteval = [[UIView alloc]initWithFrame:CGRectMake(15,48 + 10, SCREEN_WIDTH - 30, 0.8)];
//        [inteval setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"dfdfdf"]];
//        [detailView addSubview:inteval];
        
        
        UILabel *titleLabel2 = [UILabel createMyLabelWithFrame:CGRectMake(15, 0, width, 36) Font:14 Text:@"悬赏截止时间 :" andLCR:0 andColor:RGB(180, 180, 180, 1)];
        [detailView addSubview:titleLabel2];
        self.endTime = [[UIButton alloc]initWithFrame:CGRectMake(width + 15, 0, detailView.frame.size.width - 30 - width, 36)];
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
        UILabel *inteval1 = [[UILabel alloc]initWithFrame:CGRectMake(15,36, SCREEN_WIDTH - 30, 0.8)];
        [inteval1 setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"dfdfdf"]];
        [detailView addSubview:inteval1];
        
        UILabel *titleLabel3 = [UILabel createMyLabelWithFrame:CGRectMake(15, 48.8 , width, 36) Font:14 Text:@"悬赏总帮币数 :" andLCR:0 andColor:RGB(180, 180, 180, 1)];
        [detailView addSubview:titleLabel3];
        
        self.fateTextField = [[UITextField alloc]initWithFrame:CGRectMake(15 + width, 48.8 , SCREEN_WIDTH - 30 - 16 - width, 36)];
        self.fateTextField.textAlignment = NSTextAlignmentCenter;
        [self.fateTextField setTextColor:RGB(234, 128, 17, 1)];
        [self.fateTextField setFont:[UIFont systemFontOfSize:14]];
        self.fateTextField.delegate = self;
        self.fateTextField.keyboardType = UIKeyboardTypeNumberPad;
        [self.fateTextField setPlaceholder:@"请输入悬赏帮币数"];
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
        UILabel *inteval2 = [[UILabel alloc]initWithFrame:CGRectMake(15,48.8 + 36 , SCREEN_WIDTH - 30, 0.8)];
        [inteval2 setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"dfdfdf"]];
        [detailView addSubview:inteval2];
        
    }
    
}

- (void)adressBtnAction{
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"线上解决", @"线下解决", nil];
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    sheet.tag = 100;
    [sheet showInView:self.view];
 
}

-(void) datePickSender:(UIButton *) btn{
    CGRect rect = [btn convertRect:btn.bounds toView:nil];
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
    [self.endTimeLabel setText:date];
    NSLog(@"%@",date);
}

-(void) backAction{
    [self.navigationController popViewControllerAnimated:YES];
    self.tabBarController.tabBar.hidden = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.fateTextField isFirstResponder] || [self.descTextView isFirstResponder] || [self.titleTextView isFirstResponder]) {
        [self.fateTextField resignFirstResponder];
        [self.descTextView resignFirstResponder];
        [self.titleTextView resignFirstResponder];
        [UIView animateWithDuration:0.5 animations:^{
            self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        } completion:^(BOOL finished) {
            offSet = 0;
        }];
    }
    
    [self.view endEditing:YES];
}

@end
