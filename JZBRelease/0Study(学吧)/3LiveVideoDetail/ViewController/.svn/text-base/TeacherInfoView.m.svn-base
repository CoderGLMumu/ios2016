//
//  TeacherInfoView.m
//  JZBRelease
//
//  Created by zjapple on 16/10/13.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "TeacherInfoView.h"
#import "DealNormalUtil.h"

@interface TeacherInfoView ()
@property (weak, nonatomic) IBOutlet UIImageView *teacherAvaImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *type_nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *vipImageView;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *painNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *painLabel;

/** isZLT */
@property (nonatomic, assign) BOOL isZLT;

@end

@implementation TeacherInfoView

+ (instancetype)TeacherInfoView
{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]firstObject];
}

- (void)setTeacherInfo:(Users *)teacherInfo
{
    _teacherInfo = teacherInfo;
    
    self.nickNameLabel.text = teacherInfo.nickname;
    
    //    self.titleLabel.text = model.company;
    self.companyLabel.text = [NSString stringWithFormat:@"%@ %@",teacherInfo.company,teacherInfo.job];
    
//    if (teacherInfo.company.length >=8) {
//        self.companyLabel.text = [NSString stringWithFormat:@"%@...  %@",[teacherInfo.company substringToIndex:8],teacherInfo.job];
//    }else {
////        self.companyLabel.text = item.teacher.company;
//        self.companyLabel.text = [NSString stringWithFormat:@"%@ %@",teacherInfo.company,teacherInfo.job];
//    }
    
//    [self.teacherAvaImageView sd_setImageWithURL:[NSURL URLWithString:[AddHostToLoadPIC AddHostToLoadPICWithString:teacherInfo.avatar]] placeholderImage:[UIImage imageNamed:@"ZCCG_TX"]];
    
    [LocalDataRW getImageWithDirectory:Directory_XB RetalivePath:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:teacherInfo.avatar] WithContainerImageView:self.teacherAvaImageView];
    
    self.type_nameLabel.text = teacherInfo.type_name;
    
    self.painLabel.text = teacherInfo.pain;
    
    [self.vipImageView setImage:[[DealNormalUtil getInstance]getImageBasedOnName:teacherInfo.level]];
    
    if ([teacherInfo.type isEqualToString:@"2"]) {
        self.isZLT = YES;
    }
    
    if (self.isZLT) {
        self.painNameLabel.text = @"擅长领域：";
    }else{
        self.painNameLabel.text = @"经营痛点：";
    }
    [self.painNameLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"212121"]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self layoutIfNeeded];
//    [self.teacherAvaImageView sizeToFit];
    
    self.teacherAvaImageView.layer.cornerRadius = GLScreenW *70/375 * 0.5;
    self.teacherAvaImageView.clipsToBounds = YES;
}

@end
