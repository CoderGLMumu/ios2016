//
//  PersonalHeaderView.h
//  JZBRelease
//
//  Created by zjapple on 16/6/11.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonalModel.h"

@interface PersonalHeaderView : UIView

@property(nonatomic, strong) UIButton *locationBtn;
@property(nonatomic, strong) UIButton *focusBtn;
@property(nonatomic, strong) UIButton *addFriendBtn;
@property(nonatomic, strong) UIButton *sourceBtn;
@property(nonatomic, strong) UIButton *fansBtn;
@property(nonatomic, strong) UIButton *signBtn;
@property(nonatomic, strong) UIButton *broswerBtn;
@property(nonatomic, strong) UIImageView *avatarImageView,*backImageView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *gangLabel;
@property(nonatomic, strong) UILabel *companyLabel;
@property(nonatomic, strong) UILabel *locationLabel;
@property(nonatomic, strong) UILabel *titleLabel,*fansValue;

-(void) initWithData : (Users *) model;

@property(nonatomic, copy) void (^ btnAction)(Clink_Type clink_type);

@end
