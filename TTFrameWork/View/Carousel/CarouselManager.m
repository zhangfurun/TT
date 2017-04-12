//
//  CarouselManager.m
//  StoryShip
//
//  Created by 张福润 on 2017/3/10.
//  Copyright © 2017年 ifenghui. All rights reserved.
//

#import "CarouselManager.h"

#import "TTConst.h"

#import "UIImageView+WebCache.h"
#import "UIView+TTSuperView.h"

@interface CarouselManager ()<iCarouselDataSource, iCarouselDelegate>
@property (strong, nonatomic) iCarousel *carousel;

@property (nonatomic, strong) NSTimer *timer;
@property (assign, nonatomic, getter=isWrap) BOOL wrap;
@property (strong, nonatomic) UIPageControl *pageControl;
@end

@implementation CarouselManager

#pragma mark - Public Methods
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super init]) {
        
        self.wrap = YES;
        self.carouselView = [[UIView alloc] initWithFrame:frame];
        self.carousel = [[iCarousel alloc] initWithFrame:self.carouselView.bounds];
        
        self.carousel.delegate = self;
        self.carousel.dataSource = self;
        self.type = iCarouselTypeRotary;
        self.carousel.scrollSpeed = 6;
        self.carousel.pagingEnabled = YES;
        
        [self.carouselView addSubview:self.carousel];
        
        self.pageControl = [[UIPageControl alloc] init];
        self.pageControl.numberOfPages = _dataArray.count;
        self.pageControl.currentPageIndicatorTintColor = RGBA_COLOR(54,154,231, 1);
        self.pageControl.pageIndicatorTintColor = RGBA_COLOR(205,206,207, 1);
        
        self.pageControl.center = CGPointMake(self.carouselView.centerX, self.carouselView.height - 10);
        
        self.imageViewType = UIViewContentModeScaleToFill;
        self.imageViewSize = CGSizeMake((self.carouselView.height - 45) * 3, self.carouselView.height - 45);
        
        [self.carouselView addSubview:self.pageControl];
        
        [self addTimer];
        
    }
    return self;
}

- (void)reloadWithFrame:(CGRect)frame {
    self.carouselView.frame = frame;
    self.carousel.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height - 15);
    self.pageControl.center = CGPointMake(self.carouselView.centerX, self.carouselView.height - 10);
    self.imageViewSize = CGSizeMake((self.carouselView.height - 45) * 3, self.carouselView.height - 45);
    [self.carousel reloadData];
}


#pragma mark - Selector
- (void)nextImage {
    NSInteger index = self.carousel.currentItemIndex + 1;
    if (index == _dataArray.count ) {
        index = 0;
    }
    
    [self.carousel scrollToItemAtIndex:index
                              animated:YES];
}

- (void)removeTimer {
    [self.timer invalidate];
}

#pragma mark - Private Methods
-(void)addTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                  target:self
                                                selector:@selector(nextImage)
                                                userInfo:nil
                                                 repeats:YES];
    //添加到runloop中
    [[NSRunLoop mainRunLoop]addTimer:self.timer
                             forMode:NSRunLoopCommonModes];
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    
    self.pageControl.numberOfPages = dataArray.count;
    [self.carousel reloadData];
}

- (void)setType:(iCarouselType)type{
    _type = type;
    
    self.carousel.type = type;
}

#pragma mark - iCarouselDelegate
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    
    return _dataArray.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    //create new view if no view is available for recycling
    if (view == nil)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, self.imageViewSize.width, self.imageViewSize.height)];
        imageView.contentMode = self.imageViewType;
        imageView.layer.masksToBounds = YES;
        NSString *str = _dataArray[index];
        if ([str hasPrefix:@"http"]) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil options:SDWebImageRetryFailed];
        }else{
            imageView.image = [UIImage imageNamed:str];
        }
        view = imageView;
    }
    return view;
}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return self.wrap;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.05;
        }
        case iCarouselOptionFadeMax:
        {
            if (self.carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0;
            }
            return value;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
    }
}

#pragma mark - Click Delegate
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    if (self.clickAction) {
        self.clickAction(index,self.dataArray);
    }
}

#pragma marl - Scroll Delegate
- (void)carouselDidScroll:(iCarousel *)carousel; {
    switch (self.dataCount) {
        case 0:
            break;
        case 1:{
            self.pageControl.currentPage = 0;
        }
            break;
        case 2:{
            self.pageControl.currentPage = carousel.currentItemIndex % self.dataCount;
        }
            break;
        default:{
            self.pageControl.currentPage = carousel.currentItemIndex;
        }
            break;
    }
}

- (void)carouselWillBeginDragging:(iCarousel *)carousel{
    [self removeTimer];
}

- (void)carouselDidEndDragging:(iCarousel *)carousel
                willDecelerate:(BOOL)decelerate{
    //    开启定时器
    [self addTimer];
}

@end
