//
//  XBTwoSmallCell.h
//  JZBRelease
//
//  Created by cl z on 16/10/12.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBTitleView.h"
#import "XBSmallView.h"
#import "FreeModel.h"
#import "ZCBModel.h"
#import "ThemeListModel.h"
@interface XBTwoSmallCell : UITableViewCell
@property(nonatomic, strong) XBTitleView *titleView;
@property(nonatomic, strong) XBSmallView *smallView0;
@property(nonatomic, strong) XBSmallView *smallView1;
@property(nonatomic, strong) FreeModel *freeModel;
@property(nonatomic, strong) ZCBModel *zcbModel;
@property(nonatomic, strong) ThemeListModel *themeModel;
@end
