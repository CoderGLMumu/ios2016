//
//  CusNinePicView.h
//  JZBRelease
//
//  Created by zjapple on 16/6/22.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CusNinePicView : UIView


+(CusNinePicView *) getCusNinePicViewWithData:(NSArray *) ary WithSigleHeight:(NSInteger) height WithInteval:(NSInteger) inteval WithDefaultPic:(NSString *) picName OrignY:(NSInteger) offY;

@end
