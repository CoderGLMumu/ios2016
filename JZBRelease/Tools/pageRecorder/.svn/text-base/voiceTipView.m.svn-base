//
//  voiceTipView.m
//  JZBRelease
//
//  Created by Apple on 16/11/15.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "voiceTipView.h"

#import "Masonry.h"

@interface voiceTipView ()

/** botLabel */
@property (nonatomic, weak) UILabel *botLabel;
/** speakLeftImageV */
@property (nonatomic, weak) UIImageView *speakLeftImageV;

@end

@implementation voiceTipView

static voiceTipView *_instance;

//类方法，返回一个单例对象
+ (instancetype)sharevoiceTipView
{
    return [[self alloc]init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    
    return _instance;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self setupSubView];
        });
        
    }
    return self;
}

- (void)setupSubView
{
    self.layer.cornerRadius = 8;
    self.clipsToBounds = YES;
    
    self.glw_width = GLScreenW * 0.5;
    self.glh_height = GLScreenW * 0.5;
    
    self.glcx_centerX = GLScreenW * 0.5;
    self.glcy_centerY = GLScreenH * 0.5;
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    UILabel *botLabel = [UILabel new];
    self.botLabel = botLabel;
    botLabel.text = @"手指上滑，取消发送";
    botLabel.textAlignment = NSTextAlignmentCenter;
    botLabel.font = [UIFont systemFontOfSize:14];
    botLabel.textColor = [UIColor whiteColor];
    [self addSubview:botLabel];
    [botLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-15);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
    }];
    
    UIImageView *speakLeftImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"RecordingBkg@2x.png"]];
    self.speakLeftImageV = speakLeftImageV;
    [self addSubview:speakLeftImageV];
    [speakLeftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(botLabel.mas_top).offset(-15);
        make.left.equalTo(self).offset(45);
    }];
    
    UIImageView *speakRightImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"RecordingSignal001@2x.png"]];
    self.speakRightImageV = speakRightImageV;
    [self addSubview:speakRightImageV];
    [speakRightImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(botLabel.mas_top).offset(-25);
        make.right.equalTo(self).offset(-45);
    }];
    
}

- (void)changeBotLabelText:(BotLabelType)type
{
    if (type == 0) {
        self.botLabel.text = @"手指上滑，取消发送";
        self.botLabel.backgroundColor = [UIColor clearColor];
    }else if (type == 1) {
        self.botLabel.text = @"松开手指，取消发送";
//        self.botLabel.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"1976d2"];
        self.botLabel.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"222222"];
    }
}

@end
