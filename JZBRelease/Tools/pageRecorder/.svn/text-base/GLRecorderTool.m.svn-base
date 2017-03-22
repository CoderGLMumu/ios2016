//
//  GLRecorderTool.m
//  JZBRelease
//
//  Created by Apple on 16/11/11.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "GLRecorderTool.h"




#define AMR_FRAME_COUNT_PER_SECOND 50

@interface GLRecorderTool () <SYAmrRecorderDelegate, SYAmrPlayerDelegate>



@end

@implementation GLRecorderTool


+ (instancetype)getInstance{
    static GLRecorderTool *instance = nil;
    static dispatch_once_t oneceToken;
    dispatch_once(&oneceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

- (void)startRecord {
    
    if (!_amrRecorder) {
        _amrRecorder = [[SYIMAmrRecorder alloc] init];
        GLLog(@"音频默认最大录音%lus",(unsigned long)_amrRecorder.maxRecordFrames)
        _amrRecorder.maxRecordFrames = AMR_FRAME_COUNT_PER_SECOND * 60 * 5;
        GLLog(@"音频默认最大录音修改成%lus",(unsigned long)_amrRecorder.maxRecordFrames)
        _amrRecorder.delegate = self;
    }
    
    if (_amrRecorder.isRecording) {
        [_amrRecorder sy_stopRecord];
    }
    
    //开始录音
    NSString *localAmr = [self generateCacheFilePath:@"amr" fileName:[NSString stringWithFormat:@"local%.f.amr", [[NSDate date] timeIntervalSince1970] * 1000.0]];
    
    //这个路径一定要创建成功后再初始化录音机
    if (localAmr.length > 0) {
        [_amrRecorder sy_startRecordWithPath:localAmr];
    }
}

- (void)stopRecord {
    [_amrRecorder sy_stopRecord];
}

- (void)cancelRecord {
    [_amrRecorder sy_cancleRecord];
}

- (void)playRecord {
    if (_amrPlayer) {
        [_amrPlayer stop];
        _amrPlayer = nil;
    }
    
    //这个路径一定要要是存在的，否则播放失败
    if (_amrRecorder.mPath.length > 0) {
        _amrPlayer = [[SYIMAmrPlayer alloc] initWithPath:_amrRecorder.mPath];
        _amrPlayer.delegate = self;
        GLLog(@"%@", _amrRecorder.mPath)
        [_amrPlayer play];
    }
}

- (void)stopPlaylayRecord
{
    if (_amrPlayer) {
        [_amrPlayer stop];
//        if (self.stopanima) {
//            self.stopanima();
//        }
        _amrPlayer = nil;
    }
}

- (void)playRecordWithJZBPath:(NSString *)mPath
{
    if (_amrPlayer) {
        [_amrPlayer stop];
        _amrPlayer = nil;
    }
    
    //这个路径一定要要是存在的，否则播放失败
    if (mPath.length > 0) {
        _amrPlayer = [[SYIMAmrPlayer alloc] initWithPath:mPath];
        _amrPlayer.delegate = self;
        GLLog(@"%@", mPath)
        [_amrPlayer play];
    }
}

- (void)uploadRecordWithquestion_id:(NSString *)question_id Audio_length:(NSString *)audio_length eval_id:(NSString *)eval_id {
    
    if (self.amrRecorder.recordFrames >= 300) {
        
        [SVProgressHUD showInfoWithStatus:@"录音超过5分钟，评论失败"];
        
        return ;
    }
    
    if (self.amrRecorder.recordFrames <= 1) {
        
        [SVProgressHUD showInfoWithStatus:@"录音未超1秒，评论失败"];
        
        return ;
    }
    
    NSData *data = [[NSData alloc]initWithContentsOfFile:self.amrRecorder.mPath];
    
    //    NSData *imageData = UIImageJPEGRepresentation(img, 1.0);
    
    //添加要上传的文件，此处为图片
    
    //    [formData appendPartWithFileData:imageData name:@"file(看上面接口，服务器放图片的参数名Key）" fileName:@"图片名字(随便写一个，（注意后缀名）如果是UIImagePNGRepresentation写XXXX.png,如果是UIImageJPEGRepresentation写XXXX.jpeg)"mimeType:@"文件类型（此处为图片格式，如image/jpeg，对应前面的PNG/JPEG）"];
    
    // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
    // 要解决此问题，
    // 可以在上传时使用当前的系统事件作为文件名
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    // 设置时间格式
//    formatter.dateFormat = @"yyyyMMddHHmmss";
//    NSString *str = [formatter stringFromDate:[NSDate date]];
//    NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
    
    FromData * fromData = [FromData new];
    fromData.data = data;
    fromData.name = @"file";
    fromData.filename = self.amrRecorder.mPath;
    fromData.mimeType = @"arm";
    
    NSArray *dataArr = @[fromData];
    
//    NSDictionary *parameters = @{
//                                 @"access_token":[[LoginVM getInstance]readLocal].token,
//                                 @"question_id":question_id,
//                                 @"eval_id":eval_id,
//                                 @"file":data
//                                 };
    
    HttpBaseRequestItem *item = [HttpBaseRequestItem new];
    item.access_token = [[LoginVM getInstance]readLocal].token;
    item.question_id = question_id;
    item.eval_id = eval_id;
    item.file = data;
    item.audio_length = [NSString stringWithFormat:@"%lu",(unsigned long)self.amrRecorder.recordFrames];
    NSDictionary *parameters = item.mj_keyValues;
    
    //    NSString *str = [@"http://192.168.10.154/bang/index.php" ];
    
    //    NSString *str11 = [[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/user/update"];
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/Question/evaluate"] parameters:parameters fromDataArray:dataArr success:^(id json) {
        //         NSLog(@"json= %@",json);
        if (![json[@"state"] isEqual:@(0)]){
            [SVProgressHUD showSuccessWithStatus:@"您的高见已经成功发布，感谢您的参与和分享，相信这样精彩的观点一定会让更多的伙伴受益！"];
            if (self.updateUI) {
                self.updateUI();
            }
        }else{
            [SVProgressHUD showSuccessWithStatus:@"语音发送失败,请稍后再试"];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showSuccessWithStatus:@"语音发送失败,请稍后再试"];
    }];
    
}


//更新录音meters(音量大小，插上耳机的话meters值会变得很小，自己判断)
- (void)updateMeters:(float)meters {
    UIImage *prossImage = [UIImage imageNamed:@"RecordingSignal001"];
    
    if (meters >= .8) {
        prossImage = [UIImage imageNamed:@"RecordingSignal008"];
    }
    else if (meters >= .7) {
        prossImage = [UIImage imageNamed:@"RecordingSignal007"];
    }
    else if (meters >= .6) {
        prossImage = [UIImage imageNamed:@"RecordingSignal006"];
    }
    else if (meters >= .5) {
        prossImage = [UIImage imageNamed:@"RecordingSignal005"];
    }
    else if (meters >= .4) {
        prossImage = [UIImage imageNamed:@"RecordingSignal004"];
    }
    else if (meters >= .3) {
        prossImage = [UIImage imageNamed:@"RecordingSignal003"];
    }
    else if (meters >= .2) {
        prossImage = [UIImage imageNamed:@"RecordingSignal002"];
    }
    else if (meters >= .1) {
        prossImage = [UIImage imageNamed:@"RecordingSignal001"];
    }
    
    
    self.voiceView.speakRightImageV.image = prossImage;
    
//    self.imageMeters.image = prossImage;
    
    //时间
//    [self.btnRecorder setTitle:[NSString stringWithFormat:@"时长：%lds",_amrRecorder.recordFrames] forState:UIControlStateNormal];
}

#pragma mark - SYIMAmrRecorderDelegate

- (void)syAmrRecorder:(SYIMAmrRecorder *)recorder didUpdateMeters:(float)meters {
    GLLog(@"meters==%f",meters);
    [self updateMeters:meters];
    
    self.voiceView.hidden = NO;
    
}

- (void)syAmrRecorderDidStart:(SYIMAmrRecorder *)recorder {
    GLLog(@"syAmrRecorderDidStart");
    
    [self showVoiceView];
    
    if (self.stopanima) {
        self.stopanima();
    }
    
    //    [self showBeginTalkMask];
}

- (void)syAmrRecorderDidFail:(SYIMAmrRecorder *)recorder {
    GLLog(@"syAmrRecorderDidFail");
    [SYSharedTool showAlertWithTitle:@"访问麦克风失败" message:@"无法访问您的麦克风，请到手机系统的设置-隐私-麦克风中设置！" cancleTitle:@"知道了" okTitle:nil delegate:nil];
}

- (void)syAmrRecorderDidStop:(SYIMAmrRecorder *)recorder {
    NSLog(@"syAmrRecorderDidStop");
    
    if ([recorder sy_isRecordTooShort]) {
        //        [self showTooShortTalkMask];
    }
    else if ([recorder sy_isRecordTooLong]) {
        //        [self showTooLongTalkMask];
    }
    else {
        //        [self hideTalkMask];
    }
//    [self.btnRecorder setTitle:@"点击开始录音" forState:UIControlStateNormal];
    GLLog(@"录音时长：%lds",_amrRecorder.recordFrames);
    
    [self hiddenVoiceView];
    
}

#pragma mark - SYIMAmrPlayerDelegate

- (void)syAmrPlayerDidStarted:(SYIMAmrPlayer *)player {
    GLLog(@"syAmrPlayerDidStarted");
}

- (void)syAmrPlayerDidEnded:(SYIMAmrPlayer *)player {
    GLLog(@"syAmrPlayerDidEnded");
    if (self.stopanima) {
        self.stopanima();
    }
    
}

- (void)syAmrPlayerDidFail:(SYIMAmrPlayer *)player {
    GLLog(@"syAmrPlayerDidFail");
}

#pragma mark - amr file cache

- (NSString *)generateCacheFilePath:(NSString *)dirName fileName:(NSString *)fileName {
    NSString *filePath = [[self generateCacheDirPath:dirName] stringByAppendingPathComponent:fileName];
    return filePath;
}

- (NSString *)generateCacheDirPath:(NSString *)dirName {
  //  NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
//    NSString *dirPath = [cachesPath stringByAppendingPathComponent:dirName];
    NSString *dirPath_old = [LocalDataRW getDirectory:Directory_BB];
    
    NSString *dirPath = [dirPath_old stringByAppendingPathComponent:@"GLRecorderTool"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    BOOL isExists = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    if (!(isExists && isDir))
        [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    return dirPath;
}


- (void)showVoiceView
{
    self.voiceView = [voiceTipView sharevoiceTipView];
    [self.showVC.view addSubview:self.voiceView];
    self.voiceView.hidden = YES;
}

- (void)hiddenVoiceView
{
    self.voiceView.hidden = YES;
}

- (void)changeBotLabelText:(BotLabelType)type
{
    if (self.voiceView) {
        [self.voiceView changeBotLabelText:type];
    }
}

@end
