//
//  NewFeatureCellCollectionViewCell.h
//  JZBRelease
//
//  Created by Apple on 16/11/7.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewFeatureCellCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *image;
/**
 *  设置立即体验按钮是否隐藏显示
 *
 *  @param indexPath 当前是第几个格子(item)
 *  @param count     总共有多少个格子(item)
 */
- (void)setStartBtnHidden:(NSIndexPath *)indexPath count:(int)count;

@end
