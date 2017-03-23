//
//  MLImageCrop.m
//  ImageSelectAndCrop
//
//  Created by molon on 14-1-16.
//  Copyright (c) 2014年 Molon. All rights reserved.
//

#import "MLImageCrop.h"

#define kDefualRatioOfWidthAndHeight 1.0f

@interface UIImage (MLImageCrop_Addition)

//将根据所定frame来截取图片
- (UIImage*)MLImageCrop_imageByCropForRect:(CGRect)targetRect;
- (UIImage *)MLImageCrop_fixOrientation;
@end

@implementation UIImage (MLImageCrop_Addition)


- (UIImage *)MLImageCrop_fixOrientation {
    
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    UIImageOrientation io = self.imageOrientation;
    if (io == UIImageOrientationDown || io == UIImageOrientationDownMirrored) {
        transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
        transform = CGAffineTransformRotate(transform, M_PI);
    }else if (io == UIImageOrientationLeft || io == UIImageOrientationLeftMirrored) {
        transform = CGAffineTransformTranslate(transform, self.size.width, 0);
        transform = CGAffineTransformRotate(transform, M_PI_2);
    }else if (io == UIImageOrientationRight || io == UIImageOrientationRightMirrored) {
        transform = CGAffineTransformTranslate(transform, 0, self.size.height);
        transform = CGAffineTransformRotate(transform, -M_PI_2);
        
    }
    
    if (io == UIImageOrientationUpMirrored || io == UIImageOrientationDownMirrored) {
        transform = CGAffineTransformTranslate(transform, self.size.width, 0);
        transform = CGAffineTransformScale(transform, -1, 1);
    }else if (io == UIImageOrientationLeftMirrored || io == UIImageOrientationRightMirrored) {
        transform = CGAffineTransformTranslate(transform, self.size.height, 0);
        transform = CGAffineTransformScale(transform, -1, 1);
        
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    
    if (io == UIImageOrientationLeft || io == UIImageOrientationLeftMirrored || io == UIImageOrientationRight || io == UIImageOrientationRightMirrored) {
        CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
    }else{
        CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (UIImage*)MLImageCrop_imageByCropForRect:(CGRect)targetRect
{
    targetRect.origin.x*=self.scale;
    targetRect.origin.y*=self.scale;
    targetRect.size.width*=self.scale;
    targetRect.size.height*=self.scale;

    if (targetRect.origin.x<0) {
        targetRect.origin.x = 0;
    }
    if (targetRect.origin.y<0) {
        targetRect.origin.y = 0;
    }
    
    //宽度高度过界就删去
    CGFloat cgWidth = CGImageGetWidth(self.CGImage);
    CGFloat cgHeight = CGImageGetHeight(self.CGImage);
    if (CGRectGetMaxX(targetRect)>cgWidth) {
        targetRect.size.width = cgWidth-targetRect.origin.x;
    }
    if (CGRectGetMaxY(targetRect)>cgHeight) {
        targetRect.size.height = cgHeight-targetRect.origin.y;
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, targetRect);
    UIImage *resultImage=[UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    //修正回原scale和方向
    resultImage = [UIImage imageWithCGImage:resultImage.CGImage scale:self.scale orientation:self.imageOrientation];
    
    return resultImage;
}

@end


@interface MLImageCrop ()<UIScrollViewDelegate>

@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIView *overlayView; //中心截取区域的View

@property(nonatomic,strong) UIImageView *imageView;

@property(nonatomic,strong) UIWindow *actionWindow;

//其他View
@property(nonatomic,strong) UIView *topBlackView;
@property(nonatomic,strong) UIView *bottomBlackView;
@property(nonatomic,strong) UIView *buttonBackgroundView;
@property(nonatomic,strong) UIButton *cancelButton;
@property(nonatomic,strong) UIButton *confirmButton;

@end

@implementation MLImageCrop

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.ratioOfWidthAndHeight = kDefualRatioOfWidthAndHeight;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    //设置frame,这里需要设置下，这样其会在最下层
    self.scrollView.frame = self.view.bounds;
    self.overlayView.layer.borderColor = [UIColor colorWithWhite:0.966 alpha:1.000].CGColor;
    
    //绘制上下两块灰色区域
    [self.view addSubview:self.topBlackView = [self acquireBlackTransparentOverlayView]];
    [self.view addSubview:self.bottomBlackView = [self acquireBlackTransparentOverlayView]];
    
    //绘制底部按钮的背景View
    UIView *buttonBackgroundView = [[UIView alloc]init];
    buttonBackgroundView.userInteractionEnabled = NO;
    buttonBackgroundView.backgroundColor = [UIColor darkGrayColor];
    buttonBackgroundView.layer.opacity = 0.8f;
    [self.view addSubview:self.buttonBackgroundView = buttonBackgroundView];
    
    //绘制俩button
    [self.view addSubview:self.cancelButton = [self acquireCustomButtonWithTitle:@"取消" andAction:@selector(onCancel:)]];
    [self.view addSubview:self.confirmButton = [self acquireCustomButtonWithTitle:@"确认" andAction:@selector(onConfirm:)]];
    
    
    //双击事件
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.scrollView addGestureRecognizer:doubleTap];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark create view helper
- (UIView*)acquireBlackTransparentOverlayView
{
    UIView *view = [[UIView alloc]init];
    view.userInteractionEnabled = NO;
    view.backgroundColor = [UIColor blackColor];
    view.layer.opacity = 0.25f;
    return view;
}

- (UIButton *)acquireCustomButtonWithTitle:(NSString*)title andAction:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.exclusiveTouch = YES;
    return button;
}

#pragma mark - show
- (void)showWithAnimation:(BOOL)animation
{
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.opaque = YES;
    window.windowLevel = UIWindowLevelStatusBar+1.0f;
    window.rootViewController = self;
    [window makeKeyAndVisible];
    self.actionWindow = window;
    
    if (animation) {
        self.actionWindow.layer.opacity = .01f;
        [UIView animateWithDuration:0.35f animations:^{
            self.actionWindow.layer.opacity = 1.0f;
        }];
    }
}

#pragma mark - event
- (void)disappear
{
    //退出
    [UIView animateWithDuration:0.35f animations:^{
        self.actionWindow.layer.opacity = 0.01f;
    } completion:^(BOOL finished) {
        [self.actionWindow removeFromSuperview];
        [self.actionWindow resignKeyWindow];
        self.actionWindow = nil;
    }];
}

- (void)onCancel:(id)sender
{
    [self disappear];
}

- (void)onConfirm:(id)sender
{
    if (!self.imageView.image) {
        return;
    }
    //不稳定下来，不让动
    if (self.scrollView.tracking||self.scrollView.dragging||self.scrollView.decelerating||self.scrollView.zoomBouncing||self.scrollView.zooming){
        return;
    }
    //根据区域来截图
    CGPoint startPoint = [self.overlayView convertPoint:CGPointZero toView:self.imageView];
    CGPoint endPoint = [self.overlayView convertPoint:CGPointMake(CGRectGetMaxX(self.overlayView.bounds), CGRectGetMaxY(self.overlayView.bounds)) toView:self.imageView];
    
    //这里找到的点其实是imageView在zoomScale为1的时候的实际点，而zoomScale为1的时候imageView.frame.size并不一定是实际的图片size，所以需要修正
//    _pr(CGRectMake(startPoint.x, startPoint.y, (endPoint.x-startPoint.x), (endPoint.y-startPoint.y)));
    //zoomScale为1的时候的imageFrame
//    _pr(CGRectMake(self.imageView.frame.origin.x/self.scrollView.zoomScale, self.imageView.frame.origin.y/self.scrollView.zoomScale, self.imageView.frame.size.width/self.scrollView.zoomScale, self.imageView.frame.size.height/self.scrollView.zoomScale));
    
    //这里获取的是实际宽度和zoomScale为1的frame宽度的比例
    CGFloat wRatio = self.imageView.image.size.width/(self.imageView.frame.size.width/self.scrollView.zoomScale);
    CGFloat hRatio = self.imageView.image.size.height/(self.imageView.frame.size.height/self.scrollView.zoomScale);
    CGRect cropRect = CGRectMake(startPoint.x*wRatio, startPoint.y*hRatio, (endPoint.x-startPoint.x)*wRatio, (endPoint.y-startPoint.y)*hRatio);
    
//    _pr(cropRect);
    
    [self disappear];
    
    UIImage *cropImage = [self.imageView.image MLImageCrop_imageByCropForRect:cropRect];
    if (self.delegate && [self.delegate respondsToSelector:@selector(cropImage:forOriginalImage:)]){
        [self.delegate cropImage:cropImage forOriginalImage:self.image];
    }
}

#pragma mark - tap
- (void)handleDoubleTap:(UITapGestureRecognizer *)tap {
    CGPoint touchPoint = [tap locationInView:self.scrollView];
	if (self.scrollView.zoomScale == self.scrollView.minimumZoomScale) { //除去最小的时候双击最大，其他时候都还原成最小
        [self.scrollView zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
	} else {
		[self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES]; //还原
	}
}

#pragma mark - getter or setter

- (void)setImage:(UIImage *)image
{
    if ([image isEqual:_image]) {
        return;
    }
    _image = image;
    self.imageView.image = [image MLImageCrop_fixOrientation];
    if (self.isViewLoaded) {
        [self.view setNeedsLayout];
    }
}


- (void)setRatioOfWidthAndHeight:(CGFloat)ratioOfWidthAndHeight
{
    if (ratioOfWidthAndHeight<=0) {
        ratioOfWidthAndHeight = kDefualRatioOfWidthAndHeight;
    }
    if (ratioOfWidthAndHeight==_ratioOfWidthAndHeight) {
        return;
    }
    _ratioOfWidthAndHeight = ratioOfWidthAndHeight;
    //重绘
    if (self.isViewLoaded) {
        [self.view setNeedsLayout];
    }
}

- (UIView*)overlayView
{
    if (!_overlayView) {
        _overlayView = [[UIView alloc]init];
        _overlayView.layer.borderColor = [UIColor whiteColor].CGColor;
        _overlayView.layer.borderWidth = 1.0f;
        _overlayView.userInteractionEnabled = NO;
        [self.view addSubview:_overlayView];
    }
    return _overlayView;
}

- (UIScrollView*)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.exclusiveTouch = YES; //防止被触摸的时候还去触摸其他按钮，当然其防不住减速时候的弹跳黑框等特殊的，在onConfirm里面处理了
        _scrollView.delegate = self;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIImageView*)imageView
{
    if (!_imageView) {
		_imageView = [[UIImageView alloc] init];
		_imageView.contentMode = UIViewContentModeScaleAspectFit;
        //                _imageView.backgroundColor = [UIColor yellowColor];
		[self.scrollView addSubview:_imageView];
    }
    return _imageView;
}

#pragma mark - other
//判断是否是以宽度为基准来截取
- (BOOL)isBaseOnWidthOfOverlayView
{
    //这里最好不要用＝＝判断，因为是CGFloat类型
    if (self.overlayView.frame.size.width < self.view.bounds.size.width) {
        return NO;
    }
    return YES;
}

#pragma mark - layout

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.view sendSubviewToBack:self.scrollView];
    //修正frame
    
    //底部按钮背景View
#define kButtonViewHeight 50
    self.buttonBackgroundView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds)-kButtonViewHeight, CGRectGetWidth(self.view.bounds),kButtonViewHeight);
    //底部俩按钮
#define kButtonWidth 50
    self.cancelButton.frame = CGRectMake(15, CGRectGetMinY(self.buttonBackgroundView.frame), kButtonWidth, kButtonViewHeight);
    self.confirmButton.frame = CGRectMake(CGRectGetWidth(self.buttonBackgroundView.frame)-kButtonWidth-15, CGRectGetMinY(self.buttonBackgroundView.frame), kButtonWidth, kButtonViewHeight);
    
    //scrollView
    //重置下
    self.scrollView.minimumZoomScale = 1.0f;
    self.scrollView.maximumZoomScale = self.scrollView.minimumZoomScale;
    self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
    self.scrollView.frame = self.view.bounds;
    
    //overlayView
    //根据宽度找高度
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = width/self.ratioOfWidthAndHeight;
    BOOL isBaseOnWidth = YES;
    if (height>self.view.bounds.size.height) {
        //超过屏幕了那就只能是，高度定死，宽度修正
        height = self.view.bounds.size.height;
        width = height*self.ratioOfWidthAndHeight;
        isBaseOnWidth = NO;
    }
    self.overlayView.frame = CGRectMake(0, 0, width, height);
    self.overlayView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    
    //上下黑色覆盖View
    if (isBaseOnWidth) {
        //上和下
        self.topBlackView.frame = CGRectMake(0, 0, width, CGRectGetMinY(self.overlayView.frame));
        self.bottomBlackView.frame = CGRectMake(0, CGRectGetMaxY(self.overlayView.frame), width, CGRectGetHeight(self.view.bounds)-CGRectGetMaxY(self.overlayView.frame));
    }else{
        //左和右
        self.topBlackView.frame = CGRectMake(0, 0, CGRectGetMinX(self.overlayView.frame), height);
        self.bottomBlackView.frame = CGRectMake(CGRectGetMaxX(self.overlayView.frame),0, CGRectGetWidth(self.view.bounds)-CGRectGetMaxX(self.overlayView.frame), height);
    }
    
    //imageView的frame和scrollView的内容
    [self adjustImageViewFrameAndScrollViewContent];
}

#pragma mark - adjust image frame and scrollView's  content
- (void)adjustImageViewFrameAndScrollViewContent
{
    CGRect frame = self.scrollView.frame;
    if (self.imageView.image) {
        CGSize imageSize = self.imageView.image.size;
        CGRect imageFrame = CGRectMake(0, 0, imageSize.width, imageSize.height);
        
        if (frame.size.width<=frame.size.height) {
            //说白了就是竖屏时候
            CGFloat ratio = frame.size.width/imageFrame.size.width;
            imageFrame.size.height = imageFrame.size.height*ratio;
            imageFrame.size.width = frame.size.width;
        }else{
            CGFloat ratio = frame.size.height/imageFrame.size.height;
            imageFrame.size.width = imageFrame.size.width*ratio;
            imageFrame.size.height = frame.size.height;
        }
        
        self.scrollView.contentSize = frame.size;
        
        BOOL isBaseOnWidth = [self isBaseOnWidthOfOverlayView];
        if (isBaseOnWidth) {
            self.scrollView.contentInset = UIEdgeInsetsMake(CGRectGetMinY(self.overlayView.frame), 0, CGRectGetHeight(self.view.bounds)-CGRectGetMaxY(self.overlayView.frame), 0);
        }else{
            self.scrollView.contentInset = UIEdgeInsetsMake(0, CGRectGetMinX(self.overlayView.frame), 0, CGRectGetWidth(self.view.bounds)-CGRectGetMaxX(self.overlayView.frame));
        }
        
        self.imageView.frame = imageFrame;
        
        //初始化,让其不会有黑框出现
        CGFloat minScale = self.overlayView.frame.size.height/imageFrame.size.height;
        CGFloat minScale2 = self.overlayView.frame.size.width/imageFrame.size.width;
        minScale = minScale>minScale2?minScale:minScale2;
        
        self.scrollView.minimumZoomScale = minScale;
        self.scrollView.maximumZoomScale = self.scrollView.minimumZoomScale*3<2.0f?2.0f:self.scrollView.minimumZoomScale*3;
        self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
        
        //调整下让其居中
        if (isBaseOnWidth) {
            CGFloat offsetY = (self.scrollView.bounds.size.height > self.scrollView.contentSize.height)?
            (self.scrollView.bounds.size.height - self.scrollView.contentSize.height) * 0.5 : 0.0;
            self.scrollView.contentOffset = CGPointMake(0, -offsetY);
        }else{
            CGFloat offsetX = (self.scrollView.bounds.size.width > self.scrollView.contentSize.width)?
            (self.scrollView.bounds.size.width - self.scrollView.contentSize.width) * 0.5 : 0.0;
            self.scrollView.contentOffset = CGPointMake(-offsetX,0);
        }
    }else{
        frame.origin = CGPointZero;
        self.imageView.frame = frame;
        //重置内容大小
        self.scrollView.contentSize = self.imageView.frame.size;
        
        self.scrollView.minimumZoomScale = 1.0f;
        self.scrollView.maximumZoomScale = self.scrollView.minimumZoomScale; //取消缩放功能
        self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
    }
}


#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return self.imageView;
}

#pragma mark - rotate
//- (BOOL)shouldAutorotate
//{
//    return NO; //不让旋转，默认竖屏对齐
//}
//
//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait; //如果shouldAutorotate返回YES，这里就有用了，状态栏等其他会旋转但是不影响self.view
//}
@end
