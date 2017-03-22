//
//  PictureAddCell.m
//  类似QQ图片添加、图片浏览
//
//  Created by seven on 16/3/31.
//  Copyright © 2016年 QQpicture. All rights reserved.
//

#import "PictureAddCell.h"

@implementation PictureAddCell
{
    UIImageView *addImageView;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
     addImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:addImageView];
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    addImageView.frame = CGRectMake(10,10, 80, 80);
    addImageView.image = [UIImage imageNamed:@"添加.png"];
    
    
}


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com