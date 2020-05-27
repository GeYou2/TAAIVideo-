//
//  BaseRequest.m
//  Abroad-agent
//
//  Created by Slark on 17/6/2.
//  Copyright © 2017年 Slark. All rights reserved.
//

#import "ZR_Request.h"
#import "MyRequest.h"
@implementation ZR_Request

+ (instancetype)cc_request {
    return [[self alloc]init];
}

+ (instancetype)cc_requestWithUrl:(NSString *)cc_url {
    return [self cc_requestWithUrl:cc_url isPost:NO Params:nil];
}

+ (instancetype)cc_requestWithUrl:(NSString *)cc_url isPost:(BOOL)cc_isPost Params:(NSDictionary *)params {
    ZR_Request * request = [self cc_request];
    request.cc_url = [NSString stringWithFormat:@"%@%@",PostUrl,cc_url];
    NSLog(@"当前请求的地址为-----%@",request.cc_url);
    request.isPost = cc_isPost;
    request.cc_params = params;
    return request;
}

#pragma mark 发送请求
- (void)cc_senRequest {
    [self cc_sendRequstWith:nil failCompletion:nil WithString:nil];
}

- (void)cc_sendRequstWith:(CCAPICompletion)completion failCompletion:(CCFailCompletion)failcompletion WithString:(NSString *)loadString {
    NSString * urlStr = self.cc_url;
    if (urlStr.length == 0)  return;
    if (self.isPost) {
        [MyRequest POST:urlStr withParameters:self.cc_params CacheTime:0 isLoadingView:loadString success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
            /** 代表接口是通的*/
            /** 根据后台返回的code来判断是否请求成功*/
            if([jsonDic[@"code"] isEqualToNumber:[NSNumber numberWithLong:20000]]){
                NSLog(@"请求成功");
                [self handleJsonDic:jsonDic completion:completion];
            }else{
                if (failcompletion) {
                    failcompletion(jsonDic[@"message"]);
                }
            }
        } failure:^(NSError *error) {
            if (failcompletion) {
                failcompletion(@"");
            }
            return ;
        }];
    }else{
        [MyRequest GET:urlStr WithParameters:self.cc_params CacheTime:0 isLoadingView:nil success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
            if([jsonDic[@"code"] isEqualToNumber:[NSNumber numberWithLong:20000]]){
                NSLog(@"请求成功");
                [self handleJsonDic:jsonDic completion:completion];
            }else{
                if (failcompletion) {
                    failcompletion(jsonDic[@"message"]);
                }
            }
            
        } failure:^(NSError *error) {
            if (failcompletion) {
                NSLog(@"请求失败%@",error.description);
                failcompletion(error.description);
            }
            
            return ;
        }];
    }
}

- (void)handleJsonDic:(NSDictionary*)jsonDic completion:(CCAPICompletion)completion{
    [MBProgressHUD hideHUD];
    if (completion) {
        completion(jsonDic);
    }
}

@end
