//
//  XBFourSmallCell.h
//  JZBRelease
//
//  Created by cl z on 16/10/12.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBTitleView.h"
#import "XBSmallView.h"
#import "HotModel.h"
#import "JZCXModel.h"
#import "ZDYXModel.h"

@interface XBFourSmallCell : UITableViewCell
@property(nonatomic, strong) XBTitleView *titleView;
@property(nonatomic, strong) XBSmallView *smallView0;
@property(nonatomic, strong) XBSmallView *smallView1;
@property(nonatomic, strong) XBSmallView *smallView2;
@property(nonatomic, strong) XBSmallView *smallView3;
@property(nonatomic, strong) HotModel *hotModel;
@property(nonatomic, strong) JZCXModel *jzcxModel;
@property(nonatomic, strong) ZDYXModel *zdyxModel;
@property(nonatomic, strong) ThemeListModel *themeModel;

@end
