//
//  XBTeacherView.m
//  JZBRelease
//
//  Created by cl z on 16/10/13.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "XBTeacherView.h"
#import "Defaults.h"
@implementation XBTeacherView

- (instancetype)initWithTeacherArr:(NSArray *)teacherArr WithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        int width = frame.size.width / teacherArr.count;
        dispatch_queue_t queue = dispatch_queue_create("queue_content", nil);
        for (int i = 0; i < teacherArr.count; i ++) {
            Users *user = [Users mj_objectWithKeyValues: [teacherArr objectAtIndex:i]];
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i * width, 0, width, frame.size.height)];
            [self addSubview:btn];
            btn.tag = i;
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((width - 60) / 2, 19, 60, 60)];
            imageView.layer.cornerRadius = 30;
            imageView.clipsToBounds = YES;
            NSString *path = [[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:user.avatar];
            dispatch_async(queue, ^{
                UIImage *image = [LocalDataRW getImageWithDirectory:Directory_XB RetalivePath:path];
                __block typeof (image) wimage = image;
                dispatch_async(dispatch_get_main_queue(), ^{
                    wimage = [ZJBHelp handleImage:wimage withSize:imageView.frame.size withFromStudy:YES];
                    [imageView setImage:wimage];
                });
            });
            
            [btn addSubview:imageView];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.frame.origin.y + imageView.frame.size.height + 6, width, 21)];
            [label setText:user.nickname];
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
