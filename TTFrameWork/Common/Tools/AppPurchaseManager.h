//
//  AppPurchaseManager.h
//  TT
//
//  Created by 张福润 on 2017/4/6.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@class RechargePrice;

@interface AppPurchaseManager : NSObject
@property (assign, nonatomic, getter=isPurchaseing) BOOL purchaseing;

+ (instancetype)sharedInstance;

/**
 支付

 @param productId 支付的产品类型的id,在apple上面进行设置的id(这个传入的id要与自己设置的一致)
 @param view 添加的View
 */
- (void)requestProductData:(NSString *)productId addCurrentView:(UIView *)view;

/**
 取消支付
 */
- (void)removeTransaction;
@end

