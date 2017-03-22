//
//  UIImageView+CacheImage.h
//  ZJHTCarOwner
//
//  Created by Jelly Foo on 15/8/21.
//  Copyright (c) 2015年 &#27721;&#23376;&#31185;&#25216;. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (CacheImage)

- (void)cacheImageWithImageUrl:(NSURL *)url PlaceholderImage:(UIImage *)placeholder CacheIdentifier:(NSString *)oneIdentifier ;

@end
