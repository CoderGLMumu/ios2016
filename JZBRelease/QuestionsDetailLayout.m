//
//  QuestionsDetailLayout.m
//  JZBRelease
//
//  Created by cl z on 16/9/7.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "QuestionsDetailLayout.h"
#import "Defaults.h"
#import "QuestionEvaluateModel.h"
#import "ChildEvaluateModel.h"
@implementation QuestionsDetailLayout

- (id)initWithContainer:(LWStorageContainer *)container
                  Model:(QuestionsModel *)questionsModel
          dateFormatter:(NSDateFormatter *)dateFormatter
                  index:(NSInteger)index
               IsDetail:(BOOL)isDetail{
    self = [super initWithContainer:container];
    self.questionsModel = questionsModel;
    if (self) {
        
            QuestionEvaluateModel *evaluateModel = [QuestionEvaluateModel mj_objectWithKeyValues:[questionsModel.evaluate objectAtIndex:index]];
            self.index = index;
            
            LWTextStorage* dateTextStorage = [[LWTextStorage alloc] init];
            dateTextStorage.font = [UIFont systemFontOfSize:questionsModel.fontSize / 1.636];
            dateTextStorage.textColor = [UIColor hx_colorWithHexRGBAString:@"bdbdbd"];
            dateTextStorage.linespace = 1.0f;
            long long int date1 = (long long int)[evaluateModel.create_time intValue];
            NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:date1];
            dateTextStorage.text = [[questionsModel class] compareCurrentTime:date2];
            NSDictionary *dateTextAttrs = @{NSFontAttributeName:dateTextStorage.font};
        if (questionsModel.inteval == 4.5) {
            [dateTextStorage setFrame:CGRectMake(10 , 5, 160, [dateTextStorage.text sizeWithAttributes:dateTextAttrs].width)];
        }else{
            [dateTextStorage setFrame:CGRectMake(10 , 0, 160, [dateTextStorage.text sizeWithAttributes:dateTextAttrs].width)];
        }
        
            [container addStorage:dateTextStorage];

            
            LWTextStorage* contentTextStorage = [[LWTextStorage alloc] init];
            contentTextStorage.font = [UIFont systemFontOfSize:questionsModel.fontSize / 1.2];
            contentTextStorage.textColor = [UIColor hx_colorWithHexRGBAString:@"212121"];
            contentTextStorage.linespace = 2.0f;
            contentTextStorage.text = evaluateModel.eval_content;
            NSDictionary *contentTextAttrs = @{NSFontAttributeName:contentTextStorage.font};
            [contentTextStorage setFrame:CGRectMake(10 , dateTextStorage.bottom + questionsModel.inteval * 2, SCREEN_WIDTH - 20, [contentTextStorage.text sizeWithAttributes:contentTextAttrs].height)];
            [container addStorage:contentTextStorage];
        
        LWTextStorage *commentStorage11,*commentStorage12,*commentStorage13,*commentStorage21,*commentStorage22,*commentStorage23;
        LWImageStorage *commentBGStorage;
       /* if (!isDetail) {
        
            if (evaluateModel._child && evaluateModel._child.count > 0) {
                if (evaluateModel._child.count > 0) {
                    UIImage *bgImage = [[ZJBHelp getInstance] buttonImageFromColor:[UIColor hx_colorWithHexRGBAString:@"eaeaea"] WithFrame:CGRectMake(0, 0, 10, 1)];
                    commentBGStorage = [[LWImageStorage alloc]init];
                    commentBGStorage.type = LWImageStorageLocalImage;
                    commentBGStorage.image = bgImage;
                    
                    ChildEvaluateModel *childModel = [ChildEvaluateModel mj_objectWithKeyValues: [evaluateModel._child objectAtIndex:0]];
                    if (childModel.eval_to_u_nickname && childModel.eval_to_u_nickname.length > 0 && ![childModel.eval_u_nickname isEqualToString:childModel.eval_to_u_nickname] && ![childModel.eval_to_u_nickname isEqualToString:evaluateModel.eval_u_nickname]) {
                        commentStorage11 = [[LWTextStorage alloc]init];
                        commentStorage12 = [[LWTextStorage alloc]init];
                        commentStorage11.text = childModel.eval_u_nickname;
                        commentStorage11.textColor = [UIColor hx_colorWithHexRGBAString:@"2197f4"];
                        commentStorage12.textColor = [UIColor hx_colorWithHexRGBAString:@"212121"];
                        commentStorage12.linespace = commentStorage11.linespace = 2.0f;
                        commentStorage12.font = commentStorage11.font = [UIFont systemFontOfSize:evaluateModel.fontSize / 1.2142];
                        NSString *com2 = [NSString stringWithFormat:@" 回复%@ :  ",childModel.eval_to_u_nickname];
                        
                        NSDictionary *commentAttrs = @{NSFontAttributeName:commentStorage11.font};
                        NSString *singleS = [childModel.eval_content substringToIndex:1];
                        int singleSWidth = [singleS sizeWithAttributes:commentAttrs].width;
                        int remindWidth = SCREEN_WIDTH - 25 - [[childModel.eval_u_nickname stringByAppendingString:com2] sizeWithAttributes:commentAttrs].width - 2 - 25;
                        if (singleSWidth * childModel.eval_content.length > remindWidth) {
                            int subCount = remindWidth / (float)singleSWidth;
                            NSString *subS1 = [childModel.eval_content substringToIndex:subCount];
                            com2 = [com2 stringByAppendingString:subS1];
                            commentStorage12.text = com2;
                            commentStorage13 = [[LWTextStorage alloc]init];
                            NSString *subS2 = [childModel.eval_content substringFromIndex:subCount];
                            commentStorage13.text = subS2;
                            commentStorage13.font = commentStorage11.font;
                            commentStorage13.textColor = [UIColor hx_colorWithHexRGBAString:@"212121"];
                            commentStorage13.linespace = 2.0f;
                            [commentStorage11 setFrame:CGRectMake(25, contentTextStorage.bottom + 3 * childModel.inteval, [commentStorage11.text sizeWithAttributes:commentAttrs].width, [commentStorage11.text sizeWithAttributes:commentAttrs].height)];
                            [commentStorage12 setFrame:CGRectMake(commentStorage11.right, contentTextStorage.bottom + 3 * childModel.inteval, [commentStorage12.text sizeWithAttributes:commentAttrs].width + 2, [commentStorage12.text sizeWithAttributes:commentAttrs].height)];
                            [commentStorage13 setFrame:CGRectMake(25,commentStorage11.bottom + childModel.inteval / 2, SCREEN_WIDTH - 25 - 25, [commentStorage13.text sizeWithAttributes:commentAttrs].height)];
                            [container addStorage:commentStorage11];
                            [container addStorage:commentStorage12];
                            [container addStorage:commentStorage13];
                        }else{
                            com2 = [com2 stringByAppendingString:childModel.eval_content];
                            commentStorage12.text = com2;
                            [commentStorage11 setFrame:CGRectMake(25, contentTextStorage.bottom + 3 * childModel.inteval, [commentStorage11.text sizeWithAttributes:commentAttrs].width, [commentStorage11.text sizeWithAttributes:commentAttrs].height)];
                            [commentStorage12 setFrame:CGRectMake(commentStorage11.right, contentTextStorage.bottom + 3 * childModel.inteval, [commentStorage12.text sizeWithAttributes:commentAttrs].width + 2, [commentStorage12.text sizeWithAttributes:commentAttrs].height)];
                            [container addStorage:commentStorage11];
                            [container addStorage:commentStorage12];
                            
                        }
                    }else{
                        commentStorage11 = [[LWTextStorage alloc]init];
                        commentStorage12 = [[LWTextStorage alloc]init];
                        commentStorage11.text = [childModel.eval_u_nickname stringByAppendingString:@" : "];
                        commentStorage11.textColor = [UIColor hx_colorWithHexRGBAString:@"2197f4"];
                        commentStorage12.textColor = [UIColor hx_colorWithHexRGBAString:@"212121"];
                        commentStorage12.linespace = commentStorage11.linespace = 2.0f;
                        commentStorage12.font = commentStorage11.font = [UIFont systemFontOfSize:evaluateModel.fontSize / 1.2142];
                        NSDictionary *commentAttrs = @{NSFontAttributeName:commentStorage11.font};
                        NSString *singleS = [childModel.eval_content substringToIndex:1];
                        int singleSWidth = [singleS sizeWithAttributes:commentAttrs].width;
                        int remindWidth = SCREEN_WIDTH - 25 - [commentStorage11.text sizeWithAttributes:commentAttrs].width - 2- 25;
                        if (singleSWidth * childModel.eval_content.length > remindWidth) {
                            int subCount = remindWidth / (float)singleSWidth;
                            NSString *subS1 = [childModel.eval_content substringToIndex:subCount];
                            commentStorage12.text = subS1;
                            commentStorage13 = [[LWTextStorage alloc]init];
                            NSString *subS2 = [childModel.eval_content substringFromIndex:subCount];
                            commentStorage13.text = subS2;
                            commentStorage13.textColor = [UIColor hx_colorWithHexRGBAString:@"212121"];
                            commentStorage13.font = commentStorage11.font;
                            commentStorage13.linespace = 2.0f;
                            [commentStorage11 setFrame:CGRectMake(25, contentTextStorage.bottom + 3 * childModel.inteval, [commentStorage11.text sizeWithAttributes:commentAttrs].width, [commentStorage11.text sizeWithAttributes:commentAttrs].height)];
                            [commentStorage12 setFrame:CGRectMake(commentStorage11.right, contentTextStorage.bottom + 3 * childModel.inteval, [commentStorage12.text sizeWithAttributes:commentAttrs].width + 2, [commentStorage12.text sizeWithAttributes:commentAttrs].height)];
                            [commentStorage13 setFrame:CGRectMake(25,commentStorage11.bottom + childModel.inteval / 2, SCREEN_WIDTH - 25 - 25, [commentStorage13.text sizeWithAttributes:commentAttrs].height)];
                            [container addStorage:commentStorage11];
                            [container addStorage:commentStorage12];
                            [container addStorage:commentStorage13];
                        }else{
                            commentStorage12.text = childModel.eval_content;
                            [commentStorage11 setFrame:CGRectMake(25, contentTextStorage.bottom + 3 * childModel.inteval, [commentStorage11.text sizeWithAttributes:commentAttrs].width, [commentStorage11.text sizeWithAttributes:commentAttrs].height)];
                            [commentStorage12 setFrame:CGRectMake(commentStorage11.right, contentTextStorage.bottom + 3 * childModel.inteval, [commentStorage12.text sizeWithAttributes:commentAttrs].width + 2, [commentStorage12.text sizeWithAttributes:commentAttrs].height)];
                            [container addStorage:commentStorage11];
                            [container addStorage:commentStorage12];
                        }
                    }
                }
            }
            
            
            
            if (evaluateModel._child && evaluateModel._child.count > 1) {
                if (evaluateModel._child.count > 1) {
                    ChildEvaluateModel *childModel = [ChildEvaluateModel mj_objectWithKeyValues: [evaluateModel._child objectAtIndex:1]];
                    if (childModel.eval_to_u_nickname && childModel.eval_to_u_nickname.length > 0 && ![childModel.eval_u_nickname isEqualToString:childModel.eval_to_u_nickname] && ![childModel.eval_to_u_nickname isEqualToString:evaluateModel.eval_u_nickname]) {
                        commentStorage21 = [[LWTextStorage alloc]init];
                        commentStorage22 = [[LWTextStorage alloc]init];
                        commentStorage21.text = childModel.eval_u_nickname;
                        commentStorage21.textColor = [UIColor hx_colorWithHexRGBAString:@"2197f4"];
                        commentStorage22.textColor = [UIColor hx_colorWithHexRGBAString:@"212121"];
                        commentStorage22.linespace = commentStorage21.linespace = 2.0f;
                        commentStorage22.font = commentStorage21.font = [UIFont systemFontOfSize:evaluateModel.fontSize / 1.2142];
                        NSString *com2 = [NSString stringWithFormat:@" 回复%@ :  ",childModel.eval_to_u_nickname];
                        
                        NSDictionary *commentAttrs = @{NSFontAttributeName:commentStorage21.font};
                        NSString *singleS = @"回";
                        int singleSWidth = [singleS sizeWithAttributes:commentAttrs].width;
                        int remindWidth = SCREEN_WIDTH - 25 - [childModel.eval_u_nickname sizeWithAttributes:commentAttrs].width - 2 - 25;
                        if (singleSWidth * [com2 stringByAppendingString:childModel.eval_content].length > remindWidth) {
                            int subCount = remindWidth / (float)singleSWidth;
                            NSString *subS1 = [[com2 stringByAppendingString:childModel.eval_content] substringToIndex:subCount];
                            com2 = subS1;
                            commentStorage22.text = com2;
                            commentStorage23 = [[LWTextStorage alloc]init];
                            NSString *subS2 = [[com2 stringByAppendingString:childModel.eval_content] substringFromIndex:subCount];
                            commentStorage23.text = subS2;
                            commentStorage23.font = commentStorage21.font;
                            commentStorage23.textColor = [UIColor hx_colorWithHexRGBAString:@"212121"];
                            commentStorage23.linespace = 2.0f;
                            if (commentStorage13) {
                                [commentStorage21 setFrame:CGRectMake(25, commentStorage13.bottom + 0.7 * childModel.inteval, [commentStorage21.text sizeWithAttributes:commentAttrs].width, [commentStorage21.text sizeWithAttributes:commentAttrs].height)];
                                [commentStorage22 setFrame:CGRectMake(commentStorage11.right, commentStorage13.bottom + 0.7 * childModel.inteval / 2, [commentStorage22.text sizeWithAttributes:commentAttrs].width + 2, [commentStorage22.text sizeWithAttributes:commentAttrs].height)];
                                
                            }else{
                                [commentStorage21 setFrame:CGRectMake(25, commentStorage11.bottom + 0.7 * childModel.inteval, [commentStorage21.text sizeWithAttributes:commentAttrs].width, [commentStorage21.text sizeWithAttributes:commentAttrs].height)];
                                [commentStorage22 setFrame:CGRectMake(commentStorage11.right, commentStorage11.bottom + 0.7 * childModel.inteval, [commentStorage22.text sizeWithAttributes:commentAttrs].width + 2, [commentStorage22.text sizeWithAttributes:commentAttrs].height)];
                            }
                            [commentStorage23 setFrame:CGRectMake(25,commentStorage21.bottom + childModel.inteval / 2, SCREEN_WIDTH - 25 - 25, [commentStorage23.text sizeWithAttributes:commentAttrs].height)];
                            [container addStorage:commentStorage21];
                            [container addStorage:commentStorage22];
                            [container addStorage:commentStorage23];
                        }else{
                            com2 = [com2 stringByAppendingString:childModel.eval_content];
                            commentStorage22.text = com2;
                            if (commentStorage13) {
                                [commentStorage21 setFrame:CGRectMake(25, commentStorage13.bottom + 0.7 * childModel.inteval, [commentStorage21.text sizeWithAttributes:commentAttrs].width, [commentStorage21.text sizeWithAttributes:commentAttrs].height)];
                                [commentStorage22 setFrame:CGRectMake(commentStorage21.right, commentStorage13.bottom +0.7 * childModel.inteval, [commentStorage22.text sizeWithAttributes:commentAttrs].width + 2, [commentStorage22.text sizeWithAttributes:commentAttrs].height)];
                            }else{
                                [commentStorage21 setFrame:CGRectMake(25, commentStorage11.bottom + 0.7 * childModel.inteval, [commentStorage21.text sizeWithAttributes:commentAttrs].width, [commentStorage21.text sizeWithAttributes:commentAttrs].height)];
                                [commentStorage22 setFrame:CGRectMake(commentStorage21.right, commentStorage11.bottom +0.7 * childModel.inteval, [commentStorage22.text sizeWithAttributes:commentAttrs].width + 2, [commentStorage22.text sizeWithAttributes:commentAttrs].height)];
                            }
                            
                            [container addStorage:commentStorage21];
                            [container addStorage:commentStorage22];
                        }
                    }else{
                        commentStorage21 = [[LWTextStorage alloc]init];
                        commentStorage22 = [[LWTextStorage alloc]init];
                        commentStorage21.text = [childModel.eval_u_nickname stringByAppendingString:@" : "];
                        commentStorage21.textColor = [UIColor hx_colorWithHexRGBAString:@"2197f4"];
                        commentStorage22.textColor = [UIColor hx_colorWithHexRGBAString:@"212121"];
                        commentStorage22.linespace = commentStorage21.linespace = 2.0f;
                        commentStorage22.font = commentStorage21.font = [UIFont systemFontOfSize:evaluateModel.fontSize / 1.2142];
                        NSDictionary *commentAttrs = @{NSFontAttributeName:commentStorage21.font};
                        NSString *singleS = [childModel.eval_content substringToIndex:1];
                        int singleSWidth = [singleS sizeWithAttributes:commentAttrs].width;
                        int remindWidth = SCREEN_WIDTH - 25 - [commentStorage21.text sizeWithAttributes:commentAttrs].width - 2 - 25 ;
                        if (singleSWidth * childModel.eval_content.length > remindWidth) {
                            int subCount = remindWidth / (float)singleSWidth;
                            NSString *subS1 = [childModel.eval_content substringToIndex:subCount];
                            commentStorage22.text = subS1;
                            commentStorage23 = [[LWTextStorage alloc]init];
                            NSString *subS2 = [childModel.eval_content substringFromIndex:subCount];
                            commentStorage23.text = subS2;
                            commentStorage23.font = commentStorage21.font;
                            commentStorage23.textColor = [UIColor hx_colorWithHexRGBAString:@"212121"];
                            commentStorage23.linespace = 2.0f;
                            if (commentStorage13) {
                                [commentStorage21 setFrame:CGRectMake(25, commentStorage13.bottom + 0.7 * childModel.inteval, [commentStorage21.text sizeWithAttributes:commentAttrs].width, [commentStorage21.text sizeWithAttributes:commentAttrs].height)];
                                [commentStorage22 setFrame:CGRectMake(commentStorage21.right, commentStorage13.bottom + 0.7 * childModel.inteval, [commentStorage22.text sizeWithAttributes:commentAttrs].width + 2, [commentStorage22.text sizeWithAttributes:commentAttrs].height)];
                            }else{
                                [commentStorage21 setFrame:CGRectMake(25, commentStorage11.bottom + 0.7 * childModel.inteval, [commentStorage21.text sizeWithAttributes:commentAttrs].width, [commentStorage21.text sizeWithAttributes:commentAttrs].height)];
                                [commentStorage22 setFrame:CGRectMake(commentStorage21.right, commentStorage11.bottom + 0.7 * childModel.inteval, [commentStorage22.text sizeWithAttributes:commentAttrs].width + 2, [commentStorage22.text sizeWithAttributes:commentAttrs].height)];
                            }
                            
                            [commentStorage23 setFrame:CGRectMake(25,commentStorage21.bottom + childModel.inteval / 2, SCREEN_WIDTH - 25 - 20, [commentStorage23.text sizeWithAttributes:commentAttrs].height)];
                            [container addStorage:commentStorage21];
                            [container addStorage:commentStorage22];
                            [container addStorage:commentStorage23];
                        }else{
                            commentStorage22.text = childModel.eval_content;
                            if (commentStorage13) {
                                [commentStorage21 setFrame:CGRectMake(25, commentStorage13.bottom + 0.7 * childModel.inteval, [commentStorage21.text sizeWithAttributes:commentAttrs].width, [commentStorage21.text sizeWithAttributes:commentAttrs].height)];
                                [commentStorage22 setFrame:CGRectMake(commentStorage21.right, commentStorage13.bottom +0.7 * childModel.inteval, [commentStorage22.text sizeWithAttributes:commentAttrs].width + 2, [commentStorage22.text sizeWithAttributes:commentAttrs].height)];
                            }else{
                                [commentStorage21 setFrame:CGRectMake(25, commentStorage11.bottom + 0.7 * childModel.inteval, [commentStorage21.text sizeWithAttributes:commentAttrs].width, [commentStorage21.text sizeWithAttributes:commentAttrs].height)];
                                [commentStorage22 setFrame:CGRectMake(commentStorage21.right, commentStorage11.bottom + 0.7 * childModel.inteval, [commentStorage22.text sizeWithAttributes:commentAttrs].width + 2, [commentStorage22.text sizeWithAttributes:commentAttrs].height)];
                            }
                            
                            [container addStorage:commentStorage21];
                            [container addStorage:commentStorage22];
                        }
                    }
                }
            }*/
            
            if (commentStorage23) {
                commentBGStorage.frame = CGRectMake(10, commentStorage11.top - 10, SCREEN_WIDTH - 20, commentStorage23.bottom + 10 - (commentStorage11.top - 10));
            }else{
                if (commentStorage21) {
                    commentBGStorage.frame = CGRectMake(10, commentStorage11.top - 10, SCREEN_WIDTH - 20, commentStorage21.bottom + 10 - (commentStorage11.top - 10));
                }else{
                    if (commentStorage13) {
                        commentBGStorage.frame = CGRectMake(10, commentStorage11.top - 10, SCREEN_WIDTH - 20, commentStorage13.bottom + 10 - (commentStorage11.top - 10));
                    }else{
                        if (commentStorage11) {
                            commentBGStorage.frame = CGRectMake(10, commentStorage11.top - 10, SCREEN_WIDTH - 20, commentStorage11.bottom + 10 - (commentStorage11.top - 10));
                        }else{
                            //commentBGStorage.frame = CGRectMake(10, commentStorage11.top - 10, SCREEN_WIDTH - 20, 1);
                        }
                    }
                }
            }
        if (commentBGStorage) {
            [container addStorage:commentBGStorage];
            self.cellHeight = commentBGStorage.bottom + questionsModel.inteval * 2.5;
        }else{
            self.cellHeight = contentTextStorage.bottom + questionsModel.inteval * 2.5;
        }
    }
    
    return self;
}

@end
