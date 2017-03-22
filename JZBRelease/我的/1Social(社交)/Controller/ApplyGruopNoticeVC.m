//
//  ApplyFriendNoticeVC.m
//  JZBRelease
//
//  Created by zjapple on 16/8/6.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "ApplyGruopNoticeVC.h"

#import "UserInfo.h"
#import "InvitationManager.h"
#import "HXApplyGruopItem.h"
#import "HXApplyGruopCell.h"

#import "BCH_Alert.h"

typedef enum{
    ApplyStyleFriend            = 0,
    ApplyStyleGroupInvitation,
    ApplyStyleJoinGroup,
}ApplyStyle;

static ApplyGruopNoticeVC *controller = nil;

@interface ApplyGruopNoticeVC ()
{
    UserInfo *userInfo;
}

/** HXapplyFriendItems */
@property (nonatomic, strong) NSMutableArray *HXapplyGruopItems;

/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ApplyGruopNoticeVC

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)HXapplyGruopItems
{
    if (_HXapplyGruopItems == nil) {
        _HXapplyGruopItems = [NSMutableArray array];
    }
    return _HXapplyGruopItems;
}

+ (instancetype)shareController
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[self alloc] initWithStyle:UITableViewStylePlain];
    });
    
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setuptitleView];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.title = @"群组申请与通知";
    [self.tableView registerNib:[UINib nibWithNibName:@"HXApplyGruopCell" bundle:nil] forCellReuseIdentifier:@"applyGruopCell"];
    
    [self loadDataSource];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - public

- (void)addNewApply:(NSDictionary *)dictionary
{
    //new apply
    ApplyEntity * newEntity= [[ApplyEntity alloc] init];
    newEntity.applicantUsername = [dictionary objectForKey:@"username"];
    newEntity.style = [dictionary objectForKey:@"applyStyle"];
    newEntity.reason = [dictionary objectForKey:@"applyMessage"];
    
    NSString *loginName = [[EMClient sharedClient] currentUsername];
    newEntity.receiverUsername = loginName;
    
    NSString *groupId = [dictionary objectForKey:@"groupId"];
    newEntity.groupId = (groupId && groupId.length > 0) ? groupId : @"";
    
    NSString *groupSubject = [dictionary objectForKey:@"groupname"];
    newEntity.groupSubject = (groupSubject && groupSubject.length > 0) ? groupSubject : @"";
    
    NSString *loginUsername = [[EMClient sharedClient] currentUsername];
//    [[InvitationManager sharedInstance] addInvitation:newEntity loginUser:loginUsername];
    
//    [_dataSource insertObject:newEntity atIndex:0];
    [self.tableView reloadData];
  
}

- (void)setuptitleView
{
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.glw_width - 112 * 2, 40)];
    titleLable.text = @"群组申请与通知";
    titleLable.textColor = [UIColor hx_colorWithHexRGBAString:@"ffffff"];
    titleLable.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLable;
}

- (void)loadDataSource
{
    NSString *loginName = [self loginUsername];
    if(loginName && [loginName length] > 0)
    {
        NSArray * applyArray = [[InvitationManager sharedInstance] applyEmtitiesWithloginUser:loginName];
        for (ApplyEntity *applyEntity in applyArray) {
            
             ApplyStyle style = [applyEntity.style intValue];
            
            if (style == ApplyStyleGroupInvitation) {
                
//                 [self.dataSource addObjectsFromArray:applyArray];
                
                 self.HXapplyGruopItems = [HXApplyGruopItem mj_objectArrayWithKeyValuesArray:applyArray];
                
//                userInfo = [[LoginVM getInstance]readLocal];
//                
//                NSDictionary *parameters = @{
//                                             @"groupid":applyEntity.groupId,
//                                             @"access_token":userInfo.token
//                                             };
//                
//                EMGroup *group = [[EMClient sharedClient].groupManager fetchGroupInfo:applyEntity.groupId includeMembersList:NO error:nil];
//                
//                [HttpToolSDK postWithURL:@"http://192.168.10.154/bang/index.php/Web/Circle/updatemember" parameters:parameters success:^(id json) {
//                    
//                    NSLog(@"gaolin json=%@",json);
//                    NSLog(@"gaolin 11 %@",group.subject);
//                    NSLog(@"gaolin 22 %@",group.description);
//                    
//                    [self.tableView reloadData];
//                    
//                } failure:^(NSError *error) {
//                    
//                }];
                
            }
        }
        [self.tableView reloadData];
    }
}

- (NSString *)loginUsername
{
    return [[EMClient sharedClient] currentUsername];
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
    
    if (self.HXapplyGruopItems.count) {
        if ([notDataShowView sharenotDataShowView].superview) {
            [[notDataShowView sharenotDataShowView] removeFromSuperview];
        }
    }else {
        view = [notDataShowView sharenotDataShowView:tableView];
        [tableView addSubview:view];
        
    }
    
    return self.HXapplyGruopItems.count;
}


- (HXApplyGruopCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HXApplyGruopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"applyGruopCell" forIndexPath:indexPath];
    
    cell.model = self.HXapplyGruopItems[indexPath.row];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

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


//左滑删除按钮:(实现delegate)
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [UIView bch_showWithTitle:@"确认删除" message:nil buttonTitles:@[@"取消",@"删除"] callback:^(id sender, NSUInteger buttonIndex) {
        if (buttonIndex == 0) {
            return ;
        }else if (buttonIndex == 1){
            
            
            NSString *loginName = [self loginUsername];
            
            HXApplyGruopItem *item = self.HXapplyGruopItems[indexPath.row];
            
            NSArray * applyArray = [[InvitationManager sharedInstance] applyEmtitiesWithloginUser:loginName];
            //    for (ApplyEntity *applyEntity in applyArray) {
            //
            //        if ([item.groupId isEqualToString:applyEntity.groupId]) {
            //            [[InvitationManager sharedInstance] removeInvitation:applyEntity loginUser:loginName];
            //
            //        }
            //
            //    }
            
            [applyArray enumerateObjectsUsingBlock:^(ApplyEntity *applyEntity, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([item.groupId isEqualToString:applyEntity.groupId]) {
                    [[InvitationManager sharedInstance] removeInvitation:applyEntity loginUser:loginName];
                    
                }
            }];
            
            // 修改模型
            [self.HXapplyGruopItems removeObjectAtIndex:indexPath.row];
            // 局部刷新
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];        }
    }];

    
}
//删除文字:
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
    //    return [NSString stringWithFormat:@"删除-%zd",indexPath.row];
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
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
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
