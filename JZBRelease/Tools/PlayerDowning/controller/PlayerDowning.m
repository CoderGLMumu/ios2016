//
//  PlayerDowning.m
//  JZBRelease
//
//  Created by zjapple on 16/10/26.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "PlayerDowning.h"

#import "ZFDownloadManager.h"
#import "ZFSessionModel.h"
#import "PlayerDowningCell.h"

#import "playerDownLoad.h"


@interface PlayerDowning ()<ZFDownloadDelegate,UITableViewDelegate,UITableViewDataSource>

/** 是否正在下载中 */
@property (nonatomic, assign) BOOL isdownLoadStatus;
/** 正在下载 */
@property (nonatomic, strong) NSMutableArray *downloading;
/** 编辑-选择按钮 */
@property (nonatomic, weak) UIButton *selectedBtn;
/** isEdit */
@property (nonatomic, assign) BOOL isEdit;
/** botview */
@property (nonatomic, weak) UIView *botview;
/** deleteBtn */
@property (nonatomic, weak) UIButton *deleteBtn;
/** 【删除所有/全选】按钮 */
@property (nonatomic, weak) UIButton *allSelectedBtn;
/** deleteBtn */
@property (nonatomic, weak) UIButton *AllHandleButton_start;
/** deleteBtn */
@property (nonatomic, weak) UIButton *AllHandleButton_Pause;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataSource;

/** tableView */
@property (nonatomic, weak) UITableView *tableView;

@end

@implementation PlayerDowning

static NSString *ID = @"PlayerDowningCell";

static PlayerDowning *_instance;

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}



-(void)viewDidDisappear:(BOOL)animated
{
//    self.AllHandleButton_startOrPause.hidden = NO;
    if (!self.AllHandleButton_start.isEnabled) {
        [self MultipleRemove:self.selectedBtn];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self setupNavView];
    
    [self setupTopToolsView];
    
    [self setupTableView];
    
    [self setupbotView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [ZFDownloadManager sharedInstance].delegate = self;
    
    if (self.selectedBtn.isSelected) {
        [self MultipleRemove:self.selectedBtn];
    }
    
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.selectedBtn.isSelected) {
        [self MultipleRemove:self.selectedBtn];
    }
}

#pragma mark - 更新数据源-数据
- (void)loadData
{
    [ZFDownloadManager sharedInstance].downloadingArray = nil;
    [ZFDownloadManager sharedInstance].downloadedArray = nil;
    
    self.downloading = [ZFDownloadManager sharedInstance].downloadingArray;
    
    if (self.downloading.count) {
        self.isdownLoadStatus = YES;
    }else {
        self.isdownLoadStatus = NO;
    }
    
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:self.downloading];
    
    [self.tableView reloadData];
}

- (void)setupNavView
{
    self.title = @"正在缓存";
    
    //导航 选择按钮
    UIButton *selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectedBtn setBackgroundColor:[UIColor clearColor]];
    
    self.selectedBtn = selectedBtn;
    
    selectedBtn.frame = CGRectMake(0, 0, 60, 30);
    [selectedBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [selectedBtn setTitle:@"取消" forState:UIControlStateSelected];
    [selectedBtn addTarget:self action:@selector(MultipleRemove:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *selectItem = [[UIBarButtonItem alloc] initWithCustomView:selectedBtn];
    
    [selectedBtn setFont:[UIFont systemFontOfSize:15]];
    [selectedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    [selectedBtn sizeToFit];
    
    self.navigationItem.rightBarButtonItem =selectItem;
}


- (void)setupTopToolsView
{
    //全部开始按钮
    UIButton *selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.AllHandleButton_start = selectedBtn;
    selectedBtn.frame = CGRectMake(0, 64, GLScreenW *0.5, 44);
    [selectedBtn setTitle:@"全部开始" forState:UIControlStateNormal];
//    [selectedBtn setTitle:@"全部暂停" forState:UIControlStateSelected];
    [selectedBtn addTarget:self action:@selector(ClickAllStartOrPause:) forControlEvents:UIControlEventTouchUpInside];
    [selectedBtn setFont:[UIFont systemFontOfSize:15]];
    [selectedBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"212121"] forState:UIControlStateNormal];
    [selectedBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"212121"] forState:UIControlStateSelected];
    [selectedBtn setImage:[UIImage imageNamed:@"LXXZ_begin"] forState:UIControlStateNormal];
//    [selectedBtn setImage:[UIImage imageNamed:@"LXXZ_stop"] forState:UIControlStateSelected];
    [selectedBtn setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:selectedBtn];
    
    //全部暂停按钮
    UIButton *pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.AllHandleButton_Pause = pauseButton;
    pauseButton.frame = CGRectMake(GLScreenW *0.5, 64, GLScreenW *0.5 , 44);
    [pauseButton setTitle:@"全部暂停" forState:UIControlStateNormal];
//    [selectedBtn setTitle:@"全部暂停" forState:UIControlStateSelected];
    [pauseButton addTarget:self action:@selector(ClickAllPause:) forControlEvents:UIControlEventTouchUpInside];
    [pauseButton setFont:[UIFont systemFontOfSize:15]];
    [pauseButton setTitleColor:[UIColor hx_colorWithHexRGBAString:@"212121"] forState:UIControlStateNormal];
//    [pauseButton setTitleColor:[UIColor hx_colorWithHexRGBAString:@"212121"] forState:UIControlStateSelected];
    [pauseButton setImage:[UIImage imageNamed:@"LXXZ_stop"] forState:UIControlStateNormal];
//    [pauseButton setImage:[UIImage imageNamed:@"LXXZ_stop"] forState:UIControlStateSelected];
    [pauseButton setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:pauseButton];
    
    UIView *fengexian = [UIView new];
    fengexian.frame = CGRectMake(0, selectedBtn.glb_bottom - 1, GLScreenW, 1);
    fengexian.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"bdbdbd"];
    [self.view addSubview:fengexian];
    
//    selectedBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    selectedBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    selectedBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    
    pauseButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    pauseButton.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    
    UIView *fengexian_shuxian = [UIView new];
    fengexian_shuxian.frame = CGRectMake(GLScreenW * 0.5, 64, 1, selectedBtn.glh_height);
    fengexian_shuxian.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"bdbdbd"];
    [self.view addSubview:fengexian_shuxian];
    
//    if ([ZFDownloadManager sharedInstance].currentDownloads.count) {
//        //按钮状态 变成 全部暂停  【再点就暂停】
//        self.AllHandleButton_startOrPause.selected = YES;
//    }else{
//        //按钮状态 变成 全部开始  【再点就开始】
//        self.AllHandleButton_startOrPause.selected = NO;
//    }
    
}

- (void)setupbotView
{
    UIView *botview = [UIView new];
    botview.frame = CGRectMake(0, GLScreenH - 50, GLScreenW, 50);
    botview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:botview];
    botview.alpha = 0;
    self.botview = botview;
    
    //选择按钮
    UIButton *allSelectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.allSelectedBtn = allSelectedBtn;
    allSelectedBtn.frame = CGRectMake(0, 1, GLScreenW * 0.5, 49);
    [allSelectedBtn setTitle:@"全选" forState:UIControlStateNormal];
    [allSelectedBtn setTitle:@"取消全选" forState:UIControlStateSelected];
    [allSelectedBtn addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [allSelectedBtn setFont:[UIFont systemFontOfSize:15]];
    [allSelectedBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"212121"] forState:UIControlStateNormal];
    [allSelectedBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"212121"] forState:UIControlStateSelected];
    [botview addSubview:allSelectedBtn];
    
    //删除
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(GLScreenW * 0.5, 1, GLScreenW * 0.5, 49);
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    
    [deleteBtn addTarget:self action:@selector(remove:) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn setFont:[UIFont systemFontOfSize:15]];
    
    deleteBtn.enabled = NO;
    
    [deleteBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"ff9800"] forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"bdbdbd"] forState:UIControlStateDisabled];
    
    self.deleteBtn = deleteBtn;
    [botview addSubview:deleteBtn];
    
    UIView *fengexian = [UIView new];
    fengexian.frame = CGRectMake(0, 0, GLScreenW, 1);
    fengexian.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"e5e5e5"];
    [botview addSubview:fengexian];
    
}

#pragma mark - 【点击了  全部开始 / 全部暂停】
- (void)ClickAllStartOrPause:(UIButton *)btn
{
////    btn.selected = !btn.selected;
//    if (btn.selected) {
//        // 点击  按钮状态 变成 全部暂停  【点击了全部开始】
//        
//        for (ZFSessionModel *downloadObject in self.dataSource) {
//            
//            
//            BOOL isdown = [[ZFDownloadManager sharedInstance] isFileDownloadingForUrl:downloadObject.url withProgressBlock:^(CGFloat progress, NSString *speed, NSString *remainingTime, NSString *writtenSize, NSString *totalSize) {
//                
//            }];
//            
//            if (!isdown) {
//                [[ZFDownloadManager sharedInstance] download:downloadObject.url progress:^(CGFloat progress, NSString *speed, NSString *remainingTime, NSString *writtenSize, NSString *totalSize) {
//                    
//                } state:^(DownloadState state) {
//                    
//                } item:downloadObject.liveitem];
//            }
//        }
//        
//    }else {
//        // 状态 按钮状态 变成 全部开始 【点击了全部暂停】
//        for (ZFSessionModel *downloadObject in self.dataSource) {
//            
//            
//            BOOL isdown = [[ZFDownloadManager sharedInstance] isFileDownloadingForUrl:downloadObject.url withProgressBlock:^(CGFloat progress, NSString *speed, NSString *remainingTime, NSString *writtenSize, NSString *totalSize) {
//                
//            }];
//            
//            if (isdown) {
//                [[ZFDownloadManager sharedInstance] download:downloadObject.url progress:^(CGFloat progress, NSString *speed, NSString *remainingTime, NSString *writtenSize, NSString *totalSize) {
//                    
//                } state:^(DownloadState state) {
//                    
//                } item:downloadObject.liveitem];
//            }
//        }
//    }
    //    btn.selected = !btn.selected;
    
    // 点击  按钮状态 变成 全部暂停  【点击了全部开始】
    for (ZFSessionModel *downloadObject in self.dataSource) {
        
        BOOL isdowntest = [[ZFDownloadManager sharedInstance] isFileDownloadingForUrl:downloadObject.url];
        
        GLLog(@"%d---444444",isdowntest);
        
        BOOL isdown = [[ZFDownloadManager sharedInstance] isFileDownloadingForUrl:downloadObject.url withProgressBlock:^(CGFloat progress, NSString *speed, NSString *remainingTime, NSString *writtenSize, NSString *totalSize) {
            
        }];
        
        if (isdown) {
            
            if (isdowntest) {
                continue ;
            }
            
            [[ZFDownloadManager sharedInstance] start:downloadObject.url];
        }else{
            [[ZFDownloadManager sharedInstance] download:downloadObject.url progress:^(CGFloat progress, NSString *speed, NSString *remainingTime, NSString *writtenSize, NSString *totalSize) {
                
            } state:^(DownloadState state) {
                
            } item:downloadObject.liveitem];
        }
        
        
        
    }

}


#pragma mark - 【点击了  全部暂停】
- (void)ClickAllPause:(UIButton *)btn
{

        // 状态 按钮状态 变成 全部开始 【点击了全部暂停】
    for (ZFSessionModel *downloadObject in self.dataSource) {
        
        BOOL isdowntest = [[ZFDownloadManager sharedInstance] isFileDownloadingForUrl:downloadObject.url];
        
//        GLLog(@"%d---33333",isdowntest);
        
        BOOL isdown = [[ZFDownloadManager sharedInstance] isFileDownloadingForUrl:downloadObject.url withProgressBlock:^(CGFloat progress, NSString *speed, NSString *remainingTime, NSString *writtenSize, NSString *totalSize) {
            
        }];
        
        if (isdown) {
            
            if (!isdowntest) {
                continue ;
            }
            
            [[ZFDownloadManager sharedInstance] pause:downloadObject.url];
        }else{
//            [[ZFDownloadManager sharedInstance] download:downloadObject.url progress:^(CGFloat progress, NSString *speed, NSString *remainingTime, NSString *writtenSize, NSString *totalSize) {
//                
//            } state:^(DownloadState state) {
//                
//            } item:downloadObject.liveitem];
        }
    }
}

#pragma mark - 【删除 - 全选】
- (void)selectAllBtnClick:(UIButton *)button {
    
    NSMutableArray *deletedData = [NSMutableArray array];
    
    button.selected = !button.selected;
    
    if (self.tableView.indexPathsForSelectedRows.count == 0) {
        
        self.deleteBtn.enabled = YES;
        
        [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除所有"] forState:UIControlStateNormal];
        
        for (int i = 0; i < self.dataSource.count; i ++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
            [deletedData addObjectsFromArray:self.dataSource];
        }
        
    }else {
        
        self.deleteBtn.enabled = NO;
        
        [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除"] forState:UIControlStateNormal];
        
        for (int i = 0; i < self.dataSource.count; i ++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            //            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
            [deletedData addObjectsFromArray:self.dataSource];
        }
        
    }
    
    
    
    GLLog(@"self.deleteArr:%@", deletedData);
}

- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 44, GLScreenW, GLScreenH - 64 - 44) style:UITableViewStylePlain];
    
    //    [tableView registerClass:[JSCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    
    [tableView registerNib:[UINib nibWithNibName:@"PlayerDowningCell" bundle:nil] forCellReuseIdentifier:ID];
    
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    //    tableView.tableFooterView = self.defaultFooterView;
    //    tableView.tableHeaderView = self.defaultFooterView;
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //有数据才有分割线
    tableView.tableFooterView = [[UIImageView alloc]init];
    
    tableView.dataSource = self;
    tableView.delegate = self;
    
    tableView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f8f8f8"];
    
    //    [tableView addObserver:self forKeyPath:@"indexPathsForSelectedRows" options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(tableView)];
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    // 告诉tabelView在编辑模式下可以多选
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
}


#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    /** 全部列表页面的空数据占位图片 */
    notDataShowView *view;
    
    if (self.dataSource.count) {
        if ([notDataShowView sharenotDataShowView].superview) {
            [[notDataShowView sharenotDataShowView] removeFromSuperview];
        }
    }else {
        view = [notDataShowView sharenotDataShowView:tableView];
        [tableView addSubview:view];
        
    }
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PlayerDowningCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    // 设置 Cell...
    
//    __weak typeof(cell) weakcell = cell;
    
//    __block ZFSessionModel *downloadObject = self.dataSource[indexPath.row];
//    
//    [ZFDownloadManager sharedInstance].delegate = self;
//    cell.downloadBlock = ^(UIButton *sender) {
//        [[ZFDownloadManager sharedInstance] download:downloadObject.url progress:^(CGFloat progress, NSString *speed, NSString *remainingTime, NSString *writtenSize, NSString *totalSize) {
//            
//        } state:^(DownloadState state) {
//            
//        } item:weakcell.model.liveitem];
//    };
    
//    [[ZFDownloadManager sharedInstance] download:downloadObject.url progress:^(CGFloat progress, NSString *speed, NSString *remainingTime, NSString *writtenSize, NSString *totalSize) {} state:^(DownloadState state) {}];
    
//    UIView *view_bg = [[UIView alloc]initWithFrame:cell.frame];
//    view_bg.backgroundColor = [UIColor clearColor];
//    cell.selectedBackgroundView = nil;
    
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 107;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PlayerDowningCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.selectedBackgroundView = nil;
    
    [cell.selectedBackgroundView removeFromSuperview];
    
    if (!self.isEdit) {
        __block ZFSessionModel *downloadObject = self.dataSource[indexPath.row];
        
        [[ZFDownloadManager sharedInstance] download:downloadObject.url progress:^(CGFloat progress, NSString *speed, NSString *remainingTime, NSString *writtenSize, NSString *totalSize) {
//            GLLog(@"123123123");
        } state:^(DownloadState state) {
//           GLLog(@"3333333333333333333");
        } item:cell.model.liveitem];
        
        
        GLLog(@"cell.model.liveitem2%@",cell.model.liveitem);
        
//        if ([ZFDownloadManager sharedInstance].currentDownloads.count) {
//            //按钮状态 变成 全部暂停  【再点就暂停】
//            self.AllHandleButton_startOrPause.selected = YES;
//        }else{
//            //按钮状态 变成 全部开始  【再点就开始】
//            self.AllHandleButton_startOrPause.selected = NO;
//        }
        
//
//        for (ZFSessionModel *downloadObject in self.dataSource) {
//           
//            downloadObject.stateBlock = ^(DownloadState state){
//                if (state == 0) {
//                    self.AllHandleButton_startOrPause.selected = YES;
//                }else {
//                    self.AllHandleButton_startOrPause.selected = NO;
//                }
//            };
//            
////            if (downloadObject.stateBlockwn) {
////                self.AllHandleButton_startOrPause.selected = YES;
////            }else{
////                self.AllHandleButton_startOrPause.selected = NO;
////            }
//        }
        
        
//        __weak typeof(cell) weakcell = cell;
//        
//        cell.downloadBlock = ^(UIButton *sender) {
//            
//        };
        
        return ;
    }
    
    GLLog(@"%lu",tableView.indexPathsForSelectedRows.count);
    if (tableView.indexPathsForSelectedRows.count == 0) {
        
        if (self.allSelectedBtn.isSelected) {
//            [self selectAllBtnClick:self.allSelectedBtn];
            self.selectedBtn.selected = !self.selectedBtn.selected;
        }
        
//        [self selectAllBtnClick:self.allSelectedBtn];
        
        self.deleteBtn.enabled = NO;
        
        [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除"] forState:UIControlStateNormal];
        
        // 文字变 【全选】
        
    }else {
        if (self.dataSource.count == tableView.indexPathsForSelectedRows.count) {
            if (!self.allSelectedBtn.isSelected) {
//                [self selectAllBtnClick:self.allSelectedBtn];
                self.allSelectedBtn.selected = !self.allSelectedBtn.selected;
                
            }
        }
        
        self.allSelectedBtn.selected = YES;
        
        self.deleteBtn.enabled = YES;
        
        [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除%lu",self.tableView.indexPathsForSelectedRows.count] forState:UIControlStateNormal];
        
        
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayerDowningCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.selectedBackgroundView = nil;
    
    [cell.selectedBackgroundView removeFromSuperview];
    
    GLLog(@"%lu",tableView.indexPathsForSelectedRows.count);
    if (tableView.indexPathsForSelectedRows.count == 0) {
        
        if (self.allSelectedBtn.isSelected) {
            //  [self selectAllBtnClick:self.allSelectedBtn];
            self.allSelectedBtn.selected = !self.allSelectedBtn.selected;
        }
        
        self.deleteBtn.enabled = NO;
        
        [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除"] forState:UIControlStateNormal];
        
    }else {
        
        self.deleteBtn.enabled = YES;
        
        [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除(%lu)",self.tableView.indexPathsForSelectedRows.count] forState:UIControlStateNormal];
        
    }
}

//分隔线左对齐
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


#pragma mark - 按钮的点击事件
#pragma mark - 【编辑模式】
- (IBAction)MultipleRemove:(UIButton *)btn {
    // 进入/取消 【编辑模式】
    //    self.tableView.editing = !self.tableView.editing;
    
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        
        self.AllHandleButton_start.enabled = NO;
        self.AllHandleButton_Pause.enabled = NO;
        
        self.isEdit = YES;
        
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.35 animations:^{
            self.botview.alpha = 1;
        }];
        
        for (int i = 0; i < self.dataSource.count; ++i) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            PlayerDowningCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.speedLabel.hidden = YES;
        }
        
        if (self.allSelectedBtn.selected) {
            [self selectAllBtnClick:self.allSelectedBtn];
            [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除"] forState:UIControlStateNormal];
            self.deleteBtn.enabled = NO;
        }
        
        
    }else {
        
        self.AllHandleButton_start.enabled = YES;
        self.AllHandleButton_Pause.enabled = YES;
        
        self.isEdit = NO;
        
        [btn setTitle:@"编辑" forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.35 animations:^{
            self.botview.alpha = 0;
        }];
        
        for (int i = 0; i < self.dataSource.count; ++i) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            PlayerDowningCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.speedLabel.hidden = NO;
        }
        
    }
    
    [self.tableView setEditing:!self.tableView.editing animated:YES];
}

#pragma mark - 【点击了删除】
- (IBAction)remove:(UIButton *)btn {
    //【点击了删除】
    // 注意点:千万不要一边遍历一边删除,因为没删除掉一个元素,其他元素的索引可能会发生变化
    // 获取要删除的模型
    NSMutableArray *deletedData = [NSMutableArray array];
    for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
        [deletedData addObject:self.dataSource[indexPath.row]];
        ZFSessionModel * downloadObject = self.dataSource[indexPath.row];
        // 根据url删除该条数据
        [[ZFDownloadManager sharedInstance] deleteFile:downloadObject.url];
    }
    
    // 修改模型
    [self.dataSource removeObjectsInArray:deletedData];
    
    // 刷新表格
    //    [self.tableView reloadData];
    [self.tableView deleteRowsAtIndexPaths:self.tableView.indexPathsForSelectedRows withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self MultipleRemove:self.selectedBtn];
    
    
}


#pragma mark - ZFDownloadDelegate

- (void)downloadResponse:(ZFSessionModel *)sessionModel
{
    if (self.downloading) {
        // 取到对应的cell上的model
        NSArray *downloadings = self.downloading;
        if ([downloadings containsObject:sessionModel]) {
            
            NSInteger index = [downloadings indexOfObject:sessionModel];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            __block PlayerDowningCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            cell.downStatusButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            
            __weak typeof(self) weakSelf = self;
            sessionModel.progressBlock = ^(CGFloat progress, NSString *speed, NSString *remainingTime, NSString *writtenSize, NSString *totalSize) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.sizeLabel.text   = [NSString stringWithFormat:@"%@/%@",writtenSize,totalSize];
                    cell.speedLabel.text      = speed;
                    cell.progressV.progress    = progress;
                    cell.downStatusButton.selected = YES;
                    
                    if (index == downloadings.count) {
//                        weakSelf.dwoningCallBacll(cell.sizeLabel.text,cell.speedLabel.text,cell.progressV.progress);
                    }
                });
            };
            
            sessionModel.stateBlock = ^(DownloadState state){
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 更新数据源
                    if (state == DownloadStateCompleted) {
                        [ZFDownloadManager sharedInstance].downloadingArray = nil;
                        [weakSelf loadData];
                        cell.downStatusButton.selected = NO;
                    }
                    // 暂停
                    if (state == DownloadStateSuspended) {
                        cell.speedLabel.text = @"已暂停";
                        cell.downStatusButton.selected = NO;
                    }
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        // 暂停
                        if (state == DownloadStateSuspended) {
                            cell.speedLabel.text = @"已暂停";
                            cell.downStatusButton.selected = NO;
                        }
                    });
                    
                    
                });
            };
        }
    }
}


//类方法，返回一个单例对象
+ (instancetype)sharePlayerDowning
{
    //注意：这里建议使用self,而不是直接使用类名Tools（考虑继承）
    
    return [[self alloc]init];
}

//保证永远只分配一次存储空间
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    //    使用GCD中的一次性代码
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    
    //使用加锁的方式，保证只分配一次存储空间
    //    @synchronized(self) {
    //        if (_instance == nil) {
    //            _instance = [super allocWithZone:zone];
    //        }
    //    }
    return _instance;
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
