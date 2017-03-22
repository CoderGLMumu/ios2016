//
//  FilterLayout.h
//  JZBRelease
//
//  Created by zjapple on 16/5/6.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "LWLayout.h"
#import "FilterModel.h"


@interface FilterLayout : LWLayout


@property (nonatomic,assign) CGFloat cellHeight;
- (id)initWithContainer:(LWStorageContainer *)container
            Model:(FilterModel *)statusModel
                  index:(NSInteger)index;

@end
