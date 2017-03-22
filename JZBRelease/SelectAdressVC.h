//
//  SelectAdressVC.h
//  JZBRelease
//
//  Created by cl z on 16/8/15.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cityModel.h"
@interface SelectAdressVC : UIViewController{
   
}

@property(nonatomic,copy)void (^returnAdress)(cityModel *cityModel);

@end
