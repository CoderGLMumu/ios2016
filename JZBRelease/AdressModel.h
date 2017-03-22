//
//  AdressModel.h
//  JZBRelease
//
//  Created by cl z on 16/8/20.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "GetValueObject.h"

@interface AdressModel : GetValueObject

@property(nonatomic,copy) NSString *province;
@property(nonatomic,copy) NSString *city;


@end
