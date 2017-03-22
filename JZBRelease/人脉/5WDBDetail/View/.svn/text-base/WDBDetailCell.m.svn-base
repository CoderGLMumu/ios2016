//
//  WDBDetailCell.m
//  MyBang
//
//  Created by mac on 16/10/4.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "WDBDetailCell.h"
#import "InfoShowView.h"

@interface WDBDetailCell ()

@property (nonatomic, weak) InfoShowView *infoView;

@end

@implementation WDBDetailCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        InfoShowView *infoView = [InfoShowView getInfoShowViewWithData:nil WithFrame:CGRectMake(0, 0, self.glw_width, self.glh_height)];
        self.infoView = infoView;
        
        [self addSubview:infoView];
        
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchResultTableView"];
    if (self) {
        
        InfoShowView *infoView = [InfoShowView getInfoShowViewWithData:nil WithFrame:CGRectMake(0, 0, self.glw_width, self.glh_height)];
        self.infoView = infoView;
        
        [self addSubview:infoView];
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    InfoShowView *infoView = [InfoShowView getInfoShowViewWithData:nil WithFrame:CGRectMake(0, 0, self.glw_width, self.glh_height)];
    self.infoView = infoView;
    
    [self addSubview:infoView];
    
}

- (void)setModel:(WDBmember *)model
{
    _model = model;
    
    [self.infoView updateFrameWithData:model.user];
    
    self.infoView.botView.hidden = YES;
    
}

- (void)setUser:(Users *)user
{
    _user = user;
    
    [self.infoView updateFrameWithData:user];
    
    self.infoView.botView.hidden = YES;
}



@end
