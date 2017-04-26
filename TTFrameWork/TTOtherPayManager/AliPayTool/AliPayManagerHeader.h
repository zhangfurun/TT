//
//  AliPayManagerHeader.h
//  StoryShip
//
//  Created by 张福润 on 2017/4/24.
//  Copyright © 2017年 ifenghui. All rights reserved.
//

#ifndef AliPayManagerHeader_h
#define AliPayManagerHeader_h

#pragma mark - AliSDK
#import <AlipaySDK/AlipaySDK.h>

#import "Order.h"

#import "APAuthV2Info.h"

#import "RSADataSigner.h"

#pragma mark - StoryShip
#import "TTConst.h"

/**
 支付sdk参数信息
 */
#define ALI_PAY_APPID           ALIPAYAPPID                 // appid
#define ALI_PAY_PRIVATEKEY      ALIPAYPRIVATEKEY            // privateid

#define ALIPAYURLNAME @"tt_alipay"

#endif /* AliPayManagerHeader_h */
