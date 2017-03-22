//
//  VideoCommentCell.m
//  JZBRelease
//
//  Created by cl z on 16/12/1.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "VideoCommentCell.h"
#import "Defaults.h"

@implementation VideoCommentCell{
    UILabel *intevalLabel;
    NSInteger inteval;
    NSInteger imageWidth;
    NSInteger font;
    UIView *intevalView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        if (fabs((double)MAX(Main_Screen_Width, Main_Screen_Height) - (double)568) < DBL_EPSILON) {
            inteval = 4;
            font = 13;
            imageWidth = 36;
        }else if (fabs((double)MAX(Main_Screen_Width, Main_Screen_Height) - (double)736) < DBL_EPSILON){
            inteval = 8;
            font = 16;
            imageWidth = 44;
            
        }else if (fabs((double)MAX(Main_Screen_Width, Main_Screen_Height) - (double)667) < DBL_EPSILON){
            inteval = 6;
            font = 15;
            imageWidth = 40;
        }

        
        [self.contentView setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"fbfbfb"]];
        self.avatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13, imageWidth, imageWidth)];
        self.avatarImageView.layer.cornerRadius = imageWidth / 2;
        self.avatarImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.avatarImageView];
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.avatarImageView.frame.origin.x + self.avatarImageView.frame.size.width + 10, 19, 120, 21)];
        [self.nameLabel setFont:[UIFont systemFontOfSize:font /1.0714]];
        [self.nameLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"212121"]];
        [self.contentView addSubview:self.nameLabel];
        

        if (!self.vipRangeView) {
            self.vipRangeView = [[UIImageView alloc]init];
            [self addSubview:self.vipRangeView];
        }
        [self.vipRangeView setImage:[UIImage imageNamed:@"VIPicon"]];
        self.vipRangeView.frame = CGRectMake(self.nameLabel.frame.origin.x + self.nameLabel.frame.size.width + 3, 19, 13, 10.5);
        
        if (!self.companyPositionLabel) {
            self.companyPositionLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.avatarImageView.frame.origin.x + self.avatarImageView.frame.size.width + 10, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + 10, 100, 21)];
            [self addSubview:self.companyPositionLabel];
            
            [self.companyPositionLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"757575"]];
            [self.companyPositionLabel setFont:[UIFont systemFontOfSize:font / 1.153]];
        }
        
        if (!intevalLabel) {
            intevalLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.companyPositionLabel.frame.origin.x + self.companyPositionLabel.frame.size.width, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + 6, 12, 21)];
            [self addSubview:intevalLabel];
            [intevalLabel setText:@"|"];
            [intevalLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"bdbdbd"]];
            [intevalLabel setFont:[UIFont systemFontOfSize:font / 1.153]];
            intevalLabel.textAlignment = NSTextAlignmentCenter;
        }
        
        if (!self.jobPositionLabel) {
            self.jobPositionLabel = [[UILabel alloc]initWithFrame:CGRectMake(intevalLabel.frame.origin.x + intevalLabel.frame.size.width, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + 10, 120, 21)];
            [self addSubview:self.jobPositionLabel];
            
            [self.jobPositionLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"757575"]];
            [self.jobPositionLabel setFont:[UIFont systemFontOfSize:font / 1.153]];
        }
        
        
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.avatarImageView.frame.origin.x + self.avatarImageView.frame.size.width + 10, self.companyPositionLabel.frame.origin.y + self.companyPositionLabel.frame.size.height + 10, GLScreenW - (self.avatarImageView.frame.origin.x + self.avatarImageView.frame.size.width + 10 + 10), 21)];
        [self.contentLabel setFont:[UIFont systemFontOfSize:font]];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"212121"]];
        [self.contentView addSubview:self.contentLabel];
        
        self.dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.avatarImageView.frame.origin.x + self.avatarImageView.frame.size.width + 10, self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height + 10, 150, 21)];
        [self.dateLabel setFont:[UIFont systemFontOfSize:font / 1.363]];
        [self.dateLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"757575"]];
        [self.contentView addSubview:self.dateLabel];
        
        
        self.zanCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(GLScreenW - 20 - 60, self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height + 10, 60, 21)];
        [self.zanCountLabel setFont:[UIFont systemFontOfSize:font / 1.363]];
        [self.zanCountLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"757575"]];
        [self.contentView addSubview:self.zanCountLabel];
        
        self.zanBtn = [[UIButton alloc]initWithFrame:CGRectMake(GLScreenW - 20 - 60 - 10 - 15.5, self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height + 10, 35, 35)];
        
        self.zanImageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.zanBtn.frame.size.width - 15.5) / 2, (self.zanBtn.frame.size.height - 15.5) / 2, 15.5, 15.5)];
        [self.zanImageView setImage:[UIImage imageNamed:@"WDXQ_DZ"]];
        [self.zanBtn addSubview:self.zanImageView];
        //[self.zanBtn setImage:[UIImage imageNamed:@"KC_zan1"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.zanBtn];
        
    }
    return self;
}

- (void)setModel:(CourseTimeEvaluateModel *)model{
//    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:model.avatar]] placeholderImage:[UIImage imageNamed:@"ZCCG_TX"]];
    
    [LocalDataRW getImageWithDirectory:Directory_XB RetalivePath:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:model.avatar] WithContainerImageView:self.avatarImageView];
    
    
    NSDictionary *nameAttrs = @{NSFontAttributeName:self.nameLabel.font};
    [self.nameLabel setText:model.user.nickname];
    [self.nameLabel setFrame:CGRectMake(self.avatarImageView.frame.origin.x + self.avatarImageView.frame.size.width + 10, 15, [model.user.nickname sizeWithAttributes:nameAttrs].width, [model.user.nickname sizeWithAttributes:nameAttrs].height)];
    if (model.user.vip) {
        self.vipRangeView.hidden = NO;
        [self.vipRangeView setFrame:CGRectMake(self.nameLabel.frame.origin.x + self.nameLabel.frame.size.width + 3, 18, 13, 10.5)];
    }else{
        self.vipRangeView.hidden = YES;
    }
    
    
    NSString *companyText;
    if (model.user.company && model.user.company.length > 0) {
        companyText = model.user.company;
    }else{
        companyText = @"暂无";
    }
    if (companyText.length > 13) {
        companyText = [NSString stringWithFormat:@"%@...",[companyText substringToIndex:11]];
    }
    [self.companyPositionLabel setText:companyText];
    NSDictionary *companyAttrs = @{NSFontAttributeName:self.companyPositionLabel.font};
    self.companyPositionLabel.frame = CGRectMake(self.avatarImageView.frame.origin.x + self.avatarImageView.frame.size.width + 10, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + 6, [self.companyPositionLabel.text sizeWithAttributes:companyAttrs].width, [self.companyPositionLabel.text sizeWithAttributes:companyAttrs].height);
    

//    
//    [self.companyPositionLabel sizeToFit];
    
    intevalLabel.frame = CGRectMake(self.companyPositionLabel.frame.origin.x + self.companyPositionLabel.frame.size.width, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + 5, 12, 21);
    
    NSString *jobText;
    if (model.user.job && model.user.job.length > 0) {
        jobText = model.user.job;
    }else{
        jobText = @"暂无";
    }
    
    if (jobText.length > 5) {
        jobText = [NSString stringWithFormat:@"%@...",[jobText substringToIndex:5]];
    }
    
    [self.jobPositionLabel setText:jobText];
    NSDictionary *jobAttrs = @{NSFontAttributeName:self.jobPositionLabel.font};
    self.jobPositionLabel.frame = CGRectMake(intevalLabel.frame.origin.x + intevalLabel.frame.size.width, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + 6, [self.jobPositionLabel.text sizeWithAttributes:jobAttrs].width, [self.jobPositionLabel.text sizeWithAttributes:jobAttrs].height);

    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:model.eval_content];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:inteval];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [model.eval_content length])];
    [self.contentLabel setAttributedText:attributedString1];
    CGSize size = [self.contentLabel sizeThatFits:CGSizeMake(GLScreenW - (self.avatarImageView.frame.origin.x + self.avatarImageView.frame.size.width + 10 + 10), MAXFLOAT)];
    [self.contentLabel setFrame:CGRectMake(self.avatarImageView.frame.origin.x + self.avatarImageView.frame.size.width + 10, self.companyPositionLabel.frame.origin.y + self.companyPositionLabel.frame.size.height + 6, GLScreenW - (self.avatarImageView.frame.origin.x + self.avatarImageView.frame.size.width + 10 + 10), size.height)];
    [self.contentLabel setText:model.eval_content];
    
    long long int date1 = (long long int)[model.create_time intValue];
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:date1];
    NSString *timeStr = [[model class] compareCurrentTime:date2];
    self.dateLabel.frame = CGRectMake(self.avatarImageView.frame.origin.x + self.avatarImageView.frame.size.width + 10, self.contentLabel.frame.size.height + self.contentLabel.frame.origin.y + 4, 120, 21);
    [self.dateLabel setText:timeStr];
 
    NSDictionary *zanAttrs = @{NSFontAttributeName:self.zanCountLabel.font};
    NSString *zanCount;
    if (model.like_count && model.like_count.length > 0) {
        zanCount = model.like_count;
    }else{
        zanCount = @"0";
    }
    self.zanCountLabel.text = zanCount;
    self.zanCountLabel.frame = CGRectMake(GLScreenW - 20 - [self.zanCountLabel.text sizeWithAttributes:zanAttrs].width, self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height + 2, [self.zanCountLabel.text sizeWithAttributes:zanAttrs].width + 2 , 21);
    
    self.zanBtn.frame = CGRectMake(GLScreenW - 20 - self.zanCountLabel.frame.size.width  - 35, self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height - 6, 35, 35);
    if ([model.is_like integerValue] == 1) {
        [self.zanImageView setImage:[UIImage imageNamed:@"WDXQ_YDZ"]];
    }else{
        [self.zanImageView setImage:[UIImage imageNamed:@"WDXQ_DZ"]];
    }
    if (!intevalView) {
        intevalView = [[UIView alloc]initWithFrame:CGRectMake(10, self.dateLabel.frame.origin.y + self.dateLabel.frame.size.height + 10, SCREEN_WIDTH - 20, 0.8)];
        [intevalView setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"efefef"]];
        [self.contentView addSubview:intevalView];
    }
}

@end
