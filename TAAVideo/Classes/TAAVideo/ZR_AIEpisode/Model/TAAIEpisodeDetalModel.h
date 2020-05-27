//
//  TAAIEpisodeDetalModel.h
//  TutorABC
//
//  Created by 葛优 on 2020/5/16.
//  Copyright © 2020 Slark. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TAAIEpisodeDetalModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic,copy)NSString *subtitle;
@property (nonatomic,copy)NSString *ai_description;
@property (nonatomic,copy)NSString *lessonCount;
@property (nonatomic,copy)NSString *finishLessonCount;
@property (nonatomic,copy)NSString *target ;
@property (nonatomic,copy)NSString *content;
@property (nonatomic, copy) NSString *coursePrice;
@property (nonatomic,copy)NSString *level;
@property (nonatomic,copy)NSString *detailsImage;
@property (nonatomic,copy)NSString *detailsVideo;
@property (nonatomic,copy)NSString *footerDetailsUrl;
@property (nonatomic,copy)NSString *isBuy;
@property (nonatomic,strong)NSArray *lessonList;
@end

NS_ASSUME_NONNULL_END
