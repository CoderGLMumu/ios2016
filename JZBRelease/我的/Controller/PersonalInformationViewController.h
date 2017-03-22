//
//  PersonalInformationViewController.h
//  huanxinFullDemo
//
//  Created by zjapple on 16/7/26.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalInformationViewController : UITableViewController

/** MyPrelocal */
@property (nonatomic, strong) NSString *MyPrelocal;
/** isZLT */
@property (nonatomic, assign) BOOL isZLT;

/** 头像被更新的消息 */
@property (nonatomic, copy) void(^updataavatarImageView)(UIImage *selfPhoto);
/** nickName被更新的消息 */
@property (nonatomic, copy) void (^updatenickName)(NSString *nickName);
/** Identity被更新的消息 */
@property (nonatomic, copy) void (^updateIdentity)(NSString *nickName);
/** address被更新的消息 */
@property (nonatomic, copy) void (^updateAddress)(NSString *address);




@end
