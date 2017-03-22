//
//  ActivityLayout.m
//  JZBRelease
//
//  Created by cl z on 16/8/12.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "ActivityLayout.h"
#import "DealNormalUtil.h"
#import "LWConstraintManager.h"
#import "LocalDataRW.h"
@implementation ActivityLayout

- (id)initWithContainer:(LWStorageContainer *)container
                  Model:(ActivityModel *)activityModel
          dateFormatter:(NSDateFormatter *)dateFormatter
                  index:(NSInteger)index{
    self = [super initWithContainer:container];
    if (self) {
        self.activityModel = activityModel;
        
        
        
        
        
        
        UIImage *intevalImage = [[ZJBHelp getInstance] buttonImageFromColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Inteval_Color" WithKind:XMLTypeColors]] WithFrame:CGRectMake(0, 0, 10, 10)];
       // UIImage *intevalImage0 = [[ZJBHelp getInstance] buttonImageFromColor:[UIColor lightGrayColor] WithFrame:CGRectMake(0, 0, 10, 10)];
        //头像模型 avatarImageStorage
        LWImageStorage* avatarStorage = [[LWImageStorage alloc] init];
        avatarStorage.type = LWImageStorageWebImage;
        //  dispatch_async(dispatch_queue_create("", nil), ^{
        UIImage *image = nil;
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:activityModel.user.avatar]]]];
        
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
        avatarStorage.masksToBounds = NO;
        
        //名字模型 nameTextStorage
        LWTextStorage* nameTextStorage = [[LWTextStorage alloc] init];
        
        nameTextStorage.text = activityModel.user.nickname;
        nameTextStorage.font = [UIFont systemFontOfSize:activityModel.fontSize / 1.0625];
        nameTextStorage.textAlignment = NSTextAlignmentLeft;
        nameTextStorage.linespace = 2.0f;
        nameTextStorage.textColor = [ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]];
        NSDictionary *nameAttrs = @{NSFontAttributeName:nameTextStorage.font};
        nameTextStorage.clink_type = Clink_Type_One;
        [nameTextStorage addLinkWithData:nameTextStorage.text
                                 inRange:NSMakeRange(0,nameTextStorage.text.length)
                               linkColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]]
                          highLightColor:[UIColor clearColor]
                          UnderLineStyle:NSUnderlineStyleNone];
        
        
        //模型 公司职位
        LWTextStorage* companyPositionStorage = [[LWTextStorage alloc] init];
        NSString *companyText;
        
        if (activityModel.user.company && activityModel.user.job) {
            companyText = [activityModel.user.company stringByAppendingString: activityModel.user.job];
        }else if (activityModel.user.company){
            companyText = activityModel.user.company;
        }else{
            companyText = activityModel.user.job;
        }
        
        companyPositionStorage.text = companyText;
        companyPositionStorage.font = [UIFont systemFontOfSize:activityModel.fontSize / 1.214];
        companyPositionStorage.textAlignment = NSTextAlignmentLeft;
        companyPositionStorage.linespace = 2.0f;
        UIColor *color = [UIColor colorWithRed:76.0 / 255.0 green:76.0 / 255.0 blue:76.0 / 255.0 alpha:1];
        companyPositionStorage.textColor = color;
        NSDictionary *companyAttrs = @{NSFontAttributeName:companyPositionStorage.font};
        
        
        //分隔竖线
        LWTextStorage *intevalColumStorage = [[LWTextStorage alloc] init];
        intevalColumStorage.text = @"|";
        intevalColumStorage.font = [UIFont systemFontOfSize:activityModel.fontSize / 1.4166];
        [intevalColumStorage setTextColor:[UIColor colorWithRed:153.0 / 255.0 green:153.0 / 255.0 blue:153.0 / 255.0 alpha:1]];
        intevalColumStorage.textAlignment = NSTextAlignmentCenter;
        //intevalColumStorage.veriticalAlignment = LWVerticalAlignmentCenter;
        
        //模型 VIP等级
        LWImageStorage* vipImageStorage = [[LWImageStorage alloc] init];
        vipImageStorage.type = LWImageStorageWebImage;
        if (!activityModel.user.level) {
            return self;
        }
        
        vipImageStorage.image = [[DealNormalUtil getInstance]getImageBasedOnName:activityModel.user.level];
        vipImageStorage.cornerBackgroundColor = [UIColor whiteColor];
        vipImageStorage.fadeShow = YES;
        vipImageStorage.masksToBounds = NO;
        
        
        //模型 帮派
        LWTextStorage* gangStorage = [[LWTextStorage alloc] init];
        if (!activityModel.user.gang) {
            gangStorage.text = @"建众帮";
        }else{
            gangStorage.text = activityModel.user.gang;
        }
        gangStorage.font = [UIFont systemFontOfSize:activityModel.fontSize / 1.5];
        gangStorage.textAlignment = NSTextAlignmentLeft;
        gangStorage.linespace = 2.0f;
        gangStorage.textColor = [UIColor lightGrayColor];
        NSDictionary *gangAttrs = @{NSFontAttributeName:companyPositionStorage.font};
        
        //模型 行业
        LWTextStorage* industryStorage = [[LWTextStorage alloc] init];
        if ([activityModel.user.industry isEqualToString:@"nil"]) {
            industryStorage.text = @"IT";
        }else{
            industryStorage.text = activityModel.user.industry;
        }
        industryStorage.font = [UIFont systemFontOfSize:activityModel.fontSize / 1.4166];
        industryStorage.textAlignment = NSTextAlignmentLeft;
        industryStorage.linespace = 2.0f;
        industryStorage.textColor = [UIColor lightGrayColor];
        NSDictionary *industryAttrs = @{NSFontAttributeName:companyPositionStorage.font};
        
        
        /***********************************  设置约束 自动布局 *********************************************/
        
        [LWConstraintManager lw_makeConstraint:avatarStorage.constraint.leftMargin(1.7 * activityModel.inteval).topMargin(0.9 * activityModel.inteval).widthLength(activityModel.avatarWidth).heightLength(activityModel.avatarWidth)];
        [LWConstraintManager lw_makeConstraint:nameTextStorage.constraint.leftMarginToStorage(avatarStorage,0.9 * activityModel.inteval).topMargin(1.2 * activityModel.inteval).widthLength([nameTextStorage.text sizeWithAttributes:nameAttrs].width + activityModel.inteval).heightLength([nameTextStorage.text sizeWithAttributes:nameAttrs].height)];
//        [LWConstraintManager lw_makeConstraint:intevalColumStorage.constraint.leftMarginToStorage(nameTextStorage,0).topMargin(nameTextStorage.frame.origin.y).widthLength(activityModel.inteval * 1.8).heightLength([nameTextStorage.text sizeWithAttributes:nameAttrs].height)];
        [intevalColumStorage setFrame:CGRectMake(nameTextStorage.right, nameTextStorage.center.y - [intevalColumStorage.text sizeWithAttributes:industryAttrs].height / 2, activityModel.inteval * 2, [intevalColumStorage.text sizeWithAttributes:industryAttrs].height)];
        [LWConstraintManager lw_makeConstraint:companyPositionStorage.constraint.leftMarginToStorage(intevalColumStorage,0).topMargin(nameTextStorage.frame.origin.y + ([activityModel.user.nickname sizeWithAttributes:nameAttrs].height - [companyPositionStorage.text sizeWithAttributes:companyAttrs].height) / 2).widthLength([companyPositionStorage.text sizeWithAttributes:companyAttrs].width).heightLength([companyPositionStorage.text sizeWithAttributes:companyAttrs].height)];
        [LWConstraintManager lw_makeConstraint:vipImageStorage.constraint.leftMarginToStorage(companyPositionStorage,0).topMargin(companyPositionStorage.frame.origin.y).widthLength([nameTextStorage.text sizeWithAttributes:nameAttrs].height).heightLength([nameTextStorage.text sizeWithAttributes:nameAttrs].height)];
        //        [LWConstraintManager lw_makeConstraint:otherPositionStorage.constraint.leftMargin(SCREEN_WIDTH - 18 - 2 * activityModel.inteval).topMargin(companyPositionStorage.frame.origin.y).widthLength(18).heightLength(17)];
        //        self.commentPosition = otherPositionStorage.frame;
        [LWConstraintManager lw_makeConstraint:gangStorage.constraint.leftEquelToStorage(nameTextStorage).topMarginToStorage(nameTextStorage,0.5 * activityModel.inteval).widthLength([gangStorage.text sizeWithAttributes:gangAttrs].width).heightLength([gangStorage.text sizeWithAttributes:gangAttrs].height)];
        [LWConstraintManager lw_makeConstraint:industryStorage.constraint.leftMarginToStorage(gangStorage,activityModel.inteval).topMarginToStorage(nameTextStorage,0.9 * activityModel.inteval).widthLength([activityModel.user.industry sizeWithAttributes:industryAttrs].width).heightLength([activityModel.user.industry sizeWithAttributes:industryAttrs].height)];
        self.avatarPosition1 = avatarStorage.frame;
        [container addStorage:avatarStorage];
        [container addStorage:nameTextStorage];
        [container addStorage:intevalColumStorage];
        [container addStorage:companyPositionStorage];
        [container addStorage:vipImageStorage];
        [container addStorage:gangStorage];
        [container addStorage:industryStorage];
        
        LWImageStorage* banarStorage = [[LWImageStorage alloc] init];
        banarStorage.type = LWImageStorageLocalImage;
        dispatch_async(dispatch_queue_create("", nil), ^{
            UIImage *banarImage = [LocalDataRW getImageWithDirectory:Directory_BB RetalivePath:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:activityModel.activity_banner]];
            dispatch_async(dispatch_get_main_queue(), ^{
                int height = SCREEN_WIDTH * (((float)banarImage.size.height) / ((float)banarImage.size.width));
                int oheight = SCREEN_HEIGHT / 3;
                CGRect newRect;
                if (height > oheight) {
                    newRect = CGRectMake(0, avatarStorage.bottom + activityModel.inteval, SCREEN_WIDTH, oheight);
                }else{
                    newRect = CGRectMake(0, avatarStorage.bottom + activityModel.inteval, SCREEN_WIDTH, height);
                }
            
                [banarStorage setFrame:newRect];
                [banarStorage setImage:banarImage];
                self.banaerPosition = banarStorage.frame;
                [container addStorage:banarStorage];
                
                //模型 行业
                LWTextStorage* titleStorage = [[LWTextStorage alloc] init];
                if (!activityModel.activity_title || [activityModel.activity_title isEqualToString:@"nil"]) {
                    titleStorage.text = @"IT";
                }else{
                    titleStorage.text = activityModel.activity_title;
                }
                titleStorage.font = [UIFont systemFontOfSize:activityModel.fontSize * 1.1];
                titleStorage.textAlignment = NSTextAlignmentLeft;
                titleStorage.veriticalAlignment = LWVerticalAlignmentCenter;
                titleStorage.linespace = 3.0f;
                titleStorage.textColor = [UIColor colorWithRed:76.0 / 255.0 green:76.0 / 255.0 blue:76.0 / 255.0 alpha:1];
                NSDictionary *titleValueAttrs = @{NSFontAttributeName:titleStorage.font};
                [titleStorage setFrame:CGRectMake(1.7 * activityModel.inteval, banarStorage.bottom + 2 * activityModel.inteval , SCREEN_WIDTH - 3 * activityModel.inteval, [titleStorage.text sizeWithAttributes:titleValueAttrs].height)];
                [container addStorage:titleStorage];
                
//                LWImageStorage *intevalStorage0;
//                intevalStorage0 = [[LWImageStorage alloc]init];
//                intevalStorage0.type = LWImageStorageLocalImage;
//                intevalStorage0.image = intevalImage0;
//                intevalStorage0.frame = CGRectMake(1.7 * activityModel.inteval, titleStorage.bottom + 3 * activityModel.inteval, SCREEN_WIDTH - 2 * 1.7 * activityModel.inteval, 0.3f);
//                [container addStorage:intevalStorage0];
//                
                
                LWImageStorage *timeStorage = [[LWImageStorage alloc]init];
                timeStorage.type = LWImageStorageLocalImage;
                timeStorage.image = [UIImage imageNamed:@"bangba_activity_time"];
                timeStorage.frame = CGRectMake(1.7 * activityModel.inteval, titleStorage.bottom + 1.6 * activityModel.inteval, 14, 14);
                [container addStorage:timeStorage];
                
                LWTextStorage* timeValueStorage = [[LWTextStorage alloc] init];
                NSTimeInterval time=[activityModel.activity_start_date doubleValue] + 28800;
                timeValueStorage.text = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
                timeValueStorage.font = [UIFont systemFontOfSize:activityModel.fontSize / 1.214];
                timeValueStorage.textAlignment = NSTextAlignmentLeft;
                timeValueStorage.linespace = 2.0f;
                timeValueStorage.textColor = RGB(142, 142, 147, 1);
                 NSDictionary *timeValueAttrs = @{NSFontAttributeName:timeValueStorage.font};
                [timeValueStorage setFrame:CGRectMake(1.7 * activityModel.inteval + 0.5 * activityModel.inteval + 14, titleStorage.bottom + 1.6 * activityModel.inteval, 200, [timeValueStorage.text sizeWithAttributes:timeValueAttrs].height)];
                [container addStorage:timeValueStorage];
                
                LWTextStorage* fateValueStorage = [[LWTextStorage alloc] init];
                if (!activityModel.activity_score || [activityModel.activity_score isEqualToString:@"nil"] || [activityModel.activity_score integerValue] == 0) {
                    fateValueStorage.text = @"免费";
                }else{
                    fateValueStorage.text = activityModel.activity_score;
                }
                
                fateValueStorage.font = [UIFont systemFontOfSize:activityModel.fontSize * 1.1];
                fateValueStorage.textAlignment = NSTextAlignmentLeft;
                fateValueStorage.textColor = [UIColor colorWithRed:234.0 / 255.0 green:128.0 / 255.0 blue:17.0 / 255.0 alpha:1];
                NSDictionary *fateValueAttrs = @{NSFontAttributeName:fateValueStorage.font};
                [fateValueStorage setFrame:CGRectMake(SCREEN_WIDTH -  1.7 * activityModel.inteval - [fateValueStorage.text sizeWithAttributes:fateValueAttrs].width , timeValueStorage.top, [fateValueStorage.text sizeWithAttributes:fateValueAttrs].width + activityModel.inteval, [fateValueStorage.text sizeWithAttributes:fateValueAttrs].height)];
                [container addStorage:fateValueStorage];
                
                LWImageStorage *fateStorage = [[LWImageStorage alloc]init];
                fateStorage.type = LWImageStorageLocalImage;
                fateStorage.image = [UIImage imageNamed:@"grzx_questions_edit_jf"];
                fateStorage.frame = CGRectMake(fateValueStorage.left - 0.5 * activityModel.inteval - 20,timeStorage.top, 20, 18);
                [container addStorage:fateStorage];
                
                LWImageStorage *addressStorage = [[LWImageStorage alloc]init];
                addressStorage.type = LWImageStorageLocalImage;
                addressStorage.image = [UIImage imageNamed:@"bangba_activity_address"];
                addressStorage.frame = CGRectMake(1.7 * activityModel.inteval, timeStorage.bottom + 1 * activityModel.inteval, 14, 14);
                [container addStorage:addressStorage];
                
                LWTextStorage* addressValueStorage = [[LWTextStorage alloc] init];
                addressValueStorage.text = activityModel.activity_address;
                addressValueStorage.font = [UIFont systemFontOfSize:activityModel.fontSize / 1.4166];
                addressValueStorage.textAlignment = NSTextAlignmentLeft;
                addressValueStorage.linespace = 2.0f;
                addressValueStorage.textColor = RGB(142, 142, 147, 1);
                [addressValueStorage setFrame:CGRectMake(1.7 * activityModel.inteval + 0.5 * activityModel.inteval + 14, timeStorage.bottom + 1 * activityModel.inteval, SCREEN_WIDTH - (2 * 1.7 * activityModel.inteval + 0.5 * activityModel.inteval + 14 ), 14)];
                [container addStorage:addressValueStorage];
                
                LWImageStorage *intevalStorage;
                intevalStorage = [[LWImageStorage alloc]init];
                intevalStorage.type = LWImageStorageLocalImage;
                intevalStorage.image = intevalImage;
                intevalStorage.frame = CGRectMake(0, addressValueStorage.bottom + 1.5 * activityModel.inteval, SCREEN_WIDTH, 1.6 * activityModel.inteval);
                [container addStorage:intevalStorage];
                
                self.cellHeight = intevalStorage.bottom;
           });
         });
    }
    return self;
}

@end
