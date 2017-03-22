//
//  TTShareUser.m
//  TT
//
//  Created by 张福润 on 2017/3/21.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "TTShareUser.h"

#import "TTAuthInfo.h"

@implementation TTShareUser

- (instancetype)initWithQQDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _userType = [NSString stringWithFormat:@"%ld",ShareType_QQ];
        _nick = dict[@"nickname"];
        _sex = [dict[@"gender"] isEqualToString:@"男"] ? GenderTypeMan : GenderTypeWoman;
        _address = [NSString stringWithFormat:@"%@ %@",dict[@"province"],dict[@"city"]];
        _figureUrl = dict[@"figureurl_qq_2"];
    }
    return self;
}

- (instancetype)initWithWXDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _userType = [NSString stringWithFormat:@"%ld",ShareType_WeChat];
        _nick = dict[@"nickname"];
        _sex  = [dict[@"sex"] integerValue] == 1 ? GenderTypeMan : GenderTypeWoman;
        _address = [NSString stringWithFormat:@"%@ %@",dict[@"province"],dict[@"city"]];
        _figureUrl = dict[@"headimgurl"];
    }
    return self;
}

- (instancetype)initWithWBDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _userId = [NSString stringWithFormat:@"%@", dict[@"id"]];
        _userType = [NSString stringWithFormat:@"%ld",ShareType_Sina];
        _nick = dict[@"name"];
        _sex = [dict[@"gender"] isEqualToString:@"m"] ? GenderTypeMan : GenderTypeWoman;
        _address = dict[@"location"];
        _figureUrl = dict[@"avatar_large"];
    }
    return self;
}
@end
