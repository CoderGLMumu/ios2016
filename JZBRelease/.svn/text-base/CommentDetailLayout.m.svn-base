//
//  CommentDetailLayout.m
//  JZBRelease
//
//  Created by cl z on 16/7/26.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "CommentDetailLayout.h"
#import "ZJBHelp.h"
#import "DealNormalUtil.h"
#import "LWConstraintManager.h"
#import "LWImageStorage.h"
#import "Defaults.h"
#import "LWTextStorage.h"
#import "ChildEvaluateModel.h"
@implementation CommentDetailLayout
- (id)initWithContainer:(LWStorageContainer *)container
                  Model:(QuestionEvaluateModel *)questionsModel
          dateFormatter:(NSDateFormatter *)dateFormatter
                  index:(NSInteger)index
               IsDetail:(BOOL)isDetail{
    self = [super initWithContainer:container];
    if (self) {
        /****************************生成Storage 相当于模型*************************************/
        /*********LWAsyncDisplayView用将所有文本跟图片的模型都抽象成LWStorage，方便你能预先将所有的需要计算的布局内容直接缓存起来***/
        /*******而不是在渲染的时候才进行计算*******************************************/
        self.questionsModel = [QuestionEvaluateModel mj_objectWithKeyValues:[questionsModel._child objectAtIndex:index]];
        
        //头像模型 avatarImageStorage
        LWImageStorage* avatarStorage = [[LWImageStorage alloc] init];
        avatarStorage.type = LWImageStorageWebImage;
        //  dispatch_async(dispatch_queue_create("", nil), ^{
        UIImage *image = nil;
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:self.questionsModel.user.avatar]]]];
        
        if (!image) {
            image = [UIImage imageNamed:@"bq_img_head"];
        }
        //   dispatch_async(dispatch_get_main_queue(), ^{
        [avatarStorage setImage:image];
        //   });
        
        // });
        //avatarStorage.URL = activityModel.user.avatar;
        avatarStorage.cornerRadius = questionsModel.inteval * 5 / 2.0f;
        avatarStorage.cornerBackgroundColor = [UIColor whiteColor];
        avatarStorage.fadeShow = YES;
        avatarStorage.masksToBounds = NO;
        [avatarStorage setFrame:CGRectMake(questionsModel.inteval * 1.67, questionsModel.inteval * 1.67, questionsModel.inteval * 5, questionsModel.inteval * 5)];
        [container addStorage:avatarStorage];
        self.avatarPosition1 = avatarStorage.frame;
        
        //名字模型 nameTextStorage
        LWTextStorage* nameTextStorage = [[LWTextStorage alloc] init];
        nameTextStorage.text = self.questionsModel.eval_u_nickname;
        nameTextStorage.font = [UIFont systemFontOfSize:questionsModel.fontSize / 1.2857];
        nameTextStorage.textAlignment = NSTextAlignmentLeft;
        nameTextStorage.linespace = 2.0f;
        nameTextStorage.textColor = [UIColor hx_colorWithHexRGBAString:@"212121"];
        NSDictionary *nameAttrs = @{NSFontAttributeName:nameTextStorage.font};
        [nameTextStorage setFrame:CGRectMake(questionsModel.inteval * 7.833, questionsModel.inteval * 2, [nameTextStorage.text sizeWithAttributes:nameAttrs].width + 2, [nameTextStorage.text sizeWithAttributes:nameAttrs].height)];
        [container addStorage:nameTextStorage];
        
        
        LWTextStorage* intevalTextStorage0 = [[LWTextStorage alloc] init];
        intevalTextStorage0.font = [UIFont systemFontOfSize:questionsModel.fontSize / 1.2857];
        intevalTextStorage0.textColor = [UIColor hx_colorWithHexRGBAString:@"bdbdbd"];
        intevalTextStorage0.linespace = 1.0f;
        intevalTextStorage0.textAlignment = NSTextAlignmentCenter;
        intevalTextStorage0.text = @"|";
        if (self.questionsModel.inteval == 4) {
            [intevalTextStorage0 setFrame:CGRectMake(nameTextStorage.right , questionsModel.inteval * 2, questionsModel.inteval * 3.4, [intevalTextStorage0.text sizeWithAttributes:nameAttrs].height)];
        }else{
            [intevalTextStorage0 setFrame:CGRectMake(nameTextStorage.right , questionsModel.inteval * 2 + 2, questionsModel.inteval * 3.4, [intevalTextStorage0.text sizeWithAttributes:nameAttrs].height)];
        }
        
        
        
        LWTextStorage* companyTextStorage = [[LWTextStorage alloc] init];
        companyTextStorage.font = [UIFont systemFontOfSize:questionsModel.fontSize / 1.2857];
        companyTextStorage.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
        companyTextStorage.linespace = 1.0f;
        companyTextStorage.textAlignment = NSTextAlignmentLeft;
        NSString *comStr;
        if (self.questionsModel.user.company) {
            if (self.questionsModel.user.company.length > 4) {
                comStr = [self.questionsModel.user.company substringToIndex:4];
            }else{
                comStr = self.questionsModel.user.company;
            }
        }
        if (self.questionsModel.user.job) {
            if (self.questionsModel.user.job.length > 10) {
                if (comStr) {
                    comStr = [comStr stringByAppendingString:[self.questionsModel.user.job substringToIndex:10]];
                }else{
                    comStr = [self.questionsModel.user.job substringToIndex:10];
                }
            }else{
                if (comStr) {
                    comStr = [comStr stringByAppendingString:self.questionsModel.user.job];
                }else{
                    comStr = self.questionsModel.user.job;
                }
            }
        }
        if (!comStr || comStr.length == 0 || [comStr isEqualToString:@""]) {
            
        }else{
            companyTextStorage.text = comStr;
            [companyTextStorage setFrame:CGRectMake(intevalTextStorage0.right , questionsModel.inteval * 2, [companyTextStorage.text sizeWithAttributes:nameAttrs].width + 5, [companyTextStorage.text sizeWithAttributes:nameAttrs].height)];
            
            [container addStorage:intevalTextStorage0];
            [container addStorage:companyTextStorage];
        }

        
        LWTextStorage* dateTextStorage = [[LWTextStorage alloc] init];
        dateTextStorage.font = [UIFont systemFontOfSize:questionsModel.fontSize / 1.636];
        dateTextStorage.textColor = [UIColor hx_colorWithHexRGBAString:@"bdbdbd"];
        //dateTextStorage.linespace = 1.0f;
        long long int date1 = (long long int)[self.questionsModel.create_time intValue];
        NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:date1];
        dateTextStorage.text = [[questionsModel class] compareCurrentTime:date2];
        NSDictionary *dateTextAttrs = @{NSFontAttributeName:dateTextStorage.font};
        [dateTextStorage setFrame:CGRectMake(nameTextStorage.left,nameTextStorage.bottom + 5, [dateTextStorage.text sizeWithAttributes:dateTextAttrs].width, [dateTextStorage.text sizeWithAttributes:dateTextAttrs].height)];
        [container addStorage:dateTextStorage];
        
        LWTextStorage* contentTextStorage = [[LWTextStorage alloc] init];
        contentTextStorage.font = [UIFont systemFontOfSize:questionsModel.fontSize / 1.2857];
        contentTextStorage.textAlignment = NSTextAlignmentLeft;
        contentTextStorage.linespace = 2.0f;
        contentTextStorage.characterSpacing = 1.0;
        contentTextStorage.textColor = [UIColor hx_colorWithHexRGBAString:@"212121"];
        NSDictionary *contentAttrs = @{NSFontAttributeName:contentTextStorage.font};
        if ([self.questionsModel.eval_to_u_nickname isEqualToString:questionsModel.eval_u_nickname] || !self.questionsModel.eval_to_u_nickname || self.questionsModel.eval_to_u_nickname.length == 0) {
            contentTextStorage.text = self.questionsModel.eval_content;
            [contentTextStorage setFrame:CGRectMake(nameTextStorage.left, dateTextStorage.bottom + questionsModel.inteval * 1.67, SCREEN_WIDTH - nameTextStorage.left - questionsModel.inteval * 2.5, [contentTextStorage.text sizeWithAttributes:contentAttrs].height)];
            [container addStorage:contentTextStorage];
        }else{
            LWTextStorage *ansTextStorage = [[LWTextStorage alloc]init];
            ansTextStorage.font = [UIFont systemFontOfSize:questionsModel.fontSize / 1.2857];
            ansTextStorage.textAlignment = NSTextAlignmentLeft;
            ansTextStorage.linespace = 2.0f;
            ansTextStorage.textColor = [UIColor hx_colorWithHexRGBAString:@"212121"];
            ansTextStorage.text = @"回复";
            [ansTextStorage setFrame:CGRectMake(nameTextStorage.left, dateTextStorage.bottom + questionsModel.inteval * 1.67, [ansTextStorage.text sizeWithAttributes:contentAttrs].width, [ansTextStorage.text sizeWithAttributes:contentAttrs].height)];
            [container addStorage:ansTextStorage];
            
            LWTextStorage *answerTextStorage = [[LWTextStorage alloc]init];
            answerTextStorage.font = [UIFont systemFontOfSize:questionsModel.fontSize / 1.2857];
            answerTextStorage.textAlignment = NSTextAlignmentLeft;
            answerTextStorage.linespace = 2.0f;
            answerTextStorage.textColor = [UIColor hx_colorWithHexRGBAString:@"2198f2"];
            answerTextStorage.text = self.questionsModel.eval_to_u_nickname;
            [answerTextStorage setFrame:CGRectMake(ansTextStorage.right, dateTextStorage.bottom + questionsModel.inteval * 1.67, [answerTextStorage.text sizeWithAttributes:contentAttrs].width, [answerTextStorage.text sizeWithAttributes:contentAttrs].height)];
            [container addStorage:answerTextStorage];
            
            NSString *contentStr = [NSString stringWithFormat:@" : %@",self.questionsModel.eval_content];
            NSString *singleStr = [contentStr substringToIndex:1];
            int singleWidth = [singleStr sizeWithAttributes:contentAttrs].width;
            int count = (SCREEN_WIDTH - answerTextStorage.right - questionsModel.inteval * 2.5) / singleWidth;
            if (contentStr.length > count) {
                LWTextStorage *firstTextStorage = [[LWTextStorage alloc]init];
                firstTextStorage.font = [UIFont systemFontOfSize:questionsModel.fontSize / 1.2857];
                firstTextStorage.textAlignment = NSTextAlignmentLeft;
                firstTextStorage.linespace = 2.0f;
                firstTextStorage.textColor = [UIColor hx_colorWithHexRGBAString:@"212121"];
                firstTextStorage.text = [contentStr substringToIndex:count];
                [firstTextStorage setFrame:CGRectMake(answerTextStorage.right, dateTextStorage.bottom + questionsModel.inteval * 1.67, SCREEN_WIDTH - answerTextStorage.right - questionsModel.inteval * 2.5, [answerTextStorage.text sizeWithAttributes:contentAttrs].height)];
                [container addStorage:firstTextStorage];
                
                contentTextStorage.text = [contentStr substringFromIndex:count];
                [contentTextStorage setFrame:CGRectMake(nameTextStorage.left, firstTextStorage.bottom, SCREEN_WIDTH - nameTextStorage.left - questionsModel.inteval * 2.5, [contentTextStorage.text sizeWithAttributes:contentAttrs].height)];
                [container addStorage:contentTextStorage];
            }else{
                contentTextStorage.text = contentStr;
                [contentTextStorage setFrame:CGRectMake(answerTextStorage.right, dateTextStorage.bottom + questionsModel.inteval * 1.67, SCREEN_WIDTH - answerTextStorage.right - questionsModel.inteval * 2.5, [contentTextStorage.text sizeWithAttributes:contentAttrs].height)];
                [container addStorage:contentTextStorage];
            }
            
        }
        
        
        
        
        UIImage *intevalImage = [[ZJBHelp getInstance] buttonImageFromColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"] WithFrame:CGRectMake(0, 0, questionsModel.inteval * 1.67, 1)];
        LWImageStorage *intevalStorage1;
        intevalStorage1 = [[LWImageStorage alloc]init];
        intevalStorage1.type = LWImageStorageLocalImage;
        intevalStorage1.image = intevalImage;
        intevalStorage1.frame = CGRectMake(nameTextStorage.left, contentTextStorage.bottom + self.questionsModel.inteval * 2.167, SCREEN_WIDTH - nameTextStorage.left, 1);
        [container addStorage:intevalStorage1];
        self.cellHeight = intevalStorage1.bottom;
        
        
    }
    return self;
    
}
@end
