//
//  FRAlertView.m
//  ComicPhoto
//
//  Created by 张福润 on 16/9/9.
//  Copyright © 2016年 com.ifenghui. All rights reserved.
//

#import "FRAlertView.h"

#import "ZZConst.h"

#define FR_width [UIScreen mainScreen].bounds.size.width
#define FR_height [UIScreen mainScreen].bounds.size.height

#define KEY_WINDOW  [[UIApplication sharedApplication].delegate window]

@interface FRAlertView ()
@property (nonatomic ,strong)UIView *FR_superView;
@property (nonatomic ,strong)UILabel *FR_messageLab;
@property (nonatomic ,strong)UIButton *FR_cancelBtn;
@property (nonatomic ,strong)UIButton *FR_confirmBtn;
@property (nonatomic ,strong)UILabel *FR_title;
@property (nonatomic ,assign)CGFloat scare;
@property (assign, nonatomic,getter=isHaveTitle)BOOL haveTitle;

@property (nonatomic, copy) AlertCancelBlock  alertCancelBlock;
@property (nonatomic, copy) AlertConfirmBlock  alertConfirmBlock;
@end

@implementation FRAlertView
+ (void)alertViewWithMessage:(NSString *)message
                confirmTitle:(NSString *)confirmTitle
                confirmBlock:(AlertConfirmBlock)alertConfirmBlock {
    [self alertViewAddView:KEY_WINDOW message:message confirmTitle:confirmTitle confirmBlock:alertConfirmBlock];
    
}

+ (void)alertViewAddView:(UIView *)view
                 message:(NSString *)message
            confirmTitle:(NSString *)confirmTitle
            confirmBlock:(AlertConfirmBlock)alertConfirmBlock {
    [self alertViewAddView:view title:nil message:message confirmTitle:confirmTitle confirmBlock:alertConfirmBlock];
}

+ (void)alertViewAddView:(UIView *)view
                   title:(NSString *)title
                 message:(NSString *)message
            confirmTitle:(NSString *)confirmTitle
            confirmBlock:(AlertConfirmBlock)alertConfirmBlock {
     [self alertViewAddView:view title:title message:message confirmTitle:confirmTitle cancelTitle:@"取消" confirmBlock:alertConfirmBlock cancelBlock:nil];
}

+ (void)alertViewAddView:(UIView *)view
                 message:(NSString *)message
            confirmTitle:(NSString *)confirmTitle
            confirmBlock:(AlertConfirmBlock)alertConfirmBlock
             cancelBlock:(AlertCancelBlock)alertCancelBlock {
    [self alertViewAddView:view title:nil message:message confirmTitle:confirmTitle cancelTitle:@"取消" confirmBlock:alertConfirmBlock cancelBlock:alertCancelBlock ];
}

+ (void)alertViewAddView:(UIView *)view
                   title:(NSString *)title
                 message:(NSString *)message
            confirmTitle:(NSString *)confirmTitle
             cancelTitle:(NSString *)cancelTitle
            confirmBlock:(AlertConfirmBlock)alertConfirmBlock
             cancelBlock:(AlertCancelBlock)alertCancelBlock {
    FRAlertView *alertView = [[FRAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds isTitle:(title != nil)];

    [alertView FRAlert_title:title message:message cancelTitle:cancelTitle confirmTitle:confirmTitle successBlock:alertConfirmBlock cancleBlock:alertCancelBlock];
    [view addSubview:alertView];
}

- (instancetype)initWithFrame:(CGRect)frame isTitle:(BOOL)isTitle {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        
        self.scare = ((isTitle ? 41.f : 0) + 91.f + 43.5f) / (270.f);
        self.haveTitle = isTitle;
        CGFloat aletyWidth = FR_width - 100;
        if (ISIPAD) {
            if (aletyWidth > 320) {
                aletyWidth = 320;
            }
        }
        self.FR_superView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, aletyWidth, aletyWidth * self.scare)];
        self.FR_superView.backgroundColor = [UIColor whiteColor];
        self.FR_superView.center = CGPointMake(FR_width/2.0,0);
        [UIView animateWithDuration:1 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.FR_superView.center = CGPointMake(FR_width/2.0,FR_height/2.0);
        } completion:^(BOOL finished) {
        }];
        self.FR_superView.layer.borderWidth = 1;
        self.FR_superView.layer.borderColor = [UIColor clearColor].CGColor;
        self.FR_superView.layer.cornerRadius = 10;
        self.FR_superView.clipsToBounds = YES;
        [self addSubview:self.FR_superView];
    }
    return self;
}

- (void)FRAlert_title:(NSString *)title
              message:(NSString *)message
          cancelTitle:(NSString *)cancelTitle
         confirmTitle:(NSString *)confirmTitle
         successBlock:(void (^)())successBlock
          cancleBlock:(void (^)())cancleBlock
{
    
    //    title
    if (title != nil) {
        self.FR_title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.FR_superView.frame.size.width, 40)];
        self.FR_title.text = title;
        self.FR_title.textColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0];
        self.FR_title.textAlignment = NSTextAlignmentCenter;
        self.FR_title.font = [UIFont systemFontOfSize:17];
        [self.FR_superView addSubview:self.FR_title];
        
        // line1
        UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.FR_title.frame), self.FR_superView.frame.size.width, 1)];
        line1.backgroundColor = [UIColor colorWithRed:236 / 255.0 green:236 / 255.0 blue:236 / 255.0 alpha:1];
        [self.FR_superView addSubview:line1];
    }
    //正文
    self.FR_messageLab = [[UILabel alloc]initWithFrame:CGRectMake(self.FR_superView.frame.size.width * 0.1, (self.isHaveTitle ? 41 : 0), self.FR_superView.frame.size.width * 0.8, self.FR_superView.frame.size.height * (91.f / (((self.isHaveTitle ? 41:0) + 91.f + 43.5f))))];
    self.FR_messageLab.text = message;
    self.FR_messageLab.textColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0];
    self.FR_messageLab.numberOfLines = 0;
    self.FR_messageLab.textAlignment  =NSTextAlignmentCenter;
    self.FR_messageLab.lineBreakMode = NSLineBreakByWordWrapping;
    self.FR_messageLab.font = [UIFont systemFontOfSize:15];
    [self.FR_superView addSubview:self.FR_messageLab];
    
    //line2
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.FR_messageLab.frame), self.FR_superView.frame.size.width, 1)];
    line1.backgroundColor = [UIColor colorWithRed:236 / 255.0 green:236 / 255.0 blue:236 / 255.0 alpha:1];
    [self.FR_superView addSubview:line1];
  
    
    //取消
    self.FR_cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.FR_cancelBtn setTitle:cancelTitle forState:UIControlStateNormal];
    [self.FR_cancelBtn setTitleColor:[UIColor colorWithRed:50 / 255.f green:50 / 255.f blue:50 / 255.f alpha:1] forState:UIControlStateNormal];
    self.FR_cancelBtn.frame = CGRectMake(0, CGRectGetMaxY(line1.frame) , self.FR_superView.frame.size.width/2 - 0.5, self.FR_superView.frame.size.height - self.FR_messageLab.frame.size.height - (self.isHaveTitle ? 41 : 0) - 1);
    self.FR_cancelBtn.layer.borderColor = [UIColor clearColor].CGColor;
    self.FR_cancelBtn.titleLabel.font = [UIFont systemFontOfSize: 16];
    self.FR_cancelBtn.layer.borderWidth = 1;
    self.FR_cancelBtn.layer.cornerRadius = 5;
    self.FR_cancelBtn.clipsToBounds = YES;
    [self.FR_superView addSubview:self.FR_cancelBtn];
    [self.FR_cancelBtn addTarget:self action:@selector(FR_Windowclose) forControlEvents:UIControlEventTouchUpInside];
    
    //line3
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.FR_cancelBtn.frame), CGRectGetMaxY(line1.frame) , 1, self.FR_cancelBtn.frame.size.height)];
    line2.backgroundColor = [UIColor colorWithRed:236 / 255.0 green:236 / 255.0 blue:236 / 255.0 alpha:1];
    [self.FR_superView addSubview:line2];
    
    //确定
    self.FR_confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.FR_confirmBtn setTitle:confirmTitle forState:UIControlStateNormal];
    [self.FR_confirmBtn setTitleColor:[UIColor colorWithRed:60 / 255.f green:196 / 255.f blue:255 / 255.f alpha:1] forState:UIControlStateNormal];
    self.FR_confirmBtn.frame = CGRectMake(self.FR_superView.frame.size.width/2 + 0.5, self.FR_cancelBtn.frame.origin.y, self.FR_superView.frame.size.width/2 - 0.5, self.FR_cancelBtn.frame.size.height);
    self.FR_confirmBtn.layer.borderColor = [UIColor clearColor].CGColor;
    self.FR_confirmBtn.titleLabel.font = [UIFont systemFontOfSize: 16];
    self.FR_confirmBtn.layer.borderWidth = 1;
    self.FR_confirmBtn.layer.cornerRadius = 5;
    self.FR_confirmBtn.clipsToBounds = YES;
    [self.FR_confirmBtn addTarget:self action:@selector(sureCompleted:) forControlEvents:UIControlEventTouchUpInside];
    [self.FR_superView addSubview:self.FR_confirmBtn];
    
 
    
    _alertConfirmBlock = successBlock;
    _alertCancelBlock = cancleBlock;

}

- (void)sureCompleted:(UIButton *)sender {
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.FR_superView.center = CGPointMake(FR_width/2.0,FR_height+300);
        [self setAlpha:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (_alertConfirmBlock) {
            _alertConfirmBlock();
        }
    }];
}

- (void)FR_Windowclose {
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.FR_superView.center = CGPointMake(FR_width / 2.0,FR_height+300);
        [self setAlpha:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (_alertCancelBlock) {
            _alertCancelBlock();
        }
    }];
}

@end
