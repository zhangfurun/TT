//
//  TTAlertView.h
//  TT
//
//  Created by 张福润 on 2017/3/22.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 该Alert是基于系统自带的UIAlertView进行的进一步封装
 */

typedef void(^AlertCancelBlock)();
typedef void(^AlertConfirmBlock)();
typedef void(^AlertCommonBlock)();

@interface TTAlertView : UIAlertView

+ (void)alertViewTitle:(NSString *)title
               message:(NSString *)message
          confirmTitle:(NSString *)confirmTitle
           cancelBlock:(AlertCancelBlock)alertCancelBlock
          confirmBlock:(AlertConfirmBlock)alertConfirmBlock;

+ (void)alertViewTitle:(NSString *)title
               message:(NSString *)message
           cancelTitle:(NSString *)cancelTitle
          confirmTitle:(NSString *)confirmTitle
           cancelBlock:(AlertCancelBlock)alertCancelBlock
          confirmBlock:(AlertConfirmBlock)alertConfirmBlock ;

+ (void)alertViewTitle:(NSString *)title
               message:(NSString *)message
          confirmTitle:(NSString *)confirmTitle
           commonTitle:(NSString *)commonTitle
           cancelBlock:(AlertCancelBlock)alertCancelBlock
          confirmBlock:(AlertConfirmBlock)alertConfirmBlock
           commonBlock:(AlertCommonBlock)alertCommonBlock;
@end
