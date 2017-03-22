
//
//  DY_searchViewController.m
//  test
//
//  Created by 12345 on 16/3/13.
//  Copyright © 2016年 12345. All rights reserved.
//

#import "DY_searchViewController.h"
#import "DY_searchHistoryDataBase.h"
#import "UIView+GLExtension.h"
#import "JSDropDownMenu.h"
#import "RMSearchAroundItemList.h"
#import "RMSearchActivityItemList.h"
#import "HXProvincialCitiesCountiesPickerview.h"
#import "HXAddressManager.h"
#import "SendAndGetDataFromNet.h"

@interface DY_searchViewController ()<JSDropDownMenuDataSource,JSDropDownMenuDelegate>{
    

    NSMutableArray *_data3;
    
    NSInteger _currentData3Index;
    
    NSInteger _currentData1SelectedIndex;
    JSDropDownMenu *menu;
}


/** locationButton */
@property (nonatomic, weak) UIButton *locationButton;

@property (nonatomic,strong) HXProvincialCitiesCountiesPickerview *regionPickerView;

@end

@implementation DY_searchViewController



- (void)viewDidLoad{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //初始化搜索Bar
    self.mb_searchBar = [[DY_newSearchBar alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 50)];
    self.mb_searchBar.mb_delegate = self;
    [self.view addSubview:self.mb_searchBar];
    
    //初始化定位按钮
    UIView *top2View = [UIView new];
    [self.view addSubview:top2View];
    top2View.gly_y = self.mb_searchBar.glb_bottom;
    top2View.glx_x = 0;
    top2View.glh_height = 44;
    top2View.glw_width = self.view.glw_width;
    
    
    UIButton *locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.locationButton = locationButton;
    [top2View addSubview:self.locationButton];
    [self.locationButton setTitle:self.city forState:UIControlStateNormal];
    [self.locationButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.locationButton setImage:[UIImage imageNamed:@"rm_seek_address"] forState:UIControlStateNormal];
    self.locationButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
    [self.locationButton sizeToFit];
    self.locationButton.glx_x = 10;
    self.locationButton.glcy_centerY = top2View.glh_height * 0.5;
    
    [self.locationButton addTarget:self action:@selector(showPickView:) forControlEvents:UIControlEventTouchUpInside];
    
    //初始化下拉选项
    [self dropDownMenu];
    
    //初始化历史记录列表
    [self loadHistoryTableView];
    
    //初始化搜索结果列表
    [self loadSearchResultTableView];

}


#pragma mark ------下拉选项-------
- (void)dropDownMenu
{
    // 指定默认选中
    
    _data3 = [NSMutableArray arrayWithObjects:@"个人", @"活动", nil];
    
    menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(15, 30) andHeight:30];
    menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
//    menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    menu.separatorColor = [UIColor clearColor];
    menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    menu.dataSource = self;
    menu.delegate = self;
    [self.view addSubview:menu];
}

- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    
    return 1;
}

-(BOOL)displayByCollectionViewInColumn:(NSInteger)column{
    
    return YES;
}

-(BOOL)haveRightTableViewInColumn:(NSInteger)column{
    
    return NO;
}

-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    
    return 1;
}

-(NSInteger)currentLeftSelectedRow:(NSInteger)column{
    
    return 0;
}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    
    return _data3.count;

}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    
    return _data3[_currentData3Index];
          
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    return _data3[indexPath.row];
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    _currentData3Index = indexPath.row;
}


#pragma mark ------历史记录显示列表-------
- (void)loadHistoryTableView{
    
    self.mb_historyTableView = [[DY_historyTableView alloc]initWithFrame:CGRectMake(0, 70 + 44, self.view.frame.size.width, self.view.frame.size.height-70)];
    [self.view addSubview:self.mb_historyTableView];
    
    __weak typeof(self)weakSelf = self;
    self.mb_historyTableView.mb_beginDraggingBlock = ^(){
        [weakSelf.mb_searchBar.mb_searchTextField resignFirstResponder];
    };
    
    self.mb_historyTableView.mb_selectHistoryCell = ^(NSString *string){
        [weakSelf searchDataWithInputString:string];
    };
    
}


#pragma mark ------搜索结果显示列表-------
- (void)loadSearchResultTableView{
    
    self.mb_searchResultTableView = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height-70)];
    self.mb_searchResultTableView.hidden = YES;
    self.mb_searchResultTableView.text   = @"搜索结果列表";
    self.mb_searchResultTableView.textColor = [UIColor grayColor];
    self.mb_searchResultTableView.font = [UIFont systemFontOfSize:20];
    self.mb_searchResultTableView.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.mb_searchResultTableView];
    self.mb_searchResultTableView.backgroundColor = [UIColor whiteColor];
}


#pragma mark - DY_newSearchBarDelegate
//退出搜索界面
- (void)touchQuitButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}


//隐藏搜索结果页，显示历史记录页（在点击输入框内的清除按钮或者用键盘把文字一个个删除后）
- (void)hideSearchResultTableView{
    
    //隐藏搜索结果列表，显示历史列表
    self.mb_searchResultTableView.hidden = YES;
    
}


//点击键盘上的搜索按钮后进行的搜索操作
- (void)searchDataWithInputString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return;
    }
    
    NSString *type = [NSString stringWithFormat:@"%ld",_currentData3Index + 1];
    
    NSString *city = self.locationButton.titleLabel.text;
    
    self.mb_searchBar.mb_searchTextField.text = string;
    //添加一条历史记录
    [self.mb_historyTableView addHistoryWithString:string];
    
    //开始搜索,显示搜索结果列表
//    self.mb_searchResultTableView.hidden = NO;
    
    UserInfo *userInfo = [[LoginVM getInstance]readLocal];
    
    NSDictionary *parameters = @{
                                 @"access_token":userInfo.token,
                                 @"city":city,
                                 @"type":type,
                                 @"keyword":self.mb_searchBar.mb_searchTextField.text
                                 };
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/User/search"] parameters:parameters success:^(id json) {
//        NSLog(@"gaolinaaaaaabbb = %@",json);
        if (![json[@"state"] isEqual:@(1)]) return ;
        
        NSArray *results;
        
        if ([type isEqualToString:@"1"]) {
            results = [RMSearchAroundItemList mj_objectArrayWithKeyValuesArray:json[@"data"]];
        }else if ([type isEqualToString:@"2"]) {
            results = [RMSearchActivityItemList mj_objectArrayWithKeyValuesArray:json[@"data"]];
        }
        if (self.ClickSearch) {
            if (results) {
                self.ClickSearch(results,type);
            }
        }
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)showPickView:(UIButton *)sender {
//    NSString *address = _addressLabel.text;
//    NSArray *array = [address componentsSeparatedByString:@" "];
//    
//    NSString *province = @"";//省
//    NSString *city = @"";//市
//    NSString *county = @"";//县
//    if (array.count > 2) {
//        province = array[0];
//        city = array[1];
//        county = array[2];
//    } else if (array.count > 1) {
//        province = array[0];
//        city = array[1];
//    } else if (array.count > 0) {
//        province = array[0];
//    }
    
    [self.regionPickerView showPickerWithProvinceName:[self.province substringToIndex:self.province.length - 1] cityName:[self.city substringToIndex:self.city.length - 1] countyName:nil];
    
}

- (HXProvincialCitiesCountiesPickerview *)regionPickerView {
    if (!_regionPickerView) {
        _regionPickerView = [[HXProvincialCitiesCountiesPickerview alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        __weak typeof(self) wself = self;
        _regionPickerView.completion = ^(NSString *provinceName,NSString *cityName,NSString *countyName) {
            __strong typeof(wself) self = wself;
            [self.locationButton setTitle:[NSString stringWithFormat:@"%@市",cityName] forState:UIControlStateNormal];
            
        };
        [self.view addSubview:_regionPickerView];
    }
    return _regionPickerView;
}

- (void)dealloc
{
    
}


@end
