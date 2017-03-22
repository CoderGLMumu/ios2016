




/********************* 有任何问题欢迎反馈给我 liuweiself@126.com ****************************************/
/***************  https://github.com/waynezxcv/Gallop 持续更新 ***************************/
/******************** 正在不断完善中，谢谢~  Enjoy ******************************************************/










#import "LWLayout.h"
#import "StatusModel.h"
#import "DetailListModel.h"
#import "LWTextStorage.h"
/**
 *  要添加一些其他属性，可以继承自LWLayout
 */
@interface CellLayout : LWLayout

@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic,assign) CGRect singleRewardPosition;
@property (nonatomic,assign) CGRect menuPosition;
@property (nonatomic,assign) CGRect commentPosition;
@property (nonatomic,assign) CGRect rewardPosition;
@property (nonatomic,assign) CGRect rewardNumPosition;
@property (nonatomic,assign) CGRect sharePosition;
@property (nonatomic,assign) CGRect goodPosition;
@property (nonatomic,assign) CGRect commentBgPosition;
@property (nonatomic,assign) CGRect avatarPosition;
@property (nonatomic,copy) NSArray* imagePostionArray;
@property (nonatomic,strong) StatusModel* statusModel;

@property (nonatomic,strong) LWTextStorage *commentNumStorage;

@property (nonatomic,assign) BOOL isDynamicDetail;



- (id)initWithContainer:(LWStorageContainer *)container
            statusModel:(StatusModel *)statusModel
                  index:(NSInteger)index
          dateFormatter:(NSDateFormatter *)dateFormatter
            isDynamicDe:(BOOL) iDynamicDe;
@end