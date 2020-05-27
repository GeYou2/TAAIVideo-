//
//  TAAIScoreImageView.m
//  TutorABC
//
//  Created by Slark on 2020/5/23.
//  Copyright © 2020 Slark. All rights reserved.
//

#import "TAAIScoreImageView.h"

@interface TAAIScoreImageView()

@property (nonatomic, strong) UILabel* scoreLabel;
@property (nonatomic, strong) UILabel* fenLabel;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *starImageView;
@property (nonatomic, strong) UIImageView *greateImageView;

@end

@implementation TAAIScoreImageView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"编组"]];
    [self addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
        make.width.height.mas_equalTo(self);
    }];
    
    self.greateImageView = [[UIImageView alloc] init];
    [self addSubview:self.greateImageView];
    [self.greateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
    
    self.starImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"编组 2"]];
    [self addSubview:self.starImageView];
    [self.starImageView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.center.mas_equalTo(self);
    }];
    
    self.scoreLabel = [[UILabel alloc] init];
    self.scoreLabel.font = [UIFont systemFontOfSize:40];
    self.scoreLabel.textColor = [UIColor whiteColor];
    self.scoreLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.scoreLabel];
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ScreenWidth/2-30);
        make.centerY.mas_equalTo(self);
    }];
    
    self.fenLabel = [[UILabel alloc] init];
    self.fenLabel.text = @"分";
    self.fenLabel.font = [UIFont systemFontOfSize:18];
    self.fenLabel.textColor = [UIColor whiteColor];
    self.fenLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.fenLabel];
    [self.fenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scoreLabel.mas_right).with.offset(10);
        make.bottom.mas_equalTo(self.scoreLabel.mas_bottom).with.offset(-8);
    }];
}

- (void)setScoreState:(TAAIScoreState)scoreState {
    _scoreState = scoreState;
    if (scoreState == TAAIScoreStateGreat) {
        [self hideenScore];
        self.greateImageView.image = [UIImage imageNamed:@"Great"];
    }else if (scoreState == TAAIScoreStateReadGood){
        [self hideenGreate];
        self.fenLabel.textColor = RGBColor(32, 241, 116);
        self.scoreLabel.textColor = RGBColor(32, 241, 116);
    }else if (scoreState == TAAIScoreStateOops){
        [self hideenScore];
        self.starImageView.hidden = YES;
        self.greateImageView.image = [UIImage imageNamed:@"Oops"];
    }else if (scoreState == TAAIScoreStateReadCommon){
        [self hideenGreate];
        self.fenLabel.textColor = [UIColor whiteColor];
        self.scoreLabel.textColor = [UIColor whiteColor];
    }
}

- (void)hideenScore {
    self.fenLabel.hidden = YES;
    self.scoreLabel.hidden = YES;
    self.greateImageView.hidden = NO;
    self.starImageView.hidden = NO;
}

- (void)hideenGreate {
    self.fenLabel.hidden = NO;
    self.scoreLabel.hidden = NO;
    self.greateImageView.hidden = YES;
    self.starImageView.hidden = YES;
}

- (void)setScoreString:(NSString *)scoreString {
    _scoreString = scoreString;
    self.scoreLabel.text = [NSString stringWithFormat:@"%@",scoreString];
}

@end
