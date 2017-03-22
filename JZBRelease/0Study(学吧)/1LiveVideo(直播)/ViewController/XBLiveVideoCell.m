//
//  XBLiveVideoCell.m
//  JZBRelease
//
//  Created by zjapple on 16/9/9.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "XBLiveVideoCell.h"
#import "LocalDataRW.h"
#import "ZJBHelp.h"
@interface XBLiveVideoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userAvaImageView;
@property (weak, nonatomic) IBOutlet UILabel *liveNum;
@property (weak, nonatomic) IBOutlet UILabel *contentTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *liveStatusImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *GuanZhuNumLabel;

@end

@implementation XBLiveVideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"XBLiveVideoCell" owner:nil options:nil] lastObject];
        [self setupSubView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupSubView];
    
}

- (void)setupSubView
{
    self.userAvaImageView.layer.cornerRadius = self.userAvaImageView.glw_width * 0.5;
    self.userAvaImageView.clipsToBounds = YES;
    self.userAvaImageView.layer.borderWidth = 2;
    self.userAvaImageView.layer.borderColor = [UIColor whiteColor].CGColor;
}

//课程
- (void)setCourseModel:(CourseModel *)courseModel{
    if (!courseModel) {
        return;
    }
//    [self.userAvaImageView sd_setImageWithURL:[NSURL URLWithString:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:courseModel.user.avatar]] placeholderImage:[UIImage imageNamed:@"HX_img_head"]];
    
    [LocalDataRW getImageWithDirectory:Directory_XB RetalivePath:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:courseModel.user.avatar] WithContainerImageView:self.userAvaImageView];
    
    
    [self.nickNameLabel setText:courseModel.user.nickname];
    if (!courseModel.join_count || [courseModel.join_count integerValue] <= 0) {
        self.liveNum.text = @"0";
    }else{
        self.liveNum.text = courseModel.join_count;
    }
    self.liveStatusImageView.image = [UIImage imageNamed:@"ZB_ZZLX"];
    self.contentTitleLabel.text = courseModel.title;
//    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:courseModel.thumb]] placeholderImage:nil];
    
    NSString *path = [[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:courseModel.thumb];
    dispatch_async(dispatch_queue_create("queue_content", nil), ^{
        UIImage *image = [LocalDataRW getImageWithDirectory:Directory_XB RetalivePath:path];
        
        __block typeof (image) wimage = image;
        dispatch_async(dispatch_get_main_queue(), ^{
            wimage = [ZJBHelp handleImage:wimage withSize:self.contentImageView.frame.size withFromStudy:YES];
            [self.contentImageView setImage:wimage];
        });
    });
}

//课时

- (void)setCourseTimeModel:(CourseTimeModel *)courseTimeModel{
    if (!courseTimeModel) {
        return;
    }
//    [self.userAvaImageView sd_setImageWithURL:[NSURL URLWithString:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:courseTimeModel.teacher.avatar]] placeholderImage:[UIImage imageNamed:@"HX_img_head"]];
    
    [LocalDataRW getImageWithDirectory:Directory_XB RetalivePath:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:courseTimeModel.teacher.avatar] WithContainerImageView:self.userAvaImageView];
    
    
    [self.nickNameLabel setText:courseTimeModel.teacher.nickname];
    if (!courseTimeModel.join_count || [courseTimeModel.join_count integerValue] <= 0) {
        self.liveNum.text = @"0";
    }else{
        self.liveNum.text = courseTimeModel.join_count;
    }
    if ([courseTimeModel.label isEqualToString:@"直播预告"]) {
        self.liveStatusImageView.image = [UIImage imageNamed:@"ZB_ZBYG"];
    }else if([courseTimeModel.label isEqualToString:@"正在直播"]){
        self.liveStatusImageView.image = [UIImage imageNamed:@"ZB_ZZZB"];
    }else{
        self.liveStatusImageView.image = [UIImage imageNamed:@"ZB_ZZLX"];
    }
    self.contentTitleLabel.text = courseTimeModel.title;
    NSString *path = [[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:courseTimeModel.thumb];
    dispatch_async(dispatch_queue_create("queue_content", nil), ^{
        UIImage *image = [LocalDataRW getImageWithDirectory:Directory_XB RetalivePath:path];
        
        __block typeof (image) wimage = image;
        dispatch_async(dispatch_get_main_queue(), ^{
            wimage = [ZJBHelp handleImage:wimage withSize:self.contentImageView.frame.size withFromStudy:YES];
            [self.contentImageView setImage:wimage];
        });
    });
    if (!courseTimeModel.zan_count || courseTimeModel.zan_count.length == 0) {
        courseTimeModel.zan_count = @"0";
    }
    [self.GuanZhuNumLabel setText:courseTimeModel.zan_count];
    
    //[self.contentImageView sd_setImageWithURL:[NSURL URLWithString:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:courseTimeModel.thumb]] placeholderImage:nil];
    
    NSTimeInterval time= [courseTimeModel.start_time doubleValue];
    self.timeLabel.text = [[self dateFormatter] stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];

}

- (NSDateFormatter *)dateFormatter {
    static NSDateFormatter* dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YY年MM月dd日 hh:mm"];
    });
    return dateFormatter;
}

//- (void)setModel:(NSString *)model

- (void)setModel1:(XBLiveListItem *)model1

{
    _model1 = model1;
    
//    if ([model1.type integerValue] == 1) {
//         self.liveStatusImageView.image = [UIImage imageNamed:@"XB_XS_JCHF"];
//    }else if ([model1.type integerValue] == 3){
//        if ([model1.label isEqualToString:@"直播预告"]) {
//            self.liveStatusImageView.image = [UIImage imageNamed:@"ZB_ZBYG"];
//        }else if([model1.label isEqualToString:@"正在直播"]){
//            self.liveStatusImageView.image = [UIImage imageNamed:@"ZB_ZZZB"];
//        }
//    }
//    
//    if (model1.start_time) {
//        NSTimeInterval time= [model1.start_time doubleValue];
//        self.timeLabel.text = [[self dateFormatter] stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
//    }
//    
//    
//    self.liveNum.text = model1.online_count;
//    self.nickNameLabel.text = model1.teacher.nickname;
//    self.contentTitleLabel.text = model1.title;
//    
//    [self.userAvaImageView sd_setImageWithURL:[NSURL URLWithString:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:model1.teacher.avatar]] placeholderImage:[UIImage imageNamed:@"HX_img_head"]];
//    
//    NSString *path = [[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:model1.thumb];
//     dispatch_async(dispatch_queue_create("queue_content", nil), ^{
//        UIImage *image = [LocalDataRW getImageWithDirectory:Directory_XB RetalivePath:path];
//         __block typeof (image) wimage = image;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            wimage = [ZJBHelp handleImage:wimage withSize:self.contentImageView.frame.size withFromStudy:YES];
//            [self.contentImageView setImage:wimage];
//        });
//    });
//
//    self.GuanZhuNumLabel.text = model1.zan_count;
    
}

- (void)setModel2:(XBLiveListItem *)model2
{
    _model2 = model2;
    
    self.liveStatusImageView.image = [UIImage imageNamed:@"ZB_ZZZB"];
    
    self.liveStatusImageView.image = [UIImage imageNamed:@"ZB_ZBYG"];
    
    self.liveNum.text = model2.online_count;
    self.nickNameLabel.text = model2.teacher.nickname;
    self.contentTitleLabel.text = model2.title;
    
    NSTimeInterval time= [model2.start_time doubleValue];
    self.timeLabel.text = [[self dateFormatter] stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
    
//    [self.userAvaImageView sd_setImageWithURL:[NSURL URLWithString:[AddHostToLoadPIC AddHostToLoadPICWithString:model2.teacher.avatar]] placeholderImage:[UIImage imageNamed:@"HX_img_head"]];
    
    [LocalDataRW getImageWithDirectory:Directory_XB RetalivePath:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:model2.teacher.avatar] WithContainerImageView:self.userAvaImageView];
    
    //[self.contentImageView sd_setImageWithURL:[NSURL URLWithString:[AddHostToLoadPIC AddHostToLoadPICWithString:model2.thumb]] placeholderImage:nil];
    NSString *path = [[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:model2.thumb];
    dispatch_async(dispatch_queue_create("queue_content", nil), ^{
        UIImage *image = [LocalDataRW getImageWithDirectory:Directory_XB RetalivePath:path];
        __block typeof (image) wimage = image;
        dispatch_async(dispatch_get_main_queue(), ^{
            wimage = [ZJBHelp handleImage:wimage withSize:self.contentImageView.frame.size withFromStudy:YES];
            [self.contentImageView setImage:wimage];
        });
    });
}

@end
