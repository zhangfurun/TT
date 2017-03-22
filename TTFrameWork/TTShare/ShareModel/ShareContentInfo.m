//
//  ShareContentInfo.m
//  TT
//
//  Created by 张福润 on 2017/3/21.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "ShareContentInfo.h"

#import "SDWebImageManager.h"

@implementation ShareContentInfo

- (NSData *)objData {
    if (_objData) {
        return _objData;
    }
    
    if (self.contentType == ShareContentType_Image || (self.contentType == ShareContentType_Link && self.urlStr)) {
        NSURL *url = [NSURL URLWithString:self.imgPath];
        [[SDWebImageManager sharedManager] loadImageWithURL:url options:SDWebImageHighPriority progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            if (finished && error == nil) {
                _objData = UIImageJPEGRepresentation(image, 0.2);
            }
        }];
    }
    return _objData;
}

#pragma mark - Method
+ (instancetype)shareTitle:(NSString *)title content:(NSString *)content contentType:(ShareContentType)contentType {
    return [self shareTitle:title content:content url:nil imagePath:nil contentType:contentType];
}

+ (instancetype)shareTitle:(NSString *)title content:(NSString *)content url:(NSString *)url imagePath:(NSString *)imgPath contentType:(ShareContentType)contentType {
    return [self shareTitle:title content:content url:url imagePath:imgPath objData:nil contentType:contentType];
}

+ (instancetype)shareTitle:(NSString *)title content:(NSString *)content url:(NSString *)url imagePath:(NSString *)imgPath objData:(NSData *)objData contentType:(ShareContentType)contentType {
    ShareContentInfo *info = [ShareContentInfo new];
    info.title = title;
    info.content = content;
    info.urlStr = url;
    info.imgPath = imgPath;
    info.contentType = contentType;
    info.objData = objData;
    return info;
}
@end
