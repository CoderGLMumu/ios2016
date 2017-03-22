//
//  ActivityLayout.h
//  JZBRelease
//
//  Created by cl z on 16/8/12.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "CellLayout.h"
#import "CellLayout.h"
#import "ActivityModel.h"
#import "LWTextParser.h"
#import "LWDefine.h"
#import "Defaults.h"
@interface ActivityLayout : CellLayout

@property (nonatomic,assign) CGRect avatarPosition1;
@property (nonatomic,assign) CGRect banaerPosition;
@property (nonatomic, strong) ActivityModel *activityModel;


- (id)initWithContainer:(LWStorageContainer *)container
                  Model:(ActivityModel *)activityModel
          dateFormatter:(NSDateFormatter *)dateFormatter
                  index:(NSInteger)index;

@end
