//
//  LoadDataForAnimateVM.h
//  JZBRelease
//
//  Created by cl z on 16/8/1.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "GetValueObject.h"
#import "CustomAlertView.h"
#import "SendAndGetDataFromNet.h"
#import "LewPopupViewAnimationSpring.h"

typedef void (^startAnimateAfterDoSomething)(NSString *content);
typedef void (^stopAnimatebeforeDoSomething)(NSString *content);
@interface LoadDataForAnimateVM : GetValueObject

@property(nonatomic,copy) startAnimateAfterDoSomething startBlock;
@property(nonatomic,copy) stopAnimatebeforeDoSomething stopBlock;

-(id)loadURL:(NSString *)url AddStartBlock:(startAnimateAfterDoSomething)startBlock AddStopBlock:(stopAnimatebeforeDoSomething)stopBlock;

@end
