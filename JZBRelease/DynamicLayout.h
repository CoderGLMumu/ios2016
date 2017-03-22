//
//  DynamicGoodLayout.h
//  JZBRelease
//
//  Created by zjapple on 16/5/12.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "CellLayout.h"
#import "DetailListModel.h"
#import "LWTextParser.h"
#import "LWDefine.h"
#import "Defaults.h"
#import "EvaluateModel.h"
@interface DynamicLayout : CellLayout

//@property (nonatomic,assign) CGRect sendNamePosition;
//@property (nonatomic,assign) CGRect sendContentPosition;
//@property (nonatomic,assign) CGRect commentNamePosition1;
@property (nonatomic,assign) CGRect commentPosition;
//@property (nonatomic,assign) CGRect commentNamePosition2;
//@property (nonatomic,assign) CGRect commentContentPosition2;
@property (nonatomic,assign) CGRect avatarPosition1;
@property (nonatomic, strong) EvaluateModel *evaluateModel;


- (id)initWithContainer:(LWStorageContainer *)container
                  Model:(EvaluateModel *)detailListModel
          dateFormatter:(NSDateFormatter *)dateFormatter
                  index:(NSInteger)index
            WithDynamic:(BOOL) isDynamic;

@end
