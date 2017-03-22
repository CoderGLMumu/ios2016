//
//  MessageCell.m
//  JZBRelease
//
//  Created by zjapple on 16/6/30.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "MessageCell.h"
#import "Masonry.h"
#import "ValuesFromXML.h"
#import "Defaults.h"
#import "UIImageView+WebCache.h"
@implementation MessageCell
-(UIImageView *)avatarImageView{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.model.inteval * 1.5, 5, self.model.avatarWidth, self.model.avatarWidth)];
        _avatarImageView.layer.cornerRadius = 3.0;
        [self.contentView addSubview:_avatarImageView];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 54 - 0.5, SCREEN_WIDTH, 0.5)];
        [label setBackgroundColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Inteval_Color" WithKind:XMLTypeColors]]];
        [self.contentView addSubview:label];
    }
    return _avatarImageView;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [UIFont systemFontOfSize:self.model.fontSize / 1.2];
        [_nameLabel setFrame:CGRectMake(self.model.inteval * 2 + self.model.avatarWidth, 5, 160, 21)];
        [_nameLabel setTextColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]]];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_timeLabel];
        NSDictionary *attr = @{NSFontAttributeName:[UIFont systemFontOfSize:self.model.fontSize / 1.4]};
        _timeLabel.font = [UIFont systemFontOfSize:self.model.fontSize / 1.4];
        long long int date1 = (long long int)[self.model.create_time intValue];
        NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:date1];
        NSString *time = [[self.model class] compareCurrentTime:date2];
        
        [_timeLabel setFrame:CGRectMake(SCREEN_WIDTH - self.model.inteval * 2 - [time sizeWithAttributes:attr].width, 5, [time sizeWithAttributes:attr].width + 0.5 * self.model.inteval, 21)];
        [_timeLabel setTextColor:[UIColor grayColor]];
        [_timeLabel setBackgroundColor:[UIColor clearColor]];
    }
   
    return _timeLabel;
}

-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_contentLabel];
    }
    _contentLabel.font = [UIFont systemFontOfSize:self.model.fontSize / 1.4];
    NSDictionary *attr = @{NSFontAttributeName:[UIFont systemFontOfSize:self.model.fontSize / 1.4]};
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(self.model.inteval * 2 + self.model.avatarWidth);
        make.bottom.equalTo(self.avatarImageView).offset(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - (self.model.inteval * 4.5 + self.model.avatarWidth), [self.model.create_time sizeWithAttributes:attr].height));
    }];
    [_contentLabel setTextColor:[UIColor grayColor]];
    [_contentLabel setBackgroundColor:[UIColor clearColor]];
    return _contentLabel;
}

-(UIImageView *)zanOrRewardImageView{
    if (!_zanOrRewardImageView) {
        _zanOrRewardImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:_zanOrRewardImageView];
        [_zanOrRewardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(self.model.inteval * 2.5 + self.model.avatarWidth);
            make.bottom.equalTo(self.avatarImageView).offset(0);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
    }
    return _zanOrRewardImageView;
}

-(void)setModel:(MesageCellModel *)model{
    _model = model;
//    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:model.avatar]] placeholderImage:[UIImage imageNamed:@"bq_detail_smile"]];
    
    [LocalDataRW getImageWithDirectory:Directory_BQ RetalivePath:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:model.avatar] WithContainerImageView:self.avatarImageView];
    
    [self.nameLabel setText:_model.nickname];
    long long int date1 = (long long int)[self.model.create_time intValue];
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:date1];
    NSString *time = [[self.model class] compareCurrentTime:date2];
    [self.timeLabel setText:time];
    if ([self.model.type isEqualToString:@"1"]) {
        if (_model.message_content.length > 10) {
            [self.contentLabel setText:[[_model.message_content substringToIndex:10] stringByAppendingString:@"..."]];
        }else{
            [self.contentLabel setText:_model.message_content];
        }
        self.zanOrRewardImageView.hidden = YES;
        self.contentLabel.hidden = NO;
    }else if ([self.model.type isEqualToString:@"2"]){
        [self.zanOrRewardImageView setImage:[UIImage imageNamed:@"bq_sy_zan"]];
        self.zanOrRewardImageView.hidden = NO;
        self.contentLabel.hidden = YES;
    }else if ([self.model.type isEqualToString:@"3"]){
        [self.zanOrRewardImageView setImage:[UIImage imageNamed:@"bq_shangtk_jf"]];
        self.zanOrRewardImageView.hidden = NO;
        self.contentLabel.hidden = YES;
    }
}


@end
