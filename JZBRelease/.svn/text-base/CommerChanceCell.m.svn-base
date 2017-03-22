//
//  CommerChanceCell.m
//  JZBRelease
//
//  Created by zcl on 2016/10/8.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "CommerChanceCell.h"
#import "LocalDataRW.h"
#import "ZJBHelp.h"
@implementation CommerChanceCell{
    dispatch_queue_t queue;
    UILabel *twoLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updateDetail:(CommerChanceCellModel *) model{
    if (!self.timeImageView) {
        self.timeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 9.5, 13, 13)];
        [self.contentView addSubview:self.timeImageView];
        [self.timeImageView setImage:[UIImage imageNamed:@"SJ_time"]];
    }
    if (!self.timeLabel) {
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10 + 13 + 7, 0, 150, 32)];
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel setFont:[UIFont systemFontOfSize:11]];
        [self.timeLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"bdbdbd"]];
    }
    if (!model.activity_start_date || !model.activity_end_date) {
        model.activity_start_date = @"";
        model.activity_end_date = @"";
    }
   // long long int dateI1 = (long long int)[model.activity_start_date intValue];
  //  NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:dateI1];
    long long int dateI2 = (long long int)[model.activity_end_date intValue];
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:dateI2];
 //   NSString *dateS1 = [[self dateFormatter1] stringFromDate:date1];
    NSString *dateS2 = [[self dateFormatter1] stringFromDate:date2];
    NSString *time = [NSString stringWithFormat:@"至%@",dateS2];
    [self.timeLabel setText:time];
    
    if (!self.typebtn) {
        self.typebtn = [[UIButton alloc]initWithFrame:CGRectMake(GLScreenW - 20.5 - 8 - 120, 0, 148.5, 32)];
        //[self.typebtn addTarget:self action:@selector(typebtnaction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.typebtn];
    }
    if (!self.typeImageView) {
        self.typeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(128, 10.5, 10.5, 11)];
        [self.typebtn addSubview:self.typeImageView];
        [self.typeImageView setImage:[UIImage imageNamed:@"WD_more"]];
    }
    if (!self.typeLabel) {
        self.typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 122, 32)];
        [self.typebtn addSubview:self.typeLabel];
        [self.typeLabel setFont:[UIFont systemFontOfSize:13]];
//        [self.typeLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"ff9802"]];
        [self.typeLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"757575"]];
        self.typeLabel.textAlignment = NSTextAlignmentRight;
    }
    if (model._type) {
        [self.typeLabel setText:[NSString stringWithFormat:@"更多%@",model._type]];
    }
    
    if (!self.inteval0) {
        self.inteval0 = [[UIView alloc]initWithFrame:CGRectMake(0, 32, GLScreenW, 1)];
        [self.inteval0 setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
        [self.contentView addSubview:self.inteval0];
    }
    
    
    if (!self.bigImageView) {
        self.bigImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, self.inteval0.frame.origin.y + self.inteval0.frame.size.height + 10, 150, 100)];
        [self.contentView addSubview:self.bigImageView];
    }
    if (!queue) {
        queue = dispatch_queue_create("picqueue", nil);
    }
    dispatch_async(queue, ^{
        if (model.activity_banner) {
            NSString *absolutePath = [ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort];
            NSString* URLString = [absolutePath stringByAppendingPathComponent:model.activity_banner];
            UIImage *image = [LocalDataRW getImageWithDirectory:Directory_BB RetalivePath:URLString];
            __block typeof (image) wimage = image;
            dispatch_async(dispatch_get_main_queue(), ^{
                wimage = [ZJBHelp handleImage:wimage withSize:self.bigImageView.frame.size withFromStudy:YES];
                [self.bigImageView setImage:wimage];
            });
        }
    });
    
    if (!self.titleLabel) {
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(160 + 9, self.inteval0.frame.origin.y + self.inteval0.frame.size.height + 10, GLScreenW - 169 - 10, 60)];
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel setFont:[UIFont systemFontOfSize:15]];
        
        [self.titleLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"212121"]];
        //[self.titleLabel sizeToFit];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        
    }
    NSDictionary *titleTextAttrs = @{NSFontAttributeName:self.titleLabel.font};
    NSString *singleStr = [model.activity_title substringToIndex:1];
    BOOL isChinese = NO;
    int single = [singleStr characterAtIndex:0];
    if( single > 0x4e00 && single < 0x9fff)
    {
        isChinese = YES;
    }
    int singleWidth = [singleStr sizeWithAttributes:titleTextAttrs].width;
    int count = (GLScreenW - 169 - 10) / singleWidth;
    if (model.activity_title) {
        if (model.activity_title.length > count) {
            int height = [singleStr sizeWithAttributes:titleTextAttrs].height;
            [self.titleLabel setFrame:CGRectMake(160 + 9, self.inteval0.frame.origin.y + self.inteval0.frame.size.height + 10, GLScreenW - 169 - 10, height)];
            [self.titleLabel setText:[model.activity_title substringToIndex:count]];
            if (!twoLabel) {
                twoLabel = [[UILabel alloc]initWithFrame:CGRectMake(160 + 9, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 5, GLScreenW - 169 - 10, height)];
                [self.contentView addSubview:twoLabel];
                [twoLabel setFont:[UIFont systemFontOfSize:15]];
                [twoLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"212121"]];
                //[self.titleLabel sizeToFit];
                twoLabel.textAlignment = NSTextAlignmentLeft;
            }
            twoLabel.hidden = NO;
            if (model.activity_title.length > 2 * count) {
                NSString *twoStr = [[model.activity_title substringFromIndex:count] substringToIndex:count];
                [twoLabel setText:twoStr];
            }else{
                [twoLabel setText:[model.activity_title substringFromIndex:count]];
            }
        }else{
            int height = [model.activity_title sizeWithAttributes:titleTextAttrs].height;
            [self.titleLabel setFrame:CGRectMake(160 + 9, self.inteval0.frame.origin.y + self.inteval0.frame.size.height + 10, GLScreenW - 169 - 10, height)];
            [self.titleLabel setText:model.activity_title];
            twoLabel.hidden = YES;
        }
    }
    
    if (!self.commenedLabel) {
        NSDictionary *commenedTextAttrs = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        NSInteger height = [@"推荐人" sizeWithAttributes:commenedTextAttrs].height;
        self.commenedLabel = [[UILabel alloc]initWithFrame:CGRectMake(160 + 9, self.bigImageView.frame.origin.y + self.bigImageView.frame.size.height - height, [@"推荐人" sizeWithAttributes:commenedTextAttrs].width, height)];
        [self.contentView addSubview:self.commenedLabel];
        [self.commenedLabel setFont:[UIFont systemFontOfSize:14]];
        [self.commenedLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"757575"]];
        [self.commenedLabel setText:@"推荐人"];
        self.commenedLabel.textAlignment = NSTextAlignmentLeft;
    }

    if (!self.maohaoLabel1) {
        NSDictionary *commenedTextAttrs = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        NSInteger height = [@"推荐人" sizeWithAttributes:commenedTextAttrs].height;
        self.maohaoLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(160 + 9 + self.commenedLabel.frame.size.width, self.bigImageView.frame.origin.y + self.bigImageView.frame.size.height - height, 20, height)];
        [self.contentView addSubview:self.maohaoLabel1];
        [self.maohaoLabel1 setFont:[UIFont systemFontOfSize:14]];
        [self.maohaoLabel1 setTextColor:[UIColor hx_colorWithHexRGBAString:@"2197f4"]];
        [self.maohaoLabel1 setText:@":"];
        self.maohaoLabel1.textAlignment = NSTextAlignmentCenter;
    }
    
    if (!self.commenderLabel) {
        NSDictionary *commenedTextAttrs = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        NSInteger height = [@"推荐人" sizeWithAttributes:commenedTextAttrs].height;
        self.commenderLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.maohaoLabel1.frame.origin.x + self.maohaoLabel1.frame.size.width, self.bigImageView.frame.origin.y + self.bigImageView.frame.size.height - height, 100, height)];
        [self.contentView addSubview:self.commenderLabel];
        [self.commenderLabel setFont:[UIFont systemFontOfSize:14]];
        [self.commenderLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"2197f4"]];
        [self.commenderLabel setText:@"无"];
        self.commenderLabel.textAlignment = NSTextAlignmentLeft;
    }
    if (model.reference) {
        [self.commenderLabel setText:model.reference];
    }
    
    if (!self.sendLabel) {
        NSDictionary *commenedTextAttrs = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        NSInteger height = [@"发起人" sizeWithAttributes:commenedTextAttrs].height;
        self.sendLabel = [[UILabel alloc]initWithFrame:CGRectMake(160 + 9, self.bigImageView.frame.origin.y + self.bigImageView.frame.size.height - height * 2 - 8, [@"发起人" sizeWithAttributes:commenedTextAttrs].width, height)];
        [self.contentView addSubview:self.sendLabel];
        [self.sendLabel setFont:[UIFont systemFontOfSize:14]];
        [self.sendLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"757575"]];
        [self.sendLabel setText:@"发起人"];
        self.sendLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    if (!self.maohaoLabel2) {
        NSDictionary *commenedTextAttrs = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        NSInteger height = [@"推荐人" sizeWithAttributes:commenedTextAttrs].height;
        self.maohaoLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(160 + 9 + self.commenedLabel.frame.size.width, self.bigImageView.frame.origin.y + self.bigImageView.frame.size.height - height * 2 - 8, 20, height)];
        [self.contentView addSubview:self.maohaoLabel2];
        [self.maohaoLabel2 setFont:[UIFont systemFontOfSize:14]];
        [self.maohaoLabel2 setTextColor:[UIColor hx_colorWithHexRGBAString:@"212121"]];
        [self.maohaoLabel2 setText:@":"];
        self.maohaoLabel2.textAlignment = NSTextAlignmentCenter;
    }
    
    if (!self.senderLabel) {
        NSDictionary *commenedTextAttrs = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        NSInteger height = [@"推荐人" sizeWithAttributes:commenedTextAttrs].height;
        self.senderLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.maohaoLabel1.frame.origin.x + self.maohaoLabel1.frame.size.width, self.bigImageView.frame.origin.y + self.bigImageView.frame.size.height - height * 2 - 8, 100, height)];
        [self.contentView addSubview:self.senderLabel];
        [self.senderLabel setFont:[UIFont systemFontOfSize:14]];
        [self.senderLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"212121"]];
        [self.senderLabel setText:@"无"];
        self.senderLabel.textAlignment = NSTextAlignmentLeft;
    }
    if (model.user) {
        [self.senderLabel setText:model.user.nickname];
    }
    
    if (!self.inteval1) {
        self.inteval1 = [[UIView alloc]initWithFrame:CGRectMake(0, self.bigImageView.frame.origin.y + self.bigImageView.frame.size.height + 10, GLScreenW, 1)];
        [self.inteval1 setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
        [self.contentView addSubview:self.inteval1];
    }

    
    if (!self.readImageView) {
        self.readImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, self.inteval1.frame.origin.y + 1 + 12, 20, 17)];
        [self.contentView addSubview:self.readImageView];
        [self.readImageView setImage:[UIImage imageNamed:@"SJ_EYE"]];
    }
    if (!self.readLabel) {
        self.readLabel = [[UILabel alloc]initWithFrame:CGRectMake(39, self.readImageView.frame.origin.y, 40, 17)];
        [self.contentView addSubview:self.readLabel];
        [self.readLabel setFont:[UIFont systemFontOfSize:11]];
        [self.readLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"757575"]];
    }
    if (model.show_count) {
        NSDictionary *readTextAttrs = @{NSFontAttributeName:[UIFont systemFontOfSize:11]};
        [self.readLabel setFrame:CGRectMake(39, self.readImageView.frame.origin.y, [model.show_count sizeWithAttributes:readTextAttrs].width, 17)];
        [self.readLabel setText:model.show_count];
    }
    
    if (!self.intevallabel) {
        self.intevallabel = [[UILabel alloc]initWithFrame:CGRectMake(self.readLabel.frame.origin.x + self.readLabel.frame.size.width,  self.readImageView.frame.origin.y,20,17)];
        [self.contentView addSubview:self.intevallabel];
        [self.intevallabel setFont:[UIFont systemFontOfSize:11]];
        [self.intevallabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"bdbdbd"]];
        [self.intevallabel setText:@"|"];
        self.intevallabel.textAlignment = NSTextAlignmentCenter;
    }
    
    if (!self.collectImageView) {
        self.collectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.intevallabel.frame.origin.x + self.intevallabel.frame.size.width, self.inteval1.frame.origin.y + 1 + 12, 20, 17)];
        [self.contentView addSubview:self.collectImageView];
        [self.collectImageView setImage:[UIImage imageNamed:@"SJ_STAR"]];
    }
    if (!self.collectLabel) {
        self.collectLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.collectImageView.frame.origin.x + self.collectImageView.frame.size.width + 9, self.readImageView.frame.origin.y, 40, 17)];
        [self.contentView addSubview:self.collectLabel];
        [self.collectLabel setFont:[UIFont systemFontOfSize:11]];
        [self.collectLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"757575"]];
    }
    if (model.zan_count) {
        NSDictionary *readTextAttrs = @{NSFontAttributeName:[UIFont systemFontOfSize:11]};
        [self.collectLabel setFrame:CGRectMake(self.collectImageView.frame.origin.x + self.collectImageView.frame.size.width + 9, self.readImageView.frame.origin.y, [model.zan_count sizeWithAttributes:readTextAttrs].width, 17)];
        [self.collectLabel setText:model.zan_count];
    }

    if (!self.lookforbtn) {
        self.lookforbtn = [[UIButton alloc]initWithFrame:CGRectMake(GLScreenW - 20.5 - 8 - 120, self.inteval1.frame.origin.y + 1, 148.5, 41)];
//        [self.lookforbtn addTarget:self action:@selector(lookforbtnaction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.lookforbtn];
    }
    if (!self.lookForDetailImageView) {
        self.lookForDetailImageView = [[UIImageView alloc]initWithFrame:CGRectMake(128, 15, 10.5, 11)];
        [self.lookforbtn addSubview:self.lookForDetailImageView];
        [self.lookForDetailImageView setImage:[UIImage imageNamed:@"SJ_more2"]];
        self.lookForDetailImageView.hidden = YES;
    }
    if (!self.lookForDetailLabel) {
        self.lookForDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 122, 41)];
        [self.lookforbtn addSubview:self.lookForDetailLabel];
        [self.lookForDetailLabel setFont:[UIFont systemFontOfSize:13]];
        [self.lookForDetailLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"757575"]];
        self.lookForDetailLabel.textAlignment = NSTextAlignmentRight;
        [self.lookForDetailLabel setText:@"查看详情"];
        self.lookForDetailLabel.hidden = YES;
    }
    
    
    if (!self.bottomintevalview) {
        self.bottomintevalview = [[UIView alloc]initWithFrame:CGRectMake(0, self.inteval1.frame.origin.y + 42, GLScreenW, 12)];
        [self.bottomintevalview setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
        [self.contentView addSubview:self.bottomintevalview];
        
        UIView *upview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GLScreenW, 1)];
        [upview setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"e0e0e0"]];
        [self.bottomintevalview addSubview:upview];
        
        UIView *lowview = [[UIView alloc]initWithFrame:CGRectMake(0, 11, GLScreenW, 1)];
        [lowview setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"e0e0e0"]];
        [self.bottomintevalview addSubview:lowview];
    }

}


- (NSDateFormatter *)dateFormatter1 {
    static NSDateFormatter* dateFormatter1;
    static dispatch_once_t onceToken1;
    dispatch_once(&onceToken1, ^{
        dateFormatter1 = [[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    });
    return dateFormatter1;
}

- (NSDateFormatter *)dateFormatter2 {
    static NSDateFormatter* dateFormatter2;
    static dispatch_once_t onceToken2;
    dispatch_once(&onceToken2, ^{
        dateFormatter2 = [[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:@"MM-dd"];
    });
    return dateFormatter2;
}


@end
