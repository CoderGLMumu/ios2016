//
//  WDFansCell.m
//  JZBRelease
//
//  Created by zjapple on 16/10/17.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "WDFansCell.h"
#import "InfoShowView.h"

#import "BCH_Alert.h"

#import "UserInfoListItemView.h"
#import "Masonry.h"

@interface WDFansCell ()

//@property (nonatomic, weak) InfoShowView *infoView;

/** leftView */
@property (nonatomic, strong) UserInfoListItemView *leftView;

/** rightBtn */
@property (nonatomic, weak) UIButton *rightBtn;

@end

@implementation WDFansCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupSubView];
        
//        InfoShowView *infoView = [InfoShowView getInfoShowViewWithData:nil WithFrame:CGRectMake(0, 0, self.glw_width, self.glh_height)];
//        self.infoView = infoView;
//        
//        [self addSubview:infoView];
        
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchResultTableView"];
    if (self) {
        
        [self setupSubView];
        
//        InfoShowView *infoView = [InfoShowView getInfoShowViewWithData:nil WithFrame:CGRectMake(0, 0, self.glw_width, self.glh_height)];
//        self.infoView = infoView;
//        
//        [self addSubview:infoView];
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupSubView];
    
//    InfoShowView *infoView = [InfoShowView getInfoShowViewWithData:nil WithFrame:CGRectMake(0, 0, self.glw_width, self.glh_height)];
//    self.infoView = infoView;
//
//    [self addSubview:infoView];
    
}

- (void)setupSubView
{
    self.autoresizesSubviews = NO;
    
    UserInfoListItemView *leftView = [UserInfoListItemView new];
    self.leftView = leftView;
    //    leftView.backgroundColor = [UIColor redColor];
    [self addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.top.equalTo(self);
        make.height.equalTo(self);
        make.width.equalTo(@(self.glw_width * 7/10));
    }];
    
}

- (void)updateSubViewConstraints
{
    [self.leftView updateSubViewConstraints];
}

-(void)setIsReferrer:(BOOL)isReferrer
{
//    if (self.isinitButton) {
//        return ;
//    }
    
    [self.rightBtn removeFromSuperview];
    
    self.isinitButton = YES;
    
    UIButton *tipButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn = tipButton1;
    
    tipButton1.layer.cornerRadius = 5;
    tipButton1.layer.borderWidth = 1;
    tipButton1.layer.borderColor = [UIColor hx_colorWithHexRGBAString:@"757575"].CGColor;
    tipButton1.clipsToBounds = YES;
    
    [tipButton1 setTitle:@"审核" forState:UIControlStateNormal];
    
    [self addSubview:tipButton1];
    
    tipButton1.frame = CGRectMake(GLScreenW - 66, 64/2 - 22/2, 48, 22);

    [tipButton1 setFont:[UIFont systemFontOfSize:14]];
    
    [tipButton1 setTitleColor:[UIColor hx_colorWithHexRGBAString:@"757575"] forState:UIControlStateNormal];
    
//    tipButton1.userInteractionEnabled = NO;
//    @"通过",@"拒绝",@"返回"
    if ([self.model.status isEqualToString:@"0"]) {
        [tipButton1 setTitle:@"审核" forState:UIControlStateNormal];
        
        [tipButton1 setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"2196f3"]];
        [tipButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }else if ([self.model.status isEqualToString:@"1"]) {
        [tipButton1 setTitle:@"已通过" forState:UIControlStateNormal];
        tipButton1.layer.borderWidth = 0;
    }else if ([self.model.status isEqualToString:@"2"]) {
        [tipButton1 setTitle:@"已拒绝" forState:UIControlStateNormal];
        tipButton1.layer.borderWidth = 0;
    }
    
    [tipButton1 addTarget:self action:@selector(tipButton1Active:) forControlEvents:UIControlEventTouchUpInside];
    
    [tipButton1 sizeToFit];
    tipButton1.glw_width = 48;
    
}

- (void)tipButton1Active:(UIButton *)btn
{
    if (![self.model.status isEqualToString:@"0"]) {
        return ;
    }
    
    [UIView bch_showWithTitle:[NSString stringWithFormat:@"确认用户“%@”,完成注册建众帮",self.model.user.nickname] message:@"是否通过注册" buttonTitles:@[@"通过",@"拒绝",@"返回"] callback:^(id sender, NSUInteger buttonIndex) {
        if (buttonIndex == 0) {
            
            HttpBaseRequestItem *item = [HttpBaseRequestItem new];
            item.access_token = [[LoginVM getInstance]readLocal].token;
            item.user_id = self.model.uid;
            item.status = @"1";
            NSDictionary *parameters = item.mj_keyValues;
            
            [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/User/setSaleStatus"] parameters:parameters success:^(id json) {
                
                jsonBaseItem *item = [jsonBaseItem mj_objectWithKeyValues:json];
                
                [SVProgressHUD showInfoWithStatus:item.info];
                
                // 刷新界面
                
//                [self loadData];
                
                if (self.callActiveBtn) {
                    [self.rightBtn removeFromSuperview];
                    self.isinitButton = NO;
                    self.callActiveBtn();
                }
                
            } failure:^(NSError *error) {
                
            }];
            
        }else if (buttonIndex == 1){
            
            HttpBaseRequestItem *item = [HttpBaseRequestItem new];
            item.access_token = [[LoginVM getInstance]readLocal].token;
            item.user_id = self.model.uid;
            item.status = @"2";
            NSDictionary *parameters = item.mj_keyValues;
            
            [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/User/setSaleStatus"] parameters:parameters success:^(id json) {
                
                jsonBaseItem *item = [jsonBaseItem mj_objectWithKeyValues:json];
                
                [SVProgressHUD showInfoWithStatus:item.info];
                
//                [self loadData];
                // 刷新界面
                if (self.callActiveBtn) {
                    [self.rightBtn removeFromSuperview];
                    self.isinitButton = NO;
                    self.callActiveBtn();
                }
                
            } failure:^(NSError *error) {
                
            }];
            
            
        }
        
    }];

}

- (void)setItem:(Users *)item
{
    _item = item;
    
    self.leftView.user = item;
    
//    [self.infoView updateFrameWithData:item];
    
//    self.infoView.botView.hidden = YES;
}

- (void)setModel:(MySaleList *)model
{
    _model = model;
    
    self.leftView.user = model.user;
    
//    [self.infoView updateFrameWithData:model.user];
//    
//    self.infoView.botView.hidden = YES;
}

@end
