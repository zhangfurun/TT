//
//  TTWebView.m
//  TT
//
//  Created by 张福润 on 2017/3/23.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "TTWebView.h"

#import "TTConst.h"

#import "UIView+TTSuperView.h"

@interface TTWebView ()
@property (nonatomic, copy) NSString *resizeImageJS;
@end

@implementation TTWebView

- (void)setAllowUserSelected:(BOOL)allowUserSelected {
    _allowUserSelected = allowUserSelected;
    
    if (!allowUserSelected) {
        [self stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    }
}

- (NSString *)resizeImageJS {
    if (!_resizeImageJS) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"autoResizeAllImage.js" ofType:nil];
        NSString *autoResizeImgJS = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSString *script = [NSString stringWithFormat:@"%@<script>AutoResizeAllImage(%f);</script>",autoResizeImgJS,self.imageScaleWidth > 0 ? self.imageScaleWidth : KEY_WINDOW.width];
        _resizeImageJS = script;
    }
    return _resizeImageJS;
}

- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL {
    if (self.isScaleImageWidthEqualWindowWidth || self.imageScaleWidth > 0) {
        NSString *newString = [NSString stringWithFormat:@"%@%@",string, self.resizeImageJS];
        [super loadHTMLString:newString baseURL:baseURL];
    } else {
        [super loadHTMLString:string baseURL:baseURL];
    }
}

@end

