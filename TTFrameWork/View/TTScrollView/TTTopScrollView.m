//
//  TTTopScrollView.m
//  TT
//
//  Created by 张福润 on 2017/3/23.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "TTTopScrollView.h"

#import "TTContentScrollView.h"

#import "TTConst.h"

#import "UIView+TTSuperView.h"

//按钮ID
#define BUTTONID (sender.tag - 100)
//滑动ID
#define BUTTON_SELECTED_ID (_scrollViewSelectedChannelID - 100)

#define HEADERVIEW_HEIGHT 44

@interface TTTopScrollView()
@property (strong, nonatomic) UIView *slideLineView;
@property (assign, nonatomic) CGFloat btnGap;
@end

static TTTopScrollView *instance;

@implementation TTTopScrollView

+ (instancetype)shareInstance{
    return instance;
}

+ (instancetype)shareInstanceWithFrame:(CGRect)frame {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithFrame:frame];
    });
    return instance;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.pagingEnabled = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        [self initDefaultChannelID];
        
        self.buttonOriginXArray = [NSMutableArray array];
        self.buttonWidthArray = [NSMutableArray array];
    }
    return self;
}

- (void)initWithNameButtonsWithButtonFont:(UIFont *)btnFont buttonGap:(CGFloat)btnGap {
    [self clearAllSubviews];
    self.btnGap = btnGap;
    float xPos = 5.0f;
    NSInteger iHeaderNameCount = [self.headerNameArray count];
    UIColor *normalColor = RGBA_COLOR(234, 161, 161, 1);
    UIColor *selectedColor = [UIColor whiteColor];
    if (ISIPAD) {
        normalColor = RGBA_COLOR(102, 102, 102, 1);
        selectedColor = RGBA_COLOR(221, 0, 18, 1);
    }
    for (NSInteger i = 0; i < iHeaderNameCount; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *title = [self.headerNameArray objectAtIndex:i];
        [button setTag:i+100];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:normalColor forState:UIControlStateNormal];
        [button setTitleColor:selectedColor forState:UIControlStateSelected];
        button.titleLabel.font = btnFont;
        [button addTarget:self action:@selector(selectNameButton:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat buttonWidth = [title boundingRectWithSize:CGSizeMake(150, 30) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:button.titleLabel.font} context:nil].size.width;
        button.frame = CGRectMake(xPos, 0, buttonWidth + btnGap, HEADERVIEW_HEIGHT);
        [_buttonOriginXArray addObject:@(xPos)];
        xPos += buttonWidth + btnGap;
        [_buttonWidthArray addObject:@(button.frame.size.width)];
        [self addSubview:button];
        if (i == 0) {
            button.selected = YES;
            [self initDefaultChannelID];
        }
    }
    self.contentSize = CGSizeMake(xPos, HEADERVIEW_HEIGHT);
    CGRect frame = CGRectMake(5.0f, HEADERVIEW_HEIGHT - 2, [[_buttonWidthArray objectAtIndex:0] floatValue], 2);
    _slideLineView = [[UIView alloc] initWithFrame:frame];
    [_slideLineView setBackgroundColor:selectedColor];
    [self addSubview:_slideLineView];
}

- (void)initDefaultChannelID {
    _userSelectedChannelID = 100;
    _scrollViewSelectedChannelID = 100;
}

- (void)clearAllSubviews{
    [self setContentSize:CGSizeZero];
    [self setContentOffset:CGPointZero];
    _buttonWidthArray = [NSMutableArray array];
    _buttonOriginXArray = [NSMutableArray array];
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

- (void)selectNameButton:(UIButton *)sender{
    [self adjustScrollViewContentX:sender];
    
    UIButton *lastButton = (UIButton *)[self viewWithTag:_userSelectedChannelID];
    //如果更换按钮
    if (sender != lastButton) {
        //取之前的按钮
        lastButton.selected = NO;
        _userSelectedChannelID = sender.tag;
    }
    
    //按钮选中状态
    if (!sender.selected) {
        sender.selected = YES;
        [UIView animateWithDuration:0.25 animations:^{
            CGRect frame = CGRectMake(sender.frame.origin.x, HEADERVIEW_HEIGHT - 2, [[_buttonWidthArray objectAtIndex:BUTTONID] floatValue], 2);
            [_slideLineView setFrame:frame];
        } completion:^(BOOL finished) {
            if (finished) {
                //设置页出现
                //                CGRect bounds = [UIScreen mainScreen].bounds;
                //                CGRect frame = CGRectMake(0, 0, bounds.size.width, bounds.size.height);
                CGFloat contentPageWidth = [TTContentScrollView shareInstance].contentPageWidth;
                [[TTContentScrollView shareInstance] setContentOffset:CGPointMake(BUTTONID * contentPageWidth, 0) animated:YES];
                //赋值滑动列表选择频道ID
                _scrollViewSelectedChannelID = sender.tag;
            }
        }];
    }else{//重复点击选中按钮
    }
}

- (void)adjustScrollViewContentX:(UIButton *)sender{
    CGFloat originX = [[_buttonOriginXArray objectAtIndex:BUTTONID] floatValue];
    CGFloat width = [[_buttonWidthArray objectAtIndex:BUTTONID] floatValue];
    if (sender.frame.origin.x - self.contentOffset.x > self.width - (self.btnGap+width)) {
        [self setContentOffset:CGPointMake(originX - 30, 0) animated:YES];
    }
    
    if (sender.frame.origin.x - self.contentOffset.x < 5) {
        [self setContentOffset:CGPointMake(originX, 0) animated:YES];
    }
}

//滚动内容页顶部滚动
- (void)setButtonUnSelect{
    //滑动撤销选中按钮
    UIButton *lastButton = (UIButton *)[self viewWithTag:_scrollViewSelectedChannelID];
    lastButton.selected = NO;
    [_slideLineView removeFromSuperview];
}

- (void)setButtonSelect{
    //滑动选中按钮
    UIButton *button = (UIButton *)[self viewWithTag:_scrollViewSelectedChannelID];
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = CGRectMake(button.frame.origin.x, HEADERVIEW_HEIGHT - 2, [[_buttonWidthArray objectAtIndex:button.tag-100] floatValue], 2);
        [_slideLineView setFrame:frame];
    } completion:^(BOOL finished) {
        if (finished) {
            if (!button.selected) {
                UIButton *lastButton = (UIButton *)[self viewWithTag:_userSelectedChannelID];
                lastButton.selected = NO;
                button.selected = YES;
                _userSelectedChannelID = button.tag;
            }
        }
    }];
}

- (void)setScrollViewContentOffset {
    CGFloat originX = [[_buttonOriginXArray objectAtIndex:BUTTON_SELECTED_ID] floatValue];
    CGFloat width = [[_buttonWidthArray objectAtIndex:BUTTON_SELECTED_ID] floatValue];
    
    if (originX - self.contentOffset.x > self.width - (self.btnGap+width)) {
        [self setContentOffset:CGPointMake(originX - 30, 0) animated:YES];
    }
    
    if (originX - self.contentOffset.x < 5) {
        [self setContentOffset:CGPointMake(originX, 0) animated:YES];
    }
}

@end

