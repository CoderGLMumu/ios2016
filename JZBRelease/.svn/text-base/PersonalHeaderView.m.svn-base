//
//  PersonalHeaderView.m
//  JZBRelease
//
//  Created by zjapple on 16/6/11.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "PersonalHeaderView.h"
#import "Masonry.h"
#import "Defaults.h"
@interface PersonalHeaderView ()

/** isMyRootVC */
@property (nonatomic, assign) BOOL isMyRootVC;

@end

@implementation PersonalHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backImageView = [UIImageView createImageViewWithFrame:self.frame ImageName:@"grzx_head_img"];
        self.userInteractionEnabled = YES;
        
        
        if (frame.size.height == 293) {
            self.isMyRootVC = YES;
        }
        /** 点击背景图片的事件 */
        self.backImageView.tag = 98;
        [self addSubview:self.backImageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackAction:)];
        [self.backImageView addGestureRecognizer:tap];
        
        [self addSubview:self.backImageView];
    }
    return self;
}

-(void) initWithData : (Users *) model{
    
    UIView *zjBackground = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 49)];
    zjBackground.backgroundColor = [ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Personal_ZJ_Color" WithKind:XMLTypeColors]];
    zjBackground.alpha = 0.3;
    zjBackground.tag = 6;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [zjBackground addGestureRecognizer:tap];
    [self addSubview:zjBackground];
    
    UIView *xmBackground = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 49, self.frame.size.width, 49)];
    xmBackground.backgroundColor = [ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Personal_XM_Color" WithKind:XMLTypeColors]];
    
    
    xmBackground.alpha = 0.3;
    [self addSubview:xmBackground];
    
    UIView *xmView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 49, self.frame.size.width, 49)];
    [self addSubview:xmView];
    [xmView setBackgroundColor:[UIColor clearColor]];
    
    self.sourceBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width / 4, 49)];
    [xmView addSubview:self.sourceBtn];
    self.sourceBtn.tag = 2;
    [self.sourceBtn addTarget:self action:@selector(btnsActionSender:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *sourceName = [[UILabel alloc]initWithFrame:CGRectMake(0, 4, self.sourceBtn.frame.size.width, 20)];
    [sourceName setText:@"帮币"];
    [sourceName setFont:[UIFont systemFontOfSize:15]];
    [sourceName setTextColor:[UIColor whiteColor]];
    [sourceName setTextAlignment:NSTextAlignmentCenter];
    [self.sourceBtn addSubview:sourceName];
    UILabel *sourceValue = [[UILabel alloc]initWithFrame:CGRectMake(0, 4 + 21, self.sourceBtn.frame.size.width, 20)];
    if (model.score) {
        [sourceValue setText:model.score];
    }else{
        [sourceValue setText:@"0"];
    }
    [sourceValue setFont:[UIFont systemFontOfSize:15]];
    [sourceValue setTextColor:[UIColor whiteColor]];
    [sourceValue setTextAlignment:NSTextAlignmentCenter];
    [self.sourceBtn addSubview:sourceValue];
    
    self.fansBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width / 4, 0, self.frame.size.width / 4, 49)];
    [xmView addSubview:self.fansBtn];
    self.fansBtn.tag = 3;
    [self.fansBtn addTarget:self action:@selector(btnsActionSender:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *fansName = [[UILabel alloc]initWithFrame:CGRectMake(0, 4, self.fansBtn.frame.size.width, 20)];
    [fansName setText:@"粉丝"];
    [fansName setFont:[UIFont systemFontOfSize:15]];
    [fansName setTextColor:[UIColor whiteColor]];
    [fansName setTextAlignment:NSTextAlignmentCenter];
    [self.fansBtn addSubview:fansName];
    self.fansValue = [[UILabel alloc]initWithFrame:CGRectMake(0, 4 + 21, self.fansBtn.frame.size.width, 20)];
    if (model.fans_count) {
        [self.fansValue setText:model.fans_count];
    }else{
        [self.fansValue setText:@"0"];
    }
    [self.fansValue setFont:[UIFont systemFontOfSize:15]];
    [self.fansValue setTextColor:[UIColor whiteColor]];
    [self.fansValue setTextAlignment:NSTextAlignmentCenter];
    [self.fansBtn addSubview:self.fansValue];
    
    self.broswerBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width / 2, 0, self.frame.size.width / 4, 49)];
    [xmView addSubview:self.broswerBtn];
    self.broswerBtn.tag = 4;
    [self.broswerBtn addTarget:self action:@selector(btnsActionSender:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *broswerName = [[UILabel alloc]initWithFrame:CGRectMake(0, 4, self.fansBtn.frame.size.width, 20)];
    [broswerName setText:@"浏览"];
    [broswerName setFont:[UIFont systemFontOfSize:15]];
    [broswerName setTextColor:[UIColor whiteColor]];
    [broswerName setTextAlignment:NSTextAlignmentCenter];
    [self.broswerBtn addSubview:broswerName];
    UILabel *broswerValue = [[UILabel alloc]initWithFrame:CGRectMake(0, 4 + 21, self.broswerBtn.frame.size.width, 20)];
    
    [broswerValue setText:model.show_count];
    [broswerValue setFont:[UIFont systemFontOfSize:15]];
    [broswerValue setTextColor:[UIColor whiteColor]];
    [broswerValue setTextAlignment:NSTextAlignmentCenter];
    [self.broswerBtn addSubview:broswerValue];
    
    self.signBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width / 4 * 3, 0, self.frame.size.width / 4, 49)];
    [xmView addSubview:self.signBtn];
    self.signBtn.tag = 5;
    [self.signBtn addTarget:self action:@selector(btnsActionSender:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *signName = [[UILabel alloc]initWithFrame:CGRectMake(0, 4, self.signBtn.frame.size.width, 20)];
    [signName setText:@"签到"];
    [signName setFont:[UIFont systemFontOfSize:15]];
    [signName setTextColor:[UIColor whiteColor]];
    [signName setTextAlignment:NSTextAlignmentCenter];
    [self.signBtn addSubview:signName];
    UILabel *signValue = [[UILabel alloc]initWithFrame:CGRectMake(0, 4 + 21, self.signBtn.frame.size.width, 20)];
    [signValue setText:@"122"];
    [signValue setFont:[UIFont systemFontOfSize:15]];
    [signValue setTextColor:[UIColor whiteColor]];
    [signValue setTextAlignment:NSTextAlignmentCenter];
    [self.signBtn addSubview:signValue];
    
    
    self.locationBtn = [[UIButton alloc]init];
    [self addSubview:self.locationBtn];
    [self.locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 30));
        make.leftMargin.equalTo(self).offset(18);
        make.topMargin.equalTo(self).offset(12 + 64);
    }];
    UIImageView *locationImageView = [UIImageView createImageViewWithFrame:CGRectMake(0, 5, 12, 18) ImageName:@"bq_grzx_location"];
    [self.locationBtn addSubview:locationImageView];
    UILabel *addressLabel = [UILabel createLabelWithFrame:CGRectMake(20, 5, 120, 20) Font:13 Text:@"广东广州" andLCR:0 andColor:[UIColor whiteColor]];
    if (model.address) {
//        NSString *province = [model.address.province stringByReplacingOccurrencesOfString:@"省" withString:@""];
//        NSString *city = [model.address.city stringByReplacingOccurrencesOfString:@"市" withString:@""];
//        if (province && city) {
//            [addressLabel setText:[province stringByAppendingString:city]];
//        }
    }
    self.locationLabel = addressLabel;
    //[self.locationBtn addTarget:self action:@selector(actionBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.locationBtn addSubview:addressLabel];
    
    if(!self.isMyRootVC){
        UIView *focusView = [[UIView alloc]init];
        [self addSubview:focusView];
        focusView.alpha = 0.6;
        focusView.layer.cornerRadius = 3.0;
        focusView.backgroundColor = [UIColor grayColor];
        focusView.frame = CGRectMake(self.frame.size.width - 65 - 18, 17 + 64, 65, 30);
        self.focusBtn = [[UIButton alloc]init];
        [self addSubview:self.focusBtn];
        self.focusBtn.tag = 0;
        self.focusBtn.frame = CGRectMake(self.frame.size.width - 65 - 18, 17 + 64, 65, 30);
        self.focusBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        if ([model.is_fllow integerValue] == 1) {
            [self.focusBtn setTitle:@"取消关注" forState:UIControlStateNormal];
        }else{
            [self.focusBtn setTitle:@"关注" forState:UIControlStateNormal];
        }
        [self.focusBtn addTarget:self action:@selector(btnsActionSender:) forControlEvents:UIControlEventTouchUpInside];
        [self.focusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        NSLog(@"%@",[[LoginVM getInstance] readLocal]._id);
        if ([model.uid isEqualToString:[[LoginVM getInstance] readLocal]._id]) {
            self.focusBtn.hidden = YES;
            focusView.hidden = YES;
        }
        
        
        UIView *addFriendView = [[UIView alloc]init];
        [self addSubview:addFriendView];
        addFriendView.alpha = 0.6;
        addFriendView.layer.cornerRadius = 3.0;
        addFriendView.backgroundColor = [UIColor grayColor];
        addFriendView.frame = CGRectMake(self.frame.size.width - 65 - 18, 24 + 64 + 30, 65, 30);
        self.addFriendBtn = [[UIButton alloc]init];
        self.addFriendBtn.tag = 1;
        [self addSubview:self.addFriendBtn];
        self.addFriendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        self.addFriendBtn.frame = CGRectMake(self.frame.size.width - 65 - 18, 24 + 64 + 30, 65, 30);
        if ([model.is_friend integerValue] == 1) {
            [self.addFriendBtn setTitle:@"交流" forState:UIControlStateNormal];
        }else{
            [self.addFriendBtn setTitle:@"加为好友" forState:UIControlStateNormal];
        }
        
        [self.addFriendBtn addTarget:self action:@selector(btnsActionSender:) forControlEvents:UIControlEventTouchUpInside];
        [self.addFriendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    
    /** 下面这是高林修改的代码... 为了适配 ‘我的’ 模块页面... 到时再看看其他页面的问题 */
    self.avatarImageView = [UIImageView createImageViewWithFrame:CGRectMake((self.frame.size.width - model.avatarWidth * 2) / 2, model.inteval + 64, model.avatarWidth * 2, model.avatarWidth * 2) ImageName:@"bq_grzy_img-head"];
//    if (self.isMyRootVC) {
//        self.avatarImageView = [UIImageView createImageViewWithFrame:CGRectMake((self.frame.size.width - model.avatarWidth * 2) / 2, 49 , 76, 76) ImageName:@"login_user"];
//    }else {
//        self.avatarImageView = [UIImageView createImageViewWithFrame:CGRectMake((self.frame.size.width - model.avatarWidth * 2) / 2, model.inteval + 64, model.avatarWidth * 2, model.avatarWidth * 2) ImageName:@"bq_grzy_img-head"];
//    }
    
    self.avatarImageView.backgroundColor = [UIColor whiteColor];
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width * 0.5;
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.tag = 99;
    UITapGestureRecognizer *tapIcon = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapIconAction:)];
    [self.avatarImageView addGestureRecognizer:tapIcon];
    self.avatarImageView.userInteractionEnabled = YES;
    //if (model.avatar) {
    
//    login_user 改成了 ZCCG_TX
    
//        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:model.avatar]] placeholderImage:[UIImage imageNamed:@"ZCCG_TX"]];
    
    [LocalDataRW getImageWithDirectory:Directory_BQ RetalivePath:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:model.avatar] WithContainerImageView:self.avatarImageView];
    
    
    //}
    /** 以上的修改了大小和添加点击功能 */
    [self addSubview:self.avatarImageView];
    
    UIView *nameAndGang = [[UIView alloc]initWithFrame:CGRectMake(0, self.avatarImageView.frame.origin.y + self.avatarImageView.frame.size.height + model.inteval, self.frame.size.width, 30)];
    [nameAndGang setBackgroundColor:[UIColor clearColor]];
    [self addSubview:nameAndGang];
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width / 2 - model.inteval / 2, 30)];
    [nameAndGang addSubview:self.nameLabel];
    [self.nameLabel setFont:[UIFont systemFontOfSize:model.fontSize + 2]];
    [self.nameLabel setText:model.nickname];
    [self.nameLabel setTextAlignment:NSTextAlignmentRight];
    [self.nameLabel setTextColor:[UIColor whiteColor]];
    self.nameLabel.text = model.nickname;
    
    self.gangLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width / 2 + model.inteval / 2, 0, self.frame.size.width / 2 - model.inteval, 30)];
    [nameAndGang addSubview:self.gangLabel];
    [self.gangLabel setFont:[UIFont systemFontOfSize:model.fontSize]];
    [self.gangLabel setText:model.gang];
    [self.gangLabel setTextAlignment:NSTextAlignmentLeft];
    [self.gangLabel setTextColor:[UIColor whiteColor]];
    if (model.gang) {
        self.gangLabel.text = model.gang;
    }else{
        self.gangLabel.text = @"建众帮";
    }
    
    self.companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, nameAndGang.frame.origin.y + nameAndGang.frame.size.height + model.inteval, self.frame.size.width, 30)];
    [self addSubview:self.companyLabel];
    [self.companyLabel setFont:[UIFont systemFontOfSize:model.fontSize]];
    [self.companyLabel setText:model.company];
    [self.companyLabel setTextAlignment :NSTextAlignmentCenter];
    [self.companyLabel setTextColor:[UIColor whiteColor]];
    if (model.company) {
         self.companyLabel.text = model.company;
    }else{
        self.companyLabel.text = @"阿狸养虾创意总裁";
    }
   
}

-(void)tapAction:(UIGestureRecognizer *)tap{
    if (self.btnAction) {
        self.btnAction(tap.view.tag);
    }
}

/** 点击下方按钮 */
-(void)btnsActionSender:(UIButton *)btn{
    if (self.btnAction) {
        self.btnAction(btn.tag);
    }
}

/** 点击背景图片的事件 */
-(void)tapBackAction:(UIGestureRecognizer *)tap{
    if (self.btnAction) {
        self.btnAction(tap.view.tag);
    }
}

/** 点击头像的事件 */
-(void)tapIconAction:(UIGestureRecognizer *)tap{
    if (self.btnAction) {
        self.btnAction(tap.view.tag);
    }
}


@end
