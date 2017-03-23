//
//  FRAlertView.h
//  ComicPhoto
//
//  Created by 张福润 on 16/9/9.
//  Copyright © 2016年 com.ifenghui. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^AlertCancelBlock)();
typedef void(^AlertConfirmBlock)();

@interface FRAlertView : UIView
+ (void)alertViewWithMessage:(NSString *)message
                confirmTitle:(NSString *)confirmTitle
                confirmBlock:(AlertConfirmBlock)alertConfirmBlock;

+ (void)alertViewAddView:(UIView *)view
                 message:(NSString *)message
            confirmTitle:(NSString *)confirmTitle
            confirmBlock:(AlertConfirmBlock)alertConfirmBlock;

+ (void)alertViewAddView:(UIView *)view
                   title:(NSString *)title
                 message:(NSString *)message
            confirmTitle:(NSString *)confirmTitle
            confirmBlock:(AlertConfirmBlock)alertConfirmBlock;

+ (void)alertViewAddView:(UIView *)view
                 message:(NSString *)message
            confirmTitle:(NSString *)confirmTitle
            confirmBlock:(AlertConfirmBlock)alertConfirmBlock
             cancelBlock:(AlertCancelBlock)alertCancelBlock;

+ (void)alertViewAddView:(UIView *)view
                   title:(NSString *)title
                 message:(NSString *)message
            confirmTitle:(NSString *)confirmTitle
             cancelTitle:(NSString *)cancelTitle
            confirmBlock:(AlertConfirmBlock)alertConfirmBlock
             cancelBlock:(AlertCancelBlock)alertCancelBlock ;
@end
