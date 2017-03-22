//
//  UIImageView+CacheImage.m
//  ZJHTCarOwner
//
//  Created by Jelly Foo on 15/8/21.
//  Copyright (c) 2015年 &#27721;&#23376;&#31185;&#25216;. All rights reserved.
//

#import "UIImageView+CacheImage.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"

@implementation UIImageView (CacheImage)

- (void)cacheImageWithImageUrl:(NSURL *)url PlaceholderImage:(UIImage *)placeholder CacheIdentifier:(NSString *)cacheIdentifier {
    __block BOOL isUpdate = NO;
    __block UIImage *cacheImage = nil;
    [[SDImageCache sharedImageCache] queryDiskCacheForKey:cacheIdentifier done:^(UIImage *image, SDImageCacheType cacheType) {
        if (image) {
            cacheImage = image;
            self.image = cacheImage;
        }
    }];
    
    __weak typeof(self) weakSelf = self;
    if (url) { // URl存在就缓存
        [[SDWebImageManager sharedManager] downloadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.image = image;
            isUpdate = YES;
            [[SDImageCache sharedImageCache] storeImage:image forKey:cacheIdentifier];
        }];
    }
    
    if (placeholder && !cacheImage) { // 有placeholder且缓存图片不存在
        cacheImage = placeholder;
    }
    
    if (isUpdate == NO) {
        self.image = cacheImage;
    }
}

@end
