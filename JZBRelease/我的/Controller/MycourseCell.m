//
//  MycourseCell.m
//  JZBRelease
//
//  Created by cl z on 16/9/12.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "MycourseCell.h"

@implementation MycourseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"MycourseCell" owner:nil options:nil] lastObject];
    }
    return self;
}



@end
