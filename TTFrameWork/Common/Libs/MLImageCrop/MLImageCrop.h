//
//  MLImageCrop.h
//  ImageSelectAndCrop
//
//  Created by molon on 14-1-16.
//  Copyright (c) 2014年 Molon. All rights reserved.
//
//自定义截图比例，支持旋转，注意返回的不是固定Size的，而是固定比例的，Size是根据原图片和截取位置而定
//截取时候图片会自动调整到Up方向。
//必须有UIImageView+AFNetworking支持
#import <UIKit/UIKit.h>

@protocol MLImageCropDelegate <NSObject>

- (void)cropImage:(UIImage*)cropImage forOriginalImage:(UIImage*)originalImage;

@end

@interface MLImageCrop : UIViewController

//下面俩哪个后面设置，即是哪个有效
@property(nonatomic,strong) UIImage *image;

@property(nonatomic,weak) id<MLImageCropDelegate> delegate;
@property(nonatomic,assign) CGFloat ratioOfWidthAndHeight; //截取比例，宽高比

- (void)showWithAnimation:(BOOL)animation;

@end
