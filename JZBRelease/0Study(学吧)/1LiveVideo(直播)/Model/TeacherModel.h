//
//  TeacherModel.h
//  JZBRelease
//
//  Created by cl z on 16/10/13.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "GetValueObject.h"

@interface TeacherModel : GetValueObject
@property(nonatomic,copy)NSString *title;

@property(nonatomic,strong)NSArray *teacher_list;

@property(nonatomic,copy)NSString *tag;
@end
