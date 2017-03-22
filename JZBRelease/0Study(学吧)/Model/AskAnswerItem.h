//
//  AskAnswerItem.h
//  JZBRelease
//
//  Created by zjapple on 16/9/19.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AATextFont [UIFont systemFontOfSize:15]

@interface AskAnswerItem : NSObject<NSCoding>

/** eval_id */
@property (nonatomic ,strong) NSString *eval_id;
/** p_id */
@property (nonatomic ,strong) NSString *p_id;
/** top_id */
@property (nonatomic ,strong) NSString *top_id;
/** class_id */
@property (nonatomic ,strong) NSString *class_id;
/** eval_uid */
@property (nonatomic ,strong) NSString *eval_uid;
/** eval_u_nickname */
@property (nonatomic ,strong) NSString *eval_u_nickname;
/** eval_to_uid */
@property (nonatomic ,strong) NSString *eval_to_uid;
/** eval_to_u_nickname */
@property (nonatomic ,strong) NSString *eval_to_u_nickname;
/** 内容(正文) */
@property (nonatomic ,strong) NSString *eval_content;
/** like_count */
@property (nonatomic ,strong) NSString *like_count;
/** reward_count */
@property (nonatomic ,strong) NSString *reward_count;
/** evaluate_count */
@property (nonatomic ,strong) NSString *evaluate_count;
/** create_time */
@property (nonatomic ,strong) NSString *create_time;
/** status */
@property (nonatomic ,strong) NSString *status;
/** is_new */
@property (nonatomic ,strong) NSString *is_new;
/** _answer */
@property (nonatomic ,strong) NSArray *_answer;
/** user */
@property (nonatomic ,strong) Users *user;
/** is_like */
@property (nonatomic ,strong) NSNumber *is_like;


@property (nonatomic ,assign)CGFloat cellHeight;

@end
