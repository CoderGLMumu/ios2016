//
//  JZBcheckVersionItem.h
//  JZBRelease
//
//  Created by Apple on 16/12/27.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JZBcheckVersionItem : NSObject

/** JianZhongBang */
@property (nonatomic, strong) NSString *appname;
/** 1 */
@property (nonatomic, strong) NSString *versioncode;
/** 2.0.1 */
@property (nonatomic, strong) NSString *versionname;
/** https://itunes.apple.com/cn/app/jian-zhong-bang/id1150421048?mt=8 */
@property (nonatomic, strong) NSString *apkurl;
/** 更新信息 */
@property (nonatomic, strong) NSString *changelog;
/** 更新信息 */
@property (nonatomic, strong) NSString *updatetips;

//"appname":"JianZhongBang",
//"versioncode":"1",
//"versionname":"2.0.1",
//"apkurl":"https://itunes.apple.com/cn/app/jian-zhong-bang/id1150421048?mt=8",
//"changelog":"更新信息",
//"updatetips":"更新信息"

@end
