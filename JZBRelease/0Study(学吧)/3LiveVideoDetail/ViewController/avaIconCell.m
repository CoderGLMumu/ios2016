//
//  avaIconCell.m
//  JZBRelease
//
//  Created by zjapple on 16/9/26.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "avaIconCell.h"

@interface avaIconCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avaIcon;

@end

@implementation avaIconCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    self.backgroundColor = [UIColor redColor];
    
    self.avaIcon.layer.cornerRadius = 30 * 0.5;
    self.avaIcon.clipsToBounds = YES;
    
    self.avaIcon.transform = CGAffineTransformRotate(self.avaIcon.transform, M_PI);
    
}

- (void)setItem:(HttpBaseRequestItem *)item
{
    
    [LocalDataRW getImageWithDirectory:Directory_WD RetalivePath:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:item.avatar] WithContainerImageView:self.avaIcon];
    
//    [self.avaIcon sd_setImageWithURL:[NSURL URLWithString:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:item.avatar]] placeholderImage:[UIImage imageNamed:@"ZCCG_TX"]];
}

- (void)setUseritem:(online_userItem *)item
{
    
    [LocalDataRW getImageWithDirectory:Directory_WD RetalivePath:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:item.user.avatar] WithContainerImageView:self.avaIcon];

    
//    [self.avaIcon sd_setImageWithURL:[NSURL URLWithString:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:item.user.avatar]] placeholderImage:[UIImage imageNamed:@"ZCCG_TX"]];
}

@end
