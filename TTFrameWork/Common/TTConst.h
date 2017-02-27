//
//  TTConst.h
//  TT
//
//  Created by 张福润 on 2017/2/27.
//  Copyright © 2017年 张福润. All rights reserved.
//

#ifndef TTConst_h
#define TTConst_h

typedef enum : NSUInteger {
    RefreshViewStateNormal = 0,
    RefreshViewStateWillLoad,
    RefreshViewStateLoading
} RefreshViewState;

#define degreesToRadian(x) (M_PI * (x) / 180.0)

//Window
#define KEY_WINDOW  [[UIApplication sharedApplication].delegate window]
#define MAIN_SCREEN [UIScreen mainScreen]

//Orientation
#define SCREEN_ORIENTATION [[UIApplication sharedApplication] statusBarOrientation]
#define IS_SCREEN_PORTRAIT (SCREEN_ORIENTATION == UIInterfaceOrientationPortrait)

//CacheFolder
#define kCachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
#define kDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define FOLDER_PATH_WITH_FOLDERNAME(folder) [kCachesPath stringByAppendingPathComponent:folder]

//NSString
#define EMPTY_STR @""
#define STR_ISNULL_OR_EMPTY(str)       (str == nil || [str isEqualToString:EMPTY_STR] || [str isEqual:[NSNull null]])
#define STR_ISNOT_NULL_OR_EMPTY(str)   (str != nil && ![str isEqualToString:EMPTY_STR] && ![str isEqual:[NSNull null]])

// NSURL
#define UrlWithString(url)              [NSURL URLWithString:url]

//UIColor
#define RGBA_COLOR(r,g,b,a)  [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

//UIDevice
#define ISIPAD ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
#define IS320Screen (MAIN_SCREEN.bounds.size.width == 320)

//NSURL
#define URL_WITH_STR(str)    [NSURL URLWithString:str]

//NSLog
#ifdef DEBUG
#define TTLog(...) NSLog(__VA_ARGS__)
#else
#define TTLog(...)
#endif


#endif /* TTConst_h */
