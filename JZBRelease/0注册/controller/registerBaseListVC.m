//
//  registerBaseListVC.m
//  JZBRelease
//
//  Created by zjapple on 16/8/26.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "registerBaseListVC.h"
#import "registerBaseListCell.h"
#import "registerBaseListModel.h"

@interface registerBaseListVC ()

/** 模型数组 */
@property (nonatomic, strong) NSMutableArray *models;

/** 保存用户选中行的indexPath*/
@property (nonatomic ,strong) NSMutableArray *seletedIndexPaths;
/** 保存用户选中行的数据*/
@property (nonatomic ,strong) NSMutableArray *seletedTitles;
@property (weak, nonatomic) IBOutlet UILabel *navTitleLabel;

@end

@implementation registerBaseListVC

- (NSMutableArray *)seletedIndexPaths
{
    if (!_seletedIndexPaths) {
        _seletedIndexPaths = [NSMutableArray array];
    }
    return _seletedIndexPaths;
}

- (NSMutableArray *)seletedTitles
{
    if (!_seletedTitles) {
        _seletedTitles = [NSMutableArray array];
    }
    return _seletedTitles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.models = [NSMutableArray array];
    
    self.navTitleLabel.text = self.title;
    
    /** 数据转模型 */
//    for (NSString *title in self.dataSource) {
//        registerBaseListModel *model =[registerBaseListModel new];
//        model.titleName = title;
//        [self.models addObject:model];
//    }
//    [self.tableView reloadData];
    
    for (NSDictionary *dictT in self.dataSource) {
        registerBaseListModel *model =[registerBaseListModel new];
        model.titleName = dictT[@"name"];
        model.uid = dictT[@"id"];
        [self.models addObject:model];
    }
    
    
    self.tableView.tableFooterView = [[UIImageView alloc]init];
    
    if (self.VCtype == VCTypeJXS || self.VCtype == VCTypeZLT || self.VCtype == VCTypePPCS) {
        self.tableView.allowsMultipleSelection = YES;
    }
    
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    if (self.tableView.allowsMultipleSelection) {
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setTitle:@"完成" forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
        [rightButton sizeToFit];
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(done:)];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
        
//        self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    }
//    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    
//    [self.tableView registerClass:[registerBaseListCell class] forCellReuseIdentifier:@"registerCell"];
    
    [self downloadData];
}

- (void)downloadData
{
    //        NSDictionary *parameters = @{
    //                                     @"access_token":[LoginVM getInstance].readLocal.token
    //                                     };
    //
    //        [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/Friend/get"] parameters:parameters success:^(id json) {
    //
    //            publicBaseJsonItem *item = [publicBaseJsonItem mj_objectWithKeyValues:json];
    //
    //        if ([item.state isEqual:@(0)]) {
    //            [SVProgressHUD show];
    //        }
    //
    ////            NSLog(@"TTT--json%@",json);
    //        } failure:^(NSError *error) {
    //
    //        }];
}

- (void)done:(UIBarButtonItem *)item
{
    NSString *title = @"";
    
    NSString *uid = @"";
    
//    for (NSString *titleM in self.seletedTitles) {
//        
//    }
    
    for (int i = 0; i < self.seletedTitles.count; ++i) {
        NSDictionary *dictM = self.seletedTitles[i];
//        NSString *titleM = self.seletedTitles[i];
        if (i == 0) {
            title = [title stringByAppendingString:[NSString stringWithFormat:@"%@",dictM.allValues[0]]];
            uid = dictM.allKeys[0];
        }else {
            title = [title stringByAppendingString:[NSString stringWithFormat:@",%@",dictM.allValues[0]]];
            uid = [uid stringByAppendingString:[NSString stringWithFormat:@",%@",dictM.allKeys[0]]];
        }
    }
    
    
    if (title.length == 0) title = @"行业";
    self.cellClick(@{uid:title});
//    if (self.seletedIndexPaths.count) {
//        
//    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    /** 全部列表页面的空数据占位图片 */
    notDataShowView *view;
    
    if (self.models.count) {
        if ([notDataShowView sharenotDataShowView].superview) {
            [[notDataShowView sharenotDataShowView] removeFromSuperview];
        }
    }else {
        view = [notDataShowView sharenotDataShowView:tableView];
        [tableView addSubview:view];
        
    }
    
    return self.models.count;
}


- (registerBaseListCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    registerBaseListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"registerCell" forIndexPath:indexPath];
    
    cell.model = self.models[indexPath.row];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.tableView.allowsMultipleSelection) {
        
        // 修改模型
        registerBaseListModel *model = self.models[indexPath.row];
        
        if (model.isChecked) { // 取消打钩
            model.checked = NO;
            [self.seletedIndexPaths removeObject:indexPath];
            [self.seletedTitles removeObject:@{model.uid:model.titleName}];
        } else { // 重新打钩
            model.checked = YES;
            [self.seletedIndexPaths addObject:indexPath];
            [self.seletedTitles addObject:@{model.uid:model.titleName}];
        }
        
        if (self.seletedIndexPaths.count == 4) {
            model.checked = NO;
            [self.seletedIndexPaths removeObject:indexPath];
            [self.seletedTitles removeObject:@{model.uid:model.titleName}];
            [SVProgressHUD showInfoWithStatus:@"选择的类型不能超过3个"];
        }
        
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
//        if (self.multipleSelectionArr.count >= 3) {
//            
//        }else {
//            [self.multipleSelectionArr addObject:cell.model];
//        }
        
    }else {
        registerBaseListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (self.cellClick) {
            self.cellClick(@{cell.model.uid:cell.model.titleName});
        }
        
        [self.navigationController popViewControllerAnimated:YES];
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
