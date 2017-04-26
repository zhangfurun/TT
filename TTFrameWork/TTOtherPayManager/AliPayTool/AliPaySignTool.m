//
//  AliPayTool.m
//  StoryShip
//
//  Created by 张福润 on 2017/4/24.
//  Copyright © 2017年 ifenghui. All rights reserved.
//

#import "AliPaySignTool.h"

#import <UIKit/UIKit.h>

#import "TTPayManager.h"

#import "AliPayManagerHeader.h"

@implementation AliPaySignTool

+ (NSString *)doAlipayPay:(AliPayModel *)model {
    NSString *appID = ALI_PAY_APPID;
    
    NSString *rsa2PrivateKey = ALI_PAY_PRIVATEKEY;
    NSString *rsaPrivateKey = @"";
    //partner和seller获取失败,提示
    if ([appID length] == 0 || ([rsa2PrivateKey length] == 0 && [rsaPrivateKey length] == 0)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少appId或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }else {
        /*
         *生成订单信息及签名
         */
        //将商品信息赋予AlixPayOrder的成员变量
        Order* order = [Order new];
        
        // NOTE: app_id设置
        order.app_id = appID;
        
        // NOTE: 支付接口名称
        order.method = @"alipay.trade.app.pay";
        
        // NOTE: 参数编码格式
        order.charset = @"utf-8";
        
        // NOTE: 当前时间点
        NSDateFormatter* formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        order.timestamp = [formatter stringFromDate:[NSDate date]];
        
        // NOTE: 回调URL
        order.notify_url = model.notifyUrl;
        
        // NOTE: 支付版本
        order.version = [[AlipaySDK defaultService] currentVersion];
        
        // NOTE: sign_type 根据商户设置的私钥来决定
        order.sign_type = (rsa2PrivateKey.length > 1)?@"RSA2":@"RSA";
        
        // NOTE: 商品数据
        order.biz_content = [BizContent new];
        order.biz_content.body = model.body;
        order.biz_content.subject = model.payTitle;
        order.biz_content.out_trade_no = model.orderNo; //订单ID（
        order.biz_content.timeout_express = @"30m"; //超时时间设置
        order.biz_content.total_amount = model.price; //商品价格
        
        //将商品信息拼接成字符串
        NSString *orderInfo = [order orderInfoEncoded:NO];
        NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
//        NSLog(@"orderSpec = %@",orderInfo);
        
        // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
        //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
        NSString *signedString = nil;
        RSADataSigner* signer = [[RSADataSigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1) ? rsa2PrivateKey : rsaPrivateKey)];
        if ((rsa2PrivateKey.length > 1)) {
            NSString *str = [signer signString:orderInfo withRSA2:YES];
            signedString = str;
        } else {
            NSString *str = [signer signString:orderInfo withRSA2:NO];
            signedString = str;
        }
        
        // NOTE: 如果加签成功，则继续执行支付
        if (signedString != nil) {
            //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
            
            
            // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
            NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                     orderInfoEncoded, signedString];
            
            return orderString;
            //        // NOTE: 调用支付结果开始支付
            //        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            //            NSLog(@"reslut = %@",resultDic);
            //        }];
        }
    }
    return @"";
}

- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}
@end
