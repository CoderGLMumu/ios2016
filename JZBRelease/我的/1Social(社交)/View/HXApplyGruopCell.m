//
//  HXApplyGruopCell.m
//  JZBRelease
//
//  Created by zjapple on 16/8/8.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "HXApplyGruopCell.h"
#import "SendAndGetDataFromNet.h"

@interface HXApplyGruopCell ()

@property (weak, nonatomic) IBOutlet UILabel *TongyiLabel;
@property (weak, nonatomic) IBOutlet UIButton *TongyiButton;
@property (weak, nonatomic) IBOutlet UIImageView *touxiangImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

/** userInfo */
@property (nonatomic, strong) UserInfo *userInfo;

/** GruopisTongYi */
@property (nonatomic, assign) BOOL GruopisTongYi;

@end

@implementation HXApplyGruopCell

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
    
    self.GruopisTongYi = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setModel:(HXApplyGruopItem *)model
{
    _model = model;
    
    //    @property (weak, nonatomic) IBOutlet UILabel *TongyiLabel;
    //    @property (weak, nonatomic) IBOutlet UIButton *TongyiButton;
    //    @property (weak, nonatomic) IBOutlet UIImageView *touxiangImageView;
    //    @property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
    
    //  login_user 改成 ZCCG_TX **记得
    
//    [self.touxiangImageView sd_setImageWithURL:[NSURL URLWithString:[AddHostToLoadPIC AddHostToLoadPICWithString:model.recode_u_avatar]] placeholderImage:[UIImage imageNamed:@"login_user"] completed:^(UIImage *image, NSError *error, EMSDImageCacheType cacheType, NSURL *imageURL) {
//        
//    }];
    self.touxiangImageView.image = [UIImage imageNamed:@"grzx_contacts_qun"];
    
    EMGroup *group = [[EMClient sharedClient].groupManager fetchGroupInfo:model.groupId includeMembersList:NO error:nil];
    
    self.userInfo = [[LoginVM getInstance]readLocal];
    
    NSDictionary *parameters = @{
                                 @"groupid":model.groupId,
                                 @"access_token":self.userInfo.token
                                 };
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/Circle/updatemember"] parameters:parameters success:^(id json) {
        
        NSArray *arr = json[@"data"];
        if (![arr isKindOfClass:[NSNull class]]) {
            for (NSDictionary *dictT in arr) {
                
                if ([dictT[@"is_identity"] isEqualToString:@"1"]) {
                    ;
                    
                     [self.touxiangImageView sd_setImageWithURL:[NSURL URLWithString:[LocalDataRW getImageAllStr:dictT[@"avatar"]]] placeholderImage:[UIImage imageNamed:@"grzx_contacts_qun"]];
                     
//                    [LocalDataRW getImageWithDirectory:Directory_WD RetalivePath:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:dictT[@"avatar"]] WithContainerImageView:self.touxiangImageView];
                }
            }

        }
        
         self.userNameLabel.text = group.subject;
        
    } failure:^(NSError *error) {
        
    }];
    
    
//    [[EMClient sharedClient].groupManager asyncFetchGroupInfo:model.groupId includeMembersList:YES success:^(EMGroup *aGroup) {
//        /** 等改接口 */
//        self.userNameLabel.text = @"等改接口";
//        
//    } failure:^(EMError *aError) {
//        
//    }];
    
    NSUserDefaults *udefault = [NSUserDefaults standardUserDefaults];
    BOOL isTongYi =[udefault boolForKey:model.groupId];
    
    if (isTongYi) {
        self.GruopisTongYi = YES;
    }
    
    if (self.GruopisTongYi) {
        self.TongyiButton.hidden = YES;
        self.TongyiLabel.hidden = NO;
    }else {
        self.TongyiButton.hidden = NO;
        self.TongyiLabel.hidden = YES;
    }
}
- (IBAction)TongYiButtonClick:(UIButton *)sender {
    
    [self ChangeButton:self.model];
}

- (void)ChangeButton:(HXApplyGruopItem *)model
{
    EMError *error;
    
    [[EMClient sharedClient].groupManager acceptInvitationFromGroup:model.groupId inviter:model.applicantUsername error:&error];
    
    if (!error) {
        self.GruopisTongYi = YES;
        self.TongyiButton.hidden = YES;
        self.TongyiLabel.hidden = NO;
        NSUserDefaults *udefault = [NSUserDefaults standardUserDefaults];
        [udefault setBool:self.GruopisTongYi forKey:model.groupId];
        
    }
}

@end
