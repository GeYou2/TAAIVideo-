//
//  TAAILearnListModel.h
//  TutorABC
//
//  Created by Slark on 2020/5/7.
//  Copyright © 2020 Slark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TAAILearnListModel : NSObject

@property (nonatomic, copy) NSString *title;//标题
@property (nonatomic, copy) NSString *coverImage;//封面图片
@property (nonatomic, copy) NSString *level;//课程等级
@property (nonatomic, copy) NSString *courseId;//课程ID
@property (nonatomic, copy) NSString *courseTags;//有值就显示互动课
@property (nonatomic, copy) NSString *description;//描述
@property (nonatomic, copy) NSString *DDescription;//描述
@property (nonatomic, assign) NSInteger isBuy;
@end

