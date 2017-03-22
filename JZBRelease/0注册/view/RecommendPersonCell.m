//
//  RecommendPersonCell.m
//  JZBRelease
//
//  Created by zjapple on 16/10/17.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "RecommendPersonCell.h"
#import "InfoShowView.h"
#import "UserInfoListItemView.h"
#import "Masonry.h"

@interface RecommendPersonCell ()

//@property (nonatomic, weak) InfoShowView *infoView;
/** leftView */
@property (nonatomic, strong) UserInfoListItemView *leftView;

@end

@implementation RecommendPersonCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubView];
        
//        InfoShowView *infoView = [InfoShowView getInfoShowViewWithData:nil WithFrame:CGRectMake(0, 0, self.glw_width, self.glh_height)];
//        self.infoView = infoView;
//        
//        [self addSubview:infoView];
        
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchResultTableView"];
    if (self) {
        [self setupSubView];
        
//        InfoShowView *infoView = [InfoShowView getInfoShowViewWithData:nil WithFrame:CGRectMake(0, 0, self.glw_width, self.glh_height)];
//        self.infoView = infoView;
//        
//        [self addSubview:infoView];
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupSubView];
    
//    InfoShowView *infoView = [InfoShowView getInfoShowViewWithData:nil WithFrame:CGRectMake(0, 0, self.glw_width, self.glh_height)];
//    self.infoView = infoView;
//    
//    [self addSubview:infoView];
    
}

- (void)setupSubView
{
    self.autoresizesSubviews = NO;
    
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

- (void)setItem:(RecommendPersonItem *)item
{
    _item = item;
    
    self.leftView.user = item;
    
//    [self.infoView updateFrameWithData:item];
//    
//    self.infoView.botView.hidden = YES;
}

- (void)updateSubViewConstraints
{
    [self.leftView updateSubViewConstraints];
}


@end
