//
//  online_userItem.h
//  JZBRelease
//
//  Created by zjapple on 16/9/26.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface online_userItem : NSObject

/** class_id 69 */
@property (nonatomic, strong) NSString *class_id;
/** uid 38 */
@property (nonatomic, strong) NSString *uid;
/** 1474883140 */
@property (nonatomic, strong) NSString *create_time;
/** userinfo */
@property (nonatomic, strong) Users *user;

//"class_id":"69",
//"uid":"38",
//"create_time":"1474883140",
//"user":Object{...}

@end
