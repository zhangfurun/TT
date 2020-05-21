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
#import "TTServerManager.h"

#import "AFNetworking.h"

#import "NSString+TTString.h"

@interface TTBaseRequest(){
    void(^_successBlock)(TTBaseRequest *);
    void(^_cancelBlock)(TTBaseRequest *);
    void(^_failureBlock)(TTBaseRequest *,NSError *);
    void(^_uploadProgressBlock)(TTBaseRequest *, NSUInteger, long long, long long);
    NSURLSessionDataTask *_requestSession;
    NSString *_failureErrorMsg;
}
@end

const NSTimeInterval REQUEST_DEFAULT_TIMEOUT_INTERVAL = 60.0;
const NSInteger REQUEST_DEFAULT_ERROR_CODE = -1;
NSString * const Key_Model = @"Key_Model";
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

#pragma mark - Property Method
- (NSString *)failureErrorMsg {
    return [_failureErrorMsg copy];
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
    id successBlock = ^(NSURLSessionDataTask *task,id responseObject){
        [self handlerResponse:task responseObject:responseObject];
    };
    
    id failureBlock = ^(NSURLSessionDataTask * _Nullable task, NSError *error){
        [self responseError:task error:error];
    };
    
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer.timeoutInterval = [self getTimeoutInterval];
    NSString *uaHeaderStr = [self getUserAgent];
    if (![uaHeaderStr isEqualToString:EMPTY_STR]) {
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
    if (TTServerManager.isLogStatusOpen) {
        TTLog(@"%@",_requestUrl);
    }
    TTRequestMethod reqMethod = [self getRequestMethod];
    switch (reqMethod) {
        case TTRequestMethodGet:
            _requestSession = [mgr GET:_requestUrl
            parameters:nil
               headers:nil
              progress:nil
               success:successBlock
               failure:failureBlock];
            break;
        case TTRequestMethodPost: {
            __weak TTBaseRequest *WS = self;
            
            id pramamDict = [self getRequestParamDict];
            if (_binaryParameterArray && _binaryParameterArray.count > 0) {
                
                _requestSession = [mgr POST:_requestUrl parameters:pramamDict headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    for (id item in _binaryParameterArray) {
                        if ([item isKindOfClass:[TTBinaryData class]]) {
                            TTBinaryData *data = (TTBinaryData *)item;
                            [formData appendPartWithFileData:data.binaryData name:data.name fileName:data.filename mimeType:data.MIMEType];
                        }
                    }
                }
                                   progress:^(NSProgress * _Nonnull uploadProgress) {
                    [WS handlerUploadProcess:uploadProgress];
                }
                                    success:successBlock
                                    failure:failureBlock];
                
            } else {
                _requestSession = [mgr POST:_requestUrl
                                 parameters:pramamDict
                                    headers:nil
                                   progress:nil
                                    success:successBlock
                                    failure:failureBlock];
            }
        }
            break;
        case TTRequestMethodPut:
            _requestSession = [mgr PUT:_requestUrl
                            parameters:[self getRequestParamDict]
                               headers:nil
                               success:successBlock
                               failure:failureBlock];
            break;
        case TTRequestMethodDelete:
            _requestSession = [mgr DELETE:_requestUrl
                               parameters:[self getRequestParamDict]
                                  headers:nil
                                  success:successBlock
                                  failure:failureBlock];
            break;
    }
}

- (void)handlerUploadProcess:(NSProgress *)uploadProgress {
    int64_t uploadedCount = uploadProgress.completedUnitCount;
    int64_t totalUploadCount = uploadProgress.totalUnitCount;
    CGFloat progress = 1.f * uploadedCount / totalUploadCount;
    
    if (_uploadProgressBlock) {
        _uploadProgressBlock(self, progress, uploadedCount, totalUploadCount);
    }
}

- (void)handlerResponse:(NSURLSessionDataTask *)task responseObject:(id)responseObject{
    [self finishRequest];
    NSString *MIMEType = task.response.MIMEType;
    if ([MIMEType isEqualToString:MIMEType_JPG] || [MIMEType isEqualToString:MIMEType_PNG]) {
        _responseImage = [UIImage imageWithData:responseObject];
        [self executeSuccess];
    } else {
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *trimmingString = [responseString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        self.resultString = trimmingString;
        [self handlerResultString:trimmingString];
    }
}

- (void)handlerResultString:(NSString *)resultString {
    if (STR_ISNULL_OR_EMPTY(resultString)) {
        NSError *error = [NSError errorWithDomain:NSStringFromClass([self class]) code:-1 userInfo:@{@"error" : @"返回结果未处理!"}];
        _failureErrorMsg = [self fetchFailureErrorMsg:error];
        if (_failureBlock) {
            _failureBlock(self, error);
        }
        return;
    }
    @try {
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
            NSError *error = [NSError errorWithDomain:NSStringFromClass([self class]) code:-1 userInfo:@{@"error" : @"返回结果未处理!"}];
            _failureErrorMsg = [self fetchFailureErrorMsg:error];
            if (_failureBlock) {
                _failureBlock(self, error);
            }
        }
    } @catch (NSException *exception) {
        NSError *error = [NSError errorWithDomain:NSStringFromClass([self class]) code:-1 userInfo:@{@"error" : @"返回结果未处理!"}];
        _failureErrorMsg = [self fetchFailureErrorMsg:error];
        if (_failureBlock) {
            _failureBlock(self, error);
        }
    } @finally {
        
    }
}

- (void)executeSuccess {
    [self processResult];
    if (_successBlock) {
        _successBlock(self);
    }
}

- (void)responseError:(NSURLSessionTask *)task error:(NSError *)error {
    [self finishRequest];
    _failureErrorMsg = [self fetchFailureErrorMsg:error];
    if (_failureBlock) {
        _failureBlock(self, error);
    }
}

- (void)finishRequest {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [requests removeObject:self];
    if (TTServerManager.isLogStatusOpen) {
        TTLog(@"%@ requestFinished: %@", self,_requestUrl);
    }
}

- (NSString *)fetchFailureErrorMsg:(NSError *)error {
    NSString *msg = @"发生了一个未知的错误";
    switch (error.code) {
        case NSURLErrorCancelled:
            msg = [NSString stringWithFormat:@"%@_请求已取消", [[self class] getCancelString]];
            _failureBlock = nil;
            [[self class] cancelTheRequest];
            break;
        default:
            msg = TT_FetchFailureErrorMsg(error);
            break;
    }
    return msg;
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
    TTRequestMethod reqMethod = [self getRequestMethod];
    switch (reqMethod) {
        case TTRequestMethodGet:
            [requestUrlString appendString:[self getRequestParametersString]];
            return requestUrlString;
        case TTRequestMethodPost:
        case TTRequestMethodPut:
        case TTRequestMethodDelete:
            return requestUrlString;
    }
    return EMPTY_STR;
}

- (NSString *)getRequestParametersString {
    if ([self getRequestMethod] != TTRequestMethodGet) {
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
   if (_requestSession) {
        [_requestSession cancel];
    }
    if (_cancelBlock) {
        _cancelBlock(self);
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
- (NSTimeInterval)getTimeoutInterval { return REQUEST_DEFAULT_TIMEOUT_INTERVAL;}
- (NSDictionary *)getDefaultParameters{return nil;}
- (void)processResult{};
- (BOOL)success{ return YES;}
- (NSInteger)statusCode { return REQUEST_DEFAULT_ERROR_CODE;};
- (NSString *)msg { return EMPTY_STR;}
- (NSInteger)totalCount{ return 0;}
- (BOOL)hasMoreData { return NO;}
- (TTRequestMethod)getRequestMethod{
    return TTRequestMethodGet;
}
@end

