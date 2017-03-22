//
//  CusGroupBtnView.m
//  JZBRelease
//
//  Created by cl z on 16/9/20.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "CusGroupBtnView.h"
#import "ThemeListModel.h"
#import "Defaults.h"
@implementation CusGroupBtnView

- (instancetype)initWithSeleterConditionTitleArr:(NSArray *)titleArr WithImageAry:(NSArray *)imageAry WithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        int width = frame.size.width / titleArr.count;
        dispatch_queue_t queue = dispatch_queue_create("queue_content", nil);
        for (int i = 0; i < titleArr.count; i ++) {
            ThemeListModel *model = [titleArr objectAtIndex:i];
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i * width, 0, width, frame.size.height)];
            [self addSubview:btn];
            btn.tag = i;
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((width - 34) / 2, 19, 34, 34)];
            
            NSString *path = [[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:model.thumb];
            dispatch_async(queue, ^{
                UIImage *image = [LocalDataRW getImageWithDirectory:Directory_XB RetalivePath:path];
                __block typeof (image) wimage = image;
                dispatch_async(dispatch_get_main_queue(), ^{
                    wimage = [ZJBHelp handleImage:wimage withSize:imageView.frame.size withFromStudy:YES];
                    [imageView setImage:wimage];
                });
            });
            
            [btn addSubview:imageView];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.frame.origin.y + imageView.frame.size.height + 3, width, 21)];
            [label setText:model.name];
            label.textAlignment = NSTextAlignmentCenter;
            [label setTextColor:[UIColor hx_colorWithHexRGBAString:@"212121"]];
            [label setFont:[UIFont systemFontOfSize:12]];
            [btn addSubview:label];
        }
    }
    return self;
}

- (void)btnAction:(UIButton *)btn{
    if (self.returnAction) {
        self.returnAction(btn.tag);
    }
}

@end
