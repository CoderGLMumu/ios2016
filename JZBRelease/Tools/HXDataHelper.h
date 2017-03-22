//
//  HXDataHelper.h
//  JZBRelease
//
//  Created by zjapple on 16/8/6.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXDataHelper : NSObject

- (void)loadHXDataWithComplete:(void(^)())complete;

- (NSString *)changeUidWithHXid:(NSString *)hxid;

@end
