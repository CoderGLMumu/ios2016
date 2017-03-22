//
//  AlivcLiveRoomViewController.m
//  DevAlivcLiveVideo
//
//  Created by LYZ on 16/7/6.
//  Copyright © 2016年 Alivc. All rights reserved.
//

#import "AlivcLiveRoomViewController.h"
#import <AlivcLiveChatRoomUI/AlivcLiveChatRoomUI.h>


#define kAlivcLiveScreenWidth [UIScreen mainScreen].bounds.size.width
#define kAlivcLiveScreenHeight [UIScreen mainScreen].bounds.size.height


@interface AlivcLiveRoomViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *chatTableView;
@property (nonatomic, strong) NSMutableArray *chatDataArray;

@end

@implementation AlivcLiveRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.chatDataArray = [NSMutableArray array];
    
    [self loadChatTableView];
  
}


// init TableView
- (void)loadChatTableView {
    
    self.chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, kAlivcLiveScreenHeight - 200, kAlivcLiveScreenWidth / 2, 170) style:(UITableViewStylePlain)];
    self.chatTableView.delegate = self;
    self.chatTableView.dataSource = self;
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.chatTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"chatTableViewID"];
    [self.view addSubview:self.chatTableView];
    
}


// reload dataArray
- (void)chatDataArrayAddMessageWithString:(NSString *)messageString {
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        [self.chatDataArray addObject:messageString];
        
        [self.chatTableView reloadData];
        
        // 滑动到底部
        [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.chatDataArray.count - 1) inSection:0] atScrollPosition:(UITableViewScrollPositionBottom) animated:YES];
        
    });
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    /** 全部列表页面的空数据占位图片 */
    notDataShowView *view;
    
    if (self.chatDataArray.count) {
        if ([notDataShowView sharenotDataShowView].superview) {
            [[notDataShowView sharenotDataShowView] removeFromSuperview];
        }
    }else {
        view = [notDataShowView sharenotDataShowView:tableView];
        [tableView addSubview:view];
        
    }
    
    return self.chatDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatTableViewID" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = self.chatDataArray[indexPath.row];
    
    return cell;
}


#pragma mark RCIMClientReceiveMessageDelegate



#pragma mark buttonAction 

- (IBAction)sendButtonAction:(UIButton *)sender {
    
  
                                           
    [self chatDataArrayAddMessageWithString:[NSString stringWithFormat:@"我:123"]];

                                           
    
}


- (IBAction)supportButtonAction:(UIButton *)sender {
    
    AlivcLiveSupportView *supportView = [[AlivcLiveSupportView alloc] init];
    
    supportView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 100, [UIScreen mainScreen].bounds.size.height - 100, 36, 36);
    
    [supportView alivcSupportAnimateInView:self.view];

    
}


- (IBAction)backButtonAction:(UIButton *)sender {
    
   
    [self dismissViewControllerAnimated:YES completion:nil];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
