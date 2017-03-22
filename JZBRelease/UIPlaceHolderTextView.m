//
//  UIPlaceHolderTextView.m
//  JZBRelease
//
//  Created by zjapple on 16/5/21.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "UIPlaceHolderTextView.h"

@implementation UIPlaceHolderTextView
@synthesize placeHolderLabel;

@synthesize placeholder;

@synthesize placeholderColor;



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    placeHolderLabel = nil;
    placeholderColor = nil;
    placeholder = nil;
}



- (void)awakeFromNib
{
    
    [super awakeFromNib];
    [self setPlaceholder:@""];
    [self setPlaceholderColor:[UIColor lightGrayColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textBeginRespond:) name:UITextViewTextDidBeginEditingNotification object:nil];
    
}



- (id)initWithFrame:(CGRect)frame

{
    if( (self = [super initWithFrame:frame]) )
    {
        [self setPlaceholder:@""];
        [self setPlaceholderColor:[UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}



- (void)textChanged:(NSNotification *)notification

{
    if([[self placeholder] length] == 0)
    {
        return;
    }
    if([[self text] length] == 0)
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    
    else
    {
        [[self viewWithTag:999] setAlpha:0];
    }
}

- (void)textBeginRespond:(NSNotification *)notification{
    if (self.notificate) {
        self.notificate();
    }
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textChanged:nil];
}



- (void)drawRect:(CGRect)rect

{
    if( [[self placeholder] length] > 0 )
    {
        if ( placeHolderLabel == nil )
        {
            
            placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8,8,self.bounds.size.width - 16,0)];
            
            placeHolderLabel.lineBreakMode = UILineBreakModeWordWrap;
            
            placeHolderLabel.numberOfLines = 0;
            
            placeHolderLabel.font = self.font;
            
            placeHolderLabel.backgroundColor = [UIColor clearColor];
            
            placeHolderLabel.textColor = self.placeholderColor;
            
            placeHolderLabel.alpha = 0;
            
            placeHolderLabel.tag = 999;
            
            [self addSubview:placeHolderLabel];
        }
        placeHolderLabel.text = self.placeholder;
        
        [placeHolderLabel sizeToFit];
        
        [self sendSubviewToBack:placeHolderLabel];
    }
    
    
    
    if( [[self text] length] == 0 && [[self placeholder] length] > 0 )
        
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    [super drawRect:rect];
    
}


//隐藏键盘，实现UITextViewDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text  

{  
    
    if ([text isEqualToString:@"\n"]) {  
        
        [self resignFirstResponder];
        
        return NO;  
        
    }  
    
    return YES;  
    
}  



@end
