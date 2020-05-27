//
//  TAAIDetailCourseList.m
//  TutorABC
//
//  Created by 葛优 on 2020/5/16.
//  Copyright © 2020 Slark. All rights reserved.
//

#import "TAAIDetailCourseListModel.h"

@implementation TAAIDetailCourseListModel

- (instancetype)init{
    
    if (self=[super init]) {
        
        [TAAIDetailCourseListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                    @"ai_description" : @"description"
                     };
        }];
        
    }
    return self;
}

@end
