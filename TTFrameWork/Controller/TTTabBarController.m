//
//  TTTabBarController.m
//  TT
//
//  Created by 张福润 on 2017/4/6.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "TTTabBarController.h"

#import "UIView+TTSuperView.h"

@interface TTTabBarController ()

@end

@implementation TTTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideOriginalTabBar];
}

- (instancetype)initWithViewControllersClass:(NSArray *)classes {
    self = [super init];
    if (self) {
        [self setViewControllersWithClass:classes];
    }
    return self;
}

#pragma mark - Method
/**
 *  隐藏系统的TabBar
 */
- (void)hideOriginalTabBar {
    UIView *contentView;
    NSArray *subViews = self.view.subviews;
    if ([subViews[0] isKindOfClass:[UITabBar class]]) {
        contentView = subViews[1];
    }else{
        contentView = subViews[0];
    }
    contentView.height = [UIView keyWindow].height;
    for (UIView *view in subViews) {
        if ([view isKindOfClass:[UITabBar class]]) {
            view.alpha = 0;
            break;
        }
    }
}

- (void)setViewControllersWithClass:(NSArray *)classes {
    NSMutableArray *navViewControllers = [NSMutableArray array];
    for (Class class in classes) {
        UIViewController *viewController = [[class alloc] initWithNibName:NSStringFromClass(class) bundle:nil];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        [navViewControllers addObject:navigationController];
    }
    self.viewControllers = navViewControllers;
}

@end

@interface TTTabBarView () {
    UIButton *_currentBtn;
    TTTabBarController *_tabBarController;
    UINavigationController *_currentNavController;
}

@end

static TTTabBarView *_tabBarView = nil;

@implementation TTTabBarView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setShadowImage:[UIImage new] forToolbarPosition:UIBarPositionAny];
    [self setBackgroundImage:[UIImage new] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    self.width = [UIView keyWindow].width;
    NSArray *controllerClasses = [self getViewControllersClass];
    NSAssert([controllerClasses count] > 0, @"ViewControllers not set");
    _tabBarController = [[TTTabBarController alloc] initWithViewControllersClass:controllerClasses];
}

- (void)dealloc {
    _currentBtn = nil;
}

+ (instancetype)createTabBarView {
    [_tabBarView removeFromSuperview];
    _tabBarView = nil;
    
    _tabBarView = [self loadFromNib];
    [self selectedIndex:0];
    return _tabBarView;
}

+ (instancetype)getTabBarView {
    return _tabBarView;
}

+ (void)selectedIndex:(NSInteger)idx {
    for (UIView *view in _tabBarView.subviews) {
        if (view.tag == idx && [view isKindOfClass:[UIButton class]]) {
            [_tabBarView onButtonTouched:view];
            return;
        }
    }
}

- (void)onButtonTouched:(id)sender {
    _currentBtn.enabled = YES;
    _currentBtn = sender;
    _currentBtn.enabled = NO;
    
    _tabBarController.selectedIndex = _currentBtn.tag;
    UINavigationController *seletedNavController = _tabBarController.viewControllers[_currentBtn.tag];
    _currentNavController = seletedNavController;
    UIViewController *viewController = seletedNavController.viewControllers[0];
    self.bottom = viewController.view.height;
    [viewController.view addSubview:self];
}

- (TTTabBarController *)tabBarController {
    return _tabBarController;
}

- (UINavigationController *)currentNavigationController {
    return _currentNavController;
}

#pragma mark - SubClass
- (NSArray<Class> *)getViewControllersClass {return nil;};

@end

