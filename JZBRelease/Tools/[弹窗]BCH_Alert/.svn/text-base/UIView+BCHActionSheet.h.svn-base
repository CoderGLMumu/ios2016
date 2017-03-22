

#import <UIKit/UIKit.h>

typedef void(^BCHActionSheetBlock)(id sender,NSInteger buttonIndex);

@interface UIView (BCHActionSheet)

@property (nonatomic,strong) BCHActionSheetBlock bch_actionSheetBlock;

+ (void)bch_showWithTitle:(NSString *)title
                   cancelTitle:(NSString *)cancelTitle
              destructiveTitle:(NSString *)destructiveTitle
                   otherTitles:(NSArray *)otherTitles
                      callback:(BCHActionSheetBlock)callback;

@end
