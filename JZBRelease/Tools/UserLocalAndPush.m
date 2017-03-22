//
//  UserLocalAndPush.m
//  JZBRelease
//
//  Created by Apple on 16/11/4.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "UserLocalAndPush.h"
#import "INTULocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"

#import "SixWdRootVC.h"

@interface UserLocalAndPush ()

/** INTULocationManager */
@property (nonatomic, strong) INTULocationManager *INTULlocationM;
/** status_test */
@property (nonatomic, assign) INTULocationStatus status_test;

/** geo */
@property (nonatomic, strong) CLGeocoder *geoC;

@property (strong, nonatomic)  UILabel *addressL;

@property (strong, nonatomic)  UILabel *addressL_first;

@end

@implementation UserLocalAndPush{
    LoginVM *loginVM;
    UserInfo *userInfo;
    
}

static UserLocalAndPush *_instance;

//类方法，返回一个单例对象
+ (instancetype)shareUserLocalAndPush
{
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
    
    
    return _instance;
}

- (void)putUserLocation:(CLPlacemark *)pl1
{
    userInfo = [loginVM readLocal];
    
    if (!userInfo.token) return;
    
    if (!pl1) {
        return ;
    }else if (!pl1.administrativeArea) {
        return ;
    }else if (!pl1.locality) {
        return ;
    }
    
    loginVM.users.address = pl1.locality;
    
    NSUserDefaults *udefaults = [NSUserDefaults standardUserDefaults];
    
    [udefaults setObject:pl1.administrativeArea forKey:@"MyNowProvince"];
    [udefaults setObject:pl1.locality forKey:@"MyNowCity"];
    
    NSString *district = pl1.subLocality ? pl1.subLocality : @"未定位";
    NSString *community = pl1.thoroughfare ? pl1.thoroughfare : @"未定位";
    NSString *address = pl1.name ? pl1.name : @"未定位";
    
    
    NSDictionary *parameters = @{
                                 @"access_token":userInfo.token,
                                 @"lng":[NSString stringWithFormat:@"%f",pl1.location.coordinate.longitude],
                                 @"lat":[NSString stringWithFormat:@"%f",pl1.location.coordinate.latitude],
                                 @"province":pl1.administrativeArea,
                                 @"city":pl1.locality,
                                 @"district":district,
                                 @"community":community,
                                 @"address":address
                                 
                                 };
    
    /** 上传位置 */
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/User/update_address"] parameters:parameters success:^(id json) {
        if ([json[@"state"] isEqual:@(1)]) {
            //            [SVProgressHUD showSuccessWithStatus:@"定位成功啦"];
            NSUserDefaults *udefaults = [NSUserDefaults standardUserDefaults];
            
            [udefaults setObject:pl1.administrativeArea forKey:@"MyNowProvince"];
            [udefaults setObject:pl1.locality forKey:@"MyNowCity"];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 开始定位
- (void)setupLocation
{
    [self.INTULlocationM requestLocationWithDesiredAccuracy:INTULocationAccuracyCity timeout:8 delayUntilAuthorized:YES block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        if (status == INTULocationStatusSuccess) {
            
            self.status_test = status;
            
            //                NSLog(@"%ld",(long)status);
            
            [self.geoC reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                
                CLPlacemark *pl1 = [placemarks lastObject];
                CLPlacemark *pl2 = [placemarks firstObject];
                
                self.addressL.text = pl1.name;
                
                self.addressL_first.text = pl2.name;
                
                /** 存储的值 */
                //                self.addressLabel.text = [NSString stringWithFormat:@"%@%@",pl1.addressDictionary[@"State"],pl1.addressDictionary[@"City"]];
                
                NSString *location_str = [NSString stringWithFormat:@"%@%@",pl1.addressDictionary[@"State"],pl1.addressDictionary[@"City"]];
                if (!pl1) {
                    //                    location_str = @"尚未定位";
                    location_str = @"";
                    
                    __weak __typeof__(self) weakSelf = self;
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakSelf setupLocation];
                    });
                    
                    //                    [SVProgressHUD showInfoWithStatus:location_str];
                }else {
                    //                    [SVProgressHUD showSuccessWithStatus:location_str];
                    
                }
                
                /** 上传用户位置 */
                [self putUserLocation:pl1];
                
                // 全局 定位 变量值
                AppDelegate *appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
                appD.userCurrentLocal = pl1.locality;
                
//                SixWdRootVC *vc = [SixWdRootVC shareSixWdRootVC];
//                [vc.addressButton setTitle:pl1.locality forState:UIControlStateNormal];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"putUserLocation" object:nil];
                
                /** 给位置cell的label赋值 */
                //                                self.users.add = self.addressL.text;
                //                                if (self.users.address) {
                //                                    self.updateAddress(self.addressLabel.text);
                //                                }
                
                //                    self.numAddressL.text = [NSString stringWithFormat:@"你可能在的位置有%zd个--%zd",placemarks.count,self.status_test];
            }];
        }else {
            
            //            [SVProgressHUD showErrorWithStatus:@"请检查定位权限,或者网络"];
        }
    }];
}

- (INTULocationManager *)INTULlocationM
{
    if (_INTULlocationM == nil) {
        _INTULlocationM = [INTULocationManager sharedInstance];
    }
    return _INTULlocationM;
}

- (CLGeocoder *)geoC
{
    if (_geoC == nil) {
        _geoC = [[CLGeocoder alloc] init];
    }
    return _geoC;
    
}



@end
