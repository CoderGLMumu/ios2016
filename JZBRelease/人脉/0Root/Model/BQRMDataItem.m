//
//  BQRMDataItem.m
//  JZBRelease
//
//  Created by zjapple on 16/8/24.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "BQRMDataItem.h"

@implementation BQRMDataItem

- (CGFloat)cellHeight
{
    if (_cellHeight == 0) {
        
        _cellHeight = 0;
        
        /** 正文*/
//        CGFloat textX = 59;
//        CGFloat textY = 64 + 7;
        
//        CGFloat textW;
//        
//        if (self.cellnum == 1) {
//            textW = [UIScreen mainScreen].bounds.size.width - GLScreenW * 70/375 - 80 -20;
//        }else {
//            textW = [UIScreen mainScreen].bounds.size.width - GLScreenW * 70/375 - 80;
//        }
//        
////        CGFloat textW = [UIScreen mainScreen].bounds.size.width - 100;
//        
//        NSDictionary *textAttt = @{NSFontAttributeName : AATextFont};
//        // 最大宽度是textW,高度不限制
//        CGSize maxTextSize = CGSizeMake(textW, MAXFLOAT);
//        // 计算正文文字的高度 -- 改字体.h
//        CGFloat textH = [self.pain boundingRectWithSize:maxTextSize options:NSStringDrawingUsesLineFragmentOrigin attributes:textAttt context:nil].size.height;
        
        UILabel *pianLabel = [UILabel new];
        [pianLabel setText:self.pain];
        [pianLabel sizeToFit];
//        GLLog(@"%@111111111---%f--%f",self.pain,_cellHeight,pianLabel.glh_height);
        /** 设置行距 */
//        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:self.pain];
//        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
//        [paragraphStyle1 setLineSpacing:6];
//        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [self.pain length])];
//        [pianLabel setAttributedText:attributedString1];
//        
//        [pianLabel sizeToFit];
//        GLLog(@"%@2222222---%f--%f",self.pain,_cellHeight,pianLabel.glh_height);
        /** ********* */
        
        CGSize size = [self getStringRect:pianLabel.text];
        

        _cellHeight += 15;
        
        _cellHeight += GLScreenW *70/375;
       
        _cellHeight += size.height + 15;
        
        if (size.height < 18) {
            _cellHeight = GLScreenW *70/375 + 15 + 12;
        }else if(size.height < 28) {
        
            _cellHeight -= 10;
        }
            
        GLLog(@"%@333333---%f--%f",self.pain,_cellHeight,size.height);
//        _cellHeight = textH;
    }
    
    return _cellHeight;
}

- (CGSize)getStringRect:(NSString*)aString

{
    
    CGSize size;
    
    
    
    NSAttributedString* atrString = [[NSAttributedString alloc] initWithString:aString];
    
    
    
    NSRange range = NSMakeRange(0, atrString.length);
    
    
    
    NSDictionary* dic = [atrString attributesAtIndex:0 effectiveRange:&range];
    
    CGFloat textW;
    
    if (self.cellnum == 1) {
        textW = [UIScreen mainScreen].bounds.size.width - GLScreenW * 70/375 -22 - 15 - 67 - 25;
    }else {
        textW = [UIScreen mainScreen].bounds.size.width - GLScreenW * 70/375 -22 - 11 -67 -15;
//        textW = 10;
    }
    
    size = [aString boundingRectWithSize:CGSizeMake(textW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;

    return  size;
    
}

@end
