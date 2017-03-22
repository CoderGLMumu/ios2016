//
//  CollectDataBase.m
//  TheAllOfPianoScore
//
//  Created by vk on 14-9-7.
//  Copyright (c) 2014年 vk. All rights reserved.
//

#import "DY_searchHistoryDataBase.h"
@implementation DY_searchHistoryDataBase


+(id)shareDataBase{
    
  static  DY_searchHistoryDataBase *collectDataBase;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        collectDataBase = [[DY_searchHistoryDataBase alloc]init];
    });
    
    return collectDataBase;
    
}



-(NSMutableArray *)readLocalArray{
    
    
    NSString *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *dataPath = [filePath stringByAppendingString:@"/history.plist"];

    //判断是否存在这个文件
    if (![[NSFileManager defaultManager]fileExistsAtPath:dataPath]) {
        
        NSMutableArray *array = [NSMutableArray array];
        
        
        [array writeToFile:dataPath atomically:YES];
        
        return array;
        
    }else{
        
        NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:dataPath];
        if (array==nil) {
            array=[[NSMutableArray alloc]init];
        }
        return array;
    }

}

- (void)writeLocalWithDataArray:(NSMutableArray *)dataArray{
    
    NSString *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *dataPath = [filePath stringByAppendingString:@"/history.plist"];
    
    [dataArray writeToFile:dataPath atomically:YES];
    
}

- (void)deleteLocalDataArray{
    
    NSString *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *dataPath = [filePath stringByAppendingString:@"/history.plist"];
    
    NSMutableArray *localArray  = [NSMutableArray arrayWithContentsOfFile:dataPath];
    
    [localArray removeAllObjects];
}




@end
