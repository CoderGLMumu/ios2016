//
//  BanSpeakCell.h
//  JZBRelease
//
//  Created by zjapple on 16/8/15.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BanSpeakCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *banSpeakSwitch;

/** banSwValueChange */
@property (nonatomic, copy) void(^banSwValueChange)(BOOL isOn);

@end
