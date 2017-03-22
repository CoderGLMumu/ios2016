//
//  CusNinePicView.m
//  JZBRelease
//
//  Created by zjapple on 16/6/22.
//  Copyright © 2016年 zjapple. All rights reserved.
//frame宽度满屏,三行3列

#import "CusNinePicView.h"
#import "UIImageView+WebCache.h"
@implementation CusNinePicView

-(instancetype)initWithData:(NSArray *) ary
            WithSigleHeight:(NSInteger) height
                WithInteval:(NSInteger) inteval
             WithDefaultPic:(NSString *)
picName OrignY:(NSInteger) offY{
    NSInteger num;
    if (ary.count % 3 == 0) {
        num = ary.count / 3;
    }else{
        num = ary.count / 3 + 1;
    }
    
    self = [super initWithFrame:CGRectMake(0, offY, [UIScreen mainScreen].bounds.size.width, (height + inteval) * num - inteval)];
    if (self) {
        NSInteger row = 0;
        NSInteger column = 0;
        for (NSInteger i = 0; i < ary.count; i ++) {
            CGRect imageRect = CGRectMake(([UIScreen mainScreen].bounds.size.width - 2 * (height + 2 * inteval) - 2 * inteval - 3 * height) / 2 + height + 2 * inteval + (column * (height + inteval)),
                                          (row * (height + inteval)),
                                          height,
                                          height);
            
            UIImageView* imageStorage = [[UIImageView alloc] init];
            imageStorage.frame = imageRect;
            NSString* URLString = [ary objectAtIndex:i];
            [imageStorage sd_setImageWithURL:[NSURL URLWithString:URLString] placeholderImage:[UIImage imageNamed:picName]];
            [self addSubview:imageStorage];
            column = column + 1;
            if (column > 2) {
                column = 0;
                row = row + 1;
            }
        }

    }
    return self;
}

+(CusNinePicView *) getCusNinePicViewWithData:(NSArray *) ary
                              WithSigleHeight:(NSInteger) height
                                  WithInteval:(NSInteger) inteval
                               WithDefaultPic:(NSString *) picName
                                       OrignY:(NSInteger) offY{
    CusNinePicView *pics = [[CusNinePicView alloc]initWithData:ary WithSigleHeight:height WithInteval:inteval WithDefaultPic:(NSString *) picName OrignY:(NSInteger) offY];
    return pics;
}

@end
