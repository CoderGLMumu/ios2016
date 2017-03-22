//
//  VideoDetailXGKCCell.m
//  JZBRelease
//
//  Created by zjapple on 16/10/13.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "VideoDetailXGKCCell.h"
#import "Defaults.h"
@interface VideoDetailXGKCCell (){
    dispatch_queue_t queue;
}

@property (weak, nonatomic) IBOutlet UIImageView *avaImageView;
@property (weak, nonatomic) IBOutlet UILabel *TtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (weak, nonatomic) IBOutlet UILabel *joinCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;

@end

@implementation VideoDetailXGKCCell

- (void)awakeFromNib {
    [super awakeFromNib];
    queue = dispatch_queue_create("contentQueue", nil);
}

- (void)setItem:(XBLiveListItem *)item
{
    _item = item;
    
    //if (!self.avaImageView.image) {
        NSString *path = [[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:item.thumb];
        dispatch_async(queue, ^{
            UIImage *image = [LocalDataRW getImageWithDirectory:Directory_XB RetalivePath:path];
            __block typeof (image) wimage = image;
            dispatch_async(dispatch_get_main_queue(), ^{
                wimage = [ZJBHelp handleImage:image withSize:CGSizeMake(self.avaImageView.frame.size.width * 2, self.avaImageView.frame.size.height * 2)  withFromStudy:YES];
                [self.avaImageView setImage:wimage];
            });
        });
    //}
    //[self.avaImageView sd_setImageWithURL:[NSURL URLWithString:[AddHostToLoadPIC AddHostToLoadPICWithString:item.thumb]] placeholderImage:[UIImage imageNamed:@"gdkc_pic"]];
    self.TtitleLabel.text = item.title;
    self.nickNameLabel.text = item.teacher.nickname;
//    self.companyLabel.text = item.teacher.company;
    if (item.teacher.company.length >=8) {
        self.companyLabel.text = [NSString stringWithFormat:@"%@...",[item.teacher.company substringToIndex:8]];
    }else {
        self.companyLabel.text = item.teacher.company;
    }
    self.joinCountLabel.text = [NSString stringWithFormat:@"%@人报名",item.join_count];
  //  AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
 //   if (appDelegate.checkpay) {
        if ([LoginVM getInstance].users.vip) {
            AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            
            if (appDelegate.checkpay) {
                self.scoreLabel.text = [NSString stringWithFormat:@"%@元(会员免费)",item.score];
            }else{
                self.scoreLabel.text = [NSString stringWithFormat:@"%@帮币(会员免费)",item.score];
            }
            
        }else{
            AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            
            if (appDelegate.checkpay) {
                self.scoreLabel.text = [NSString stringWithFormat:@"%@元",item.score];
            }else{
                self.scoreLabel.text = [NSString stringWithFormat:@"%@元",item.score];
            }
        }
//    }else{
//        self.scoreLabel.text = @"免费";
//    }
    
    
}


@end
