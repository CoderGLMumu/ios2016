//
//  DY_historyTableView.m
//  test
//
//  Created by 12345 on 16/3/13.
//  Copyright © 2016年 12345. All rights reserved.
//

#import "DY_historyTableView.h"
#import "DY_searchHistoryDataBase.h"
#import "DY_historyListTableViewCell.h"
@implementation DY_historyTableView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.mb_historyArray = [NSMutableArray array];
        //从本地读取缓存的历史记录
        self.mb_historyArray = [[DY_searchHistoryDataBase shareDataBase]readLocalArray];
        self.delegate   = self;
        self.dataSource = self;
        
        
        //隐藏tableview多余的线
        [self setExtraCellLineHidden:self];
    }
    return self;
}


//去掉tableView多余的分割线
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

//添加一条历史记录
- (void)addHistoryWithString:(NSString *)string{
    
    //先改变tableview的数据源
    if ([self.mb_historyArray containsObject:string]) {
        [self.mb_historyArray removeObject:string];
        [self reloadData];
    }
    [self.mb_historyArray insertObject:string atIndex:0];
    //在进行界面插入单元格操作
    [self insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
    [self reloadData];

    //存储新的数据源到本地，以保证下次打开程序有之前搜索的记录
    [[DY_searchHistoryDataBase shareDataBase]writeLocalWithDataArray:self.mb_historyArray];
    
}


//删除一条
- (void)deleteHistoryWithIndex:(NSInteger )index{
    
    if (index >=0&& index<self.mb_historyArray.count) {
        
        [self.mb_historyArray removeObjectAtIndex:index];
        [self deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
        [[DY_searchHistoryDataBase shareDataBase]writeLocalWithDataArray:self.mb_historyArray];
        [self reloadData];
    }
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    /** 全部列表页面的空数据占位图片 */
    notDataShowView *view;
    
    if (self.mb_historyArray.count) {
        if ([notDataShowView sharenotDataShowView].superview) {
            [[notDataShowView sharenotDataShowView] removeFromSuperview];
        }
    }else {
        view = [notDataShowView sharenotDataShowView:tableView];
        [tableView addSubview:view];
        
    }
    
    return self.mb_historyArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    DY_historyListTableViewCell *cell = [self dequeueReusableCellWithIdentifier:@"identifier_history"];
    if (cell == nil) {
        cell = [[DY_historyListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifier_history"];
        [cell.mb_deleteButton addTarget:self action:@selector(handleDeleteButton:) forControlEvents:UIControlEventTouchUpInside];

    }
    cell.mb_deleteButton.tag = indexPath.row;

    if (indexPath.row>=0&&indexPath.row<self.mb_historyArray.count) {
        cell.mb_label.text = self.mb_historyArray[indexPath.row];
    }

    return cell;
    
    
}

//设置单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}


//点击搜索历史记录并回调出去
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        DY_historyListTableViewCell *cell = (DY_historyListTableViewCell*)[self cellForRowAtIndexPath:indexPath];
        if (self.mb_selectHistoryCell) {
            self.mb_selectHistoryCell(cell.mb_label.text);
        }
    }
    
}

//设置分区header的title
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"历史记录";
}

//点击删除按钮，删除历史记录
- (void)handleDeleteButton:(UIButton *)button{
    [self deleteHistoryWithIndex:button.tag];
}



- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.mb_beginDraggingBlock) {
        //回调tableview滑动的回调
        self.mb_beginDraggingBlock();
    }
}


-(void)dealloc{
    
}

@end
