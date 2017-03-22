/** 第一步、根据需要导入 .framework包
 百度地图 iOS SDK 采用分包的形式提供 .framework包，请广大开发者使用时确保各分包的版本保持一致。其中BaiduMapAPI_Base.framework为基础包，使用SDK任何功能都需导入，其他分包可按需导入。
 将所需的BaiduMapAPI_**.framework拷贝到工程所在文件夹下。
 在 TARGETS->Build Phases-> Link Binary With Libaries中点击“+”按钮，在弹出的窗口中点击“Add Other”按钮，选择BaiduMapAPI_**.framework添加到工程中。
 注: 静态库中采用Objective-C++实现，因此需要您保证您工程中至少有一个.mm后缀的源文件(您可以将任意一个.m后缀的文件改名为.mm)，或者在工程属性中指定编译方式，即在Xcode的Project -> Edit Active Target -> Build Setting 中找到 Compile Sources As，并将其设置为"Objective-C++"
 */

/** 第五步、引入头文件
 在使用SDK的类 按需 引入下边的头文件：
 #import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
 
 #import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
 
 #import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
 
 #import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
 
 #import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
 
 #import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
 
 #import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
 
 #import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件 */


#import <Foundation/Foundation.h>

@interface black : NSObject

@end
