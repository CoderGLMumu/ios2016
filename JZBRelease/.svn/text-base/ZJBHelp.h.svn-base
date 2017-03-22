//
//  ZJBHelp.h
//  JZBRelease
//
//  Created by zjapple on 16/4/29.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BQRootVC.h"
#import "BBRootVC.h"
#import "HomeTabBarVC.h"
#import "StudyBaRootVC.h"
@interface ZJBHelp : NSObject

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) BQRootVC *bqRootVC;
@property (nonatomic, strong) StudyBaRootVC *studyBaRootVC;
@property (nonatomic, strong) BBRootVC *bbRootVC;
@property (nonatomic, strong) HomeTabBarVC *homeTabBarVC;
@property (nonatomic, assign) BOOL fromStudy;
+(instancetype) getInstance;

-(void) configNav:(UIViewController *) vc
         WithLOrR:(NSString *) direct
        ImageName:(NSString*)imageName
           Action:(SEL)action;

- (UIImage *)buttonImageFromColor : (UIColor *) color WithFrame : (CGRect) rect;

- (NSData *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize ScaledToSize : (CGSize) newSize;

+ (UIImage *)handleImage:(UIImage *)originalImage withSize:(CGSize)size withFromStudy:(BOOL)fromStudy;
@end
