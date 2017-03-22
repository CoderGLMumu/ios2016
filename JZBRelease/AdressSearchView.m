//
//  AdressSearchView.m
//  JZBRelease
//
//  Created by cl z on 16/8/16.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "AdressSearchView.h"
#import "cityModel.h"
#import "AdressSearchCell.h"
@interface AdressSearchView()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation AdressSearchView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createTableView];
    }
    return self;
}

- (void)createTableView{
   
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView setBackgroundColor:[UIColor clearColor]];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self addSubview:tableView];
    self.tableView = tableView;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
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

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID=@"AdressSearchCell";
    AdressSearchCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil)
    {
        cell=[[AdressSearchCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cityModel *model=self.dataAry[indexPath.row];
    cell.titleLabel.text=model.name;
    cell.detaileLabel.text=model.address;
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.whichSelectAction) {
        self.whichSelectAction(indexPath.row);
    }
}

-(NSMutableArray *)dataAry{
    if (!_dataAry) {
        _dataAry = [[NSMutableArray alloc]init];
    }
    return _dataAry;
}

@end
