//
//  ZJBHelp.m
//  JZBRelease
//
//  Created by zjapple on 16/4/29.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "ZJBHelp.h"
#import "Defaults.h"
#import "AFHTTPRequestOperationManager.h"
@implementation ZJBHelp
static ZJBHelp *zjbInstance = nil;
+(instancetype)getInstance{
    static dispatch_once_t predict;
    dispatch_once(&predict, ^{
        zjbInstance = [[ZJBHelp alloc]init];
    });
    return zjbInstance;
}

-(void) configNav:(UIViewController *) vc
         WithLOrR:(NSString *) direct
        ImageName:(NSString*)imageName
           Action:(SEL)action{
    UIButton *btn = [UIButton createButtonWithFrame:CGRectMake(0,0,20,20) ImageName:imageName Target:vc Action:action Title:nil cornerRadius:0 borderColor:nil borderWidth:0];
    UIBarButtonItem *messageItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    if ([direct isEqualToString:LEFT]) {
        vc.navigationItem.leftBarButtonItem = messageItem;
    }else {
        vc.navigationItem.rightBarButtonItem = messageItem;
    }
}

-(void)uploadPictures:(NSArray *)_imageArray{
    
    //域名
    NSString *domainStr = @"http://192.168.1.69/xffcol/index.php/Api/";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //如果还需要上传其他的参数，参考上面的POST请求，创建一个可变字典，存入需要提交的参数内容，作为parameters的参数提交
    [manager POST:domainStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         //_imageArray就是图片数组，我的_imageArray里面存的都是图片的data，下面可以直接取出来使用，如果存的是image，将image转换data的方法如下：NSData *imageData = UIImageJPEGRepresentation(image, 0.7);
         if (_imageArray.count > 0 ){
             for(int i = 0;i < _imageArray.count;i ++){
                 NSData *data=_imageArray[i];
                 //上传的参数名
                 NSString *name = [NSString stringWithFormat:@"%d",i];
                 //上传的filename
                 NSString *fileName = [NSString stringWithFormat:@"%@.jpg",name];
                 [formData appendPartWithFileData:data
                                             name:name
                                         fileName:fileName
                                         mimeType:@"image/jpeg"];
             }
         }
         
     }success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //关闭系统风火轮
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         
         //json解析
         NSDictionary * resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
         NSLog(@"---resultDic--%@",resultDic);
         
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              // 解析失败
              [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
          }];
}


- (UIImage *)buttonImageFromColor : (UIColor *) color WithFrame : (CGRect) rect{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (NSData *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize ScaledToSize : (CGSize) newSize {
    CGFloat compression = 0.8f;
    CGFloat maxCompression = 0.2f;
    NSData *imageData = [self imageWithImage:image scaledToSize:newSize];
    
    while ([imageData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    NSLog(@"imageSize is %ld",imageData.length);
    return imageData;
}

- (NSData *)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0.7);
}

+ (UIImage *)handleImage:(UIImage *)originalImage withSize:(CGSize)size withFromStudy:(BOOL)fromStudy;
{
    CGSize originalsize = [originalImage size];
    NSLog(@"改变前图片的宽度为%f,图片的高度为%f",originalsize.width,originalsize.height);
    
    if (fromStudy) {
        CGImageRef imageRef = nil;
        float rate1 = originalsize.width / (float)originalsize.height;
        float rate2 = size.width / (float)size.height;
        if (rate1 > 1) {
            
        }
        if (rate1 > rate2) {
            int width = originalsize.width / rate1 * rate2;
            //if (width > originalsize.width) {
                
           // }else{
                imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake((originalsize.width - width) / 2, 0, width, originalsize.height));//获取图片整体部分
                size = CGSizeMake(width, originalsize.height);
                
            //}
        }else{
            int height = originalsize.height / rate2 * rate1;
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(0, (originalsize.height - height) / 2, originalsize.width, height));//获取图片整体部分
            size = CGSizeMake(originalsize.width, height);
        }
        UIGraphicsBeginImageContext(size);//指定要绘画图片的大小
        CGContextRef con = UIGraphicsGetCurrentContext();
        
        CGContextTranslateCTM(con, 0.0, size.height);
        CGContextScaleCTM(con, 1.0, -1.0);
        
        CGContextDrawImage(con, CGRectMake(0, 0, size.width, size.height), imageRef);
        
        UIImage *standardImage = UIGraphicsGetImageFromCurrentImageContext();
        NSLog(@"改变后图片的宽度为%f,图片的高度为%f",[standardImage size].width,[standardImage size].height);
        
        UIGraphicsEndImageContext();
        CGImageRelease(imageRef);
        
        return standardImage;

    }
    
    //原图长宽均小于标准长宽的，不作处理返回原图
    if (originalsize.width<size.width && originalsize.height<size.height)
    {
        return originalImage;
    }
    
    //原图长宽均大于标准长宽的，按比例缩小至最大适应值
    else if(originalsize.width>size.width && originalsize.height>size.height)
    {
        CGFloat rate = 1.0;
        CGFloat widthRate = originalsize.width/size.width;
        CGFloat heightRate = originalsize.height/size.height;
        
        rate = widthRate>heightRate?heightRate:widthRate;
        
        CGImageRef imageRef = nil;
        
        if (heightRate>widthRate)
        {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(0, originalsize.height/2-size.height*rate/2, originalsize.width, size.height*rate));//获取图片整体部分
            size = CGSizeMake(originalsize.width, size.height*rate);
        }
        else
        {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(originalsize.width/2-size.width*rate/2, 0, size.width*rate, originalsize.height));//获取图片整体部分
            size = CGSizeMake(size.width*rate, originalsize.height);
            
        }
        
        UIGraphicsBeginImageContext(size);//指定要绘画图片的大小
        CGContextRef con = UIGraphicsGetCurrentContext();
        
        CGContextTranslateCTM(con, 0.0, size.height);
        CGContextScaleCTM(con, 1.0, -1.0);
        
        CGContextDrawImage(con, CGRectMake(0, 0, size.width, size.height), imageRef);
        
        UIImage *standardImage = UIGraphicsGetImageFromCurrentImageContext();
        NSLog(@"改变后图片的宽度为%f,图片的高度为%f",[standardImage size].width,[standardImage size].height);
        
        UIGraphicsEndImageContext();
        CGImageRelease(imageRef);
        
        return standardImage;
    }
    
    //原图长宽有一项大于标准长宽的，对大于标准的那一项进行裁剪，另一项保持不变
    else if(originalsize.height>size.height || originalsize.width>size.width)
    {
        CGImageRef imageRef = nil;
        
        if(originalsize.height>size.height)
        {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(0, originalsize.height/2-size.height/2, originalsize.width, size.height));//获取图片整体部分
        }
        else if (originalsize.width>size.width)
        {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(originalsize.width/2-size.width/2, 0, size.width, originalsize.height));//获取图片整体部分
        }
        
        UIGraphicsBeginImageContext(size);//指定要绘画图片的大小
        CGContextRef con = UIGraphicsGetCurrentContext();
        
        CGContextTranslateCTM(con, 0.0, size.height);
        CGContextScaleCTM(con, 1.0, -1.0);
        
        CGContextDrawImage(con, CGRectMake(0, 0, size.width, size.height), imageRef);
        
        UIImage *standardImage = UIGraphicsGetImageFromCurrentImageContext();
        NSLog(@"改变后图片的宽度为%f,图片的高度为%f",[standardImage size].width,[standardImage size].height);
        
        UIGraphicsEndImageContext();
        CGImageRelease(imageRef);
        
        return standardImage;
    }
    
    //原图为标准长宽的，不做处理
    else
    {
        return originalImage;
    }
}


@end
