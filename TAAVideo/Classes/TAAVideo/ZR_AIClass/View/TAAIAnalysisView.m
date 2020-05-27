//
//  TAAIAnalysisView.m
//  TutorABC
//
//  Created by Slark on 2020/5/15.
//  Copyright © 2020 Slark. All rights reserved.
//

#import "TAAIAnalysisView.h"

@interface TAAIAnalysisView()

@property (nonatomic, strong) UILabel *headTitle;
@property (nonatomic, strong) UILabel *contenLabel;
@property (nonatomic, copy) NSString *contentString;

@end

@implementation TAAIAnalysisView

- (instancetype)initWithContent:(NSString *)content {
    self = [super init];
    if (self) {
        self.contentString = content;
        self.clipsToBounds = YES;
        [self setUp];
    }
    return self;
}

- (void)setUp{
    self.headTitle = [[UILabel alloc] init];
    self.headTitle. text = @"解析:";
    self.headTitle.font = [UIFont systemFontOfSize:14];
    self.headTitle.textColor = [UIColor UIColorFormHexString:@"#0A1F44"];
    self.headTitle.textAlignment = NSTextAlignmentLeft;
    
    [self addSubview:self.headTitle];
    [self.headTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
    
    self.contenLabel = [[UILabel alloc] init];
    self.contenLabel. text = self.contentString;
    self.contenLabel.font = [UIFont systemFontOfSize:14];
    self.contenLabel.textColor = [UIColor UIColorFormHexString:@"#53627C"];
    self.contenLabel.textAlignment = NSTextAlignmentLeft;
    self.contenLabel.numberOfLines = 0;
    
    [self addSubview:self.contenLabel];
    [self.contenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.headTitle.mas_bottom).with.offset(7);
        make.bottom.mas_equalTo(0);
      //  make.height.mas_equalTo(20);
    }];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contenLabel).mas_offset(1);
    }];
    
}

@end
