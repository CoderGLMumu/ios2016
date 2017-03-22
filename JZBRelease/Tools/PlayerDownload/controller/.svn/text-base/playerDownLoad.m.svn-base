//
//  playerDownLoad.m
//  JZBRelease
//
//  Created by zjapple on 16/10/21.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "playerDownLoad.h"
#import "playerDownLoadCell.h"
#import "playerDownLoadItem.h"
#import "ZFDownloadManager.h"
#import "ZFSessionModel.h"

#import "XBOffLiveVideoShowVC.h"
#import "XBOffLiveVoiceShowVC.h"
#import "AskAnswerItem.h"

#import "PlayerDowning.h"
#import "XBVideoAndVoiceVC.h"

#import "CourseTimeEvaluateModel.h"

@interface playerDownLoad ()<ZFDownloadDelegate,UITableViewDelegate,UITableViewDataSource>

/** isEdit */
@property (nonatomic, assign) BOOL isEdit;

/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 正在下载 */
@property (nonatomic, strong) NSMutableArray *downloading;

/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** botview */
@property (nonatomic, weak) UIView *botview;
/** deleteBtn */
@property (nonatomic, weak) UIButton *deleteBtn;
/** 删除所有按钮 */
@property (nonatomic, weak) UIButton *allSelectedBtn;
/** 编辑-选择按钮 */
@property (nonatomic, weak) UIButton *selectedBtn;

/** 是否正在下载中 */
@property (nonatomic, assign) BOOL isdownLoadStatus;


/** progressView */
@property (nonatomic, weak) UIProgressView *progressView;
/** top_leftLabel */
@property (nonatomic, weak) UILabel *top_leftLabel;
/** top_rightLabel */
@property (nonatomic, weak) UILabel *top_rightLabel;

@end

@implementation playerDownLoad

static NSString *ID = @"playerDownLoadCell";
static playerDownLoad *_instance;

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)dealloc
{
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f8f8f8"];
    
//    [self.tableView registerNib:[UINib nibWithNibName:@"WDBListCell" bundle:nil] forCellReuseIdentifier:ID];
    
    [self setupTableView];
    
    [self setupNavView];
    
    [self setupbotView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadData];
    
    if (self.selectedBtn.isSelected) {
        [self MultipleRemove:self.selectedBtn];
    }
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.selectedBtn.isSelected) {
        [self MultipleRemove:self.selectedBtn];
    }
}

- (void)setupNavView
{
    self.title = @"离线下载";
    
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

- (void)loadData
{
//    self.dataSource = nil;
//    
//    self.dataSource = [NSMutableArray arrayWithArray:@[@"1",@"12",@"13",@"14",@"15"]];
    
    [ZFDownloadManager sharedInstance].downloadingArray = nil;
    [ZFDownloadManager sharedInstance].downloadedArray = nil;
    
    self.downloading = [ZFDownloadManager sharedInstance].downloadingArray;
    
    if (self.downloading.count) {
        self.isdownLoadStatus = YES;
    }else {
        self.isdownLoadStatus = NO;
    }
    
    [self.dataSource removeAllObjects];
    NSMutableArray *downladed = [ZFDownloadManager sharedInstance].downloadedArray;
    [self.dataSource addObjectsFromArray:downladed];
    
    [self.tableView reloadData];
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change     context:(void *)context
//{
//    NSLog(@"%@ %@ %@ %@", object, keyPath, change, context);
//}

- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, GLScreenW, GLScreenH) style:UITableViewStylePlain];
    
//    [tableView registerClass:[JSCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    
    [tableView registerNib:[UINib nibWithNibName:@"playerDownLoadCell" bundle:nil] forCellReuseIdentifier:ID];
    
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
    
    playerDownLoadCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    // 设置 Cell...
    
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 107;
}

- (void)pushDowningList:(UIControl *)btn
{
    PlayerDowning *vc = [PlayerDowning new];
    
//    vc.dwoningCallBacll = ^(NSString *size,NSString *speed,float progress){
//        self.top_rightLabel.text   = size;
//        //                    cell.speedLabel.text      = speed;
//            self.progressView.progress    = progress;
//    };
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //在这里设置组的头部视图是位置和宽高都是没有效果的, 它专门有一个方法来设置头部视图的高度
    UIView *sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    sectionHeader.backgroundColor = [UIColor whiteColor];
    
    if (self.isdownLoadStatus) {
        
        UIControl *topView = [UIControl new];
        topView.frame = CGRectMake(0, 0, GLScreenW, 68);
        topView.backgroundColor = [UIColor whiteColor];
        [sectionHeader addSubview:topView];
        
        [topView addTarget:self action:@selector(pushDowningList:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *pic = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LXXZ_down"]];
        pic.frame = CGRectMake(20, 15, pic.glw_width, pic.glh_height);
        [topView addSubview:pic];
        
        UILabel *titleLabel1 = [UILabel new];
        [topView addSubview:titleLabel1];
        titleLabel1.text = @"正在缓存";
        titleLabel1.textColor = [UIColor hx_colorWithHexRGBAString:@"212121"];
        titleLabel1.font = [UIFont systemFontOfSize:15];
        titleLabel1.frame = CGRectMake(pic.glr_right + 12, 26, 0, 0);
        [titleLabel1 sizeToFit];
        
        if (self.downloading.count) {
            titleLabel1.text = [NSString stringWithFormat:@"正在缓存（%lu）",(unsigned long)self.downloading.count];
        }
        
        [titleLabel1 sizeToFit];
        
//        UILabel *titleLabel3 = [UILabel new];
//        self.top_rightLabel = titleLabel3;
//        [topView addSubview:titleLabel3];
//        ZFSessionModel *model2 = self.downloading.lastObject;
//        //        titleLabel3.text = model2.totalSize;
//        
//        NSUInteger receivedSize = ZFDownloadLength(model2.url);
//        NSString *writtenSize = [NSString stringWithFormat:@"%.2f %@",
//                                 [model2 calculateFileSizeInUnit:(unsigned long long)receivedSize],
//                                 [model2 calculateUnit:(unsigned long long)receivedSize]];
//        titleLabel3.text = [NSString stringWithFormat:@"%@/%@",writtenSize,model2.totalSize];
////        titleLabel3.text = @"111111";
//        titleLabel3.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
//        titleLabel3.font = [UIFont systemFontOfSize:11];
//        [titleLabel3 sizeToFit];
//        titleLabel3.frame = CGRectMake(GLScreenW - 55 -titleLabel3.glw_width, titleLabel1.glb_bottom + 5, titleLabel3.glw_width, titleLabel3.glh_height);
//        
//        UILabel *titleLabel2 = [UILabel new];
//        self.top_leftLabel = titleLabel2;
//        [topView addSubview:titleLabel2];
//        ZFSessionModel *model = self.downloading.lastObject;
//        titleLabel2.text = model.titleL;
////        titleLabel2.text = @"1111111111111111111111111111111111111111111111111111";
//        titleLabel2.textColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
//        titleLabel2.font = [UIFont systemFontOfSize:11];
//        [titleLabel2 sizeToFit];
//        titleLabel2.frame = CGRectMake(pic.glr_right + 12, titleLabel1.glb_bottom + 5, GLScreenW - 126 - (titleLabel3.glw_width + 20), titleLabel2.glh_height);
//        
//        UIProgressView *progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(pic.glr_right + 12, titleLabel2.glb_bottom + 8, GLScreenW - 125, 8)];
//        self.progressView = progressView;
//        [topView addSubview:progressView];
//        CGFloat progress = 1.0 * receivedSize / model.totalLength;
//        progressView.progress = progress;
//        //设置进度条颜色
//        progressView.trackTintColor = [UIColor hx_colorWithHexRGBAString:@"bdbdbd"];
//        //设置进度条上进度的颜色
//        progressView.progressTintColor = [UIColor hx_colorWithHexRGBAString:@"2198f2"];
//        
        UIView *midView = [UIView new];
        midView.frame = CGRectMake(0, 68, GLScreenW, 14);
        midView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f8f8f8"];
        [sectionHeader addSubview:midView];
//
//        
        UIView *botView = [UIView new];
        botView.frame = CGRectMake(0, 68 + 14, GLScreenW, 44);
        botView.backgroundColor = [UIColor whiteColor];
        [sectionHeader addSubview:botView];
//
        UILabel *CellTitle = [UILabel new];
        
        CellTitle.frame = CGRectMake(20, 0, 0, 0);
        CellTitle.text = @"已缓存";
        [CellTitle sizeToFit];
        CellTitle.glcy_centerY = 22;
        CellTitle.textColor = [UIColor hx_colorWithHexRGBAString:@"212121"];
        CellTitle.font = [UIFont systemFontOfSize:15];
        [botView addSubview:CellTitle];
        
        UIView *fengexian = [UIView new];
        fengexian.frame = CGRectMake(0, 44, GLScreenW, 1);
        [fengexian setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"bdbdbd"]];
        [botView addSubview:fengexian];

        UIImageView *tipImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LXXZ_arrow"]];
        tipImageV.frame = CGRectMake(GLScreenW - 20 - tipImageV.glw_width, 73 * 0.5 - tipImageV.glh_height * 0.5, tipImageV.glw_width, tipImageV.glh_height);
        [topView addSubview:tipImageV];
        
        
    }else{
        
        UILabel *CellTitle = [UILabel new];
        
        CellTitle.frame = CGRectMake(20, 0, 0, 0);
        CellTitle.text = @"已缓存";
        [CellTitle sizeToFit];
        CellTitle.glcy_centerY = 22;
        CellTitle.textColor = [UIColor hx_colorWithHexRGBAString:@"212121"];
        CellTitle.font = [UIFont systemFontOfSize:15];
        
        [sectionHeader addSubview:CellTitle];
        
        UIView *fengexian = [UIView new];
        fengexian.frame = CGRectMake(0, 44, GLScreenW, 1);
        [fengexian setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"bdbdbd"]];
        [sectionHeader addSubview:fengexian];
        
    }
    
    return sectionHeader;
}

//返回组的头部视图的高度.
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (self.isdownLoadStatus) {
        return 126;
    }
    
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (!self.isEdit) {
     
        ZFSessionModel *model = self.dataSource[indexPath.row];
        
//        model
//        if ([model.type isEqualToString:@"2"]) {
////            XBOffLiveVideoShowVC *vc = [XBOffLiveVideoShowVC new];
////            
////            vc.videoURL = [NSURL URLWithString:model.url];
////            
////            [self presentViewController:vc animated:YES completion:nil ];
//            
//            XBOffLiveVoiceShowVC *vc = [XBOffLiveVoiceShowVC new];
//            
//            vc.videoURL = [NSURL URLWithString:model.url];
//            
//            vc.teacher = model.liveitem.teacher;
//            vc.join_list_user = model.liveitem.online_user;
//            vc.class_id = model.liveitem.aid;
//            
//            NSArray *questionArr = [AskAnswerItem mj_objectArrayWithKeyValuesArray:model.liveitem.question];
//            
//            vc.question = questionArr;
//            
//            vc.liveitem = model.liveitem;
//            
//            
//            [self presentViewController:vc animated:YES completion:nil ];
//
//        }
        
        //课时类型 1视频 2音频 3直播 4语音直播 5线下
        if ([model.type isEqualToString:@"1"] || [model.type isEqualToString:@"2"]){
            
            XBVideoAndVoiceVC *vc = [XBVideoAndVoiceVC new];
            if ([model.type isEqualToString:@"1"]) {
                vc.videoOrVoice = YES;
            }
            vc.videoURL = [NSURL URLWithString:model.url];
            
            
            vc.teacher = model.liveitem.teacher;
            vc.join_list_user = model.liveitem.online_user;
            vc.class_id = model.liveitem.aid;
            
            model.liveitem.question = [CourseTimeEvaluateModel mj_objectArrayWithKeyValuesArray:model.liveitem.evaluate];
            
            vc.question = [[model.liveitem.question reverseObjectEnumerator] allObjects];
            
            vc.liveitem = model.liveitem;
            
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }
        
        return;
    }
    
    GLLog(@"%lu",tableView.indexPathsForSelectedRows.count);
    if (tableView.indexPathsForSelectedRows.count == 0) {
        
        if (self.allSelectedBtn.isSelected) {
            //            [self selectAllBtnClick:self.allSelectedBtn];
            self.selectedBtn.selected = !self.selectedBtn.selected;
        }
        
        self.deleteBtn.enabled = NO;
        
        [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除"] forState:UIControlStateNormal];
        
    }else {
        
        if (self.dataSource.count == tableView.indexPathsForSelectedRows.count) {
            if (!self.allSelectedBtn.isSelected) {
                //                [self selectAllBtnClick:self.allSelectedBtn];
                self.allSelectedBtn.selected = !self.allSelectedBtn.selected;
                
            }
        }
        self.allSelectedBtn.selected = YES;
        self.deleteBtn.enabled = YES;
    
        [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除(%lu)",self.tableView.indexPathsForSelectedRows.count] forState:UIControlStateNormal];
        
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        
        [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除%lu",self.tableView.indexPathsForSelectedRows.count] forState:UIControlStateNormal];
        
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
        
        self.isEdit = YES;
        
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.35 animations:^{
            self.botview.alpha = 1;
        }];
        
        
        if (self.allSelectedBtn.selected) {
            [self selectAllBtnClick:self.allSelectedBtn];
            [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除"] forState:UIControlStateNormal];
            self.deleteBtn.enabled = NO;
        }
        
    }else {
        
        self.isEdit = NO;
        
        [btn setTitle:@"编辑" forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.35 animations:^{
           self.botview.alpha = 0;
        }];
        
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



//#pragma mark - ZFDownloadDelegate
//
//- (void)downloadResponse:(ZFSessionModel *)sessionModel
//{
//    if (self.downloading) {
//        // 取到对应的cell上的model
//        NSArray *downloadings = self.downloading;
//        if ([downloadings containsObject:sessionModel]) {
//            
//            __weak typeof(self) weakSelf = self;
//            sessionModel.progressBlock = ^(CGFloat progress, NSString *speed, NSString *remainingTime, NSString *writtenSize, NSString *totalSize) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    weakSelf.top_rightLabel.text   = [NSString stringWithFormat:@"%@/%@",writtenSize,totalSize];
////                    cell.speedLabel.text      = speed;
//                    weakSelf.progressView.progress    = progress;
//                    
//                });
//            };
//        }
//    }
//}


//类方法，返回一个单例对象
+ (instancetype)shareplayerDownLoad
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
