//
//  CollectDataBase.h
//  TheAllOfPianoScore
//
//  Created by vk on 14-9-7.
//  Copyright (c) 2014年 vk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DY_searchHistoryDataBase : NSObject


+ (id)shareDataBase;

- (NSMutableArray *)readLocalArray;

- (void)writeLocalWithDataArray:(NSMutableArray *)dataArray;

- (void)deleteLocalDataArray;


@end



