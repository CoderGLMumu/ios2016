//
//  SendNineImageView.h
//  JZBRelease
//
//  Created by zjapple on 16/5/19.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendNineImageView : UIView

@property(nonatomic, strong) NSMutableArray *imageAry;

@property(nonatomic, strong) NSMutableArray *viewsAry;

@property(nonatomic, strong) UIImageView *addImageView;

-(void) initViews : (NSInteger) width Inteval : (NSInteger) inteval;

-(void) addSingleView : (NSInteger) width Inteval : (NSInteger) inteval;

-(void) removeSomeViews : (NSArray *) whichs;

-(void) removeAllViews;

@property (nonatomic, copy) void (^clickAction)(NSInteger tag);

@end
