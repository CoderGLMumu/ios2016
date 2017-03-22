//
//  OtherPersonCentralCell.m
//  JZBRelease
//
//  Created by cl z on 16/8/5.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "OtherPersonCentralCell.h"
#import "Defaults.h"
#import "Masonry.h"
#import "Defaults.h"
@implementation OtherPersonCentralCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.fImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:self.fImageView];
        [self.fImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(15);
            make.size.mas_equalTo(CGSizeMake(22, 22));
        }];
        
        self.tLabel = [[UILabel alloc]init];
        [self.tLabel setFont:[UIFont systemFontOfSize:14]];
        [self.tLabel setTextColor:RGB(76, 76, 76, 1)];
        [self.contentView addSubview:self.tLabel];
        [self.tLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.fImageView).offset(16 + 22);
            make.size.mas_equalTo(CGSizeMake(100, 21));
        }];
        
        self.tImageView = [[UIImageView alloc]init];
        [self.tImageView setImage:[UIImage imageNamed:@"grzx_grzx_right"]];
        [self.contentView addSubview:self.tImageView];
        [self.tImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(7.5, 14));
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(SCREEN_WIDTH - 7.5 - 15);
        }];
        self.intevalLabel = [[UILabel alloc]init];
        [self.intevalLabel setBackgroundColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Inteval_Color" WithKind:XMLTypeColors]]];
        [self.contentView addSubview:self.intevalLabel];
        [self.intevalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30, 1));
            make.top.equalTo(self.contentView).offset(self.contentView.frame.size.height - 1);
            make.left.equalTo(self.contentView).offset(15);
            
        }];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
