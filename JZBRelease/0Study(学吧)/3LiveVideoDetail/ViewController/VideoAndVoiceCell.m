//
//  VideoAndVoiceCell.m
//  JZBRelease
//
//  Created by cl z on 16/10/31.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "VideoAndVoiceCell.h"
#import "UIImageView+WebCache.h"
@interface VideoAndVoiceCell()
@end

@implementation VideoAndVoiceCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"fbfbfb"]];
        self.avatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 23, 44, 44)];
        self.avatarImageView.layer.cornerRadius = 22;
        self.avatarImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.avatarImageView];
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(66, 23, 120, 21)];
        [self.nameLabel setFont:[UIFont systemFontOfSize:12]];
        [self.nameLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"757575"]];
        [self.contentView addSubview:self.nameLabel];
        
        self.wrapView = [[UIView alloc]initWithFrame:CGRectMake(66, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + 10, 200, 30)];
        [self.wrapView setBackgroundColor:[UIColor whiteColor]];
        self.wrapView.layer.cornerRadius = 3.0;
        self.wrapView.layer.borderColor = [UIColor hx_colorWithHexRGBAString:@"dfdfdf"].CGColor;
        self.wrapView.layer.borderWidth = 0.8;
        [self.contentView addSubview:self.wrapView];
        
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(11, 0, self.wrapView.frame.size.width - 18, 30)];
        [self.contentLabel setFont:[UIFont systemFontOfSize:14]];
        
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"212121"]];
        [self.wrapView addSubview:self.contentLabel];
    }
    return self;
}

- (void)setModel:(CourseTimeEvaluateModel *)model{
//    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:model.avatar]] placeholderImage:[UIImage imageNamed:@"ZCCG_TX"]];
    
    [LocalDataRW getImageWithDirectory:Directory_XB RetalivePath:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:model.avatar] WithContainerImageView:self.avatarImageView];
    
    
    [self.nameLabel setText:model.nickname];
    [self.wrapView setFrame:CGRectMake(66, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + 10, model.width, model.height)];

    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:model.eval_content];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:8];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [model.eval_content length])];
    [self.contentLabel setAttributedText:attributedString1];
    
    [self.contentLabel setFrame:CGRectMake(11, 0, model.width - 18, model.height)];
    [self.contentLabel setText:model.eval_content];
    
}
@end
