//
//  TTHUDMessage.h
//  TT
//
//  Created by 张福润 on 2017/3/3.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HUDShowTextType) {
    HUDShowTextTypeNone,
    HUDShowTextTypeText,
    HUDShowTextTypeDetailsText,
    HUDShowTextTypeRequestText,
    HUDShowTextTypeUploadText,
    HUDShowTextTypeDeleteText,
    HUDShowTextTypeSendText
};

typedef enum : NSUInteger {
    /// UIActivityIndicatorView.
    HUDShowProgressTypeIndeterminate,
    /// A round, pie-chart like, progress view.
    HUDShowProgressTypeDeterminate,
    /// Horizontal progress bar.
    HUDShowProgressTypeDeterminateHorizontalBar,
    /// Ring-shaped progress view.
    HUDShowProgressTypeAnnularDeterminate,
    /// Shows a custom view.
    HUDShowProgressTypeCustomView,
    /// Shows only labels.
    HUDShowProgressTypeText
} HUDShowProgressType;

typedef enum : NSUInteger {
    HUDShowCompletedTypeInfo,
    HUDShowCompletedTypeCompleted,
    HUDShowCompletedTypeError,
} HUDShowCompletedType;


@interface TTHUDMessage : NSObject
+ (void)showInView:(UIView *)view;
+ (void)showInView:(UIView *)view showText:(NSString *)text;
+ (void)showInView:(UIView *)view showDetailsText:(NSString *)detailsText;
+ (void)showInView:(UIView *)view showRequestText:(NSString *)text;
+ (void)showInView:(UIView *)view showUploadText:(NSString *)text;
+ (void)showInView:(UIView *)view showDeleteText:(NSString *)text;
+ (void)showInView:(UIView *)view showSendText:(NSString *)text;
+ (void)showInView:(UIView *)view showText:(NSString *)text detailsText:(NSString *)detailsText;
+ (void)showInView:(UIView *)view showTextOnly:(NSString *)text;
+ (void)showInView:(UIView *)view showTextOnly:(NSString *)text completedBlock:(void(^)())completed;
+ (void)showInView:(UIView *)view showTextOnly:(NSString *)text detailText:(NSString *)detailText textMargin:(float)margin;
+ (void)showInView:(UIView *)view showTextOnly:(NSString *)text detailText:(NSString *)detailText textMargin:(float)margin completedBlock:(void(^)())completed;
+ (void)showCompletedText:(NSString *)text withCompletedType:(HUDShowCompletedType)completedType;
+ (void)showInView:(UIView *)view showCompletedText:(NSString *)text withCompletedType:(HUDShowCompletedType)completedType;
+ (void)showInView:(UIView *)view showCompletedText:(NSString *)text withCompletedType:(HUDShowCompletedType)completedType completedBlock:(void(^)())completed;
+ (void)showInView:(UIView *)view showText:(NSString *)text progress:(float)progress;
+ (void)showInView:(UIView *)view showText:(NSString *)text progress:(float)progress withProgressType:(HUDShowProgressType)progressType;
+ (void)showInView:(UIView *)view showText:(NSString *)text currentCount:(NSString *)currentCount totalCount:(NSString *)totalCount;
+ (void)updateShowText:(NSString *)text andDetailsText:(NSString *)detailsText inView:(UIView *)view withHUDTextType:(HUDShowTextType)hudTextType;
+ (void)hide;
+ (void)hideAllHUDInView:(UIView *)view;
@end

//@interface TTHUDMessage : NSObject
//
//@end
