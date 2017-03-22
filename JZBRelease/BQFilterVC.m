//
//  BQFilterVC.m
//  JZBRelease
//
//  Created by zjapple on 16/5/5.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "BQFilterVC.h"
#import "Defaults.h"
#import "FilterLayout.h"
#import "FilterCell.h"
#import "FilterModel.h"
@interface BQFilterVC ()<TableViewCellDelegate>


@end

@implementation BQFilterVC{
    NSMutableArray *dataAry;
    NSMutableArray *cellAry;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    self.filterTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tabBarController.tabBar.hidden = YES;
    
    
    dataAry = [[NSMutableArray alloc]initWithArray:@[@[@{@"title":@"关注的好友"},@{@"title":@"帮派"},@{@"title":@"行业"}],
                                                         @[@{@"title":@"推荐一"},@{@"title":@"推荐二"},@{@"title":@"推荐三"}]]];
    [self initCellAry];
    
    
    
    
}

-(void) initCellAry{
    for (int i = 0; i < dataAry.count; i ++) {
        NSArray *ary = [dataAry objectAtIndex:i];
        for (int j = 0; j < ary.count; j ++) {
            if (!cellAry) {
                cellAry = [[NSMutableArray alloc]init];
            }
            FilterModel *model = [FilterModel modelWithJSON:[ary objectAtIndex:j]];
            if (model) {
                FilterLayout *layout = [self layoutWithStatusModel:model index:i * 3 + j];
                [cellAry addObject:layout];
            }
        }
    }
}

-(void)configNav
{
    //11 20
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11 + 5 + 40, 35)];
    UIImageView *backImageView = [UIImageView createImageViewWithFrame:CGRectMake(0, (35-20)/2, 20, 20) ImageName:@"DL_light_ARROW"];
    backImageView.userInteractionEnabled = YES;
    [backView addSubview:backImageView];
//    UILabel *backLabel = [UILabel createLabelWithFrame:CGRectMake(11 + 5,(35-20)/2, 40, 20) Font:17 Text:@"返回" andLCR:0 andColor:[UIColor whiteColor]];
//    [backView addSubview:backLabel];
    UIControl *back = [[UIControl alloc] initWithFrame:backView.bounds];
    [back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:back];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    
}

- (FilterLayout *)layoutWithStatusModel:(FilterModel *)filterModel index:(NSInteger)index {
    //生成Storage容器
    LWStorageContainer* container = [[LWStorageContainer alloc] init];
    //生成Layout
    FilterLayout* layout = [[FilterLayout alloc]initWithContainer:container Model:filterModel index:index];
    return layout;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    if (!dataAry) {
        return 0;
    }
    return dataAry.count;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!dataAry) {
        return 0;
    }
    if (dataAry.count > section) {
        NSMutableArray *sectionAry = [dataAry objectAtIndex:section];
        return sectionAry.count;
    }
    return 0;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!cellAry) {
        return nil;
    }
    static NSString* cellIdentifier = @"filterCellIdentifier";
    FilterCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[FilterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    if (cellAry.count > indexPath.row) {
        FilterLayout* cellLayout = cellAry[indexPath.section * 3 + indexPath.row];
        cell.cellLayout = cellLayout;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"select %ld row",indexPath.row);
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (0 == section) {
        return nil;
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 44)];
    UILabel *label = [UILabel createLabelWithFrame:CGRectMake(10, 0, 120, 44) Font: 17 Text:@"推荐" andLCR:0 andColor:[UIColor grayColor]];
    [view addSubview:label];
    return view;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (0 == section) {
        return 0;
    }
    return 44;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (cellAry.count <= 0) {
//        return 0;
//    }
//    FilterLayout* layout = cellAry[0];
//    return layout.cellHeight;
    return 44;
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) backAction{
    [self.navigationController popViewControllerAnimated:YES];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)dealloc{
//    self.filterTableView = nil;
//    dataAry = nil;
}

@end
