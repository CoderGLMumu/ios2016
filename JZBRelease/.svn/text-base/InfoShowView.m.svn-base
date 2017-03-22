//
//  InfoShowView.m
//  JZBRelease
//
//  Created by zjapple on 16/6/22.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "InfoShowView.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "DealNormalUtil.h"
@implementation InfoShowView{
    UILabel *intevalLabel,*intevalLabel1;
    UIView *intevalView;
}

-(instancetype)initWithFrame:(CGRect)frame WithData:(GetValueObject *) obj{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void) updateFrameWithData:(GetValueObject *) obj{
    Users *user = (Users *)obj;
    if (!self.avatarView) {
        self.avatarView = [[UIImageView alloc]init];
        [self addSubview:self.avatarView];
        [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(44, 44));
            make.leftMargin.equalTo(self).offset(10);
            make.topMargin.equalTo(self).offset(10);
        }];
        self.avatarView.layer.cornerRadius = 22;
        self.avatarView.layer.masksToBounds = YES;
        self.avatarView.userInteractionEnabled = YES;
        UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(avtarTap)];
        [self.avatarView addGestureRecognizer:tap];
    }
    
    
//    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:user.avatar]] placeholderImage:[UIImage imageNamed:@"bq_img_head"]];
    
//    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:user.avatar]] placeholderImage:[UIImage imageNamed:@"bq_img_head"]];
    
    
    [LocalDataRW getImageWithDirectory:Directory_BB RetalivePath:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:user.avatar] WithContainerImageView:self.avatarView];
    
    if (!self.nameBtn) {
        self.nameBtn = [[UIButton alloc]init];
        [self addSubview:self.nameBtn];
        [self.nameBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"212121"] forState:UIControlStateNormal];
        [self.nameBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    }
    NSString *nameStr;
    if (user.nickname.length > 6) {
        nameStr = [user.nickname substringToIndex:6];
    }else{
        nameStr = user.nickname;
    }
    [self.nameBtn setTitle:nameStr forState:UIControlStateNormal];
    NSDictionary *nameAttrs = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
    self.nameBtn.frame = CGRectMake(44 + 10 + 8, 12, [user.nickname sizeWithAttributes:nameAttrs].width + user.inteval / 3, [user.nickname sizeWithAttributes:nameAttrs].height);
    
    if (!intevalLabel1) {
        intevalLabel1 = [[UILabel alloc]init];
        [self addSubview:intevalLabel1];
        [intevalLabel1 setText:@"|"];
        [intevalLabel1 setTextColor:[UIColor hx_colorWithHexRGBAString:@"bdbdbd"]];
        [intevalLabel1 setFont:[UIFont systemFontOfSize:14]];
        intevalLabel1.textAlignment = NSTextAlignmentCenter;
    }
    intevalLabel1.frame = CGRectMake(self.nameBtn.frame.origin.x + self.nameBtn.frame.size.width, 10, 20, self.nameBtn.frame.size.height);
    
    if (!self.gangLabel) {
        self.gangLabel = [[UILabel alloc]init];
        [self addSubview:self.gangLabel];
        [self.gangLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"757575"]];
        [self.gangLabel setFont:[UIFont systemFontOfSize:14]];
    }
    if (!user.type_name || user.type_name.length <= 0) {
        user.type_name = @"智囊团";
    }
    
    // 去除首尾空格：
//    user.gang = [user.gang stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // 去除首尾空格和换行：
    user.type_name = [user.type_name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    [self.gangLabel setText:user.type_name];
    
    NSDictionary *gangAttrs = @{NSFontAttributeName:self.gangLabel.font};
    self.gangLabel.frame = CGRectMake(intevalLabel1.frame.origin.x + intevalLabel1.frame.size.width, 12, [self.gangLabel.text sizeWithAttributes:gangAttrs].width, [self.gangLabel.text sizeWithAttributes:gangAttrs].height);
    [self addSubview:self.gangLabel];
    
    if (!self.vipRangeView) {
        self.vipRangeView = [[UIImageView alloc]init];
        [self addSubview:self.vipRangeView];
    }
    [self.vipRangeView setImage:[[DealNormalUtil getInstance]getImageBasedOnName:user.level]];
    self.vipRangeView.frame = CGRectMake(self.gangLabel.frame.origin.x + self.gangLabel.frame.size.width + 3, 14.5, 16, 12);

    if (!self.companyPositionLabel) {
        self.companyPositionLabel = [[UILabel alloc]init];
        [self addSubview:self.companyPositionLabel];
        
        [self.companyPositionLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"757575"]];
        [self.companyPositionLabel setFont:[UIFont systemFontOfSize:12]];
    }
    NSString *companyText;
    if (user.company && user.company.length > 0) {
        companyText = user.company;
    }else{
        companyText = @"暂无";
    }
    [self.companyPositionLabel setText:companyText];
    NSDictionary *companyAttrs = @{NSFontAttributeName:self.companyPositionLabel.font};
    self.companyPositionLabel.frame = CGRectMake(62, 39, [self.companyPositionLabel.text sizeWithAttributes:companyAttrs].width, [self.companyPositionLabel.text sizeWithAttributes:companyAttrs].height);
    
    if (self.companyPositionLabel.text.length > 13) {
        self.companyPositionLabel.text = [NSString stringWithFormat:@"%@...",[self.companyPositionLabel.text substringToIndex:11]];
    }
    
    [self.companyPositionLabel sizeToFit];
    
    if (!intevalLabel) {
        intevalLabel = [[UILabel alloc]init];
        [self addSubview:intevalLabel];
        [intevalLabel setText:@"|"];
        [intevalLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"bdbdbd"]];
        [intevalLabel setFont:[UIFont systemFontOfSize:12]];
        intevalLabel.textAlignment = NSTextAlignmentCenter;
    }
    intevalLabel.frame = CGRectMake(self.companyPositionLabel.frame.origin.x + self.companyPositionLabel.frame.size.width, 38, 20, [self.companyPositionLabel.text sizeWithAttributes:companyAttrs].height);
    
    if (!self.jobPositionLabel) {
        self.jobPositionLabel = [[UILabel alloc]init];
        [self addSubview:self.jobPositionLabel];
        
        [self.jobPositionLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"757575"]];
        [self.jobPositionLabel setFont:[UIFont systemFontOfSize:12]];
    }
    NSString *jobText;
    if (user.job && user.job.length > 0) {
        jobText = user.job;
    }else{
        jobText = @"暂无";
    }
    
    if (jobText.length > 5) {
        jobText = [NSString stringWithFormat:@"%@...",[jobText substringToIndex:5]];
    }
    
    [self.jobPositionLabel setText:jobText];
    NSDictionary *jobAttrs = @{NSFontAttributeName:self.jobPositionLabel.font};
    self.jobPositionLabel.frame = CGRectMake(intevalLabel.frame.origin.x + intevalLabel.frame.size.width, 39, [self.jobPositionLabel.text sizeWithAttributes:jobAttrs].width, [self.jobPositionLabel.text sizeWithAttributes:jobAttrs].height);
    
    if (self.isCaina) {
        if (!self.cainaView) {
            self.cainaView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - 50, 0, 50, 50)];
            [self.cainaView setImage:[UIImage imageNamed:@"WD_CN"]];
            [self addSubview:self.cainaView];
        }
        self.cainaView.hidden = NO;
    }else{
        self.cainaView.hidden = YES;
    }
    
    if (!self.intevalViewHidden) {
        if (!intevalView) {
            intevalView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1)];
            [intevalView setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
            [self addSubview:intevalView];
            self.botView = intevalView;
        }
    }
}

+(InfoShowView *) getInfoShowViewWithData:(GetValueObject *) obj WithFrame:(CGRect) frame{
    
    InfoShowView *view = [[InfoShowView alloc]initWithFrame:frame WithData:obj];
    
    return view;
}

- (void) avtarTap{
    if (self.returnAction) {
        self.returnAction(0);
    }
}

- (NSDateFormatter *)dateFormatter {
    static NSDateFormatter* dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM月dd日 hh:mm"];
    });
    return dateFormatter;
}

@end
