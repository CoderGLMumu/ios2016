//
//  MyCourseVC.m
//  JZBRelease
//
//  Created by cl z on 16/9/12.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "MyCourseVC.h"
#import "MycourseCell.h"
#import "ZJBHelp.h"
#import "Defaults.h"
#import "CourseTypeView.h"
#import "SerialsCourseVC.h"
#import "CourseTimeVC.h"
#import "SendedCourseListVC.h"
#import "DataBaseHelperSecond.h"
#import "ApplyTeacherVC.h"
#import "PlayBackVideoCourseVC.h"
#import "HasBoughtCourseTimeVC.h"
#import "FocusedCourseTimeListVC.h"
#import "SendedCourseTimeListVC.h"
#import "playerDownLoad.h"
#import "ZBYGCoursTimeVC.h"
#import "ZBCourstTimeVC.h"
#import "LuXiangCourseTimeVC.h"

#import "GLNAVC.h"

@interface MyCourseVC ()<UIActionSheetDelegate,UIAlertViewDelegate>{
    NSArray *image1Ary,*imageOtherAry,*image2Ary,*labelAry,*teacherAry;
    NSInteger which;
}

@end

@implementation MyCourseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f8f8f8"]];
    
    which = -1;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    image2Ary = @[@"WDKC_YG",@"WDKC_ZB",@"WDKC_LX",@"WDKC_FB"];
    DataBaseHelperSecond *db = [DataBaseHelperSecond getInstance];
    
    if (self.isOther) {
        
        if ([self.user.is_teacher integerValue] == 1) {

            labelAry = @[@"我的预告",@"我的直播",@"已发布"];
            
//            labelAry = @[@"他的预告",@"他的直播",@"他的课程"];
            image1Ary = @[@"WDKC_YG",@"WDKC_ZB",@"WDKC_FB"];
            which = -1;
        }
        
    }else {
        image1Ary = @[@"WDKC_YSC",@"WDKC_YBM",@"WDKC_down"];
        Users *user = [[Users alloc]init];
        user.uid = [[LoginVM getInstance] readLocal]._id;
        user = (Users *)[db getModelFromTabel:user];
        self.user = user;
        if ([user.is_teacher integerValue] == 1) {
            [self configNav];
//<<<<<<< .mine
            labelAry = @[@"已收藏",@"已报名",@"离线下载"];
            teacherAry = @[@"我的预告",@"我的直播",@"我的录像",@"已发布"];
//=======
//            labelAry = @[@"发布",@"精彩回放",@"已报名",@"已收藏",@"下载"];
//>>>>>>> .r1451
            which = 0;
        }else{
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *teacherState = [userDefaults objectForKey:@"TeacherState"];
            if (!teacherState) {
//<<<<<<< .mine
                labelAry = @[@"已收藏",@"已报名",@"离线下载"];
                teacherAry = @[@"申请导师"];
//=======
//                labelAry = @[@"申请导师",@"已报名",@"已收藏",@"下载"];
//>>>>>>> .r1451
                which = 1;
            }else{
//<<<<<<< .mine
                labelAry = @[@"已收藏",@"已报名",@"离线下载"];
                teacherAry = @[@"申请审核中"];
//=======
//                labelAry = @[@"申请审核中",@"已报名",@"已收藏",@"下载"];
//>>>>>>> .r1451
                which = 2;
            }
        }

    }
    
    
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    NSString *title = @"课程";
    self.title = title;
    
    if (!self.user.is_teacher) {
        self.user = [LoginVM getInstance].users;
    }
    if ([self.user.is_teacher integerValue] != 1) {
        NSString *title = @"发布直播";
        NSString *message = @"亲，发布直播课程需要先申请成为建众帮导师，爱分享、爱思考！";
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去申请", nil];
        [alertView show];
    }
}

- (void)leftconfigNav
{
//    11 20
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

-(void)configNav
{
    if (self.isOther) {
        
        return ;
        
    }
    UIButton *sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 35, 28)];
    //[sendBtn setImage:[UIImage imageNamed:@"BQ_DT_release"] forState:UIControlStateNormal];
    NSString *title = @"发布";
    [sendBtn setTitle:title forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(addCourseTime) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    UIBarButtonItem *sendBarBtn = [[UIBarButtonItem alloc]initWithCustomView:sendBtn];
    self.navigationItem.rightBarButtonItem = sendBarBtn;
}

- (void) addCourseTime{
    CourseTimeVC *courseTimeVC = [[CourseTimeVC alloc]init];
    //__weak typeof (self) wself = self;
    self.fromXBAndIsTeacher = NO;
    courseTimeVC.returnAction = ^(){
        
    };
    [self.navigationController pushViewController:courseTimeVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    GLLog(@"%@",self.navigationController);
    if ([self.navigationController isKindOfClass:[GLNAVC class]]) {
        
    }else {
        [self leftconfigNav];
    }
    
    [self createTableView];
}



- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.fromXBAndIsTeacher) {
        [self addCourseTime];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (1 == buttonIndex) {
        ApplyTeacherVC *applyVC = [[ApplyTeacherVC alloc]init];
        applyVC.returnAction = ^(NSString *info){
            labelAry = @[@"已收藏",@"已报名",@"离线下载"];
            teacherAry = @[@"申请审核中"];
            which = 2;
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:@"1" forKey:@"TeacherState"];
            [SVProgressHUD showInfoWithStatus:info];
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:applyVC animated:YES];
    }
}


- (void) backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createTableView{
    UITableView *tableView;
//<<<<<<< .mine
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64 , self.view.frame.size.width, 44 * (labelAry.count + teacherAry.count) + (teacherAry.count + 1) * 10) style:UITableViewStylePlain];
//=======
//    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64 + 15, self.view.frame.size.width, GLScreenH - 64 - 15) style:UITableViewStylePlain];
//>>>>>>> .r1451
    tableView.delegate = self;
    tableView.dataSource = self;
//    tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.scrollEnabled = NO;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//<<<<<<< .mine
    tableView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f8f8f8"];
    tableView.bounces = NO;
    self.tableView = tableView;
//=======
//>>>>>>> .r1451
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (0 == buttonIndex) {
        SerialsCourseVC *serial = [[SerialsCourseVC alloc]init];
        [self.navigationController pushViewController:serial animated:YES];
    }else if (1 == buttonIndex){
        CourseTimeVC *courseTimeVC = [[CourseTimeVC alloc]init];
        [self.navigationController pushViewController:courseTimeVC animated:YES];
    }
}

//-(void)configNav
//{
//
//    UIButton *sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 35, 28)];
//    [sendBtn setImage:[UIImage imageNamed:@"BQ_DT_release"] forState:UIControlStateNormal];
//    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [sendBtn addTarget:self action:@selector(addCourse) forControlEvents:UIControlEventTouchUpInside];
//    [sendBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
//    UIBarButtonItem *sendBarBtn = [[UIBarButtonItem alloc]initWithCustomView:sendBtn];
//    self.navigationItem.rightBarButtonItem = sendBarBtn;
//    
//}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (teacherAry.count) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return labelAry.count;
    }

    return teacherAry.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"MycourseCell";
    MycourseCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[MycourseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    if (indexPath.section == 0) {
        [cell.firstImageView setImage:[UIImage imageNamed:[image1Ary objectAtIndex:indexPath.row]]];
        [cell.twoLabel setText:[labelAry objectAtIndex:indexPath.row]];
    }else if (indexPath.section == 1) {
        [cell.firstImageView setImage:[UIImage imageNamed:[image2Ary objectAtIndex:indexPath.row]]];
        [cell.twoLabel setText:[teacherAry objectAtIndex:indexPath.row]];
    }
    
    
    [cell.twoLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"212121"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (1 == indexPath.section) {
        if (indexPath.row == 0) {
            if (which == 0) {
                ZBYGCoursTimeVC *vc = [[ZBYGCoursTimeVC alloc]init];
                vc.user = [LoginVM getInstance].users;
                vc.title = @"我的预告";
                [self.navigationController pushViewController:vc animated:YES];
            }else if (1 == which){
                ApplyTeacherVC *applyVC = [[ApplyTeacherVC alloc]init];
                applyVC.returnAction = ^(NSString *info){
                    labelAry = @[@"已收藏",@"已报名",@"离线下载"];
                    teacherAry = @[@"申请审核中"];
                    which = 2;
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:@"1" forKey:@"TeacherState"];
                    [SVProgressHUD showInfoWithStatus:info];
                    [self.tableView reloadData];
                };
                [self.navigationController pushViewController:applyVC animated:YES];
            }else if (-1 == which){
//                SendedCourseTimeListVC *vc = [[SendedCourseTimeListVC alloc]init];
//                vc.userID = [LoginVM getInstance].users.uid;
//                vc.isRootVCComing = YES;
//                [self.navigationController pushViewController:vc animated:YES];
            }else if (2 == which){
                NSDictionary *parameters = @{
                                             @"access_token":[LoginVM getInstance].readLocal.token,
                                             };
                
                [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/Study/checkApply"] parameters:parameters success:^(id json) {
                    
                    
                    [SVProgressHUD showInfoWithStatus:json[@"info"]];
                        return ;
                    
                    //        NSLog(@"TTT--json%@",json);
                } failure:^(NSError *error) {
                    //[SVProgressHUD showInfoWithStatus:error];
                }];

            }
        }else if(1 == indexPath.row){
            if (which == 0) {
                ZBCourstTimeVC *vc = [[ZBCourstTimeVC alloc]init];
                vc.user = [LoginVM getInstance].users;
                vc.title = @"我的直播";
                [self.navigationController pushViewController:vc animated:YES];

            }
        }else if (2 == indexPath.row){
            if (0 == which) {
                LuXiangCourseTimeVC *vc = [[LuXiangCourseTimeVC alloc]init];
                vc.user = [LoginVM getInstance].users;
                vc.title = @"我的录像";
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else if (3 == indexPath.row){
            PlayBackVideoCourseVC *playBackVC = [[PlayBackVideoCourseVC alloc]init];
            playBackVC.user = [LoginVM getInstance].users;
            playBackVC.title = @"已发布";
            [self.navigationController pushViewController:playBackVC animated:YES];
        }
        return;
    }else {
        if (0 == indexPath.row) {
            if (0 == which) {
                FocusedCourseTimeListVC *focusedVC = [[FocusedCourseTimeListVC alloc]init];
                [self.navigationController pushViewController:focusedVC animated:YES];
                
            }else if(-1 == which){
                ZBYGCoursTimeVC *vc = [[ZBYGCoursTimeVC alloc]init];
                vc.user = self.user;
//                vc.title = @"他的预告";
                vc.title = @"我的预告";
                [self.navigationController pushViewController:vc animated:YES];

            }else{
                FocusedCourseTimeListVC *focusedVC = [[FocusedCourseTimeListVC alloc]init];
                [self.navigationController pushViewController:focusedVC animated:YES];
            }
        }else if (1 == indexPath.row){
            if (0 == which) {
                HasBoughtCourseTimeVC *hasVC = [[HasBoughtCourseTimeVC alloc]init];
                [self.navigationController pushViewController:hasVC animated:YES];
            }else if(-1 == which){
                ZBCourstTimeVC *vc = [[ZBCourstTimeVC alloc]init];
                vc.user = self.user;
//                vc.title = @"他的直播";
                vc.title = @"我的直播";
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                HasBoughtCourseTimeVC *hasVC = [[HasBoughtCourseTimeVC alloc]init];
                [self.navigationController pushViewController:hasVC animated:YES];
            }
            
        }else if (2 == indexPath.row){
            if (-1 == which) {
                PlayBackVideoCourseVC *playBackVC = [[PlayBackVideoCourseVC alloc]init];
                playBackVC.user = self.user;
//                playBackVC.title = @"他的课程";
                playBackVC.title = @"已发布";
                [self.navigationController pushViewController:playBackVC animated:YES];

            }else{
                playerDownLoad *vc = [playerDownLoad new];
                
                self.navigationController.hidesBottomBarWhenPushed = YES;
                
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else{
            FocusedCourseTimeListVC *focusedVC = [[FocusedCourseTimeListVC alloc]init];
            [self.navigationController pushViewController:focusedVC animated:YES];
        }
//<<<<<<< .mine
//    
//=======
//    }else if(3 == indexPath.row){
//        if (0 == which) {
//            FocusedCourseTimeListVC *focusedVC = [[FocusedCourseTimeListVC alloc]init];
//            [self.navigationController pushViewController:focusedVC animated:YES];
//        }else{
//            playerDownLoad *vc = [playerDownLoad new];
//            
//            self.navigationController.hidesBottomBarWhenPushed = YES;
//            
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//    }else{
//        playerDownLoad *vc = [playerDownLoad new];
//        
//        self.navigationController.hidesBottomBarWhenPushed = YES;
//        
//        [self.navigationController pushViewController:vc animated:YES];
//>>>>>>> .r1451
//    }
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}


@end
