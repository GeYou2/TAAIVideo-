//
//  TAAIPartModel.h
//  TutorABC
//
//  Created by Slark on 2020/5/17.
//  Copyright © 2020 Slark. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TAAIPartModel : NSObject

@property (nonatomic, copy) NSString *partStatus;
@property (nonatomic, copy) NSString *partId;
@property (nonatomic, copy) NSString *currentPart;
@property (nonatomic, copy) NSString *partType;
@property (nonatomic, copy) NSString *childParts;
@property (nonatomic, copy) NSString *courseId;
@property (nonatomic, copy) NSString *currentPartType;
@property (nonatomic, copy) NSString *contentId;
@property (nonatomic, copy) NSString *childPart;
@property (nonatomic, copy) NSString *childPartOption;
@property (nonatomic, copy) NSString *lessonId;
@property (nonatomic, copy) NSString *sectionId;
@property (nonatomic, strong) NSDictionary *learningObj;
@property (nonatomic, strong) NSDictionary *questionObj;

@end

NS_ASSUME_NONNULL_END
