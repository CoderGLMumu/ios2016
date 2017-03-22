

#import "UIAlertController+BCHHelperKitUIKit.h"
#import <objc/runtime.h>

static const void *s_bch_actionArray = "s_bch_actionArray";

@implementation UIAlertController (BCHHelperKitUIKit)
#pragma mark - setter / getter
-(void)setActionArray:(NSMutableArray *)actionArray{
    objc_setAssociatedObject(self, s_bch_actionArray, actionArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSMutableArray *)actionArray{
    return objc_getAssociatedObject(self, s_bch_actionArray);
}

+(instancetype)bch_showWithTitle:(NSString *)title
                         message:(NSString *)message
                    buttonTitles:(NSArray *)buttonTitles
                  preferredStyle:(UIAlertControllerStyle)preferredStyle
                           block:(BCHAlertControllerClickedButtonBlock)block{
    return [self bch_showWithTitle:title message:message preferredStyle:preferredStyle buttonTitles:buttonTitles accessoryImages:nil alertTintColor:nil addAttributes:nil range:NSMakeRange(0, 0) block:block];
}

+(instancetype)bch_showWithTitle:(NSString *)title
                         message:(NSString *)message
                  preferredStyle:(UIAlertControllerStyle)preferredStyle
                    buttonTitles:(NSArray *)buttonTitles
                 accessoryImages:(NSArray *)accessoryImages
                  alertTintColor:(UIColor *)tintColor
                   addAttributes:(NSDictionary *)addAttributes
                           range:(NSRange)range
                           block:(BCHAlertControllerClickedButtonBlock)block{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    
    if (tintColor) {
        alert.view.tintColor = tintColor;
    }
    if (addAttributes) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title];
        [attributedString addAttributes:addAttributes range:range];
        [alert setValue:attributedString forKey:@"attributedTitle"];
    }
    for (int i = 0; i < buttonTitles.count; i++) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:buttonTitles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (block) {
                block(action,i);
            }
        }];
        [alert addAction:action];
        [alert.actionArray addObject:action];
    }
    
    for (int i = 0; i < accessoryImages.count; i++) {
        UIAlertAction *action = alert.actionArray[i];
        [action setValue:[accessoryImages[i] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    }
    
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootViewController presentViewController:alert animated:YES completion:nil];

    return alert;
}

@end
