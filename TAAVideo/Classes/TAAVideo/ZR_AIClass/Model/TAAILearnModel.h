//
//  TAAILearnModel.h
//  TutorABC
//
//  Created by Slark on 2020/5/17.
//  Copyright © 2020 Slark. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TAAILearnModel : NSObject

@property (nonatomic, copy) NSString *courseId;
@property (nonatomic, copy) NSString *sectionProgress;
@property (nonatomic, copy) NSString *lessonId;
@property (nonatomic, strong) NSArray *sectionList;

@end

NS_ASSUME_NONNULL_END
