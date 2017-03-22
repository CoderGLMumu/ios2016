//
//  LocalDataRW.h
//  JZBRelease
//
//  Created by zjapple on 16/5/9.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,Directory_Type){
    Directory_BB = 0,
    Directory_RM = 1,
    Directory_BQ = 2,
    Directory_XB = 3,
    Directory_ZX = 4,
    Directory_WD = 5,
};

@interface LocalDataRW : NSObject

+(BOOL) writeDataToLocaOfDocument : (NSArray *) ary AtFileName : (NSString *) fileName;

+(NSMutableArray *) readDataFromLocalOfDocument : (NSString *) atFileName;

+(BOOL) writeDataToLocaOfDocument : (NSArray *) ary WithDirectory_Type : (Directory_Type) type AtFileName : (NSString *) fileName;

+(NSMutableArray *) readDataFromLocalOfDocument : (NSString *) atFileName WithDirectory_Type : (Directory_Type) type;

+(BOOL) writeDictToLocaOfDocument : (NSDictionary *) dict WithDirectory_Type : (Directory_Type) type AtFileName : (NSString *) fileName;

+(NSDictionary *) readDictFromLocalOfDocument : (NSString *) atFileName WithDirectory_Type : (Directory_Type) type;

+(NSString *) makeDir : (NSString *) directoryPath;

//获取本地模块路径
+(NSString *) getDirectory : (Directory_Type) type;
//获取图片
+(UIImage *) getImageWithDirectory : (Directory_Type) type RetalivePath : (NSString *) path;

//imageview load图片
+ (void) getImageWithDirectory : (Directory_Type) type RetalivePath : (NSString *) path WithContainerImageView:(UIImageView *) imageView;

/** imageview load图片地址 */
+ (NSString *) getImageAllStr : (NSString *) path;

+(BOOL) writeImageWithDirectory : (Directory_Type) type RetalivePath : (NSString *) path WithImageData : (NSData *) data;

//动态数存取
+(void)addCountWithType:(NSString *) type;

+(void)reduceCountWithType:(NSString *) type;

+(NSNumber *)returnCountWithType:(NSString *) type;

+(void)clearToZeroWithType:(NSString *) type;



//获取以字符串结尾的所有文件
+ (NSArray *)getAllFilesNameWithDirectory:(Directory_Type) directory_type WithRelativeDir:(NSString *)dirName WithSuffix:(NSString *) suffix;

/**
 计算数组中所有文件大小总和，大小为k

 @param filesArray 文件数组
 @return 大小
 */
+ (NSString *)calculateFilesSize:(NSArray *)filesArray;


/**
 移除某个文件从本地

 @param path 文件路径
 */
+ (void)removeFileFromLocalWithPath:(NSString *)path;



@end
