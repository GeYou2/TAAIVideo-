//
//  TAAIProtocol.h
//  TutorABC
//
//  Created by Slark on 2020/5/26.
//  Copyright © 2020 Slark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITGUserProtocol.h"

@protocol TAAIClientDelegate <NSObject>

@end

NS_ASSUME_NONNULL_BEGIN

@interface TAAIProtocol : NSObject<ITGUserProtocol>

@property (nonatomic, weak)id <ITGUserProtocol> delegate;

@end

NS_ASSUME_NONNULL_END
