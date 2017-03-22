//
//  CuiPickerView.h
//  CXB
//
//  Created by xutai on 16/4/15.
//  Copyright © 2016年 xutai. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol CuiPickViewDelegate <NSObject>
-(void)didFinishPickView:(NSString*)date;
-(void)pickerviewbuttonclick:(UIButton *)sender;
-(void)hiddenPickerView;


@end


@interface CuiPickerView : UIView
@property (nonatomic, copy) NSString *province;
@property(nonatomic,strong)NSDate*curDate;
@property(nonatomic,assign)BOOL isShow;
@property (nonatomic,strong)UITextField *myTextField;
@property(nonatomic,strong)id<CuiPickViewDelegate>delegate;
- (void)showInView:(UIView *)view;
- (void)hiddenPickerView;

/** isEditBirthday */
@property (nonatomic, assign) BOOL isEditBirthday;

@property(nonatomic,assign)BOOL isBirthday;

@end

