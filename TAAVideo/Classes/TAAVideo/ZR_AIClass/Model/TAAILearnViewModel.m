//
//  TAAILearnViewModel.m
//  TutorABC
//
//  Created by Slark on 2020/5/19.
//  Copyright © 2020 Slark. All rights reserved.
//

#import "TAAILearnViewModel.h"
#import <AVKit/AVKit.h>

@interface TAAILearnViewModel()

@property (nonatomic, strong) NSMutableDictionary *params;

@end

@implementation TAAILearnViewModel

+ (NSString *)getFailFeedBackVideoUrlWithPartModel:(TAAIPartModel *)partModel{
    NSDictionary *questionObj = partModel.questionObj;
    NSArray * feedBackVideos = questionObj[@"questionExtFeedbackList"];
    if ([feedBackVideos isKindOfClass:[NSNull class]]||feedBackVideos.count <= 0) {
        return @"";
    }
    NSDictionary *feedDic = feedBackVideos.lastObject;
    NSDictionary *feeddVideoDic = feedDic[@"learningObj"];
    NSString *bgUrl = feeddVideoDic[@"bgUrl"];
    return bgUrl;
}

+ (NSString *)getSuccessFeedBackVieeoUrlWithPartModel:(TAAIPartModel *)partModel {
    NSDictionary *questionObj = partModel.questionObj;
    NSArray * feedBackVideos = questionObj[@"questionExtFeedbackList"];
    if ([feedBackVideos isKindOfClass:[NSNull class]]||feedBackVideos.count <= 0) {
           return @"";
       }
    NSDictionary *feedDic = feedBackVideos.firstObject;
    NSDictionary *feeddVideoDic = feedDic[@"learningObj"];
    NSString *bgUrl = feeddVideoDic[@"bgUrl"];
    return bgUrl;
}


+ (UIImage*)getVideoImageWithUrl:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    if (!asset) {
        return [UIImage imageNamed:@""];
    }
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
    return thumbnailImage;
}


+ (NSMutableArray *)getFloatLayerDataWithPartModel:(TAAIPartModel *)partModel {
    NSMutableArray *dataArray = [NSMutableArray new];
    NSDictionary *learnObjDic = partModel.learningObj;
    NSArray *keywordListArr = learnObjDic[@"keywordList"];
    if (keywordListArr.count == 0||[keywordListArr isKindOfClass:[NSNull class]]) {
        return dataArray;
    }
    NSDictionary *valueDic = keywordListArr.firstObject;
    [dataArray addObject:valueDic[@"description"]];
  
    NSArray *exListArray = valueDic[@"keywordExtList"];
    if (exListArray.count > 0) {
        for (NSDictionary *extDic in exListArray) {
            [dataArray addObject:extDic[@"description"]];
        }
    }
    return dataArray;
}


+ (NSString *)postFollowReadDataServiceWithMessageDic:(NSDictionary *)messageDic PartModel:(TAAIPartModel *)partModel SectionModel:(TAAIClassSectionModel *)sectionModel {
    NSDictionary *partDic = partModel.questionObj;
    NSDictionary *result = messageDic[@"result"];
    NSString *score = result[@"overall"];
    NSString *fluencyOverall = result[@"fluency"][@"overall"]; //流利度总体得分--> 流利度
    NSString *integrity = result[@"integrity"]; //完整度评分-->词汇量
    NSString *rhythmOverall = result[@"rhythm"][@"overall"]; //韵律得分-->发音标准
    NSString *answerAssess = [NSString stringWithFormat:@"%@|%@|%@",fluencyOverall,integrity,rhythmOverall];
    
    NSDictionary *clientAnswerDic = @{@"questionId":[NSString stringWithFormat:@"%@",partDic[@"questionId"]],
                                      @"questionType":@"1",
                                      @"answerType":@"AUDIO",
                                      @"answerContent":messageDic[@"audioUrl"],//url
                                      @"answerAssessTotalScore":score,//错误0 正确1
                                      @"answerAssess":@"流利度|词汇量|发音标准",
                                      @"answerAssessScore":answerAssess,
                                      @"partId":partModel.partId
    };
    
    NSArray * clientArray = @[clientAnswerDic];
    
    NSDictionary *params = @{@"clientId":@"889017717",
                             @"sectionId":sectionModel.sectionId,
                             @"lessonId":sectionModel.lessonId,
                             @"courseId":sectionModel.courseId,
                             @"clientAnswerList":clientArray,
    };
    ZR_Request *request = [ZR_Request cc_requestWithUrl:@"business/clientAnswerSubmit" isPost:YES Params:params];
    [request cc_sendRequstWith:^(NSDictionary *jsonDic) {
        if([jsonDic[@"code"] isEqualToNumber:@20000]){
            NSLog(@"提交成功");
        }
    } failCompletion:^(NSString *eerorString) {
        NSLog(@"跟读提交失败");
    } WithString:nil];
    return  @"";
}


+ (NSString *)postChoiceDataToServicewWithPartModel:(TAAIPartModel *)partModel SectionModel:(TAAIClassSectionModel *)sectionModel answer:(NSString *)answer correct:(NSString *)correct {
    NSDictionary *partDic = partModel.questionObj;
    NSDictionary *clientAnswerDic = @{@"questionId":partDic[@"questionId"],
                                      @"questionType":@"0",
                                      @"answerType":partDic[@"titleType"],
                                      @"answerContent":answer,//选项
                                      @"answerCorrect":correct,//错误0 正确1
                                      @"partId":[NSString stringWithFormat:@"%@",partModel.partId],
    };
    
    NSArray * clientArray = @[clientAnswerDic];
    
    NSDictionary *params = @{@"clientId":@"889017717",
                             @"sectionId":sectionModel.sectionId,
                             @"lessonId":sectionModel.lessonId,
                             @"courseId":sectionModel.courseId,
                             @"clientAnswerList":clientArray,
    };
    
    
    ZR_Request *request = [ZR_Request cc_requestWithUrl:@"business/clientAnswerSubmit" isPost:YES Params:params];
    [request cc_sendRequstWith:^(NSDictionary *jsonDic) {
        if([jsonDic[@"code"] isEqualToNumber:@20000]){
            NSLog(@"答题提交成功");
        }
    } failCompletion:^(NSString *eerorString) {
         NSLog(@"答题提交失败");
    } WithString:nil];
    return @"";
}

+ (NSString *)postAITestToServiceWithSectionModel:(TAAIClassSectionModel *)sectionModel WithdataArray:(nonnull NSMutableArray *)dataArray{
    NSDictionary *params = @{@"clientId":@"889017717",
                             @"sectionId":sectionModel.sectionId,
                             @"lessonId":sectionModel.lessonId,
                             @"courseId":sectionModel.courseId,
                             @"clientAnswerList":dataArray,
    };
    ZR_Request *request = [ZR_Request cc_requestWithUrl:@"business/clientAnswerSubmit" isPost:YES Params:params];
    [request cc_sendRequstWith:^(NSDictionary *jsonDic) {
        if([jsonDic[@"code"] isEqualToNumber:@20000]){
            NSLog(@"答题提交成功");
        }
    } failCompletion:^(NSString *eerorString) {
        NSLog(@"答题提交失败");
    } WithString:nil];
    return @"";
}

+ (void)postProgressToServiceWithClientId:(NSString *)userId setionId:(NSString *)sectionId lessonId:(NSString *)lessonId courseId:(NSString *)courseId isStartProgress:(NSString *)isStartProgress {
    NSDictionary *params = @{@"clientId":userId,
                             @"sectionId":sectionId,
                             @"lessonId":lessonId,
                             @"courseId":courseId,
                             @"isStartProgress":isStartProgress
    };
    
    ZR_Request *request = [ZR_Request cc_requestWithUrl:@"business/clientProgress" isPost:YES Params:params];
    [request cc_sendRequstWith:^(NSDictionary *jsonDic) {
        if ([jsonDic[@"code"] isEqualToNumber:@20000]) {
            NSLog(@"上传进度成功");
        }
    } failCompletion:^(NSString *eerorString) {
        NSLog(@"上传进度失败");
    } WithString:nil];
    
}

@end
