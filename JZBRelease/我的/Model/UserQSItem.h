//
//  UserQSItem.h
//  JZBRelease
//
//  Created by zjapple on 16/10/20.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "jsonBaseItem.h"

@interface UserQSItem : jsonBaseItem
/** "contribution":5 */
@property (nonatomic, strong) NSNumber *contribution;

@end
