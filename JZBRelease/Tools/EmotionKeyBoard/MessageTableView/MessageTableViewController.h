//
//  MessageTableViewController.h
//  EmotionKeyboard
//
//  Created by CoderXu on 16/8/11.
//  Copyright © 2016年 CoderXu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewController : UITableViewController
@property(nonatomic, strong) NSMutableArray *msgList;

/** isMobShow  1是手机  0是电脑 */
@property (nonatomic, assign) BOOL isMobShow;

@end
