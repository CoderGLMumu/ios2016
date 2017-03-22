//
//  CusSearchVC.h
//  JZBRelease
//
//  Created by cl z on 16/10/22.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CusSearchModel.h"

@protocol CusSearchDelegate <NSObject>

@required

- (void)beginSearch:(NSString *)keyWord;

- (void)gobackAction;

- (void)clearBtnAction;

@end


@interface CusSearchVC : UIViewController


/**
 初始自定义搜索控制器实例方法

 @param placeholder 搜索框提示语
 @param adressName   搜索关键词存储本地名称
 @param parentVC    加载该控制器View的上级控制器，同时也是本控制器的代理实例

 @return 返回控制器实例
 */
- (instancetype)initWithplaceholder:(NSString *)placeholder
                      WithAdresaName:(NSString *)adressName
             WithParentOrDeleagteVC:(UIViewController<CusSearchDelegate> *)parentVC;

@property (nonatomic, strong) CusSearchModel *cusSearchModel;
@property (nonatomic, assign) id<CusSearchDelegate> delegate;
@property (nonatomic, strong) UITableView *keyWordTableView;

@end

