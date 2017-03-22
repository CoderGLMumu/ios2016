//
//  MessageListVC.m
//  JZBRelease
//
//  Created by zjapple on 16/6/30.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "MessageListVC.h"
#import "Defaults.h"
#import "SendAndGetDataFromNet.h"
#import "MessageRequestModel.h"
#import "MessageCell.h"
#import "DynamicDetailVC.h"
#import "StatusModel.h"
#import "LocalDataRW.h"
#import "DealNormalUtil.h"
@interface MessageListVC()<UIAlertViewDelegate>

@end

@implementation MessageListVC

-(void)viewDidLoad{
    self.automaticallyAdjustsScrollViewInsets = NO;
  //  NSMutableArray *localAry = [LocalDataRW readDataFromLocalOfDocument:MESSAGE_NAME];
//    if (self.dataAry) {
//        for (int i = 0; i < localAry.count; i ++) {
//            NSDictionary *dict = [localAry objectAtIndex:i];
//            [self.dataAry addObject:dict];
//        }
//        BOOL issucee = [LocalDataRW writeDataToLocaOfDocument:self.dataAry AtFileName:MESSAGE_NAME];
//        if (issucee) {
//            NSLog(@"message is saved");
//        }else{
//            NSLog(@"message is failed");
//        }
//    }else{
//        self.dataAry = localAry;
//    }
    [self.view setBackgroundColor: [UIColor whiteColor]];
    [self createTableView];
    [self configNav];
    
    
}

-(void)configNav
{
    //11 20
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11 + 5 + 40, 35)];
    UIImageView *backImageView = [UIImageView createImageViewWithFrame:CGRectMake(0, (35-20)/2, 20, 20) ImageName:@"DL_light_ARROW"];
    backImageView.userInteractionEnabled = YES;
    [backView addSubview:backImageView];
//    UILabel *backLabel = [UILabel createLabelWithFrame:CGRectMake(11 + 5,(35-20)/2, 40, 20) Font:17 Text:@"返回" andLCR:0 andColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]]];
//    [backView addSubview:backLabel];
    UIControl *back = [[UIControl alloc] initWithFrame:backView.bounds];
    [back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:back];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}


-(void) backAction{
    NSNumber *count = [LocalDataRW returnCountWithType:@"dynamic_reply"];
    if ([count intValue] == 0) {
        [self.navigationController popViewControllerAnimated:YES];
        self.tabBarController.tabBar.hidden = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageComed" object:self userInfo:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"您还有未读未的消息，真的想退出吗？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [LocalDataRW clearToZeroWithType:@"dynamic_reply"];
        [self.navigationController popViewControllerAnimated:YES];
        self.tabBarController.tabBar.hidden = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageComed" object:self userInfo:nil];
    }
}

- (void)createTableView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
    [self.view addSubview:tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataAry) {
        
        /** 全部列表页面的空数据占位图片 */
        notDataShowView *view;
        
        if (self.dataAry.count) {
            if ([notDataShowView sharenotDataShowView].superview) {
                [[notDataShowView sharenotDataShowView] removeFromSuperview];
            }
        }else {
            view = [notDataShowView sharenotDataShowView:tableView];
            [tableView addSubview:view];
            
        }
        
        return self.dataAry.count;
    }
    return 0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifier = @"MessageCell";
    MessageCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }if (self.dataAry.count > indexPath.row) {
        NSDictionary *dict = [self.dataAry objectAtIndex:self.dataAry.count - 1 - indexPath.row];
        MesageCellModel *messageCellModel = [MesageCellModel mj_objectWithKeyValues:dict];
        [cell setModel:messageCellModel];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 54;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [self.dataAry objectAtIndex:self.dataAry.count - 1 - indexPath.row];
    MesageCellModel *messageCellModel = [MesageCellModel mj_objectWithKeyValues:dict];
    DynamicDetailVC *vc = [[DynamicDetailVC alloc]init];
    vc.pushFromMessageListVC = YES;
    __block MessageListVC *wself = self;
    vc.returnAction = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself.dataAry removeObjectAtIndex:self.dataAry.count - 1 - indexPath.row];
            [LocalDataRW writeDataToLocaOfDocument:wself.dataAry AtFileName:MESSAGE_NAME];
            [LocalDataRW reduceCountWithType:@"dynamic_reply"];
            [wself.tableView reloadData];
        });
    };
    StatusModel *statusModel = [[StatusModel alloc]init];
    statusModel.id = messageCellModel.dynamic_id;
    vc.statusModel = statusModel;
    //self.tabBarController.tabBar.hidden = YES;
    vc.updateDetailComment = YES;
    [DealNormalUtil getInstance].isJudge = YES;
    [self.navigationController pushViewController:vc animated:YES];
   
}


@end
