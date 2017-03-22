

#import "UIView+BCHActionSheet.h"
#import <objc/runtime.h>
#import "NSArray+BCHHelperKit.h"
static const void *s_bch_actionSheetBlockKey = "s_bch_actionSheetBlockKey";

@interface UIApplication (BCHActionSheet) <UIActionSheetDelegate>
@end
@implementation UIApplication (BCHActionSheet)
- (void)actionSheet:(nonnull UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.bch_actionSheetBlock) {
        actionSheet.bch_actionSheetBlock(actionSheet, buttonIndex);
    }
}
@end

@implementation UIView (BCHActionSheet)
#pragma mark - setter / getter
-(BCHActionSheetBlock)bch_actionSheetBlock{
    return objc_getAssociatedObject(self, s_bch_actionSheetBlockKey);
}

-(void)setBch_actionSheetBlock:(BCHActionSheetBlock)bch_actionSheetBlock{
    objc_setAssociatedObject(self, s_bch_actionSheetBlockKey, bch_actionSheetBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)bch_showWithTitle:(NSString *)title
                   cancelTitle:(NSString *)cancelTitle
              destructiveTitle:(NSString *)destructiveTitle
                   otherTitles:(NSArray *)otherTitles
                      callback:(BCHActionSheetBlock)callback{
    float iOSVersion = [[UIDevice currentDevice].systemVersion floatValue];
    if (iOSVersion < 8.0f){
        UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:title
                                                        delegate:[UIApplication sharedApplication]
                                               cancelButtonTitle:cancelTitle
                                          destructiveButtonTitle:destructiveTitle
                                               otherButtonTitles:
                             [otherTitles bch_objectAtIndex:0],
                             [otherTitles bch_objectAtIndex:1],
                             [otherTitles bch_objectAtIndex:2],
                             [otherTitles bch_objectAtIndex:3],
                             [otherTitles bch_objectAtIndex:4],
                             [otherTitles bch_objectAtIndex:5],
                             [otherTitles bch_objectAtIndex:6],
                             [otherTitles bch_objectAtIndex:7],
                             [otherTitles bch_objectAtIndex:8],
                             [otherTitles bch_objectAtIndex:9],
                             [otherTitles bch_objectAtIndex:10],
                             [otherTitles bch_objectAtIndex:11],
                             [otherTitles bch_objectAtIndex:12],
                             [otherTitles bch_objectAtIndex:13],
                             [otherTitles bch_objectAtIndex:14],
                             [otherTitles bch_objectAtIndex:15],
                             [otherTitles bch_objectAtIndex:16],
                             [otherTitles bch_objectAtIndex:17],
                             [otherTitles bch_objectAtIndex:18],
                             [otherTitles bch_objectAtIndex:19],
                             [otherTitles bch_objectAtIndex:20],
                             [otherTitles bch_objectAtIndex:21],
                             [otherTitles bch_objectAtIndex:22],
                             [otherTitles bch_objectAtIndex:23],
                             [otherTitles bch_objectAtIndex:24],
                             [otherTitles bch_objectAtIndex:25],
                             [otherTitles bch_objectAtIndex:26],
                             [otherTitles bch_objectAtIndex:27],
                             [otherTitles bch_objectAtIndex:28],
                             [otherTitles bch_objectAtIndex:29],nil];
        as.bch_actionSheetBlock = callback;
        [as showInView:[UIApplication sharedApplication].keyWindow];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        NSMutableArray *buttonTitles = [NSMutableArray arrayWithArray:otherTitles];
        if (destructiveTitle) {
            [buttonTitles insertObject:destructiveTitle atIndex:0];
        }
        if (cancelTitle) {
            [buttonTitles addObject:cancelTitle];
        }
        
        
        for (int i = 0; i < buttonTitles.count; i++) {
            UIAlertAction *action = action = [UIAlertAction actionWithTitle:buttonTitles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (callback) {
                    callback(action,i);
                }
            }];
            if (i == 0) {
                action = [UIAlertAction actionWithTitle:buttonTitles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if (callback) {
                        callback(action,i);
                    }
                }];
            }
            if (buttonTitles.count >= 1 && (i == buttonTitles.count - 1)) {
                action = [UIAlertAction actionWithTitle:buttonTitles[i] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    if (callback) {
                        callback(action,i);
                    }
                }];
            }
            
            [alert addAction:action];
        }
        UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        [rootViewController presentViewController:alert animated:YES completion:nil];
    }
}
@end
