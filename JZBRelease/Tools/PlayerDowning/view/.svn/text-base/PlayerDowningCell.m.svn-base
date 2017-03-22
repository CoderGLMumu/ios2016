//
//  PlayerDowningCell.m
//  JZBRelease
//
//  Created by zjapple on 16/10/26.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "PlayerDowningCell.h"
#import "ZFDownloadManager.h"

@interface PlayerDowningCell ()

@property (weak, nonatomic) IBOutlet UIImageView *thumbImageV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;

@end

@implementation PlayerDowningCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.downStatusButton.selected = NO;
    
    self.progressV.layer.cornerRadius = 3;
    self.progressV.clipsToBounds = YES;
    
}

- (void)setModel:(ZFSessionModel *)model
{
    _model = model;
    
//    [self.thumbImageV sd_setImageWithURL:[NSURL URLWithString:[AddHostToLoadPIC AddHostToLoadPICWithString:model.thumb]] placeholderImage:[UIImage imageNamed:@"gdkc_pic"]];
    
    [LocalDataRW getImageWithDirectory:Directory_XB RetalivePath:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:model.thumb] WithContainerImageView:self.thumbImageV];
    
    self.titleL.text = model.titleL;
//    self.sizeLabel.text = model.totalSize;
    NSUInteger receivedSize = ZFDownloadLength(model.url);
    NSString *writtenSize = [NSString stringWithFormat:@"%.2f %@",
                             [model calculateFileSizeInUnit:(unsigned long long)receivedSize],
                             [model calculateUnit:(unsigned long long)receivedSize]];
    self.sizeLabel.text = [NSString stringWithFormat:@"%@/%@",writtenSize,model.totalSize];
    
    CGFloat progress = 1.0 * receivedSize / model.totalLength;
    self.progressV.progress = progress;
    self.speedLabel.text = [NSString stringWithFormat:@"%.2f%%",progress * 100];

    self.speedLabel.text = @"暂停";
    
}

- (IBAction)StartOrPause:(UIButton *)sender {
    
//    if (self.downloadBlock) {
//        self.downloadBlock(sender);
//    }
    
}

@end
