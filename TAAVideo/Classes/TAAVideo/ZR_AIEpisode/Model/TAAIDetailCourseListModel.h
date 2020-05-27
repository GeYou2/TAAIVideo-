//
//  TAAIDetailCourseList.h
//  TutorABC
//
//  Created by 葛优 on 2020/5/16.
//  Copyright © 2020 Slark. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TAAIDetailCourseListModel : NSObject
@property (nonatomic, copy) NSString *lessonId;
@property (nonatomic,copy)NSString *studyStatus;
@property (nonatomic,copy)NSString *ai_description;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *coverImage;
@property (nonatomic,copy)NSString *isFree ;
//@property (nonatomic,copy)NSString *isLock;
@property (nonatomic,copy)NSString *hasReport;
@property (nonatomic,copy)NSString *isBuy;
@end

NS_ASSUME_NONNULL_END
