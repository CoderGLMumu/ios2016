//
//  ApplyFriendCell.m
//  JZBRelease
//
//  Created by zjapple on 16/8/6.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "HXApplyFriendCell.h"
#import "UIImage+GLImage.h"
#import "SendAndGetDataFromNet.h"

@interface HXApplyFriendCell ()
@property (weak, nonatomic) IBOutlet UILabel *TongyiLabel;
@property (weak, nonatomic) IBOutlet UIButton *TongyiButton;
@property (weak, nonatomic) IBOutlet UIImageView *touxiangImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

/** userInfo */
@property (nonatomic, strong) UserInfo *userInfo;

/** FMDBTool */
@property (nonatomic, strong) GLFMDBToolSDK *FMDBTool;

@end

@implementation HXApplyFriendCell

- (GLFMDBToolSDK *)FMDBTool
{
    if (_FMDBTool == nil) {
        _FMDBTool = [GLFMDBToolSDK shareToolsWithCreateDDL:nil];
    }
    return _FMDBTool;
}

- (UserInfo *)userInfo
{
    if (_userInfo == nil) {
        _userInfo = [[UserInfo alloc] init];
    }
    return _userInfo;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)setup
{
    self.TongyiLabel.hidden = YES;
    
    self.touxiangImageView.layer.cornerRadius = self.touxiangImageView.glh_height * 0.5;
    self.touxiangImageView.clipsToBounds = YES;
    
    self.TongyiButton.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"2196f3"];
    
    [self.TongyiButton sizeToFit];
    self.TongyiButton.layer.cornerRadius = 6;
    self.TongyiButton.clipsToBounds = YES;
    self.TongyiButton.layer.borderColor = [UIColor hx_colorWithHexRGBAString:@"757575"].CGColor;
    self.TongyiButton.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(HXApplyFriendItem *)model
{
    _model = model;
    
//    @property (weak, nonatomic) IBOutlet UILabel *TongyiLabel;
//    @property (weak, nonatomic) IBOutlet UIButton *TongyiButton;
//    @property (weak, nonatomic) IBOutlet UIImageView *touxiangImageView;
//    @property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
    
//    [self.avaIcon sd_setImageWithURL:[NSURL URLWithString:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:item.user.avatar]] placeholderImage:[UIImage imageNamed:@"ZCCG_TX"]];
    
    [self.touxiangImageView sd_setImageWithURL:[NSURL URLWithString:[LocalDataRW getImageAllStr:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:model.recode_u_avatar]]] placeholderImage:[UIImage imageNamed:@"ZCCG_TX"] completed:^(UIImage *image, NSError *error, EMSDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    self.userNameLabel.text = model.recode_u_nickname;
    
//    if (model.isConfirm) {
//        self.TongyiButton.hidden = YES;
//        self.TongyiLabel.hidden = NO;
//    }else {
//        self.TongyiButton.hidden = NO;
//        self.TongyiLabel.hidden = YES;
//    }
    
        if ([model.type isEqualToString:@"2"]) {
            self.TongyiButton.hidden = YES;
            self.TongyiLabel.hidden = NO;
        }else {
            self.TongyiButton.hidden = NO;
            self.TongyiLabel.hidden = YES;
            
        }
}
- (IBAction)TongYiButtonClick:(UIButton *)sender {
    
    [self AddFriend:self.model];
}

- (void)AddFriend:(HXApplyFriendItem *)model
{
    //        添加好友
    //        接口：/Web/Friend/add
    //        参数:access_token,to_uid
    //        返回：
    //                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //                NSString *access_token = [defaults stringForKey:@"access_token"];
    
    self.userInfo = [[LoginVM getInstance]readLocal];
    if (model.recode_uid){
        NSDictionary *parameters = @{
                                     @"to_uid":model.recode_uid ,
                                     @"access_token":self.userInfo.token
                                     };
        
        [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/Friend/add"] parameters:parameters success:^(id json) {
            
            //        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:json options:kNilOptions error:nil];
            
            if ([json[@"state"] isEqual:@(0)]) {
//                [self hideHud];
//                [self showHint:NSLocalizedString(@"acceptFail", @"accept failure")];
                if ([json[@"info"] isEqualToString:@"已邀请"]) {
                    self.TongyiButton.hidden = YES;
                    self.TongyiLabel.hidden = NO;
                    [SVProgressHUD showSuccessWithStatus:@"添加好友成功"];
                    // 改数据库
//                    NSString *update_sql = [NSString stringWithFormat:@"update t_HXapplyFriendItems set isConfirm = '%d' where recode_uid = '%@';",1,model.recode_uid];
                    NSString *update_sql = [NSString stringWithFormat:@"update t_HXapplyFriendItems set type = '%@' where recode_uid = '%@';",@"2",model.recode_uid];
                    
                    [self.FMDBTool updateWithSql:update_sql];

                }
                return ;
            }
            
//            error = [[EMClient sharedClient].contactManager acceptInvitationForUsername:[NSString stringWithFormat:@"member_%@",model.recode_uid]];
            [SVProgressHUD showSuccessWithStatus:@"添加好友成功"];
            self.TongyiButton.hidden = YES;
            self.TongyiLabel.hidden = NO;
            
            // 改数据库
//            NSString *update_sql = [NSString stringWithFormat:@"update t_HXapplyFriendItems set isConfirm = '%d' where recode_uid = '%@';",1,model.recode_uid];
            NSString *update_sql = [NSString stringWithFormat:@"update t_HXapplyFriendItems set type = '%@' where recode_uid = '%@';",@"2",model.recode_uid];

            [self.FMDBTool updateWithSql:update_sql];

            
//            [self hideHud];
        } failure:^(NSError *err) {
//            [self showHint:NSLocalizedString(@"acceptFail", @"accept failure")];
//            [self hideHud];
        }];
    }
}

@end
