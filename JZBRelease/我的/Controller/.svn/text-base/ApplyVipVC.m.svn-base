//
//  ApplyVipVC.m
//  JZBRelease
//
//  Created by cl z on 16/10/14.
//  Copyright © 2016年 zjapple. All rights reserved.
// /Web/Version/checkVIPMoney

#import "ApplyVipVC.h"
#import "AppDelegate.h"
#import "WXApi.h"

#import "wechatPayItem.h"

#import "BCH_Alert.h"
#import "payForAlipay.h"
#import "payForWechat.h"

#import "popContactUsView.h"
#import "JoinUsToxieYiView.h"
#import "payAlipayItem.h"

#import "GLSaleDataTool.h"
#import <StoreKit/StoreKit.h>
#import "Goods_JZBVip.h"

@interface ApplyVipVC ()<UITextViewDelegate,SKProductsRequestDelegate, SKPaymentTransactionObserver>{
    UIView *vipView;
    UIView *introduceView;
    UILabel *fateLabel;
    UITextView *content;
    UIButton *selectXieYiBtn,*btn;
    NSInteger stateCount;
    BOOL isSelect;
}

/** textT */
@property (nonatomic, weak) UILabel *textT;

/** becomeVipBtn */
@property (nonatomic, weak) UIButton *becomeVipBtn;

@property (nonatomic, strong) NSArray *products;

@end

@implementation ApplyVipVC

-(void)setProducts:(NSArray *)products
{
    _products = products;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    stateCount = 0;
    self.title = @"加入建众帮";
    [self initIntroduceView];
    [self initVipView];
    [self DownLoadData];
    
    
    //发布对象在特定时候发现通知中心我说了已经做了某事,你也要做某事了
    [[NSNotificationCenter defaultCenter] addObserverForName:@"IntegralDetailVCPay" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        GLLog(@"%@",note.userInfo);
        if ([note.userInfo.allKeys[0] hasPrefix:@"WX"]) {
            [self.becomeVipBtn setTitle:@"续费建众帮会员" forState:UIControlStateNormal];
        }else {
            payAlipayItem *item = [payAlipayItem mj_objectWithKeyValues:note.userInfo];
            
            if (item.resultStatus.integerValue == AlipayCallBackType9000) {
                [self.becomeVipBtn setTitle:@"续费建众帮会员" forState:UIControlStateNormal];
            }
        }
        
        //        [self popoverPresentationController];
        //do some think
    }];//可以拿到object(A)的数据
    
    AppDelegate *appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    // appD.checkpay
    if (appD.checkpay) {
        
        
        
        
    }else {
        
               [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
               [GLSaleDataTool getGoods_JZBVip:^(NSArray *goods) {
                   NSArray *ids = [goods valueForKeyPath:@"goodID"];
                   // 请求哪些商品可以卖
                   NSSet *idSet = [NSSet setWithArray:ids];
                   SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:idSet];
                   request.delegate = self;
                   [request start];
               }];

    }
    
//    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
//        [GLSaleDataTool getGoods_JZBVip:^(NSArray *goods) {
//            NSArray *ids = [goods valueForKeyPath:@"goodID"];
//            // 请求哪些商品可以卖
//            NSSet *idSet = [NSSet setWithArray:ids];
//            SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:idSet];
//            request.delegate = self;
//            [request start];
//        }];
        
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden = YES;
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)dealloc
{
    
}

#pragma mark - textViewDelegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}

- (void)initIntroduceView{
    introduceView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 240)];
    [self.view addSubview:introduceView];
    [introduceView setBackgroundColor:[UIColor whiteColor]];
    content = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, introduceView.frame.size.width, introduceView.frame.size.height)];
    [introduceView addSubview:content];
    
//    content.editable = NO;
    content.font = [UIFont systemFontOfSize:14];
    
    [content setDelegate:self];
    [content setEditable:YES];
//    UILabel *textT = [UILabel new];
//    self.textT = textT;
//    [introduceView addSubview:textT];
//    textT.frame = CGRectMake(0, 0, introduceView.glw_width, introduceView.glh_height);
}

- (void)initVipView{
    vipView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 240, self.view.frame.size.width, 240)];
    [self.view addSubview:vipView];
    [vipView setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"f2f2f2"]];
    
    NSString *fateStr = @"建众帮入会费用:";
    UIFont *fateFont = [UIFont systemFontOfSize:14];
    NSDictionary *attr = @{NSFontAttributeName:fateFont};
    int width = [fateStr sizeWithAttributes:attr].width + 4;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 44, width, 21)];
    [label setFont:fateFont];
    [label setText:fateStr];
    [label setTextColor:[UIColor hx_colorWithHexRGBAString:@"212121"]];
    [vipView addSubview:label];
    
    fateLabel = [[UILabel alloc]initWithFrame:CGRectMake(20 + 8 + width, 44, 1440, 21)];
    [fateLabel setFont:[UIFont systemFontOfSize:17]];
    [fateLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"ff9800"]];
//    [fateLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"fc504e"]];
    [vipView addSubview:fateLabel];
    
    btn = [[UIButton alloc]initWithFrame:CGRectMake(20, 78, 13, 13)];
    [btn setImage:[UIImage imageNamed:@"wdzy_wx"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [vipView addSubview:btn];
    
    NSString *selectStr = @"勾选即表示您同意并愿意";
    UIFont *selectFont = [UIFont systemFontOfSize:13];
    NSDictionary *attrSelect = @{NSFontAttributeName:fateFont};
    int selectWidth = [fateStr sizeWithAttributes:attrSelect].width + 45;
    UILabel *selectLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 75, selectWidth, 20)];
    [selectLabel setText:selectStr];
    [selectLabel setFont:selectFont];
    [vipView addSubview:selectLabel];
    
    UIControl *control = [[UIControl alloc]initWithFrame:CGRectMake(20, 73, 20 + selectWidth, 20)];
    [control addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [vipView addSubview:control];
    
    NSString *selectXieYiStr = @"遵守加入建众帮协议";
    int selectXieYiWidth = [selectXieYiStr sizeWithAttributes:attrSelect].width + 4;
    selectXieYiBtn = [[UIButton alloc]initWithFrame:CGRectMake(selectLabel.frame.origin.x + selectLabel.frame.size.width, 75, selectXieYiWidth, 20)];
    [selectXieYiBtn setTitle:selectXieYiStr forState:UIControlStateNormal];
    [selectXieYiBtn.titleLabel setFont:selectFont];
    [selectXieYiBtn setTitleColor:[UIColor hx_colorWithHexRGBAString:@"2196F3"] forState:UIControlStateNormal];
    [selectXieYiBtn addTarget:self action:@selector(selectXieYiBtn:) forControlEvents:UIControlEventTouchUpInside];
    [vipView addSubview:selectXieYiBtn];
//    [selectXieYiBtn sizeToFit];
    
    UIButton *becomeVipBtn = [[UIButton alloc]initWithFrame:CGRectMake(44, btn.frame.origin.y + 13 + 27, self.view.frame.size.width - 88, 44)];
    [becomeVipBtn setTitle:@"加入建众帮" forState:UIControlStateNormal];
    [becomeVipBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [becomeVipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [becomeVipBtn addTarget:self action:@selector(becomeVipBtn:) forControlEvents:UIControlEventTouchUpInside];
    [becomeVipBtn setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"ff9800"]];
//    [becomeVipBtn setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"fc504e"]];
    becomeVipBtn.layer.cornerRadius = 22.0;
    [vipView addSubview:becomeVipBtn];
    self.becomeVipBtn = becomeVipBtn;
    
    UIButton *contactUsBtn = [[UIButton alloc]initWithFrame:CGRectMake(44, becomeVipBtn.frame.origin.y + 12 + 44, self.view.frame.size.width - 88, 44)];
    [contactUsBtn setTitle:@"联系我们" forState:UIControlStateNormal];
    [contactUsBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [contactUsBtn addTarget:self action:@selector(contactUsBtn:) forControlEvents:UIControlEventTouchUpInside];
    [contactUsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    contactUsBtn.layer.borderColor = [UIColor hx_colorWithHexRGBAString:@"ff9800"].CGColor;
//    contactUsBtn.layer.borderColor = [UIColor hx_colorWithHexRGBAString:@"fc504e"].CGColor;
    contactUsBtn.layer.borderWidth = 1.0;
    contactUsBtn.layer.cornerRadius = 22.0;
    [vipView addSubview:contactUsBtn];
    
    AppDelegate *appD = (AppDelegate*)[UIApplication sharedApplication].delegate;

    if (appD.vip) {
        [becomeVipBtn setTitle:@"续费建众帮会员" forState:UIControlStateNormal];
    }
    
}

- (void)btnAction{
    if (isSelect) {
        [btn setImage:[UIImage imageNamed:@"wdzy_wx"] forState:UIControlStateNormal];
        isSelect = NO;
    }else{
        // 选择同意
        [btn setImage:[UIImage imageNamed:@"wdzy_yx"] forState:UIControlStateNormal];
        isSelect = YES;
    }
}

#pragma mark - 点击遵守加入建众帮协议
- (void)selectXieYiBtn:(UIButton *)btn{
    
    // 点击遵守加入建众帮协议
    JoinUsToxieYiView *popview = [JoinUsToxieYiView shareJoinUsToxieYiView];
    [self.view addSubview:popview];
    popview.frame = self.view.frame;
    
    [popview.contentView setDelegate:self];
    [popview.contentView setEditable:YES];
}

- (void)becomeVipBtn:(UIButton *)btn{
    
    if (isSelect == NO) {
        [SVProgressHUD showInfoWithStatus:@"请先选择同意 \n《遵守加入建众帮协议》"];
        return;
    }
    
    if (!fateLabel.text) return ;
    
//    NSDictionary *parameters = @{
//                                 @"access_token":[[LoginVM getInstance]readLocal].token,
//                                 @"price":fateLabel.text,
//                                 @"type":@"2"
//                                 };
//    
//    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Pay/WechatPay/createOrder"] parameters:parameters success:^(id json) {
//        
//        if ([json[@"state"] isEqual:@(0)]) {
//            [SVProgressHUD showInfoWithStatus:json[@"info"]];
//            return ;
//        }
//        
//        wechatPayItem *item = [wechatPayItem mj_objectWithKeyValues:json[@"data"]];
//        
//        NSNumber *timestamp = item.timestamp;
//        
//        //调起微信支付
//        PayReq* req             = [[PayReq alloc] init];
//        req.partnerId           = item.partnerid;
//        req.prepayId            = item.prepayid;
//        req.nonceStr            = item.noncestr;
//        req.timeStamp           = timestamp.intValue;
//        req.package             = item.package;
//        req.sign                = item.sign;
//        
//        //日志输出
//        NSLog(@"日志输出appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",json[@"data"][@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
//        
//        NSLog(@"请求结果%d",[WXApi sendReq:req]);
//        
//    } failure:^(NSError *error) {
//        
//    }];
    
    
    AppDelegate *appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    // appD.checkpay
    if (appD.checkpay) {
        
        // appD.checkpay 正常支付
        
        [UIView bch_showWithTitle:@"请选择支付方式" cancelTitle:@"取消" destructiveTitle:nil otherTitles:@[@"微信",@"支付宝"] callback:^(id sender, NSInteger buttonIndex) {
            
            if (buttonIndex == 0) {
                
                // 选择微信
                
                [payForWechat payForWechat:fateLabel.text type:@"2" class_id:nil];
                
            }else if (buttonIndex == 1) {
                
                // 选择支付宝
                [payForAlipay payForAlipay:fateLabel.text type:@"2" class_id:nil];
            }
            
        }];
    }else {
        
        // 非正常支付
        
        [self loadPayWay];
    }
    
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
            [GLSaleDataTool getGoods_JZBVip:^(NSArray *goods) {
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
        SKProduct *product;
        if (self.products) {
            product = self.products[0];
        }
        
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

#pragma mark - 点击了 联系我们
- (void)contactUsBtn:(UIButton *)btn{
    
    // 
    popContactUsView *popview = [popContactUsView sharePopContactUsView];
    [self.view addSubview:popview];
    popview.frame = self.view.frame;
    
    
}


- (void)DownLoadData
{
    NSDictionary *parameters = @{
                                 @"test":@""
                                 };
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"/Web/Version/checkVIPMoney"] parameters:parameters success:^(id json) {
        
        if ([json[@"state"] isEqual:@(0)]) {
            //            NSLog(@"TTT--json%@",json);
            //            [SVProgressHUD showInfoWithStatus:json[@"info"]];
            if ([json[@"error"][@"errcode"] isEqual:@(501)]) {
                
            }else{
                
            }
            
            return ;
        }else {
            NSDictionary *dict = [[NSDictionary alloc]dictionaryWithJSON:json];
            NSNumber *fateNum = [dict objectForKey:@"price"];
            NSString *contentStr = [dict objectForKey:@"content"];
            if (fateNum) {
                [fateLabel setText:[NSString stringWithFormat:@"%@元/年",fateNum]];
            }
            if (contentStr) {
                [content setText:contentStr];
                NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:content.text];
                NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle1 setLineSpacing:8];
                [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [content.text length])];
                [content setAttributedText:attributedString1];
            }
            
        }
    } failure:^(NSError *error) {
        
       
        
    }];
}

/** 微信支付回调 */
- (void)onResp:(BaseResp *)resp {
    
    //支付返回结果，实际支付结果需要去微信服务器端查询
    NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
    
    switch (resp.errCode) {
        case WXSuccess:
            strMsg = @"支付结果：成功！";
            NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
            break;
            
        default:
//            strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
            strMsg = [NSString stringWithFormat:@"支付结果：失败！"];
            NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
            break;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
}

#pragma mark - SKProductRequest代理方法实现

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    self.products = [[NSArray alloc]initWithArray:response.products];
    GLLog(@"%@",self.products)
    if (stateCount == 1) {
        [self loadPayWay];
    }

//    
//    GLLog(@"----%@--%@--%@--%@--%@--%d--%@--%@--", prod.localizedDescription,prod.localizedTitle,prod.price,prod.priceLocale,prod.productIdentifier,prod.downloadable,prod.downloadContentLengths,prod.downloadContentVersion);
//    GLLog(@"----%@", response.products);
    
    //    @property(nonatomic, readonly) NSString *localizedDescription NS_AVAILABLE_IOS(3_0);
    //
    //    @property(nonatomic, readonly) NSString *localizedTitle NS_AVAILABLE_IOS(3_0);
    //
    //    @property(nonatomic, readonly) NSDecimalNumber *price NS_AVAILABLE_IOS(3_0);
    //
    //    @property(nonatomic, readonly) NSLocale *priceLocale NS_AVAILABLE_IOS(3_0);
    //
    //    @property(nonatomic, readonly) NSString *productIdentifier NS_AVAILABLE_IOS(3_0);
    //
    //    // YES if this product has content downloadable using SKDownload
    //    @property(nonatomic, readonly, getter=isDownloadable) BOOL downloadable NS_AVAILABLE_IOS(6_0);
    //
    //    // Sizes in bytes (NSNumber [long long]) of the downloads available for this product
    //    @property(nonatomic, readonly) NSArray<NSNumber *> *downloadContentLengths NS_AVAILABLE_IOS(6_0);
    //
    //    // Version of the downloadable content
    //    @property(nonatomic, readonly) NSString *downloadContentVersion NS_AVAILABLE_IOS(6_0);
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
    SKProduct *productCur = self.products[0];
    item.price = productCur.price.stringValue;
    //    item.class_id = [LoginVM getInstance].readLocal.token;
    item.type = @"2";
    NSDictionary *parameters = item.mj_keyValues;
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Pay/IOSPay/createOrder"] parameters:parameters success:^(id json) {
        
        publicBaseJsonItem *item = [publicBaseJsonItem mj_objectWithKeyValues:json];
        if (!item.data) {
            return ;
        }
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
