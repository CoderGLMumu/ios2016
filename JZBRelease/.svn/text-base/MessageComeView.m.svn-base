//
//  MessageComeView.m
//  JZBRelease
//
//  Created by zjapple on 16/6/29.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "MessageComeView.h"
#import "ValuesFromXML.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"
#import "ZJBHelp.h"
@implementation MessageComeView{
    UIImageView *imageView;
    UILabel *label;
}

-(instancetype)initWithModel:(MessageComeModel *) model WithFrame:(CGRect) frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Inteval_Color" WithKind:XMLTypeColors]]];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((self.frame.size.width - self.frame.size.width * 2 / 5) / 2, (self.frame.size.height - 35) / 2, self.frame.size.width * 2 / 5, 35)];
        [self addSubview:btn];
        [btn setBackgroundColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]]];
        btn.layer.cornerRadius = 3.0;
        [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
        //[btn setImage:[[ZJBHelp getInstance]buttonImageFromColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]] WithFrame:CGRectMake(0, 0, btn.frame.size.width, btn.frame.size.height)] forState:UIControlStateNormal];
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width - self.frame.size.width * 2 / 5) / 2 + 2, (self.frame.size.height - 26) / 2, 26, 26)];
        imageView.layer.cornerRadius = 3.0;
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"bq_detail_smile"]];
        [self addSubview:imageView];
        
        label = [[UILabel alloc]initWithFrame:CGRectMake((btn.frame.size.width - self.frame.size.width / 3 / 3 * 2) / 2, 0, self.frame.size.width / 3 / 3 * 2, btn.frame.size.height)];
        label.font = [UIFont systemFontOfSize:model.fontSize / 1.2];
        label.textAlignment = NSTextAlignmentCenter;
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor whiteColor]];
        [label setText:[NSString stringWithFormat:@"%@条新消息",model.messageCount]];
        [btn addSubview:label];
        
        UIImageView *rowImageView = [[UIImageView alloc]init];
        [self addSubview:rowImageView];
        [rowImageView setImage:[UIImage imageNamed:@"bq_sy_white_right"]];
        [rowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(9, 16));
            make.centerY.equalTo(self);
            make.left.equalTo(self).with.offset(btn.frame.origin.x + btn.frame.size.width - 2 * model.inteval);
        }];
    }
    return self;
}

-(void)initWithModel:(MessageComeModel *) model{
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"f_static_023"]];
    [label setText:[NSString stringWithFormat:@"%@条新消息",model.messageCount]];
}

-(void)btnAction{
    if (self.returnAction) {
        self.returnAction(Clink_Type_One);
    }
}

+(MessageComeView *)initWithModel:(MessageComeModel *) model WithFrame:(CGRect) frame{
    return [[MessageComeView alloc]initWithModel:model WithFrame:frame];
}

@end
