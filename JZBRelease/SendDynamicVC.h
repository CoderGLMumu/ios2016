//
//  SendDynamicVC.h
//  JZBRelease
//
//  Created by zjapple on 16/5/18.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatKeyBoard.h"
#import "DynamicDetailHeaderView.h"
#import "MoreItem.h"
#import "ChatToolBarItem.h"
#import "FaceSourceManager.h"
#import "FaceThemeModel.h"
#import "SelecterToolsScrolView.h"
#import "SelecterContentScrollView.h"
#import "ChatKeyBoardMacroDefine.h"

@interface SendDynamicVC : UIViewController<ChatKeyBoardDataSource, ChatKeyBoardDelegate>

@property(nonatomic,strong)UICollectionView *pictureCollectonView;

@end
