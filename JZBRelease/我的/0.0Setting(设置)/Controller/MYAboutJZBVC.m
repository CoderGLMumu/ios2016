//
//  MYAboutJZBVC.m
//  JZBRelease
//
//  Created by cl z on 16/10/26.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "MYAboutJZBVC.h"

@interface MYAboutJZBVC ()
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (strong, nonatomic) UILabel *versionDesLabel;

@end

@implementation MYAboutJZBVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
   
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.versionLabel.text = [NSString stringWithFormat:@"建众帮 %@",app_Version];
    [self.versionLabel setTextColor:[UIColor grayColor]];
    NSString *versionContentStr = @"        建众帮是家居建材行业首个在线教育平台，主要是提供在线学习培训、问题解决、知识共享、资源整合。入驻平台的用户可以是家居建材行业的厂商各层级管理人员、经销商、门店营销人员等。";
    
    self.versionDesLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 280, GLScreenW - 20, 100)];
    [self.versionDesLabel setTextColor:[UIColor lightGrayColor]];
    self.versionDesLabel.text = versionContentStr;
    self.versionDesLabel.numberOfLines = 0;
    [self.versionDesLabel setFont:[UIFont systemFontOfSize:15]];
    self.versionDesLabel.lineBreakMode = NSLineBreakByWordWrapping;
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:versionContentStr];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:5];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [versionContentStr length])];
    [self.versionDesLabel setAttributedText:attributedString1];
    CGSize size = [self.versionDesLabel sizeThatFits:CGSizeMake(GLScreenW - 40, MAXFLOAT)];
    [self.versionDesLabel setFrame:CGRectMake(20, 280, GLScreenW - 40, size.height)];
    [self.view addSubview:self.versionDesLabel];
}


@end
