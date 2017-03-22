//
//  AttentionCell.m
//  JZBRelease
//
//  Created by zjapple on 16/10/17.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "AttentionCell.h"
#import "InfoShowView.h"
#import "UserInfoListItemView.h"
#import "Masonry.h"

@interface AttentionCell ()

//@property (nonatomic, weak) InfoShowView *infoView;

@property (nonatomic, weak) UIButton *btn;

/** leftView */
@property (nonatomic, strong) UserInfoListItemView *leftView;

@end

@implementation AttentionCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupSubView];
        
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchResultTableView"];
    if (self) {
        
        [self setupSubView];
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupSubView];
    
}

- (void)updateSubViewConstraints
{
    [self.leftView updateSubViewConstraints];
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
    
//    InfoShowView *infoView = [InfoShowView getInfoShowViewWithData:nil WithFrame:CGRectMake(0, 0, self.glw_width, self.glh_height)];
//    self.infoView = infoView;
//    
//    [self addSubview:infoView];
    
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(GLScreenW - 63 - 20 , (33 / 2), 63, 33);
//    NSLog(@"btnbtn-%@",btn);
    self.btn = btn;
    [self addSubview:btn];
    
//    btn.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"fc504e"];
    btn.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"2196f3"];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn setFont:[UIFont systemFontOfSize:13]];
    btn.layer.cornerRadius = 5;
    btn.clipsToBounds = YES;
    btn.layer.borderColor = [UIColor hx_colorWithHexRGBAString:@"757575"].CGColor;
    btn.layer.borderWidth = 1;
    
    btn.selected = YES;
    
    [btn setTitle:@"取消关注" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [self.btn setBackgroundImage:[UIImage imageNamed:@"WDZY_JHY"] forState:UIControlStateNormal];
    
}

- (void)setItem:(Users *)item
{
    if (self.isMyAttent) {
        self.btn.hidden = YES ;
    }
    
    _item = item;
    
//    [self.infoView updateFrameWithData:item];
//    
//    self.infoView.botView.hidden = YES;
    self.leftView.user = item;
}

- (void)clickBtn:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        
        [self addFans];
    }else {
        
        [self delFans];
    }
    
}

-(void)addFans{
    
//    NSDictionary *parameters = @{
//                                 @"access_token":[LoginVM getInstance].readLocal.token,
//                                 @"user_id":self.item.uid
//                                 };
    
      HttpBaseRequestItem *item = [HttpBaseRequestItem new];
      item.access_token = [[LoginVM getInstance]readLocal].token;
      item.user_id = self.item.uid;
      NSDictionary *parameters = item.mj_keyValues;
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/Fans/add"] parameters:parameters success:^(id json) {
    
    if ([json[@"state"] isEqual:@(0)]) {
//        [SVProgressHUD show];
    }
    
        [SVProgressHUD showSuccessWithStatus:@"成功关注"];
        [self.btn setTitle:@"取消关注" forState:UIControlStateNormal];
        [self.btn setBackgroundImage:[UIImage imageNamed:@"WDZY_SX"] forState:UIControlStateNormal];
//        [self.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        GLLog(@"TTT--json%@",json);
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)delFans{
    
    HttpBaseRequestItem *item = [HttpBaseRequestItem new];
    item.access_token = [[LoginVM getInstance]readLocal].token;
    item.user_id = self.item.uid;
    NSDictionary *parameters = item.mj_keyValues;
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/Fans/del"] parameters:parameters success:^(id json) {
        
        publicBaseJsonItem *item = [publicBaseJsonItem mj_objectWithKeyValues:json];
        
        if ([json[@"state"] isEqual:@(0)]) {
            [SVProgressHUD showInfoWithStatus:item.info];
        }
        
        [SVProgressHUD showSuccessWithStatus:@"取消关注"];
        [self.btn setTitle:@"关注" forState:UIControlStateNormal];
        [self.btn setBackgroundImage:[UIImage imageNamed:@"WDZY_JHY"] forState:UIControlStateNormal];
//        [self.btn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"212121"] forState:UIControlStateNormal];
        
        
        GLLog(@"TTT--json%@",json);
    } failure:^(NSError *error) {
        
    }];

    
}

@end
