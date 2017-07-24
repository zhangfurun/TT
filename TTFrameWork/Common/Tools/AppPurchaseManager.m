//
//  AppPurchaseManager.m
//  TT
//
//  Created by 张福润 on 2017/4/6.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "AppPurchaseManager.h"

#import "TTConst.h"
#import "TTHUDMessage.h"

#define SANDBOX_PATH    @"https://sandbox.iTunes.Apple.com/verifyReceipt"
#define BUY_PATH        @"https://buy.itunes.apple.com/verifyReceipt"

static AppPurchaseManager *instance = nil;

@interface AppPurchaseManager () <SKPaymentTransactionObserver,SKProductsRequestDelegate>
@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) UIView *currentView;
@end

@implementation AppPurchaseManager

+ (instancetype)sharedInstance {
    if (!instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [AppPurchaseManager new];
        });
    }
    return instance;
}

- (void)dealloc {
    [self removeTransaction];
}

#pragma mark - Request
- (void)serverVerifyRequest:(NSString *)verifyCode isSandBox:(NSString *)isSandBox {
    // 与自己的服务器验证
#warning 重要
    // 这里需要注意的是,在验证结果后,调用下面方法,记住,无论结果如何
    // [self removeTransaction]
}

#pragma mark - Method
- (void)removeTransaction {
    self.purchaseing = NO;
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)requestProductData:(NSString *)productId addCurrentView:(UIView *)view {
    if (productId == nil) {
        [TTHUDMessage showCompletedText:@" 商品信息错误！ " withCompletedType:HUDShowCompletedTypeError];
        return;
    }
    self.productId = productId;
    self.purchaseing = YES;
    self.currentView = view;
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:instance];
    NSSet *productIdentifiers = [NSSet setWithObject:self.productId];
    SKProductsRequest* productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
    [TTHUDMessage showInView:self.currentView showText:@"正在加载商品信息，请稍后..."];
}

- (void)completeTransactions:(SKPaymentTransaction *)transaction {
    [self verificationAppleSeverWithIsSandBox:NO tryCount:0];
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

// 苹果服务器验证
- (void)verificationAppleSeverWithIsSandBox:(BOOL)isSandBox tryCount:(NSInteger)tryCount {
    __weak typeof(self) WS = self;
    NSURL *url = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:url];
    [TTHUDMessage showInView:self.currentView];
    
    NSString *encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"receipt-data":encodeStr} options:0 error:nil];
    NSURL *storeUrl = [NSURL URLWithString:isSandBox ? SANDBOX_PATH : BUY_PATH];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:storeUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.f];
    req.HTTPMethod = @"POST";
    req.HTTPBody = jsonData;
    
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (data) {
            NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSInteger status = [responseDic[@"status"] integerValue];
            if (status == 0) {
                [WS serverVerifyRequest:encodeStr isSandBox:isSandBox ? @"1" : @"0"];
            }else {
                if (status == 21007) {
                    //                    [WS verificationAppleSeverWithIsSandBox:YES tryCount:0];
                    [WS serverVerifyRequest:encodeStr isSandBox:@"1"];
                }else {
                    WS.purchaseing = NO;
                    if (tryCount > 3) {
                        [TTHUDMessage showCompletedText:@"验证失败,请联系客服!" withCompletedType:HUDShowCompletedTypeError];
                    }else {
                        [TTHUDMessage showInView:KEY_WINDOW showCompletedText:@"验证失败，正在重试..." withCompletedType:HUDShowCompletedTypeError completedBlock:^{
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [TTHUDMessage showInView:KEY_WINDOW];
                                [WS verificationAppleSeverWithIsSandBox:isSandBox tryCount:tryCount + 1];
                            });
                        }];
                    }
                }
            }
        } else {
            WS.purchaseing = NO;
            if (tryCount > 3) {
                [TTHUDMessage showCompletedText:@"验证失败,请联系客服!" withCompletedType:HUDShowCompletedTypeError];
            }else {
                [TTHUDMessage showInView:KEY_WINDOW showCompletedText:@"验证失败，正在重试..." withCompletedType:HUDShowCompletedTypeError completedBlock:^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [TTHUDMessage showInView:KEY_WINDOW];
                        [WS verificationAppleSeverWithIsSandBox:isSandBox tryCount:tryCount + 1];
                    });
                }];
            }
        }
    }];
}

- (void)failedTransactions:(SKPaymentTransaction *)transaction {
    if(transaction.error) {
        NSString *errorMsg = transaction.error.userInfo[NSLocalizedDescriptionKey];
        [TTHUDMessage showCompletedText:errorMsg withCompletedType:HUDShowCompletedTypeError];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    self.purchaseing = NO;
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    
}

#pragma mark - SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    NSArray *products = response.products;
    if (products.count == 0) {
        [TTHUDMessage showCompletedText:@"无商品信息" withCompletedType:HUDShowCompletedTypeError];
        self.purchaseing = NO;
        return;
    }
    SKProduct *purchasePro = [[SKProduct alloc] init];
    
    NSString *productId = self.productId;
    for (SKProduct *product in products) {
        if ([product.productIdentifier isEqualToString:productId]) {
            purchasePro = product;
        }
    }
    SKPayment *payment = [SKPayment paymentWithProduct:purchasePro];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    self.purchaseing = NO;
    NSString *errorMsg = error.userInfo[NSLocalizedDescriptionKey];
    [TTHUDMessage showCompletedText:errorMsg withCompletedType:HUDShowCompletedTypeError];
}

- (void)requestDidFinish:(SKRequest *)request {
    //    [TTHUDMessage hide];
}

#pragma mark - SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *trans in transactions) {
        switch (trans.transactionState) {
            case SKPaymentTransactionStatePurchased:{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self completeTransactions:trans];
                });
            }
                break;
            case SKPaymentTransactionStatePurchasing:
                
                break;
            case SKPaymentTransactionStateRestored:
                //                [ZZHUDMessage showCompletedText:@"恢复购买" withCompletedType:HUDShowCompletedTypeError];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransactions:trans];
                break;
            case SKPaymentTransactionStateDeferred:
                //                [ZZHUDMessage showCompletedText:@"最终状态未确定" withCompletedType:HUDShowCompletedTypeError];
                break;
                
            default:
                break;
        }
    }
}
@end
