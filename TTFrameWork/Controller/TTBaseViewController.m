//
//  TTBaseViewController.m
//  TT
//
//  Created by 张福润 on 2017/4/6.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "TTBaseViewController.h"

#import "TTConst.h"

#import "UIDevice+TTDevice.h"

@interface TTBaseViewController ()

@end

@implementation TTBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (ISIPAD) {
        self.orientation = UIInterfaceOrientationMaskLandscape;
    }
    [self addNavigationTitle];
    
    //    [self.navigationItem setHidesBackButton:YES];
    if (_leftBtn) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_leftBtn];
    }
    if (_rightBtn) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
    } else if (_rightBtns && _rightBtns.count != 0) {
        NSMutableArray *rightBarBtns = [NSMutableArray array];
        NSInteger rightBtnCount = _rightBtns.count;
        for (NSInteger i = rightBtnCount - 1; i >= 0; i--) {
            UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtns[i]];
            [rightBarBtns addObject:btnItem];
        }
        self.navigationItem.rightBarButtonItems = rightBarBtns;
    }
    
    //如果UIScrollView或子类，不能滑动到顶部，ViewController中有一个UIScrollView或子类，发现大小不对(如底部不能靠底)时需要设置此属性为NO
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIInterfaceOrientationMask targetOrientation = self.isAllowRotate ? self.orientation : UIInterfaceOrientationMaskPortrait;
    [self setInterfaceOrientation:targetOrientation];
    [UIApplication sharedApplication].statusBarHidden = _hideStatusBar;
    [UIApplication sharedApplication].statusBarStyle = _statusBarStyleDefault ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
    self.navigationController.navigationBarHidden = _hideNavigationBar;
    [self.navigationController.navigationBar setBackgroundImage:_navBarColorChange ? nil : ([self scaleToSize:[UIImage imageNamed:@"nav_bg.png"] size:CGSizeMake(self.view.frame.size.width, 44)]) forBarMetrics:0];
}

//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    [self.navigationController.navigationBar setBackgroundImage:_navBarColorChange ? nil : ([self scaleToSize:[UIImage imageNamed:@"nav_bg.png"] size:CGSizeMake(self.view.frame.size.width, 44)]) forBarMetrics:0];
//}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self cancelAllRequest];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)shouldAutorotate {
    return self.isAllowRotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (ISIPAD) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return self.isAllowRotate ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return self.isAllowRotate;
}

- (void)dealloc {
    NSLog(@"%@ Do Dealloc",[[self class] classStr]);
}

#pragma mark - Property Method
- (UIColor *)navigationBarColor {
    if (_navigationBarColor) {
        return _navigationBarColor;
    }
    _navigationBarColor = [UIColor whiteColor];
    return _navigationBarColor;
}

- (void)setNavigationTitle:(NSString *)navigationTitle{
    _navigationTitle = navigationTitle;
    
    UILabel *titleLabel = (UILabel *)self.navigationItem.titleView;
    if ([titleLabel isKindOfClass:[UILabel class]]) {
        [titleLabel setText:_navigationTitle];
    }
}

- (BOOL)isAllowRotate {
    if (ISIPAD) {
        return self.orientation != UIInterfaceOrientationMaskLandscape;
    }
    return self.orientation != UIInterfaceOrientationUnknown && self.orientation != UIInterfaceOrientationMaskPortrait;
}

- (void)setOrientation:(UIInterfaceOrientationMask)orientation {
    _orientation = orientation;
    [self setInterfaceOrientation:orientation];
}

#pragma mark - Method
- (void)addNavigationTitle {
    self.navigationController.navigationBar.barTintColor = self.navigationBarColor;
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:0];
    self.navigationController.navigationBar.translucent = NO;
    if (_navigationTitle) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        [titleLabel setText:_navigationTitle];
        [titleLabel setFont:[UIFont systemFontOfSize:18.0f]];
        [titleLabel setTextColor:_navigationTitleColor?:[UIColor whiteColor]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        self.navigationItem.titleView = titleLabel;
    }
}

- (void)showBackBtn {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
    //    [backBtn setImage:[UIImage imageNamed:@"nav_back_tap.png"] forState:UIControlStateHighlighted];
    [backBtn setFrame:CGRectMake(0, 0, 35, 35)];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 10)];
    [backBtn addTarget:self action:@selector(onBackBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    self.leftBtn = backBtn;
}

- (void)onBackBtnTap:(UIButton *)sender {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:self.dismissBlock];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)destoryHandler {};

- (void)cancelAllRequest {}

+ (NSString *)classStr {
    return NSStringFromClass([self class]);
}

//强制转屏
- (void)setInterfaceOrientation:(UIInterfaceOrientationMask)orientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector  = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

//调整图片大小
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
