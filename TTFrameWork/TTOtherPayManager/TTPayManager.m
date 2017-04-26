//
//  TTPayManager.m
//  StoryShip
//
//  Created by 张福润 on 2017/4/23.
//  Copyright © 2017年 ifenghui. All rights reserved.
//

#import "TTPayManager.h"

#import "AliPayManagerHeader.h"
#import "WeChatPayManagerHeader.h"

#import "TTAlertView.h"

///用户获取设备ip地址
#include <ifaddrs.h>
#include <arpa/inet.h>

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#import <AFNetworkActivityIndicatorManager.h>
#else
#import "AFNetworking.h"
#import "AFNetworkReachabilityManager.h"
#endif

#import "AliPaySignTool.h"

@interface TTPayManager ()<WXApiDelegate>
@property (copy, nonatomic) SuccessBlock successBlock;
@property (copy, nonatomic) CancelBlock cancelBlock;
@property (copy, nonatomic) FailureBlock failureBlock;

@property (strong, nonatomic) NSMutableDictionary *appSchemeDict;
@end

@implementation TTPayManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static TTPayManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[TTPayManager alloc] init];
    });
    return instance;
}

#pragma mark - Methods
- (NSMutableDictionary *)appSchemeDict{
    if (_appSchemeDict == nil) {
        _appSchemeDict = [NSMutableDictionary dictionary];
    }
    return _appSchemeDict;
}

#pragma mark -- Public Methods
- (void)registerApp {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *urlTypes = dict[@"CFBundleURLTypes"];
    NSAssert(urlTypes, TIP_URLTYPE);
    for (NSDictionary *urlTypeDict in urlTypes) {
        NSString *urlName = urlTypeDict[@"CFBundleURLName"];
        NSArray *urlSchemes = urlTypeDict[@"CFBundleURLSchemes"];
        NSAssert(urlSchemes.count, TIP_URLTYPE_SCHEME(urlName));
        // 一般对应只有一个
        NSString *urlScheme = urlSchemes.lastObject;
        if ([urlName isEqualToString:WECHATURLNAME]) {
            [self.appSchemeDict setValue:urlScheme forKey:WECHATURLNAME];
            // 注册微信
            [WXApi registerApp:urlScheme];
        }
        else if ([urlName isEqualToString:ALIPAYURLNAME]){
            // 保存支付宝scheme，以便发起支付使用
            [self.appSchemeDict setValue:urlScheme forKey:ALIPAYURLNAME];
        }
        else{
            
        }
    }
}

- (BOOL)handleUrl:(NSURL *)url {
    NSAssert(url, TIP_CALLBACKURL);
    if ([url.host isEqualToString:@"pay"]) {// 微信
        return [WXApi handleOpenURL:url delegate:self];
    }else {
        if ([url.host isEqualToString:@"safepay"]) {// 支付宝
            [self aliPayResult:url];
            return YES;
        }else {
            return NO;
        }
    }
}

- (void)payWithOrderMessage:(id)orderMessage
               successBlock:(SuccessBlock)successBlock
                cancelBlock:(CancelBlock)cancelBlock
               failureBlock:(FailureBlock)failureBlock {
    NSAssert(orderMessage, TIP_ORDERMESSAGE);
    // 发起支付
    if ([orderMessage isKindOfClass:[WeChatPayModel class]]) {
        // 微信
        if ([WXApi isWXAppInstalled]) {
            [self jumpToWxPay:(WeChatPayModel *)orderMessage
                 successBlock:successBlock
                  cancelBlock:cancelBlock
                 failureBlock:failureBlock];
        }else {
            [TTAlertView alertViewTitle:@"下载微信客户端" message:@"是否前去下载微信客户端?" confirmTitle:@"下载" cancelBlock:^{
                
            } confirmBlock:^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[WXApi getWXAppInstallUrl]]];
            }];
        }
    }else {
        [self aliPay:orderMessage
        successBlock:successBlock
         cancelBlock:cancelBlock
        failureBlock:failureBlock];
    }
}

#pragma mark -- AliPay Method
- (void)aliPay:(id)orderMessage
  successBlock:(SuccessBlock)successBlock
   cancelBlock:(CancelBlock)cancelBlock
  failureBlock:(FailureBlock)failureBlock {
    self.successBlock = successBlock;
    self.cancelBlock = cancelBlock;
    self.failureBlock = failureBlock;
    if ([orderMessage isKindOfClass:[AliPayModel class]]){
        // 支付宝
        NSAssert([orderMessage isKindOfClass:[AliPayModel class]], TIP_ORDERMESSAGE);
        NSAssert(self.appSchemeDict[ALIPAYURLNAME], TIP_URLTYPE_SCHEME(ALIPAYURLNAME));
        NSString *orderStr = [AliPaySignTool doAlipayPay:(AliPayModel *)orderMessage];
        [[AlipaySDK defaultService] payOrder:(NSString *)orderStr fromScheme:self.appSchemeDict[ALIPAYURLNAME] callback:^(NSDictionary *resultDic){
            NSString *resultStatus = resultDic[@"resultStatus"];
            NSString *errStr = resultDic[@"memo"];
            
            switch (resultStatus.integerValue) {
                case 9000:// 成功
                    if (self.successBlock) {
                        self.successBlock();
                    }
                    break;
                case 6001:// 取消
                    if (self.cancelBlock) {
                        self.cancelBlock();
                    }
                    break;
                default:
                    if (self.failureBlock) {
                        self.failureBlock(errStr);
                    }
                    break;
            }
        }];
    }
}

- (void)aliPayResult:(NSURL *)url {
    // 支付跳转支付宝钱包进行支付，处理支付结果(在app被杀模式下，通过这个方法获取支付结果）
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSString *resultStatus = resultDic[@"resultStatus"];
        NSString *errStr = resultDic[@"memo"];
        switch (resultStatus.integerValue) {
            case 9000:// 成功
                if (self.successBlock) {
                    self.successBlock();
                }
                break;
            case 6001:// 取消
                if (self.cancelBlock) {
                    self.cancelBlock();
                }
                break;
            default:
                if (self.failureBlock) {
                    self.failureBlock(errStr);
                }
                break;
        }
    }];
    
    // 授权跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"result = %@",resultDic);
        // 解析 auth code
        NSString *result = resultDic[@"result"];
        NSString *authCode = nil;
        if (result.length>0) {
            NSArray *resultArr = [result componentsSeparatedByString:@"&"];
            for (NSString *subResult in resultArr) {
                if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                    authCode = [subResult substringFromIndex:10];
                    break;
                }
            }
        }
        NSLog(@"授权结果 authCode = %@", authCode?:@"");
    }];
    
}

#pragma mark -- WeChat Method
- (void)jumpToWxPay:(WeChatPayModel *)model
       successBlock:(SuccessBlock)successBlock
        cancelBlock:(CancelBlock)cancelBlock
       failureBlock:(FailureBlock)failureBlock{
    self.successBlock = successBlock;
    self.cancelBlock = cancelBlock;
    self.failureBlock = failureBlock;
    
    NSString *tradeType = @"APP";                                       //交易类型
    NSString *totalFee  = model.price;                                  //交易价格1表示0.01元，10表示0.1元
    NSString *payTitle   = model.payTitle;
    NSString *tradeNO   = [self generateTradeNO];                       //随机字符串变量 这里最好使用和安卓端一致的生成逻辑
    NSString *addressIP = [self fetchIPAddress];                        //设备IP地址,请再wifi环境下测试,否则获取的ip地址为error,正确格式应该是8.8.8.8
    NSString *orderNo   = model.orderNo;   //随机产生订单号用于测试，正式使用请换成你从自己服务器获取的订单号
    NSString *notifyUrl = model.notifyUrl;// 交易结果通知网站此处用于测试，随意填写，正式使用时填写正确网站
    
    //获取SIGN签名
    WeChatSignManager *adaptor = [[WeChatSignManager alloc] initWithWechatAppId:WECHAT_APP_ID
                                                                    wechatMCHId:WECHAT_PARTNER_ID
                                                                        tradeNo:tradeNO
                                                               wechatPartnerKey:WECHAT_PARTNER_KEY
                                                                       payTitle:payTitle
                                                                        orderNo:orderNo
                                                                       totalFee:totalFee
                                                                       deviceIp:addressIP
                                                                      notifyUrl:notifyUrl
                                                                      tradeType:tradeType];
    
    //转换成XML字符串,这里只是形似XML，实际并不是正确的XML格式，需要使用AF方法进行转义
    NSString *string = [[adaptor dic] XMLString];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    // 这里传入的XML字符串只是形似XML，但不是正确是XML格式，需要使用AF方法进行转义
    session.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [session.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [session.requestSerializer setValue:kUrlWechatPay forHTTPHeaderField:@"SOAPAction"];
    [session.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return string;
    }];
    
    [session POST:kUrlWechatPay
       parameters:string
     
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              //  输出XML数据
              NSString *responseString = [[NSString alloc] initWithData:responseObject
                                                               encoding:NSUTF8StringEncoding] ;
              //  将微信返回的xml数据解析转义成字典
              NSDictionary *dic = [NSDictionary dictionaryWithXMLString:responseString];
              
              // 判断返回的许可
              if ([[dic objectForKey:@"result_code"] isEqualToString:@"SUCCESS"]
                  &&[[dic objectForKey:@"return_code"] isEqualToString:@"SUCCESS"] ) {
                  // 发起微信支付，设置参数
                  PayReq *request = [[PayReq alloc] init];
                  request.openID = [dic objectForKey:WX_APPID];
                  request.partnerId = [dic objectForKey:WX_MCHID];
                  request.prepayId= [dic objectForKey:WX_PREPAYID];
                  request.package = @"Sign=WXPay";
                  request.nonceStr= [dic objectForKey:WX_NONCESTR];
                  
                  // 将当前时间转化成时间戳
                  NSDate *datenow = [NSDate date];
                  NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
                  UInt32 timeStamp =[timeSp intValue];
                  request.timeStamp= timeStamp;
                  
                  // 签名加密
                  WeChatSignManager *md5 = [[WeChatSignManager alloc] init];
                  
                  request.sign=[md5 createMD5SingForPay:request.openID
                                              partnerid:request.partnerId
                                               prepayid:request.prepayId
                                                package:request.package
                                               noncestr:request.nonceStr
                                              timestamp:request.timeStamp];
                  // 调用微信
                  [WXApi sendReq:request];
              }
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              
          }];
}

// 产生随机字符串
- (NSString *)generateTradeNO {
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    
    NSMutableString *resultStr = [[NSMutableString alloc] init];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wshorten-64-to-32"
    srand(time(0)); // 此行代码有警告:
#pragma clang diagnostic pop
    for (int i = 0; i < kNumber; i++) {
        
        unsigned index = rand() % [sourceStr length];
        
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        
        [resultStr appendString:oneStr];
    }
    return resultStr;
}


// 获取设备ip地址(尽在wifi环境下)
- (NSString *)fetchIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[PayResp class]]){
        // 判断支付类型
        if([resp isKindOfClass:[PayResp class]]){
            //支付回调
            NSString *errStr = resp.errStr;
            switch (resp.errCode) {
                case 0:
                    errStr = @"订单支付成功";
                    if (self.successBlock) {
                        self.successBlock();
                    }
                    break;
                case -1:
                    // 失败
                    errStr = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                    if (self.failureBlock) {
                        self.failureBlock(errStr);
                    }
                    break;
                case -2:
                    // 取消
                    if (self.cancelBlock) {
                        self.cancelBlock();
                    }
                    break;
                default:
                    errStr = resp.errStr;
                    if (self.failureBlock) {
                        self.failureBlock(errStr);
                    }
                    break;
            }
        }
    }
}
@end

@implementation WeChatPayModel
- (NSString *)payTitle {
    return _payTitle ? : @"故事飞船支付";
}
@end

@implementation AliPayModel
- (NSString *)price {
    return [NSString stringWithFormat:@"%.2f", [_price floatValue] / 100.f];
}
@end
