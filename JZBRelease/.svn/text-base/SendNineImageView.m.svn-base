//
//  SendNineImageView.m
//  JZBRelease
//
//  Created by zjapple on 16/5/19.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "SendNineImageView.h"
#import "Defaults.h"

@implementation SendNineImageView{
    NSInteger row;
    NSInteger column;
}


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        row = 0;
        column = 0;
        self.viewsAry = [[NSMutableArray alloc]init];
        //self.userInteractionEnabled = YES;
    }
    return self;
}

-(void) initViews : (NSInteger) width Inteval:(NSInteger)inteval{
    
    if (!self.addImageView) {
        
        CGRect imageViewRect = CGRectMake(25, inteval,width,width);
        self.addImageView = [UIImageView createImageViewWithFrame:imageViewRect ImageName:@"bq_edit_img_add"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewAction:)];
        [self.addImageView addGestureRecognizer:tap];
        self.addImageView.layer.cornerRadius = 5.0;
        self.addImageView.layer.borderWidth = 1;
        self.addImageView.layer.borderColor = [UIColor clearColor].CGColor;
        self.addImageView.tag = 10;
        [self addSubview:self.addImageView];
        [self.viewsAry addObject:self.addImageView];
    }
    if (!(self.imageAry.count > 0)) {
        return;
    }
    NSInteger tempRow = 0;
    NSInteger tempColumn = 0;
    if ((self.imageAry.count + 1) % 4 == 0) {
        tempRow = (self.imageAry.count + 1) / 4  - 1;
        tempColumn = 4 - 1;
    }else{
        tempRow = (self.imageAry.count + 1) / 4;
        tempColumn = (self.imageAry.count + 1) % 4 - 1;
    }
    CGRect btnRect = CGRectMake(25 + (tempColumn * (width + inteval)),
                                inteval + (tempRow * (width + inteval)),
                                width,
                                width);
    [UIView animateWithDuration:0.45 animations:^{
        self.addImageView.frame = btnRect;
        if (self.imageAry.count == 9) {
            self.addImageView.alpha = 0;
        }
    } completion:^(BOOL finished) {
        if (self.imageAry.count == 9) {
            self.addImageView.hidden = YES;
        }
        for (NSInteger i = row * 4 + column; i < self.imageAry.count; i ++) {
            CGRect imageViewRect = CGRectMake(25 + column * (width + inteval),
                                        inteval + (row * (width + inteval)),
                                        width,
                                        width);
            
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[self.imageAry objectAtIndex:i]];
            imageView.frame = imageViewRect;
            imageView.layer.cornerRadius = 5.0;
            imageView.layer.borderWidth = 1;
            imageView.userInteractionEnabled = YES;
            imageView.layer.borderColor = [UIColor clearColor].CGColor;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewAction:)];
            [imageView addGestureRecognizer:tap];
            imageView.tag = i;
            column = column + 1;
            if (column > 3) {
                column = 0;
                row = row + 1;
            }
            [self addSubview:imageView];
            [self.viewsAry insertObject:imageView atIndex:self.viewsAry.count - 1];
        }
        
    }];

}

-(void) removeSomeViews : (NSArray *) whichs{
    for (int i = 0; i < whichs.count; i ++) {
        
    }
}

-(NSMutableArray *)imageAry{
    if (_imageAry) {
        return _imageAry;
    }
    _imageAry = [[NSMutableArray alloc]init];
    return _imageAry;
}

-(void) addSingleView : (NSInteger) width Inteval : (NSInteger) inteval{
    
}

-(void) removeAllViews{
    for (int i = 0; i < self.viewsAry.count; i ++) {
        UIImageView *imageView = [self.viewsAry objectAtIndex:i];
        [imageView removeFromSuperview];
        imageView = nil;
    }
    if (self.addImageView) {
        [self.addImageView removeFromSuperview];
        self.addImageView = nil;
    }
    [self.viewsAry removeAllObjects];
    row = 0;
    column = 0;
}

-(void)imageViewAction : (UITapGestureRecognizer *)tap{
    self.clickAction(tap.view.tag);
    NSLog(@"btn.tag is %ld",tap.view.tag);
}

-(void)dealloc{
    [self removeAllViews];
}
@end
