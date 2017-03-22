//
//  PicturesAndMenusView.m
//  JZBRelease
//
//  Created by zjapple on 16/6/22.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "PicturesAndMenusView.h"
#import "Masonry.h"
#import "Defaults.h"
@implementation PicturesAndMenusView

-(instancetype)initWithData:(GetValueObject *) obj{
    self = [super init];
    if (self) {
        StatusModel *model = (StatusModel *)obj;
        Users *user = model.user;
        
        //正文内容模型 contentTextStorage
        self.contentLabel = [[UILabel alloc] init];
        UIFont *font = [UIFont systemFontOfSize:(float)model.fontSize / 1.3];
        NSDictionary *contentAttrs = @{NSFontAttributeName:font};
        int rowwidth = SCREEN_WIDTH - (5 * model.inteval + model.avatarWidth);
        int sum = 0;
        int k = 0;
        if (self.isDynamicDetail) {
            self.contentLabel.text = model.describe;
        }else{
            if (model.describe.length * 12 > rowwidth * 3) {
                while (sum < rowwidth * 3 && k < model.describe.length) {
                    
                    NSString *singleS = [model.describe substringWithRange:NSMakeRange(k, 1)];
                    k ++;
                    CGSize s1=[singleS sizeWithAttributes:contentAttrs];
                    sum += s1.width;
                }
                NSString *describe = [NSString stringWithFormat:@"%@...",[model.describe substringToIndex:k]];
                self.contentLabel.text = describe;
            }else{
                self.contentLabel.text = model.describe;
            }
        }
        self.contentLabel.font = font;
        if (self.isDynamicDetail) {
            self.contentLabel.textColor = [UIColor blackColor];
        }
        [self addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leftMargin.equalTo(self).offset(2 * model.inteval + model.avatarWidth);
            make.rightMargin.equalTo(self).offset(2 * model.inteval);
            
        }];

        
        NSMutableArray *imagesAry = [[NSMutableArray alloc]init];
        NSString *absolutePath = [ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort];
        for (int i = 0; i < model.images.count; i ++) {
            NSString *path = [absolutePath stringByAppendingPathComponent:[model.images objectAtIndex:i]];
            if (path) {
                [imagesAry addObject:path];
            }
        }
        self.picsView = [CusNinePicView getCusNinePicViewWithData:imagesAry WithSigleHeight:model.imageWidth WithInteval:model.inteval WithDefaultPic:@"f_static_000" OrignY:self.contentLabel.frame.size.height];
        [self addSubview:self.picsView];
        
        //menu
        self.commentBtn = [[UIButton alloc]init];
        [self addSubview:self.commentBtn];
        [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(19, 18));
            make.rightMargin.equalTo(self).offset(2 * model.inteval);
            make.topMargin.equalTo(self.picsView).offset(2 * model.inteval);
        }];
        self.height = self.frame.size.height + 4 * model.inteval + 18;
        
    }
    return self;
}


+(PicturesAndMenusView *) getPicturesAndMenusViewWithData:(GetValueObject *) obj{
    PicturesAndMenusView *pic = [[PicturesAndMenusView alloc] initWithData:obj];
    return pic;
}


@end
