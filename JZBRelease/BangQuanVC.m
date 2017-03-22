//
//  BangQuanVC.m
//  JZBRelease
//
//  Created by zjapple on 16/5/30.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "BangQuanVC.h"
#import "BQDynamicVC.h"
@interface BangQuanVC ()

@end

@implementation BangQuanVC

-(instancetype)init{
    self = [super init];
    if (self) {
//        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//        self = [story instantiateViewControllerWithIdentifier:@"BangQuanVC"];
        
        self = [[BangQuanVC alloc]initWithRootViewController:[[BQDynamicVC alloc]init]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
