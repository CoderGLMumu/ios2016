//
//  UIPlaceHolderTextView.h
//  JZBRelease
//
//  Created by zjapple on 16/5/21.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView{
    
    NSString *placeholder;
    
    UIColor *placeholderColor;
    
    
    
@private
    
    UILabel *placeHolderLabel;
    
}



@property(nonatomic, retain) UILabel *placeHolderLabel;

@property(nonatomic, retain) NSString *placeholder;

@property(nonatomic, retain) UIColor *placeholderColor;

@property(nonatomic, copy) void (^notificate)();

-(void)textChanged:(NSNotification*)notification;

@end
