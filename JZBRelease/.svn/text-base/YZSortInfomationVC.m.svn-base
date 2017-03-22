
//
//  YZSortInfomationVC.m
//  JZBRelease
//
//  Created by cl z on 16/11/25.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "YZSortInfomationVC.h"

#import "YZTagList.h"
#import "GetValueObject.h"
#import "Defaults.h"
#import "LocalDataRW.h"
#import "BBGetIndustryModel.h"
#import "IndustryModel.h"
#define Main_Screen_Height [[UIScreen mainScreen] bounds].size.height //主屏幕的高度
#define Main_Screen_Width  [[UIScreen mainScreen] bounds].size.width
@interface YZSortInfomationVC(){
    YZTagList *tagList,*tagList1;
    UIView *view1;
    GetValueObject *obj;
    NSMutableArray *unFocusAry;
    CGSize tagSize;
}

@end

@implementation YZSortInfomationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择关注的标签";
    [self.view setBackgroundColor:[UIColor whiteColor]];
   [self configNav];
    // Do any additional setup after loading the view.
    
    if (fabs((double)MAX(Main_Screen_Width, Main_Screen_Height) - (double)568) < DBL_EPSILON) {
        tagSize = CGSizeMake(65, 30);
    }else if (fabs((double)MAX(Main_Screen_Width, Main_Screen_Height) - (double)736) < DBL_EPSILON){
        tagSize = CGSizeMake(80, 30);
    }else if (fabs((double)MAX(Main_Screen_Width, Main_Screen_Height) - (double)667) < DBL_EPSILON){
        tagSize = CGSizeMake(75, 30);
    }else{
        tagSize = CGSizeMake(65, 30);
    }
    obj = [[GetValueObject alloc]init];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 76, 160, 30)];
    [label setText:@"已关注的标签:"];
    [label setFont:[UIFont systemFontOfSize:16]];
    [label setTextColor:RGB(180, 180, 180, 1)];
    [self.view addSubview:label];
    
    NSArray *tags = self.focusedAry;
    tagList = [[YZTagList alloc] init];
    tagList.frame = CGRectMake(0, 94, self.view.bounds.size.width, 43);
    // 设置排序时，缩放比例
    tagList.scaleTagInSort = 1.3;
    tagList.unableHitCount = 2;
    // 需要排序
    tagList.isSort = YES;
    // 标签尺寸
    tagList.tagSize = tagSize;
    tagList.tagBackgroundColor = [UIColor whiteColor];
    tagList.borderColor = RGB(227, 227, 227, 1);
    tagList.borderWidth = 0.8;
    tagList.tagCornerRadius = 3.0;
    // 设置标签颜色
    tagList.tagColor = RGB(93, 166, 252, 1);
    __weak typeof(self) weakSelf = self;
    tagList.clickTagBlock = ^(NSString *tag){
        [weakSelf clickTag1:tag];
        
    };
    [self.view addSubview:tagList];
    [tagList addTags:tags];
    
    
    
    view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 3 + tagList.frame.origin.y + tagList.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height - (3 + tagList.frame.origin.y + tagList.frame.size.height))];
    [self.view addSubview:view1];
    
    UIView *inteval = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    [inteval setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
    [view1 addSubview:inteval];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, 160, 30)];
    [label1 setText:@"未关注的标签:"];
    [label1 setFont:[UIFont systemFontOfSize:16]];
    [label1 setTextColor:RGB(180, 180, 180, 1)];
    [view1 addSubview:label1];
    
    
    unFocusAry = [LocalDataRW readDataFromLocalOfDocument:@"unFocusInfoTags.plist" WithDirectory_Type:Directory_ZX];
    [self downloadData];
    //    if (!unFocusAry) {
    //
    //    }else{
    //        [self initUnFocusView];
    //    }
}

- (void)initUnFocusView{
    // 创建标签列表
    tagList1 = [[YZTagList alloc] init];
    // 高度可以设置为0，会自动跟随标题计算
    tagList1.frame = CGRectMake(0, 30, self.view.bounds.size.width, view1.frame.size.height - 30);
    // 设置排序时，缩放比例
    tagList1.scaleTagInSort = 1.3;
    // 需要排序
    //    tagList1.isSort = YES;
    // 标签尺寸
    tagList1.tagSize = tagSize;
    // 不需要自适应标签列表高度
    tagList1.isFitTagListH = NO;
    [view1 addSubview:tagList1];
    
    tagList1.tagBackgroundColor = [UIColor whiteColor];
    tagList1.borderColor = RGB(227, 227, 227, 1);
    tagList1.borderWidth = 0.8;
    tagList1.tagCornerRadius = 3.0;
    // 设置标签颜色
    tagList1.tagColor = RGB(93, 166, 252, 1);
    __weak typeof(self) weakSelf = self;
    tagList1.clickTagBlock = ^(NSString *tag){
        [weakSelf clickTag:tag];
        
    };
    
    /**
     *  这里一定先设置标签列表属性，然后最后去添加标签
     */
    [tagList1 addTags:unFocusAry];
}

- (void)downloadData {
    CustomAlertView *alertView = [CustomAlertView defaultCustomAlertView:@"加载中..."];
    [self lew_presentPopupView:alertView animation:[LewPopupViewAnimationSpring new]];
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[HttpManager shareManager] netStatus:^(AFNetworkReachabilityStatus status) {
            if(status == AFNetworkReachabilityStatusReachableViaWWAN || status ==AFNetworkReachabilityStatusReachableViaWiFi){
                BBGetIndustryModel *model = [[BBGetIndustryModel alloc]init];
                model.id = @"0";
                model.tree = @"0";
                SendAndGetDataFromNet *send = [[SendAndGetDataFromNet alloc]init];
                send.returnArray = ^(NSArray *ary){
                    if (ary && ary.count > 0) {
                        if ([LocalDataRW writeDataToLocaOfDocument:ary WithDirectory_Type:Directory_ZX AtFileName:@"AllInfoTags.plist"]) {
                            NSLog(@"write successfully");
                        }
                        if (!unFocusAry) {
                            unFocusAry = [[NSMutableArray alloc]init];
                        }else{
                            [unFocusAry removeAllObjects];
                        }
                        for (NSInteger i = 0; i < ary.count; i ++) {
                            IndustryModel *industryModel = [IndustryModel mj_objectWithKeyValues:[ary objectAtIndex:i]];
                            BOOL isExsist = NO;
                            for (int j = 0; j < self.focusedAry.count; j ++) {
                                NSString *tag = [self.focusedAry objectAtIndex:j];
                                if ([industryModel.title isEqualToString:tag]) {
                                    isExsist = YES;
                                    break;
                                }
                            }
                            if (!isExsist) {
                                [unFocusAry addObject:industryModel.title];
                            }
                            
                        }
                        [LocalDataRW writeDataToLocaOfDocument:unFocusAry WithDirectory_Type:Directory_ZX AtFileName:@"unFocusInfoTags.plist"];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self initUnFocusView];
                            [self lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
                            [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                        });
                        
                    }else{
                        [self lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
                        [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                    }
                };
                [send dictDataFromNet:model WithRelativePath:@"Article_Column_List_URL"];
                
                
            }else{
                [Toast makeShowCommen:@"您的网络有问题 " ShowHighlight:@"请重置" HowLong:1.2];
            }
        }];
    });
}


-(void)configNav
{
    //11 20
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11 + 5 + 40, 35)];
    UIImageView *backImageView = [UIImageView createImageViewWithFrame:CGRectMake(0, (35-20)/2, 20, 20) ImageName:@"DL_light_ARROW"];
    backImageView.userInteractionEnabled = YES;
    [backView addSubview:backImageView];
    //    UILabel *backLabel = [UILabel createLabelWithFrame:CGRectMake(11 + 5,(35-20)/2, 40, 20) Font:17 Text:@"返回" andLCR:0 andColor:[ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Navigation_Color" WithKind:XMLTypeColors]]];
    //    [backView addSubview:backLabel];
    UIControl *back = [[UIControl alloc] initWithFrame:backView.bounds];
    [back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:back];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
}
-(void) backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidDisappear:(BOOL)animated{
    if (self.returnData) {
        self.returnData(tagList.tagArray);
    }
    [LocalDataRW writeDataToLocaOfDocument:tagList.tagArray WithDirectory_Type:Directory_ZX AtFileName:@"focusedInfoTags.plist"];
    [LocalDataRW writeDataToLocaOfDocument:tagList1.tagArray WithDirectory_Type:Directory_ZX AtFileName:@"unFocusInfoTags.plist"];
    [self.navigationController popViewControllerAnimated:YES];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)clickTag:(NSString *)tag
{
    // 删除标签
    [tagList addTag:tag];
    [tagList1 deleteTag:tag];
    [UIView animateWithDuration:0.25 animations:^{
        [view1 setFrame:CGRectMake(0, 10 + tagList.frame.origin.y + tagList.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height - (10 + tagList.frame.origin.y + tagList.frame.size.height))];
    }];
}

- (void)clickTag1:(NSString *)tag
{
    // 删除标签
    [tagList deleteTag:tag];
    [tagList1 addTag:tag];
    [UIView animateWithDuration:0.25 animations:^{
        [view1 setFrame:CGRectMake(0, 10 + tagList.frame.origin.y + tagList.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height - (10 + tagList.frame.origin.y + tagList.frame.size.height))];
    }];
}

@end
