//
//  OtherPersonCentralVC.m
//  JZBRelease
//
//  Created by cl z on 16/8/5.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "OtherPersonCentralVC.h"
#import "OtherPersonCentralCell.h"
#import "Defaults.h"
#import "PersonalHeaderView.h"
#import "PersonalModel.h"
#import "GetUserInfoModel.h"
#import "BQDynamicVC.h"
#import "PerAskAndAnswerVC.h"
#import "BBActivityVC.h"
#import "PerActivityVC.h"
#import "CustomAlertView.h"
#import "AddFansModel.h"
#import "LewPopupViewAnimationSpring.h"
#import "FansListVC.h"

#import "ChatViewController.h"
#import "SendAndGetDataFromNet.h"

@interface OtherPersonCentralVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *nameAry0,*nameAry1,*imageAry0,*imageAry1;
}
@property(nonatomic, strong) PersonalHeaderView *personalHeaderView;
@property(nonatomic, strong) Users *model;
@property(nonatomic, assign) int requestCount;

/** isSendFriend */
@property (nonatomic, assign) BOOL isSendFriend;

@end

@implementation OtherPersonCentralVC

- (void)viewDidLoad {
    [super viewDidLoad];
    nameAry0 = @[@"他的问答",@"他的活动",@"他的课程",];
    nameAry1 = @[@"他的动态",];
    imageAry0 = @[@"grzx_grzx_gz",@"grzx_grzx_activity",@"grzx_grzx_course",];
    imageAry1 = @[@"grzx_grzx_dynamic",];
    
    [self createTableView];
    UIView *barBackground = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    barBackground.backgroundColor = [ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Personal_XM_Color" WithKind:XMLTypeColors]];
    barBackground.alpha = 0.3;
    [self.view addSubview:barBackground];
    UIButton *backView = [[UIButton alloc] initWithFrame:CGRectMake(18, 20 + 4.5, 11 + 5 + 40, 35)];
    UIImageView *backImageView = [UIImageView createImageViewWithFrame:CGRectMake(0, (35-20)/2, 20, 20) ImageName:@"DL_light_ARROW"];
    backImageView.userInteractionEnabled = YES;
    
    [backView addSubview:backImageView];
//    UILabel *backLabel = [UILabel createLabelWithFrame:CGRectMake(11 + 5,(35-20)/2, 40, 20) Font:17 Text:@"返回" andLCR:0 andColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]]];
//    [backView addSubview:backLabel];
    backView.tag = 0;
    [backView addTarget:self action:@selector(actionBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backView];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    [self downloadData];
}

-(void)initNavi{
    
}

- (void)createTableView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Inteval_Color" WithKind:XMLTypeColors]];
    [self.view addSubview:tableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
    tableView.bounces = NO;
}

-(void)actionBtn : (UIButton *) btn{
    if (self.fromDynamicDetailVC) {
        [self.navigationController popViewControllerAnimated:YES];
        self.navigationController.navigationBar.hidden = NO;
        return;
    }
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)downloadData {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[HttpManager shareManager] netStatus:^(AFNetworkReachabilityStatus status) {
            if(status == AFNetworkReachabilityStatusReachableViaWWAN || status ==AFNetworkReachabilityStatusReachableViaWiFi){
                GetUserInfoModel *model = [[GetUserInfoModel alloc]init];
                model.access_token = [[LoginVM getInstance] readLocal].token;
                model.uid = self.user.uid;
                SendAndGetDataFromNet *sendAndget = [[SendAndGetDataFromNet alloc]init];
                __weak SendAndGetDataFromNet *wsend = sendAndget;
                __weak OtherPersonCentralVC *wself = self;
                sendAndget.returnDict = ^(NSDictionary *dict){
                    if (!dict) {
                        [Toast makeShowCommen:@"您的网络有问题 " ShowHighlight:@"请重置" HowLong:0.8];
                    }else{
                        if ([[dict objectForKey:@"state"] integerValue] == 1) {
                            wself.requestCount = 0;
                            NSDictionary *dataDict = [dict objectForKey:@"data"];
                            self.model = [Users mj_objectWithKeyValues:dataDict];
                            NSLog(@"dataDict %@",dataDict);
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self refreshComplete];
                            });
                        }else{
                            if (wself.requestCount > 1) {
                                [Toast makeShowCommen:@"您的网络有问题 " ShowHighlight:@"请重置" HowLong:0.8];
                                return ;
                            }
                            [LoginVM getInstance].isGetToken = ^(){
                                model.access_token = [[LoginVM getInstance] readLocal].token;
                                [wsend dictFromNet:model WithRelativePath:@"USER_INFO"];
                                wself.requestCount ++;
                            };
                            [[LoginVM getInstance] loginWithUserInfoForGetNewToken:[[LoginVM getInstance] readLocal]];
                        }
                    }
                };
                [sendAndget dictFromNet:model WithRelativePath:@"USER_INFO"];
            }else{
                [Toast makeShowCommen:@"您的网络有问题 " ShowHighlight:@"请重置" HowLong:0.8];
            }
        }];
    });
}

- (void)refreshComplete {
//    [self.tableViewHeader refreshingAnimateStop];
    [UIView animateWithDuration:0.35f animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    } completion:^(BOOL finished) {
        [self.personalHeaderView removeFromSuperview];
        self.personalHeaderView = nil;
        [self.tableView reloadData];
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (0 == section) {
        return 0;
    }else if(1 == section){
        return 3;
    }else{
        return 1;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (0 == section) {
        return self.personalHeaderView;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (0 == section) {
        return 20 + 44 * 2 + 205;
    }else{
        return 21;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellIdentifier = @"OtherPersonCentralCell";
    OtherPersonCentralCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[OtherPersonCentralCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == 1) {
        [cell.fImageView setImage:[UIImage imageNamed:[imageAry0 objectAtIndex:indexPath.row]]];
        [cell.tLabel setText:[nameAry0 objectAtIndex:indexPath.row]];
        if (indexPath.row == nameAry0.count - 1) {
            cell.intevalLabel.hidden = YES;
        }else{
            cell.intevalLabel.hidden = NO;
        }
    }else if (indexPath.section == 2){
        [cell.fImageView setImage:[UIImage imageNamed:[imageAry1 objectAtIndex:indexPath.row]]];
        [cell.tLabel setText:[nameAry1 objectAtIndex:indexPath.row]];
        cell.intevalLabel.hidden = YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Users *user = self.model;
    if (indexPath.section == 2) {
        BQDynamicVC *bqRoot = [[BQDynamicVC alloc]init];
        bqRoot.fromPernoal = YES;
        bqRoot.user = user;
        self.navigationController.navigationBar.hidden = NO;
        [self.navigationController pushViewController:bqRoot animated:YES];
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            PerAskAndAnswerVC *askVC = [[PerAskAndAnswerVC alloc]init];
            askVC.user = user;
            self.navigationController.navigationBar.hidden = NO;
            [self.navigationController pushViewController:askVC animated:YES];
        }else if (indexPath.row == 1){
            PerActivityVC *activityVC = [[PerActivityVC alloc]init];
            activityVC.user = user;
            self.navigationController.navigationBar.hidden = NO;
            [self.navigationController pushViewController:activityVC animated:YES];
        }
    }
}


- (PersonalHeaderView *)personalHeaderView{
 
     if (_personalHeaderView) {
         return _personalHeaderView;
     }
     _personalHeaderView = [[PersonalHeaderView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH , 20 + 44 * 2 + 205)];
        if (!self.model) {
            self.model = [[Users alloc]init];
     }
        [_personalHeaderView initWithData:self.model];
        __weak typeof (self) wself = self;
     
        NSUserDefaults *udefaults = [NSUserDefaults standardUserDefaults];
        NSString *isSendFriendWithID = [NSString stringWithFormat:@"isSendFriend%@",self.model.uid];
        self.isSendFriend = [udefaults objectForKey:isSendFriendWithID];
     
     if (self.isSendFriend) {
         [self.personalHeaderView.addFriendBtn setTitle:@"已申请" forState:UIControlStateNormal];
     }
     
     if ([self.model.is_friend integerValue] == 1) {
         [self.personalHeaderView.addFriendBtn setTitle:@"交流" forState:UIControlStateNormal];
     }
     
     _personalHeaderView.btnAction = ^(NSInteger tag){
     if (0 == tag) {
         if ([wself.model.is_fllow integerValue] == 1) {
             [wself delFans];
     }else{
         [wself addFans];
     }
     }else if (3 == tag){
         FansListVC *fansVC = [[FansListVC alloc]init];
         fansVC.user = wself.model;
         wself.navigationController.navigationBar.hidden = NO;
         [wself.navigationController pushViewController:fansVC animated:YES];
     }else if (1 == tag){
     if (wself.isSendFriend) {
         CustomAlertView *alertView = [CustomAlertView defaultCustomAlertView:@"已经发送申请"];
         [wself lew_presentPopupView:alertView animation:[LewPopupViewAnimationSpring new]];
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [wself lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
     });
     }else {
     // 点击 加为好友
     if ([wself.model.is_friend integerValue] == 1) {
     
         [wself MesFriend];
     }else{
         [wself addFriend];
        }
     }
     
     
      }
   };
        return _personalHeaderView;
}


- (void)MesFriend
{
    ChatViewController *chatViewController = [[ChatViewController alloc]
                                              initWithConversationChatter:[NSString stringWithFormat:@"member_%@",self.user.uid] conversationType:0];
    [self.navigationController pushViewController:chatViewController animated:YES];
}


- (void)addFriend
{
    NSDictionary *parameters = @{
                                 @"to_uid":self.user.uid ,
                                 @"access_token":[[LoginVM getInstance] readLocal].token
                                 };
    
//    NSLog(@"gaolintestparameters = %@",parameters);
    
    /** 正在进行好友申请 */
    CustomAlertView *alertView = [CustomAlertView defaultCustomAlertView:@"正在发送请求..."];
    [self lew_presentPopupView:alertView animation:[LewPopupViewAnimationSpring new]];
    self.personalHeaderView.addFriendBtn.enabled = NO;
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/Friend/add"] parameters:parameters success:^(id json) {
        
        if ([json[@"state"] isEqual:@(1)]) {
            /** 已经发送好友申请 */
            [alertView setTitle:@"已经发送好友申请"];
            self.model.is_friend = [NSNumber numberWithInteger:1];
            [self.personalHeaderView.addFriendBtn setTitle:@"已申请" forState:UIControlStateNormal];
            
            NSUserDefaults *udefaults = [NSUserDefaults standardUserDefaults];
//            [udefaults objectForKey:@""];
            NSString *isSendFriendWithID = [NSString stringWithFormat:@"isSendFriend%@",self.user.uid];
            [udefaults setBool:YES forKey:isSendFriendWithID];
            self.isSendFriend = YES;
            
        }else {
            /** 网络问题 或者 token过期 */\
            [alertView setTitle:@"网络问题,申请失败,请稍后重试 或者联系我们"];
            self.model.is_friend = [NSNumber numberWithInteger:0];
            
        }
        self.personalHeaderView.addFriendBtn.enabled = YES;
        [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
        
        [self lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
        
    } failure:^(NSError *err) {
        [alertView setTitle:@"申请失败..请稍后重试"];
        self.personalHeaderView.addFriendBtn.enabled = YES;
        [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
        [self lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
//        [self showHint:NSLocalizedString(@"acceptFail", @"accept failure")];
//        [self hideHud];
    }];
}

-(void)addFans{
    self.personalHeaderView.focusBtn.enabled = NO;
    CustomAlertView *alertView = [CustomAlertView defaultCustomAlertView:@"关注中..."];
    [self lew_presentPopupView:alertView animation:[LewPopupViewAnimationSpring new]];
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
    AddFansModel *addFansModel = [[AddFansModel alloc]init];
    addFansModel.access_token = [[LoginVM getInstance] readLocal].token;
    addFansModel.user_id = self.user.uid;
    SendAndGetDataFromNet *sendAndGet = [[SendAndGetDataFromNet alloc]init];
    __block SendAndGetDataFromNet *wsend = sendAndGet;
    sendAndGet.returnModel = ^(GetValueObject *obj,int state){
        if (!obj) {
            [alertView setTitle:@"关注失败"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
                [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                    [Toast makeShowCommen:@"您的网络 " ShowHighlight:@"出现故障" HowLong:0.8];
//                    self.personalHeaderView.focusBtn.enabled = YES;
                });
            });
        }else{
            if (1 == state) {
                self.requestCount = 0;
                [alertView.label setText:@"成功关注"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
                    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                    [_personalHeaderView.focusBtn setTitle:@"取消关注" forState:UIControlStateNormal];
                    [_personalHeaderView.fansValue setText:[NSString stringWithFormat:@"%ld",[_personalHeaderView.fansValue.text integerValue] + 1]];
                    self.model.is_fllow = [NSNumber numberWithInteger:1];
                    self.personalHeaderView.focusBtn.enabled = YES;
                });
            }else{
                if (self.requestCount > 1) {
                    [alertView setTitle:@"关注失败"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
                        [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                            [Toast makeShowCommen:@"您的网络 " ShowHighlight:@"出现故障" HowLong:0.8];
                            self.personalHeaderView.focusBtn.enabled = YES;
                        });
                    });
                    return ;
                }
                [LoginVM getInstance].isGetToken = ^(){
                    addFansModel.access_token = [[LoginVM getInstance] readLocal].token;
                    [wsend commenDataFromNet:addFansModel WithRelativePath:@"Add_Fans_URL"];
                    self.requestCount ++;
                };
                [[LoginVM getInstance] loginWithUserInfoForGetNewToken:[[LoginVM getInstance] readLocal]];
            }
            
        }
    };
    [sendAndGet commenDataFromNet:addFansModel WithRelativePath:@"Add_Fans_URL"];
}

-(void)delFans{
    self.personalHeaderView.focusBtn.enabled = NO;
    CustomAlertView *alertView = [CustomAlertView defaultCustomAlertView:@"取消关注中..."];
    [self lew_presentPopupView:alertView animation:[LewPopupViewAnimationSpring new]];
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
    //AddFansModel可作取消关注Model
    AddFansModel *addFansModel = [[AddFansModel alloc]init];
    addFansModel.access_token = [[LoginVM getInstance] readLocal].token;
    addFansModel.user_id = self.user.uid;
    SendAndGetDataFromNet *sendAndGet = [[SendAndGetDataFromNet alloc]init];
    __block SendAndGetDataFromNet *wsend = sendAndGet;
    sendAndGet.returnModel = ^(GetValueObject *obj,int state){
        if (!obj) {
            [alertView setTitle:@"取消失败"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
                [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                    [Toast makeShowCommen:@"您的网络 " ShowHighlight:@"出现故障" HowLong:0.8];
                    self.personalHeaderView.focusBtn.enabled = YES;
                });
            });
        }else{
            if (1 == state) {
                self.requestCount = 0;
                [alertView.label setText:@"取消关注"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
                    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                    [_personalHeaderView.focusBtn setTitle:@"关注" forState:UIControlStateNormal];
                    [_personalHeaderView.fansValue setText:[NSString stringWithFormat:@"%ld",[_personalHeaderView.fansValue.text integerValue] - 1]];
                    self.model.is_fllow = [NSNumber numberWithInteger:0];
                    self.personalHeaderView.focusBtn.enabled = YES;
                });
            }else{
                if (self.requestCount > 1) {
                    [alertView setTitle:@"取消失败"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
                        [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                            [Toast makeShowCommen:@"您的网络 " ShowHighlight:@"出现故障" HowLong:0.8];
                            self.personalHeaderView.focusBtn.enabled = YES;
                        });
                    });
                    return ;
                }
                [LoginVM getInstance].isGetToken = ^(){
                    addFansModel.access_token = [[LoginVM getInstance] readLocal].token;
                    [wsend commenDataFromNet:addFansModel WithRelativePath:@"Delete_Fans_URL"];
                    self.requestCount ++;
                };
                [[LoginVM getInstance] loginWithUserInfoForGetNewToken:[[LoginVM getInstance] readLocal]];
            }
            
        }
    };
    [sendAndGet commenDataFromNet:addFansModel WithRelativePath:@"Delete_Fans_URL"];
}


@end
