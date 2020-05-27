//
//  TAAILearnObjModel.h
//  TutorABC
//
//  Created by Slark on 2020/5/17.
//  Copyright © 2020 Slark. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TAAILearnObjModel : NSObject

@property (nonatomic, copy) NSString *bgUrl;
@property (nonatomic, copy) NSString *bgType;
@property (nonatomic, copy) NSString *learningId;
@property (nonatomic, copy) NSString *keywordIds;
@property (nonatomic, copy) NSString *cnSubtitlesUrl;
@property (nonatomic, copy) NSString *enSubtitlesUrl;
@property (nonatomic, copy) NSString *cnSubtitles;
@property (nonatomic, copy) NSString *enSubtitles;
@property (nonatomic, copy) NSString *audioUrl;
@property (nonatomic, strong) NSArray *keywordList;

@end

NS_ASSUME_NONNULL_END
