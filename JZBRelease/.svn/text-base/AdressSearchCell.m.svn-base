//
//  AdressSearchCell.m
//  JZBRelease
//
//  Created by cl z on 16/8/17.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "AdressSearchCell.h"
#import "Defaults.h"
@implementation AdressSearchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        if (!self.titleLabel) {
            self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, SCREEN_WIDTH - 20 - 40, 21)];
            [self.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [self.titleLabel setTextColor:RGB(76, 76, 76, 1)];
            self.titleLabel.textAlignment = NSTextAlignmentLeft;
            [self.contentView addSubview:self.titleLabel];
        }
        if (!self.detaileLabel) {
            self.detaileLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, SCREEN_WIDTH - 20 - 40, 13)];
            [self.detaileLabel setFont:[UIFont systemFontOfSize:12]];
            [self.detaileLabel setTextColor:RGB(136, 136, 136, 1)];
            self.detaileLabel.textAlignment = NSTextAlignmentLeft;
            [self.contentView addSubview:self.detaileLabel];
        }
        if (!self.selectImageView) {
            self.selectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 40, 15, 20, 20)];
            [self.contentView addSubview:self.selectImageView];
        }
        UIView *inteval = [[UIView alloc]initWithFrame:CGRectMake(20, 49.5, SCREEN_WIDTH - 40, .5)];
        [inteval setBackgroundColor:RGB(180, 180, 180, 1)];
        [self.contentView addSubview:inteval];
    }
    return self;
}


@end
