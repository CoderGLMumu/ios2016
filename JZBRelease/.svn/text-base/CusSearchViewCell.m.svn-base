//
//  CusSearchViewCell.m
//  JZBRelease
//
//  Created by cl z on 16/10/22.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "CusSearchViewCell.h"

@implementation CusSearchViewCell{
    UIView *intevalView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setTitleStr:(NSString *)titleStr{
    
    [self.textLabel setText:titleStr];
    if (!_deleteBtn) {
        _deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(GLScreenW - 60, 0, 60, 44)];
        [_deleteBtn setImage:[UIImage imageNamed:@"search_history_delete_icon_normal"] forState:UIControlStateNormal];
        [_deleteBtn setImage:[UIImage imageNamed:@"SearchDeleteSelected"] forState:UIControlStateSelected];
        [self.contentView addSubview:_deleteBtn];
    }
    if (!intevalView) {
        intevalView = [[UIView alloc]initWithFrame:CGRectMake(20, 43.2, GLScreenW - 20, 0.8)];
        [intevalView setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
        [self.contentView addSubview:intevalView];
    }
}


@end
