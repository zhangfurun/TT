//
//  TTStarView.m
//  TT
//
//  Created by 张福润 on 2017/3/23.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "TTStarView.h"

@interface TTStarView ()

@property (nonatomic, strong) UIView *starBackgroundView;
@property (nonatomic, strong) UIView *starForegroundView;
@property (nonatomic, assign) CGFloat singleStarWidth;
@property (nonatomic, assign) BOOL allowHalfStar;

@end

@implementation TTStarView

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame numberOfStar:kNUMBER_OF_STAR allowHalfStar:YES];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _numberOfStar = kNUMBER_OF_STAR;
    _allowHalfStar = YES;
    [self commonInit];
}

/**
 *  初始化TTStarRatingView
 *
 *  @param frame         Rectangles
 *  @param allowHalfStar 是否允许有半颗星
 *
 *  @return TTStarRatingViewObject
 */
- (instancetype)initWithFrame:(CGRect)frame allowHalfStar:(BOOL)allowHalfStar {
    self = [super initWithFrame:frame];
    if (self) {
        _numberOfStar = kNUMBER_OF_STAR;
        _allowHalfStar = allowHalfStar;
        [self commonInit];
    }
    return self;
}

/**
 *  初始化TQStarRatingView
 *
 *  @param frame  Rectangles
 *  @param number 星星个数
 *
 *  @return TQStarRatingViewObject
 */
- (instancetype)initWithFrame:(CGRect)frame numberOfStar:(int)number allowHalfStar:(BOOL)allowHalfStar {
    self = [super initWithFrame:frame];
    if (self) {
        _numberOfStar = number;
        _allowHalfStar = allowHalfStar;
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.starBackgroundView = [self buidlStarViewWithImageName:kBACKGROUND_STAR];
    self.starForegroundView = [self buidlStarViewWithImageName:kFOREGROUND_STAR];
    [self addSubview:self.starBackgroundView];
    [self addSubview:self.starForegroundView];
    self.singleStarWidth = self.frame.size.width / _numberOfStar;
}

#pragma mark - Set Score

/**
 *  设置控件分数
 *
 *  @param score     分数，必须在 0 － 1 之间
 *  @param isAnimate 是否启用动画
 */
- (void)setScore:(float)score withAnimation:(bool)isAnimate {
    [self setScore:score withAnimation:isAnimate completion:^(BOOL finished){}];
}

/**
 *  设置控件分数
 *
 *  @param score      分数，必须在 0 － 1 之间
 *  @param isAnimate  是否启用动画
 *  @param completion 动画完成block
 */
- (void)setScore:(float)score withAnimation:(bool)isAnimate completion:(void (^)(BOOL finished))completion {
    NSAssert((score >= 0.0)&&(score <= 1.0), @"score must be between 0 and 1");
    
    if (score < 0) {
        score = 0;
    }
    
    if (score > 1) {
        score = 1;
    }
    
    CGPoint point = CGPointMake(score * self.frame.size.width, 0);
    
    if(isAnimate) {
        __weak __typeof(self)weakSelf = self;
        
        [UIView animateWithDuration:0.2 animations:^ {
             [weakSelf changeStarForegroundViewWithPoint:point];
             
         }completion:^(BOOL finished) {
             if (completion) {
                 completion(finished);
             }
         }];
    }else {
        [self changeStarForegroundViewWithPoint:point];
    }
}

#pragma mark - Touche Event
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    if(CGRectContainsPoint(rect,point))
    {
        [self changeStarForegroundViewWithPoint:point];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    __weak __typeof(self)weakSelf = self;
    
    [UIView animateWithDuration:0.2 animations:^
     {
         [weakSelf changeStarForegroundViewWithPoint:point];
     }];
}

#pragma mark - Buidl Star View

/**
 *  通过图片构建星星视图
 *
 *  @param imageName 图片名称
 *
 *  @return 星星视图
 */
- (UIView *)buidlStarViewWithImageName:(NSString *)imageName {
    CGRect frame = self.bounds;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.clipsToBounds = YES;
    for (int i = 0; i < self.numberOfStar; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = CGRectMake(i * frame.size.width / self.numberOfStar, 0, frame.size.width / self.numberOfStar, frame.size.height);
        [view addSubview:imageView];
    }
    return view;
}

#pragma mark - Change Star Foreground With Point

/**
 *  通过坐标改变前景视图
 *
 *  @param point 坐标
 */
- (void)changeStarForegroundViewWithPoint:(CGPoint)point {
    CGPoint p = point;
    
    if (p.x < 0) {
        p.x = 0;
    }
    
    if (p.x > self.frame.size.width) {
        p.x = self.frame.size.width;
    }
    
    NSString * str = [NSString stringWithFormat:@"%0.2f",p.x / self.frame.size.width];
    float score = [str floatValue];
    if (!self.allowHalfStar) {
        CGFloat oneScore = 1.0 / kNUMBER_OF_STAR;
        NSInteger time = round(score / oneScore);
        score = oneScore * time;
    }
    p.x = ceil(score * self.frame.size.width);
    self.starForegroundView.frame = CGRectMake(0, 0, p.x, self.frame.size.height);
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(starRatingView: score:)]) {
        [self.delegate starRatingView:self score:score];
    }
}

@end

