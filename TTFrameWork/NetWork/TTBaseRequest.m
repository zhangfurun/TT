//
//  TTBaseRequest.m
//  TT
//
//  Created by 张福润 on 2017/3/11.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "TTBaseRequest.h"

#import "TTConst.h"
#import "TTLogManager.h"
#import "TTBinaryData.h"

#import "AFNetworking.h"

#import "NSString+TTString.h"

@interface TTBaseRequest(){
    void(^_successBlock)(TTBaseRequest *);
    void(^_cancelBlock)(TTBaseRequest *);
    void(^_failureBlock)(TTBaseRequest *,NSError *);
    void(^_uploadProgressBlock)(TTBaseRequest *, NSUInteger, long long, long long);
    AFHTTPRequestOperation *_requestOperation;
}
@end

static NSMutableArray *requests;

@implementation TTBaseRequest

- (instancetype)initWithParameters:(NSDictionary *)requestParameters
                   postBinaryArray:(NSMutableArray *)binaryArray
                      successBlock:(void(^)(TTBaseRequest *))successBlock
                       cancelBlock:(void(^)(TTBaseRequest *))cancelBlock
                      failureBlock:(void(^)(TTBaseRequest *,NSError *))failureBlock
                 uplodProcessBlock:(void (^)(TTBaseRequest *, NSUInteger, long long, long long))uploadProcessBlock {
    self = [super init];
    if (self) {
        _requestParameters = requestParameters;
        _binaryParameterArray = binaryArray;
        _requestUrl = [self getRequestUrl];
        _successBlock = successBlock;
        _cancelBlock = cancelBlock;
        _failureBlock = failureBlock;
        _uploadProgressBlock = uploadProcessBlock;
        [self doRequest];
    }
    return self;
}

+ (void)requestParameters:(NSDictionary *)parameters successBlock:(void (^)(TTBaseRequest *))successBlock cancelBlock:(void (^)(TTBaseRequest *))cancelBlock failureBlock:(void (^)(TTBaseRequest *, NSError *))failureBlock {
    return [self requestParameters:parameters binaryArray:nil successBlock:successBlock cancelBlock:cancelBlock failureBlock:failureBlock uplodProcessBlock:nil];
}

+ (void)requestParameters:(NSDictionary *)requestParameters
              binaryArray:(NSMutableArray *)binaryArray
             successBlock:(void (^)(TTBaseRequest *))successBlock
              cancelBlock:(void (^)(TTBaseRequest *))cancelBlock
             failureBlock:(void (^)(TTBaseRequest *, NSError *))failureBlock
        uplodProcessBlock:(void (^)(TTBaseRequest *request, NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))uploadProcessBlock {
    AFNetworkReachabilityManager *rechabilityManager = [AFNetworkReachabilityManager sharedManager];
    AFNetworkReachabilityStatus networkStatus = [rechabilityManager networkReachabilityStatus];
    if (networkStatus == AFNetworkReachabilityStatusNotReachable) {
        if (failureBlock) {
            NSError *error = [NSError errorWithDomain:NSStringFromClass(self) code:-1 userInfo:@{@"error":@"NetworkError"}];
            failureBlock(nil,error);
        }
    }
    TTBaseRequest *baseRequest = [[self alloc]
                                  initWithParameters:requestParameters
                                  postBinaryArray:binaryArray
                                  successBlock:successBlock
                                  cancelBlock:cancelBlock
                                  failureBlock:failureBlock
                                  uplodProcessBlock:uploadProcessBlock];
    [[NSNotificationCenter defaultCenter] addObserver:baseRequest
                                             selector:@selector(canelRequest)
                                                 name:[self getCancelString]
                                               object:nil];
    if (requests == nil) {
        requests = [NSMutableArray array];
    }
    [requests addObject:baseRequest];
}

- (void)doRequest{
    id successBlock = ^(AFHTTPRequestOperation *operateion,id responseObject){
        [self handlerResponse:operateion responseObject:responseObject];
    };
    
    id failureBlock = ^(AFHTTPRequestOperation *operation, NSError *error){
        [self responseError:operation error:error];
    };
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    NSString *uaHeaderStr = [self getUserAgent];
    if (![NSString isNilOrEmpty:uaHeaderStr]) {
        [mgr.requestSerializer setValue:uaHeaderStr forHTTPHeaderField:@"User-Agent"];
    }
    NSDictionary *reqHeaderDict = [self getCustomHeaders];
    if (reqHeaderDict) {
        for (NSString *key in reqHeaderDict.allKeys) {
            NSString *value = [reqHeaderDict valueForKey:key];
            [mgr.requestSerializer setValue:value forHTTPHeaderField:key];
        }
    }
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    if ([TTLogManager logStatus]) {
        TTLog(@"%@",_requestUrl);
    }
    TTRequestType reqMethod = [self getRequestMethod];
    switch (reqMethod) {
        case TTRequestTypeGet:
            _requestOperation = [mgr GET:_requestUrl parameters:nil success:successBlock failure:failureBlock];
            break;
        case TTRequestTypePost: {
            _requestOperation = [mgr POST:_requestUrl parameters:[self getRequestParamDict] constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                if (_binaryParameterArray) {
                    for (id item in _binaryParameterArray) {
                        if ([item isKindOfClass:[TTBinaryData class]]) {
                            TTBinaryData *data = (TTBinaryData *)item;
                            [formData appendPartWithFileData:data.binaryData name:data.name fileName:data.filename mimeType:data.MIMEType];
                        }
                    }
                }
            } success:successBlock failure:failureBlock];
            __weak TTBaseRequest *WS = self;
            [_requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                [WS handlerUploadProcess:bytesWritten totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
            }];
        }
            break;
        case TTRequestTypePut:
            _requestOperation = [mgr PUT:_requestUrl parameters:[self getRequestParamDict] success:successBlock failure:failureBlock];
            break;
        case TTRequestTypeDelete:
            _requestOperation = [mgr DELETE:_requestUrl parameters:[self getRequestParamDict] success:successBlock failure:failureBlock];
            break;
    }
}

- (void)handlerUploadProcess:(NSUInteger)bytesWritten totalBytesWritten:(long long)totalBytesWritten totalBytesExpectedToWrite:(long long)totalBytesExpectedToWrite {
    if (_uploadProgressBlock) {
        _uploadProgressBlock(self, bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    }
}

- (void)handlerResponse:(AFHTTPRequestOperation *)operation responseObject:(id)responseObject{
    [self finishRequest];
    NSString *MIMEType = operation.response.MIMEType;
    if ([MIMEType isEqualToString:MIMEType_JPG] || [MIMEType isEqualToString:MIMEType_PNG]) {
        _responseImage = [UIImage imageWithData:operation.responseData];
        [self executeSuccess];
    } else {
        NSString *responseString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSString *trimmingString = [responseString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        self.resultString = trimmingString;
        [self handlerResultString:trimmingString];
    }
}

- (void)handlerResultString:(NSString *)resultString {
    NSData *jsonData = [resultString dataUsingEncoding:NSUTF8StringEncoding];
    id result = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    _resultDict = [NSMutableDictionary dictionary];
    if ([result isKindOfClass:[NSDictionary class]]) {
        _resultDict = [[NSMutableDictionary alloc] initWithDictionary:result];
        [self executeSuccess];
    } else if ([result isKindOfClass:[NSArray class]]){
        _resultArray = [[NSMutableArray alloc] initWithArray:result];
        [self executeSuccess];
    } else {
        if (_failureBlock) {
            NSError *error = [NSError errorWithDomain:NSStringFromClass([self class]) code:-1 userInfo:@{@"error" : @"返回结果未处理!"}];
            _failureBlock(self,error);
        }
    }
}

- (void)executeSuccess{
    [self processResult];
    if (_successBlock) {
        _successBlock(self);
    }
}

- (void)responseError:(AFHTTPRequestOperation *)operation error:(NSError *)error{
    [self finishRequest];
    if (_failureBlock) {
        _failureBlock(self, error);
    }
}

- (void)finishRequest{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [requests removeObject:self];
    if ([TTLogManager logStatus]) {
        TTLog(@"%@ requestFinished: %@", self,_requestUrl);
        //        TTLog(@"%@", requests);
    }
}

+ (TTNetworkReachabilityStatus)fetchReachabilityStatus {
    return (TTNetworkReachabilityStatus)[[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
}

+ (void)starNetWorkReachability {
    AFNetworkReachabilityManager *nwReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [nwReachabilityManager startMonitoring];
}

#pragma mark - RequestUrl and Parameters
- (NSString *)getRequestUrl{
    NSString *url = [self getRequestUrlHasParameters];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return url;
}

+ (BOOL)isRequesting {
    for (TTBaseRequest *request in requests) {
        if ([request isKindOfClass:[self class]]) {
            return  YES;
        }
    }
    return NO;
}

- (NSString *)getRequestUrlHasParameters {
    NSMutableString *requestUrlString = [NSMutableString stringWithFormat:@"%@%@",[self getRequestHost],[self getRequestQuery]];
    TTRequestType reqMethod = [self getRequestMethod];
    switch (reqMethod) {
        case TTRequestTypeGet:
            [requestUrlString appendString:[self getRequestParametersString]];
            return requestUrlString;
        case TTRequestTypePost:
        case TTRequestTypePut:
        case TTRequestTypeDelete:
            return requestUrlString;
    }
    return EMPTY_STR;
}

- (NSString *)getRequestParametersString {
    if ([self getRequestMethod] != TTRequestTypeGet) {
        return EMPTY_STR;
    }
    NSDictionary *defaultParameterDict = [self getDefaultParameters];
    if (_requestParameters == nil && defaultParameterDict == nil) {
        return EMPTY_STR;
    }
    NSMutableDictionary *tempParameterDict = [NSMutableDictionary dictionary];
    if (defaultParameterDict) {
        [tempParameterDict addEntriesFromDictionary:defaultParameterDict];
    }
    if (_requestParameters) {
        [tempParameterDict addEntriesFromDictionary:_requestParameters];
    }
    NSMutableString *requestParamsString = [NSMutableString string];
    NSArray *allKeys = tempParameterDict.allKeys;
    NSInteger keysCount = [allKeys count];
    NSInteger i = 0;
    for (NSString *paramKey in allKeys) {
        [requestParamsString appendFormat:@"%@=%@",paramKey,[tempParameterDict objectForKey:paramKey]];
        if (i++ == (keysCount - 1)) {
            break;
        }
        [requestParamsString appendString:@"&"];
    }
    return requestParamsString;
}

- (NSDictionary *)getRequestParamDict {
    NSDictionary *defaultParamDict = [self getDefaultParameters];
    if (_requestParameters == nil && defaultParamDict == nil) {
        return nil;
    }
    NSMutableDictionary *tempPramDict = [NSMutableDictionary dictionary];
    if (defaultParamDict) {
        [tempPramDict addEntriesFromDictionary:defaultParamDict];
    }
    if (_requestParameters) {
        [tempPramDict addEntriesFromDictionary:_requestParameters];
    }
    return tempPramDict;
}

#pragma mark - Cancel Request
- (void)canelRequest{
    if (_requestOperation) {
        [_requestOperation cancel];
    }
}

+ (NSString *)getCancelString{
    return [NSString stringWithFormat:@"Cancel_%@",NSStringFromClass(self)];
}

+ (void)cancelTheRequest{
    [[NSNotificationCenter defaultCenter] postNotificationName:[self getCancelString] object:nil];
}

#pragma mark - Children Class
- (NSString *)getRequestHost{return EMPTY_STR;}
- (NSString *)getRequestQuery{return EMPTY_STR;}
- (NSString *)getUserAgent{return EMPTY_STR;}
- (NSDictionary<NSString *, NSString *> *)getCustomHeaders{return nil;}
- (NSDictionary *)getDefaultParameters{return nil;}
- (void)processResult{};
- (BOOL)success{ return YES;}
- (NSString *)errorMsg {return EMPTY_STR;}
- (NSInteger)totalCount{return 0;}
- (BOOL)hasMoreData {return NO;}
- (TTRequestType)getRequestMethod{
    return TTRequestTypeGet;
}
@end

