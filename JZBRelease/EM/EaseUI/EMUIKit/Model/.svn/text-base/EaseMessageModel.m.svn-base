/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "EaseMessageModel.h"

#import "EaseEmotionEscape.h"
#import "EaseConvertToCommonEmoticonsHelper.h"

#import "HXFriendDataSource.h"
#import "Users.h"
#import "DataBaseHelperSecond.h"
#import "HXGroupList.h"
#import "SendAndGetDataFromNet.h"

@interface EaseMessageModel ()

/** FMDBTool */
@property (nonatomic, strong) GLFMDBToolSDK *FMDBTool;

/** user */
@property (nonatomic, strong) Users *user;

@end

@implementation EaseMessageModel

- (Users *)user
{
    if (_user == nil) {
        _user = [[Users alloc] init];
    }
    return _user;
}

- (GLFMDBToolSDK *)FMDBTool
{
    if (_FMDBTool == nil) {
        _FMDBTool = [GLFMDBToolSDK shareToolsWithCreateDDL:nil];
    }
    return _FMDBTool;
}

/** 高林修改聊天详情的头像和名称等数据 */
- (instancetype)initWithMessage:(EMMessage *)message
{
    self = [super init];
    if (self) {
        _cellHeight = -1;
        _message = message;
        _firstMessageBody = message.body;
        _isMediaPlaying = NO;
        _nickname = message.from;
        _isSender = message.direction == EMMessageDirectionSend ? YES : NO;
        
        switch (_firstMessageBody.type) {
            case EMMessageBodyTypeText:
            {
                EMTextMessageBody *textBody = (EMTextMessageBody *)_firstMessageBody;
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper convertToSystemEmoticons:textBody.text];
                self.text = didReceiveText;
            }
                break;
            case EMMessageBodyTypeImage:
            {
                EMImageMessageBody *imgMessageBody = (EMImageMessageBody *)_firstMessageBody;
                NSData *imageData = [NSData dataWithContentsOfFile:imgMessageBody.localPath];
                if (imageData.length) {
                    self.image = [UIImage imageWithData:imageData];
                }
                
                if ([imgMessageBody.thumbnailLocalPath length] > 0) {
                    self.thumbnailImage = [UIImage imageWithContentsOfFile:imgMessageBody.thumbnailLocalPath];
                }
                else{
                    CGSize size = self.image.size;
                    self.thumbnailImage = size.width * size.height > 200 * 200 ? [self scaleImage:self.image toScale:sqrt((200 * 200) / (size.width * size.height))] : self.image;
                }
                
                self.thumbnailImageSize = self.thumbnailImage.size;
                self.imageSize = imgMessageBody.size;
                if (!_isSender) {
                    self.fileURLPath = imgMessageBody.remotePath;
                }
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                EMLocationMessageBody *locationBody = (EMLocationMessageBody *)_firstMessageBody;
                self.address = locationBody.address;
                self.latitude = locationBody.latitude;
                self.longitude = locationBody.longitude;
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                EMVoiceMessageBody *voiceBody = (EMVoiceMessageBody *)_firstMessageBody;
                self.mediaDuration = voiceBody.duration;
                self.isMediaPlayed = NO;
                if (message.ext) {
                    self.isMediaPlayed = [[message.ext objectForKey:@"isPlayed"] boolValue];
                }
                
                // audio file path
                self.fileURLPath = voiceBody.remotePath;
            }
                break;
            case EMMessageBodyTypeVideo:
            {
                EMVideoMessageBody *videoBody = (EMVideoMessageBody *)message.body;
                self.thumbnailImageSize = videoBody.thumbnailSize;
                if ([videoBody.thumbnailLocalPath length] > 0) {
                    NSData *thumbnailImageData = [NSData dataWithContentsOfFile:videoBody.thumbnailLocalPath];
                    if (thumbnailImageData.length) {
                        self.thumbnailImage = [UIImage imageWithData:thumbnailImageData];
                    }
                    self.image = self.thumbnailImage;
                }
                
                // video file path
                self.fileURLPath = videoBody.remotePath;
            }
                break;
            case EMMessageBodyTypeFile:
            {
                EMFileMessageBody *fileMessageBody = (EMFileMessageBody *)_firstMessageBody;
                self.fileIconName = @"chat_item_file";
                self.fileName = fileMessageBody.displayName;
                self.fileSize = fileMessageBody.fileLength;
                
                if (self.fileSize < 1024) {
                    self.fileSizeDes = [NSString stringWithFormat:@"%fB", self.fileSize];
                }
                else if(self.fileSize < 1024 * 1024){
                    self.fileSizeDes = [NSString stringWithFormat:@"%.2fkB", self.fileSize / 1024];
                }
                else if (self.fileSize < 2014 * 1024 * 1024){
                    self.fileSizeDes = [NSString stringWithFormat:@"%.2fMB", self.fileSize / (1024 * 1024)];
                }
            }
                break;
            default:
                break;
        }
    }
    
    if (message.chatType == EMChatTypeChat) {
        /** 单聊 */
        
        /** 高林 转换HX头像-用户名 */
        if (_isSender) {
            DataBaseHelperSecond *db = [DataBaseHelperSecond getInstance];
            [db initDataBaseDB];
            self.user.uid = [[[LoginVM getInstance]readLocal] _id];
            self.user = (Users *)[db getModelFromTabel:self.user];
            _avatarURLPath = [LocalDataRW getImageAllStr:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:self.user.avatar]];
            _nickname = self.user.nickname;
            
        }else{
            // 传入DDL 创建表打开数据库[banner][entranceIcons][partitions]
            self.FMDBTool = [GLFMDBToolSDK shareToolsWithCreateDDL:nil];
            
            // 查询数据【banner】
            NSString *query_sql = @"select * from t_HXFriendDataSource";
            
            FMResultSet *result = [self.FMDBTool queryWithSql:query_sql];
            HXFriendDataSource *profileEntity = [HXFriendDataSource new];
            while ([result next]) { // next方法返回yes代表有数据可取
                
                profileEntity.uid = [result stringForColumn:@"uid"];
                
                if ([profileEntity.uid isEqualToString:[self.message.from substringFromIndex:7]]) {
                    profileEntity.nickname = [result stringForColumn:@"nickname"];
                    profileEntity.UserModel = [NSKeyedUnarchiver unarchiveObjectWithData:[result dataNoCopyForColumn:@"UserModel"]];
                    if (profileEntity.UserModel.avatarURLPath) {
                        //          model.avatarURLPath = profileEntity.imageUrl;
                        //                model.nickname = profileEntity.nickname;
                        _avatarURLPath = profileEntity.UserModel.avatarURLPath;
                        _nickname = profileEntity.nickname;
                    }
                }
            }
        }
        
    }else if (message.chatType == EMChatTypeGroupChat) {
        /** 群聊 */
        
        /** 高林 转换HX头像-用户名 */
        if (_isSender) {
            DataBaseHelperSecond *db = [DataBaseHelperSecond getInstance];
            [db initDataBaseDB];
            self.user.uid = [[[LoginVM getInstance]readLocal] _id];
            self.user = (Users *)[db getModelFromTabel:self.user];
            _avatarURLPath = [LocalDataRW getImageAllStr:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:self.user.avatar]];
            _nickname = self.user.nickname;
        }else{
            // 传入DDL 创建表打开数据库[banner][entranceIcons][partitions]
            self.FMDBTool = [GLFMDBToolSDK shareToolsWithCreateDDL:nil];
            
            // 查询数据【banner】
//            NSString *query_sql = @"select * from 111";
//            
//            FMResultSet *result = [self.FMDBTool queryWithSql:query_sql];
            NSUserDefaults *udefaults = [NSUserDefaults standardUserDefaults];
            id result = [udefaults objectForKey:[NSString stringWithFormat:@"HXGroupList%@",message.conversationId]];
            UserInfo *userInfo = [[LoginVM getInstance]readLocal];
            if (!result) {
                NSDictionary *parameters = @{
                                             @"groupid":message.conversationId,
                                             @"access_token":userInfo.token
                                             };
                
                [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/Circle/updatemember"] parameters:parameters success:^(id json) {
                    if ([json[@"state"] isEqual:(0)]) return ;
                    
                    for (NSDictionary *dictT in json[@"data"]) {
                        
                        if ([dictT[@"uid"] isEqualToString:[self.message.from substringFromIndex:7]]) {
                            _avatarURLPath = [LocalDataRW getImageAllStr:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:dictT[@"avatar"]]];
                            _nickname = dictT[@"nickname"];
                        }
                        
//                        NSLog(@"gaolin???=%@",json);
//                        [self.dataSource addObject:dictT[@"nickname"]];
//                        [self.uids addObject:dictT[@"uid"]];
//                        [self.imgDataSource addObject:@{dictT[@"nickname"]:[AddHostToLoadPIC AddHostToLoadPICWithString:dictT[@"avatar"]]}];
                    }
                    
                    
                    [udefaults setObject:json[@"data"] forKey:[NSString stringWithFormat:@"HXGroupList%@",message.conversationId]];
                    
                } failure:^(NSError *error) {
                    
                }];
            }else {
                for (NSDictionary *dictT in result) {
                    
                    if ([dictT[@"uid"] isEqualToString:[self.message.from substringFromIndex:7]]) {
                        _avatarURLPath = [LocalDataRW getImageAllStr:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:dictT[@"avatar"]]];
                        _nickname = dictT[@"nickname"];
                    }
                }
                
                NSDictionary *parameters = @{
                                             @"groupid":message.conversationId,
                                             @"access_token":userInfo.token
                                             };
                
                [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/Circle/updatemember"] parameters:parameters success:^(id json) {
                    if ([json[@"state"] isEqual:(0)]) return ;
                    
                    [udefaults setObject:json[@"data"] forKey:[NSString stringWithFormat:@"HXGroupList%@",message.conversationId]];
                    
                } failure:^(NSError *error) {
                    
                }];
            }
            
            
//            HXFriendDataSource *profileEntity = [HXFriendDataSource new];
//            while ([result next]) { // next方法返回yes代表有数据可取
//                
//                profileEntity.uid = [result stringForColumn:@"uid"];
//                
//                if ([profileEntity.uid isEqualToString:[self.message.from substringFromIndex:7]]) {
//                    profileEntity.nickname = [result stringForColumn:@"nickname"];
//                    profileEntity.UserModel = [NSKeyedUnarchiver unarchiveObjectWithData:[result dataNoCopyForColumn:@"UserModel"]];
//                    if (profileEntity.UserModel.avatarURLPath) {
//                        //          model.avatarURLPath = profileEntity.imageUrl;
//                        //                model.nickname = profileEntity.nickname;
//                        _avatarURLPath = profileEntity.UserModel.avatarURLPath;
//                        _nickname = profileEntity.nickname;
//                    }
//                }
//            }
    }
  
}
    
//    _nickname = @"";
    
    return self;
}

- (NSString *)messageId
{
    return _message.messageId;
}

- (EMMessageStatus)messageStatus
{
    return _message.status;
}

- (EMChatType)messageType
{
    return _message.chatType;
}

- (EMMessageBodyType)bodyType
{
    return self.firstMessageBody.type;
}

- (BOOL)isMessageRead
{
    return _message.isReadAcked;
}

- (NSString *)fileLocalPath
{
    if (_firstMessageBody) {
        switch (_firstMessageBody.type) {
            case EMMessageBodyTypeVideo:
            case EMMessageBodyTypeImage:
            case EMMessageBodyTypeVoice:
            case EMMessageBodyTypeFile:
            {
                EMFileMessageBody *fileBody = (EMFileMessageBody *)_firstMessageBody;
                return fileBody.localPath;
            }
                break;
            default:
                break;
        }
    }
    return nil;
}

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
