//
//  TAAICourseCoverView.h
//  TutorABC
//
//  Created by 葛优 on 2020/5/16.
//  Copyright © 2020 Slark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAAIDetailCourseListModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol TAAICourseCoverViewDelegate <NSObject>
- (void)chooseCourse:(NSInteger)courseIndex;
@end
@interface TAAICourseCoverView : UIView
@property (nonatomic, weak) id<TAAICourseCoverViewDelegate> delegate;
- (void)fetchDataWithImages:(TAAIDetailCourseListModel *)model;
@end

NS_ASSUME_NONNULL_END
