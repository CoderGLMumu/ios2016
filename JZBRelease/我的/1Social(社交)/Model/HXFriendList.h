//
//  GLFriendList.h
//  huanxinFullDemo
//
//  Created by zjapple on 16/7/21.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <Foundation/Foundation.h>

//"uid":"18",
//"nickname":"w123456",
//"avatar":"",
//"mobile":"",
//"company":"",
//"job":"",
//"max_score":"30",
//"level":"零级"

//@property (nonatomic,strong) NSString *uid;
//@property (nonatomic,strong) NSString *nickname;
//@property (nonatomic,strong) NSString *avatar;
//@property (nonatomic,strong) NSString *mobile;
//@property (nonatomic,strong) NSString *company;
//@property (nonatomic,strong) NSString *job;
//@property (nonatomic,strong) NSString *max_score;
//@property (nonatomic,strong) NSString *level;

@interface HXFriendList : NSObject

@property (nonatomic,strong) NSString *u_id;
@property (nonatomic,strong) NSDictionary *user;

@end
