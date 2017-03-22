//
//  RankTableTableViewController.m
//  JZBRelease
//
//  Created by zjapple on 16/9/28.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "RankTableTableViewController.h"

#import "Defaults.h"
#import "rankItem.h"
#import "RankingCell.h"

@interface RankTableTableViewController ()

// dataSource
@property(nonatomic , strong)NSArray *dataSource;

@end

@implementation RankTableTableViewController

static NSString *ID = @"RankingCellID2";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
//    [self downLoadData];
    
    self.view.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f8f8f8"];
    
   [self.tableView registerNib:[UINib nibWithNibName:@"RankingCell" bundle:nil] forCellReuseIdentifier:ID];
}

- (void)downLoadData
{
    //类型 1本周 2本月 3本年
    
    NSDictionary *parameters1 = @{
                                  @"type":self.type
                                  };
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/User/rank"] parameters:parameters1 success:^(id json) {
        
        self.dataSource = [rankItem mj_objectArrayWithKeyValuesArray:json];
        
        //        [self tableViewreloadData];
        
        [self.tableView reloadData];
        
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不通顺"];
    }];
    
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//
//    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.topNum = [NSString stringWithFormat:@"%ld",indexPath.row];
//    cell.model = self.dataSource[indexPath.row];
//    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    NSLog(@"123123123");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"123123123");
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
