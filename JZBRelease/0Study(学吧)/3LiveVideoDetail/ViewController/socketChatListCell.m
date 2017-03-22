//
//  socketChatListCell.m
//  JZBRelease
//
//  Created by Apple on 16/12/12.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "socketChatListCell.h"
#import "UserInfoListItemView.h"
#import "Masonry.h"

@interface socketChatListCell ()
@property (weak, nonatomic) IBOutlet UILabel *rightNumTLabel;
/** leftView */
@property (nonatomic, strong) UserInfoListItemView *leftView;
@end

@implementation socketChatListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupSubView];
    
    self.autoresizesSubviews = NO;
    
}

- (void)setupSubView
{
    UserInfoListItemView *leftView = [UserInfoListItemView new];
    self.leftView = leftView;
//    leftView.backgroundColor = [UIColor redColor];
    [self addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.top.equalTo(self);
        make.height.equalTo(self);
        make.width.equalTo(@(self.glw_width * 2/3));
    }];
    
}

- (void)setModel:(reward_rankItem *)model
{
    _model = model;
    
    self.leftView.user = model.user;
    
    self.rightNumTLabel.text = [NSString stringWithFormat:@"%@帮币",model.total_money];
    [self.rightNumTLabel sizeToFit];
}

- (void)updateSubViewConstraints
{
    [self.leftView updateSubViewConstraints];
}


@end
