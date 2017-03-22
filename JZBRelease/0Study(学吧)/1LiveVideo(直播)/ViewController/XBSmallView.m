//
//  XBSmallView.m
//  JZBRelease
//
//  Created by cl z on 16/10/12.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "XBSmallView.h"
#import "Defaults.h"

@implementation XBSmallView{
    UIImageView *imageView;
    UILabel *topTitleLabel;
    UIView *backgroundView;
    UIView *backgroundView1;
    UILabel *payLabel;
    UILabel *peopleCountLabel;
    UIImageView *peopleImageView;
    UIView *thirdView;
    UILabel *titleLabel;
    dispatch_queue_t queue;
    NSInteger height;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        height = 0;
        queue = dispatch_queue_create("contentqueue", nil);
    }
    return self;
}

+ (XBSmallView *) initWithModel:(CourseTimeModel *) model WithFrame:(CGRect) frame{
    XBSmallView *view = [[XBSmallView alloc]initWithFrame:frame];
    return view;

}

- (void)updateWithModel:(CourseTimeModel *)models{
    if (0 == height) {
        if (fabs((double)MAX(Main_Screen_Width, Main_Screen_Height) - (double)568) < DBL_EPSILON) {
            height = 95;
            
        }else if (fabs((double)MAX(Main_Screen_Width, Main_Screen_Height) - (double)736) < DBL_EPSILON){
            height = 115;
            
        }else if (fabs((double)MAX(Main_Screen_Width, Main_Screen_Height) - (double)667) < DBL_EPSILON){
            height = 115;
        }
    }
    self.models = models;
    if (!imageView) {
        if (!self.isTwoSmall) {
            if (!self.isThreeSmall) {
                imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 8, self.frame.size.width - 13.5, height)];
            }else{
                imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, self.frame.size.width - 13.5, height)];
            }
        }else{
            if (!self.isThreeSmall) {
                imageView = [[UIImageView alloc]initWithFrame:CGRectMake(3.5, 8, self.frame.size.width - 13.5, height)];
            }else{
                imageView = [[UIImageView alloc]initWithFrame:CGRectMake(3.5, 0, self.frame.size.width - 13.5, height)];
            }
        }
        [self addSubview:imageView];
    }
    NSString *abP = [ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort];
    //if (!imageView.image) {
        NSString *path = [abP stringByAppendingString:models.thumb];
        dispatch_async(queue, ^{
            UIImage *image = [LocalDataRW getImageWithDirectory:Directory_XB RetalivePath:path];
            __block typeof (image) wimage = image;
            dispatch_async(dispatch_get_main_queue(), ^{
                wimage = [ZJBHelp handleImage:image withSize:imageView.frame.size withFromStudy:YES];
                [imageView setImage:wimage];
            });
        });
   // }
    
    MechanismModel *mechanismModel = models.mechanism;
    NSDictionary *topAttr = @{NSFontAttributeName:[UIFont systemFontOfSize:11]};
    if (mechanismModel && mechanismModel.name && mechanismModel.name.length > 0) {
        NSString *topTitleStr = mechanismModel.name;
        int topWidth = [topTitleStr sizeWithAttributes:topAttr].width + 20;
        if (!topTitleLabel) {
            topTitleLabel = [[UILabel alloc]init];
            if (!self.isTwoSmall) {
                topTitleLabel.frame = CGRectMake(self.frame.size.width - topWidth - 3.5, 8, topWidth, 20);
            }else{
                topTitleLabel.frame = CGRectMake(imageView.frame.origin.x + imageView.frame.size.width - topWidth, 8, topWidth, 20);
            }
            [topTitleLabel setTextColor:[UIColor whiteColor]];
            [topTitleLabel setFont:[UIFont systemFontOfSize:11]];
            topTitleLabel.textAlignment = NSTextAlignmentCenter;
            [topTitleLabel setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"ff9800"]];
            [self addSubview:topTitleLabel];
        }
        if (!self.isTwoSmall) {
            topTitleLabel.frame = CGRectMake(self.frame.size.width - topWidth - 3.5, 8, topWidth, 20);
        }else{
            topTitleLabel.frame = CGRectMake(imageView.frame.origin.x + imageView.frame.size.width - topWidth, 8, topWidth, 20);
        }
        
        [topTitleLabel setText:topTitleStr];

    }
    
    if (!backgroundView) {
        backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, height - 22, imageView.frame.size.width, 22)];
        [backgroundView setBackgroundColor:[UIColor blackColor]];
        backgroundView.alpha = 0.7;
        [imageView addSubview:backgroundView];
        
        backgroundView1 = [[UIView alloc]initWithFrame:CGRectMake(0, height - 22, imageView.frame.size.width, 22)];
        [backgroundView1 setBackgroundColor:[UIColor clearColor]];
        [imageView addSubview:backgroundView1];

    }
    Users *users = [[Users alloc]init];
    users = [[LoginVM getInstance] users];
    
    NSString *payStr;
   // AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    if (appDelegate.checkpay) {
        if (models.score && models.score.length > 0 && ([models.score floatValue] > 0.0)) {
            //        if (!users.vip) {
            payStr = [models.score stringByAppendingString:@" (会员免费)"];
            //        }else{
            //            payStr = @"免费";
            //        }
        }else{
            payStr = @"免费";
        }
    //}else{
  //      payStr = @"免费";
  //  }
    if (!payLabel) {
        payLabel = [[UILabel alloc]initWithFrame:CGRectMake(7, 0, [payStr sizeWithAttributes:topAttr].width, backgroundView1.frame.size.height)];
        [payLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"ff9800"]];
        [payLabel setFont:[UIFont systemFontOfSize:11]];
        [backgroundView1 addSubview:payLabel];
    }
    [payLabel setFrame:CGRectMake(7, 0, [payStr sizeWithAttributes:topAttr].width, backgroundView1.frame.size.height)];
    [payLabel setText:payStr];
    
    NSString *peopleStr;
    if (models.show_count && models.show_count.length > 0) {
        peopleStr = models.show_count;
    }else{
        peopleStr = @"0";
    }
    NSDictionary *attr = @{NSFontAttributeName:[UIFont systemFontOfSize:11]};
    if (!peopleCountLabel) {
        peopleCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(backgroundView1.frame.size.width - [peopleStr sizeWithAttributes:attr].width - 10, 0, [peopleStr sizeWithAttributes:attr].width, backgroundView1.frame.size.height)];
        [peopleCountLabel setTextColor:[UIColor whiteColor]];
        [peopleCountLabel setFont:[UIFont systemFontOfSize:11]];
        [backgroundView1 addSubview:peopleCountLabel];
    }
    peopleCountLabel.frame = CGRectMake(backgroundView1.frame.size.width - [peopleStr sizeWithAttributes:attr].width - 10, 0, [peopleStr sizeWithAttributes:attr].width, backgroundView1.frame.size.height);
    [peopleCountLabel setText:peopleStr];
    
    if (!peopleImageView) {
        peopleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(backgroundView1.frame.size.width - [peopleStr sizeWithAttributes:attr].width - 31, 4, 14, 14)];
        [backgroundView1 addSubview:peopleImageView];
        [peopleImageView setImage:[UIImage imageNamed:@"XBZY_people"]];
    }
    [peopleImageView setFrame: CGRectMake(backgroundView1.frame.size.width - [peopleStr sizeWithAttributes:attr].width - 31, 4, 14, 14)];
    
   
    if (!thirdView) {
        thirdView = [[UIView alloc]initWithFrame:CGRectMake(0, imageView.frame.origin.y + imageView.frame.size.height, self.frame.size.width, 39)];
        [thirdView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:thirdView];
    }
    
    if (!titleLabel) {
        if (!self.isTwoSmall) {
            titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, thirdView.frame.size.width - 20, thirdView.frame.size.height)];
        }else{
            titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(7, 0, thirdView.frame.size.width - 20, thirdView.frame.size.height)];

        }
        [titleLabel setFont:[UIFont systemFontOfSize:14]];
        [titleLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"212121"]];
        [thirdView addSubview:titleLabel];
    }
    
    if (models.title && models.title.length > 1) {
//        NSString *singleStr = [models.title substringToIndex:1];
//        NSDictionary *titleTextAttrs = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
//        int singleWidth = [singleStr sizeWithAttributes:titleTextAttrs].width;
//        int count = titleLabel.frame.size.width / singleWidth;
        [titleLabel setText:models.title];
//        if (models.title.length > count) {
//            NSString *title = [[models.title substringToIndex:count - 3] stringByAppendingString:@"..."];
//            [titleLabel setText:title];
//        }else{
//            [titleLabel setText:models.title];
//        }
    }
}

@end
