//
//  WeChatPayManagerHeader.h
//  StoryShip
//
//  Created by 张福润 on 2017/4/24.
//  Copyright © 2017年 ifenghui. All rights reserved.
//

#ifndef WeChatPayManagerHeader_h
#define WeChatPayManagerHeader_h


#import "WXApi.h"
#import "WeChatSignManager.h"   //微信签名工具类
#import "XMLDictionary.h"       //XML转换工具类

#import "TTConst.h"

/**
 微信支付需要配置的参数
 */

#define WECHAT_APP_ID           WECHATAPPIDKEY      // 开放平台登录https://open.weixin.qq.com的开发者中心获取APPID
#define WECHAT_APP_SECRETKEY    WECHATAPPSECRETKEY  // 开放平台登录https://open.weixin.qq.com的开发者中心获取AppSecret。
#define WECHAT_PARTNER_ID       WECHATPARTNERID     // 微信支付商户号
#define WECHAT_PARTNER_KEY      WECHATPARTNERKEY    // 安全校验码（MD5）密钥，商户平台登录账户和密码登录http://pay.weixin.qq.com
// 平台设置的“API密钥”，为了安全，请设置为以数字和字母组成的32字符串。
/**
 * 微信下单接口
 */
#define kUrlWechatPay       @"https://api.mch.weixin.qq.com/pay/unifiedorder"

/**
 * 统一下单请求参数键值
 */

#define WX_APPID         @"appid"            // 应用id
#define WX_MCHID         @"mch_id"           // 商户号
#define WX_NONCESTR      @"nonce_str"        // 随机字符串
#define WX_SIGN          @"sign"             // 签名
#define WX_BODY          @"body"             // 商品描述
#define WX_OUTTRADENO    @"out_trade_no"     // 商户订单号
#define WX_TOTALFEE      @"total_fee"        // 总金额
#define WX_EQUIPMENTIP   @"spbill_create_ip" // 终端IP
#define WX_NOTIFYURL     @"notify_url"       // 通知地址
#define WX_TRADETYPE     @"trade_type"       // 交易类型
#define WX_PREPAYID      @"prepay_id"        // 预支付交易会话

/**
 * PayManager 需要设置的判断信息
 */
#define WECHATURLNAME @"tt_wxpay"

#define TIP_CALLBACKURL         @"url地址不能为空！"                 // 回调url地址为空
#define TIP_ORDERMESSAGE        @"订单信息不能为空！"                // 订单信息为空字符串或者nil
#define TIP_URLTYPE             @"请先在Info.plist 添加 URL Type"  // 没添加 URL Types
#define TIP_URLTYPE_SCHEME(name) [NSString stringWithFormat:@"请先在Info.plist 的 URL Type 添加 %@ 对应的 URL Scheme",name]// 添加了 URL Types 但信息不全

#endif /* WeChatPayManagerHeader_h */
