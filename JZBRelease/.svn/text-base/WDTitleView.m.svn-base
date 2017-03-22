//
//  WDTitleView.m
//  JZBRelease
//
//  Created by cl z on 16/11/2.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "WDTitleView.h"
#import "FamousMasterColumnsModel.h"
@implementation WDTitleView

{
    UILabel *label;
    UILabel *label1;
    
}

- (instancetype)initTypeStr:(NSString *) str WithFrame:(CGRect) frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, (frame.size.height - 17.5) / 2, 5.5, 17.5)];
        [imageView setImage:[UIImage imageNamed:@"WD_titleicon"]];
        [self addSubview:imageView];
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(21.5, 0, 150, frame.size.height)];
        [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
//        [label setTextColor:[UIColor hx_colorWithHexRGBAString:@"6bbaf6"]];
        [label setTextColor:[UIColor hx_colorWithHexRGBAString:@"212121"]];
        [label setText:str];
        [self addSubview:label];
        
        
        self.btn = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width - 120, 0, 120, frame.size.height)];
        [self.btn setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.btn];
        UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(self.btn.frame.size.width - 20.5, (frame.size.height - 10) / 2.0, 0, 0)];
        [imageView1 setImage:[UIImage imageNamed:@"WD_more"]];
        [imageView1 sizeToFit];
        [self.btn addSubview:imageView1];
        label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.btn.frame.size.width - 27.5, frame.size.height)];
        [label1 setFont:[UIFont systemFontOfSize:14]];
        [label1 setTextColor:[UIColor hx_colorWithHexRGBAString:@"757575"]];
        label1.textAlignment = NSTextAlignmentRight;
        NSRange range = [str rangeOfString:@"专栏"];
        if (range.length > 0) {
            [label1 setText:@"全部专栏"];
        }else{
            [label1 setText:@"全部问答"];
        }
        
        [self.btn addSubview:label1];
        
        UIView *inteval = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height - 0.6, frame.size.width, 0.6)];
        [inteval setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"bdbdbd"]];
        [self addSubview:inteval];
    }
    return self;
}

+ (WDTitleView *) initTypeStr:(NSString *) str WithFrame:(CGRect) frame{
    WDTitleView *view = [[WDTitleView alloc]initTypeStr:str WithFrame:frame];
    return view;
}

- (void) updateTypeWithModel:(GetValueObject *) model{
    self.model = model;
    [label setText:((FamousMasterColumnsModel *)model).title];
    [label1 setText:((FamousMasterColumnsModel *)model).title];
}


@end
