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

// Default
static NSString * const TimeFormatDefault = @"yyyy-MM-dd";

static NSString *HH = @"HH";
static NSString *mm = @"mm";
static NSString *ss = @"ss";
static NSString *HHmmss = @"HH:mm:ss";

static NSString *YYYY = @"YYYY";
static NSString *YY = @"YY";
static NSString *MM = @"MM";
static NSString *dd = @"dd";

static NSString *MM_dd = @"MM-dd";
static NSString *MM_dd_HHmm = @"MM-dd HH:mm";
static NSString *YY_MM_dd = @"YY-MM-dd";
static NSString *YYYY_MM_dd = @"YYYY-MM-dd";
static NSString *YYYY_MM_ddHHmmss = @"YYYY-MM-dd HH:mm:ss";

static NSString *MMdd = @"MM.dd";
static NSString *YYMMdd = @"YY.MM.dd";
static NSString *YYYYMMdd = @"YYYY.MM.dd";
static NSString *YYYYMMddHHmmss = @"YYYY.MM.dd HH:mm:ss";

// 第三方
#define WECHATAPPIDKEY              @"" // id
#define WECHATAPPSECRETKEY          @"" // SECRETKEY
#define WECHATPARTNERID             @"" // 商户号
#define WECHATPARTNERKEY            @"" // 密钥

#define SINAAPPIDKEY                @"" //key
#define SINAREDIRECTURIKEY          @""

#define BAIDUAPPIDKEY               @"" // key

#define ALIPAYAPPID                 @"" // appid
#define ALIPAYPRIVATEKEY            @"" // 私钥(这个对于阿里支付的私钥,建议放到服务器端去做)

#endif /* TTConst_h */
