//
//  WDBmember.h
//  JZBRelease
//
//  Created by cl z on 16/10/8.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDBmember : NSObject

/** "uid":"47", */
@property (nonatomic, strong) NSString *uid;
/** "user":Object{...} */
@property (nonatomic, strong) Users *user;

@end
