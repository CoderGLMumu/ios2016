//
//  mechanism.h
//  JZBRelease
//
//  Created by zjapple on 16/10/13.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <Foundation/Foundation.h>

/** "id":"2",
 "uid":"57",
 "name":"建众微课堂",
 "thumb":"0",
 "content":"" */

@interface mechanism : NSObject<NSCoding>

/** "id":"2" */
@property (nonatomic, strong) NSString *id;
/** "uid":"57" */
@property (nonatomic, strong) NSString *uid;
/** "name":"建众微课堂" */
@property (nonatomic, strong) NSString *name;
/** "thumb":"0", */
@property (nonatomic, strong) NSString *thumb;
/** "content":"" */
@property (nonatomic, strong) NSString *content;

@end
