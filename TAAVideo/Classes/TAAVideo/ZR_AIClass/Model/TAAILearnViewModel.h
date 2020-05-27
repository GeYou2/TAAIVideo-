//
//  TAAILearnViewModel.h
//  TutorABC
//
//  Created by Slark on 2020/5/19.
//  Copyright © 2020 Slark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TAAIPartModel.h"
#import "TAAIClassSectionModel.h"
#import "TAAIQuestionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TAAILearnViewModel : NSObject

+ (NSString *)getFailFeedBackVideoUrlWithPartModel:(TAAIPartModel *)partModel;

+ (NSString *)getSuccessFeedBackVieeoUrlWithPartModel:(TAAIPartModel *)partModel;

+ (UIImage *)getVideoImageWithUrl:(NSURL *)videoURL atTime:(NSTimeInterval)time;

+ (NSMutableArray *)getFloatLayerDataWithPartModel:(TAAIPartModel *)partModel;

+ (NSString *)postChoiceDataToServicewWithPartModel:(TAAIPartModel *)partModel SectionModel:(TAAIClassSectionModel *)sectionModel answer:(NSString *)answer correct:(NSString *)correct;

+ (NSString *)postFollowReadDataServiceWithMessageDic:(NSDictionary *)messageDic PartModel:(TAAIPartModel *)partModel SectionModel:(TAAIClassSectionModel *)sectionModel;

+ (NSString *)postAITestToServiceWithSectionModel:(TAAIClassSectionModel *)sectionModel WithdataArray:(NSMutableArray *)dataArray;

+ (void)postProgressToServiceWithClientId:(NSString *)userId setionId:(NSString *)sectionId lessonId:(NSString *)lessonId courseId:(NSString *)courseId isStartProgress:(NSString *)isStartProgress;

@end

NS_ASSUME_NONNULL_END
