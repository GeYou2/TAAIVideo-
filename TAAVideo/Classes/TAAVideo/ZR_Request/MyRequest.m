//
//  MyRequest.m
//  AFCache
//
//  Created by tc on 2016/11/10.
//  Copyright © 2016年 tc. All rights reserved.
//
#define IsNilString(__String)   (__String==nil || [__String isEqualToString:@"null"] || [__String isEqualToString:@"<null>"])

#import "MyRequest.h"
#import "AFNetworking.h"
#import "EGOCache.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
@implementation MyRequest

#pragma mark get
+(void)GET:(NSString *)url WithParameters:(NSDictionary*)paramas CacheTime:(NSInteger)CacheTime isLoadingView:(NSString *)loadString success:(SuccessCallBack)success failure:(FailureCallBack)failure{
    url = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    EGOCache *cache = [EGOCache globalCache];
    if (![self interStatus]) {
        NSString *interNetError = [url stringByAppendingString:@"interNetError"];
        NSData *responseObject = [cache dataForKey:interNetError];
        if (responseObject.length != 0) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            success(responseObject,YES,dict);
            return;
        }
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 30.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [requestSerializer setValue:@"b845088dd33c4be3bfe4a9016247b2e2o91v34Fk85889027244" forHTTPHeaderField:@"token"];
    manager.requestSerializer = requestSerializer;
    
    if ([cache hasCacheForKey:url]) {
        NSData *responseObject = [cache dataForKey:url];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        success(responseObject,YES,dict);
        return;
    }
    
    [manager GET:url parameters:paramas progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!IsNilString(loadString)) {
            [MBProgressHUD hideHUD];
        }
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        BOOL succe = NO;
        success(responseObject,succe,dict);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (!IsNilString(loadString)) {
           [MBProgressHUD hideHUD];
        }
        [MBProgressHUD show:@"网络连接失败" icon:nil view:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"noNet" object:nil];
        failure(error);
    }];
}

#pragma mark post
+ (void)POST:(NSString *)url withParameters:(id)params CacheTime:(NSInteger)CacheTime isLoadingView:(NSString *)loadString success:(SuccessCallBack)success failure:(FailureCallBack)failure{
    [MBProgressHUD showMessage:loadString];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    EGOCache *cache = [EGOCache globalCache];
    if (![self interStatus]) {
        //无网络
        NSString *interNetError = [url stringByAppendingString:@"interNetError"];
        NSData *responseObject = [cache dataForKey:interNetError];
        if ((responseObject.length != 0)) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            success(responseObject,YES,dict);
            return;
        }
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 30.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [requestSerializer setValue:@"b845088dd33c4be3bfe4a9016247b2e2o91v34Fk85889027244" forHTTPHeaderField:@"token"];
    manager.requestSerializer = requestSerializer;
    
    if ([cache hasCacheForKey:url]) {
        NSData *responseObject = [cache dataForKey:url];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        success(responseObject,YES,dict);
        return;
    }
    
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress){
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [MBProgressHUD hideHUD];
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        BOOL succe = NO;
        success(responseObject,succe,dict);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        failure(error);
    }];
}

+ (void)POSTImageUrl:(NSString *)url withParams:(NSDictionary *)params Images:(UIImage *)image imageName:(NSString*)imageName{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 30.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];//声明返回的数据是json
    manager.requestSerializer =[AFJSONRequestSerializer serializer];//声明请求的数据是json
    //设置请求头
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //上传操作
        NSData* data =UIImagePNGRepresentation(image);
        [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"@SMT"] fileName:imageName mimeType:@"image/png"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上传成功了啊啊啊");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败了");
    }];
    /*
     1、name:多文件上传时,name不能重复，不能重复，不能重复，重要的事情说三遍，我就是在这里卡住了，当时我的接口文档中让我传的参数是“photos[]”,结果我真的傻乎乎的只传了一个“photos[]”,其结果就是只有一张图片上传成功，这也体现了交流的重要性，至于具体怎么传，接口文档一般都有说明，如不清楚，请与后台人员沟通，这是服务器用于接收你所上传文件的参数名，十分重要。
     
     　　2、fileName:不能重复，这个名字由用户决定，只要不重复，其它没有要求。
     
     　　3、mimeType:你所要上传文件的类型，各种文件所对应的类型详情请自己百度。
     
     　　上传图片一般会与相册与照相机结合使用，但是其图片一般较大，可使用UIImageJPEGRepresentation(image, 0.1)方法对图片进行一定程度的压缩，具体压缩情况要结合你的实例。作一点说明：UIImagePNGRepresentation(image)与UIImageJPEGRepresentation(image, 0.1)方法都会返回图片的data数据，如果将data数据转化成图片，图片类型由后缀名决定，如果保存为.png后缀的图片，就是png图片，如果保存为.jpg后缀的图片，则就是jpg图片，故不要被方法名中的PNG和JPEG所影响。
     */
}

//同步判断网络状态
+(BOOL)interStatus{
    BOOL status ;
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus status22 = [reach currentReachabilityStatus];
     // 判断网络状态
    if (status22 == ReachableViaWiFi) {
        status = YES;
        //无线网
    } else if (status22 == ReachableViaWWAN) {
        status = YES;
        //移动网
    } else{
        status = NO;
    }
    return status;
}



@end
