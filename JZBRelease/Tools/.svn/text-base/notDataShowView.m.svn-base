//
//  notDataShowView.m
//  JZBRelease
//
//  Created by Apple on 16/11/1.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "notDataShowView.h"

@interface notDataShowView ()

/** imageV */
@property (nonatomic, weak) UIImageView *imageV;

@end

@implementation notDataShowView

static notDataShowView *_instance;

//类方法，返回一个单例对象
+ (instancetype)sharenotDataShowView:(UITableView *)tableView
{
    //注意：这里建议使用self,而不是直接使用类名Tools（考虑继承）
    notDataShowView *view = [[self alloc]init];
    view.center = CGPointMake(tableView.center.x, tableView.center.y - 64);
    return view;
}

//类方法，返回一个单例对象
+ (instancetype)sharenotDataShowView
{
    //注意：这里建议使用self,而不是直接使用类名Tools（考虑继承）
    return [[self alloc]init];;
}

//保证永远只分配一次存储空间
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    //    使用GCD中的一次性代码
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    
    //使用加锁的方式，保证只分配一次存储空间
    //    @synchronized(self) {
    //        if (_instance == nil) {
    //            _instance = [super allocWithZone:zone];
    //        }
    //    }
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //    使用GCD中的一次性代码
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self setSubView];
        });
        
        
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)setSubView
{
    
    self.frame = CGRectMake(0, 0, GLScreenW, 200);
    
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"could"]];
    [self addSubview:imageV];

    self.imageV = imageV;
//    imageV.frame = CGRectMake(0, 0, self.glw_width, self.glh_height);
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageV.glcx_centerX = self.glw_width * 0.5;
    self.imageV.glcy_centerY = self.glh_height * 0.5;
    
}

@end
