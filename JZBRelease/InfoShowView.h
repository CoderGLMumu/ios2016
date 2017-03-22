//
//  InfoShowView.h
//  JZBRelease
//
//  Created by zjapple on 16/6/22.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicInfoInitView.h"
#import "ActivityModel.h"
#import "GetValueObject.h"
@interface InfoShowView : BasicInfoInitView

@property(nonatomic, strong) UIImageView *avatarView;
@property(nonatomic, strong) UIButton *nameBtn;
@property(nonatomic, strong) UILabel *companyPositionLabel;
@property(nonatomic, strong) UILabel *fateLabel;
@property(nonatomic, strong) UILabel *industryLabel;
@property(nonatomic, strong) UILabel *gangLabel,*jobPositionLabel;
@property(nonatomic, strong) UIImageView *vipRangeView;
@property(nonatomic, strong) UIImageView *cainaView;
@property(nonatomic, assign) BOOL isCaina;
@property(nonatomic, assign) BOOL intevalViewHidden;
/** botView */
@property (nonatomic, weak) UIView *botView;

@property(nonatomic, copy) void (^returnAction)(NSInteger tag);

+(InfoShowView *) getInfoShowViewWithData:(GetValueObject *) obj WithFrame:(CGRect) frame;

-(void) updateFrameWithData:(GetValueObject *) obj;

@end
