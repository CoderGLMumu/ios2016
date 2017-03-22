//
//  CustomSearchViewController.h
//  剧能玩2.1
//
//  Created by dzb on 15/11/11.
//  Copyright © 2015年 大兵布莱恩特 . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomSearchViewControllerDelegate <NSObject,UISearchControllerDelegate>

@required
/**
 *  点击了搜索按钮的返回按钮
 */
- (void)searchControllerBackButtonClick:(UISearchController *)searchController;
@end

@interface CustomSearchViewController : UISearchController
/**
 *  delegate
 */
@property (nonatomic,assign) id<CustomSearchViewControllerDelegate>delegateCustom;

@end
