//
//  SimpleInfoView.h
//  JZBRelease
//
//  Created by zcl on 2016/10/4.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleInfoView : UIView
@property(nonatomic, strong) UIImageView *avatarView;
@property(nonatomic, strong) UIButton *nameBtn;
@property(nonatomic, strong) UILabel *answerFromLabel;
@property(nonatomic, strong) UILabel *companyPositionLabel;
//@property(nonatomic, strong) UILabel *fateLabel;
//@property(nonatomic, strong) UILabel *industryLabel;
//@property(nonatomic, strong) UILabel *gangLabel,*jobPositionLabel;
@property(nonatomic, strong) UIImageView *vipRangeView;
@property(nonatomic, strong) UIImageView *cainaView;
@property(nonatomic, assign) BOOL isCaina;

@property(nonatomic, strong) UIImageView *emergenceView;
@property(nonatomic, assign) BOOL isEmergence;

@property(nonatomic, strong) UIButton *delBtn;

/** botView */
@property (nonatomic, weak) UIView *botView;

@property(nonatomic, copy) void (^returnAction)(NSInteger tag);

+(SimpleInfoView *) getInfoShowViewWithData:(GetValueObject *) obj WithFrame:(CGRect) frame;

-(void) updateFrameWithData:(GetValueObject *) obj;
@end
