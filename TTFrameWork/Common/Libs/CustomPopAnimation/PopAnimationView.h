//
//  PopAnimationView.h
//  StoryShip
//
//  Created by 张福润 on 2017/1/22.
//  Copyright © 2017年 ifenghui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIViewController;

@interface PopAnimationView : UIView
- (void)loadBaseAnimationFromeViewCntorller:(UIViewController *)fromeViewController ToViewController:(UIViewController *)toViewcontroller WithTitle:(NSString *)title BGImage:(UIImage *)image ;
@end
