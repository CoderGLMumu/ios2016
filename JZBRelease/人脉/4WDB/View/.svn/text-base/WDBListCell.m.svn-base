//
//  WDBListCell.m
//  MyBang
//
//  Created by mac on 16/10/4.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "WDBListCell.h"

@interface WDBListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *like_countLabel_GuanZhu;
@property (weak, nonatomic) IBOutlet UILabel *mcountLabel;

@end

@implementation WDBListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

-(void)setItem:(WDBListItem *)item
{
    _item = item;
    
    [LocalDataRW getImageWithDirectory:Directory_RM RetalivePath:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:item.thumb] WithContainerImageView:self.iconImageView];
    
//    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[AddHostToLoadPIC AddHostToLoadPICWithString:item.thumb]] placeholderImage:[UIImage imageNamed:@"WDB_LOGO"]];
    
//    [self.iconImageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"WDB_LOGO"]];
    
    self.nameLabel.text = item.name;
    self.mcountLabel.text = [NSString stringWithFormat:@"%@位成员",item.mcount];
    self.like_countLabel_GuanZhu.text = [NSString stringWithFormat:@"%@人关注",item.like_count];
}


@end
