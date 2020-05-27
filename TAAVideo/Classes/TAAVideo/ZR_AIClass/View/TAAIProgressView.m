//
//  TAAIProgressView.m
//  TutorABC
//
//  Created by Slark on 2020/5/22.
//  Copyright © 2020 Slark. All rights reserved.
//

#import "TAAIProgressView.h"

@interface TAAIProgressView()

@property (nonatomic, strong) UILabel *indexLabel;


@end

@implementation TAAIProgressView

//- (instancetype)initWithProgressCount:(NSInteger)count{
//    if (!self) {
//        self = [super init];
//        [self setUpwWithCount:count];
//    }
//    return self;
//}

- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    [self setUpwWithCount:dataArray.count];
}

- (void)setUpwWithCount:(NSInteger)count{
    CGFloat space = ScreenWidth / count ;
    for (NSInteger i = 0; i < count; i ++) {
        UILabel *label = [[UILabel alloc] init];
        [self addSubview:label];
        label.frame = RR(space*i+space, 0, 2, 3);
        label.backgroundColor = [UIColor whiteColor];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
