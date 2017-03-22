//
//  TTAlertView.m
//  TT
//
//  Created by 张福润 on 2017/3/22.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "TTAlertView.h"


@interface TTAlertView ()<UIAlertViewDelegate>
@property (nonatomic, copy) AlertConfirmBlock alertConfirmBlock;
@property (nonatomic, copy) AlertCancelBlock  alertCancelBlock;
@property (nonatomic, copy) AlertCommonBlock  alertCommonBlock;
@end

@implementation TTAlertView

+ (void)alertViewTitle:(NSString *)title
               message:(NSString *)message
          confirmTitle:(NSString *)confirmTitle
           cancelBlock:(AlertCancelBlock)alertCancelBlock
          confirmBlock:(AlertConfirmBlock)alertConfirmBlock {
    TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:confirmTitle, nil];
    alertView.delegate = alertView;
    alertView.alertCancelBlock = alertCancelBlock;
    alertView.alertConfirmBlock = alertConfirmBlock;
    [alertView show];
}

+ (void)alertViewTitle:(NSString *)title
               message:(NSString *)message
           cancelTitle:(NSString *)cancelTitle
          confirmTitle:(NSString *)confirmTitle
           cancelBlock:(AlertCancelBlock)alertCancelBlock
          confirmBlock:(AlertConfirmBlock)alertConfirmBlock {
    TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:cancelTitle
                                              otherButtonTitles:confirmTitle, nil];
    alertView.delegate = alertView;
    alertView.alertCancelBlock = alertCancelBlock;
    alertView.alertConfirmBlock = alertConfirmBlock;
    [alertView show];
}

+ (void)alertViewTitle:(NSString *)title
               message:(NSString *)message
          confirmTitle:(NSString *)confirmTitle
           commonTitle:(NSString *)commonTitle
           cancelBlock:(AlertCancelBlock)alertCancelBlock
          confirmBlock:(AlertConfirmBlock)alertConfirmBlock
           commonBlock:(AlertCommonBlock)alertCommonBlock {
    TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:confirmTitle, commonTitle, nil];
    alertView.delegate = alertView;
    alertView.alertCancelBlock = alertCancelBlock;
    alertView.alertConfirmBlock = alertConfirmBlock;
    alertView.alertCommonBlock = alertCommonBlock;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if (self.alertCancelBlock) {
            self.alertCancelBlock();
        }
    } else if (buttonIndex == 1) {
        if (self.alertConfirmBlock) {
            self.alertConfirmBlock();
        }
    } else if (buttonIndex == 2) {
        if (self.alertCommonBlock) {
            self.alertCommonBlock();
        }
    }
}

@end
