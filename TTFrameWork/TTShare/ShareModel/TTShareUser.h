//
//  TTShareUser.h
//  TT
//
//  Created by 张福润 on 2017/3/21.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "TTBaseModel.h"

typedef enum : NSUInteger {
    GenderTypeMan,
    GenderTypeWoman,
} GenderType;

@interface TTShareUser : TTBaseModel
@property (nonatomic, strong) NSString *userId;//OAuth -> openId
@property (nonatomic, strong) NSString *nick;
@property (nonatomic, assign) GenderType   sex;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *figureUrl;
@property (nonatomic, strong) NSString *userType;
@property (nonatomic, strong) NSString *password;

- (instancetype)initWithQQDict:(NSDictionary *)dict;
- (instancetype)initWithWXDict:(NSDictionary *)dict;
- (instancetype)initWithWBDict:(NSDictionary *)dict;
@end
