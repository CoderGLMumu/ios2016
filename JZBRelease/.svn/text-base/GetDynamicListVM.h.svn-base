//
//  GetDynamicList.h
//  JZBRelease
//
//  Created by zjapple on 16/5/31.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "GetValueObject.h"
#import "GetDynamicListModel.h"
@interface GetDynamicListVM : GetValueObject

-(void) getDynamicListFromNet : (GetDynamicListModel *) getDynamicListModel;

-(NSMutableArray *) getDynamicListFromLocal;

@property (nonatomic,strong) void (^ returnDataAry)(NSMutableArray *ary);

@end
