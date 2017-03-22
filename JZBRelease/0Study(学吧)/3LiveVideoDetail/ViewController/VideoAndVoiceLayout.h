//
//  VideoAndVoiceLayout.h
//  JZBRelease
//
//  Created by cl z on 16/10/31.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "CellLayout.h"
#import "DealNormalUtil.h"
#import "LWConstraintManager.h"
#import "CourseTimeEvaluateModel.h"
@interface VideoAndVoiceLayout : CellLayout
@property (nonatomic,assign) CGRect avatarPosition1;
@property (nonatomic, strong) CourseTimeEvaluateModel *courseTimeEvaluateModel;


- (id)initWithContainer:(LWStorageContainer *)container
                  Model:(CourseTimeEvaluateModel *)courseTimeEvaluateModel
          dateFormatter:(NSDateFormatter *)dateFormatter
                  index:(NSInteger)index
               IsDetail:(BOOL)isDetail;
@end
