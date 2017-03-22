    //
//  SendDynamicVC.m
//  JZBRelease
//
//  Created by zjapple on 16/5/18.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "SendDynamicVC.h"
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
#import "CustomAlertView.h"
#import "LewPopupViewAnimationSpring.h"
#import "HttpManager.h"
#import "SBJson.h"
#import "GetValueObject.h"
#import "SelectAdressVC.h"
#import "cityModel.h"

@interface SendDynamicVC()<MJPhotoBrowserDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate>{
    int requestCount;
}

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIPlaceHolderTextView *contentTextView;
@property(nonatomic, strong) NSMutableArray *itemsSectionPictureArray;
@property(nonatomic, strong) SendNineImageView *containerView;
@property(nonatomic, strong) UIView *allBtnViews;
@property(nonatomic, strong) NSArray *imageAry;
@property(nonatomic, strong) NSMutableArray *picIDAry;
/** chatkeyBoard */
@property (nonatomic, strong) ChatKeyBoard *chatKeyBoard;

@end
@implementation SendDynamicVC{
    
    int offY;
    
    UIAlertView *alertView;
    BOOL sended;
    GetValueObject *valueObj;
    NSString *adress;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Inteval_Color" WithKind:XMLTypeColors]];
    }
    return self;
}

-(void)viewDidLoad{
    valueObj = [[GetValueObject alloc]init];
    [self configNav];
    [self.view addSubview:self.scrollView];
    [self initAllView];
    self.itemsSectionPictureArray = [[NSMutableArray alloc] init];
    NSLog(@"%fld",SCREEN_WIDTH);
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    UIImage *addressImage = [UIImage imageNamed:@"bq_edit_location.png"];
    UIImage *whoLookImage = [UIImage imageNamed:@"bq_edit_qiu.png"];
    UIImage *wantwhoLookImage = [UIImage imageNamed:@"bq_edit_@.png"];
    self.imageAry = @[addressImage,whoLookImage,wantwhoLookImage];
    NSMutableArray *textOneAry = [[NSMutableArray alloc]initWithArray:@[@"所在位置",@"谁可以看",@"提醒谁看"]];
    self.allBtnViews = [self initsOtherViews:self.imageAry TextOne:textOneAry TextTwo:nil];
    
//    self.chatKeyBoard = [ChatKeyBoard keyBoard];
//    self.chatKeyBoard.delegate = self;
//    self.chatKeyBoard.dataSource = self;
//    self.chatKeyBoard.placeHolder = @"请输入消息";
//    [self.view addSubview:self.chatKeyBoard];
//   
//    self.chatKeyBoard.allowMore = NO;
//    self.chatKeyBoard.allowVoice = NO;
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.contentTextView resignFirstResponder];
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
    
    
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav.png"] forBarMetrics:UIBarMetricsDefault];
    
}

-(void)sendActionSender{
    if (self.contentTextView.text.length == 0) {
        if (!alertView) {
            [alertView removeFromSuperview];
            alertView = nil;
        }
        alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:[ValuesFromXML getValueWithName : @"SendDynamicContentForNil" WithKind : XMLTypeBase] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    UserInfo *userInfo = [[LoginVM getInstance] readLocal];
    if (!userInfo && !userInfo.token) {
        return;
    }
    self.picIDAry = [[NSMutableArray alloc]init];
    CustomAlertView *cusAlertView = [CustomAlertView defaultCustomAlertView:@"发布中..."];
    [self lew_presentPopupView:cusAlertView animation:[LewPopupViewAnimationSpring new]];
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
    NSString *absolutePath = [ValuesFromXML getValueWithName:@"Sever_Absolute_Address" WithKind:XMLTypeNetPort];
    NSString *path = [absolutePath stringByAppendingPathComponent:[ValuesFromXML getValueWithName:@"UPLoad_Picture" WithKind:XMLTypeNetPort]];
    if (self.containerView.imageAry.count > 0) {
        for (int i = 0; i < self.containerView.imageAry.count; i ++) {
            dispatch_async(queue, ^{
                [HttpManager uploadPictures:nil WithUrlString:path Image:[self.containerView.imageAry objectAtIndex:i]];
                [HttpManager shareManager].returnData = ^(NSDictionary *dict){
                    int state = [[dict objectForKey:@"state"] intValue];
                    if (1 == state) {
                        NSDictionary *data = [dict objectForKey:@"data"];
                        if (data) {
                            NSString *picPath = [data objectForKey:@"path"];
                            if (picPath) {
                                dispatch_async(dispatch_queue_create("", nil), ^{
                                    [LocalDataRW writeImageWithDirectory:Directory_BQ RetalivePath:[absolutePath stringByAppendingPathComponent:picPath] WithImageData:UIImageJPEGRepresentation([self.containerView.imageAry objectAtIndex:i], 0.8)];
                                });
                            }
                            NSString *picID = [data objectForKey:@"id"];
                            if (picID) {
                                [self.picIDAry addObject:[NSString stringWithFormat:@"%@|",picID]];
                                if (self.picIDAry.count == self.containerView.imageAry.count) {
                                    SendDynamicModel *sendDynamicModel = [[SendDynamicModel alloc]init];
                                    sendDynamicModel.access_token = userInfo.token;
                                    sendDynamicModel.type = @"1";
                                    sendDynamicModel.content = self.contentTextView.text;
                                    if (adress) {
                                        sendDynamicModel.address = adress;
                                    }else{
                                        sendDynamicModel.address = @"";
                                    }
                                    NSMutableString *picString = [[NSMutableString alloc]init];
                                    for (int i = 0; i < self.picIDAry.count; i ++) {
                                        [picString appendString:[self.picIDAry objectAtIndex:i]];
                                    }
                                    sendDynamicModel.pic = picString;
                                    SendAndGetDataFromNet *send = [[SendAndGetDataFromNet alloc]init];
                                    send.returnModel = ^(GetValueObject *obj,int state){
                                        if (1 == state) {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateDynamic" object:self userInfo:nil];
                                                [cusAlertView setTitle:@"发布成功"];
                                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                    [self lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
                                                    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                        sended = YES;
                                                        [self backAction];
                                                    });
                                                });
                                                
                                            });
                                        }else{
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                //[[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateDynamic" object:self userInfo:nil];
                                                [cusAlertView setTitle:@"发布失败"];
                                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                    [self lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
                                                    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                        sended = YES;
                                                        [self backAction];
                                                    });
                                                });
                                                
                                            });
                                            
                                        }
                                        NSLog(@"state %d",state);
                                    };
                                    [send commenDataFromNet:sendDynamicModel WithRelativePath:@"Send_Dynamic"];
                                }
                            }
                        }
                    }
                    
                };
            });

        }
    }else{
        SendDynamicModel *sendDynamicModel = [[SendDynamicModel alloc]init];
        sendDynamicModel.access_token = userInfo.token;
        sendDynamicModel.type = @"1";
        sendDynamicModel.content = self.contentTextView.text;
        sendDynamicModel.address = @"广东广州";
        SendAndGetDataFromNet *send = [[SendAndGetDataFromNet alloc]init];
        __weak typeof (send) wsend = send;
        send.returnModel = ^(GetValueObject *obj,int state){
            if (obj) {
                if (1 == state) {
                    requestCount = 0;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateDynamic" object:self userInfo:nil];
                        [cusAlertView setTitle:@"发布成功"];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
                            [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                sended = YES;
                                [self backAction];
                            });
                        });
                        
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (requestCount > 1) {
                            [cusAlertView setTitle:@"发布失败"];
                            [Toast makeShowCommen:@"您的网络有问题 " ShowHighlight:@"请重置" HowLong:0.8];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [self lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
                                [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    sended = YES;
                                    [self backAction];
                                });
                            });
                        }
                        [LoginVM getInstance].isGetToken = ^(){
                            sendDynamicModel.access_token = [[LoginVM getInstance] readLocal].token;
                            [wsend commenDataFromNet:sendDynamicModel WithRelativePath:@"Send_Dynamic"];
                            requestCount ++;
                        };
                        [[LoginVM getInstance] loginWithUserInfoForGetNewToken:[[LoginVM getInstance] readLocal]];
                        
                    });
                }
            }else{
                [cusAlertView setTitle:@"发布失败"];
                [Toast makeShowCommen:@"您的网络有问题 " ShowHighlight:@"请重置" HowLong:0.8];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
                    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        sended = YES;
                    });
                });

            }
        };
        [send commenDataFromNet:sendDynamicModel WithRelativePath:@"Send_Dynamic"];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
        self.tabBarController.tabBar.hidden = NO;
    }
}

-(void) backAction{
    if (sended) {
        [self.navigationController popViewControllerAnimated:YES];
        self.tabBarController.tabBar.hidden = NO;
        return;
    }
    if (self.contentTextView.text.length > 0 || self.containerView.imageAry.count > 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请注意！" message:@"您就差发布啦，真的想退出此次动态发布吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
    self.tabBarController.tabBar.hidden = NO;
}

-(UIScrollView *)scrollView{
    if (_scrollView) {
        return _scrollView;
    }
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scrollView.directionalLockEnabled = YES; //只能一个方向滑动
    _scrollView.pagingEnabled = NO; //是否翻页
    _scrollView.scrollEnabled = YES;
    _scrollView.backgroundColor = [ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Inteval_Color" WithKind:XMLTypeColors]];
    _scrollView.showsVerticalScrollIndicator =YES; //垂直方向的滚动指示
    _scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;//滚动指示的风格
    _scrollView.showsHorizontalScrollIndicator = NO;//水平方向的滚动指示
    return _scrollView;
}

-(void)initAllView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    [view setBackgroundColor:[UIColor whiteColor]];
    [self.scrollView addSubview:view];
    self.contentTextView = [[UIPlaceHolderTextView alloc]initWithFrame:CGRectMake(2 * valueObj.inteval - valueObj.inteval / 2, 0, SCREEN_WIDTH - 4 * valueObj.inteval, 80)];
    self.contentTextView.font = [UIFont systemFontOfSize:15];
    self.contentTextView.textColor = [UIColor blackColor];
    self.contentTextView.placeholder = @"这一刻的想法";
    [view addSubview:self.contentTextView];
    [self initContainerView];
}

-(void)initContainerView{
    self.containerView = [[SendNineImageView alloc]initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH, (SCREEN_WIDTH - 50 - 3 * valueObj.inteval) / 4 + 3 * valueObj.inteval)];
    self.containerView.backgroundColor = [UIColor whiteColor];
    [self.containerView initViews:(SCREEN_WIDTH - 50 - 3 * valueObj.inteval) / 4 Inteval:1.5 *valueObj.inteval];
    __weak SendDynamicVC *wself = self;
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


-(UIView *) initsOtherViews : (NSArray *) imageAry TextOne : (NSArray *) textOneAry TextTwo : (NSArray *) textTwoAry {
    UIView *view = [[UIView alloc]init];
    [view setBackgroundColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Inteval_Color" WithKind:XMLTypeColors]]];

    view.frame = CGRectMake(0, self.contentTextView.frame.size.height + self.containerView.frame.size.height, SCREEN_WIDTH, imageAry.count * 44 + 24);
    [self.scrollView addSubview:view];

    for (int i = 0; i < imageAry.count; i ++) {
        UIButton *btn = [UIButton new];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn setBackgroundImage:[UIImage imageNamed:@"navigationBG.png"] forState:UIControlStateHighlighted];
        [view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(view.frame.size.width, 44));
            if (i == 0) {
                make.top.equalTo(view).with.offset(1);
            }else if(i == 1){
                make.top.equalTo(view).with.offset(45 + 20);
            }else{
                make.top.equalTo(view).with.offset(45 * 2 + 20.3);
            }
        }];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnActionSender:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *imageView = [[UIImageView alloc]init];
        [btn addSubview:imageView];
        [imageView setImage:[imageAry objectAtIndex:i]];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.size.mas_equalTo(CGSizeMake(18, 18));
            }else{
                make.size.mas_equalTo(CGSizeMake(18, 18));
            }
            make.centerY.equalTo(btn);
            make.left.equalTo(btn).with.offset(2 * valueObj.inteval);
        }];
        
        UILabel *label = [[UILabel alloc]init];
        [btn addSubview:label];
        [label setText:[textOneAry objectAtIndex:i]];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentLeft;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30 - 1.5 * valueObj.inteval - 12, 21));
            make.centerY.equalTo(btn);
            make.left.equalTo(imageView).with.offset(30);
        }];
        
        UIImageView *rowImageView = [[UIImageView alloc]init];
        [btn addSubview:rowImageView];
        [rowImageView setImage:[UIImage imageNamed:@"grzx_grzx_right"]];
        [rowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(9, 16));
            make.centerY.equalTo(btn);
            make.left.equalTo(btn).with.offset(SCREEN_WIDTH - 1.5 * valueObj.inteval - 12);
        }];

    }
    
    return view;
}

-(void) btnActionSender : (UIButton *) btn{
    if (0 == btn.tag) {
        SelectAdressVC *selectVC = [[SelectAdressVC alloc]init];
        selectVC.returnAdress = ^(cityModel *cityModel){
            UILabel *adressLabel = [btn.subviews objectAtIndex:1];
            [adressLabel setText:cityModel.address];
            adress = cityModel.address;
        };
        [self presentViewController:selectVC animated:YES completion:^{
            
        }];
    }
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
            self.containerView.frame = CGRectMake(0, 80, SCREEN_WIDTH, (SCREEN_WIDTH - 50 - 3 * valueObj.inteval) / 4 + 3 * valueObj.inteval);
        }else if (self.containerView.imageAry.count <8)
        {
            self.containerView.frame = CGRectMake(0, 80, SCREEN_WIDTH, 2 * (SCREEN_WIDTH - 50 - 3 * valueObj.inteval) / 4 + 4.5 * valueObj.inteval);
        }else
        {
            self.containerView.frame = CGRectMake(0, 80, SCREEN_WIDTH, 3 * (SCREEN_WIDTH - 50 - 3 * valueObj.inteval) / 4 + 6 * valueObj.inteval);
        }

        [self.containerView initViews:(SCREEN_WIDTH - 50 - 3 * valueObj.inteval) / 4 Inteval:1.5 *valueObj.inteval];
        [UIView animateWithDuration:.25 animations:^{
            self.allBtnViews.frame = CGRectMake(0, self.contentTextView.frame.size.height + self.containerView.frame.size.height, SCREEN_WIDTH, self.imageAry.count * 35);
        } completion:^(BOOL finished) {
            
        }];
        [self.containerView layoutIfNeeded];
    }
}

#pragma mark - 相册、相机调用方法
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"点击了从手机选择");
        
        ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
        elcPicker.maximumImagesCount = 9 - self.containerView.imageAry.count;
        elcPicker.returnsOriginalImage = YES;
        elcPicker.returnsImage = YES;
        elcPicker.onOrder = NO;
        elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie];
        elcPicker.imagePickerDelegate = self;
        //    elcPicker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;//过渡特效
        [self presentViewController:elcPicker animated:YES completion:nil];
        
    }else if (buttonIndex == 1)
    {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            //设置拍照后的图片可被编辑
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            picker.delegate = self;
            picker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            
            [self presentViewController:picker animated:YES completion:nil];
        }else{
            NSLog(@"模拟无效,请真机测试");
        }
    }
}

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    
    __weak SendDynamicVC *wself = self;
    [self dismissViewControllerAnimated:YES completion:^{
        //[wself.itemsSectionPictureArray removeAllObjects];
        BOOL hasVideo = NO;
        //[self.containerView removeAllViews];
        for (NSDictionary *dict in info) {
            if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
                if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                    UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                    CGSize newSize;
                    
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
                self.containerView.frame = CGRectMake(0, 80, SCREEN_WIDTH, (SCREEN_WIDTH - 50 - 3 * valueObj.inteval) / 4 + 3 * valueObj.inteval);
            }else if (self.containerView.imageAry.count <8)
            {
                self.containerView.frame = CGRectMake(0, 80, SCREEN_WIDTH, 2 * (SCREEN_WIDTH - 50 - 3 * valueObj.inteval) / 4 + 4.5 * valueObj.inteval);
            }else
            {
                self.containerView.frame = CGRectMake(0, 80, SCREEN_WIDTH, 3 * (SCREEN_WIDTH - 50 - 3 * valueObj.inteval) / 4 + 6 * valueObj.inteval);
            }
            [self.containerView initViews:(SCREEN_WIDTH - 50 - 3 * valueObj.inteval) / 4 Inteval:1.5 *valueObj.inteval];
            [UIView animateWithDuration:.25 animations:^{
                self.allBtnViews.frame = CGRectMake(0, self.contentTextView.frame.size.height + self.containerView.frame.size.height, SCREEN_WIDTH, self.imageAry.count * 35);
            } completion:^(BOOL finished) {
                
            }];
            [wself.view layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            // 添加新选择的图片
            
        }];
    }];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
    __weak SendDynamicVC *wself = self;
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
                self.containerView.frame = CGRectMake(0, 80, SCREEN_WIDTH, (SCREEN_WIDTH - 50 - 3 * valueObj.inteval) / 4 + 3 * valueObj.inteval);
            }else if (self.containerView.imageAry.count <8)
            {
                self.containerView.frame = CGRectMake(0, 80, SCREEN_WIDTH, 2 * (SCREEN_WIDTH - 50 - 3 * valueObj.inteval) / 4 + 4.5 * valueObj.inteval);
            }else
            {
                self.containerView.frame = CGRectMake(0, 80, SCREEN_WIDTH, 3 * (SCREEN_WIDTH - 50 - 3 * valueObj.inteval) / 4 + 6 * valueObj.inteval);
            }
            [self.containerView initViews:(SCREEN_WIDTH - 50 - 3 * valueObj.inteval) / 4 Inteval:1.5 *valueObj.inteval];
            [UIView animateWithDuration:.25 animations:^{
                self.allBtnViews.frame = CGRectMake(0, self.contentTextView.frame.size.height + self.containerView.frame.size.height, SCREEN_WIDTH, self.imageAry.count * 35);
            } completion:^(BOOL finished) {
                
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


-(void) dealloc{
    
}

@end
