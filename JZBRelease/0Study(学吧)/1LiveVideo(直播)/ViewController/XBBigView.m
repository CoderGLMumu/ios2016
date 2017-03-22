//
//  XBBigView.m
//  JZBRelease
//
//  Created by cl z on 16/10/12.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "XBBigView.h"
#import "Defaults.h"
@implementation XBBigView{
    UIImageView *imageView;
    UIView *backgroundView;
    UIView *backgroundView1;
    UILabel *peopleCountLabel;
    UILabel *timeLabel;
    UIImageView *timeImageView;
    UIView *thirdView;
    UILabel *titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

+ (XBBigView *) initWithModel:(CourseTimeModel *) model WithFrame:(CGRect) frame{
    XBBigView *view = [[XBBigView alloc]initWithFrame:frame];
    return view;
}

- (void) updateWithModel:(CourseTimeModel *) models{
    self.model = models;
    if (!imageView) {
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 9, self.frame.size.width - 20, 150)];
        [self addSubview:imageView];
    }
    if (!imageView.image) {
        NSString *path = [[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:models.thumb];
        dispatch_async(dispatch_queue_create("queue_content", nil), ^{
            UIImage *image = [LocalDataRW getImageWithDirectory:Directory_XB RetalivePath:path];
            __block typeof (image) wimage = image;
            dispatch_async(dispatch_get_main_queue(), ^{
                wimage = [ZJBHelp handleImage:wimage withSize:imageView.frame.size withFromStudy:YES];
                [imageView setImage:wimage];
            });
        });
    }
    
    if (!backgroundView) {
        backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 150 - 22, imageView.frame.size.width, 22)];
        [backgroundView setBackgroundColor:[UIColor blackColor]];
        backgroundView.alpha = 0.7;
        [imageView addSubview:backgroundView];
        
        backgroundView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 150 - 22, imageView.frame.size.width, 22)];
        [backgroundView1 setBackgroundColor:[UIColor clearColor]];
        [imageView addSubview:backgroundView1];

        UIImageView *peopleView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 4, 14, 14)];
        [peopleView setImage:[UIImage imageNamed:@"XBZY_people"]];
        [backgroundView1 addSubview:peopleView];
    }
    
    
    if (!peopleCountLabel) {
         peopleCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(31, 0, 120, backgroundView1.frame.size.height)];
        [backgroundView1 addSubview:peopleCountLabel];
        [peopleCountLabel setTextColor:[UIColor whiteColor]];
        [peopleCountLabel setFont:[UIFont systemFontOfSize:11]];
    }
   
    if (!models.show_count) {
        models.show_count = @"0";
    }
    [peopleCountLabel setText:models.show_count];
    if (!models.start_time) {
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970]*1000;
        models.start_time = [NSString stringWithFormat:@"%f", a];
    }
    long long int date1 = (long long int)[models.start_time intValue];
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:date1];
    NSString *dateStr = [[XBBigView dateFormatter] stringFromDate:date2];
    NSDictionary *attr = @{NSFontAttributeName:[UIFont systemFontOfSize:11]};
    if (!timeLabel) {
        timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(backgroundView1.frame.size.width - [dateStr sizeWithAttributes:attr].width - 10, 0, [dateStr sizeWithAttributes:attr].width, backgroundView1.frame.size.height)];
        [timeLabel setTextColor:[UIColor whiteColor]];
        [timeLabel setFont:[UIFont systemFontOfSize:11]];
        [backgroundView1 addSubview:timeLabel];

    }
    [timeLabel setFrame:CGRectMake(backgroundView1.frame.size.width - [dateStr sizeWithAttributes:attr].width - 10, 0, [dateStr sizeWithAttributes:attr].width, backgroundView1.frame.size.height)];
    [timeLabel setText:dateStr];
    if (!timeImageView) {
        timeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(backgroundView1.frame.size.width - [dateStr sizeWithAttributes:attr].width - 31, 4, 14, 14)];
        [timeImageView setImage:[UIImage imageNamed:@"XBZY_time"]];
        [backgroundView1 addSubview:timeImageView];
    }
    [timeImageView setFrame:CGRectMake(backgroundView1.frame.size.width - [dateStr sizeWithAttributes:attr].width - 31, 4, 14, 14)];
    
    if (!thirdView) {
        thirdView = [[UIView alloc]initWithFrame:CGRectMake(0, 159, GLScreenW, 39)];
        [thirdView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:thirdView];
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, thirdView.frame.size.width - 24, thirdView.frame.size.height)];
        [titleLabel setFont:[UIFont systemFontOfSize:14]];
        [titleLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"212121"]];
        [thirdView addSubview:titleLabel];

    }
    
    if (models.title && models.title.length > 1) {
        NSString *singleStr = [models.title substringToIndex:1];
        NSDictionary *titleTextAttrs = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        int singleWidth = [singleStr sizeWithAttributes:titleTextAttrs].width;
        int count = titleLabel.frame.size.width / singleWidth;
        if (models.title.length > count) {
            NSString *title = [[models.title substringToIndex:count - 3] stringByAppendingString:@"..."];
            [titleLabel setText:title];
        }else{
            [titleLabel setText:models.title];
        }
    }
}

+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter* dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM月dd日 hh:mm"];
    });
    return dateFormatter;
}

@end
