//
//  TTHUDMessage.m
//  TT
//
//  Created by 张福润 on 2017/3/3.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "TTHUDMessage.h"

#import "TTConst.h"
#import "MBProgressHUD.h"

NSString * const Loading            = @"Loading";
NSString * const Request_Loading    = @"正在加载%@数据";
NSString * const Upload_Loading     = @"正在上传%@";
NSString * const Delete_Loading     = @"正在删除%@";
NSString * const Send_Loading       = @"正在发送%@";

static MBProgressHUD *HUD;

static TTHUDMessage *instance;

@implementation TTHUDMessage
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

+ (void)showInView:(UIView *)view{
    [self showInView:view showText:Loading detailsText:EMPTY_STR];
}

+ (void)showInView:(UIView *)view showText:(NSString *)text {
    [self showInView:view showText:text detailsText:EMPTY_STR];
}

+ (void)showInView:(UIView *)view showDetailsText:(NSString *)detailsText {
    [self showInView:view showText:EMPTY_STR detailsText:detailsText];
}

+ (void)showInView:(UIView *)view showRequestText:(NSString *)text{
    NSString *requestStr = [NSString stringWithFormat:Request_Loading,text];
    [self showInView:view showText:requestStr];
}

+ (void)showInView:(UIView *)view showUploadText:(NSString *)text {
    NSString *uploadStr = [NSString stringWithFormat:Upload_Loading,text];
    [self showInView:view showText:uploadStr];
}

+ (void)showInView:(UIView *)view showDeleteText:(NSString *)text {
    NSString *deleteStr = [NSString stringWithFormat:Delete_Loading,text];
    [self showInView:view showText:deleteStr];
}

+ (void)showInView:(UIView *)view showSendText:(NSString *)text {
    NSString *sendStr = [NSString stringWithFormat:Send_Loading,text];
    [self showInView:view showText:sendStr];
}

+ (void)showInView:(UIView *)view showText:(NSString *)text detailsText:(NSString *)detailsText{
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        [self hideHUD];
    //        HUD =[MBProgressHUD showHUDAddedTo:view animated:YES];
    //        HUD.labelText = text;
    //        HUD.detailsLabelText = detailsText;
    //    });
    [self showCustomViewInView:view showText:text detailText:detailsText];
}

+ (void)showCustomViewInView:(UIView *)view showText:(NSString *)text detailText:(NSString *)detailText {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideHUD];
        NSUInteger capacity = 8;
        NSMutableArray<UIImage *> *imgs = [NSMutableArray arrayWithCapacity:capacity];
        NSInteger i = 0;
        do {
            NSString *imgName = [NSString stringWithFormat:@"B_%ld.png",i];
            
            [imgs addObject:[UIImage imageNamed:imgName]];
            i++;
        } while (i < 8);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        imageView.animationImages = [imgs copy];
        imgs = nil;
        imageView.animationRepeatCount = 0;
        imageView.animationDuration = 5.0;
        [imageView startAnimating];
        HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
        HUD.customView = imageView;
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.bezelView.color = [UIColor clearColor];
        HUD.margin = 10.0;
    });
}

+ (void)showInView:(UIView *)view showTextOnly:(NSString *)text {
    [self showInView:view showTextOnly:text completedBlock:nil];
}

+ (void)showInView:(UIView *)view showTextOnly:(NSString *)text completedBlock:(void (^)())completed {
    [self showInView:view showTextOnly:text detailText:nil textMargin:0 completedBlock:completed];
}

+ (void)showInView:(UIView *)view showTextOnly:(NSString *)text detailText:(NSString *)detailText textMargin:(float)margin {
    [self showInView:view showTextOnly:text detailText:detailText textMargin:margin completedBlock:nil];
}

+ (void)showInView:(UIView *)view showTextOnly:(NSString *)text detailText:(NSString *)detailText textMargin:(float)margin completedBlock:(void (^)())completed {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideHUD];
        [view endEditing:YES];
        HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
        HUD.label.text = text;
        HUD.detailsLabel.text = detailText;
        HUD.mode = MBProgressHUDModeText;
        HUD.margin = margin?:10.0f;
        HUD.removeFromSuperViewOnHide = YES;
        [HUD hideAnimated:YES afterDelay:2];
        if (completed) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                completed();
            });
        }
    });
}

+ (void)showCompletedText:(NSString *)text withCompletedType:(HUDShowCompletedType)completedType {
    [self showInView:KEY_WINDOW showCompletedText:text withCompletedType:completedType];
}

+ (void)showInView:(UIView *)view showCompletedText:(NSString *)text withCompletedType:(HUDShowCompletedType)completedType {
    [self showInView:view showCompletedText:text withCompletedType:completedType completedBlock:nil];
}

+ (void)showInView:(UIView *)view showCompletedText:(NSString *)text withCompletedType:(HUDShowCompletedType)completedType completedBlock:(void (^)())completed {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideHUD];
        [view endEditing:YES];
        HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
        HUD.mode = MBProgressHUDModeCustomView;
        NSString *fileName = @"hud_info.png";
        switch (completedType) {
            case HUDShowCompletedTypeInfo:
                fileName = @"hud_info.png";
                break;
            case HUDShowCompletedTypeCompleted:
                fileName = @"hud_completed.png";
                break;
            case HUDShowCompletedTypeError:
                fileName = @"hud_error.png";
                break;
        }
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:fileName]];
        HUD.label.text = text;
        HUD.margin = 10.0f;
        HUD.userInteractionEnabled = NO;
        HUD.removeFromSuperViewOnHide = YES;
        [HUD hideAnimated:YES afterDelay:2];
        if (completed) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                completed();
            });
        }
    });
}

+ (void)showInView:(UIView *)view showText:(NSString *)text progress:(float)progress {
    [self showInView:view showText:text progress:progress withProgressType:HUDShowProgressTypeDeterminate];
}

+ (void)showInView:(UIView *)view showText:(NSString *)text progress:(float)progress withProgressType:(HUDShowProgressType)progressType {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (HUD && HUD.mode == (MBProgressHUDMode)progressType) {
            HUD.progress = progress;
            HUD.label.text = [NSString stringWithFormat:@"%.2f%@",progress * 100,@"%"];
            HUD.detailsLabel.text = text;
        } else {
            [self hideHUD];
            HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
            HUD.mode = (MBProgressHUDMode)progressType;
            HUD.detailsLabel.text = text;
        }
    });
    
}

+ (void)showInView:(UIView *)view showText:(NSString *)text currentCount:(NSString *)currentCount totalCount:(NSString *)totalCount {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (HUD && HUD.mode == MBProgressHUDModeDeterminateHorizontalBar) {
            HUD.progress = currentCount.floatValue / totalCount.floatValue;
            HUD.label.text = [NSString stringWithFormat:@"%@/%@",currentCount,totalCount];
            HUD.detailsLabel.text = text;
        } else {
            [self hide];
            HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
            HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
            HUD.detailsLabel.text = text;
        }
    });
}

+ (void)updateShowText:(NSString *)text andDetailsText:(NSString *)detailsText inView:(UIView *)view withHUDTextType:(HUDShowTextType)hudTextType{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *showText = text;
        NSString *showDetailsText = detailsText;
        switch (hudTextType) {
            case HUDShowTextTypeRequestText:
                showText = [NSString stringWithFormat:Request_Loading,showText];
                break;
            case HUDShowTextTypeUploadText:
                showText = [NSString stringWithFormat:Upload_Loading,showText];
                break;
            case HUDShowTextTypeDeleteText:
                showText = [NSString stringWithFormat:Delete_Loading,showText];
                break;
            case HUDShowTextTypeSendText:
                showText = [NSString stringWithFormat:Send_Loading,showText];
                break;
            default:
                break;
        }
        HUD.label.text = showText;
        HUD.detailsLabel.text = showDetailsText;
    });
}

+ (void)hide{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideHUD];
    });
}

+ (void)hideHUD{
    if (HUD) {
        [HUD hideAnimated:YES];
        HUD = nil;
    }
}

+ (void)hideAllHUDInView:(UIView *)view{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:view animated:YES];
    });
}
@end
