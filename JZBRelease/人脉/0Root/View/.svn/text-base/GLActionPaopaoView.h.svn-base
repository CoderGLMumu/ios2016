//
//  GLActionPaopaoView.h
//  JZBRelease
//
//  Created by zjapple on 16/8/17.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLActionPaopaoView : UIControl

/** uid */
@property (nonatomic, strong) NSString *uid;
/** paopaoView被点击回调消息 */
@property (nonatomic, strong) void(^paopaoViewClick)(GLActionPaopaoView *view);
/** paopaoView被点击回调消息 */
@property (nonatomic, strong) void(^paopaoViewWidth)(CGFloat width);

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *chenHuLabel;
@property (weak, nonatomic) IBOutlet UILabel *industryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *vipImageView;

- (IBAction)paopaoViewClick:(UIButton *)sender;

+ (instancetype)glActionPaopaoView;

+ (instancetype)glActionPaopaoViewActivity;

@end
