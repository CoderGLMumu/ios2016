//
//  QuestionEditVM.m
//  JZBRelease
//
//  Created by cl z on 16/8/3.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "QuestionEditVM.h"
#import "CustomAlertView.h"
#import "LewPopupViewAnimationSpring.h"
#import "SendAndGetDataFromNet.h"
@implementation QuestionEditVM

-(void)sendQuestion:(SendQuestionModel *) model WithUrl:(NSString *) url WithViewController:(UIViewController *) vc{
    
    //self.picIDAry = [[NSMutableArray alloc]init];
    CustomAlertView *alertView = [CustomAlertView defaultCustomAlertView:@"发布中..."];
    [vc lew_presentPopupView:alertView animation:[LewPopupViewAnimationSpring new]];
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
    SendAndGetDataFromNet *send = [[SendAndGetDataFromNet alloc]init];
    send.returnModel = ^(GetValueObject *model,int state){
        if (1 == state) {
            
        }
    };
    [send commenDataFromNet:model WithRelativePath:@"Send_Question"];
    
    
}

@end
