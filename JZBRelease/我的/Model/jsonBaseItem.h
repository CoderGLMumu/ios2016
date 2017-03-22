//
//  jsonBaseItem.h
//  JZBRelease
//
//  Created by zjapple on 16/10/20.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface jsonBaseItem : NSObject

/** state */
@property (nonatomic, strong) NSNumber *state;
/** info */
@property (nonatomic, strong) NSString *info;
/** data */
@property (nonatomic, strong) NSArray *data;




//"state":1,
//"info":"签到成功",
//"data":[
//
//],

@end
