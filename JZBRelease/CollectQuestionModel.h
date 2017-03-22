//
//  CollectQuestionModel.h
//  JZBRelease
//
//  Created by zcl on 2016/10/6.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "GetValueObject.h"

@interface CollectQuestionModel : GetValueObject
@property(nonatomic,copy) NSString *access_token;
@property(nonatomic,copy) NSString *question_id;
@end
