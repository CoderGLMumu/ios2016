//
//  DY_searchViewController.h
//  test
//
//  Created by 12345 on 16/3/13.
//  Copyright © 2016年 12345. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DY_newSearchBar.h"
#import "DY_historyTableView.h"


@interface DY_searchViewController : UIViewController<DY_newSearchBarDelegate>

@property(nonatomic,strong)DY_newSearchBar      *mb_searchBar;
//自定义搜索Bar

@property(nonatomic,strong)DY_historyTableView          *mb_historyTableView;//显示搜索历史记录列表

@property(nonatomic,strong)UILabel          *mb_searchResultTableView;//搜索结果伪列表

/** 城市 */
@property (nonatomic, strong) NSString *city;
/** 省份 */
@property (nonatomic, strong) NSString *province;


/** 搜索完成后的数据回调 */
@property (nonatomic, strong) void(^ClickSearch)(NSArray *results ,NSString *type);

@end