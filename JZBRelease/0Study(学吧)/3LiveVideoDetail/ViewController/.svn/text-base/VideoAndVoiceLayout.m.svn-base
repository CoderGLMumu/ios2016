//
//  VideoAndVoiceLayout.m
//  JZBRelease
//
//  Created by cl z on 16/10/31.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "VideoAndVoiceLayout.h"
#import "ZJBHelp.h"
#import "DealNormalUtil.h"
#import "LWConstraintManager.h"
#import "LWImageStorage.h"
#import "Defaults.h"
#import "LWTextStorage.h"
#import "ChildEvaluateModel.h"
@implementation VideoAndVoiceLayout
- (id)initWithContainer:(LWStorageContainer *)container
                  Model:(CourseTimeEvaluateModel *)courseTimeEvaluateModel
          dateFormatter:(NSDateFormatter *)dateFormatter
                  index:(NSInteger)index
               IsDetail:(BOOL)isDetail{
    self = [super initWithContainer:container];
    if (self) {
        /****************************生成Storage 相当于模型*************************************/
        /*********LWAsyncDisplayView用将所有文本跟图片的模型都抽象成LWStorage，方便你能预先将所有的需要计算的布局内容直接缓存起来***/
        /*******而不是在渲染的时候才进行计算*******************************************/
        self.courseTimeEvaluateModel = courseTimeEvaluateModel;
        
        //头像模型 avatarImageStorage
        LWImageStorage* avatarStorage = [[LWImageStorage alloc] init];
        avatarStorage.type = LWImageStorageWebImage;
        //  dispatch_async(dispatch_queue_create("", nil), ^{
        UIImage *image = nil;
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:self.courseTimeEvaluateModel.avatar]]]];
        
        if (!image) {
            image = [UIImage imageNamed:@"bq_img_head"];
        }
        //   dispatch_async(dispatch_get_main_queue(), ^{
        [avatarStorage setImage:image];
        //   });
        
        // });
        //avatarStorage.URL = activityModel.user.avatar;
        avatarStorage.cornerRadius = 20.0f;
        avatarStorage.cornerBackgroundColor = [UIColor whiteColor];
        avatarStorage.fadeShow = YES;
        avatarStorage.masksToBounds = YES;
    
        [avatarStorage setFrame:CGRectMake(10, 10, 44, 44)];
        [container addStorage:avatarStorage];
        self.avatarPosition1 = avatarStorage.frame;
        
        //名字模型 nameTextStorage
        LWTextStorage* nameTextStorage = [[LWTextStorage alloc] init];
        nameTextStorage.text = self.courseTimeEvaluateModel.nickname;
        nameTextStorage.font = [UIFont systemFontOfSize:14];
        nameTextStorage.textAlignment = NSTextAlignmentLeft;
        nameTextStorage.linespace = 2.0f;
        nameTextStorage.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
        NSDictionary *nameAttrs = @{NSFontAttributeName:nameTextStorage.font};
        [nameTextStorage setFrame:CGRectMake(47 + 14, 12, 160, [nameTextStorage.text sizeWithAttributes:nameAttrs].height)];
        [container addStorage:nameTextStorage];
        
        LWTextStorage* dateTextStorage = [[LWTextStorage alloc] init];
        dateTextStorage.font = [UIFont systemFontOfSize:11];
        dateTextStorage.textColor = [UIColor hx_colorWithHexRGBAString:@"bdbdbd"];
        dateTextStorage.linespace = 1.0f;
        long long int date1 = (long long int)[self.courseTimeEvaluateModel.create_time intValue];
        NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:date1];
        dateTextStorage.text = [[courseTimeEvaluateModel class] compareCurrentTime:date2];
        NSDictionary *dateTextAttrs = @{NSFontAttributeName:dateTextStorage.font};
        [dateTextStorage setFrame:CGRectMake(SCREEN_WIDTH - 10 - [dateTextStorage.text sizeWithAttributes:dateTextAttrs].width , 12, [dateTextStorage.text sizeWithAttributes:dateTextAttrs].width, [dateTextStorage.text sizeWithAttributes:dateTextAttrs].height)];
        [container addStorage:dateTextStorage];
        
        LWTextStorage* contentTextStorage = [[LWTextStorage alloc] init];
        
        if ([self.courseTimeEvaluateModel.to_nickname isEqualToString:courseTimeEvaluateModel.nickname]) {
            contentTextStorage.text = self.courseTimeEvaluateModel.eval_content;
        }else{
            if (self.courseTimeEvaluateModel.to_nickname && self.courseTimeEvaluateModel.nickname.length > 0) {
                contentTextStorage.text = [NSString stringWithFormat:@"回复%@：%@",self.courseTimeEvaluateModel.to_nickname,self.courseTimeEvaluateModel.eval_content];
            }else{
                contentTextStorage.text = self.courseTimeEvaluateModel.eval_content;
            }
        }
        contentTextStorage.font = [UIFont systemFontOfSize:14];
        contentTextStorage.textAlignment = NSTextAlignmentLeft;
        contentTextStorage.linespace = 2.0f;
        contentTextStorage.textColor = [UIColor hx_colorWithHexRGBAString:@"212121"];
        NSDictionary *contentAttrs = @{NSFontAttributeName:contentTextStorage.font};
        [contentTextStorage setFrame:CGRectMake(57 + 14, nameTextStorage.bottom + 16, SCREEN_WIDTH - 77 - 14, [contentTextStorage.text sizeWithAttributes:contentAttrs].height)];
        [container addStorage:contentTextStorage];
        
        int singleWidth = [[contentTextStorage.text substringToIndex:1] sizeWithAttributes:contentAttrs].width;
        int count = (SCREEN_WIDTH - 77) / singleWidth;
        LWImageStorage *wrapImage = [[LWImageStorage alloc]init];
        wrapImage.type = LWImageStorageLocalImage;
        [wrapImage setImage:[UIImage imageNamed:@"XB_K"]];
        if (contentTextStorage.text.length > count) {
            [wrapImage setFrame:CGRectMake(47  + 14, nameTextStorage.bottom + 6, SCREEN_WIDTH - 57, [contentTextStorage.text sizeWithAttributes:contentAttrs].height + 20)];
        }else{
            [wrapImage setFrame:CGRectMake(47 + 14, nameTextStorage.bottom + 6, [contentTextStorage.text sizeWithAttributes:contentAttrs].width + 20, [contentTextStorage.text sizeWithAttributes:contentAttrs].height + 16)];
        }
        
        [container addStorage:wrapImage];
        
//        UIImage *intevalImage = [[ZJBHelp getInstance] buttonImageFromColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"] WithFrame:CGRectMake(0, 0, 10, 1)];
//        LWImageStorage *intevalStorage1;
//        intevalStorage1 = [[LWImageStorage alloc]init];
//        intevalStorage1.type = LWImageStorageLocalImage;
//        intevalStorage1.image = intevalImage;
//        intevalStorage1.frame = CGRectMake(0, contentTextStorage.bottom + 10, SCREEN_WIDTH, 1);
//        [container addStorage:intevalStorage1];
        self.cellHeight = wrapImage.bottom + 10;
        
        
    }
    return self;
    
}

@end
