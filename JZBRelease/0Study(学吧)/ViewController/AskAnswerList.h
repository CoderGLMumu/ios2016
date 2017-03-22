//
//  AskAnswerList.h
//  JZBRelease
//
//  Created by zjapple on 16/9/19.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AskAnswerList : UIViewController

/** class_id */
@property (nonatomic, strong) NSString *class_id;

/** teacher */
@property (nonatomic, strong) Users *teacher;

/** question */
@property (nonatomic, strong) NSArray *dataSource;

/** callBackDataS */
@property (nonatomic, copy) void(^callBackDataS)(NSArray *dataSource);

/** 来自type = 1 or 2 */
@property (nonatomic, assign) BOOL isVoiceAndVideo;
@end
