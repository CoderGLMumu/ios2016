//
//  DealNormalUtil.m
//  JZBRelease
//
//  Created by zjapple on 16/6/2.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "DealNormalUtil.h"

@implementation DealNormalUtil

+(instancetype) getInstance{
    static DealNormalUtil *dealNormal;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (dealNormal == nil) {
            dealNormal = [[DealNormalUtil alloc]init];
        }
    });
    return dealNormal;
}

-(UIImage *) getImageBasedOnName : (NSString *) name{
    return nil;
    if (!name) {
        return nil;
    }
    UIImage *image;
    if (self.imagesDict) {
        image = [self.imagesDict objectForKey:name];
        if (image) {
            return image;
        }
    }else{
        self.imagesDict = [[NSMutableDictionary alloc]init];
    }
    if ([name isEqualToString:@"一级"]) {
        image = [UIImage imageNamed:@"bq_dtxq_v1"];
    }else if ([name isEqualToString:@"二级"]){
        image = [UIImage imageNamed:@"bq_dtxq_v2"];
    }else if ([name isEqualToString:@"三级"]){
        image = [UIImage imageNamed:@"bq_dtxq_v3"];
    }else if ([name isEqualToString:@"四级"]){
        image = [UIImage imageNamed:@"bq_dtxq_v4"];
    }else if ([name isEqualToString:@"五级"]){
        image = [UIImage imageNamed:@"bq_dtxq_v5"];
    }else if ([name isEqualToString:@"六级"]){
        image = [UIImage imageNamed:@"bq_dtxq_v6"];
    }else if ([name isEqualToString:@"七级"]){
        image = [UIImage imageNamed:@"bq_dtxq_v7"];
    }else if ([name isEqualToString:@"八级"]){
        image = [UIImage imageNamed:@"bq_dtxq_v8"];
    }else{
        image = [UIImage imageNamed:@"bq_dtxq_v9"];
    }
    [self.imagesDict setObject:image forKey:name];
    return image;
}

- (UIImage*)clipImageWithImage:(UIImage*)image inRect:(CGRect)rect {
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    
    UIGraphicsBeginImageContext(image.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextDrawImage(context, rect, imageRef);
    
    UIImage* clipImage = [UIImage imageWithCGImage:imageRef];
    
    //    CGImageCreateWithImageInRect(CGImageRef  _Nullable image, <#CGRect rect#>)
    
    //    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();      // 不同的方式
    
    UIGraphicsEndImageContext();
    
    //    NSData* data = [NSData dataWithData:UIImagePNGRepresentation(clipImage)];
    
    //    BOOL flag = [data writeToFile:@"/Users/gua/Desktop/Image/后.png" atomically:YES];
    
    //    GGLogDebug(@"========压缩后=======%@",clipImage);
    
    return clipImage;
    
}

@end
