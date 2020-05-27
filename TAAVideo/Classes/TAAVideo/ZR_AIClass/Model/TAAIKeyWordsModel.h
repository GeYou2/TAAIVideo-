//
//  TAAIKeyWordsModel.h
//  TutorABC
//
//  Created by Slark on 2020/5/17.
//  Copyright © 2020 Slark. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TAAIKeyWordsModel : NSObject

@property (nonatomic, copy) NSString *extType;
@property (nonatomic, copy) NSString *keywordId;
@property (nonatomic, copy) NSString *extDescription;
@property (nonatomic, strong) NSArray *keywordExtList;
@property (nonatomic, copy) NSString *keywordExtId;
@property (nonatomic, copy) NSString *DDescription;
@property (nonatomic, copy) NSString *keywordType;
@property (nonatomic, copy) NSString *appearTime;
@property (nonatomic, copy) NSString *continueTime;

@end

NS_ASSUME_NONNULL_END
