//
//  CourseTimeVC.h
//  JZBRelease
//
//  Created by cl z on 16/9/13.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseTimeVC : UIViewController

@property (nonatomic, strong) NSString *course_id;
@property(nonatomic, copy) void (^returnAction)();
@end
