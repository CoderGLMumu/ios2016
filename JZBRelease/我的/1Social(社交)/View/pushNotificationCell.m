//
//  pushNotificationCell.m
//  JZBRelease
//
//  Created by Apple on 16/11/7.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "pushNotificationCell.h"

@interface pushNotificationCell ()

@property (weak, nonatomic) IBOutlet UILabel *TtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@end

@implementation pushNotificationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setItem:(PushextrasItem *)item
{
    _item = item;
    
    self.TtitleLabel.text = [NSString stringWithFormat:@"标题：%@",item.title];
    self.contentLabel.text = [NSString stringWithFormat:@"内容：%@",item.content];
    
}


@end
