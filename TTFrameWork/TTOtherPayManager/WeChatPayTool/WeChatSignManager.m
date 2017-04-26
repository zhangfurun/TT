//
//  WeChatSignManager.m
//  StoryShip
//
//  Created by 张福润 on 2017/4/24.
//  Copyright © 2017年 ifenghui. All rights reserved.
//

#import "WeChatSignManager.h"
#import "WeChatPayManagerHeader.h"

#import <CommonCrypto/CommonDigest.h>

@interface WeChatSignManager()

@property (nonatomic,copy)NSString *wechatAppId;    //微信开放平台AppId
@property (nonatomic,copy)NSString *wechatMCHId;    //微信商户号
@property (nonatomic,copy)NSString *tradeNo;        //随机字符串变量 这里最好使用和安卓端一致的生成逻辑
// 安全校验码（MD5）密钥，商户平台登录账户和密码登录http://pay.weixin.qq.com
// 平台设置的“API密钥”，为了安全，请设置为以数字和字母组成的32字符串。
@property (nonatomic,copy)NSString *wechatPartnerKey;
@property (nonatomic,copy)NSString *payTitle;       //支付标题
@property (nonatomic,copy)NSString *orderNo;        //随机产生订单号用于测试，正式使用请换成你从自己服务器获取的订单号
@property (nonatomic,copy)NSString *totalFee;       //总价格
@property (nonatomic,copy)NSString *deviceIp;       //设备Id地址
@property (nonatomic,copy)NSString *notifyUrl;      //交易结果通知网站此处用于测试，随意填写，正式使用时填写正确网站
@property (nonatomic,copy)NSString *tradeType;      //交易类型

@end

@implementation WeChatSignManager

#pragma mark - Life Cycle

- (instancetype)initWithWechatAppId:(NSString *)wechatAppId
                        wechatMCHId:(NSString *)wechatMCHId
                            tradeNo:(NSString *)tradeNo
                   wechatPartnerKey:(NSString *)wechatPartnerKey
                           payTitle:(NSString *)payTitle
                           orderNo :(NSString *)orderNo
                           totalFee:(NSString *)totalFee
                           deviceIp:(NSString *)deviceIp
                          notifyUrl:(NSString *)notifyUrl
                          tradeType:(NSString *)tradeType
{
    if (self = [super init]) {
        
        _wechatAppId        = wechatAppId;
        _wechatMCHId        = wechatMCHId;
        _tradeNo            = tradeNo;
        _wechatPartnerKey   = wechatPartnerKey;
        _payTitle           = payTitle;
        _orderNo            = orderNo;
        _totalFee           = totalFee;
        _deviceIp           = deviceIp;
        _notifyUrl          = notifyUrl;
        _tradeType          = tradeType;
        
        [self.dic setValue:_wechatAppId forKey:WX_APPID];
        [self.dic setValue:_wechatMCHId forKey:WX_MCHID];
        [self.dic setValue:_tradeNo     forKey:WX_NONCESTR];
        [self.dic setValue:_payTitle    forKey:WX_BODY];
        [self.dic setValue:_orderNo     forKey:WX_OUTTRADENO];
        [self.dic setValue:_totalFee    forKey:WX_TOTALFEE];
        [self.dic setValue:_deviceIp    forKey:WX_EQUIPMENTIP];
        [self.dic setValue:_notifyUrl   forKey:WX_NOTIFYURL];
        [self.dic setValue:_tradeType   forKey:WX_TRADETYPE];
        
        [self createMd5Sign:self.dic];
    }
    return self;
}

//创建签名
//签名算法
//签名生成的通用步骤如下：
-(void)createMd5Sign:(NSMutableDictionary*)dict
{
    NSMutableString *contentString  =[NSMutableString string];
    
    NSArray *keys = [dict allKeys];
    
    
    //第一步，设所有发送或者接收到的数据为集合M，将集合M内非空参数值的参数按照参数名ASCII码从小到大排序（字典序），使用URL键值对的格式（即key1=value1&key2=value2…）拼接成字符串stringA。
    //特别注意以下重要规则：
    //◆ 参数名ASCII码从小到大排序（字典序）；
    //◆ 如果参数的值为空不参与签名；
    //◆ 参数名区分大小写；
    //◆ 验证调用返回或微信主动通知签名时，传送的sign参数不参与签名，将生成的签名与该sign值作校验。
    //◆ 微信接口可能增加字段，验证签名时必须支持增加的扩展字段
    
    //1.按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    //2.拼接字符串
    for (NSString *categoryId in sortedArray) {
        
        if (   ![dict[categoryId] isEqualToString:@""]
            && ![dict[categoryId] isEqualToString:@"sign"]
            && ![dict[categoryId] isEqualToString:@"key"])
        {
            [contentString appendFormat:@"%@=%@&", categoryId, dict[categoryId]];
        }
    }
    
    //第二步，在stringA最后拼接上key得到stringSignTemp字符串，并对stringSignTemp进行MD5运算，再将得到的字符串所有字符转换为大写，得到sign值signValue。
    //key设置路径：微信商户平台(pay.weixin.qq.com)-->账户设置-->API安全-->密钥设置
    //添加商户密钥key字段
    [contentString appendFormat:@"key=%@",_wechatPartnerKey];
    
    //MD5 获取Sign签名
    NSString *md5Sign =[self md5:contentString];
    
    
    [self.dic setValue:md5Sign forKey:@"sign"];
}

//创建发起支付时的sign签名
-(NSString *)createMD5SingForPay:(NSString *)appid_key
                       partnerid:(NSString *)partnerid_key
                        prepayid:(NSString *)prepayid_key
                         package:(NSString *)package_key
                        noncestr:(NSString *)noncestr_key
                       timestamp:(UInt32)timestamp_key
{
    NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
    [signParams setObject:appid_key forKey:WX_APPID];
    [signParams setObject:noncestr_key forKey:@"noncestr"];
    [signParams setObject:package_key forKey:@"package"];
    [signParams setObject:partnerid_key forKey:@"partnerid"];
    [signParams setObject:prepayid_key forKey:@"prepayid"];
    [signParams setObject:[NSString stringWithFormat:@"%u",(unsigned int)timestamp_key] forKey:@"timestamp"];
    
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [signParams allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[signParams objectForKey:categoryId] isEqualToString:@""]
            && ![[signParams objectForKey:categoryId] isEqualToString:WX_SIGN]
            && ![[signParams objectForKey:categoryId] isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [signParams objectForKey:categoryId]];
        }
    }

    //添加商户密钥key字段
    [contentString appendFormat:@"key=%@", WECHAT_PARTNER_KEY];
    
    NSString *result = [self md5:contentString];
    
    return result;
}


// MD5加密算法
-(NSString *) md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    //加密规则，因为逗比微信没有出微信支付demo，这里加密规则是参照安卓demo来得
    unsigned char result[16]= "0123456789abcdef";
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    //这里的x是小写则产生的md5也是小写，x是大写则md5是大写，这里只能用大写，逗比微信的大小写验证很逗
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

#pragma makr - Getter and Setter

- (NSMutableDictionary *)dic
{
    if (!_dic) {
        _dic = [NSMutableDictionary dictionary];
    }
    return _dic;
}
@end

