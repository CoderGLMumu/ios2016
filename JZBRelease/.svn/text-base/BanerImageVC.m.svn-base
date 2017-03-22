//
//  BanerImageVC.m
//  JZBRelease
//
//  Created by cl z on 16/8/23.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "BanerImageVC.h"
#import "Defaults.h"
@interface BanerImageVC ()<UIActionSheetDelegate>

@end

@implementation BanerImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIButton *exchangBtn = [UIButton createButtonWithFrame:CGRectMake((SCREEN_WIDTH - SCREEN_WIDTH / 2) / 2, SCREEN_HEIGHT - 120, SCREEN_WIDTH / 2, 44) Image:nil Target:self Action:@selector(exchangeBtnAction) Title:@"更换海报封面" cornerRadius:3 borderColor:nil borderWidth:0.5];
    [exchangBtn setBackgroundColor:[UIColor blackColor]];
    [exchangBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:exchangBtn];
}
-(void)configNav
{
    //11 20
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11 + 5 + 40, 35)];
    UIImageView *backImageView = [UIImageView createImageViewWithFrame:CGRectMake(0, (35-20)/2, 20, 20) ImageName:@"bq_detail_left"];
    backImageView.userInteractionEnabled = YES;
    [backView addSubview:backImageView];
    UILabel *backLabel = [UILabel createLabelWithFrame:CGRectMake(11 + 5,(35-20)/2, 40, 20) Font:17 Text:@"返回" andLCR:0 andColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]]];
    [backView addSubview:backLabel];
    UIControl *back = [[UIControl alloc] initWithFrame:backView.bounds];
    [back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:back];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    UIButton *sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 35, 28)];
    [sendBtn setTitle:@"删除" forState:UIControlStateNormal];
    sendBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [sendBtn setTitleColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    UIBarButtonItem *sendBarBtn = [[UIBarButtonItem alloc]initWithCustomView:sendBtn];
    self.navigationItem.rightBarButtonItem = sendBarBtn;
    
}

-(void)viewDidAppear:(BOOL)animated{
    dispatch_async(dispatch_queue_create("", nil), ^{
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, (SCREEN_HEIGHT - SCREEN_HEIGHT / 3) / 2, SCREEN_WIDTH, SCREEN_HEIGHT / 3)];
        if (self.image) {
            [imageView setImage:self.image];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view addSubview:imageView];
        });
    });
}

-(void) backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) deleteAction{
    [self backAction];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.returnImage) {
            self.returnImage(nil,0);
        }
    });
}

-(void)exchangeBtnAction{
    [self takePhoto];
}

- (void)takePhoto {
    UIActionSheet *_sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"拍照", @"从手机选择", nil];
    [_sheet showInView:[UIApplication sharedApplication].keyWindow];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    dispatch_after(0., dispatch_get_main_queue(), ^{
        [self backAction];
        if (buttonIndex == 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.returnImage) {
                    self.returnImage(nil,1);
                }
            });
        }else if(buttonIndex == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.returnImage) {
                    self.returnImage(nil,2);
                }
            });
        }else if (buttonIndex == 2){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.returnImage) {
                    self.returnImage(nil,2);
                }
            });
        }
    });
}

-(void)dealloc{
    self.image = nil;
}

@end
