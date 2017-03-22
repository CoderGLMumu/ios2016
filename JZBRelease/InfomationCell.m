//
//  InfomationCell.m
//  JZBRelease
//
//  Created by cl z on 16/11/25.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "InfomationCell.h"
#import "Defaults.h"

@implementation InfomationCell{
    UIView *intevalView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setModel:(InfomationModel *)model{
    int heigh = 0;
    int inteval = 0;
    int font = 0;
    if (fabs((double)MAX(Main_Screen_Width, Main_Screen_Height) - (double)568) < DBL_EPSILON) {
        heigh = 320.0 / 375 * 77;
        inteval = 4;
        font = 14;
    }else if (fabs((double)MAX(Main_Screen_Width, Main_Screen_Height) - (double)736) < DBL_EPSILON){
        heigh = 414.0 / 375 * 77;
        inteval = 8;
        font = 18;
    }else if (fabs((double)MAX(Main_Screen_Width, Main_Screen_Height) - (double)667) < DBL_EPSILON){
        heigh = 77;
        inteval = 6;
        font = 17;
    }
    
    if (!self.titleLabel) {
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, GLScreenW - 20, 0)];
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.backgroundColor = [UIColor clearColor]; //背景色
        self.titleLabel.userInteractionEnabled = NO;
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"212121"];
        self.titleLabel.font = [UIFont systemFontOfSize:font];
    }
    NSDictionary *attrDict = @{NSFontAttributeName:[UIFont systemFontOfSize:font]};
    int singleWidth = [@"大" sizeWithAttributes:attrDict].width;
    int count = (SCREEN_WIDTH - 20) / singleWidth;
    NSString *modelStr;
    if (model.title.length > count * 2) {
        modelStr = [[model.title substringToIndex:(2 * count - 4)] stringByAppendingString:@"..."];
    }else{
        modelStr = model.title;
    }
    self.titleLabel.text = modelStr;
    NSMutableAttributedString * attributedString2 = [[NSMutableAttributedString alloc] initWithString:self.titleLabel.text];
    NSMutableParagraphStyle * paragraphStyle2 = [[NSMutableParagraphStyle alloc] init];
    if (model.title.length <= count) {
        [paragraphStyle2 setLineSpacing:0];
    }else{
        [paragraphStyle2 setLineSpacing:inteval];
    }
    [attributedString2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle2 range:NSMakeRange(0, [self.titleLabel.text length])];
    [self.titleLabel setAttributedText:attributedString2];
    CGSize subscribeInfoTviewsize = [self.titleLabel sizeThatFits:CGSizeMake(GLScreenW - 20, MAXFLOAT)];
    [self.titleLabel setFrame:CGRectMake(10, 15, GLScreenW - 20, subscribeInfoTviewsize.height)];
    
    if (!self.picImageView) {
        self.picImageView = [[UIImageView alloc]init];
        
        [self.contentView addSubview:self.picImageView];
    }
    
    NSRange range0 = [model.cover rangeOfString:@"<"];
    NSRange range1 = [model.cover rangeOfString:@">"];
    if (model.cover && model.cover.length > 0 && (range0.length == 0) && (range1.length == 0)) {
        if (fabs((double)MAX(Main_Screen_Width, Main_Screen_Height) - (double)568) < DBL_EPSILON) {
            self.picImageView.frame = CGRectMake(10, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 10, 300, 300 * 150 / 355);
        }else if (fabs((double)MAX(Main_Screen_Width, Main_Screen_Height) - (double)736) < DBL_EPSILON){
            self.picImageView.frame = CGRectMake(10, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 10, 414 - 20, 394 * 150 / 355);
        }else if (fabs((double)MAX(Main_Screen_Width, Main_Screen_Height) - (double)667) < DBL_EPSILON){
            self.picImageView.frame = CGRectMake(10, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 10, 355, 150);
        }
        self.picImageView.hidden = NO;
        dispatch_async(dispatch_queue_create("queue", nil), ^{
            UIImage *image = [LocalDataRW getImageWithDirectory:Directory_ZX RetalivePath:model.cover];
            if (!image) {
                image = [LocalDataRW getImageWithDirectory:Directory_ZX RetalivePath:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:model.cover]];
                
                __block typeof (image) wimage = image;
                dispatch_async(dispatch_get_main_queue(), ^{
                    wimage = [ZJBHelp handleImage:wimage withSize:self.picImageView.frame.size withFromStudy:YES];
                    [self.picImageView setImage:wimage];
                });
                
            }
            
            __block typeof (image) wimage = image;
            dispatch_async(dispatch_get_main_queue(), ^{
                wimage = [ZJBHelp handleImage:wimage withSize:self.picImageView.frame.size withFromStudy:YES];
                [self.picImageView setImage:wimage];
            });
            
            //            if (image) {
            //                dispatch_async(dispatch_get_main_queue(), ^{
            //                    [self.picImageView setImage:image];
            //                });
            //            }
        });
    }else{
        self.picImageView.hidden = YES;
    }
    
    if (!self.bottomView) {
        self.bottomView = [[UIView alloc]init];
        [self.bottomView setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.bottomView];
        
        self.positionImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 11, 28, 15)];
        [self.bottomView addSubview:self.positionImageView];
        
        self.sourceLabel = [[UILabel alloc]init];
        [self.bottomView addSubview:self.sourceLabel];
        [self.sourceLabel setFont:[UIFont systemFontOfSize:11]];
        [self.sourceLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"bdbdbd"]];
        
        self.moveLabel = [[UILabel alloc]init];
        [self.bottomView addSubview:self.moveLabel];
        [self.moveLabel setFont:[UIFont systemFontOfSize:11]];
        [self.moveLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"bdbdbd"]];
        
        self.commentLabel = [[UILabel alloc]init];
        [self.bottomView addSubview:self.commentLabel];
        [self.commentLabel setFont:[UIFont systemFontOfSize:11]];
        [self.commentLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"bdbdbd"]];
        
        self.zanLabel = [[UILabel alloc]init];
        [self.bottomView addSubview:self.zanLabel];
        [self.zanLabel setFont:[UIFont systemFontOfSize:11]];
        [self.zanLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"bdbdbd"]];
        
        self.timeLabel = [[UILabel alloc]init];
        [self.bottomView addSubview:self.timeLabel];
        [self.timeLabel setFont:[UIFont systemFontOfSize:11]];
        [self.timeLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"bdbdbd"]];
        
        self.intevalImageView0 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"NEWS_and"]];
        [self.bottomView addSubview:self.intevalImageView0];
        
        self.intevalImageView1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"NEWS_and"]];
        [self.bottomView addSubview:self.intevalImageView1];
        
    }
    
    if (!intevalView) {
        intevalView = [[UIView alloc]initWithFrame:CGRectMake(10, self.bottomView.frame.origin.y + self.bottomView.frame.size.height - 0.8, SCREEN_WIDTH - 20, 0.8)];
        [intevalView setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"e2e2e2"]];
        [self.contentView addSubview:intevalView];
    }
    
    if (self.picImageView.hidden) {
        [self.bottomView setFrame:CGRectMake(0, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 3, SCREEN_WIDTH, 40)];
        [intevalView setFrame:CGRectMake(10, self.bottomView.frame.origin.y + self.bottomView.frame.size.height - 0.8, SCREEN_WIDTH - 20, 0.8)];
    }else{
        [self.bottomView setFrame:CGRectMake(0, self.picImageView.frame.origin.y + self.picImageView.frame.size.height + 3, SCREEN_WIDTH, 40)];
        [intevalView setFrame:CGRectMake(10, self.bottomView.frame.origin.y + self.bottomView.frame.size.height - 0.8, SCREEN_WIDTH - 20, 0.8)];
    }
    
    
    if ([model.position isEqualToString:@"8"]) {
        [self.positionImageView setImage:[UIImage imageNamed:@"NEWS_top"]];
    }else{
        [self.positionImageView setImage:[UIImage imageNamed:@"NEWS_hot"]];
    }
    
    NSDictionary *attr = @{NSFontAttributeName:[UIFont systemFontOfSize:11]};
    
    [self.sourceLabel setText:model.source];
    [self.sourceLabel setFrame:CGRectMake(self.positionImageView.frame.origin.x + self.positionImageView.frame.size.width + 8, (36 - [model.source sizeWithAttributes:attr].height) / 2, [model.source sizeWithAttributes:attr].width, [model.source sizeWithAttributes:attr].height)];
    
    NSString *moveStr = [model.view stringByAppendingString:@"阅"];
    [self.moveLabel setText:moveStr];
    [self.moveLabel setFrame:CGRectMake(self.sourceLabel.frame.origin.x + self.sourceLabel.frame.size.width + 12, (36 - [moveStr sizeWithAttributes:attr].height) / 2, [moveStr sizeWithAttributes:attr].width, [moveStr sizeWithAttributes:attr].height)];
    
    [self.intevalImageView0 setFrame:CGRectMake(self.moveLabel.frame.origin.x + self.moveLabel.frame.size.width + 8, (38 - 3) / 2, 3, 3)];
    
    NSString *commentStr = [model.comment stringByAppendingString:@"评"];
    [self.commentLabel setText:commentStr];
    [self.commentLabel setFrame:CGRectMake(self.intevalImageView0.frame.origin.x + self.intevalImageView0.frame.size.width + 8, (36 - [commentStr sizeWithAttributes:attr].height) / 2, [commentStr sizeWithAttributes:attr].width, [commentStr sizeWithAttributes:attr].height)];
    
    [self.intevalImageView1 setFrame:CGRectMake(self.commentLabel.frame.origin.x + self.commentLabel.frame.size.width + 8, (38 - 3) / 2, 3, 3)];
    
    NSString *zanStr = [model.like_count stringByAppendingString:@"赞"];
    [self.zanLabel setText:zanStr];
    [self.zanLabel setFrame:CGRectMake(self.intevalImageView1.frame.origin.x + self.intevalImageView1.frame.size.width + 8, (36 - [zanStr sizeWithAttributes:attr].height) / 2, [zanStr sizeWithAttributes:attr].width, [zanStr sizeWithAttributes:attr].height)];
    
    long long int date1 = (long long int)[model.create_time intValue];
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:date1];
    NSString *timeStr = [[model class] compareCurrentTime:date2];
    [self.timeLabel setText:timeStr];
    [self.timeLabel setFrame:CGRectMake(SCREEN_WIDTH - 10 - [timeStr sizeWithAttributes:attr].width, (36 - [timeStr sizeWithAttributes:attr].height) / 2, [timeStr sizeWithAttributes:attr].width, [timeStr sizeWithAttributes:attr].height)];
    
    
    
}

@end
