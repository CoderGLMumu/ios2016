//
//  MesageCellModel.h
//  JZBRelease
//
//  Created by zjapple on 16/6/30.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "GetValueObject.h"

@interface MesageCellModel : GetValueObject

@property(nonatomic,strong) NSString *avatar;
@property(nonatomic,strong) NSString *nickname;
@property(nonatomic,strong) NSString *create_time;
@property(nonatomic,strong) NSString *message_content;
@property(nonatomic,strong) NSString *dynamic_id;
@property(nonatomic,strong) NSString *count;
@property(nonatomic,strong) NSString *type;
@end
