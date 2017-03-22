//
//  WDBDetailItem.h
//  MyBang
//
//  Created by mac on 16/10/4.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDBDetailItem : NSObject


/** 图片地址 , */
@property (nonatomic, strong) NSString *thumb;
/** "id":"1", */
@property (nonatomic, strong) NSString *id;
/** "name":"大商论剑帮 ", */
@property (nonatomic, strong) NSString *name;
/** "mcount":"1", */
@property (nonatomic, strong) NSString *mcount;
/** "like_count":"1", */
@property (nonatomic, strong) NSString *like_count;
/** "content":"" 简介 */
@property (nonatomic, strong) NSString *content;
/**
 
 "member":[
 Object{...}
 ],
 
 */
@property (nonatomic, strong) NSArray *member;
/** "is_join":0  */
@property (nonatomic, strong) NSNumber *is_join;
/** "is_like":0 */
@property (nonatomic, strong) NSNumber *is_like;


@end
