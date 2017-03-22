//
//  PlayerDowningCell.h
//  JZBRelease
//
//  Created by zjapple on 16/10/26.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZFSessionModel.h"
#import "ZFPlayer.h"

typedef void(^ZFDownloadBlock)(UIButton *);

@interface PlayerDowningCell : UITableViewCell

/** model */
@property (nonatomic, strong) ZFSessionModel *model;

@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressV;
@property (weak, nonatomic) IBOutlet UIButton *downStatusButton;

@property (nonatomic, copy  ) ZFDownloadBlock downloadBlock;

@end
