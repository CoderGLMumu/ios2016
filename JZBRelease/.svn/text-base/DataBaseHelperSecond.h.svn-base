//
//  DataBaseHelperSecond.h
//  沟通宝
//
//  Created by zcl on 14-8-7.
//  Copyright (c) 2014年 zcl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "GetValueObject.h"

@interface DataBaseHelperSecond : NSObject

@property (nonatomic,retain) FMDatabase* db;
@property (nonatomic,retain) NSString *path;

+(instancetype) getInstance;

-(void)initDataBaseDB;

-(void) closeDB;

-(BOOL) createTabel : (GetValueObject *) model;

-(BOOL) insertModelToTabel : (GetValueObject *) model;

-(BOOL) alterModelToTabel : (GetValueObject *) model;

-(NSMutableArray *) getModelListFromTabel : (GetValueObject *) model;

-(GetValueObject *) getModelFromTabel : (GetValueObject *) model;

-(BOOL) delteModelFromTabel : (GetValueObject *) model;

-(BOOL) delteTable : (GetValueObject *) model;

-(BOOL) isExistInTable : (GetValueObject *) model;

@end
