//
//  recorderPlayView.m
//  JZBRelease
//
//  Created by Apple on 16/11/14.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "recorderPlayView.h"
#import "GLRecorderTool.h"

#import "HSDownloadManager.h"

//#import "ZFDownloadManager.h"

#import "Masonry.h"

@interface recorderPlayView (){
    NSInteger state;
    GetValueObject *obj;
}

/** imageV */
@property (nonatomic, weak) UIImageView *imageV0;
/** imageV_anima */
@property (nonatomic, weak) UIImageView *imageV_anima0;

/** imageV */
@property (nonatomic, weak) UIImageView *imageV1;
/** imageV_anima */
@property (nonatomic, weak) UIImageView *imageV_anima1;

@end

@implementation recorderPlayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = frame;
//        [self setupSubView];
    }
    return self;
}

- (instancetype)initWithContent:(NSString *)content
{
    self = [super init];
    if (self) {
        obj = [[GetValueObject alloc]init];
        if (obj.inteval != 4) {
            self.frame = CGRectMake(0, 0, GLScreenW, 40);
        }else{
            self.frame = CGRectMake(0, 0, GLScreenW, 30);
        }
        
        [self setupSubViewContent:content];
        [self setupSubViewContent1:content];
    }
    return self;
}

- (void)setupSubViewContent:(NSString *)content
{
//    self.glw_width = 244;
//    self.glh_height = 35;
    
//    UIImageView *imageBG = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"recorderPlayBG"]];
    UIView *imageBG = [UIView new];
//    imageBG.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"FB514D"];
    imageBG.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"ff9800"];
    [self addSubview:imageBG];
    [imageBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(0);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width / 3, self.frame.size.height));
    }];
    imageBG.layer.cornerRadius = self.glh_height * 0.5;
    imageBG.clipsToBounds = YES;
    self.imageBGSmall = imageBG;
    self.imageBGSmall.hidden = YES;
    
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"recorderPlayVideo4"]];
    self.imageV0 = imageV;
    [self.imageBGSmall addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageBGSmall).offset(15);
        make.top.equalTo(@(self.glh_height / 2 - imageV.glh_height * 0.5));
//        make.width.height.equalTo(@(self.glh_height * 0.5));
//        make.height.equalTo(@(self.glh_height * 0.9));
    }];
    
    UIImageView *imageV_anima = [[UIImageView alloc]init];
    [self.imageBGSmall addSubview:imageV_anima];
    imageV_anima.contentMode = UIViewContentModeLeft;
//    [imageV_anima mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@(10));
//        make.top.equalTo(@(self.glh_height / 2 - imageV.glh_height * 0.5));
////        make.edges.equalTo(imageV);
//    }];
    
    [self layoutIfNeeded];

    imageV_anima.frame = imageV.frame;
    
    self.imageV_anima0 = imageV_anima;
    // 加载所有的动画图片
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 0; i<=4; i++) {
        
        NSString *filenamePrefix = @"BB_YY_voice";
        
        NSString *filename = [NSString stringWithFormat:@"%@0%d", filenamePrefix, i];
        //NSString *file = [[NSBundle mainBundle] pathForResource:filename ofType:@"png"];
        UIImage *image = [UIImage imageNamed:filename];
        if (image) {
            [images addObject:image];
        }
    }
    
    // 设置动画图片
    imageV_anima.animationImages = images;
    // 设置播放次数
    imageV_anima.animationRepeatCount = 0;
    imageV_anima.animationDuration = 1;
    imageV_anima.hidden = YES;
//    imageV_anima.image = [UIImage imageNamed:@"recorderPlayVideo3"];
    
    
    UILabel *rightLabel = [UILabel new];
    [rightLabel setFont:[UIFont systemFontOfSize:14]];
    [rightLabel setFrame:CGRectMake(self.imageBGSmall.frame.size.width - 10 - 100, 0, 100, self.imageBGSmall.frame.size.height)];
    self.rightLabel0 = rightLabel;
    /** 文本颜色 */
    rightLabel.textColor = [UIColor whiteColor];
    rightLabel.text = content;
    rightLabel.textAlignment = NSTextAlignmentRight;
    //[rightLabel sizeToFit];
    [self.imageBGSmall addSubview:rightLabel];
    
}

- (void)setupSubViewContent1:(NSString *)content
{
    //    self.glw_width = 244;
    //    self.glh_height = 35;
    
    //    UIImageView *imageBG = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"recorderPlayBG"]];
    UIView *imageBG = [UIView new];
//    imageBG.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"FB514D"];
    imageBG.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"ff9800"];
    [self addSubview:imageBG];
    [imageBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(0);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width / 3 * 2, self.frame.size.height));
    }];
    imageBG.layer.cornerRadius = self.glh_height * 0.5;
    imageBG.clipsToBounds = YES;
    self.imageBGBig = imageBG;
    self.imageBGBig.hidden = YES;
    
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"recorderPlayVideo4"]];
    self.imageV1 = imageV;
    [self.imageBGBig addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageBGBig).offset(15);
        make.top.equalTo(@(self.glh_height / 2 - imageV.glh_height * 0.5));
        //        make.width.height.equalTo(@(self.glh_height * 0.5));
        //        make.height.equalTo(@(self.glh_height * 0.9));
    }];
    
    UIImageView *imageV_anima = [[UIImageView alloc]init];
    [self.imageBGBig addSubview:imageV_anima];
    imageV_anima.contentMode = UIViewContentModeLeft;
    //    [imageV_anima mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(@(10));
    //        make.top.equalTo(@(self.glh_height / 2 - imageV.glh_height * 0.5));
    ////        make.edges.equalTo(imageV);
    //    }];
    
    [self layoutIfNeeded];
    
    imageV_anima.frame = imageV.frame;
    
    self.imageV_anima1 = imageV_anima;
    // 加载所有的动画图片
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 0; i<=4; i++) {
        
        NSString *filenamePrefix = @"BB_YY_voice";
        
        NSString *filename = [NSString stringWithFormat:@"%@0%d", filenamePrefix, i];
        //NSString *file = [[NSBundle mainBundle] pathForResource:filename ofType:@"png"];
        UIImage *image = [UIImage imageNamed:filename];
        if (image) {
            [images addObject:image];
        }
    }
    
    // 设置动画图片
    imageV_anima.animationImages = images;
    // 设置播放次数
    imageV_anima.animationRepeatCount = 0;
    imageV_anima.animationDuration = 1;
    imageV_anima.hidden = YES;
    //    imageV_anima.image = [UIImage imageNamed:@"recorderPlayVideo3"];
    
    
    UILabel *rightLabel = [UILabel new];
    [rightLabel setFont:[UIFont systemFontOfSize:14]];
    self.rightLabel1 = rightLabel;
    [rightLabel setFrame:CGRectMake(self.imageBGBig.frame.size.width - 10 - 100, 0, 100, self.imageBGSmall.frame.size.height)];
    /** 文本颜色 */
    rightLabel.textColor = [UIColor whiteColor];
    rightLabel.text = content;
    rightLabel.textAlignment = NSTextAlignmentRight;
    //[rightLabel sizeToFit];
    [self.imageBGBig addSubview:rightLabel];
    
}


- (void)stopAnima
{
    if (!self.imageBGSmall.hidden) {
        self.imageV0.hidden = NO;
        self.imageV_anima0.hidden = YES;
        [self.imageV_anima0 stopAnimating];
        return;
    }
    if (!self.imageBGBig.hidden) {
        self.imageV1.hidden = NO;
        self.imageV_anima1.hidden = YES;
        [self.imageV_anima1 stopAnimating];
        return;
    }
}

- (void)startAnima
{
    if (!self.imageBGSmall.hidden) {
        self.imageV0.hidden = YES;
        self.imageV_anima0.hidden = NO;
        [self.imageV_anima0 startAnimating];
        return;
    }
    if (!self.imageBGBig.hidden) {
        self.imageV1.hidden = YES;
        self.imageV_anima1.hidden = NO;
        [self.imageV_anima1 startAnimating];
        return;
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self downloadTestDone];
    
    
    //  播放音频
//    GLRecorderTool * tool = [[GLRecorderTool alloc]init];
//    [tool playRecordWithJZBPath:@"http://120.77.48.254/Bang/Uploads/Audio/2016-11-1423634/58297292ce62d16448.amr"];
    
    //http://120.77.48.254/Bang/Uploads/Audio/2016-11-1423634/58297292ce62d16448.amr
    
}

- (void)downloadTestDone
{
    if (self.playBlock) {
        self.playBlock();
    }
}

@end
