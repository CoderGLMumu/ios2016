//
//  BanSpeakVC.m
//  JZBRelease
//
//  Created by zjapple on 16/8/15.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "BanSpeakVC.h"
#import "BanSpeakCell.h"
#import "SendAndGetDataFromNet.h"

@interface BanSpeakVC ()

/** 是否禁言 */
@property (nonatomic, assign) BOOL isBan;

@end

@implementation BanSpeakVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isBan = NO;
    
    /** 去除多余的分割线 */
    self.tableView.tableFooterView = [[UIImageView alloc]init];
    
    [self setuptitleView];
}

- (void)setuptitleView
{
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.glw_width - 112 * 2, 40)];
    titleLable.text = @"禁言列表";
    titleLable.textColor = [UIColor hx_colorWithHexRGBAString:@"ffffff"];
    titleLable.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLable;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    /** 全部列表页面的空数据占位图片 */
    notDataShowView *view;
    
    if (self.dataSource.count) {
        if ([notDataShowView sharenotDataShowView].superview) {
            [[notDataShowView sharenotDataShowView] removeFromSuperview];
        }
    }else {
        view = [notDataShowView sharenotDataShowView:tableView];
        [tableView addSubview:view];
        
    }
    
    return self.dataSource.count;
}


- (BanSpeakCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BanSpeakCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BanSpeakCell" forIndexPath:indexPath];
    
    NSString *nickName= self.dataSource[indexPath.row];
    NSDictionary *dictT= self.imgDataSource[indexPath.row];
    NSString *user_str = self.uids[indexPath.row];
//    NSLog(@"gaolinttttasdfa%@",dictT[nickName]);
    
    [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:dictT[nickName]] placeholderImage:[UIImage imageNamed:@"ZCCG_TX"]];
    
    cell.nickNameLabel.text = nickName;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.isBan = [defaults boolForKey:[NSString stringWithFormat:@"JY%@",nickName]];
    
    if (self.isBan) {
        cell.banSpeakSwitch.on = YES;
    }else {
        cell.banSpeakSwitch.on = NO;
    }
    
    cell.banSwValueChange = ^(BOOL isOn){
        
//        禁言/取消
//        接口：/Web/Circle/forbid
//        参数:access_token,groupid，user_id，forbid
//        返回：是否成功
        
        UserInfo *userInfo = [[LoginVM getInstance]readLocal];
        
        NSDictionary *parameters = @{
                                     @"access_token":userInfo.token,
                                         @"groupid":self.chatGroup.groupId,
                                         @"user_id":user_str,
                                     @"forbid":[NSString stringWithFormat:@"%d",isOn]
                                     };
        
        
        
        [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/Circle/forbid"] parameters:parameters success:^(id json) {
            NSLog(@"Web/Circle/forbid = %@",json);
            
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",json]];
            
        } failure:^(NSError *error) {
            
        }];
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:isOn forKey:[NSString stringWithFormat:@"JY%@",nickName]];
    };
    
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

/** 分隔线左对齐 */
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }

    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
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
