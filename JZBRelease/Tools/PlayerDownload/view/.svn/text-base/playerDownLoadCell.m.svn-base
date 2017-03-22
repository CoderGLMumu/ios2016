//
//  playerDownLoadCell.m
//  JZBRelease
//
//  Created by zjapple on 16/10/21.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "playerDownLoadCell.h"

@interface playerDownLoadCell ()
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;

@end

@implementation playerDownLoadCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    
}

- (void)setModel:(ZFSessionModel *)model
{
    _model = model;
    
//    [self.thumbImageV sd_setImageWithURL:[NSURL URLWithString:[AddHostToLoadPIC AddHostToLoadPICWithString:model.thumb]] placeholderImage:[UIImage imageNamed:@"gdkc_pic"]];
    
    [LocalDataRW getImageWithDirectory:Directory_XB RetalivePath:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:model.thumb] WithContainerImageView:self.thumbImageV];
    
    self.titleL.text = model.titleL;
    self.sizeLabel.text = model.totalSize;
    
}


@end
