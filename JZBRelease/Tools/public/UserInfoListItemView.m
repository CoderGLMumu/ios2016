//
//  UserInfoListItemView.m
//  JZBRelease
//
//  Created by Apple on 16/12/14.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "UserInfoListItemView.h"
#import "Masonry.h"

@interface UserInfoListItemView ()

/** imageV */
@property (nonatomic, weak) UIImageView *avatarView;
/** nicknameLabel */
@property (nonatomic, weak) UILabel *nicknameLabel;
/** fengexianRAnicknameLabel */
@property (nonatomic, weak) UIView *fengexianRAnicknameLabel;
/** typeNameLabel */
@property (nonatomic, weak) UILabel *typeNameLabel;

/** companyLabel */
@property (nonatomic, weak) UILabel *companyLabel;
/** fengexianRWcompanyLabel */
@property (nonatomic, weak) UIView *fengexianRWcompanyLabel;
/** jobLabel */
@property (nonatomic, weak) UILabel *jobLabel;

@end

@implementation UserInfoListItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubView];
    }
    return self;
}

- (void)setUser:(Users *)user
{
    _user = user;
    
    //    [self setupSubView];
    
    [self updateData];
    
    [self creatMas];
    
}

- (void)creatMas
{
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.leading.equalTo(self).offset(10);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.avatarView.mas_trailing).offset(10);
        make.top.equalTo(self.avatarView);
    }];
    
    [self.fengexianRAnicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nicknameLabel.mas_top).offset(3);
        make.leading.equalTo(self.nicknameLabel.mas_trailing).offset(5);
        make.height.equalTo(@(self.nicknameLabel.glh_height - 6));
        make.width.equalTo(@(1));
    }];
    
    [self.typeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nicknameLabel);
        make.leading.equalTo(self.fengexianRAnicknameLabel.mas_trailing).offset(5);
    }];
    
    [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.avatarView.mas_trailing).offset(10);
        make.bottom.equalTo(self.avatarView);
    }];
    
    [self.fengexianRWcompanyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.companyLabel.mas_top).offset(3);
        make.leading.equalTo(self.companyLabel.mas_trailing).offset(5);
        make.height.equalTo(@(self.companyLabel.glh_height - 6));
        make.width.equalTo(@(1));
    }];
    
    [self.jobLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.companyLabel);
        make.leading.equalTo(self.fengexianRWcompanyLabel.mas_trailing).offset(5);
    }];
    
    [self layoutIfNeeded];
    
//    CGFloat maxW = self.glw_width - 10 - 10 -44 ;
//    
//    if (self.companyLabel.glw_width + self.jobLabel.glw_width > maxW) {
//        
//        if (self.companyLabel.glw_width > self.jobLabel.glw_width) {
//            
//            self.companyLabel.glw_width = maxW - self.jobLabel.glw_width - 5;
//            
//        }else {
//            self.jobLabel.glw_width = maxW - self.companyLabel.glw_width - 5;
//            
//        }
//        
//        self.fengexianRWcompanyLabel.glx_x = self.companyLabel.glr_right - 1;
//        
//        self.jobLabel.glx_x = self.companyLabel.glr_right + 5;
//    }
    
    [self updateSubViewConstraints];
    
    self.avatarView.layer.cornerRadius = self.avatarView.glw_width / 2;
    self.avatarView.clipsToBounds = YES;
}

- (void)setupSubView
{
    // 头像
    UIImageView *avatarView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    [self addSubview:avatarView];
//    imageV.frame = CGRectMake(10, 10, 35, 35);
    self.avatarView = avatarView;
//    avatarView.backgroundColor = [UIColor yellowColor];
    
//    avatarView.backgroundColor = [UIColor greenColor];
    
    // nickname
    UILabel *nicknameLabel = [UILabel new];
    self.nicknameLabel = nicknameLabel;
    [self addSubview:nicknameLabel];
//    nicknameLabel.frame = CGRectMake(imageV.glr_right + 5, nickNameLabel.glb_bottom + 5, 0, 0);
    nicknameLabel.text = @"正在加载...";
    nicknameLabel.font = [UIFont systemFontOfSize:16];
    [nicknameLabel sizeToFit];
//    nicknameLabel.backgroundColor = [UIColor redColor];
    nicknameLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"212121"];
    
    // nickname 右边 分割线
    UIView *fengexianRAnicknameLabel = [UIView new];
    self.fengexianRAnicknameLabel = fengexianRAnicknameLabel;
    [self addSubview:fengexianRAnicknameLabel];
    
    fengexianRAnicknameLabel.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"bdbdbd"];
    
    
    // 所属大T
    UILabel *typeNameLabel = [UILabel new];
    self.typeNameLabel = typeNameLabel;
    [self addSubview:typeNameLabel];
    //    nicknameLabel.frame = CGRectMake(imageV.glr_right + 5, nickNameLabel.glb_bottom + 5, 0, 0);
    typeNameLabel.text = @" ";
    typeNameLabel.font = [UIFont systemFontOfSize:13];
    [typeNameLabel sizeToFit];
//    typeNameLabel.backgroundColor = [UIColor redColor];
    typeNameLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
    
    
    // 公司Label
    UILabel *companyLabel = [UILabel new];
    self.companyLabel = companyLabel;
    [self addSubview:companyLabel];
    //    nicknameLabel.frame = CGRectMake(imageV.glr_right + 5, nickNameLabel.glb_bottom + 5, 0, 0);
    companyLabel.text = @" ";
    companyLabel.font = [UIFont systemFontOfSize:13];
    [companyLabel sizeToFit];
//    companyLabel.backgroundColor = [UIColor redColor];
    companyLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
    
    
    // company 右边 分割线
    UIView *fengexianRWcompanyLabel = [UIView new];
    self.fengexianRWcompanyLabel = fengexianRWcompanyLabel;
    [self addSubview:fengexianRWcompanyLabel];
    
    fengexianRWcompanyLabel.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"bdbdbd"];
    
    
    // 职务Label
    UILabel *jobLabel = [UILabel new];
    self.jobLabel = jobLabel;
    [self addSubview:jobLabel];
    //    nicknameLabel.frame = CGRectMake(imageV.glr_right + 5, nickNameLabel.glb_bottom + 5, 0, 0);
    jobLabel.text = @" ";
    jobLabel.font = [UIFont systemFontOfSize:13];
    [jobLabel sizeToFit];
//    jobLabel.backgroundColor = [UIColor redColor];
    jobLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
    
    [self layoutIfNeeded];
}

- (void)updateData
{
//    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:[AddHostToLoadPIC AddHostToLoadPICWithString:self.user.avatar]] placeholderImage:[UIImage imageNamed:@"ZCCG_TX"]];
    
    [LocalDataRW getImageWithDirectory:Directory_WD RetalivePath:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:self.user.avatar] WithContainerImageView:self.avatarView];
    
    self.nicknameLabel.text = self.user.nickname;
    self.typeNameLabel.text = self.user.type_name;
    
    self.companyLabel.text = self.user.company;
    self.jobLabel.text = self.user.job;
    
    if ([self.companyLabel.text isEqualToString:@""]) {
        self.companyLabel.text = @"暂无";
    }
    
    if ([self.jobLabel.text isEqualToString:@""]) {
        self.jobLabel.text = @"暂无";
    }
    
    if ([self.typeNameLabel.text isEqualToString:@""]) {
        self.typeNameLabel.text = @"暂无";
    }
    
}

- (void)updateSubViewConstraints
{
    CGFloat maxW = self.glw_width - 10 - 10 -44 ;
    
    if (self.companyLabel.glw_width + self.jobLabel.glw_width > maxW) {
        
        if (self.companyLabel.glw_width > self.jobLabel.glw_width) {
            
            [self.companyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(maxW - self.jobLabel.glw_width - 5));
            }];
            
        }else {
//            self.jobLabel.glw_width = maxW - self.companyLabel.glw_width - 5;
            [self.jobLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(maxW - self.companyLabel.glw_width - 5));
            }];
        }
        
        self.fengexianRWcompanyLabel.glx_x = self.companyLabel.glr_right - 1;
        
        self.jobLabel.glx_x = self.companyLabel.glr_right + 5;
    }
}


@end
