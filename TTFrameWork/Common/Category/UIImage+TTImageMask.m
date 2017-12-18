//
//  UIImage+TTImageMask.m
//  TT
//
//  Created by 张福润 on 2017/12/18.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "UIImage+TTImageMask.h"

@implementation UIImage (TTImageMask)
+ (UIImage *)imageAddTitleWithSubtitle:(NSString *)title attributes:(NSDictionary *)attributes withImage:(UIImage *)image InRect:(CGRect)rect {
    UIGraphicsBeginImageContext(image.size);
    
    [image drawAtPoint:CGPointZero];
    NSAttributedString *attr = [[NSAttributedString alloc]initWithString:title attributes:attributes];
    [attr drawInRect:rect];
    UIImage * watermarkImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return watermarkImage;
}

- (UIImage *)imageWithWaterMask:(UIImage*)mask inRect:(CGRect)rect {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0) {
        UIGraphicsBeginImageContextWithOptions([self size], NO, 0.0); // 0.0 for scale means "scale for device's main screen".
    }
#else
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 4.0) {
        UIGraphicsBeginImageContext([self size]);
    }
#endif
    
    //原图
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    //水印图
    [mask drawInRect:rect];
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newPic;
}

+ (UIImage *)getAppIconLogo {
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"]lastObject];
    UIImage *logo = [UIImage imageNamed:icon];
    return logo;
}

@end
