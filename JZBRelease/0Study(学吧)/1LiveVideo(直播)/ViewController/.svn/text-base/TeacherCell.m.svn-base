//
//  TeacherCell.m
//  JZBRelease
//
//  Created by cl z on 16/10/12.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "TeacherCell.h"
#import "XBTeacherVC.h"
#import "TeacherModel.h"
#import "Defaults.h"
@implementation TeacherCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTeacherModel:(TeacherModel *)teacherModel{
    if (!self.titleView) {
        self.titleView = [XBTitleView initTypeStr:teacherModel.title WithFrame:CGRectMake(0, 0, GLScreenW, 40)];
         [self.titleView.btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.titleView];
    }
    [self.titleView updateTypeWithModel:teacherModel];
}

- (void) btnAction:(UIButton *)btn{
    XBTeacherVC *teacherListVC = [[XBTeacherVC alloc]init];
    TeacherModel *model = (TeacherModel *)self.titleView.model;
    teacherListVC.tag = model.tag;
    [[ZJBHelp getInstance].studyBaRootVC.navigationController pushViewController:teacherListVC animated:YES];
}

@end
