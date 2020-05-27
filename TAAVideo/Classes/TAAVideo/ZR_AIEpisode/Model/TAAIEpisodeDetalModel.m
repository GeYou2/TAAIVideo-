//
//  TAAIEpisodeDetalModel.m
//  TutorABC
//
//  Created by 葛优 on 2020/5/16.
//  Copyright © 2020 Slark. All rights reserved.
//

#import "TAAIEpisodeDetalModel.h"
#import "TAAIDetailCourseListModel.h"
@implementation TAAIEpisodeDetalModel
- (instancetype)init{
    
    if (self=[super init]) {
        
        [TAAIEpisodeDetalModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                    @"ai_description" : @"description"
                     };
        }];
        
    }
    return self;
}

- (NSString *)level {
    NSArray *levelarr = [_level componentsSeparatedByString:@"-"];
    if (levelarr.count == 2) {
        if ([levelarr[0] isEqual:levelarr[1]]) {
            _level = levelarr[0];
        }
    }
    return _level;
}

- (NSArray *)lessonList {
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSDictionary *dict in _lessonList) {
        TAAIDetailCourseListModel *listModel = [TAAIDetailCourseListModel mj_objectWithKeyValues:dict];
        [tempArr addObject:listModel];
    }
    return tempArr;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
