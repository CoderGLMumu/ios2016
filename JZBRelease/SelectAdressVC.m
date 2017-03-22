//
//  SelectAdressVC.m
//  JZBRelease
//
//  Created by cl z on 16/8/15.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "SelectAdressVC.h"
#import "Defaults.h"
#import "ZJBHelp.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
#import "cityModel.h"
#import "AdressSearchView.h"
#import "AdressSearchCell.h"

@interface SelectAdressVC ()<UISearchBarDelegate,BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate,UITableViewDataSource,UITableViewDelegate,BMKMapViewDelegate>{
    UIView *navView;
    UIView *searchView;
    UIView *mapAndTab;
    UISearchBar *searchBar;
    BOOL beginSearch,beginSelect,noResult;
    NSInteger pre,selectRow;
    BMKPinAnnotationView *newAnnotation;
    
    BMKGeoCodeSearch *_geoCodeSearch;
    
    BMKReverseGeoCodeOption *_reverseGeoCodeOption;
    
    BMKGeoCodeSearchOption *geoCodeOption;
    
    BMKLocationService *_locService;
    AdressSearchView *adressSearchView;
    
 
}

@property (strong, nonatomic) UITableView *cityTableview;
@property (strong, nonatomic) BMKMapView *mapView;
@property (strong, nonatomic) UIButton *mapPin;
@property (strong, nonatomic) UILabel *currentAdressLabel;

@property(nonatomic,strong)NSMutableArray *cityDataArr;

@end

@implementation SelectAdressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    selectRow = -1;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    [self.view addSubview:navView];
    [navView setBackgroundColor:[UIColor whiteColor]];
    mapAndTab = [[UIView alloc]initWithFrame:CGRectMake(0, 108, SCREEN_WIDTH, SCREEN_HEIGHT - 108)];
    [self.view addSubview:mapAndTab];
    
    UIButton *backView = [[UIButton alloc] initWithFrame:CGRectMake(18, 20 + 4.5, 50, 28)];
    [backView setTitle:@"取消" forState:UIControlStateNormal];
    //[backView setBackgroundColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]]];
    [backView setTitleColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]]forState:UIControlStateNormal];
    //backView.layer.cornerRadius = 3.0;
    [backView.titleLabel setFont:[UIFont systemFontOfSize:15]];
//    UIImageView *backImageView = [UIImageView createImageViewWithFrame:CGRectMake(0, (35-20)/2, 20, 20) ImageName:@"DL_light_ARROW"];
//    backImageView.userInteractionEnabled = YES;
//    [backView addSubview:backImageView];
//    UILabel *backLabel = [UILabel createLabelWithFrame:CGRectMake(11 + 5,(35-20)/2, 40, 20) Font:17 Text:@"返回" andLCR:0 andColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]]];
//    [backView addSubview:backLabel];
    backView.tag = 0;
    [backView addTarget:self action:@selector(cancleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backView];
    
    UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50 - 18, 20 + 8, 50, 28)];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn setBackgroundColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]]];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    okBtn.layer.cornerRadius = 3.0;
    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [okBtn addTarget:self action:@selector(okBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:okBtn];
    
//    searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
//    [searchView setBackgroundColor:RGB(180, 180, 180, 1)];
    
    searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
    UIView *segment = [searchBar.subviews objectAtIndex:0];
    UIImageView *bgImage = [[UIImageView alloc] initWithImage: [[ZJBHelp getInstance] buttonImageFromColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Search_Color" WithKind:XMLTypeColors]] WithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)]];
    [segment addSubview: bgImage];
    searchBar.placeholder = @"搜索";
    searchBar.delegate = self;
    [self.view addSubview:searchBar];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesTap)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    //[self.view addGestureRecognizer:tapGestureRecognizer];
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_HEIGHT - 108) / 2 - 36)];
    [mapAndTab addSubview:_mapView];
    _mapPin = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 40) / 2, ((SCREEN_HEIGHT - 108) / 2 - 36 - 40) / 2, 40, 40)];
    [_mapView addSubview:_mapPin];
    [_mapPin setBackgroundImage:[UIImage imageNamed:@"serach_Map"] forState:UIControlStateNormal];
    
    UIView *currentView = [[UIView alloc]initWithFrame:CGRectMake(0, _mapView.frame.origin.y + _mapView.frame.size.height, SCREEN_WIDTH, 36)];
    [currentView setBackgroundColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]]];
    [mapAndTab addSubview:currentView];
    
    _currentAdressLabel = [UILabel createLabelWithFrame:CGRectMake(12, 8, SCREEN_WIDTH - 12, 20) Font:14 Text:@"【当前】" andLCR:NSTextAlignmentLeft andColor:[UIColor whiteColor]];
    [currentView addSubview:_currentAdressLabel];
    
    [self createTableView];
    [self initLocationService];
    
}

- (void)createTableView{
    NSLog(@"self.view.frame.size.height %f",self.view.frame.size.height);
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _mapView.frame.origin.y + _mapView.frame.size.height + 36, SCREEN_WIDTH, (SCREEN_HEIGHT - 108) / 2) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor whiteColor];
    [mapAndTab addSubview:tableView];
    
    self.cityTableview = tableView;
}

-(NSMutableArray *)cityDataArr
{
    if (_cityDataArr==nil)
    {
        _cityDataArr=[NSMutableArray arrayWithCapacity:15];
    }
    
    return _cityDataArr;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBars{
    [UIView animateWithDuration:0.5 animations:^{
        navView.frame = CGRectMake(0, -64, navView.frame.size.width, navView.frame.size.height);
        searchBars.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
        UIImageView *barImageView = [[[searchBar.subviews firstObject] subviews] firstObject];
        barImageView.layer.borderColor = [ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Search_Color" WithKind:XMLTypeColors]].CGColor;
        barImageView.layer.borderWidth = 1;
        [self.view setBackgroundColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Search_Color" WithKind:XMLTypeColors]]];
        searchBars.showsCancelButton = YES;
        
        [mapAndTab setFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    } completion:^(BOOL finished) {
        if (!adressSearchView) {
            adressSearchView = [[AdressSearchView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
            [adressSearchView setBackgroundColor:[UIColor blackColor]];
            adressSearchView.alpha = 0.5;
            [self.view addSubview:adressSearchView];
            __block typeof (self) wself = self;
            adressSearchView.whichSelectAction = ^(NSInteger row){
                selectRow = row;
                [wself gesTap];
            };
            adressSearchView.hidden = NO;
        }
        beginSearch = YES;
    }];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBars{
    
    [self gesTap];
}

-(void)gesTap{
    if (beginSearch) {
        UITextField *searchField = [searchBar valueForKey:@"_searchField"];
        if ([searchField isKindOfClass:[UITextField class]]) {
            [searchField setText:@""];
        }
        cityModel *searchCityModel;
        if (selectRow != -1) {
            searchCityModel = [adressSearchView.dataAry objectAtIndex:selectRow];
        }
        [adressSearchView removeFromSuperview];
        adressSearchView = nil;
        [UIView animateWithDuration:0.5 animations:^{
            navView.frame = CGRectMake(0, 0, navView.frame.size.width, navView.frame.size.height);
            searchBar.frame = CGRectMake(0, 64, SCREEN_WIDTH, 44);
            [searchBar resignFirstResponder];
            searchBar.showsCancelButton = NO;
            [mapAndTab setFrame:CGRectMake(0, 108, SCREEN_WIDTH, SCREEN_HEIGHT - 108)];
        } completion:^(BOOL finished) {
            beginSearch = NO;
            if (selectRow != -1) {
                if (!_geoCodeSearch) {
                    _geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
                    _geoCodeSearch.delegate = self;
                }
                if (!geoCodeOption) {
                    geoCodeOption = [[BMKGeoCodeSearchOption alloc]init];
                }
                geoCodeOption.address = [searchCityModel.address stringByAppendingString:searchCityModel.name];
                if ([_geoCodeSearch geoCode:geoCodeOption]) {
                    NSLog(@"success");
                }else{
                    NSLog(@"failure");
                }
            }
        }];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (!geoCodeOption) {
        geoCodeOption = [[BMKGeoCodeSearchOption alloc]init];
    }
    if (!_geoCodeSearch) {
        _geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
        _geoCodeSearch.delegate = self;
    }
    //adressSearchView.hidden = YES;
    geoCodeOption.address = searchText;
    if ([_geoCodeSearch geoCode:geoCodeOption]) {
        NSLog(@"success");
    }else{
        NSLog(@"failure");
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    _mapView.delegate = nil; // 不用时，置nil
    _geoCodeSearch.delegate = nil; // 不用时，置nil
    _reverseGeoCodeOption = nil;
    [_locService stopUserLocationService];
    _locService = nil;
    [_mapView viewWillDisappear];
    
}

-(void)cancleBtnAction : (UIButton *) btn{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)okBtnAction : (UIButton *) btn{
    if (self.cityDataArr.count > 0) {
        cityModel *cityModel = [self.cityDataArr objectAtIndex:0];
        if (self.returnAdress) {
            self.returnAdress(cityModel);
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }
}

#pragma mark  tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    /** 全部列表页面的空数据占位图片 */
    notDataShowView *view;
    
    if (self.cityDataArr.count) {
        if ([notDataShowView sharenotDataShowView].superview) {
            [[notDataShowView sharenotDataShowView] removeFromSuperview];
        }
    }else {
        view = [notDataShowView sharenotDataShowView:tableView];
        [tableView addSubview:view];
        
    }
    
    return self.cityDataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"cellID";
    AdressSearchCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil)
    {
        cell=[[AdressSearchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    cityModel*model=self.cityDataArr[indexPath.row];
    if (model.selected) {
        if (beginSelect) {
            if (!_geoCodeSearch) {
                _geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
                _geoCodeSearch.delegate = self;
            }
            if (!geoCodeOption) {
                geoCodeOption = [[BMKGeoCodeSearchOption alloc]init];
            }
            geoCodeOption.address = [model.address stringByAppendingString:model.name];
            if ([_geoCodeSearch geoCode:geoCodeOption]) {
                NSLog(@"success");
            }else{
                NSLog(@"failure");
            }
        }

        [cell.selectImageView setImage:[UIImage imageNamed:@"grzx_bdsjh_select"]];
        [self.currentAdressLabel setText:[NSString stringWithFormat:@"【当前】 %@  %@",model.address,model.name]];
    }else{
        [cell.selectImageView setImage:nil];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.titleLabel.text=model.name;
    cell.detaileLabel.text=model.address;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (pre == indexPath.row) {
        return;
    }
    if (self.cityDataArr.count > pre) {
        cityModel *preCityModel = [self.cityDataArr objectAtIndex:pre];
        preCityModel.selected = NO;
    }
    cityModel *cityModel = [self.cityDataArr objectAtIndex:indexPath.row];
    cityModel.selected = YES;
    pre = indexPath.row;
    beginSelect = YES;
    [self.cityTableview reloadData];
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


-(void)viewDidLayoutSubviews {
    
    if ([self.cityTableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.cityTableview setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.cityTableview respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.cityTableview setLayoutMargins:UIEdgeInsetsZero];
    }
    
}


#pragma mark 初始化地图，定位
-(void)initLocationService
{
    
    [_mapView setMapType:BMKMapTypeStandard];// 地图类型 ->卫星／标准、
    
    _mapView.zoomLevel=8;
    _mapView.delegate=self;
    _mapView.showsUserLocation = YES;
    
    [_mapView bringSubviewToFront:_mapPin];
    
    
    if (_locService==nil) {
        
        _locService = [[BMKLocationService alloc]init];
        
        [_locService setDesiredAccuracy:kCLLocationAccuracyBest];
    }
    
    _locService.delegate = self;
    [_locService startUserLocationService];
    
    
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    
}

#pragma mark BMKLocationServiceDelegate
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    _mapView.showsUserLocation = YES;//显示定位图层
    //设置地图中心为用户经纬度
    [_mapView updateLocationData:userLocation];
    
    
    _mapView.centerCoordinate = userLocation.location.coordinate;
    BMKCoordinateRegion region ;//表示范围的结构体
    region.center = _mapView.centerCoordinate;//中心点
    region.span.latitudeDelta = 0.01;//经度范围（设置为0.1表示显示范围为0.2的纬度范围）
    region.span.longitudeDelta = 0.01;//纬度范围
    [_mapView setRegion:region animated:YES];
    if (!beginSearch) {
        //屏幕坐标转地图经纬度
        CLLocationCoordinate2D MapCoordinate=[_mapView convertPoint:_mapPin.center toCoordinateFromView:_mapView];
        
        if (_geoCodeSearch==nil) {
            //初始化地理编码类
            _geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
            _geoCodeSearch.delegate = self;
            
        }
        if (_reverseGeoCodeOption==nil) {
            
            //初始化反地理编码类
            _reverseGeoCodeOption= [[BMKReverseGeoCodeOption alloc] init];
        }
        
        //需要逆地理编码的坐标位置
        _reverseGeoCodeOption.reverseGeoPoint =MapCoordinate;
        [_geoCodeSearch reverseGeoCode:_reverseGeoCodeOption];
        [_locService stopUserLocationService];
    }
}

#pragma mark BMKMapViewDelegate
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    //屏幕坐标转地图经纬度
    CLLocationCoordinate2D MapCoordinate=[_mapView convertPoint:_mapPin.center toCoordinateFromView:_mapView];
    
    if (_geoCodeSearch==nil) {
        //初始化地理编码类
        _geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
        _geoCodeSearch.delegate = self;
        
    }
    if (_reverseGeoCodeOption==nil) {
        
        //初始化反地理编码类
        _reverseGeoCodeOption= [[BMKReverseGeoCodeOption alloc] init];
    }
    
    //需要逆地理编码的坐标位置
    _reverseGeoCodeOption.reverseGeoPoint =MapCoordinate;
    [_geoCodeSearch reverseGeoCode:_reverseGeoCodeOption];
    
}

#pragma mark BMKGeoCodeSearchDelegate

- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    //获取周边用户信息
    if (error==BMK_SEARCH_NO_ERROR) {
        noResult = NO;
        if (beginSearch) {
            if (_reverseGeoCodeOption==nil) {
                //初始化反地理编码类
                _reverseGeoCodeOption= [[BMKReverseGeoCodeOption alloc] init];
            }
            //需要逆地理编码的坐标位置
            _reverseGeoCodeOption.reverseGeoPoint =result.location;
            [_geoCodeSearch reverseGeoCode:_reverseGeoCodeOption];

        }else{
            if (selectRow != -1) {
                if (_reverseGeoCodeOption==nil) {
                    //初始化反地理编码类
                    _reverseGeoCodeOption= [[BMKReverseGeoCodeOption alloc] init];
                }
                //需要逆地理编码的坐标位置
                _reverseGeoCodeOption.reverseGeoPoint =result.location;
                BMKCoordinateRegion region ;//表示范围的结构体
                region.center = result.location;//中心点
                [_mapView setRegion:region animated:YES];
                [_geoCodeSearch reverseGeoCode:_reverseGeoCodeOption];
                selectRow = -1;
                return;
            }
            BMKCoordinateRegion region ;//表示范围的结构体
            region.center = result.location;
            [_mapView setRegion:region animated:YES];
        }
        
    }else if(error == BMK_SEARCH_PERMISSION_UNFINISHED){
 //       BOOL ret = [_mapManager start:@"uBLsm8Ssq8niGLoBTQSr6L8U1fiQLbc5" generalDelegate:self];

        
    }else if (error == BMK_SEARCH_RESULT_NOT_FOUND){
        noResult = YES;
    }else{
        
        NSLog(@"BMKSearchErrorCode: %u",error);
    }

}


-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    //获取周边用户信息
    if (error==BMK_SEARCH_NO_ERROR) {
        if (beginSearch) {
            if (searchBar.text.length > 0) {
                if (result.poiList.count > 0) {
                    if (!noResult) {
                        [adressSearchView.dataAry removeAllObjects];
                        adressSearchView.alpha = 1;
                        for(BMKPoiInfo *poiInfo in result.poiList)
                        {
                            cityModel *model=[[cityModel alloc]init];
                            model.name=poiInfo.name;
                            if([poiInfo.address rangeOfString:poiInfo.city].location !=NSNotFound){
                                model.address=poiInfo.address;
                            }
                            else
                            {
                                model.address = [poiInfo.city stringByAppendingString:poiInfo.address];
                            }
                            [adressSearchView.dataAry addObject:model];
                        }
                        [adressSearchView.tableView reloadData];
                    }else{
                        noResult = NO;
                    }
                }
            }
        }else{
            [self.cityDataArr removeAllObjects];
            pre = 0;
            for(int i = 0;i < result.poiList.count;i ++)
            {
                BMKPoiInfo *poiInfo = [result.poiList objectAtIndex:i];
                cityModel *model=[[cityModel alloc]init];
                if (i == 0) {
                    model.selected = YES;
                }
                model.name=poiInfo.name;
                if([poiInfo.address rangeOfString:poiInfo.city].location !=NSNotFound){
                    model.address=poiInfo.address;
                }
                else
                {
                    model.address = [poiInfo.city stringByAppendingString:poiInfo.address];
                }
                model.city = poiInfo.city;
                model.longitude = poiInfo.pt.longitude;
                model.latitude = poiInfo.pt.latitude;
                [self.cityDataArr addObject:model];
            }
            [self.cityTableview reloadData];
        }
    }else{
        
        NSLog(@"BMKSearchErrorCode: %u",error);
    }
    
}


- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
    if (_geoCodeSearch) {
        _geoCodeSearch.delegate = nil;
        _geoCodeSearch = nil;
    }
}


@end
