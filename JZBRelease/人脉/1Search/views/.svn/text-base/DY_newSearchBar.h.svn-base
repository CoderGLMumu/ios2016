//
//  DY_newSearchBar.h
//  Tan8
//
//  Created by 12345 on 16/2/24.
//  Copyright © 2016年 YLRS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DY_newSearchBarDelegate <NSObject>

//点击取消退出搜索页面
- (void)touchQuitButton;

//回调用户输入的内容用于搜索 string为用户输入的内容
- (void)searchDataWithInputString:(NSString *)string;

//当用户把输入框清空的时候会去隐藏搜索结果列表，显示搜索历史记录列表
- (void)hideSearchResultTableView;

@end


@interface DY_newSearchBar : UIView<UITextFieldDelegate>

@property(nonatomic,strong)UIImageView *mb_searchImageView;//放大镜
@property(nonatomic,strong)UIImageView *mb_searchBackView;//圆角白色背景框
@property(nonatomic,strong)UITextField *mb_searchTextField;//输入框
@property(nonatomic,strong)UIButton    *mb_searchQuitButton;//退出按钮
@property(nonatomic,assign)id<DY_newSearchBarDelegate> mb_delegate;

@end
