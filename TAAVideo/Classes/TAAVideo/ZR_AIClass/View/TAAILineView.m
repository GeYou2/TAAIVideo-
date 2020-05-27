//
//  TestLineView.m
//  DevelopmentFramework
//
//  Created by Slark on 2020/5/9.
//  Copyright © 2020 Slark. All rights reserved.
//

#import "TAAILineView.h"

@interface TAAILineView()

@property (nonatomic, strong) UILabel *lineLabel;
@property (nonatomic, strong) UILabel *cornerLabel;

@end

@implementation TAAILineView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp{
    self.lineLabel = [[UILabel alloc]init];
    self.lineLabel.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.lineLabel];
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@3);
        make.right.equalTo(@-6);
        make.height.equalTo(@(1));
    }];

    self.cornerLabel = [[UILabel alloc]init];
    self.cornerLabel.layerCornerRadius = 2;
    self.cornerLabel.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.cornerLabel];
    [self.cornerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0);
        make.top.equalTo(@0);
        make.width.height.equalTo(@6);
    }];
}
@end
