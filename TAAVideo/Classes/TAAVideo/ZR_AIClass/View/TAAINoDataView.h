//
//  TAAINoDataView.h
//  TutorABC
//
//  Created by Slark on 2020/5/23.
//  Copyright © 2020 Slark. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol TAAINoDataViewDelegate <NSObject>

- (void)refrash;
@end
@interface TAAINoDataView : UIView
@property (nonatomic, weak) id<TAAINoDataViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
