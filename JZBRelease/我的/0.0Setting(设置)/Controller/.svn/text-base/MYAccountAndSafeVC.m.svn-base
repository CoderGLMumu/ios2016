//
//  MYAccountAndSafeVC.m
//  JZBRelease
//
//  Created by zjapple on 16/8/23.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "MYAccountAndSafeVC.h"
#import "UserInfo.h"
#import "Users.h"
#import "DataBaseHelperSecond.h"
#import "LewPopupViewAnimationSpring.h"
#import "LewPopupViewAnimationSlide.h"
#import "LewPopupViewAnimationFade.h"

#import "MYAlterEMailPopView.h"
#import "CustomAlertView.h"

@interface MYAccountAndSafeVC ()
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *TelNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *mailboxLabel;

@end

@implementation MYAccountAndSafeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UserInfo *userInfo = [[LoginVM getInstance]readLocal];
    self.accountLabel.text = userInfo.account;
    
    Users *users = [[Users alloc]init];
    users.uid = userInfo._id;
    users = (Users *)[[DataBaseHelperSecond getInstance] getModelFromTabel:users];
    
    self.TelNumLabel.text = users.mobile;
    if ([self.TelNumLabel.text  isEqual: @"nil"]) {
        self.TelNumLabel.text = @"未绑定";
    }
    
    self.mailboxLabel.text = users.email;
    if ([self.mailboxLabel.text  isEqual: @"nil"]) {
        self.mailboxLabel.text = @"未绑定";
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

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


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountAndSafeCell" forIndexPath:indexPath];
//    
//    
//    
//    return cell;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 &&indexPath.row == 2) {
        MYAlterEMailPopView *myAlterEMailPopView = [MYAlterEMailPopView myAlterEMailPopView];
        
        myAlterEMailPopView.cancelCallback = ^{
            
            [self lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
        };
        
        myAlterEMailPopView.enterCallback = ^(NSString *email){
            
            self.mailboxLabel.text = email;
            
            NSDictionary *parameters = @{
                                         @"access_token":[LoginVM getInstance].readLocal.token,
                                         @"field":@"email",
                                         @"value":email
                                         };
            
            [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/user/update"] parameters:parameters success:^(id json) {
            
            if ([json[@"state"] isEqual:@(0)]) {
                [SVProgressHUD showInfoWithStatus:json[@"info"]];
                return ;
            }
            
                CustomAlertView *alertView = [CustomAlertView defaultCustomAlertView:@"修改邮箱成功"];
                [self lew_presentPopupView:alertView animation:[LewPopupViewAnimationSpring new]];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
                });
                
            } failure:^(NSError *error) {
                
            }];
            
        };
        
        [self lew_presentPopupView:myAlterEMailPopView animation:[LewPopupViewAnimationSpring new] dismissed:^{
//            NSLog(@"11111111111111111111动画结束");
            
        }];
//        myAlterEMailPopView
    }
}


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
