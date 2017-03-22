//
//  FilterLayout.m
//  JZBRelease
//
//  Created by zjapple on 16/5/6.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "FilterLayout.h"
#import "LWTextParser.h"
#import "LWDefine.h"
#import "Defaults.h"
@implementation FilterLayout{
    int inteval;
    int imageWidth;
    int avatarWidth;
    int fontSize;
}

- (id)initWithContainer:(LWStorageContainer *)container
                  Model:(FilterModel *)filterModel
                  index:(NSInteger)index{
    self = [super initWithContainer:container];
    if (self) {
        
 

        //名字模型 titleTextStorage
        LWTextStorage* titleTextStorage = [[LWTextStorage alloc] init];
        titleTextStorage.text = filterModel.title;
        titleTextStorage.font = [UIFont systemFontOfSize:(float)avatarWidth / 8.0 * 3];
        titleTextStorage.textAlignment = NSTextAlignmentLeft;
        titleTextStorage.linespace = 2.0f;
        titleTextStorage.textColor = [ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Click_Color" WithKind:XMLTypeColors]];
        NSDictionary *titleAttrs = @{NSFontAttributeName:titleTextStorage.font};
        
        [LWConstraintManager lw_makeConstraint:titleTextStorage.constraint.leftMargin(10).topMargin(11).widthLength([filterModel.title sizeWithAttributes:titleAttrs].width).heightLength([filterModel.title sizeWithAttributes:titleAttrs].height)];
        [container addStorage:titleTextStorage];
        
        self.cellHeight = [self suggestHeightWithBottomMargin:15.0f];
    }
    
    return self;
}
@end
