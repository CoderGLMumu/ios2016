//
//  AskAnswerItem.m
//  JZBRelease
//
//  Created by zjapple on 16/9/19.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "AskAnswerItem.h"
#import "MJExtension.h"

@implementation AskAnswerItem

- (CGFloat)cellHeight
{
    if (_cellHeight == 0) {
    
        /** 头部的距离 */
        _cellHeight = 64 + 15;
        
        /** 正文*/
        CGFloat textX = 59;
        CGFloat textY = 64 + 7;
        CGFloat textW = [UIScreen mainScreen].bounds.size.width - 68 - 20;

        NSDictionary *textAttt = @{NSFontAttributeName : AATextFont};
        // 最大宽度是textW,高度不限制
        CGSize maxTextSize = CGSizeMake(textW, MAXFLOAT);
        // 计算正文文字的高度
        CGFloat textH = [self.eval_content boundingRectWithSize:maxTextSize options:NSStringDrawingUsesLineFragmentOrigin attributes:textAttt context:nil].size.height;
        
        /**增加 内容 到 时间 */
        _cellHeight += textH + 21;
        
        /**增加 时间 和 底部的距离 */
        _cellHeight += 11 + 19;
        
        if (self._answer.count) {
            _cellHeight += 140.5 * self._answer.count;
        }
    }
    
    return _cellHeight;
}

MJCodingImplementation

@end
