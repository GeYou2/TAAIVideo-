//
//  BaseRequest.h
//  Abroad-agent
//
//  Created by Slark on 17/6/2.
//  Copyright © 2017年 Slark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZR_Request.h"
@interface ZR_Request : NSObject

typedef void(^CCAPICompletion) (NSDictionary * jsonDic);
typedef void(^CCFailCompletion) (NSString* eerorString);
typedef void(^PostCallBack) (void);

@property (nonatomic,copy)NSString* imageNameString;
@property (nonatomic,copy)NSString* cc_url;
@property (nonatomic,strong)NSDictionary * cc_params;
@property (nonatomic,assign)BOOL isPost;
@property (nonatomic,strong)PostCallBack callBack;

+ (instancetype)cc_request;
+ (instancetype)cc_requestWithUrl:(NSString*)cc_url;
+ (instancetype)cc_requestWithUrl:(NSString*)cc_url isPost:(BOOL)cc_isPost Params:(NSDictionary*)params;
- (void)cc_senRequest;
- (void)cc_sendRequstWith:(CCAPICompletion)completion failCompletion:(CCFailCompletion)failcompletion WithString:(NSString*)loadString;




@end
