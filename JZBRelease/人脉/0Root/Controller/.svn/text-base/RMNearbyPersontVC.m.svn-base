//
//  RMRootVC.m
//  JZBRelease
//
//  Created by zjapple on 16/8/16.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "RMNearbyPersontVC.h"
#import "DY_searchViewController.h"
//#import "OtherPersonCentralVC.h"
#import "PublicOtherPersonVC.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件 */

#import "RMSearchAroundItemList.h"
#import "RMSearchActivityItemList.h"
#import "GLActionPaopaoView.h"
#import "GLWhiteSearchView.h"

#import "RMNearbyPersontVC.h"

#import "UIImageView+CreateImageView.h"
#import "UILabel+CreateLabel.h"
#import "SendAndGetDataFromNet.h"

@interface RMNearbyPersontVC () <BMKMapViewDelegate , BMKLocationServiceDelegate ,BMKGeoCodeSearchDelegate>

/** 自定义paopaoView */
@property (nonatomic, strong) GLActionPaopaoView *actionPaopaoView;

/** SearchAroundItemLists */
@property (nonatomic, strong) NSMutableArray *searchAroundItemLists;

/** mapView */
@property (nonatomic, strong) BMKMapView *mapView;
/** locService */
@property (nonatomic, strong) BMKLocationService *locService;

@property (nonatomic, assign) CLLocationDegrees latitude;
@property (nonatomic, assign) CLLocationDegrees longitude;

@property (nonatomic, strong) BMKPointAnnotation* pointAnnotation;
@property (nonatomic, strong) BMKGeoCodeSearch *geocodesearch;

/** paopaoViewImageURL */
@property (nonatomic, strong) NSString *paopaoViewImageURL;
/** paopaoViewUserName */
@property (nonatomic, strong) NSString *paopaoViewUserName;
/** chengHu */
@property (nonatomic, strong) NSString *chengHu;
/** level */
@property (nonatomic, strong) NSString *level;
/** address */
@property (nonatomic, strong) NSString *industry;
/** paopaoView具体的uid */
@property (nonatomic, strong) NSString *uid;

/** 搜索类型 */
@property (nonatomic, strong) NSString *type;
/** 用户类型 zlt ppcs  */
@property (nonatomic, strong) NSString *userType;
/** paopaoViewImageURL */
@property (nonatomic, strong) NSString *paopaoViewActivity_title;

/** 搜索的View */
@property (nonatomic, weak) GLWhiteSearchView *glWhiteSearchView;
/** 省份 */
@property (nonatomic, strong) NSString *province;

//@property (nonatomic, strong) dispatch_semaphore_t signal;

@end

@implementation RMNearbyPersontVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.signal = dispatch_semaphore_create(0);
    
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.glw_width, self.view.glh_height)];
    self.view = self.mapView;
    
    [self setUpLocation];
    if (self.rMSearchAroundItemList) {
        self.title = [self.rMSearchAroundItemList.user.nickname stringByAppendingString:@"位置"];
    }else{
        self.title = @"附近的人";
    }
    
    [self setuptitleView];
    self.tabBarController.tabBar.hidden=YES;
//    [self configNav:self.navigationController];
    
    [self setupTopTipView];
    
}

- (void)setupTopTipView
{
    UIView *contentView = [UIView new];
    contentView.frame = CGRectMake(0, 64, GLScreenW, 40);
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    
    UIButton *tipButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [tipButton1 setImage:[UIImage imageNamed:@"RMzlt_tipIcon"] forState:UIControlStateNormal];
    [tipButton1 setTitle:@"智囊团" forState:UIControlStateNormal];
    
    UIButton *tipButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [tipButton2 setImage:[UIImage imageNamed:@"RMjsx_tipIcon"] forState:UIControlStateNormal];
    [tipButton2 setTitle:@"经销商" forState:UIControlStateNormal];
    
    UIButton *tipButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [tipButton3 setImage:[UIImage imageNamed:@"RMppcs_tipIcon"] forState:UIControlStateNormal];
    [tipButton3 setTitle:@"品牌厂商" forState:UIControlStateNormal];
    
    [contentView addSubview:tipButton1];
    [contentView addSubview:tipButton2];
    [contentView addSubview:tipButton3];
    
    [tipButton1 setFont:[UIFont systemFontOfSize:15]];
    [tipButton2 setFont:[UIFont systemFontOfSize:15]];
    [tipButton3 setFont:[UIFont systemFontOfSize:15]];
    
    [tipButton1 setTitleColor:[UIColor hx_colorWithHexRGBAString:@"757575"] forState:UIControlStateNormal];
    [tipButton2 setTitleColor:[UIColor hx_colorWithHexRGBAString:@"757575"] forState:UIControlStateNormal];
    [tipButton3 setTitleColor:[UIColor hx_colorWithHexRGBAString:@"757575"] forState:UIControlStateNormal];
    
    tipButton1.frame = CGRectMake(0, 0, GLScreenW / 3, contentView.glh_height);
    tipButton2.frame = CGRectMake(GLScreenW / 3, 0, GLScreenW / 3, contentView.glh_height);
    tipButton3.frame = CGRectMake(GLScreenW / 3 + GLScreenW / 3, 0, GLScreenW / 3, contentView.glh_height);
    
    tipButton1.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 22);
    tipButton2.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 22);
    tipButton3.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 22);
    
    tipButton1.userInteractionEnabled = NO;
    tipButton2.userInteractionEnabled = NO;
    tipButton3.userInteractionEnabled = NO;
}

/** 初始化跳转View */
- (void)setUpSearchView
{
    /** 搜索跳转View */
    GLWhiteSearchView *glWhiteSearchView = [GLWhiteSearchView glWhiteSearchView];
    [self.view addSubview:glWhiteSearchView];
    self.glWhiteSearchView = glWhiteSearchView;
    glWhiteSearchView.glx_x = 39;
    glWhiteSearchView.gly_y = 80;
    glWhiteSearchView.layer.cornerRadius = 15;
    glWhiteSearchView.clipsToBounds = YES;
    
    [glWhiteSearchView addTarget:self action:@selector(pushSearchVC:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setUpLocation
{
    //初始化BMKLocationService
    self.locService = [[BMKLocationService alloc]init];
    self.geocodesearch = [[BMKGeoCodeSearch alloc]init];
    self.locService.delegate = self;
    
    //启动LocationService
    
    _mapView.zoomLevel = 16;
    _mapView.trafficEnabled = YES;
    _mapView.showMapScaleBar = YES;
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;
    
    [self.locService startUserLocationService];
    
//    _mapView.mapPadding = UIEdgeInsetsMake(64, 0, 49, 0);
    _mapView.mapPadding = UIEdgeInsetsMake(64, 0, 0, 0);
    
//    NSLog(@"进入普通定位态");
//    [_locService startUserLocationService];
    

//    [startBtn setEnabled:NO];
//    [startBtn setAlpha:0.6];
//    [stopBtn setEnabled:YES];
//    [stopBtn setAlpha:1.0];
//    [followHeadBtn setEnabled:YES];
//    [followHeadBtn setAlpha:1.0];
//    [followingBtn setEnabled:YES];
//    [followingBtn setAlpha:1.0];
    
    // 搜索附近的人 增加大头针
    [self searchNearbyPerson];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    self.geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    [self.tabBarController.tabBar setHidden:NO];
    self.tabBarController.tabBar.hidden=YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden=YES;
}

- (void)setuptitleView
{
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.glw_width - 112 * 2, 40)];
    titleLable.text = self.title;
    //    titleLable.textColor = [UIColor hx_colorWithHexRGBAString:@"ffffff"];
    titleLable.textColor = [UIColor whiteColor];
    titleLable.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLable;
}

- (void)configNav:(UIViewController *)vc
{
    //11 20
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11 + 5 + 40, 35)];
    UIImageView *backImageView = [UIImageView createImageViewWithFrame:CGRectMake(0, (35-20)/2, 20, 20) ImageName:@"DL_light_ARROW"];
    backImageView.userInteractionEnabled = NO;
    [backView addSubview:backImageView];
//    UILabel *backLabel = [UILabel createLabelWithFrame:CGRectMake(11 + 5,(35-20)/2, 40, 20) Font:17 Text:@"返回" andLCR:0 andColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]]];
//    [backView addSubview:backLabel];
    UIControl *back = [[UIControl alloc] initWithFrame:backView.bounds];
    [back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:back];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    _mapView.delegate = nil; // 不用时，置nil
    self.geocodesearch.delegate = nil; // 不用时，置nil
    
    
    
}

- (void)searchNearbyPerson
{
    
    //判断是否是从提问而来
    if (self.rMSearchAroundItemList) {
        if (!self.searchAroundItemLists) {
            self.searchAroundItemLists = [[NSMutableArray alloc]init];
        }
        [self.searchAroundItemLists addObject:self.rMSearchAroundItemList];
        [self setUpAnnotationView];
    }else{
        //    接口：/Web/User/search_around
        //    参数:access_token，lng，lat，distance
        //    返回：附近人列表
        
        UserInfo *userInfo = [[LoginVM getInstance]readLocal];
        
        if (!self.longitude) return;
        
        NSDictionary *parameters = @{
                                     @"access_token":userInfo.token,
                                     @"lng":[NSString stringWithFormat:@"%f",self.longitude],
                                     @"lat":[NSString stringWithFormat:@"%f",self.latitude],
                                     @"distance":@"10"
                                     };
        
        [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/User/search_around"] parameters:parameters success:^(id json) {
            
            if ([json[@"state"] isEqual:@(0)]) return ;
            
            self.searchAroundItemLists = [RMSearchAroundItemList mj_objectArrayWithKeyValuesArray:json[@"data"]];
            //        NSLog(@"gaolin testtt %@",json);
            
            if (self.searchAroundItemLists) {
                // 搜索附近的人 增加大头针
                [self setUpAnnotationView];
            }
            
            //        RMSearchAroundItemList *test = self.searchAroundItemLists[0];
            //        NSLog(@"gaoliniflgkldsgjl  ?? %@",test.user.uid);
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)pushSearchVC:(GLWhiteSearchView *)SearchView
{
    DY_searchViewController *searchVC = [[DY_searchViewController alloc]init];
    
    searchVC.city = SearchView.addressLabel.text;
    searchVC.province = self.province;
    
    [self presentViewController:searchVC animated:YES completion:^{
        
    }];
    
    searchVC.ClickSearch = ^(NSArray *results ,NSString *type){
        if (results) {
            self.searchAroundItemLists = results;
            self.type = type;
            [self setUpAnnotationView];
        }
    
    };
}

//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
//    NSLog(@"gaolin  heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    
//    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
//    BMKCoordinateSpan span = BMKCoordinateSpanMake(0.03, 0.03);
//    _mapView.limitMapRegion = BMKCoordinateRegionMake(center, span);////限制地图显示范围
    
    self.latitude = userLocation.location.coordinate.latitude;
    self.longitude = userLocation.location.coordinate.longitude;
//    NSLog(@"gaolin  didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
}

/** 地图初始化完毕时会调用此接口 */
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView
{
    [self searchNearbyPerson];
    [self localGeocodesearch];
}

/** 将要开始定位会调用此接口 */
- (void)willStartLocatingUser
{
    
}

- (void)localGeocodesearch
{
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];

    reverseGeocodeSearchOption.reverseGeoPoint = CLLocationCoordinate2DMake(self.latitude, self.longitude);

    BMKGeoCodeSearch *geocodesearch = [[BMKGeoCodeSearch alloc]init];
    geocodesearch.delegate = self;

    BOOL flag = [geocodesearch reverseGeoCode:reverseGeocodeSearchOption];

    if(flag)
    {
//        [SVProgressHUD showInfoWithStatus:@"反geo检索发送成功"];
    }
    else
    {
//        [SVProgressHUD showInfoWithStatus:@"反geo检索发送失败"];
    }
}

/** 反地理编码 */
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    /** result.geoPt;//地理坐标
        result.strAddr;//地理名称
        result.addressDetail.province;//省份
        result.addressDetail.city;//城市
        result.addressDetail.district;//地区
     */
    
//    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
//    [_mapView removeAnnotations:array];
//    array = [NSArray arrayWithArray:_mapView.overlays];
//    [_mapView removeOverlays:array];
    
    
    /** ！！！！禁用搜索！！！ */
//    [self setUpSearchView];
    
    if (error == 0) {
//        self.address = result.address;
        
        self.glWhiteSearchView.addressLabel.text = result.addressDetail.city;
        self.province = result.addressDetail.province;
//        _mapView.centerCoordinate = result.location;
    }
//    dispatch_semaphore_signal(self.signal);
//    searcher.delegate = nil;
//    searcher = nil;
//    NSLog(@"gaolin thread2222%@",[NSThread currentThread]);
}

// 根据anntation生成对应的View 自定义大头针
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    //普通annotation
    
        NSString *AnnotationViewID = @"JZBAnnotaionViewView";
    //根据指定标识查找一个可被复用的标注View，一般在delegate中使用，用此函数来代替新申请一个View
        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        
        // 设置颜色
        annotationView.pinColor = BMKPinAnnotationColorPurple;
        // 从天上掉下效果
        annotationView.animatesDrop = YES;
        // 设置可拖拽
        annotationView.draggable = YES;
    
        if ([self.userType isEqualToString:@"0"]) {
            annotationView.image = [UIImage imageNamed:@"rm_contacts_position"];
        }else if ([self.userType isEqualToString:@"1"]) {
            annotationView.image = [UIImage imageNamed:@"RMzlt_tipIcon"];
        }else if ([self.userType isEqualToString:@"2"]) {
            annotationView.image = [UIImage imageNamed:@"RMppcs_tipIcon"];
        }else if ([self.userType isEqualToString:@"3"]) {
            annotationView.image = [UIImage imageNamed:@"RMjsx_tipIcon"];
        }else {
            annotationView.image = [UIImage imageNamed:@"rm_contacts_position"];
        }
    
//glActionPaopaoViewActivity

        if ([self.type isEqualToString:@"1"] || self.type == nil) {
            // 搜索个人
           self.actionPaopaoView = [GLActionPaopaoView glActionPaopaoView];
            __weak typeof(self) wself = self;
            self.actionPaopaoView.paopaoViewWidth = ^(CGFloat width){
                
                wself.actionPaopaoView.glw_width = width;
//                GLLog(@"%f",width)
//                GLLog(@"%f",width)
            };
//            [self.actionPaopaoView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.paopaoViewImageURL] placeholderImage:[UIImage imageNamed:@"HX_img_head"]];
            
            [LocalDataRW getImageWithDirectory:Directory_RM RetalivePath:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:self.paopaoViewImageURL] WithContainerImageView:self.actionPaopaoView.avatarImageView];
            
            
            self.actionPaopaoView.nickNameLabel.text = self.paopaoViewUserName;
            self.actionPaopaoView.chenHuLabel.text = self.chengHu;
            //            actionPaopaoView.vipImageView.image
            if (!self.industry) {
                self.industry = @"";
            }
            self.actionPaopaoView.industryLabel.text = self.industry;
            self.actionPaopaoView.uid = self.uid;
            
            annotationView.paopaoView = [[BMKActionPaopaoView alloc]initWithCustomView:self.actionPaopaoView];
            
            
            __weak typeof(self) weakSelf = self;
            self.actionPaopaoView.paopaoViewClick = ^(GLActionPaopaoView *view){
//                    OtherPersonCentralVC *vc = [[OtherPersonCentralVC alloc]init];
                PublicOtherPersonVC *vc = [[UIStoryboard storyboardWithName:@"PublicOtherPersonVC" bundle:nil]instantiateInitialViewController];
//                weakSelf.hidesBottomBarWhenPushed=NO;
                    Users *user = [[Users alloc]init];
                    user.uid = view.uid;
                    vc.user = user;
                
                if ([vc.user.uid isEqualToString:[LoginVM getInstance].readLocal._id] || vc.user.uid == nil) {
                    return ;
                }
                
                    [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            
//            [self.actionPaopaoView addTarget:self action:@selector(pushDetailInfo:) forControlEvents:UIControlEventTouchUpInside];
            
        }else if ([self.type isEqualToString:@"2"]) {
            // 搜索活动
            self.actionPaopaoView = [GLActionPaopaoView glActionPaopaoViewActivity];

           // self.actionPaopaoView.activity_titleLabel.text = self.paopaoViewActivity_title;

//            self.actionPaopaoView.activity_titleLabel.text = self.paopaoViewActivity_title;

            annotationView.paopaoView = [[BMKActionPaopaoView alloc]initWithCustomView:self.actionPaopaoView];
        }

    
        return annotationView;
//    //动画annotation
//    NSString *AnnotationViewID = @"AnimatedAnnotation";
//    MyAnimatedAnnotationView *annotationView = nil;
//    if (annotationView == nil) {
//        annotationView = [[MyAnimatedAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
//    }
//    NSMutableArray *images = [NSMutableArray array];
//    for (int i = 1; i < 4; i++) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"poi_%d.png", i]];
//        [images addObject:image];
//    }
//    annotationView.annotationImages = images;
//    return annotationView;
    
}

//- (void)pushDetailInfo:(GLActionPaopaoView *)cont
//{
//    OtherPersonCentralVC *vc = [[OtherPersonCentralVC alloc]init];
//    Users *user = [[Users alloc]init];
//    user.uid = cont.uid;
//    [self.navigationController pushViewController:vc animated:YES];
//}

/** 初始化大头针 */
- (void)setUpAnnotationView
{
        _mapView.delegate = self;
        NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
        [_mapView removeAnnotations:array];
    
        if ([self.type isEqualToString:@"1"] || self.type == nil) {
            
            for (RMSearchAroundItemList *itemList in self.searchAroundItemLists) {
                
                self.pointAnnotation = [[BMKPointAnnotation alloc]init];
                CLLocationCoordinate2D coor;
                
                if (itemList.lat != nil && itemList.lng != nil) {
                    coor.latitude = itemList.lat.doubleValue;
                    //            NSLog(@"gaolinaaaaaaa%f",coor.latitude);
                    coor.longitude = itemList.lng.doubleValue;
                }
                
                self.pointAnnotation.coordinate = coor;
                self.pointAnnotation.title = itemList.user.nickname;
                self.pointAnnotation.subtitle = itemList.user.uid;
                
//                self.paopaoViewImageURL = [AddHostToLoadPIC AddHostToLoadPICWithString:itemList.user.avatar];
                self.paopaoViewImageURL = itemList.user.avatar;
                self.paopaoViewUserName = itemList.user.nickname;
                
                self.userType = itemList.user.type;
                
                if (!itemList.user.company) {
                    itemList.user.company = @"";
                }
                
                if (!itemList.user.job) {
                    itemList.user.job = @"";
                }
                
                self.chengHu = [NSString stringWithFormat:@"%@%@",itemList.user.company,itemList.user.job];
                self.level = itemList.user.level;
                self.industry = itemList.user.industry;
                self.uid = itemList.uid;
                [_mapView addAnnotation:self.pointAnnotation];
            }
            
        } else if([self.type isEqualToString:@"2"]) {
            for (RMSearchActivityItemList *itemList in self.searchAroundItemLists) {
                
                self.pointAnnotation = [[BMKPointAnnotation alloc]init];
                CLLocationCoordinate2D coor;
                
                if (itemList.lat != nil && itemList.lng != nil) {
                    coor.latitude = itemList.lat.doubleValue;
                    //            NSLog(@"gaolinaaaaaaa%f",coor.latitude);
                    coor.longitude = itemList.lng.doubleValue;
                }
                
                self.pointAnnotation.coordinate = coor;
                self.pointAnnotation.title = itemList.user.nickname;
                self.pointAnnotation.subtitle = itemList.user.uid;
//                self.paopaoViewImageURL = [AddHostToLoadPIC AddHostToLoadPICWithString:itemList.user.avatar];
//                self.paopaoViewImageURL = [AddHostToLoadPIC AddHostToLoadPICWithString:itemList.user.avatar];
                self.paopaoViewActivity_title = itemList.activity_title;
                [_mapView addAnnotation:self.pointAnnotation];
            }
        }
            
//            BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
//            
//            reverseGeocodeSearchOption.reverseGeoPoint = coor;
            
//            BMKGeoCodeSearch *geocodesearch = [[BMKGeoCodeSearch alloc]init];
//            geocodesearch.delegate = self;
//            
//            BOOL flag = [geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
//            
//            if(flag)
//            {
//                [SVProgressHUD showInfoWithStatus:@"反geo检索发送成功"];
//            }
//            else
//            {
//                [SVProgressHUD showInfoWithStatus:@"反geo检索发送失败"];
//            }
//                dispatch_semaphore_wait(self.signal, DISPATCH_TIME_FOREVER);
            //        NSLog(@"gaolin thread%@",[NSThread currentThread]);
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
//    
//    NSLog(@"%@",self.actionPaopaoView);
//    NSLog(@"%@",self.actionPaopaoView);
    
//    [self.UserNameLabel sizeToFit];
//    self.UserNameWidth.constant = self.UserNameLabel.frame.size.width;
//    [self.chengHuLabel sizeToFit];
//    self.ChengHuWidth.constant = self.chengHuLabel.frame.size.width;
//    if (self.chengHuLabel.frame.size.width < self.scoreLabel.glw_width) {
//        self.ChengHuWidth.constant = self.scoreLabel.glw_width;
//    }
}

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
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
