//
//  GLNickNameViewController.h
//  huanxinFullDemo
//
//  Created by zjapple on 16/7/26.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLNickNameViewController : UIViewController

@property (nonatomic, strong) NSString *VCtitle;

/** 要更新的信息 */
@property (nonatomic, strong) NSString *info;

/** nickName被更新的消息 */
@property (nonatomic, strong) void (^updatenickName)(NSString *nickName);




@end
