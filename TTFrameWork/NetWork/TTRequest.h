//
//  TTRequest.h
//  TT
//
//  Created by 张福润 on 2017/3/11.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "TTBaseRequest.h"

/**
 这个TTRequest数据请求,是针对项目中的数据请求做出的实际的操作类
 在实际开发中,我们可以继承TTBaseRequest进行操作,同时,重写对外接口,我们可以尽可能的完善项目的数据请求
 */

extern NSString * const FORMAL_SERVER_URL;
extern NSString * const TEST_SERVER_URL;

@interface TTRequest : TTBaseRequest

@end
