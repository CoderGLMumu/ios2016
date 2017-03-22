//
//  SorceDetailVC.m
//  JZBRelease
//
//  Created by cl z on 16/8/30.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "IntegralDetailVC.h"
#import "GetValueObject.h"
#import "Defaults.h"

#import "AlipaySDK.h"
#import "WXApi.h"

#import "payForWechat.h"
#import "payForAlipay.h"

#import "UIButton+CreateButton.h"
#import "popContactUsView.h"
#import "PayMoneyHelpMe.h"

#import "GLSaleDataTool.h"
#import <StoreKit/StoreKit.h>
#import "Goods_JZBVip.h"

@interface IntegralDetailVC ()<UIActionSheetDelegate,SKProductsRequestDelegate, SKPaymentTransactionObserver>{
    GetValueObject *getValueObject;
    NSMutableArray *integralAry;
    NSMutableArray *valueAry;
    NSInteger which;
    NSInteger stateCount;
}

@property (weak, nonatomic) IBOutlet UILabel *currentSourceLabel;

@property (weak, nonatomic) IBOutlet UIView *firstSourceView;
@property (weak, nonatomic) IBOutlet UIView *secondSourceView;
@property (weak, nonatomic) IBOutlet UIView *threeSourceView;
@property (weak, nonatomic) IBOutlet UIView *fourSourceView;
@property (weak, nonatomic) IBOutlet UIView *fiveSourceView;
@property (weak, nonatomic) IBOutlet UIView *sixSourceView;

@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondValueLabe;
@property (weak, nonatomic) IBOutlet UILabel *threeLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *fiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *fiveValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *sixLabel;
@property (weak, nonatomic) IBOutlet UILabel *sixValueLabel;

/** price */
@property (nonatomic, strong) NSString *price;

@property (nonatomic, strong) NSArray *products;

@end

@implementation IntegralDetailVC

-(void)setProducts:(NSArray *)products
{
    _products = products;
}

-(instancetype)init{
    self = [super init];
    if (self) {
//        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        self = [story instantiateViewControllerWithIdentifier:@"IntegralDetailVC"];
//        self = [[UIStoryboard storyboardWithName:@"IntegralDetailVC" bundle:nil] instantiateInitialViewController];
    }
    return self;
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

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initWithView:(UIView *)view WithLabel1:(UILabel *)label1 WithLabel2:(UILabel *)label2{

    if ([label1 isKindOfClass:[UILabel class]]) {
        [label1 setText:[integralAry objectAtIndex:view.tag]];
    }
    if ([label2 isKindOfClass:[UILabel class]]) {
        [label2 setText:[valueAry objectAtIndex:view.tag]];
    }
    view.userInteractionEnabled = YES;
    view.layer.cornerRadius = 3.0;
    view.layer.borderColor = [ValuesFromXML getColor:[ValuesFromXML getValueWithName:@"Integral_Value_Color" WithKind:XMLTypeColors]].CGColor;
    view.layer.borderWidth = 0.5;
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTap:)];
    [view addGestureRecognizer:tap];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.currentSourceLabel setText:self.bangbiCount];
    stateCount = 0;
    [self downloadData];
    
    [self setupNote];
    
    self.view.userInteractionEnabled = YES;
    self.title = @"我的帮币";
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [GLSaleDataTool getGoods_ShopBB:^(NSArray *goods) {
        NSArray *ids = [goods valueForKeyPath:@"goodID"];
        // 请求哪些商品可以卖
        NSSet *idSet = [NSSet setWithArray:ids];
        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:idSet];
        request.delegate = self;
        [request start];
    }];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if (self.isFromPreseVC) {
        [self addNavBar];
        [self putDownView64];
    }
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)downloadData
{
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/Version/pay_select_list"] parameters:nil success:^(id json) {
        
        NSArray *arr = json;
        
        // price是钱,money是币
        
        integralAry = [NSMutableArray array];
        valueAry = [NSMutableArray array];
        
        for (NSDictionary *dictM in arr) {
            NSString *key = [NSString stringWithFormat:@"%@帮币",dictM.allValues[1]];
            NSString *value = [NSString stringWithFormat:@"%@元",dictM.allValues[0]];
            
            [integralAry addObject:key];
            [valueAry addObject:value];
            
        }
        
//        integralAry = @[@"100帮币",@"300帮币",@"500帮币",@"800帮币",@"1000帮币",@"2880帮币"];
//        valueAry = @[@"10元",@"30元",@"50元",@"80元",@"100元",@"288元"];
        
        [self initdataSource];
        
    } failure:^(NSError *error) {
        
        
    }];
    
}


- (void)initdataSource
{
    
    [self initWithView:self.firstSourceView WithLabel1:self.firstLabel WithLabel2:self.firstValueLabel];
    [self initWithView:self.secondSourceView WithLabel1:self.secondLabel WithLabel2:self.secondValueLabe];
    [self initWithView:self.threeSourceView WithLabel1:self.threeLabel WithLabel2:self.threeValueLabel];
    [self initWithView:self.fourSourceView WithLabel1:self.fourLabel WithLabel2:self.fourValueLabel];
    [self initWithView:self.fiveSourceView WithLabel1:self.fiveLabel WithLabel2:self.fiveValueLabel];
    [self initWithView:self.sixSourceView WithLabel1:self.sixLabel WithLabel2:self.sixValueLabel];
}

- (void)addNavBar
{
    UIView *navBar = [UIView new];
    [self.view addSubview:navBar];
    navBar.frame = CGRectMake(0, 0, GLScreenW, 64);
    /** 蓝色头部 */
    navBar.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"2198f2"];
    
    UILabel *midTitleLabel = [UILabel new];
    [navBar addSubview:midTitleLabel];
    midTitleLabel.frame = CGRectMake(0, 64 *0.5, GLScreenW, 0);
    midTitleLabel.text = @"帮币充值";
    midTitleLabel.textColor = [UIColor whiteColor];
    midTitleLabel.textAlignment = NSTextAlignmentCenter;
    midTitleLabel.font = [UIFont systemFontOfSize:20];
    [midTitleLabel sizeToFit];
    midTitleLabel.glcx_centerX = GLScreenW * 0.5;
    
    UIButton *closeButton = [UIButton createButtonWithFrame:CGRectMake(10, 64 *0.42, 30, 30) FImageName:@"close" Target:self Action:@selector(dismissVC) Title:nil];
    closeButton.imageView.contentMode = UIViewContentModeCenter;
    closeButton.gls_size = CGSizeMake(30, 30);
    [navBar addSubview:closeButton];
    
}

- (void)dismissVC
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)putDownView64
{
    self.view.frame = CGRectMake(0, 64, GLScreenW, GLScreenH - 64);
}

- (void)viewTap:(UITapGestureRecognizer *)tap{
    which = tap.view.tag;
    
    //
    NSString *strM = [valueAry objectAtIndex:which];
    
    NSString *price = [strM substringToIndex:strM.length - 1];
    self.price = price;
    
    NSDictionary *parameters = @{
                                 @"access_token":[[LoginVM getInstance]readLocal].token,
                                 @"price":price
                                 };
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Pay/AliPay/createOrder"] parameters:parameters success:^(id json) {
        
//        NSLog(@"TTTT-json%@",json);
        
    } failure:^(NSError *error) {
        
        
        
    }];
    
    GLLog(@"选择了多少钱tap.view.tag==%lu",which)
    
    [self loadPayWay];
    
    
//    [self payForWechat:price];
    
}



- (void)loadPayWay{
    AppDelegate *appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    // !appD.checkpay
    if (!appD.checkpay) {
        // 非正常支付
        
        if (stateCount > 1) {
            [SVProgressHUD showInfoWithStatus:@"请求失败,请重试"];
            return;
        }
        if (!self.products || self.products.count == 0) {
            [GLSaleDataTool getGoods_ShopBB:^(NSArray *goods) {
                NSArray *ids = [goods valueForKeyPath:@"goodID"];
                // 请求哪些商品可以卖
                NSSet *idSet = [NSSet setWithArray:ids];
                SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:idSet];
                request.delegate = self;
                [request start];
                stateCount ++;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD showInfoWithStatus:@"请求数据中..."];
                });
            }];
            return;
        }
        stateCount = 0;
        // 取出商品
        SKProduct *product = self.products[which];
        
        // 购买商品
        SKPayment *payMent = [SKPayment paymentWithProduct:product];
        
        // 把凭证加入到队列, 等待用户付款
        if (payMent) {
            
            [[SKPaymentQueue defaultQueue] addPayment:payMent];
        }
        //        [[SKPaymentQueue defaultQueue] addPayment:payMent];
        //        if ([SKPaymentQueue defaultQueue].observationInfo) {
        //
        //        }else {
        ////            [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        ////            if ([SKPaymentQueue canMakePayments]) {
        ////                [[SKPaymentQueue defaultQueue] addPayment:payMent];
        ////            }
        //        }
        
        // 设置监听者, 监听整个交易状态
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
        return ;
    }else{
        UIActionSheet *sheetView = [[UIActionSheet alloc]initWithTitle:@"请选择支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"微信",@"支付宝", nil];
        [sheetView showInView:[UIApplication sharedApplication].keyWindow];
    }

}

//#pragma mark --签名算法，获取签名
//- (NSString *)getSignWithPartnerId:(NSString *)partnerId
//                      withPrepayId:(NSString *)prepayId
//                      withNonceStr:(NSString *)nonceStr
//                     withTimeStamp:(UInt32)timeStamp
//                       withPackage:(NSString *)package
//{
//    //拼接stringA
//    NSString *stringA = [NSString stringWithFormat:@"appid=%@&noncestr=%@&package=%@&partnerid=%@&prepayid=%@&timestamp=%d",@"替换为微信appid", nonceStr, package, partnerId, prepayId, timeStamp];
//    //拼接API秘钥
//    NSString *stringSignTemp = [NSString stringWithFormat:@"%@&key=%@", stringA,@"这里的key替换为微信商户平台中自己设置的key"];
//    //MD5签名
//    NSString *sign = [self md5:stringSignTemp];
//    //转换成大写字母
//    sign = [sign uppercaseString];
//    return sign;
//}
//#pragma mark --MD5签名算法
//- (NSString *) md5:(NSString *) str
//{
//    const char *cStr = [str UTF8String];
//    unsigned char result[16];
//    CC_MD5(cStr, strlen(cStr), result);// This is the md5 call
//    return [NSString stringWithFormat:
//            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
//            result[0], result[1], result[2], result[3],
//            result[4], result[5], result[6], result[7],
//            result[8], result[9], result[10], result[11],
//            result[12], result[13], result[14], result[15]
//            ];
//}

- (void)payForWechat:(NSString *)price
{
    NSDictionary *parameters = @{
                                 @"access_token":[[LoginVM getInstance]readLocal].token,
                                 @"price":price,
                                 @"type":@"1"
                                 };
    
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Pay/WechatPay/createOrder"] parameters:parameters success:^(id json) {
        
        if ([json[@"state"] isEqual:@(0)]) {
            [SVProgressHUD showInfoWithStatus:json[@"info"]];
            return ;
        }
        
        NSNumber *timestamp = json[@"data"][@"timestamp"];
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.partnerId           = json[@"data"][@"partnerid"];
        req.prepayId            = json[@"data"][@"prepayid"];
        req.nonceStr            = json[@"data"][@"noncestr"];
        req.timeStamp           = timestamp.intValue;
        req.package             = json[@"data"][@"package"];
        req.sign                = json[@"data"][@"sign"];
        
        //日志输出
        NSLog(@"日志输出appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",json[@"data"][@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
        
        NSLog(@"请求结果%d",[WXApi sendReq:req]);
        
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            
        {
            
            NSLog(@"选择微信");
            
//            NSDictionary *parameters = @{
//                                         @"access_token":[[LoginVM getInstance]readLocal].token,
//                                         @"price":@"1",
//                                         @"type":@"1"
//                                         };
//            
//            
//            [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Pay/WechatPay/createOrder"] parameters:parameters success:^(id json) {
//                
//                if ([json[@"state"] isEqual:@(0)]) {
//                    [SVProgressHUD showInfoWithStatus:json[@"info"]];
//                    return ;
//                }
//                
//                NSNumber *timestamp = json[@"data"][@"timestamp"];
//                
//                //调起微信支付
//                PayReq* req             = [[PayReq alloc] init];
//                req.partnerId           = json[@"data"][@"partnerid"];
//                req.prepayId            = json[@"data"][@"prepayid"];
//                req.nonceStr            = json[@"data"][@"noncestr"];
//                req.timeStamp           = timestamp.intValue;
//                req.package             = json[@"data"][@"package"];
//                req.sign                = json[@"data"][@"sign"];
//                
//                //日志输出
//                NSLog(@"日志输出appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",json[@"data"][@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
//                
//                NSLog(@"请求结果%d",[WXApi sendReq:req]);
//
//                
//            } failure:^(NSError *error) {
//                
//            }];
            
            [payForWechat payForWechat:self.price type:@"1" class_id:nil];
            
            break;
        }
    
        case 1:
            
        {
            NSLog(@"选择支付宝");
            
//            NSDictionary *parameters = @{
//                                         @"access_token":[[LoginVM getInstance]readLocal].token,
//                                         @"price":@"1"
//                                         };
//            
//            
//            [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Pay/AliPay/getSign"] parameters:parameters success:^(id json) {
//                
//                if ([json[@"state"] isEqual:@(0)]) {
//                    [SVProgressHUD showInfoWithStatus:json[@"info"]];
//                    return ;
//                }
//                
//                NSString *appScheme = @"jzbrelease";
//                
//                [[AlipaySDK defaultService] payOrder:json[@"data"] fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//                    NSLog(@"reslut = %@",resultDic);
//                }];
//                
//            } failure:^(NSError *error) {
//                
//            }];
            
            [payForAlipay payForAlipay:self.price type:@"1" class_id:nil];
            
            break;
        }
            
        default:
            NSLog(@"取消");
            break;
    }
}

- (void)onResp:(BaseResp *)resp {
   
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            default:
//                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                strMsg = [NSString stringWithFormat:@"支付结果：失败！"];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];

}

- (void)setupNote
{
    
    //发布对象在特定时候发现通知中心我说了已经做了某事,你也要做某事了
    [[NSNotificationCenter defaultCenter] addObserverForName:@"IntegralDetailVCPay" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        GLLog(@"%@",note.userInfo);

        //
        NSDictionary *parameters = @{
                                     @"access_token":[LoginVM getInstance].readLocal.token,
                                     @"uid":@"0"
                                     };
        
        [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/user/info"] parameters:parameters success:^(id json) {
            
            Users *model = [Users new];
            
            model = [Users mj_objectWithKeyValues:json[@"data"]];
            
            [self.currentSourceLabel setText:model.money];
            
            //            NSLog(@"TTT--json%@",json);
            
        } failure:^(NSError *error) {
            
        }];
        
//        [self popoverPresentationController];
        //do some think
    }];//可以拿到object(A)的数据
}

- (IBAction)ClickcontactUsButton:(UIButton *)sender {
    
    popContactUsView *popview = [popContactUsView sharePopContactUsView];
    [self.view addSubview:popview];
    popview.frame = self.view.frame;
    
}
- (IBAction)ClickHelpMeButton:(UIButton *)sender {
    PayMoneyHelpMe *popview = [PayMoneyHelpMe sharePayMoneyHelpMe];
    [self.view addSubview:popview];
    popview.frame = self.view.frame;
    
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark - SKProductRequest代理方法实现

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    
    self.products = [[NSArray alloc]initWithArray:response.products];
    GLLog(@"%@",self.products)
    if (stateCount == 1) {
        [self loadPayWay];
    }
    
}

#pragma mark - SKPaymentTransactionObserver 代理方法实现

// 交易状态发生变化时调用
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
    
    [transactions enumerateObjectsUsingBlock:^(SKPaymentTransaction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        for (SKPaymentTransaction *transaction in transactions) {
            //  SKPayment *payment , 小票 , 有商品
            //  SKPaymentTransactionState transactionState 交易状态
            switch (obj.transactionState) {
                case  SKPaymentTransactionStatePurchasing:
                    GLLog(@"正在付款");
                    break;
                    
                case  SKPaymentTransactionStatePurchased:
                {
                    [self completeTransaction:transaction];
                    GLLog(@"-----交易完成 --------");
                    break;
                }
                case  SKPaymentTransactionStateFailed:
                {
                    GLLog(@"交易失败");
                    [self failedTransaction:transaction];
                    UIAlertView *alerView2 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"购买失败，请重新尝试购买" delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];
                    [alerView2 show];
                    break;
                }
                case  SKPaymentTransactionStateRestored:
                    [self restoreTransaction:transaction];
                    GLLog(@"-----已经购买过该商品 --------");
                    GLLog(@"恢复购买");
                    break;
                case SKPaymentTransactionStateDeferred:
                    GLLog(@"推迟付款");
                    break;
                    
                default:
                    break;
                    
            }
            
        }
    }];
    
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction {
    NSLog(@"-----completeTransaction--------");
    // Your application should implement these two methods.
    NSString *product = transaction.payment.productIdentifier;
    if ([product length] > 0)
    {
        NSArray *tt = [product componentsSeparatedByString:@"."];
        NSString *bookid = [tt lastObject];
        if ([bookid length] > 0)
        {
            [self recordTransaction:bookid];
            [self provideContent:bookid];
        }
    }
    
    HttpBaseRequestItem *item = [HttpBaseRequestItem new];
    item.access_token = [LoginVM getInstance].readLocal.token;
    SKProduct *productCur = self.products[which];
    item.price = productCur.price.stringValue;
    //    item.class_id = [LoginVM getInstance].readLocal.token;
    item.type = @"1";
    NSDictionary *parameters = item.mj_keyValues;
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Pay/IOSPay/createOrder"] parameters:parameters success:^(id json) {
        
        publicBaseJsonItem *item = [publicBaseJsonItem mj_objectWithKeyValues:json];
        if (!item.data) {
            return ;
        }
        if ([item.state isEqual:@(0)]) {
            [SVProgressHUD show];
        }
        //        HttpBaseRequestItem *item2 = [HttpBaseRequestItem new];
        //        item2.access_token = [LoginVM getInstance].readLocal.token;
        //        SKProduct *productCur = self.products[0];
        //        item2.price = productCur.price.stringValue;
        //        //    item.class_id = [LoginVM getInstance].readLocal.token;
        //        item2.type = @"2";
        //        NSDictionary *parameters2 = item2.mj_keyValues;
        
        [HttpToolSDK postWithURL:item.data parameters:nil success:^(id json) {
            
            publicBaseJsonItem *item = [publicBaseJsonItem mj_objectWithKeyValues:json];
            if ([item.state isEqual:@(1)]) {
                // Remove the transaction from the payment queue
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"" message:@"购买成功" delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];
                [alerView show];
            }
            
        } failure:^(NSError *error) {
            GLLog(@"%@",error);
            GLLog(@"%@",error);
        }];
        //            NSLog(@"TTT--json%@",json);
    } failure:^(NSError *error) {
        
    }];
}
//记录交易
-(void)recordTransaction:(NSString *)product
{
    NSLog(@"-----记录交易--------");
}
//处理下载内容
-(void)provideContent:(NSString *)product
{
    NSLog(@"-----下载--------");
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@"失败");
    
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

-(void) paymentQueueRestoreCompletedTransactionsFinished: (SKPaymentTransaction *)transaction
{
    
}
- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@" 交易恢复处理");
}

-(void) paymentQueue:(SKPaymentQueue *) paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    NSLog(@"-------paymentQueue----");
}

@end
