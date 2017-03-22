
//
//  InfomationCell2.m
//  JZBRelease
//
//  Created by cl z on 16/11/25.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "InfomationCell2.h"
#import "Defaults.h"

@implementation InfomationCell2{
    UIView *intevalView;
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
    if (!self.picImageView) {
        self.picImageView = [[UIImageView alloc]init];
        if (fabs((double)MAX(Main_Screen_Width, Main_Screen_Height) - (double)568) < DBL_EPSILON) {
            self.picImageView.frame = CGRectMake(SCREEN_WIDTH - 10 - 120 * 320 / 375, 15, 120 * 320 / 375, heigh);
        }else if (fabs((double)MAX(Main_Screen_Width, Main_Screen_Height) - (double)736) < DBL_EPSILON){
            self.picImageView.frame = CGRectMake(SCREEN_WIDTH - 10 - 120 * 414 / 375, 15, 120 * 414 / 375, heigh);
        }else if (fabs((double)MAX(Main_Screen_Width, Main_Screen_Height) - (double)667) < DBL_EPSILON){
            self.picImageView.frame = CGRectMake(SCREEN_WIDTH - 10 - 120, 15, 120, heigh);
        }
        [self.contentView addSubview:self.picImageView];
    }
    NSRange range0 = [model.cover rangeOfString:@"<"];
    NSRange range1 = [model.cover rangeOfString:@">"];
    if (model.cover && model.cover.length > 0 && (range0.length == 0) && (range1.length == 0)) {
        self.picImageView.hidden = NO;
        dispatch_async(dispatch_queue_create("queue", nil), ^{
            UIImage *image = [LocalDataRW getImageWithDirectory:Directory_ZX RetalivePath:model.cover];
            if (image) {
                //                dispatch_async(dispatch_get_main_queue(), ^{
                //                    [self.picImageView setImage:image];
                //                });
                
                __block typeof (image) wimage = image;
                dispatch_async(dispatch_get_main_queue(), ^{
                    wimage = [ZJBHelp handleImage:wimage withSize:self.picImageView.frame.size withFromStudy:YES];
                    [self.picImageView setImage:wimage];
                });
            }
        });
        
        if (!self.titleLabel) {
            self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, self.picImageView.frame.origin.x - 15, 0)];
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
        int count = (self.picImageView.frame.origin.x - 25) / singleWidth;
        NSString *modelStr;
        if (model.title.length > count * 2) {
            modelStr = [[model.title substringToIndex:(2 * count - 4)] stringByAppendingString:@"..."];
        }else{
            modelStr = model.title;
        }
        self.titleLabel.text = modelStr;
        NSMutableAttributedString * attributedString2 = [[NSMutableAttributedString alloc] initWithString:self.titleLabel.text];
        NSMutableParagraphStyle * paragraphStyle2 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle2 setLineSpacing:inteval];
        NSDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setValue:self.titleLabel.font forKey:NSFontAttributeName];
        [dict setValue:paragraphStyle2 forKey:NSParagraphStyleAttributeName];
        [attributedString2 addAttributes:dict range:NSMakeRange(0, [self.titleLabel.text length])];
        [self.titleLabel setAttributedText:attributedString2];
        CGSize subscribeInfoTviewsize = [self.titleLabel sizeThatFits:CGSizeMake(self.picImageView.frame.origin.x - 25, MAXFLOAT)];
        [self.titleLabel setFrame:CGRectMake(10, 15, self.picImageView.frame.origin.x - 25, subscribeInfoTviewsize.height)];
        
        
        if (!self.sourceLabel) {
            
            self.sourceLabel = [[UILabel alloc]init];
            [self.contentView addSubview:self.sourceLabel];
            [self.sourceLabel setFont:[UIFont systemFontOfSize:11]];
            [self.sourceLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"bdbdbd"]];
            
            self.commentLabel = [[UILabel alloc]init];
            [self.contentView addSubview:self.commentLabel];
            [self.commentLabel setFont:[UIFont systemFontOfSize:11]];
            [self.commentLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"bdbdbd"]];
            
            
            self.timeLabel = [[UILabel alloc]init];
            [self.contentView addSubview:self.timeLabel];
            [self.timeLabel setFont:[UIFont systemFontOfSize:11]];
            [self.timeLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"bdbdbd"]];
            
        }
        
        
        NSDictionary *attr = @{NSFontAttributeName:[UIFont systemFontOfSize:11]};
        
        [self.sourceLabel setText:model.source];
        [self.sourceLabel setFrame:CGRectMake(10, self.picImageView.frame.origin.y + self.picImageView.frame.size.height - [model.source sizeWithAttributes:attr].height, [model.source sizeWithAttributes:attr].width, [model.source sizeWithAttributes:attr].height)];
        
        
        
        NSString *commentStr = [model.view stringByAppendingString:@"阅"];
        [self.commentLabel setText:commentStr];
        [self.commentLabel setFrame:CGRectMake(self.sourceLabel.frame.origin.x + self.sourceLabel.frame.size.width + 12,  self.picImageView.frame.origin.y + self.picImageView.frame.size.height - [model.source sizeWithAttributes:attr].height, [commentStr sizeWithAttributes:attr].width, [commentStr sizeWithAttributes:attr].height)];
        
        
        long long int date1 = (long long int)[model.create_time intValue];
        NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:date1];
        NSString *timeStr = [[model class] compareCurrentTime:date2];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        [self.timeLabel setText:timeStr];
        [self.timeLabel setFrame:CGRectMake(self.picImageView.frame.origin.x - 15 - [timeStr sizeWithAttributes:attr].width,  self.picImageView.frame.origin.y + self.picImageView.frame.size.height - [model.source sizeWithAttributes:attr].height, [timeStr sizeWithAttributes:attr].width, [timeStr sizeWithAttributes:attr].height)];
        
        if (!intevalView) {
            intevalView = [[UIView alloc]init];
            [intevalView setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"e2e2e2"]];
            [self.contentView addSubview:intevalView];
        }
        intevalView.frame = CGRectMake(10, self.sourceLabel.frame.origin.y + self.sourceLabel.frame.size.height + 13.2, SCREEN_WIDTH - 20, 0.8);
    }else{
        self.picImageView.hidden = YES;
        if (!self.titleLabel) {
            self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, SCREEN_WIDTH - 20, 0)];
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
        
        NSDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setValue:self.titleLabel.font forKey:NSFontAttributeName];
        [dict setValue:paragraphStyle2 forKey:NSParagraphStyleAttributeName];
        [attributedString2 addAttributes:dict range:NSMakeRange(0, [self.titleLabel.text length])];
        [self.titleLabel setAttributedText:attributedString2];
        CGSize subscribeInfoTviewsize = [self.titleLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH - 15, MAXFLOAT)];
        [self.titleLabel setFrame:CGRectMake(10, 15, SCREEN_WIDTH - 20, subscribeInfoTviewsize.height)];
        
        
        if (!self.sourceLabel) {
            
            self.sourceLabel = [[UILabel alloc]init];
            [self.contentView addSubview:self.sourceLabel];
            [self.sourceLabel setFont:[UIFont systemFontOfSize:11]];
            [self.sourceLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"bdbdbd"]];
            
            self.commentLabel = [[UILabel alloc]init];
            [self.contentView addSubview:self.commentLabel];
            [self.commentLabel setFont:[UIFont systemFontOfSize:11]];
            [self.commentLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"bdbdbd"]];
            
            
            self.timeLabel = [[UILabel alloc]init];
            [self.contentView addSubview:self.timeLabel];
            [self.timeLabel setFont:[UIFont systemFontOfSize:11]];
            
            [self.timeLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"bdbdbd"]];
            
        }
        
        
        NSDictionary *attr = @{NSFontAttributeName:[UIFont systemFontOfSize:11]};
        
        [self.sourceLabel setText:model.source];
        [self.sourceLabel setFrame:CGRectMake(10, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 10, [model.source sizeWithAttributes:attr].width, [model.source sizeWithAttributes:attr].height)];
        
        
        
        NSString *commentStr = [model.comment stringByAppendingString:@"评"];
        [self.commentLabel setText:commentStr];
        [self.commentLabel setFrame:CGRectMake(self.sourceLabel.frame.origin.x + self.sourceLabel.frame.size.width + 12,  self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 10, [commentStr sizeWithAttributes:attr].width, [commentStr sizeWithAttributes:attr].height)];
        
        
        long long int date1 = (long long int)[model.create_time intValue];
        NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:date1];
        NSString *timeStr = [[model class] compareCurrentTime:date2];
        [self.timeLabel setText:timeStr];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        [self.timeLabel setFrame:CGRectMake(SCREEN_WIDTH - 10 - 120,  self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 10, 120, [timeStr sizeWithAttributes:attr].height)];
        
        if (!intevalView) {
            intevalView = [[UIView alloc]init];
            [intevalView setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"e2e2e2"]];
            [self.contentView addSubview:intevalView];
        }
        intevalView.hidden = NO;
        intevalView.frame = CGRectMake(10, self.sourceLabel.frame.origin.y + self.sourceLabel.frame.size.height + 13.2, SCREEN_WIDTH - 20, 0.8);
    }
    
    
}



@end
