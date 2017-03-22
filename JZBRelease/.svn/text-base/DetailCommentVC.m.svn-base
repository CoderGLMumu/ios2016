//
//  DetailCommentVC.m
//  JZBRelease
//
//  Created by zjapple on 16/5/14.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "DetailCommentVC.h"
#import "ChatKeyBoard.h"
#import "DynamicDetailHeaderView.h"
#import "MoreItem.h"
#import "ChatToolBarItem.h"
#import "FaceSourceManager.h"
#import "FaceThemeModel.h"
#import "SelecterToolsScrolView.h"
#import "SelecterContentScrollView.h"
#import "ChatKeyBoardMacroDefine.h"
#import "DetailCommentLayout.h"
#import "DetailCommentCell.h"
#import "SendEvaluateModel.h"
#import "LoginVM.h"
#import "ChildEvaluateModel.h"
#import "TableViewCell.h"
//#import "OtherPersonCentralVC.h"
#import "PublicOtherPersonVC.h"
#import "DynamicCell.h"
#import "ZanCommentModel.h"
@interface DetailCommentVC()<ChatKeyBoardDataSource, ChatKeyBoardDelegate>

@property(nonatomic, strong) NSMutableArray *commentAry;
@property (nonatomic, strong) ChatKeyBoard *chatKeyBoard;
@property (nonatomic, strong)  DynamicCell *dynamicCell;
@end

@implementation DetailCommentVC{
    BOOL subComment;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)viewDidLoad{
    [self configNav];
    dispatch_async(dispatch_queue_create("", nil), ^{
        self.commentAry = [self cellWithDataModel:self.evaluateModel];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
    
    self.tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.decelerationRate = 1.0f;
    [self.view addSubview:self.tableView];
    
    self.chatKeyBoard = [ChatKeyBoard keyBoard];
    self.chatKeyBoard.delegate = self;
    self.chatKeyBoard.dataSource = self;
    self.chatKeyBoard.placeHolder = [NSString stringWithFormat:@"回复:%@",self.evaluateModel.user.nickname];
    self.chatKeyBoard.allowVoice = NO;
    self.chatKeyBoard.allowMore = NO;
    self.chatKeyBoard.allowFace = NO;
    [self.view addSubview:self.chatKeyBoard];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDataAndView) name:@"DetailCommentVC" object:nil];
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
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    subComment = NO;
    [self.chatKeyBoard keyboardDown];
    self.chatKeyBoard.placeHolder = [NSString stringWithFormat:@"回复:%@",self.evaluateModel.user.nickname];
    [UIView animateWithDuration:0.3 animations:^{
        [self.tableView setFrame:[UIScreen mainScreen].bounds];
    } completion:^(BOOL finished) {
        
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    
    /** 全部列表页面的空数据占位图片 */
    notDataShowView *view;
    
    if (self.commentAry.count) {
        if ([notDataShowView sharenotDataShowView].superview) {
            [[notDataShowView sharenotDataShowView] removeFromSuperview];
        }
    }else {
        view = [notDataShowView sharenotDataShowView:tableView];
        [tableView addSubview:view];
        
    }
    
    return self.commentAry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return nil;
    }
    static NSString *commentIdentifier = @"DetailcommentIdentifier";
    DetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentIdentifier];
    if (!cell) {
        cell = [[DetailCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentIdentifier];
    }
    if (self.commentAry.count > indexPath.row) {
        DetailCommentLayout *cellLayouts = self.commentAry[indexPath.row];
        cell.cellLayout = cellLayouts;
    }
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;

    return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (0 == section) {
        return self.dynamicCell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (0 == section) {
        return self.dynamicCell.cellLayout.cellHeight + 64 + 44 + 10;
    }
    return 0;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.commentAry) {
        DetailCommentLayout *cellLayouts = self.commentAry[indexPath.row];
        return cellLayouts.cellHeight;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailCommentLayout *layout = [self.commentAry objectAtIndex:indexPath.row];
    if ([[[LoginVM getInstance] readLocal]._id isEqualToString:layout.childEvaluateModel.user.uid]) {
        return;
    }else{
        self.chatKeyBoard.placeHolder = [NSString stringWithFormat:@"回复 %@",layout.childEvaluateModel.eval_u_nickname];
        self.chatKeyBoard.indexPath = indexPath;
        subComment = YES;
        [self.chatKeyBoard keyboardUp];
    }
}


-(NSMutableArray *)cellWithDataModel:(EvaluateModel *) evaluateModel{
    NSMutableArray *ary = [[NSMutableArray alloc]init];
    for (int i = 0; i <evaluateModel._child.count; i ++) {
        DetailCommentLayout *layout = [self layoutWithEvaluateModel:evaluateModel index:i];
        if (layout) {
            [ary addObject:layout];
        }
    }
    return ary;
}


- (DetailCommentLayout *)layoutWithEvaluateModel:(EvaluateModel *) evaluateModel index:(NSInteger)index {
    //生成Storage容器
    LWStorageContainer* container = [[LWStorageContainer alloc] init];
    //生成Layout
    DetailCommentLayout* layout = [[DetailCommentLayout alloc]initWithContainer:container Model:evaluateModel dateFormatter:nil index:index];
    return layout;
}

- (void)tableViewCell:(TableViewCell *)cell didClickedCommentWithCellLayout:(CellLayout *)layout
          atIndexPath:(NSIndexPath *)indexPath clinkType:(Clink_Type)clink_type{
    if (clink_type == Clink_Type_Six) {
//        OtherPersonCentralVC* vc = [[OtherPersonCentralVC alloc] init];
        PublicOtherPersonVC *vc = [[UIStoryboard storyboardWithName:@"PublicOtherPersonVC" bundle:nil]instantiateInitialViewController];
        
        ChildEvaluateModel *childEvaluateModel = ((DetailCommentLayout *)layout).childEvaluateModel ;
        vc.user = childEvaluateModel.user;
        vc.fromDynamicDetailVC = YES;
        
        if ([vc.user.uid isEqualToString:[LoginVM getInstance].readLocal._id] || vc.user.uid == nil) {
            return ;
        }
        
        self.navigationController.navigationBar.hidden = YES;
        self.tabBarController.tabBar.hidden = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (clink_type == Clink_Type_Two){
        DynamicLayout *wlayout = (DynamicLayout *)layout;
        ZanCommentModel *zanModel = [[ZanCommentModel alloc]init];
        zanModel.access_token = [[LoginVM getInstance] readLocal].token;
        zanModel.eval_id = wlayout.evaluateModel.eval_id;
        SendAndGetDataFromNet *sendAndGet = [[SendAndGetDataFromNet alloc]init];
        
        __block typeof (wlayout) wwlayout = wlayout;
        
        sendAndGet.returnModel = ^(GetValueObject *obj,int state){
            if (1 == state) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                    
                    if ([wwlayout.evaluateModel.is_like intValue] == 1) {
                        wwlayout.evaluateModel.like_count = [NSNumber numberWithInteger:[wwlayout.evaluateModel.like_count integerValue] - 1];
                        wwlayout.evaluateModel.is_like = @"0";
                    }else{
                        wwlayout.evaluateModel.like_count = [NSNumber numberWithInteger:[wwlayout.evaluateModel.like_count integerValue] + 1];
                        wwlayout.evaluateModel.is_like = @"1";
                    }
                    //wwlayout = [self layoutWithDetailListModel:wwlayout.evaluateModel index:indexPath.row withH:0];
                    
                    DynamicCell *wcell = (DynamicCell *)cell;
                    [wcell.tabItemBarView.zanCountLabel setText:[NSString stringWithFormat:@"%@",wwlayout.evaluateModel.like_count]];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if ([wwlayout.evaluateModel.is_like intValue] == 1) {
                            [Toast makeShowCommen:@"您为该条评论," ShowHighlight:@"成功点赞" HowLong:1.5];
                        }else{
                            [Toast makeShowCommen:@"您为该条评论," ShowHighlight:@"取消点赞" HowLong:1.5];
                        }
                    });
                });
            }else{
                
            }
        };
        [sendAndGet commenDataFromNet:zanModel WithRelativePath:@"Zan_Comment"];
    }else if (clink_type == Clink_Type_One){
        [self.chatKeyBoard keyboardUp];
    }
}

-(void)updateDataAndView{
    [self.commentAry removeAllObjects];
    self.commentAry = [self cellWithDataModel:self.evaluateModel];
    self.chatKeyBoard.placeHolder = [NSString stringWithFormat:@"回复:%@",self.evaluateModel.user.nickname];
    subComment = NO;
    [self.tableView reloadData];
}

- (DynamicLayout *)layoutWithDetailListModel:(EvaluateModel *)detilModel index:(NSInteger)index withH:(NSInteger) tag{
    //生成Storage容器
    LWStorageContainer* container = [[LWStorageContainer alloc] init];
    //生成Layout
    DynamicLayout* layout = [[DynamicLayout alloc]initWithContainer:container Model:detilModel dateFormatter:nil index:index WithDynamic:YES];
    return layout;
}

- (DynamicCell *)dynamicCell{
    
    if (_dynamicCell) {
        return _dynamicCell;
    }
    _dynamicCell = [[DynamicCell alloc]init];
    DynamicLayout *dynamicLayout = [self layoutWithDetailListModel:self.evaluateModel index:0 withH:0];
    _dynamicCell.delegate = self;
    _dynamicCell.cellLayout = dynamicLayout;
    return _dynamicCell;
}



#pragma mark -- begin edit
- (void)chatKeyBoardTextViewDidBeginEditing:(UITextView *)textView{
    
    NSLog(@"pop");
}
#pragma mark -- 发送文本
- (void)chatKeyBoardSendText:(NSString *)text
{
    [self.chatKeyBoard keyboardDown];
    if (!self.indexPath) {
        SendEvaluateModel *sendModel = [[SendEvaluateModel alloc]init];
        sendModel.access_token = [[LoginVM getInstance] readLocal].token;
        sendModel.dynamic_id = self.evaluateModel.dynamic_id;
        sendModel.content = text;
        SendAndGetDataFromNet *sendAndGet = [[SendAndGetDataFromNet alloc]init];
        if (subComment) {
            if (self.commentAry.count <= self.chatKeyBoard.indexPath.row) {
                return;
            }
            ChildEvaluateModel *child = [ChildEvaluateModel mj_objectWithKeyValues:[self.evaluateModel._child objectAtIndex:self.chatKeyBoard.indexPath.row]];
            sendModel.eval_id = child.eval_id;
            subComment = NO;
        }else{
            sendModel.eval_id = self.evaluateModel.eval_id;
        }
        __block DetailCommentVC *wself = self;
        sendAndGet.returnModel = ^(GetValueObject *obj,int state){
            if (1 == state) {
                if (wself.updateData) {
                    wself.updateData(wself.indexPath2.row);
                }
            }
        };
        [sendAndGet commenDataFromNet:sendModel WithRelativePath:@"Send_Evaluate"];

    }
}

-(void)tableViewCell:(UITableViewCell *)cell didClickedLinkWithData:(id)data clinkType:(Clink_Type)clink_type{
    
    if (Clink_Type_One == clink_type) {
//        OtherPersonCentralVC* vc = [[OtherPersonCentralVC alloc] init];
        PublicOtherPersonVC *vc = [[UIStoryboard storyboardWithName:@"PublicOtherPersonVC" bundle:nil]instantiateInitialViewController];
        
        EvaluateModel *evaluateModel = ((DetailCommentLayout *)(((DetailCommentCell *)cell).cellLayout)).evaluateModel;
        vc.user = evaluateModel.user;
        vc.fromDynamicDetailVC = YES;
        
        if ([vc.user.uid isEqualToString:[LoginVM getInstance].readLocal._id] || vc.user.uid == nil) {
            return ;
        }
        
        self.navigationController.navigationBar.hidden = YES;
        self.tabBarController.tabBar.hidden = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (Clink_Type_Two == clink_type){
        
    }else if(Clink_Type_Three == clink_type){
//        OtherPersonCentralVC* vc = [[OtherPersonCentralVC alloc] init];
        
        PublicOtherPersonVC *vc = [[UIStoryboard storyboardWithName:@"PublicOtherPersonVC" bundle:nil]instantiateInitialViewController];
        
        DetailCommentLayout *commentLayout = [self.commentAry objectAtIndex:((DetailCommentCell *)cell).indexPath.row];
        ChildEvaluateModel *childModel = [ChildEvaluateModel mj_objectWithKeyValues:[commentLayout.evaluateModel._child objectAtIndex:((DetailCommentCell *)cell).indexPath.row - 1]];
        Users *user = [[Users alloc]init];
        user.uid = childModel.eval_uid;
        user.nickname = childModel.eval_u_nickname;
        vc.user = user;
        vc.fromDynamicDetailVC = YES;
        
        if ([vc.user.uid isEqualToString:[LoginVM getInstance].readLocal._id] || vc.user.uid == nil) {
            return ;
        }
        
        self.navigationController.navigationBar.hidden = YES;
        self.tabBarController.tabBar.hidden = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        subComment = YES;
        [self.chatKeyBoard keyboardUp];
        NSLog(@"((TableViewCell *)cell).indexPath.row) %ld",((TableViewCell *)cell).indexPath.row - 1);
        if (!(self.evaluateModel._child.count > ((TableViewCell *)cell).indexPath.row - 1)) {
            return;
        }
        ChildEvaluateModel *child = [ChildEvaluateModel mj_objectWithKeyValues: [self.evaluateModel._child objectAtIndex:((TableViewCell *)cell).indexPath.row - 1]];
        
        self.chatKeyBoard.placeHolder = [NSString stringWithFormat:@"回复:%@",child.eval_u_nickname];
        self.chatKeyBoard.indexPath = ((TableViewCell *)cell).indexPath;
        CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:self.chatKeyBoard.indexPath];
        NSLog(@"%ld",self.chatKeyBoard.indexPath.row);
        CGRect rect = [self.tableView convertRect:rectInTableView toView:self.view];
        
        NSLog(@"%f",self.chatKeyBoard.frame.origin.y);
        NSLog(@"%f",self.chatKeyBoard.frame.size.height);
        NSLog(@"%f",self.view.frame.size.height);
        NSInteger keyOrginY = self.view.frame.size.height - self.chatKeyBoard.frame.size.height;
        DetailCommentLayout *layout = [self.commentAry objectAtIndex:self.chatKeyBoard.indexPath.row];
        if ((rect.origin.y + layout.cellHeight) > keyOrginY) {
            NSInteger moveSet = rect.origin.y + layout.cellHeight - keyOrginY + 49;
            [UIView animateWithDuration:0.3 animations:^{
                [self.tableView setFrame:CGRectMake(0, self.tableView.frame.origin.y - moveSet, self.tableView.frame.size.width, self.tableView.frame.size.height)];
            } completion:^(BOOL finished) {
                //[self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height -self.tableView.bounds.size.height + 60) animated:YES];
            }];
            
            //[self.tableView setContentOffset:CGPointMake(0.0, moveSet) animated:NO];
        }
    }
}

#pragma mark -- ChatKeyBoardDataSource
- (NSArray<MoreItem *> *)chatKeyBoardMorePanelItems
{
    MoreItem *item1 = [MoreItem moreItemWithPicName:@"sharemore_location" highLightPicName:nil itemName:@"位置"];
    MoreItem *item2 = [MoreItem moreItemWithPicName:@"sharemore_pic" highLightPicName:nil itemName:@"图片"];
    MoreItem *item3 = [MoreItem moreItemWithPicName:@"sharemore_video" highLightPicName:nil itemName:@"拍照"];
    MoreItem *item4 = [MoreItem moreItemWithPicName:@"sharemore_location" highLightPicName:nil itemName:@"位置"];
    MoreItem *item5 = [MoreItem moreItemWithPicName:@"sharemore_pic" highLightPicName:nil itemName:@"图片"];
    MoreItem *item6 = [MoreItem moreItemWithPicName:@"sharemore_video" highLightPicName:nil itemName:@"拍照"];
    MoreItem *item7 = [MoreItem moreItemWithPicName:@"sharemore_location" highLightPicName:nil itemName:@"位置"];
    MoreItem *item8 = [MoreItem moreItemWithPicName:@"sharemore_pic" highLightPicName:nil itemName:@"图片"];
    MoreItem *item9 = [MoreItem moreItemWithPicName:@"sharemore_video" highLightPicName:nil itemName:@"拍照"];
    return @[item1, item2, item3, item4, item5, item6, item7, item8, item9];
}
- (NSArray<ChatToolBarItem *> *)chatKeyBoardToolbarItems
{
    ChatToolBarItem *item1 = [ChatToolBarItem barItemWithKind:kBarItemFace normal:@"face" high:@"face_HL" select:@"keyboard"];
    
    ChatToolBarItem *item2 = [ChatToolBarItem barItemWithKind:kBarItemVoice normal:@"voice" high:@"voice_HL" select:@"keyboard"];
    
    ChatToolBarItem *item3 = [ChatToolBarItem barItemWithKind:kBarItemMore normal:@"more_ios" high:@"more_ios_HL" select:nil];
    
    ChatToolBarItem *item4 = [ChatToolBarItem barItemWithKind:kBarItemSwitchBar normal:@"switchDown" high:nil select:nil];
    
    return @[item1, item2, item3, item4];
}

- (NSArray<FaceThemeModel *> *)chatKeyBoardFacePanelSubjectItems
{
    return [FaceSourceManager loadFaceSource];
}

-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

@end
