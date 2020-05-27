//
//  TAAIKeyWordsView.h
//  DevelopmentFramework
//
//  Created by Slark on 2020/5/9.
//  Copyright © 2020 Slark. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TAAIKeyWordsView : UIView

@property (nonatomic, strong) NSMutableArray *dataArray;

- (instancetype)initWithArray:(NSMutableArray*)dataArray;

@end

NS_ASSUME_NONNULL_END
