//
//  WDBDetailVC.m
//  MyBang
//
//  Created by mac on 16/10/4.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "WDBDetailVC.h"
#import "WDBDetailItem.h"
#import "WDBDetailCell.h"
#import "WDBmember.h"

#import "AllMemberListVC.h"

#import "UIImageView+CreateImageView.h"
#import "PublicOtherPersonVC.h"

@interface WDBDetailVC ()

/** 数据源 */
@property (nonatomic, strong) NSArray *dataSource;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *like_countLabel;
@property (weak, nonatomic) IBOutlet UILabel *allMemberCountLabel;
@property (nonatomic, strong) WDBDetailItem *item;
@property (weak, nonatomic) IBOutlet UILabel *bangNameLabel;
//@property (weak, nonatomic) IBOutlet UIButton *careButton;
@property (weak, nonatomic) IBOutlet UIView *TtableViewHeaderView;
@property (weak, nonatomic) IBOutlet UIButton *zkqbButton;

@property (weak, nonatomic) UIButton *applic;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
/** btn */
//@property (nonatomic, strong) void(^pushButton)(UIButton *btn) ;
@property (weak, nonatomic) IBOutlet UIView *botViewFengexian;

@end

@implementation WDBDetailVC

- (void)viewDidLoad {
    
    self.title = self.fromItem.name;
    
    self.tableView.bounces = NO;
    
    self.view.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f8f8f8"];
    
    [super viewDidLoad];
    
    [self downLoadData];
    
    [self configNav];
    
    [self setupBotView];
}

#pragma mark - Nav按钮 and title
-(void)configNav
{
    //11 20
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11 + 5 + 40, 35)];
    UIImageView *backImageView = [UIImageView createImageViewWithFrame:CGRectMake(0, (35-20)/2, 20, 20) ImageName:@"DL_light_ARROW"];
    backImageView.userInteractionEnabled = YES;
    [backView addSubview:backImageView];

    UIControl *back = [[UIControl alloc] initWithFrame:backView.bounds];
    [back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:back];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
}

- (void) backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupBotView
{
    [self.view layoutIfNeeded];
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setTitle:@"关注" forState:UIControlStateNormal];
    
    [btn1 setTitleColor:[UIColor hx_colorWithHexRGBAString:@"FE9900"] forState:UIControlStateNormal];
    btn1.frame = CGRectMake(0, GLScreenH - 52 - 64, self.view.glw_width * 0.5, 52);
    [self.view addSubview:btn1];
    btn1.backgroundColor = [UIColor whiteColor];
    [btn1 addTarget:self action:@selector(clickCareButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"FE9A01"];
    
    [btn2 setTitle:@"申请加入" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn2.frame = CGRectMake(self.view.glw_width * 0.5, GLScreenH - 52 - 64, self.view.glw_width * 0.5, 52);
    [self.view addSubview:btn2];
    btn2.backgroundColor = [UIColor orangeColor];
    [btn2 addTarget:self action:@selector(clickApplicButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn1 setFont:[UIFont systemFontOfSize:16]];
    [btn2 setFont:[UIFont systemFontOfSize:16]];
    
    if ([self.item.is_like isEqual: @(0)]) {
        [btn1 setTitle:@"关注" forState:UIControlStateNormal];
    }else {
        [btn1 setTitle:@"已关注" forState:UIControlStateNormal];
    }
    
    if ([self.item.is_join isEqual: @(0)]) {
        [btn2 setTitle:@"申请加入" forState:UIControlStateNormal];
    }else {
        [btn2 setTitle:@"进入帮派" forState:UIControlStateNormal];
    }
    
    self.applic = btn2;
    
}

- (void)downLoadData
{
    NSDictionary *parameters = @{
                                 @"access_token":[LoginVM getInstance].readLocal.token,
                                 @"id":self.fromItem.id
                                 };
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/Gang/get"] parameters:parameters success:^(id json) {
        
        if ([json[@"state"] isEqual:@(0)]) {
            [SVProgressHUD show];
        }
        
        self.dataSource = [WDBmember mj_objectArrayWithKeyValuesArray:json[@"data"][@"member"]];
        self.item = [WDBDetailItem mj_objectWithKeyValues:json[@"data"]];
        
        [self.tableView reloadData];
        
        [self setupSubViewData];
        
        //        NSLog(@"TTT--json%@",json);
    } failure:^(NSError *error) {
        
    }];
}

- (void)setupSubViewData
{
//    if ([self.item.is_like isEqual: @(0)]) {
//        [self.careButton setTitle:@"关注" forState:UIControlStateNormal];
//    }else {
//        [self.careButton setTitle:@"已关注" forState:UIControlStateNormal];
//    }
    
    self.title = self.item.name;
    self.bangNameLabel.text = self.item.name;
    
    self.allMemberCountLabel.text = [NSString stringWithFormat:@"全部成员（%@）",self.item.mcount];
    self.like_countLabel.text = [NSString stringWithFormat:@"%@位用户关注",self.item.like_count];
    self.contentLabel.text = self.item.content;
    
//    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[AddHostToLoadPIC AddHostToLoadPICWithString:self.item.thumb]] placeholderImage:[UIImage imageNamed:@"WDB_LOGO"]];
    
    [LocalDataRW getImageWithDirectory:Directory_RM RetalivePath:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:self.item.thumb] WithContainerImageView:self.iconImageView];
    
    if (self.dataSource.count == 0) {
        self.botViewFengexian.hidden = YES;
    }
    
//    self.contentLabel.text = @"123";
//    self.contentLabel.text = @"?????????????????？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？?????????????????？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？?????????????????？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？?????????????????？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？?????????????????？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？?????????????????？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？?????????????????？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？?????????????????？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？?????????????????？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？?????????????????？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？?????????????????？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？?????????????????？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？?????????????????？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？?????????????????？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？";
    

    [self.contentLabel sizeToFit];
    
    if ([self.contentLabel.text isEqualToString:@""]) {
        self.contentLabel.text = @"暂无数据";
    }
    
    [self.view layoutIfNeeded];
    [self.zkqbButton sizeToFit];
    
    self.TtableViewHeaderView.glh_height = self.zkqbButton.gly_y + self.zkqbButton.glh_height;
    
    
    
    CGFloat labelHeight = [self.contentLabel sizeThatFits:CGSizeMake(self.contentLabel.frame.size.width, MAXFLOAT)].height;
    NSNumber *count = @((labelHeight) / self.contentLabel.font.lineHeight);
    
    if (count.integerValue >= 5) {
        self.TtableViewHeaderView.glh_height += 20;
    }else {
        self.zkqbButton.hidden = YES;
    }
    
    self.tableView.tableHeaderView = self.TtableViewHeaderView;
    
    [self.tableView reloadData];
}

- (IBAction)clickzjqbButton:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        
        [sender setTitle:@"收缩全部" forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"BPXQ_ZKQB2"] forState:UIControlStateNormal];
        
        self.contentLabel.numberOfLines = 0;
        [self.contentLabel sizeToFit];
        
        self.TtableViewHeaderView.glh_height += self.contentLabel.glh_height;
        self.TtableViewHeaderView.glh_height -= 90;
        self.tableView.tableHeaderView = self.TtableViewHeaderView;
        
        [self.tableView reloadData];
    }else {
        self.contentLabel.numberOfLines = 5;
        
        [sender setTitle:@"展开全部" forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"BPXQ_ZKQB1"] forState:UIControlStateNormal];
        
//        [self.contentLabel sizeToFit];
        
        self.TtableViewHeaderView.glh_height -= self.contentLabel.glh_height;
        self.TtableViewHeaderView.glh_height += 90;
        self.tableView.tableHeaderView = self.TtableViewHeaderView;
        
        [self.tableView reloadData];
    }

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

//    /** 全部列表页面的空数据占位图片 */
//    notDataShowView *view;
//    
//    if (self.dataSource.count) {
//        if ([notDataShowView sharenotDataShowView].superview) {
//            [[notDataShowView sharenotDataShowView] removeFromSuperview];
//        }
//    }else {
//        view = [notDataShowView sharenotDataShowView:tableView];
//        [tableView addSubview:view];
//        
//    }
    
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WDBDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WDBDetailCell" forIndexPath:indexPath];
    
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WDBmember *model = self.dataSource[indexPath.row];
    
    PublicOtherPersonVC *vc = [[UIStoryboard storyboardWithName:@"PublicOtherPersonVC" bundle:nil]instantiateInitialViewController];
    vc.user = model.user;
    
    vc.isSecVCPush = YES;
//    vc.fromDynamicDetailVC = YES;
    
    if ([vc.user.uid isEqualToString:[LoginVM getInstance].readLocal._id] || vc.user.uid == nil) {
        return ;
    }
    
    [self.navigationController setHidesBottomBarWhenPushed:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (IBAction)clickAllMemberView:(UIControl *)sender {
    
    AllMemberListVC *vc = [[UIStoryboard storyboardWithName:@"AllMemberListVC" bundle:nil] instantiateInitialViewController];
    vc.fromItem = self.fromItem;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


/** 点击了关注按钮 */
- (IBAction)clickCareButton:(UIButton *)sender {
    
    NSDictionary *parameters = @{
                                 @"access_token":[LoginVM getInstance].readLocal.token,
                                 @"id":self.fromItem.id
                                 };
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/Gang/like"] parameters:parameters success:^(id json) {
        
        if ([json[@"state"] isEqual:@(0)]) {
            [SVProgressHUD show];
        }
        
        if ([self.item.is_like isEqual: @(0)]) {
            self.item.is_like = @(1);
            [sender setTitle:@"已关注" forState:UIControlStateNormal];
            [SVProgressHUD showSuccessWithStatus:@"关注成功"];
        }else{
            self.item.is_like = @(0);
            [sender setTitle:@"关注" forState:UIControlStateNormal];
            [SVProgressHUD showSuccessWithStatus:@"取消关注"];
        }
        
//        [SVProgressHUD showSuccessWithStatus:@"关注成功"];
//        [SVProgressHUD showSuccessWithStatus:@"取消关注"];
        
        //        NSLog(@"TTT--json%@",json);
    } failure:^(NSError *error) {
        
    }];
    
}

/** 点击了申请加入按钮 */
- (IBAction)clickApplicButton:(UIButton *)sender {
    
    [self shouInfo:@"请输入申请原因" isLink:NO];
    
}

- (void)handleApplicJoin:(NSString *)reason
{
    
    NSDictionary *parameters = @{
                                 @"access_token":[LoginVM getInstance].readLocal.token,
                                 @"id":self.fromItem.id,
                                 @"reason":reason
                                 };

    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/Gang/join"] parameters:parameters success:^(id json) {

        if ([json[@"state"] isEqual:@(0)]) {
            [SVProgressHUD show];
        }

        [SVProgressHUD showInfoWithStatus:json[@"info"]];
        
        [self.applic setTitle:@"进入帮派" forState:UIControlStateNormal];

        //        NSLog(@"TTT--json%@",json);
    } failure:^(NSError *error) {
        
    }];

}

#pragma mark - 弹窗
- (void)shouInfo:(NSString *)output isLink:(BOOL)isLink
{
    // 做个弹框, 弹出结果
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"申请加入" message:output preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    UIAlertAction *action_commit = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self.navigationController popViewControllerAnimated:YES];
        
        UITextField *textF =  alertVC.textFields.lastObject;
        
        if ([textF.text isEqualToString:@""]) {
            [SVProgressHUD showErrorWithStatus:@"请输入申请理由"];
        }else {
            [self handleApplicJoin:textF.text];
        }
        
    }];
    
    UIAlertAction *action_push = [UIAlertAction actionWithTitle:@"跳转链接" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:output]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
    
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"申请的原因是...";
    }];
    
    if (isLink) {
        [alertVC addAction:action_push];
    }
    
    [alertVC addAction:action];
    [alertVC addAction:action_commit];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
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
