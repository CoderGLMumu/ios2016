//
//  ManagerCacheCell.m
//  JZBRelease
//
//  Created by cl z on 16/11/14.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "ManagerCacheCell.h"

@implementation ManagerCacheCell{
    UIView *intevalView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}


- (void)setModel:(ManagerCacheModel *)model{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, (self.contentView.frame.size.height - 21) / 2, 180, 21)];
        [_nameLabel setFont:[UIFont systemFontOfSize:17]];
        [self.contentView addSubview:_nameLabel];
    }
    NSString *str = [NSString stringWithFormat:@"%@(%@)",model.name,model.size];
    [_nameLabel setText:str];
    
    if (!_clearBtn) {
        _clearBtn = [[UIButton alloc]initWithFrame:CGRectMake(GLScreenW - 20 - 30, (self.contentView.frame.size.height - 30) / 2, GLScreenW, 30)];
        [self.contentView addSubview:_clearBtn];
    }
    
    if (!intevalView) {
        intevalView = [[UIView alloc]initWithFrame:CGRectMake(20, 49 - 0.8, GLScreenW - 20, 0.8)];
        [self.contentView addSubview:intevalView];
        [intevalView setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"bdbdbd"]];
    }
    
}

@end
