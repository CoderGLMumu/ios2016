//
//  SelecterToolsScrolView.m
//  SelecterTools
//
//  Created by zhao on 16/3/15.
//  Copyright © 2016年 xincheng. All rights reserved.
//

#import "SelecterToolsScrolView.h"
#import "Defaults.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

#define TitleFont 14


@interface SelecterToolsScrolView(){
    BOOL hit;
}

@property(nonatomic,copy)BtnClick btnClick;


@property(nonatomic,retain)NSMutableArray *btnArr;
@property(nonatomic,retain)UIButton * previousBtn;
@property(nonatomic,retain)UIButton * currentBtn;


@property(nonatomic,retain)UIView *bottomScrLine;
@end

@implementation SelecterToolsScrolView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithSeleterConditionTitleArr:(NSArray *)titleArr andBtnBlock:(BtnClick)btnClick WithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        _btnArr = [NSMutableArray array];
        NSInteger btnWidth = 0;
        for (int i = 0; i<titleArr.count; i++) {
            CGRect rect = CGRectMake(i*WIDTH/titleArr.count,0, WIDTH/titleArr.count,40);
            UIButton *titleBtn = [[UIButton alloc]initWithFrame:rect];
            titleBtn.tag = i;
            [titleBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [titleBtn setTitle:titleArr[i] forState:UIControlStateNormal];
            titleBtn.titleLabel.font = [UIFont systemFontOfSize:TitleFont];
            [titleBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"717171"] forState:UIControlStateNormal];
            [titleBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"626262"] forState:UIControlStateSelected];
            [self addSubview:titleBtn];
            [_btnArr addObject:titleBtn];
            if (i == 0) {
                titleBtn.titleLabel.font = [UIFont systemFontOfSize:TitleFont + 2];
                _previousBtn = titleBtn;
                _currentBtn = titleBtn;
                titleBtn.selected = YES;
                NSDictionary *btnAttrs = @{NSFontAttributeName:titleBtn.titleLabel.font};
                btnWidth = [titleBtn.titleLabel.text sizeWithAttributes:btnAttrs].width;
            }
            
        }
        
        
        _bottomScrLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-3,btnWidth,3)];
        _bottomScrLine.center = CGPointMake(_currentBtn.center.x, _bottomScrLine.center.y);
        _bottomScrLine.backgroundColor = [ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]];
        [self addSubview:_bottomScrLine];
        
        UIView *intevalLabel1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
        [intevalLabel1 setBackgroundColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"DIVISION_LINE" WithKind:XMLTypeColors]]];
        [self addSubview:intevalLabel1];
        
        
        self.btnClick = btnClick;
        
    }
    return self;
}


-(void)updateSelecterToolsIndex:(NSInteger )index
{
    UIButton *selectBtn = _btnArr[index];
    [self changeSelectBtn:selectBtn];
}

-(void)btnClick:(UIButton *)sender
{
    if (sender == _previousBtn) {
        return;
    }
    hit = YES;
    [self changeSelectBtn:sender];
    
}

-(void)changeSelectBtn:(UIButton *)btn
{
    if (btn == _previousBtn) {
        return;
    }
    _previousBtn = _currentBtn;
    _currentBtn = btn;
    _previousBtn.selected = NO;
    _currentBtn.selected = YES;
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _bottomScrLine.center = CGPointMake(_currentBtn.center.x, _bottomScrLine.center.y);
        [btn.titleLabel setFont:[UIFont systemFontOfSize:TitleFont + 2]];
        [_previousBtn.titleLabel setFont:[UIFont systemFontOfSize:TitleFont]];
        _previousBtn = _currentBtn = btn;
        if (self.tag == 1) {
            self.tag = 0;
        }else{
            self.btnClick(btn,hit);
        }
    } completion:^(BOOL finished) {
        hit = NO;
    }];
    
    
//    if (_currentBtn.center.x<WIDTH/2) {
//        
//        [self setContentOffset:CGPointMake(0, 0) animated:YES];
//    }else if (_currentBtn.center.x>self.contentSize.width-WIDTH/2)
//    {
//        [self setContentOffset:CGPointMake(self.contentSize.width-WIDTH, 0) animated:YES];
//
//    }else
//    {
//        [self setContentOffset:CGPointMake(btn.center.x-WIDTH/2, 0) animated:YES];
//    }
    
}

//
//-(CGFloat)getTitleContentWidth:(NSString *)title
//{
//   CGRect rect = [title boundingRectWithSize:CGSizeMake(WIDTH, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:TitleFont]} context:nil];
//    return rect.size.width;
//}



@end
