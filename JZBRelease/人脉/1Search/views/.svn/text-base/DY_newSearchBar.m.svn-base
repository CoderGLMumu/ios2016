//
//  DY_newSearchBar.m
//  Tan8
//
//  Created by 12345 on 16/2/24.
//  Copyright © 2016年 YLRS. All rights reserved.
//

#import "DY_newSearchBar.h"
#import "GLRMButton.h"
#import "UIView+GLExtension.h"

@implementation DY_newSearchBar


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        

        self.backgroundColor = [UIColor colorWithRed:65/255.f green:65/255.f  blue:65/255.f  alpha:1];
//        self.backgroundColor = [UIColor whiteColor];
       
        //圆角白色背景框
        self.mb_searchBackView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, frame.size.width-10-50, frame.size.height-20)];
        self.mb_searchBackView.backgroundColor = [UIColor whiteColor];
        self.mb_searchBackView.userInteractionEnabled = YES;
        self.mb_searchBackView.layer.masksToBounds = YES;
        self.mb_searchBackView.layer.cornerRadius  = 5;
        [self addSubview:self.mb_searchBackView];
        
        GLRMButton *conditionButton = [GLRMButton buttonWithType:UIButtonTypeCustom];
        [self.mb_searchBackView addSubview:conditionButton];
        conditionButton.frame = CGRectMake(10, 0, 0, 0);
        conditionButton.glcy_centerY = self.mb_searchBackView.gly_y - 3;
        [conditionButton setTitle:@"全部" forState:UIControlStateNormal];
        [conditionButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [conditionButton setImage:[UIImage imageNamed:@"rm_seek_down"] forState:UIControlStateNormal];
        [conditionButton sizeToFit];
        
        UIView *fengexian = [UIView new];
        [self.mb_searchBackView addSubview:fengexian];
        fengexian.glx_x = conditionButton.glr_right + 12;
        fengexian.gly_y = conditionButton.gly_y;
        fengexian.glh_height = conditionButton.glh_height;
        fengexian.glw_width = 1;
        fengexian.backgroundColor = [UIColor redColor];
        
        //放大镜
        self.mb_searchImageView = [[UIImageView alloc]initWithFrame:CGRectMake(fengexian.glr_right, 0, 30, 30)];
        self.mb_searchImageView.image = [UIImage imageNamed:@"search"];
        self.mb_searchImageView.contentMode = UIViewContentModeCenter;
        [self.mb_searchBackView addSubview:self.mb_searchImageView];
        
        
        //退出按钮
        self.mb_searchQuitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.mb_searchQuitButton setTitle:@"取消" forState:UIControlStateNormal];
        self.mb_searchQuitButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.mb_searchQuitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.mb_searchQuitButton.frame = CGRectMake(frame.size.width-50,0, 50, 50);
        [self.mb_searchQuitButton addTarget:self action:@selector(handleQuitButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.mb_searchQuitButton];
        

        
        //输入框
        self.mb_searchTextField = [[UITextField alloc]initWithFrame:CGRectMake(self.mb_searchImageView.glr_right + 2, 0, self.mb_searchBackView.frame.size.width-self.mb_searchImageView.frame.size.width, self.mb_searchBackView.frame.size.height)];
        self.mb_searchTextField.clearButtonMode =  UITextFieldViewModeWhileEditing;
        self.mb_searchTextField.font = [UIFont systemFontOfSize:14];
        self.mb_searchTextField.placeholder = @"输入搜索的内容";
        self.mb_searchTextField.delegate = self;
        self.tintColor = [UIColor blackColor];
        self.mb_searchTextField.textColor = [UIColor blackColor];
        self.mb_searchTextField.backgroundColor = [UIColor clearColor];
        self.mb_searchTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.mb_searchTextField.returnKeyType = UIReturnKeySearch;
        [self.mb_searchBackView addSubview:self.mb_searchTextField];
    
        
        
        
        
       
    }
    return self;
}





//点击按钮
- (void)handleQuitButton{
    if (self.mb_delegate && [self.mb_delegate respondsToSelector:@selector(touchQuitButton)]) {
        [self.mb_delegate touchQuitButton];
    }

}

//点击键盘return键的方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    //过滤掉输入框输入的文字前后的空格
    NSString *textString = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (![textString isEqualToString:@""]) {
        [self.mb_delegate searchDataWithInputString:textField.text];
    }
    
    return YES;
}

//监听输入框文本的变化
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.text.length == 1 && [string isEqualToString:@""]) {
        if (self.mb_delegate&&[self.mb_delegate respondsToSelector:@selector(hideSearchResultTableView)]) {
            [self.mb_delegate hideSearchResultTableView];
        }
    }
    return YES;
    
}

//点击输入框右侧清除按钮响应的方法
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    
    if (self.mb_delegate&&[self.mb_delegate respondsToSelector:@selector(hideSearchResultTableView)]) {
        [self.mb_delegate hideSearchResultTableView];
    }
    return YES;
}

@end
