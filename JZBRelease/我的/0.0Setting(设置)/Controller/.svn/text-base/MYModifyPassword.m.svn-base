//
//  MYModifyPassword.m
//  JZBRelease
//
//  Created by zjapple on 16/8/23.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "MYModifyPassword.h"
#import "CustomAlertView.h"
#import "LewPopupViewAnimationSpring.h"

#import "LoginVC.h"

@interface MYModifyPassword ()

@property (weak, nonatomic) IBOutlet UIButton *ConfirmButton;
@property (weak, nonatomic) IBOutlet UITextField *CurrentPassWorkTF;
@property (weak, nonatomic) IBOutlet UITextField *NewPassWordTF;
@property (weak, nonatomic) IBOutlet UITextField *ConfirmPassWorkTF;

@end

@implementation MYModifyPassword

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
}

- (void)setUpView
{
    self.ConfirmButton.layer.cornerRadius = 25;
    self.ConfirmButton.clipsToBounds = YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 21;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (void)changePasssword
{
    if (!self.NewPassWordTF.text) {
        [SVProgressHUD showInfoWithStatus:@"请输入新密码"];
    }
    
    if (!self.ConfirmPassWorkTF.text) {
        [SVProgressHUD showInfoWithStatus:@"请再次输入新密码"];
    }
    
    if (![self.NewPassWordTF.text isEqualToString:self.ConfirmPassWorkTF.text]) {
        [SVProgressHUD showInfoWithStatus:@"两次输入密码不一致,请重新输入"];
    }
    
    CustomAlertView *alertView = [CustomAlertView defaultCustomAlertView:@"修改密码..."];
    [self lew_presentPopupView:alertView animation:[LewPopupViewAnimationSpring new]];
    
    NSDictionary *parameters = @{
                                 @"access_token":[LoginVM getInstance].readLocal.token,
                                 @"field":@"password",
                                 @"password":self.CurrentPassWorkTF.text,
                                 @"newpassword":self.NewPassWordTF.text,
                                 @"renewpassword":self.ConfirmPassWorkTF.text
                                 };
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/user/update"] parameters:parameters success:^(id json) {
        
        if ([json[@"state"] isEqual:@(0)]) {
            [self lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
            [SVProgressHUD showInfoWithStatus:json[@"info"]];
            return ;
        }
        
        CustomAlertView *alertView = [CustomAlertView defaultCustomAlertView:@"修改密码成功,请重新登录"];
        [self lew_presentPopupView:alertView animation:[LewPopupViewAnimationSpring new]];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
            
            LoginVC *loginVC = [[LoginVC alloc]init];
            
            loginVC.isClearPassword = YES;
            [self.navigationController pushViewController:loginVC animated:YES];
        });
        
    } failure:^(NSError *error) {
        
    }];

}

- (IBAction)clickEnterButton:(UIButton *)sender {
    
    [self changePasssword];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
