

#import <UIKit/UIKit.h>

typedef void(^BCHAlertControllerClickedButtonBlock)(UIAlertAction *action,NSUInteger buttonIndex);

@interface UIAlertController (BCHHelperKitUIKit)

@property (nonatomic,strong) NSMutableArray *actionArray;

+(instancetype)bch_showWithTitle:(NSString *)title
                         message:(NSString *)message
                    buttonTitles:(NSArray *)buttonTitles
                  preferredStyle:(UIAlertControllerStyle)preferredStyle
                           block:(BCHAlertControllerClickedButtonBlock)block;
@end
