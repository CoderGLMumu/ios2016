//
//  SendCourseVC.m
//  JZBRelease
//
//  Created by cl z on 16/9/12.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "SendCourseVC.h"
#import "Defaults.h"

@interface SendCourseVC ()

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) NSMutableArray *itemsSectionPictureArray,*picIDAry;
@property(nonatomic, strong) UIView *banarView;


@end

@implementation SendCourseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (UIView *) returnTitleView:(NSString *) title WithFrame:(CGRect) frame{
    UIView *titleView = [[UIView alloc]initWithFrame:frame];
    [titleView setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f8f8f8"]];
    UILabel *label = [UILabel createLabelWithFrame:CGRectMake(20, 0, 120, frame.size.height) Font:13 Text:title andLCR:NSTextAlignmentLeft andColor:[UIColor hx_colorWithHexRGBAString:@"212121"]];
    [titleView addSubview:label];
    return titleView;
}

- (UIView *)banarView{
    if (!_banarView) {
        _banarView = [[UIView alloc]initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH, 150)];
        [_banarView setBackgroundColor:[UIColor whiteColor]];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, (150 - 60) / 2, 60, 60)];
        [imageView setImage:[UIImage imageNamed:@"WD_FB_TJ"]];
        [_banarView addSubview:imageView];
    }
    return _banarView;
}

@end
