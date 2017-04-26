//
//  APAuthV2Info.h
//  AliSDKDemo
//
//  Created by 亦澄 on 16-8-12.
//  Copyright (c) 2016年 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APAuthV2Info : NSObject

/*********************************授权必传参数*********************************/

//服务接口名称，常量com.alipay.account.auth。
@property (nonatomic, copy) NSString *apiname;

//调用方app标识 ，mc代表外部商户。
@property (nonatomic, copy) NSString *appName;

//调用业务类型，openservice代表开放基础服务
@property (nonatomic, copy) NSString *bizType;

//产品码，目前只有WAP_FAST_LOGIN
@property (nonatomic, copy) NSString *productID;


//签约平台内的appid
@property (nonatomic, copy) NSString *appID;

//商户签约id
@property (nonatomic, copy) NSString *pid;

//授权类型,AUTHACCOUNT:授权;LOGIN:登录
@property (nonatomic, copy) NSString *authType;

//商户请求id需要为unique,回调使用
@property (nonatomic, copy) NSString *targetID;


/*********************************授权可选参数*********************************/

//oauth里的授权范围，PD配置,默认为kuaijie
@property (nonatomic, copy) NSString *scope;

//固定值，alipay.open.auth.sdk.code.get
@property (nonatomic, copy) NSString *method;

@end
