

#import <UIKit/UIKit.h>

typedef void(^BCHAlertBlock)(id sender,NSUInteger buttonIndex);

@interface UIView (BCHAlert)

@property (nonatomic,strong) BCHAlertBlock bch_alertBlock; 

+(void)bch_showWithTitle:(NSString *)title
                         message:(NSString *)message
                    buttonTitles:(NSArray *)buttonTitles 
                           callback:(BCHAlertBlock)callback;

@end
