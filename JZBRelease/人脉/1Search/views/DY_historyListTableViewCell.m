//
//  DY_HistoryListTableViewCell.m
//  oneguitar
//
//  Created by Yandongyu on 15-1-6.
//  Copyright (c) 2015年 tan8. All rights reserved.
//

#import "DY_historyListTableViewCell.h"

@implementation DY_historyListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.mb_label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.frame.size.width-100,self.frame.size.height)];
        self.mb_label.backgroundColor = [UIColor clearColor];
        self.mb_label.textColor = [UIColor blackColor];
        self.mb_label.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.mb_label];
        
        
        self.mb_deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.mb_deleteButton setImage:[UIImage imageNamed:@"remove"] forState:UIControlStateNormal];
        self.mb_deleteButton.backgroundColor = [UIColor clearColor];
        [self addSubview: self.mb_deleteButton];
        
    }
    return self;
}



- (void)layoutSubviews{
    
    [super layoutSubviews];

    self.mb_label.frame = CGRectMake(20, 0, self.frame.size.width-self.frame.size.height-30, self.frame.size.height);
    self.mb_deleteButton.frame = CGRectMake(self.frame.size.width-self.frame.size.height-10, 0, self.frame.size.height, self.frame.size.height);
}
@end
