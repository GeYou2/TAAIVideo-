//
//  TAAILearnModel.h
//  TutorABC
//
//  Created by 葛优 on 2020/5/19.
//  Copyright © 2020 Slark. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TAAILearnListBannerModel : NSObject
@property (nonatomic, copy) NSString *bannerImage;//Banner图片URL
//Banner跳转链接URL(可以为空,为空就不能跳转)
@property (nonatomic, copy) NSString *bannerLink;
@property (nonatomic, copy) NSString *isBuy;//是否购买
@property (nonatomic, copy) NSString *isOpen;//开关(开:1 关:0  关时不展示底部banner)
@property (nonatomic, strong) NSArray *courseList;//标题
@end

NS_ASSUME_NONNULL_END
