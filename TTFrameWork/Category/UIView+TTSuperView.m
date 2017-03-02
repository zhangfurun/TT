//
//  UIView+TTSuperView.m
//  TT
//
//  Created by 张福润 on 2017/2/27.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "UIView+TTSuperView.h"

#import "TTConst.h"

#import <objc/runtime.h>


NSTimeInterval const animateDuration = 0.25;

typedef void(^VoidBlock)();

@interface UIView ()
@property (nonatomic, copy) VoidBlock coverViewTouchBlock;
@end

@implementation UIView (TTSuperView)

#pragma mark - X
- (void)setX:(CGFloat)x {
    [self setX:x withAnimate:NO];
}

-(CGFloat)x{
    return self.frame.origin.x;
}

- (CGRect)newFrameWithX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    return frame;
}

- (void)setX:(CGFloat)x withAnimate:(BOOL)animate {
    [self setX:x withAnimate:animate completion:nil];
}

- (void)setX:(CGFloat)x withAnimate:(BOOL)animate completion:(void (^)(BOOL))completion {
    if (animate) {
        [self setX:x withAnimate:animate animateDuration:animateDuration completion:completion];
    }else{
        self.frame = [self newFrameWithX:x];
        if (completion) {
            completion(YES);
        }
    }
}

- (void)setX:(CGFloat)x withAnimate:(BOOL)animate animateDuration:(NSTimeInterval)duration completion:(void (^)(BOOL))completion{
    CGRect frame = [self newFrameWithX:x];
    [UIView animateWithDuration:duration animations:^{
        self.frame = frame;
    } completion:completion];
}

#pragma mark - Y
- (void)setY:(CGFloat)y{
    [self setY:y withAnimate:NO];
}

-(CGFloat)y{
    return self.frame.origin.y;
}

- (CGRect)newFrameWithY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    return frame;
}

- (void)setY:(CGFloat)y withAnimate:(BOOL)animate {
    [self setY:y withAnimate:animate completion:nil];
}

- (void)setY:(CGFloat)y withAnimate:(BOOL)animate completion:(void (^)(BOOL))completion {
    if (animate) {
        [self setY:y withAnimate:animate animateDuration:animateDuration completion:completion];
    }else{
        self.frame = [self newFrameWithY:y];
        if (completion) {
            completion(YES);
        }
    }
}

- (void)setY:(CGFloat)y withAnimate:(BOOL)animate animateDuration:(NSTimeInterval)duration completion:(void (^)(BOOL))completion {
    CGRect frame = [self newFrameWithY:y];
    [UIView animateWithDuration:duration animations:^{
        self.frame = frame;
    } completion:completion];
    
}

#pragma mark - Width
- (void)setWidth:(CGFloat)width {
    [self setWidth:width withAnimate:NO];
}

- (CGFloat)width{
    return self.frame.size.width;
}

- (CGRect)newFrameWithWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    return frame;
}

- (void)setWidth:(CGFloat)width withAnimate:(BOOL)animate {
    [self setWidth:width withAnimate:animate completion:nil];
}

- (void)setWidth:(CGFloat)width withAnimate:(BOOL)animate completion:(void (^)(BOOL))completion {
    if (animate) {
        [self setWidth:width withAnimate:animate animateDuration:animateDuration completion:completion];
    }else{
        self.frame = [self newFrameWithWidth:width];
        if (completion) {
            completion(YES);
        }
    }
}

- (void)setWidth:(CGFloat)width withAnimate:(BOOL)animate animateDuration:(NSTimeInterval)duration completion:(void (^)(BOOL))completion {
    CGRect frame = [self newFrameWithWidth:width];
    [UIView animateWithDuration:duration animations:^{
        self.frame = frame;
    } completion:completion];
}

#pragma mark - Height
- (void)setHeight:(CGFloat)height {
    [self setHeight:height withAnimate:NO];
}

- (CGFloat)height{
    return self.frame.size.height;
}

- (CGRect)newFrameWithHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    return frame;
}

- (void)setHeight:(CGFloat)height withAnimate:(BOOL)animate {
    [self setHeight:height withAnimate:animate completion:nil];
}

- (void)setHeight:(CGFloat)height withAnimate:(BOOL)animate completion:(void (^)(BOOL))completion {
    if (animate) {
        [self setHeight:height withAnimate:animate animateDuration:animateDuration completion:completion];
    }else{
        self.frame = [self newFrameWithHeight:height];
        if (completion) {
            completion(YES);
        }
    }
}

- (void)setHeight:(CGFloat)height withAnimate:(BOOL)animate animateDuration:(NSTimeInterval)duration completion:(void (^)(BOOL))completion {
    CGRect frame = [self newFrameWithHeight:height];
    [UIView animateWithDuration:duration animations:^{
        self.frame = frame;
    } completion:completion];
}

#pragma mark - CenterX
- (void)setCenterX:(CGFloat)centerX {
    [self setCenterX:centerX withAnimate:NO];
}

- (CGFloat)centerX{
    return self.center.x;
}

- (CGPoint)newCenterWithCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    return center;
}

- (void)setCenterX:(CGFloat)centerX withAnimate:(BOOL)animate {
    [self setCenterX:centerX withAnimate:animate completion:nil];
}

- (void)setCenterX:(CGFloat)centerX withAnimate:(BOOL)animate completion:(void (^)(BOOL))completion {
    if (animate) {
        [self setCenterX:centerX withAnimate:animate animateDuration:animateDuration completion:completion];
    }else{
        self.center = [self newCenterWithCenterX:centerX];
        if (completion) {
            completion(YES);
        }
    }
}

- (void)setCenterX:(CGFloat)centerX withAnimate:(BOOL)animate animateDuration:(NSTimeInterval)duration completion:(void (^)(BOOL))completion {
    CGPoint center = [self newCenterWithCenterX:centerX];
    [UIView animateWithDuration:duration animations:^{
        self.center = center;
    } completion:completion];
}

#pragma mark - CenterY
- (void)setCenterY:(CGFloat)centerY {
    [self setCenterY:centerY withAnimate:NO];
}

- (CGFloat)centerY{
    return self.center.y;
}

- (CGPoint)newCenterWithCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    return center;
}

- (void)setCenterY:(CGFloat)centerY withAnimate:(BOOL)animate {
    [self setCenterY:centerY withAnimate:animate completion:nil];
}

- (void)setCenterY:(CGFloat)centerY withAnimate:(BOOL)animate completion:(void (^)(BOOL))completion {
    if (animate) {
        [self setCenterY:centerY withAnimate:animate animateDuration:animateDuration completion:completion];
    }else{
        self.center = [self newCenterWithCenterY:centerY];
        if (completion) {
            completion(YES);
        }
    }
}

- (void)setCenterY:(CGFloat)centerY withAnimate:(BOOL)animate animateDuration:(NSTimeInterval)duration completion:(void (^)(BOOL))completion {
    CGPoint center = [self newCenterWithCenterY:centerY];
    [UIView animateWithDuration:duration animations:^{
        self.center = center;
    } completion:completion];
}

#pragma mark - Top
- (void)setTop:(CGFloat)top {
    [self setY:top];
}

- (CGFloat)top{
    return self.y;
}

- (void)setTop:(CGFloat)top withAnimate:(BOOL)animate {
    [self setY:top withAnimate:animate];
}

- (void)setTop:(CGFloat)top withAnimate:(BOOL)animate completion:(void (^)(BOOL))completion {
    [self setTop:top withAnimate:animate animateDuration:animateDuration completion:completion];
}

- (void)setTop:(CGFloat)top withAnimate:(BOOL)animate animateDuration:(NSTimeInterval)duration completion:(void (^)(BOOL))completion {
    [self setY:top withAnimate:animate animateDuration:duration completion:completion];
}

#pragma mark - Right
- (void)setRight:(CGFloat)right {
    [self setRight:right withAnimate:NO];
}

- (CGFloat)right{
    return self.x + self.width;
}

- (CGRect)newFrameWithRight:(CGFloat)right{
    CGRect frame = self.frame;
    frame.origin.x = right - self.width;
    return frame;
}

- (void)setRight:(CGFloat)right withAnimate:(BOOL)animate {
    [self setRight:right withAnimate:animate completion:nil];
}

- (void)setRight:(CGFloat)right withAnimate:(BOOL)animate completion:(void (^)(BOOL))completion {
    if (animate) {
        [self setRight:right withAnimate:animate animateDuration:animateDuration completion:completion];
    }else{
        self.frame = [self newFrameWithRight:right];
        if (completion) {
            completion(YES);
        }
    }
}

- (void)setRight:(CGFloat)right withAnimate:(BOOL)animate animateDuration:(NSTimeInterval)duration completion:(void (^)(BOOL))completion {
    CGRect frame = [self newFrameWithRight:right];
    [UIView animateWithDuration:duration animations:^{
        self.frame = frame;
    } completion:completion];
}

#pragma mark - Botton
- (void)setBottom:(CGFloat)bottom {
    [self setBottom:bottom withAnimate:NO];
}

- (CGFloat)bottom{
    return self.y + self.height;
}

- (CGRect)newFrameWithBotton:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - self.height;;
    return frame;
}

- (void)setBottom:(CGFloat)bottom withAnimate:(BOOL)animate {
    [self setBottom:bottom withAnimate:animate completion:nil];
}

- (void)setBottom:(CGFloat)bottom withAnimate:(BOOL)animate completion:(void (^)(BOOL))completion {
    if (animate) {
        [self setBottom:bottom withAnimate:animate animateDuration:animateDuration completion:completion];
    }else{
        self.frame = [self newFrameWithBotton:bottom];
        if (completion) {
            completion(YES);
        }
    }
}

- (void)setBottom:(CGFloat)bottom withAnimate:(BOOL)animate animateDuration:(NSTimeInterval)duration completion:(void (^)(BOOL))completion {
    CGRect frame = [self newFrameWithBotton:bottom];
    [UIView animateWithDuration:duration animations:^{
        self.frame = frame;
    } completion:completion];
}

#pragma mark - Left
- (void)setLeft:(CGFloat)left {
    [self setX:left];
}

- (CGFloat)left{
    return self.x;
}

- (void)setLeft:(CGFloat)left withAnimate:(BOOL)animate {
    [self setX:left withAnimate:animate];
}

- (void)setLeft:(CGFloat)left withAnimate:(BOOL)animate completion:(void (^)(BOOL))completion {
    [self setLeft:left withAnimate:animate animateDuration:animateDuration completion:completion];
}

- (void)setLeft:(CGFloat)left withAnimate:(BOOL)animate animateDuration:(NSTimeInterval)duration completion:(void (^)(BOOL))completion {
    [self setX:left withAnimate:animate animateDuration:duration completion:completion];
}

#pragma mark - Size
- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

#pragma mark - Layer
- (void)setLayerCornerRadius{
    [self setLayerCornerRadiusWithRadius:self.height/2];
}

- (void)setLayerCornerRadiusWithRadius:(CGFloat)radius {
    self.layer.cornerRadius = radius;
    self.clipsToBounds = YES;
}

- (void)setBorderWidth:(CGFloat)width borderColor:(CGColorRef)borderColor isCirCle:(BOOL)isCircle {
    [self setBorderWidth:width borderColor:borderColor radius:isCircle ? (self.height / 2) : 0];
}

- (void)setBorderWidth:(CGFloat)width borderColor:(CGColorRef)borderColor radius:(CGFloat)radius {
    self.layer.borderWidth = width;
    self.layer.borderColor = borderColor;
    [self setLayerCornerRadiusWithRadius:radius];
}

#pragma mark - UIWindow&UIScreen
+ (UIWindow *)keyWindow {
    return KEY_WINDOW;
}

+ (UIScreen *)mainScreen {
    return MAIN_SCREEN;
}

+ (CGRect)mainScreenBounds {
    return MAIN_SCREEN.bounds;
}

#pragma mark - LoadFromNib
+ (id)loadFromNib {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

+ (NSString *)ClassStr {
    return NSStringFromClass([self class]);
}

#pragma mark - RotateAnimation
- (void)rotateAnimation {
    self.transform = CGAffineTransformRotate(self.transform, (M_2_PI / 180.0));
    [self performSelector:@selector(rotateAnimation) withObject:nil afterDelay:0.01];
}

- (void)startRotationWithDisableViews:(NSArray *)disableViews {
    for (UIView *aView in disableViews) {
        aView.userInteractionEnabled = NO;
        aView.alpha = 0.7;
    }
    self.userInteractionEnabled = NO;
    [self rotateAnimation];
}

- (void)stopRotationDisableViews:(NSArray *)disableViews {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rotateAnimation) object:nil];
    self.transform = CGAffineTransformIdentity;
    self.userInteractionEnabled = YES;
    for (UIView *aView in disableViews) {
        aView.userInteractionEnabled = YES;
        aView.alpha = 1;
    }
}

#pragma mark - UIGestureRecognizers
- (void)removeAllGesture {
    NSArray *allGeses = [self gestureRecognizers];
    for (UIGestureRecognizer *ges in allGeses) {
        [self removeGestureRecognizer:ges];
    }
}

#pragma mark - ShowView
- (void)showInViewWithZoom:(UIView *)aView {
    [aView addSubview:self];
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    self.center = aView.center;
    self.alpha = 0;
    [UIView animateWithDuration:animateDuration animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
    }];
}

- (void)removeWithZoomFromView:(UIView *)aView completion:(void(^)(BOOL finished))completion {
    [UIView animateWithDuration:animateDuration animations:^{
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (completion) {
            completion(finished);
            [self removeFromSuperview];
        }
    }];
}

static char c_CoverviewTouchBlockKey;
- (void)setCoverViewTouchBlock:(void (^)())coverViewTouchBlock {
    objc_setAssociatedObject(self, &c_CoverviewTouchBlockKey, coverViewTouchBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (VoidBlock)coverViewTouchBlock {
    return objc_getAssociatedObject(self, &c_CoverviewTouchBlockKey);
}

- (UIView *)showViewInSuperView:(UIView *)superView withCompletedBlock:(void(^)())completedblock {
    return [self showViewInSuperView:superView withCoverViewTouchBlock:nil completedBlock:completedblock];
}

- (UIView *)showViewInSuperView:(UIView *)superView withCoverViewTouchBlock:(void(^)())touchBlock completedBlock:(void(^)())completedblock {
    return [self showViewInSuperView:superView frame:CGRectZero withCoverViewBgColor:[UIColor blackColor] alpha:0.4 coverViewTouchEnable:touchBlock!=nil coverViewTouchBlock:touchBlock completedBlock:completedblock];
}

- (UIView *)showViewInSuperView:(UIView *)superView frame:(CGRect)frame withCoverViewBgColor:(UIColor *)bgColor alpha:(CGFloat)alpha coverViewTouchEnable:(BOOL)enable coverViewTouchBlock:(void(^)())touchBlock completedBlock:(void(^)())completedBlock {
    CGRect coverFrame = frame;
    if (frame.size.width == 0 && frame.size.height == 0) {
        coverFrame = superView.bounds;
    }
    UIView *coverView = [[UIView alloc] initWithFrame:coverFrame];
    coverView.backgroundColor = [bgColor colorWithAlphaComponent:alpha];
    coverView.userInteractionEnabled = enable;
    
    if (enable && touchBlock) {
        [self setCoverViewTouchBlock:touchBlock];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverViewTap:)];
        [coverView addGestureRecognizer:tapGes];
    }
    [superView addSubview:coverView];
    if (completedBlock) {
        completedBlock();
    }
    return coverView;
}

- (void)pushInView:(UIView *)aView completion:(void(^)(BOOL finished))completion {
    [aView addSubview:self];
    [self setX:aView.width];
    [self setCenterY:aView.centerY];
    [self setCenterX:aView.centerX withAnimate:YES animateDuration:animateDuration completion:completion];
}

- (void)popFromView:(UIView *)aView completion:(void(^)(BOOL finished))completion {
    [self setX:aView.width withAnimate:YES animateDuration:animateDuration completion:completion];
}

- (void)setAlpha:(CGFloat)alpha isAnimation:(BOOL)isAnimation duration:(NSTimeInterval)duration completionBlock:(void(^)())completion {
    if (isAnimation) {
        [UIView animateWithDuration:duration animations:^{
            [self setAlpha:alpha];
        } completion:^(BOOL finished) {
            if (finished) {
                if (completion) {
                    completion();
                }
            }
        }];
    } else {
        [self setAlpha:alpha];
    }
}

#pragma mark - Selector
- (void)coverViewTap:(UITapGestureRecognizer *)tapGes {
    if (self.coverViewTouchBlock) {
        self.coverViewTouchBlock();
    }
}

#pragma mark - 绘制
/**
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
+ (CAShapeLayer *)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    
    //设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    
    //设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    
    //设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    
    //设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(lineView.frame), 0);
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    //把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
    return shapeLayer;
}

+ (CAShapeLayer *)drawDashedBorderAroundView:(UIView *)lineView cornerRadius:(CGFloat)cornerRadius lineWidth:(CGFloat)lineWidth lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor*)lineColor {
    
    //drawing
    CGRect frame = lineView.bounds;
    
    CAShapeLayer *_shapeLayer = [CAShapeLayer layer];
    
    //creating a path
    CGMutablePathRef path = CGPathCreateMutable();
    
    //drawing a border around a view
    CGPathMoveToPoint(path, NULL, frame.size.width - cornerRadius * sin(M_PI_4 * 0.5) , frame.size.height - cornerRadius * sin(M_PI_4 * 0.5));
    CGPathAddArc(path, NULL, frame.size.width - cornerRadius, frame.size.height - cornerRadius, cornerRadius, M_PI_4, M_PI_2, NO);
    CGPathAddLineToPoint(path, NULL, cornerRadius, frame.size.height);
    CGPathAddArc(path, NULL, cornerRadius, frame.size.height - cornerRadius, cornerRadius, M_PI_2, M_PI, NO);
    CGPathAddLineToPoint(path, NULL, 0, cornerRadius);
    CGPathAddArc(path, NULL, cornerRadius, cornerRadius, cornerRadius, M_PI, -M_PI_2, NO);
    CGPathAddLineToPoint(path, NULL, frame.size.width - cornerRadius, 0);
    CGPathAddArc(path, NULL, frame.size.width - cornerRadius, cornerRadius, cornerRadius, -M_PI_2, 0, NO);
    CGPathAddLineToPoint(path, NULL, frame.size.width, frame.size.height - cornerRadius);
    CGPathAddArc(path, NULL, frame.size.width - cornerRadius, frame.size.height - cornerRadius, cornerRadius, 0, M_PI_4, NO);
    
    //path is set as the _shapeLayer object's path
    _shapeLayer.path = path;
    CGPathRelease(path);
    
    _shapeLayer.backgroundColor = [[UIColor clearColor] CGColor];
    _shapeLayer.frame = frame;
    _shapeLayer.masksToBounds = NO;
    [_shapeLayer setValue:[NSNumber numberWithBool:NO] forKey:@"isCircle"];
    _shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    _shapeLayer.strokeColor = [lineColor CGColor];
    _shapeLayer.lineWidth = lineWidth;
    _shapeLayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil];
    _shapeLayer.lineCap = kCALineCapRound;
    
    //_shapeLayer is added as a sublayer of the view, the border is visible
    [lineView.layer addSublayer:_shapeLayer];
    lineView.layer.cornerRadius = cornerRadius;
    return _shapeLayer;
}

#pragma mark - Autoresizing
- (void)setAutoresizeMaskAll {
    self.autoresizingMask =
    UIViewAutoresizingFlexibleBottomMargin|
    UIViewAutoresizingFlexibleHeight|
    UIViewAutoresizingFlexibleLeftMargin|
    UIViewAutoresizingFlexibleRightMargin|
    UIViewAutoresizingFlexibleTopMargin|
    UIViewAutoresizingFlexibleWidth;
}


@end
