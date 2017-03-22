




/********************* 有任何问题欢迎反馈给我 liuweiself@126.com ****************************************/
/***************  https://github.com/waynezxcv/Gallop 持续更新 ***************************/
/******************** 正在不断完善中，谢谢~  Enjoy ******************************************************/









#import "CellLayout.h"
#import "LWTextParser.h"
#import "LWStorage+Constraint.h"
#import "LWConstraintManager.h"
#import "CommentModel.h"
#import "LWDefine.h"
#import "Defaults.h"
#import "EvaluateModel.h"
#import "ZJBHelp.h"
#import "DealNormalUtil.h"
#import "LocalDataRW.h"
#define REWARD_WIDTH 61
#define REWARD_HEIGHT 61

@implementation CellLayout
@synthesize commentNumStorage;
- (id)initWithContainer:(LWStorageContainer *)container
            statusModel:(StatusModel *)statusModel
                  index:(NSInteger)index
          dateFormatter:(NSDateFormatter *)dateFormatter
            isDynamicDe:(BOOL) iDynamicDe{
    self = [super initWithContainer:container];
    if (self) {
        /****************************生成Storage 相当于模型*************************************/
        /*********LWAsyncDisplayView用将所有文本跟图片的模型都抽象成LWStorage，方便你能预先将所有的需要计算的布局内容直接缓存起来***/
        /*******而不是在渲染的时候才进行计算*******************************************/
        self.statusModel = statusModel;
        self.isDynamicDetail = iDynamicDe;
       
        
        //正文内容模型 contentTextStorage
        LWTextStorage* contentTextStorage = [[LWTextStorage alloc] init];
        UIFont *font = [UIFont systemFontOfSize:statusModel.fontSize / 1.0625];
        NSDictionary *contentAttrs = @{NSFontAttributeName:font};
        int rowwidth = SCREEN_WIDTH - statusModel.avatarWidth - 4 * statusModel.inteval;
        int sum = 0;
        int k = 0;
        if (self.isDynamicDetail) {
            contentTextStorage.text = statusModel.content;
        }else{
            if (statusModel.describe.length * 12 > rowwidth * 3) {
                while (sum < rowwidth * 3 && k < statusModel.describe.length) {
                    NSString *singleS = [statusModel.describe substringWithRange:NSMakeRange(k, 1)];
                    k ++;
                    CGSize s1=[singleS sizeWithAttributes:contentAttrs];
                    sum += s1.width;
                }
                NSString *describe = [NSString stringWithFormat:@"%@...",[statusModel.describe substringToIndex:k]];
                contentTextStorage.text = describe;
            }else{
                contentTextStorage.text = statusModel.describe;
            }
        }
        contentTextStorage.font = [UIFont systemFontOfSize:statusModel.fontSize / 1.214];
        if (self.isDynamicDetail) {
            
        }
        contentTextStorage.textColor = [UIColor hx_colorWithHexRGBAString:@"212121"];
        contentTextStorage.linespace = 2.0f;
        contentTextStorage.clink_type = Clink_Type_Two;
        
        [contentTextStorage setFrame:CGRectMake(62, 2 * statusModel.inteval, SCREEN_WIDTH - 82, [contentTextStorage.text sizeWithAttributes:contentAttrs].height)];
        [container addStorage:contentTextStorage];
   
        
        //发布的图片模型 imgsStorage
        NSInteger imageCount = [statusModel.images count];
        NSMutableArray* imageStorageArray = [[NSMutableArray alloc] initWithCapacity:imageCount];
        NSMutableArray* imagePositionArray = [[NSMutableArray alloc] initWithCapacity:imageCount];
        NSInteger row = 0;
        NSInteger column = 0;
        int imageWidth = (SCREEN_WIDTH - 124 - 10) / 3;
        for (NSInteger i = 0; i < statusModel.images.count; i ++) {
            LWImageStorage* imageStorage = [[LWImageStorage alloc] init];
            
            /***********************************/
            NSString *absolutePath = [ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort];
            NSString* URLString = [absolutePath stringByAppendingPathComponent:[statusModel.images objectAtIndex:i]];
            NSLog(@"[statusModel.images objectAtIndex:i] is %@",[statusModel.images objectAtIndex:i]);
            //imageStorage.URL = [NSURL URLWithString:URLString];
            // dispatch_async(dispatch_queue_create("", nil), ^{
            UIImage *image = [LocalDataRW getImageWithDirectory:Directory_BQ RetalivePath:URLString];
            if (!image) {
                image = [UIImage imageNamed:@"WD_pic"];
            }
            
            CGRect imageRect;
            if (statusModel.images.count == 1) {
                imageRect = CGRectMake(62 , contentTextStorage.bottom + statusModel.inteval * 2 +  (row * (imageWidth + 5)), 1.5 * statusModel.imageWidth,1.5 * statusModel.imageWidth * image.size.height / image.size.width);
                imageStorage.frame = imageRect;
            }else{
                imageRect = CGRectMake(62 + (column * (imageWidth + 5)) , contentTextStorage.bottom + statusModel.inteval * 2 +  (row * (imageWidth + 5)), imageWidth,imageWidth);
                imageStorage.frame = imageRect;
                image = [ZJBHelp handleImage:image withSize:imageStorage.frame.size withFromStudy:NO];
            }
            NSString* imagePositionString = NSStringFromCGRect(imageRect);
            [imagePositionArray addObject:imagePositionString];
            /***************** 也可以不使用设置约束的方式来布局，而是直接设置frame属性的方式来布局*************************************/
            
            [imageStorage setImage:image];
            imageStorage.type = LWImageStorageLocalImage;
            imageStorage.fadeShow = YES;
            imageStorage.masksToBounds = YES;
            imageStorage.contentMode = kCAGravityResizeAspect;
            
            [imageStorageArray addObject:imageStorage];
            
            column = column + 1; 
            if (column > 2) {
                column = 0;
                row = row + 1;
            }
        }
        self.imagePostionArray = imagePositionArray;
        
        [container addStorages:imageStorageArray];
       
        //获取最后一张图片的模型
        LWImageStorage* lastImageStorage = (LWImageStorage *)[imageStorageArray lastObject];
        
        LWTextStorage* adressTextStorage;
        if (statusModel.address && statusModel.address.length > 0) {
            
            LWImageStorage *adressImageStorage = [[LWImageStorage alloc]init];
            adressImageStorage.type = LWImageStorageLocalImage;
            adressImageStorage.image = [UIImage imageNamed:@"BQDT__DW"];
            
            adressTextStorage = [[LWTextStorage alloc] init];
            adressTextStorage.text = statusModel.address;
            adressTextStorage.font = [UIFont systemFontOfSize:statusModel.fontSize / 1.4166];
            adressTextStorage.textColor = [UIColor lightGrayColor];
            adressTextStorage.numberOfLines = 1;
            NSDictionary *dateAttrs = @{NSFontAttributeName:adressTextStorage.font};
            if (statusModel.images && statusModel.images.count > 0) {
                [adressImageStorage setFrame:CGRectMake(62, lastImageStorage.bottom + statusModel.inteval * 2, 12.5, 14)];
                adressTextStorage.frame = CGRectMake(adressImageStorage.right + 5, lastImageStorage.bottom + 1.8 * statusModel.inteval, SCREEN_WIDTH - 62 - 5 - 20, [adressTextStorage.text sizeWithAttributes:dateAttrs].height);
            }else{
                [adressImageStorage setFrame:CGRectMake(62, contentTextStorage.bottom + statusModel.inteval * 1, 12.5, 14)];
                adressTextStorage.frame = CGRectMake(adressImageStorage.right + 5, contentTextStorage.bottom +  0.8 * statusModel.inteval, SCREEN_WIDTH - 62 - 5 - 20, [adressTextStorage.text sizeWithAttributes:dateAttrs].height);
            }
            [container addStorage:adressImageStorage];
            [container addStorage:adressTextStorage];
        }
        
        //生成时间的模型 dateTextStorage
        LWTextStorage* dateTextStorage = [[LWTextStorage alloc] init];
        long long int date1 = (long long int)[statusModel.create_time intValue];
        NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:date1];
        dateTextStorage.text = [[statusModel class] compareCurrentTime:date2];
        
         NSLog(@"%@",dateTextStorage.text);
        dateTextStorage.font = [UIFont systemFontOfSize:statusModel.fontSize / 1.545];
        dateTextStorage.textColor = [UIColor lightGrayColor];
        dateTextStorage.numberOfLines = 1;
        NSDictionary *dateAttrs = @{NSFontAttributeName:dateTextStorage.font};
        if (adressTextStorage) {
            dateTextStorage.frame = CGRectMake(62, adressTextStorage.bottom +  1 * statusModel.inteval, [dateTextStorage.text sizeWithAttributes:dateAttrs].width + statusModel.inteval, [dateTextStorage.text sizeWithAttributes:dateAttrs].height);
        }else{
            if (statusModel.images && statusModel.images.count > 0) {
                dateTextStorage.frame = CGRectMake(62, lastImageStorage.bottom + 2 * statusModel.inteval, [dateTextStorage.text sizeWithAttributes:dateAttrs].width + statusModel.inteval, [dateTextStorage.text sizeWithAttributes:dateAttrs].height);
            }else{
                dateTextStorage.frame = CGRectMake(62, contentTextStorage.bottom +  2 * statusModel.inteval, [dateTextStorage.text sizeWithAttributes:dateAttrs].width + statusModel.inteval, [dateTextStorage.text sizeWithAttributes:dateAttrs].height);
            }
        }
        [container addStorage:dateTextStorage];
        
        UIImage *intevalImage = [[ZJBHelp getInstance] buttonImageFromColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"] WithFrame:CGRectMake(0, 0, 10, 1)];
        LWImageStorage *intevalStorage;
        intevalStorage = [[LWImageStorage alloc]init];
        intevalStorage.type = LWImageStorageLocalImage;
        intevalStorage.image = intevalImage;
        intevalStorage.frame = CGRectMake(0, dateTextStorage.bottom + 11, SCREEN_WIDTH, 1);
        [container addStorage:intevalStorage];
        
        self.cellHeight = intevalStorage.bottom;
    }
    return self;
}

@end
