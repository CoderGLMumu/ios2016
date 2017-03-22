//
//  ManagerCacheVC.m
//  JZBRelease
//
//  Created by cl z on 16/11/11.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "ManagerCacheVC.h"
#import "ManagerCacheCell.h"
#import "Defaults.h"
#import "CustomAlertView.h"
@interface ManagerCacheVC ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    NSIndexPath *gindexPath;
    UIButton *selectAllBtn;
    UIView *view;
}

@property (nonatomic, strong) NSArray *audioArray,*videoArray;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIButton *selectedBtn,*deleteBtn;
@property (nonatomic, assign) BOOL isEdit;


@end

@implementation ManagerCacheVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"清理缓存";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.dataSource = [[NSMutableArray alloc]init];
    //= @[@"图片",@"音频",@"问答音频"];
    [self createTableView];
    [SVProgressHUD showWithStatus:@"计算数据中..."];
    [self caluateData];
    [self setupNavView];
    [self initBottomViews];
    view.alpha = 0;
}

- (void)caluateData{
    dispatch_async(dispatch_queue_create("", nil), ^{
        NSArray *xbPicFileArray = [LocalDataRW getAllFilesNameWithDirectory:Directory_XB WithRelativeDir:nil WithSuffix:@".jpg"];
        if (xbPicFileArray && xbPicFileArray.count > 0) {
            NSString *xbsize = [LocalDataRW calculateFilesSize:xbPicFileArray];
            ManagerCacheModel *model = [[ManagerCacheModel alloc]init];
            model.name = @"学吧图片";
            model.size = xbsize;
            [self.dataSource addObject:model];
        }
        NSArray *bbPicFileArray = [LocalDataRW getAllFilesNameWithDirectory:Directory_BB WithRelativeDir:nil WithSuffix:@".jpg"];
        if (bbPicFileArray && bbPicFileArray.count > 0) {
            NSString *bbsize = [LocalDataRW calculateFilesSize:bbPicFileArray];
            ManagerCacheModel *model = [[ManagerCacheModel alloc]init];
            model.name = @"帮吧图片";
            model.size = bbsize;
            [self.dataSource addObject:model];
        }
        
        NSArray *zxPicFileArray = [LocalDataRW getAllFilesNameWithDirectory:Directory_ZX WithRelativeDir:nil WithSuffix:@".jpg"];
        if (zxPicFileArray && zxPicFileArray.count > 0) {
            NSString *zxsize = [LocalDataRW calculateFilesSize:zxPicFileArray];
            ManagerCacheModel *model = [[ManagerCacheModel alloc]init];
            model.name = @"资讯图片";
            model.size = zxsize;
            [self.dataSource addObject:model];
        }
        
        NSArray *bbaudioFileArray = [LocalDataRW getAllFilesNameWithDirectory:Directory_ZX WithRelativeDir:@"GLRecorderTool" WithSuffix:@".amr"];
        if (bbaudioFileArray && bbaudioFileArray.count > 0) {
            NSString *zxsize = [LocalDataRW calculateFilesSize:bbaudioFileArray];
            ManagerCacheModel *model = [[ManagerCacheModel alloc]init];
            model.name = @"帮吧音频";
            model.size = zxsize;
            [self.dataSource addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [self.tableView reloadData];
        });
    });
}

- (void)createTableView{
    NSLog(@"self.view.frame.size.height %f",self.view.frame.size.height);
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 49) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f2f2f2"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
}

- (void)setupNavView
{
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

- (void)initBottomViews{
    view = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49)];
    [view setBackgroundColor:[UIColor whiteColor]];
    view.layer.borderColor = [UIColor hx_colorWithHexRGBAString:@"f2f2f2"].CGColor;
    view.layer.borderWidth = 0.8;
    [self.view addSubview:view];
    
    selectAllBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width / 2, view.frame.size.height)];
    [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    //[selectAllBtn setTitle:@"取消全选" forState:UIControlStateSelected];
    selectAllBtn.titleLabel.font = [UIFont systemFontOfSize:17];
//    [selectAllBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"1976d2"] forState:UIControlStateNormal];
    [selectAllBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"222222"] forState:UIControlStateNormal];
    [selectAllBtn addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:selectAllBtn];
    
    self.deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(view.frame.size.width / 2, 0, view.frame.size.width / 2, view.frame.size.height)];
    [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    self.deleteBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.deleteBtn addTarget:self action:@selector(remove:) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"ff9800"] forState:UIControlStateNormal];
    [self.deleteBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"bdbdbd"] forState:UIControlStateDisabled];
    [view addSubview:self.deleteBtn];
    
    [self.view addSubview:view];
}

- (void)selectAllBtn{
    
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 49;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"ManagerCacheCell";
    ManagerCacheCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ManagerCacheCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    if (0 == indexPath.section) {
        cell.model = [self.dataSource objectAtIndex:indexPath.row];
    }
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.isEdit) {
        GLLog(@"%lu",tableView.indexPathsForSelectedRows.count);
        if (tableView.indexPathsForSelectedRows.count == 0) {
            [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
            self.deleteBtn.enabled = NO;
            
            [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除"] forState:UIControlStateNormal];
            
        }else {
            if (tableView.indexPathsForSelectedRows.count == self.dataSource.count) {
                
                [selectAllBtn setTitle:@"取消全选" forState:UIControlStateNormal];
            }else{
                [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
            }
            self.deleteBtn.enabled = YES;
            
            [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除(%lu)",self.tableView.indexPathsForSelectedRows.count] forState:UIControlStateNormal];
            
        }
    }
    
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isEdit) {
        GLLog(@"%lu",tableView.indexPathsForSelectedRows.count);
        if (tableView.indexPathsForSelectedRows.count == 0) {
            [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
            self.deleteBtn.enabled = NO;
            
            [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除"] forState:UIControlStateNormal];
            
        }else {
            if (tableView.indexPathsForSelectedRows.count == self.dataSource.count) {
                
                [selectAllBtn setTitle:@"取消全选" forState:UIControlStateNormal];
            }else{
                [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
            }
            
            self.deleteBtn.enabled = YES;
            
            [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除%lu",self.tableView.indexPathsForSelectedRows.count] forState:UIControlStateNormal];
            
        }
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
- (void)MultipleRemove:(UIButton *)btn {
    // 进入/取消 【编辑模式】
    //    self.tableView.editing = !self.tableView.editing;
    
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        
        self.isEdit = YES;
        
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.35 animations:^{
            view.alpha = 1;
        }];
        
        self.deleteBtn.enabled = NO;
        
        [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除"] forState:UIControlStateNormal];
        
    }else {
        
        self.isEdit = NO;
        
        [btn setTitle:@"编辑" forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.35 animations:^{
            view.alpha = 0;
        }];
        
    }
    
    [self.tableView setEditing:!self.tableView.editing animated:YES];
}

#pragma mark - 【点击了删除】
- (void)remove:(UIButton *)btn {
    //【点击了删除】
    // 注意点:千万不要一边遍历一边删除,因为没删除掉一个元素,其他元素的索引可能会发生变化
    // 获取要删除的模型
    NSMutableArray *deletedData = [NSMutableArray array];
    for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
        [deletedData addObject:self.dataSource[indexPath.row]];
        ManagerCacheModel *model = [self.dataSource objectAtIndex:indexPath.row];
        if ([model.name isEqualToString:@"学吧图片"]) {
            NSArray *xbPicFileArray = [LocalDataRW getAllFilesNameWithDirectory:Directory_XB WithRelativeDir:nil WithSuffix:@".jpg"];
            if (xbPicFileArray && xbPicFileArray.count > 0) {
                for (int i = 0; i < xbPicFileArray.count; i ++) {
                    [LocalDataRW removeFileFromLocalWithPath:[xbPicFileArray objectAtIndex:i]];
                }
            }
        }else if([model.name isEqualToString:@"帮吧图片"]){
            NSArray *bbPicFileArray = [LocalDataRW getAllFilesNameWithDirectory:Directory_BB WithRelativeDir:nil WithSuffix:@".jpg"];
            if (bbPicFileArray && bbPicFileArray.count > 0) {
                for (int i = 0; i < bbPicFileArray.count; i ++) {
                    [LocalDataRW removeFileFromLocalWithPath:[bbPicFileArray objectAtIndex:i]];
                }
            }
        }else if ([model.name isEqualToString:@"资讯图片"]){
            NSArray *zxPicFileArray = [LocalDataRW getAllFilesNameWithDirectory:Directory_ZX WithRelativeDir:nil WithSuffix:@".jpg"];
            if (zxPicFileArray && zxPicFileArray.count > 0) {
                for (int i = 0; i < zxPicFileArray.count; i ++) {
                    [LocalDataRW removeFileFromLocalWithPath:[zxPicFileArray objectAtIndex:i]];
                }
            }
        }else if ([model.name isEqualToString:@"帮吧音频"]){
            NSArray *bbAudioFileArray = [LocalDataRW getAllFilesNameWithDirectory:Directory_ZX WithRelativeDir:@"GLRecorderTool" WithSuffix:@".amr"];
            if (bbAudioFileArray && bbAudioFileArray.count > 0) {
                for (int i = 0; i < bbAudioFileArray.count; i ++) {
                    [LocalDataRW removeFileFromLocalWithPath:[bbAudioFileArray objectAtIndex:i]];
                }
            }
        }
    }
    
    // 修改模型
    [self.dataSource removeObjectsInArray:deletedData];
    
    // 刷新表格
    //    [self.tableView reloadData];
    [self.tableView deleteRowsAtIndexPaths:self.tableView.indexPathsForSelectedRows withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self MultipleRemove:self.selectedBtn];
    [UIView animateWithDuration:0.35 animations:^{
        view.alpha = 0;
    }];
}



#pragma mark - 【删除 - 全选】
- (void)selectAllBtnClick:(UIButton *)button {
    
    NSMutableArray *deletedData = [NSMutableArray array];
    
    button.selected = !button.selected;
    
    if (self.tableView.indexPathsForSelectedRows.count == 0) {
        [selectAllBtn setTitle:@"取消全选" forState:UIControlStateNormal];
        self.deleteBtn.enabled = YES;
        
        [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除所有"] forState:UIControlStateNormal];
        
        for (int i = 0; i < self.dataSource.count; i ++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
            [deletedData addObjectsFromArray:self.dataSource];
        }
        
    }else {
        for (int i = 0; i < self.dataSource.count; i ++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            //            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
            [deletedData addObjectsFromArray:self.dataSource];
        }

        if (self.tableView.indexPathsForSelectedRows.count == self.dataSource.count) {
            [selectAllBtn setTitle:@"取消全选" forState:UIControlStateSelected];
        }else{
            [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        }
        self.deleteBtn.enabled = NO;
        
        [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除"] forState:UIControlStateNormal];
        
        
    }
    
    
    
    GLLog(@"self.deleteArr:%@", deletedData);
}




@end
