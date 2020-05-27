//
//  TAAISectionView.h
//  TutorABC
//
//  Created by 葛优 on 2020/5/13.
//  Copyright © 2020 Slark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAAISectionModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TAAISectionViewDelegate <NSObject>
- (void)TAAISectionViewDidClickSection:(NSInteger )index;

@end

@interface TAAISectionView : UIView

@property (nonatomic, weak) id<TAAISectionViewDelegate> delegate;
- (void)setDataWithSections:(NSArray *)model;
- (void)highlightWithSection:(NSInteger)inidex;

@end

NS_ASSUME_NONNULL_END
