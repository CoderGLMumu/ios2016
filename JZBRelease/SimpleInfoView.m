//
//  SimpleInfoView.m
//  JZBRelease
//
//  Created by zcl on 2016/10/4.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "SimpleInfoView.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "DealNormalUtil.h"
@implementation SimpleInfoView{
    UILabel *intevalLabel,*intevalLabel1;
    UIView *intevalView;
    UIView *intevalLabelVIew;
    int height;
}

-(instancetype)initWithFrame:(CGRect)frame WithData:(GetValueObject *) obj{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void) updateFrameWithData:(GetValueObject *) obj{
    Users *user = (Users *)obj;
    if (height == 0) {
        if (user.inteval == 4.5) {
            height = user.inteval * 2;
        }else{
            height = user.inteval * 2.833;
        }
    }
    if (!self.answerFromLabel) {
        NSString *ansStr = @"分享来自：";
        self.answerFromLabel = [[UILabel alloc]init];
        [self addSubview:self.answerFromLabel];
        [self.answerFromLabel setFont:[UIFont systemFontOfSize:obj.fontSize / 1.214]];
        NSDictionary *ansAttrs = @{NSFontAttributeName:[UIFont systemFontOfSize:obj.fontSize / 1.214]};
        [self.answerFromLabel setFrame:CGRectMake(10, height, [ansStr sizeWithAttributes:ansAttrs].width, [ansStr sizeWithAttributes:ansAttrs].height)];
        self.answerFromLabel.textAlignment = NSTextAlignmentLeft;
        [self.answerFromLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"2197f6"]];
        [self.answerFromLabel setText:ansStr];
    }
    if (!self.avatarView) {
        self.avatarView = [[UIImageView alloc]init];
        [self addSubview:self.avatarView];
        if (user.inteval == 5 || user.inteval == 6) {
            [self.avatarView setFrame:CGRectMake(self.answerFromLabel.frame.size.width + self.answerFromLabel.frame.origin.x, 13, 25, 25)];
            self.avatarView.layer.cornerRadius = 25.0 / 2;
        }else{
            [self.avatarView setFrame:CGRectMake(self.answerFromLabel.frame.size.width + self.answerFromLabel.frame.origin.x, user.inteval * 2.16 + 2, user.inteval * 4.166, user.inteval * 4.166)];
            self.avatarView.layer.cornerRadius = user.inteval * 4.166 / 2;
        }
        
        self.avatarView.layer.masksToBounds = YES;
        self.avatarView.userInteractionEnabled = YES;
        UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(avtarTap)];
        [self.avatarView addGestureRecognizer:tap];
    }
    
    dispatch_async(dispatch_queue_create("", nil), ^{
        UIImage *image = [LocalDataRW getImageWithDirectory:Directory_BB RetalivePath:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:user.avatar]];
        if (!image) {
            image = [UIImage imageNamed:@"bq_img_head"];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.avatarView setImage:image];
        });
    });
    
//    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:user.avatar]] placeholderImage:[UIImage imageNamed:@"bq_img_head"]];

    
    [LocalDataRW getImageWithDirectory:Directory_BB RetalivePath:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:user.avatar] WithContainerImageView:self.avatarView];
    
    if (!self.nameBtn) {
        self.nameBtn = [[UIButton alloc]init];
        [self addSubview:self.nameBtn];
        [self.nameBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"757575"] forState:UIControlStateNormal];
        [self.nameBtn.titleLabel setFont:[UIFont systemFontOfSize:obj.fontSize / 1.214]];
    }
    [self.nameBtn setTitle:user.nickname forState:UIControlStateNormal];
    NSDictionary *nameAttrs = @{NSFontAttributeName:[UIFont systemFontOfSize:obj.fontSize / 1.214]};
    self.nameBtn.frame = CGRectMake(self.avatarView.frame.origin.x + self.avatarView.frame.size.width + user.inteval * 1.67, height, [user.nickname sizeWithAttributes:nameAttrs].width + user.inteval / 3, [user.nickname sizeWithAttributes:nameAttrs].height);
    
//    if (!self.vipRangeView) {
//        self.vipRangeView = [[UIImageView alloc]init];
//        [self addSubview:self.vipRangeView];
//    }
//    [self.vipRangeView setImage:[[DealNormalUtil getInstance]getImageBasedOnName:user.level]];
//    self.vipRangeView.frame = CGRectMake(self.nameBtn.frame.origin.x + self.nameBtn.frame.size.width + 3, 16, 16, 12);
    
    if (!intevalLabel) {
        intevalLabelVIew = [[UIView alloc]initWithFrame:CGRectMake(self.nameBtn.frame.origin.x + self.nameBtn.frame.size.width, self.nameBtn.frame.origin.y, user.inteval * 2.833, self.nameBtn.frame.size.height)];
        [intevalLabelVIew setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:intevalLabelVIew];
        intevalLabel = [[UILabel alloc]init];
        [intevalLabel setText:@"|"];
        [intevalLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"757575"]];
        [intevalLabel setFont:[UIFont systemFontOfSize:obj.fontSize / 1.214]];
        intevalLabel.textAlignment = NSTextAlignmentCenter;
        intevalLabel.frame = CGRectMake(0, 0, intevalLabelVIew.frame.size.width, intevalLabelVIew.frame.size.height);
        //[intevalLabel sizeToFit];
        [intevalLabelVIew addSubview:intevalLabel];
    }
    [intevalLabelVIew setFrame:CGRectMake(self.nameBtn.frame.origin.x + self.nameBtn.frame.size.width, self.nameBtn.frame.origin.y, user.inteval * 2.833, self.nameBtn.frame.size.height)];
    
    if (!self.companyPositionLabel) {
        self.companyPositionLabel = [[UILabel alloc]initWithFrame:CGRectMake(intevalLabelVIew.frame.origin.x + intevalLabelVIew.frame.size.width, self.nameBtn.frame.origin.y, user.inteval * 3.33, self.nameBtn.frame.size.height)];
        self.companyPositionLabel.textAlignment = NSTextAlignmentLeft;
        [self.companyPositionLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"757575"]];
        [self.companyPositionLabel setFont:[UIFont systemFontOfSize:obj.fontSize / 1.214]];
        [self addSubview:self.companyPositionLabel];
    }
    NSString *comStr;
    if (user.company) {
        if (user.company.length > 4) {
            comStr = [user.company substringToIndex:4];
        }else{
            comStr = user.company;
        }
    }
    if (user.job) {
        if (user.job.length > 10) {
            if (comStr) {
                comStr = [comStr stringByAppendingString:[user.job substringToIndex:10]];
            }else{
                comStr = [user.job substringToIndex:10];
            }
        }else{
            if (comStr) {
                comStr = [comStr stringByAppendingString:user.job];
            }else{
                comStr = user.job;
            }
        }
    }
    if (!comStr || comStr.length == 0 || [comStr isEqualToString:@""]) {
        self.companyPositionLabel.hidden = YES;
        intevalLabel.hidden = YES;
    }else{
        self.companyPositionLabel.hidden = NO;
        intevalLabel.hidden = NO;
    }
    [self.companyPositionLabel setText:comStr];
    if (intevalLabel.frame.origin.x + intevalLabel.frame.size.width + [self.companyPositionLabel.text sizeWithAttributes:nameAttrs].width + 3 > (GLScreenW - 10)) {
        [self.companyPositionLabel setFrame:CGRectMake(intevalLabelVIew.frame.origin.x + intevalLabelVIew.frame.size.width, self.nameBtn.frame.origin.y, GLScreenW - 10 - (intevalLabel.frame.origin.x + intevalLabel.frame.size.width), self.nameBtn.frame.size.height)];
        [intevalLabel sizeToFit];
    }else{
        [self.companyPositionLabel setFrame:CGRectMake(intevalLabelVIew.frame.origin.x + intevalLabelVIew.frame.size.width, self.nameBtn.frame.origin.y, [self.companyPositionLabel.text sizeWithAttributes:nameAttrs].width + 3, self.nameBtn.frame.size.height)];
    }
    
    
    if (self.isCaina) {
        if (!self.cainaView) {
            self.cainaView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - user.inteval * 7.33, 0, user.inteval * 7.33, user.inteval * 7.33)];
            [self.cainaView setImage:[UIImage imageNamed:@"WD_CN"]];
            [self addSubview:self.cainaView];
            
        }
        self.cainaView.hidden = NO;
    }else{
        self.cainaView.hidden = YES;
    }
    
    if (!self.delBtn) {
        self.delBtn = [[UIButton alloc]initWithFrame:CGRectMake(GLScreenW - user.inteval * 7.33, 2, user.inteval * 7.33, user.inteval * 7.33)];
        [self.delBtn setImage:[UIImage imageNamed:@"WD_delete"] forState:UIControlStateNormal];
        [self addSubview:self.delBtn];
        
    }
    if (self.delBtn) {
        if (intevalLabel.frame.origin.x + intevalLabel.frame.size.width > (GLScreenW - user.inteval * 7.33)) {
            intevalLabel.hidden = YES;
        }else if (intevalLabel.frame.origin.x + intevalLabel.frame.size.width + [self.companyPositionLabel.text sizeWithAttributes:nameAttrs].width + 3 > (GLScreenW - user.inteval * 7.33)){
            [self.companyPositionLabel setFrame:CGRectMake(intevalLabel.frame.origin.x + intevalLabel.frame.size.width, self.nameBtn.frame.origin.y, GLScreenW - user.inteval * 7.33 - (intevalLabel.frame.origin.x + intevalLabel.frame.size.width), self.nameBtn.frame.size.height)];
            [intevalLabel sizeToFit];
        }else{
            
        }

    }
    
//    if (self.isEmergence) {
//        if (!self.emergenceView) {
//            self.emergenceView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - 25 - 17, (44 - 25) / 2, 25, 25)];
//            [self.emergenceView setImage:[UIImage imageNamed:@"WD_urgent"]];
//            [self addSubview:self.emergenceView];
//        }
//        self.emergenceView.hidden = NO;
//    }else{
//        self.emergenceView.hidden = YES;
//    }

    
    
//    if (!intevalView) {
//        intevalView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1)];
//        [intevalView setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
//        [self addSubview:intevalView];
//        self.botView = intevalView;
//    }
}

+(SimpleInfoView *) getInfoShowViewWithData:(GetValueObject *) obj WithFrame:(CGRect) frame{
    
    SimpleInfoView *view = [[SimpleInfoView alloc]initWithFrame:frame WithData:obj];
    
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