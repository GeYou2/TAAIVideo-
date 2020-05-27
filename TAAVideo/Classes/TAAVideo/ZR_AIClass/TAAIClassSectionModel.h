//
//  TAAISectionModel.h
//  TutorABC
//
//  Created by Slark on 2020/5/17.
//  Copyright © 2020 Slark. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TAAIClassSectionModel : NSObject

@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSArray *partList;
@property (nonatomic, copy) NSString *lessonId;
@property (nonatomic, copy) NSString *courseId;
@property (nonatomic, copy) NSString *sectionId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *nextSection;
@property (nonatomic, copy) NSString *currentSection;
@property (nonatomic, copy) NSString *aiEvaluating;

@end

NS_ASSUME_NONNULL_END
