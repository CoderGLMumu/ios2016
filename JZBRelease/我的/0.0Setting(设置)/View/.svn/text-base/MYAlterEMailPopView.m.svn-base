//
//  MYAlterEMailPopView.m
//  JZBRelease
//
//  Created by zjapple on 16/8/23.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "MYAlterEMailPopView.h"
#import "GLGeneralTool.h"

@interface MYAlterEMailPopView () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UITextField *eMailTF;

/** email */
@property (nonatomic, strong) NSString *email;

@end

@implementation MYAlterEMailPopView

+ (instancetype)myAlterEMailPopView
{
   return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]firstObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setUp];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{

    self.layer.cornerRadius = 10;
    self.clipsToBounds = YES;
    self.eMailTF.delegate = self;
}

/** 在UITextField编辑之前调用方法 **/

- (void)textFieldDidBeginEditing:(UITextField*)textField {
    
    // 视图上移
    
    [GLGeneralTool animationOfTextField:textField isUp:YES withDistance:80 inView:self];
    
}

/** 在UITextField编辑完成调用方法 **/

- (void)textFieldDidEndEditing:(UITextField*)textField {
    
    // 视图下移
    
    [GLGeneralTool animationOfTextField:textField isUp:NO withDistance:80 inView:self];
    
}
- (IBAction)clickEnterButton:(UIButton *)sender {
    
    
    if (self.enterCallback) {
        self.enterCallback(self.eMailTF.text);
    }
    
}

- (IBAction)clickCancelButton:(UIButton *)sender {
    
    
    if (self.cancelCallback) {
        self.cancelCallback();
    }
    
}


@end
