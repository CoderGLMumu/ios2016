//
//  DataBaseHelperSecond.m
//  沟通宝
//
//  Created by zcl on 14-8-7.
//  Copyright (c) 2014年 zcl. All rights reserved.
//

#import "DataBaseHelperSecond.h"
#import "LoginVM.h"
#import <objc/runtime.h>
#import "Users.h"
#import "LocalDataRW.h"
@implementation DataBaseHelperSecond
@synthesize path,db;

+(instancetype) getInstance{
    static DataBaseHelperSecond *dataHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (dataHelper == nil) {
            dataHelper = [[DataBaseHelperSecond alloc]init];
        }
    });
    return dataHelper;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initDataBaseDB];
    }
    return self;
}

-(void)initDataBaseDB{
    path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:[[LoginVM getInstance]readLocal].account];
    [LocalDataRW makeDir:path];
    NSLog(@"%@",path);
    NSString *dbString = [path stringByAppendingPathComponent:@"localZJB.db"];
    db = [FMDatabase databaseWithPath:dbString];
}

-(BOOL) createTabel : (GetValueObject *) model{
    if (![db open]) {
        return NO;
    }
    NSMutableArray *propertiesAry = [self getProperties:[model class]];
    NSMutableString *sqlCreateTable = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@",NSStringFromClass([model class])];
    for (int i = 0; i < propertiesAry.count; i ++) {
        if (0 == i) {
            [sqlCreateTable appendString:[NSString stringWithFormat:@"(%@ text,",[propertiesAry objectAtIndex:i]]];
        }else if (propertiesAry.count - 1 == i){
            [sqlCreateTable appendString:[NSString stringWithFormat:@"%@ text)",[propertiesAry objectAtIndex:i]]];
        }else{
            [sqlCreateTable appendString:[NSString stringWithFormat:@"%@ text,",[propertiesAry objectAtIndex:i]]];
        }
        
    }
    [self delteTable:model];
    BOOL res = [db executeUpdate:sqlCreateTable];
    [db close];
    return res;
}

-(BOOL) insertModelToTabel : (GetValueObject *) model{
    if (![db open]) {
        return NO;
    }
    NSMutableArray *propertiesAry = [self getProperties:[model class]];
    NSMutableString *sqlInsert = [NSMutableString stringWithFormat:@"insert into %@" ,NSStringFromClass([model class])];
    NSMutableString *valuesSql = [NSMutableString stringWithFormat:@" values("];
    for (int i = 0; i < propertiesAry.count; i ++) {
        if (0 == i) {
            [sqlInsert appendString:[NSString stringWithFormat:@" (%@,",[propertiesAry objectAtIndex:i]]];
            [valuesSql appendString:@"?,"];
        }else if (propertiesAry.count - 1 == i){
            [sqlInsert appendString:[NSString stringWithFormat:@"%@)",[propertiesAry objectAtIndex:i]]];
            [valuesSql appendString:@"?)"];
        }else{
            [sqlInsert appendString:[NSString stringWithFormat:@"%@,",[propertiesAry objectAtIndex:i]]];
            [valuesSql appendString:@"?,"];
        }
    }
    [sqlInsert appendString:valuesSql];
    NSMutableArray *valueAry = [[NSMutableArray alloc]init];
    for (int i = 0; i < propertiesAry.count; i ++) {
        NSString *value = [model getValueWithPropertyName:[propertiesAry objectAtIndex:i]];
        if (![value isKindOfClass:[NSString class]] || !(value.length > 0)) {
            value = @"nil";
        }
        [valueAry  addObject:value];
    }
    BOOL res = [db executeUpdate:sqlInsert withArgumentsInArray:valueAry];
    [db close];
    return res;
}

-(BOOL) alterModelToTabel : (GetValueObject *) model{
    if (![db open]) {
        return NO;
    }
    NSMutableArray *propertiesAry = [self getProperties:[model class]];
    NSMutableString *sqlAlter = [NSMutableString stringWithFormat:@"UPDATE %@ ",NSStringFromClass([model class])];
    for (int i = 0; i < propertiesAry.count; i ++) {
        if (0 == i) {
            [sqlAlter appendString:[NSString stringWithFormat:@"SET %@ = %@ ",[propertiesAry objectAtIndex:i],[model getValueWithPropertyName:[propertiesAry objectAtIndex:i]]]];
        }else if (propertiesAry.count - 1 == i){
            [sqlAlter appendString:[NSString stringWithFormat:@"%@ = %@ ",[propertiesAry objectAtIndex:i],[model getValueWithPropertyName:[propertiesAry objectAtIndex:i]]]];
        }else{
            [sqlAlter appendString:[NSString stringWithFormat:@"%@ = %@ ",[propertiesAry objectAtIndex:i],[model getValueWithPropertyName:[propertiesAry objectAtIndex:i]]]];
        }
    }
//    NSMutableArray *valueAry = [[NSMutableArray alloc]init];
//    for (int i = 0; i < propertiesAry.count; i ++) {
//        NSString *value = [model getValueWithPropertyName:[propertiesAry objectAtIndex:i]];
//        if (![value isKindOfClass:[NSString class]] || !(value.length > 0)) {
//            value = @"nil";
//        }
//        [valueAry  addObject:value];
//    }
    [sqlAlter appendString:[NSString stringWithFormat:@"where %@=%@",[propertiesAry objectAtIndex:0],[model getValueWithPropertyName:[propertiesAry objectAtIndex:0]]]];
    BOOL res = [db executeUpdate:sqlAlter];
    [db close];
    return res;
}

-(NSMutableArray *) getModelListFromTabel : (GetValueObject *) model{
    NSMutableArray *ary = [[NSMutableArray alloc]init];
    if (![db open]) {
        return nil;
    }
    NSMutableArray *propertiesAry = [self getProperties:[model class]];
    NSMutableString *sqlSelect = [NSMutableString stringWithFormat:@"select * from %@" ,NSStringFromClass([model class])];
     FMResultSet *rs = [db executeQuery:sqlSelect];
    while ([rs next]) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        for (int i = 0; i < propertiesAry.count; i ++) {
            [dict setObject:[rs stringForColumn:[propertiesAry objectAtIndex:i]] forKey:[propertiesAry objectAtIndex:i]];
        }
        GetValueObject *dataModel = [[model class] mj_objectWithKeyValues:dict];
        if (dataModel) {
            [ary addObject:dataModel];
        }
    }
    [db close];
    return ary;
}

-(GetValueObject *) getModelFromTabel : (GetValueObject *) model{
    if (![db open]) {
        return nil;
    }
    NSMutableArray *propertiesAry = [self getProperties:[model class]];
    NSMutableString *sqlSelect = [NSMutableString stringWithFormat:@"select * from %@ where %@='%@'" ,NSStringFromClass([model class]),[propertiesAry objectAtIndex:0],[model getValueWithPropertyName:[propertiesAry objectAtIndex:0]]];
    NSLog(@"%@",[model getValueWithPropertyName:[propertiesAry objectAtIndex:0]]);
    FMResultSet *rs = [db executeQuery:sqlSelect];
    
    while ([rs next]) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        for (int i = 0; i < propertiesAry.count; i ++) {
            [dict setObject:[rs stringForColumn:[propertiesAry objectAtIndex:i]] forKey:[propertiesAry objectAtIndex:i]];
        }
        model = [[model class] mj_objectWithKeyValues:dict];
    }
    [db close];
    return model;
}

-(BOOL) delteModelFromTabel : (GetValueObject *) model{
    BOOL isSuccess;
    if (![db open]) {
        return nil;
    }
    NSMutableArray *propertiesAry = [self getProperties:[model class]];
    NSMutableString *deleteSql = [NSMutableString stringWithFormat:@"delete from %@ where %@='%@'" ,NSStringFromClass([model class]),[propertiesAry objectAtIndex:0],[model getValueWithPropertyName:[propertiesAry objectAtIndex:0]]];
    isSuccess = [db executeUpdate:deleteSql];
    return isSuccess;
}

-(BOOL) delteTable : (GetValueObject *) model{
    if (![db open]) {
        return NO;
    }
    BOOL isSuccess;
    NSString *sqlstr = [NSString stringWithFormat:@"DROP TABLE %@", NSStringFromClass([model class])];
    isSuccess = [db executeUpdate:sqlstr];
    return isSuccess;
}

-(BOOL) isExistInTable : (GetValueObject *) model{
    BOOL isExist = NO;
    if (![db open]) {
        return NO;
    }
    NSMutableArray *propertiesAry = [self getProperties:[model class]];
    NSString *values = [model getValueWithPropertyName:[propertiesAry objectAtIndex:0]];
    NSMutableString *sqlSelect = [NSMutableString stringWithFormat:@"select * from %@ where %@='%@'" ,NSStringFromClass([model class]),[propertiesAry objectAtIndex:0],values];
    FMResultSet *rs = [db executeQuery:sqlSelect];
    while ([rs next]) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        for (int i = 0; i < propertiesAry.count; i ++) {
            [dict setObject:[rs stringForColumn:[propertiesAry objectAtIndex:i]] forKey:[propertiesAry objectAtIndex:i]];
        }
        GetValueObject *queryModel = [[model class] mj_objectWithKeyValues:dict];
        if (queryModel) {
            isExist = YES;
        }
    }
    return isExist;
}

-(NSMutableArray *)getProperties:(Class)cls{
    // 获取当前类的所有属性
    unsigned int count;// 记录属性个数
    objc_property_t *properties = class_copyPropertyList(cls, &count);
    // 遍历
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        
        // An opaque type that represents an Objective-C declared property.
        // objc_property_t 属性类型
        objc_property_t property = properties[i];
        // 获取属性的名称 C语言字符串
        const char *cName = property_getName(property);
        // 转换为Objective C 字符串
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        [mArray addObject:name];
    }
    return mArray.copy;
}


-(void) closeDB{
    if (db && [db open]) {
        [db close];
    }
}

@end
