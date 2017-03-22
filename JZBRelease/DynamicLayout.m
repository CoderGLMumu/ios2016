//
//  DynamicGoodLayout.m
//  JZBRelease
//
//  Created by zjapple on 16/5/12.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "DynamicLayout.h"
#import "EvaluateModel.h"
#import "ChildEvaluateModel.h"
#import "DealNormalUtil.h"
@implementation DynamicLayout

- (id)initWithContainer:(LWStorageContainer *)container
                  Model:(EvaluateModel *)evaluateModel
          dateFormatter:(NSDateFormatter *)dateFormatter
                  index:(NSInteger)index
            WithDynamic:(BOOL) isDynamic{
    self = [super initWithContainer:container];
    if (self) {
        /****************************生成Storage 相当于模型*************************************/
        /*********LWAsyncDisplayView用将所有文本跟图片的模型都抽象成LWStorage，方便你能预先将所有的需要计算的布局内容直接缓存起来***/
        /*******而不是在渲染的时候才进行计算*******************************************/
        self.evaluateModel = evaluateModel;
        
     
        
        LWTextStorage *commentStorage11,*commentStorage12,*commentStorage13,*commentStorage21,*commentStorage22,*commentStorage23,*dateStorage;
        if (0 == index) {
            //正文内容模型 contentTextStorage
            LWTextStorage* contentTextStorage = [[LWTextStorage alloc] init];
            //UIFont *font = [UIFont systemFontOfSize:evaluateModel.fontSize / 8.0 * 3 - 3];
            contentTextStorage.font = [UIFont systemFontOfSize:evaluateModel.fontSize / 1.0625];
            contentTextStorage.textColor = [UIColor hx_colorWithHexRGBAString:@"212121"];
            contentTextStorage.linespace = 2.0f;
            contentTextStorage.text = evaluateModel.eval_content;
            contentTextStorage.clink_type = Clink_Type_Two;
            NSDictionary *contentAttrs = @{NSFontAttributeName:contentTextStorage.font};
            [contentTextStorage setFrame:CGRectMake(62, 2 * self.evaluateModel.inteval, SCREEN_WIDTH - 82, [contentTextStorage.text sizeWithAttributes:contentAttrs].height)];
            [container addStorage:contentTextStorage];
            if (!isDynamic) {
                if (self.evaluateModel._child && self.evaluateModel._child.count > 0) {
                    if (self.evaluateModel._child.count > 0) {
                        ChildEvaluateModel *childModel = [ChildEvaluateModel mj_objectWithKeyValues: [evaluateModel._child objectAtIndex:0]];
                        if (childModel.eval_to_u_nickname && childModel.eval_to_u_nickname.length > 0 && ![childModel.eval_u_nickname isEqualToString:childModel.eval_to_u_nickname] && ![childModel.eval_to_u_nickname isEqualToString:self.evaluateModel.eval_u_nickname]) {
                            commentStorage11 = [[LWTextStorage alloc]init];
                            commentStorage12 = [[LWTextStorage alloc]init];
                            commentStorage11.text = childModel.eval_u_nickname;
                            commentStorage11.textColor = [UIColor hx_colorWithHexRGBAString:@"2198f2"];
                            commentStorage12.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
                            commentStorage12.linespace = commentStorage11.linespace = 2.0f;
                            commentStorage12.font = commentStorage11.font = [UIFont systemFontOfSize:self.evaluateModel.fontSize / 1.416];
                            NSString *com2 = [NSString stringWithFormat:@" 回复%@ :  ",childModel.eval_to_u_nickname];
                            
                            NSDictionary *commentAttrs = @{NSFontAttributeName:commentStorage11.font};
                            NSString *singleS = [childModel.eval_content substringToIndex:1];
                            int singleSWidth = [singleS sizeWithAttributes:commentAttrs].width;
                            int remindWidth = SCREEN_WIDTH - 62 - [[childModel.eval_u_nickname stringByAppendingString:com2] sizeWithAttributes:commentAttrs].width - 20;
                            if (singleSWidth * childModel.eval_content.length > remindWidth) {
                                int subCount = remindWidth / (float)singleSWidth;
                                NSString *subS1 = [childModel.eval_content substringToIndex:subCount];
                                com2 = [com2 stringByAppendingString:subS1];
                                commentStorage12.text = com2;
                                commentStorage13 = [[LWTextStorage alloc]init];
                                NSString *subS2 = [childModel.eval_content substringFromIndex:subCount];
                                commentStorage13.text = subS2;
                                commentStorage13.font = commentStorage11.font;
                                commentStorage13.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
                                commentStorage13.linespace = 2.0f;
                                [commentStorage11 setFrame:CGRectMake(62, contentTextStorage.bottom + 1.5 * childModel.inteval, [commentStorage11.text sizeWithAttributes:commentAttrs].width, [commentStorage11.text sizeWithAttributes:commentAttrs].height)];
                                [commentStorage12 setFrame:CGRectMake(commentStorage11.right, contentTextStorage.bottom + 1.5 * childModel.inteval, [commentStorage12.text sizeWithAttributes:commentAttrs].width, [commentStorage12.text sizeWithAttributes:commentAttrs].height)];
                                [commentStorage13 setFrame:CGRectMake(62,commentStorage11.bottom + childModel.inteval, SCREEN_WIDTH - 62 - 20, [commentStorage13.text sizeWithAttributes:commentAttrs].height)];
                                [container addStorage:commentStorage11];
                                [container addStorage:commentStorage12];
                                [container addStorage:commentStorage13];
                            }else{
                                com2 = [com2 stringByAppendingString:childModel.eval_content];
                                commentStorage12.text = com2;
                                [commentStorage11 setFrame:CGRectMake(62, contentTextStorage.bottom + 1.5 * childModel.inteval, [commentStorage11.text sizeWithAttributes:commentAttrs].width, [commentStorage11.text sizeWithAttributes:commentAttrs].height)];
                                [commentStorage12 setFrame:CGRectMake(commentStorage11.right, contentTextStorage.bottom + 1.5 * childModel.inteval, [commentStorage12.text sizeWithAttributes:commentAttrs].width, [commentStorage12.text sizeWithAttributes:commentAttrs].height)];
                                [container addStorage:commentStorage11];
                                [container addStorage:commentStorage12];
                                
                            }
                        }else{
                            commentStorage11 = [[LWTextStorage alloc]init];
                            commentStorage12 = [[LWTextStorage alloc]init];
                            commentStorage11.text = [childModel.eval_u_nickname stringByAppendingString:@" : "];
                            commentStorage11.textColor = [UIColor hx_colorWithHexRGBAString:@"2198f2"];
                            commentStorage12.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
                            commentStorage12.linespace = commentStorage11.linespace = 2.0f;
                            commentStorage12.font = commentStorage11.font = [UIFont systemFontOfSize:self.evaluateModel.fontSize / 1.416];
                            NSDictionary *commentAttrs = @{NSFontAttributeName:commentStorage11.font};
                            NSString *singleS = [childModel.eval_content substringToIndex:1];
                            int singleSWidth = [singleS sizeWithAttributes:commentAttrs].width;
                            int remindWidth = SCREEN_WIDTH - 62 - [commentStorage11.text sizeWithAttributes:commentAttrs].width - 20;
                            if (singleSWidth * childModel.eval_content.length > remindWidth) {
                                int subCount = remindWidth / (float)singleSWidth;
                                NSString *subS1 = [childModel.eval_content substringToIndex:subCount];
                                commentStorage12.text = subS1;
                                commentStorage13 = [[LWTextStorage alloc]init];
                                NSString *subS2 = [childModel.eval_content substringFromIndex:subCount];
                                commentStorage13.text = subS2;
                                commentStorage13.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
                                commentStorage13.font = commentStorage11.font;
                                commentStorage13.linespace = 2.0f;
                                [commentStorage11 setFrame:CGRectMake(62, contentTextStorage.bottom + 1.5 * childModel.inteval, [commentStorage11.text sizeWithAttributes:commentAttrs].width, [commentStorage11.text sizeWithAttributes:commentAttrs].height)];
                                [commentStorage12 setFrame:CGRectMake(commentStorage11.right, contentTextStorage.bottom + 1.5 * childModel.inteval, [commentStorage12.text sizeWithAttributes:commentAttrs].width, [commentStorage12.text sizeWithAttributes:commentAttrs].height)];
                                [commentStorage13 setFrame:CGRectMake(62,commentStorage11.bottom + childModel.inteval, SCREEN_WIDTH - 62 - 20, [commentStorage13.text sizeWithAttributes:commentAttrs].height)];
                                [container addStorage:commentStorage11];
                                [container addStorage:commentStorage12];
                                [container addStorage:commentStorage13];
                            }else{
                                commentStorage12.text = childModel.eval_content;
                                [commentStorage11 setFrame:CGRectMake(62, contentTextStorage.bottom + 1.5 * childModel.inteval, [commentStorage11.text sizeWithAttributes:commentAttrs].width, [commentStorage11.text sizeWithAttributes:commentAttrs].height)];
                                [commentStorage12 setFrame:CGRectMake(commentStorage11.right, contentTextStorage.bottom + 1.5 * childModel.inteval, [commentStorage12.text sizeWithAttributes:commentAttrs].width, [commentStorage12.text sizeWithAttributes:commentAttrs].height)];
                                [container addStorage:commentStorage11];
                                [container addStorage:commentStorage12];
                            }
                        }
                    }
                }
                
                
                
                if (self.evaluateModel._child && self.evaluateModel._child.count > 1) {
                    if (self.evaluateModel._child.count > 1) {
                        ChildEvaluateModel *childModel = [ChildEvaluateModel mj_objectWithKeyValues: [evaluateModel._child objectAtIndex:1]];
                        if (childModel.eval_to_u_nickname && childModel.eval_to_u_nickname.length > 0 && ![childModel.eval_u_nickname isEqualToString:childModel.eval_to_u_nickname] && ![childModel.eval_to_u_nickname isEqualToString:self.evaluateModel.eval_u_nickname]) {
                            commentStorage21 = [[LWTextStorage alloc]init];
                            commentStorage22 = [[LWTextStorage alloc]init];
                            commentStorage21.text = childModel.eval_u_nickname;
                            commentStorage21.textColor = [UIColor hx_colorWithHexRGBAString:@"2198f2"];
                            commentStorage22.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
                            commentStorage22.linespace = commentStorage21.linespace = 2.0f;
                            commentStorage22.font = commentStorage21.font = [UIFont systemFontOfSize:self.evaluateModel.fontSize / 1.416];
                            NSString *com2 = [NSString stringWithFormat:@" 回复%@ :  ",childModel.eval_to_u_nickname];
                            
                            NSDictionary *commentAttrs = @{NSFontAttributeName:commentStorage21.font};
                            NSString *singleS = [childModel.eval_content substringToIndex:1];
                            int singleSWidth = [singleS sizeWithAttributes:commentAttrs].width;
                            int remindWidth = SCREEN_WIDTH - 62 - [[childModel.eval_u_nickname stringByAppendingString:com2] sizeWithAttributes:commentAttrs].width - 20;
                            if (singleSWidth * childModel.eval_content.length > remindWidth) {
                                int subCount = remindWidth / (float)singleSWidth;
                                NSString *subS1 = [childModel.eval_content substringToIndex:subCount];
                                com2 = [com2 stringByAppendingString:subS1];
                                commentStorage22.text = com2;
                                commentStorage23 = [[LWTextStorage alloc]init];
                                NSString *subS2 = [childModel.eval_content substringFromIndex:subCount];
                                commentStorage23.text = subS2;
                                commentStorage23.font = commentStorage21.font;
                                commentStorage23.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
                                commentStorage23.linespace = 2.0f;
                                if (commentStorage13) {
                                    [commentStorage21 setFrame:CGRectMake(62, commentStorage13.bottom + 1.5 * childModel.inteval, [commentStorage21.text sizeWithAttributes:commentAttrs].width, [commentStorage21.text sizeWithAttributes:commentAttrs].height)];
                                    [commentStorage22 setFrame:CGRectMake(commentStorage11.right, commentStorage13.bottom + 1.5 * childModel.inteval, [commentStorage22.text sizeWithAttributes:commentAttrs].width, [commentStorage22.text sizeWithAttributes:commentAttrs].height)];
                                    
                                }else{
                                    [commentStorage21 setFrame:CGRectMake(62, commentStorage11.bottom + 1.5 * childModel.inteval, [commentStorage21.text sizeWithAttributes:commentAttrs].width, [commentStorage21.text sizeWithAttributes:commentAttrs].height)];
                                    [commentStorage22 setFrame:CGRectMake(commentStorage11.right, commentStorage11.bottom + 1.5 * childModel.inteval, [commentStorage22.text sizeWithAttributes:commentAttrs].width, [commentStorage22.text sizeWithAttributes:commentAttrs].height)];
                                }
                                [commentStorage23 setFrame:CGRectMake(62,commentStorage21.bottom + childModel.inteval, SCREEN_WIDTH - 62 - 20, [commentStorage23.text sizeWithAttributes:commentAttrs].height)];
                                [container addStorage:commentStorage21];
                                [container addStorage:commentStorage22];
                                [container addStorage:commentStorage23];
                            }else{
                                com2 = [com2 stringByAppendingString:childModel.eval_content];
                                commentStorage22.text = com2;
                                if (commentStorage13) {
                                    [commentStorage21 setFrame:CGRectMake(62, commentStorage13.bottom + 1.5 * childModel.inteval, [commentStorage21.text sizeWithAttributes:commentAttrs].width, [commentStorage21.text sizeWithAttributes:commentAttrs].height)];
                                    [commentStorage22 setFrame:CGRectMake(commentStorage21.right, commentStorage13.bottom +1.5 * childModel.inteval, [commentStorage22.text sizeWithAttributes:commentAttrs].width, [commentStorage22.text sizeWithAttributes:commentAttrs].height)];
                                }else{
                                    [commentStorage21 setFrame:CGRectMake(62, commentStorage11.bottom + 1.5 * childModel.inteval, [commentStorage21.text sizeWithAttributes:commentAttrs].width, [commentStorage21.text sizeWithAttributes:commentAttrs].height)];
                                    [commentStorage22 setFrame:CGRectMake(commentStorage21.right, commentStorage11.bottom +1.5 * childModel.inteval, [commentStorage22.text sizeWithAttributes:commentAttrs].width, [commentStorage22.text sizeWithAttributes:commentAttrs].height)];
                                }
                                
                                [container addStorage:commentStorage21];
                                [container addStorage:commentStorage22];
                            }
                        }else{
                            commentStorage21 = [[LWTextStorage alloc]init];
                            commentStorage22 = [[LWTextStorage alloc]init];
                            commentStorage21.text = [childModel.eval_u_nickname stringByAppendingString:@" : "];
                            commentStorage21.textColor = [UIColor hx_colorWithHexRGBAString:@"2198f2"];
                            commentStorage22.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
                            commentStorage22.linespace = commentStorage21.linespace = 2.0f;
                            commentStorage22.font = commentStorage21.font = [UIFont systemFontOfSize:self.evaluateModel.fontSize / 1.416];
                            NSDictionary *commentAttrs = @{NSFontAttributeName:commentStorage21.font};
                            NSString *singleS = [childModel.eval_content substringToIndex:1];
                            int singleSWidth = [singleS sizeWithAttributes:commentAttrs].width;
                            int remindWidth = SCREEN_WIDTH - 62 - [commentStorage21.text sizeWithAttributes:commentAttrs].width - 20;
                            if (singleSWidth * childModel.eval_content.length > remindWidth) {
                                int subCount = remindWidth / (float)singleSWidth;
                                NSString *subS1 = [childModel.eval_content substringToIndex:subCount];
                                commentStorage22.text = subS1;
                                commentStorage23 = [[LWTextStorage alloc]init];
                                NSString *subS2 = [childModel.eval_content substringFromIndex:subCount];
                                commentStorage23.text = subS2;
                                commentStorage23.font = commentStorage21.font;
                                commentStorage23.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
                                commentStorage23.linespace = 2.0f;
                                if (commentStorage13) {
                                    [commentStorage21 setFrame:CGRectMake(62, commentStorage13.bottom + 1.5 * childModel.inteval, [commentStorage21.text sizeWithAttributes:commentAttrs].width, [commentStorage21.text sizeWithAttributes:commentAttrs].height)];
                                    [commentStorage22 setFrame:CGRectMake(commentStorage21.right, commentStorage13.bottom + 1.5 * childModel.inteval, [commentStorage22.text sizeWithAttributes:commentAttrs].width, [commentStorage22.text sizeWithAttributes:commentAttrs].height)];
                                }else{
                                    [commentStorage21 setFrame:CGRectMake(62, commentStorage11.bottom + 1.5 * childModel.inteval, [commentStorage21.text sizeWithAttributes:commentAttrs].width, [commentStorage21.text sizeWithAttributes:commentAttrs].height)];
                                    [commentStorage22 setFrame:CGRectMake(commentStorage21.right, commentStorage11.bottom + 1.5 * childModel.inteval, [commentStorage22.text sizeWithAttributes:commentAttrs].width, [commentStorage22.text sizeWithAttributes:commentAttrs].height)];
                                }
                                
                                [commentStorage23 setFrame:CGRectMake(62,commentStorage21.bottom + childModel.inteval, SCREEN_WIDTH - 62 - 20, [commentStorage23.text sizeWithAttributes:commentAttrs].height)];
                                [container addStorage:commentStorage21];
                                [container addStorage:commentStorage22];
                                [container addStorage:commentStorage23];
                            }else{
                                commentStorage22.text = childModel.eval_content;
                                if (commentStorage13) {
                                    [commentStorage21 setFrame:CGRectMake(62, commentStorage13.bottom + 1.5 * childModel.inteval, [commentStorage21.text sizeWithAttributes:commentAttrs].width, [commentStorage21.text sizeWithAttributes:commentAttrs].height)];
                                    [commentStorage22 setFrame:CGRectMake(commentStorage21.right, commentStorage13.bottom +1.5 * childModel.inteval, [commentStorage22.text sizeWithAttributes:commentAttrs].width, [commentStorage22.text sizeWithAttributes:commentAttrs].height)];
                                }else{
                                    [commentStorage21 setFrame:CGRectMake(62, commentStorage11.bottom + 1.5 * childModel.inteval, [commentStorage21.text sizeWithAttributes:commentAttrs].width, [commentStorage21.text sizeWithAttributes:commentAttrs].height)];
                                    [commentStorage22 setFrame:CGRectMake(commentStorage21.right, commentStorage11.bottom + 1.5 * childModel.inteval, [commentStorage22.text sizeWithAttributes:commentAttrs].width, [commentStorage22.text sizeWithAttributes:commentAttrs].height)];
                                }
                                
                                [container addStorage:commentStorage21];
                                [container addStorage:commentStorage22];
                            }
                        }
                    }
                }
            }
            
            if (commentStorage11) {
                commentStorage11.clink_type = Clink_Type_Three;
                [commentStorage11 addLinkWithData:[NSString stringWithFormat:@"%@",evaluateModel.eval_u_nickname]
                                          inRange:NSMakeRange(0,evaluateModel.eval_u_nickname.length)
                                        linkColor:[UIColor hx_colorWithHexRGBAString:@"2198f2"]
                                   highLightColor:RGB(0, 0, 0, 0.15)
                                   UnderLineStyle:NSUnderlineStyleNone];
            }
            if (commentStorage21) {
                commentStorage21.clink_type = Clink_Type_Five;
                [commentStorage21 addLinkWithData:[NSString stringWithFormat:@"%@",evaluateModel.eval_u_nickname]
                                          inRange:NSMakeRange(0,evaluateModel.eval_u_nickname.length)
                                        linkColor:[UIColor hx_colorWithHexRGBAString:@"2198f2"]
                                   highLightColor:RGB(0, 0, 0, 0.15)
                                   UnderLineStyle:NSUnderlineStyleNone];
            }
            
            //模型 时间
            dateStorage = [[LWTextStorage alloc] init];
            long long int date1 = (long long int)[evaluateModel.create_time intValue];
            NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:date1];
            dateStorage.text = [[evaluateModel class] compareCurrentTime:date2];
            dateStorage.font = [UIFont systemFontOfSize:evaluateModel.fontSize / 1.4166];
            dateStorage.textAlignment = NSTextAlignmentLeft;
            dateStorage.linespace = 2.0f;
            dateStorage.textColor = [UIColor lightGrayColor];
            NSDictionary *dateAttrs = @{NSFontAttributeName:dateStorage.font};
            
            if (commentStorage23) {
                [dateStorage setFrame:CGRectMake(62, commentStorage23.bottom + 1.5 * self.evaluateModel.inteval, [dateStorage.text sizeWithAttributes:dateAttrs].width, [dateStorage.text sizeWithAttributes:dateAttrs].height)];
            }else{
                if (commentStorage21) {
                    [dateStorage setFrame:CGRectMake(62, commentStorage21.bottom + 1.5 * self.evaluateModel.inteval, [dateStorage.text sizeWithAttributes:dateAttrs].width, [dateStorage.text sizeWithAttributes:dateAttrs].height)];
                }else{
                    if (commentStorage13) {
                        [dateStorage setFrame:CGRectMake(62, commentStorage13.bottom + 1.5 * self.evaluateModel.inteval, [dateStorage.text sizeWithAttributes:dateAttrs].width, [dateStorage.text sizeWithAttributes:dateAttrs].height)];
                    }else{
                        if (commentStorage11) {
                            [dateStorage setFrame:CGRectMake(62, commentStorage11.bottom + 1.5 * self.evaluateModel.inteval, [dateStorage.text sizeWithAttributes:dateAttrs].width, [dateStorage.text sizeWithAttributes:dateAttrs].height)];
                        }else{
                            [dateStorage setFrame:CGRectMake(62, contentTextStorage.bottom + 1.5 * self.evaluateModel.inteval, [dateStorage.text sizeWithAttributes:dateAttrs].width, [dateStorage.text sizeWithAttributes:dateAttrs].height)];
                            
                        }
                    }
                }
            }
            [container addStorage:dateStorage];
            
            
            UIImage *intevalImage = [[ZJBHelp getInstance] buttonImageFromColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"] WithFrame:CGRectMake(0, 0, 10, 1)];
            LWImageStorage *intevalStorage;
            intevalStorage = [[LWImageStorage alloc]init];
            intevalStorage.type = LWImageStorageLocalImage;
            intevalStorage.image = intevalImage;
            intevalStorage.frame = CGRectMake(0, dateStorage.bottom + 1.5 * self.evaluateModel.inteval, SCREEN_WIDTH, 1);
            [container addStorage:intevalStorage];
            self.cellHeight = intevalStorage.bottom;
        }
    }
    return self;

}

-(NSString *) returnUploadTime:(NSString *)timeStr
{
    //Tue May 21 10:56:45 +0800 2013
   
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"E MMM d HH:mm:SS Z y"];
    NSDate *d=[date dateFromString:timeStr];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=now-late;
    
    if (cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
        
    }
    if (cha/3600>1&&cha/86400<1) {
        //        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        //        timeString = [timeString substringToIndex:timeString.length-7];
        //        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"HH:mm"];
        timeString = [NSString stringWithFormat:@"今天 %@",[dateformatter stringFromDate:d]];
    }
    if (cha/86400>1)
    {
        //        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        //        timeString = [timeString substringToIndex:timeString.length-7];
        //        timeString=[NSString stringWithFormat:@"%@天前", timeString];
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YY-MM-dd HH:mm"];
        timeString = [NSString stringWithFormat:@"%@",[dateformatter stringFromDate:d]];
    }
    return timeString;
}

@end
