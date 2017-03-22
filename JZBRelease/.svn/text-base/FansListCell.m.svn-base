//
//  FansListCell.m
//  JZBRelease
//
//  Created by cl z on 16/8/20.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "FansListCell.h"
#import "Defaults.h"
@implementation FansListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        GetValueObject *obj = [[GetValueObject alloc]init];
        if (!self.avtarImageView) {
            self.avtarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(obj.inteval * 1.7, obj.inteval, obj.avatarWidth, obj.avatarWidth)];
            self.avtarImageView.layer.cornerRadius = 20.0f;
            [self.contentView addSubview:self.avtarImageView];
        }
        if (!self.nameLabel) {
            self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(obj.inteval * 1.7 + obj.avatarWidth + 1 * obj.inteval, 1.5 * obj.inteval, SCREEN_WIDTH - 20 - 40, 21)];
            [self.nameLabel setFont:[UIFont systemFontOfSize:obj.fontSize]];
            [self.nameLabel setTextColor:RGB(76, 76, 76, 1)];
            self.nameLabel.textAlignment = NSTextAlignmentLeft;
            [self.contentView addSubview:self.nameLabel];
        }
        
        UIView *inteval = [[UIView alloc]initWithFrame:CGRectMake(obj.inteval * 1.7, obj.avatarWidth + 2 * obj.inteval - .5, SCREEN_WIDTH - 40, .5)];
        [inteval setBackgroundColor:RGB(180, 180, 180, 1)];
        [self.contentView addSubview:inteval];
    }
    return self;
}

@end
