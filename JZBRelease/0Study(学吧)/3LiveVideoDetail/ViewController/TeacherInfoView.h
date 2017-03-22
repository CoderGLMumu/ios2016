//
//  TeacherInfoView.h
//  JZBRelease
//
//  Created by zjapple on 16/10/13.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeacherInfoView : UIControl

+ (instancetype)TeacherInfoView;

/** teacherInfo */
@property (nonatomic, strong) Users *teacherInfo;

@end
