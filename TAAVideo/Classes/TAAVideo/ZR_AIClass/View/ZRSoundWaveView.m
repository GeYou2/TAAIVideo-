//
//  ZRSoundWaveView.m
//  ZRKit
//
//  Created by HaoCold on 2018/11/20.
//  Copyright © 2018 HaoCold. All rights reserved.
//
//  MIT License
//
//  Copyright (c) 2018 xZR093
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "ZRSoundWaveView.h"

@implementation ZRSoundWaveConfig

- (instancetype)init{
    if ([super init]) {
        _count = 3;
        _width = 2;
        _color = [UIColor whiteColor];
        _leftMargin = 0;
        _space = 2;
    }
    return self;
}

@end

@interface ZRSoundWaveBar : UIView
@property (nonatomic,  assign) CGFloat  duration;

@property (nonatomic,  strong) UIView *bar;
@property (nonatomic,  strong) UIColor *color;
@property (nonatomic,  strong) NSTimer *timer;
@property (nonatomic,  assign) CGFloat radius;

- (void)shouldStartAnimation:(BOOL)flag;

@end

@implementation ZRSoundWaveBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    if (!newSuperview) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)setupViews
{
    UIView *view = [[UIView alloc] init];
    view.frame = self.bounds;
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    self.bar = view;
    
    self.transform = CGAffineTransformMakeRotation(M_PI);
}

- (void)animation
{
    [UIView animateWithDuration:self.duration*0.5 animations:^{
        self.bar.frame = CGRectMake(0, self.height/2-self.height/4, self.width, self.height/2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:self.duration*0.3 animations:^{
            self.bar.frame = self.bounds;
        }];
    }];
    
}

- (void)shouldStartAnimation:(BOOL)flag
{
    if (flag) {
        [self.timer fire];
    }else{
        [self.timer invalidate];
        _timer = nil;
    }
}

- (void)setColor:(UIColor *)color{
    _color = color;
    self.bar.backgroundColor = color;
}

- (void)setRadius:(CGFloat)radius{
    _radius = radius;
    self.bar.clipsToBounds = YES;
    self.bar.layer.cornerRadius = radius;
}

- (NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:self.duration target:self selector:@selector(animation) userInfo:nil repeats:YES];
    }
    return _timer;
}

@end


@interface ZRSoundWaveView()
@property (nonatomic,  strong) ZRSoundWaveConfig *config;
@end

@implementation ZRSoundWaveView

- (instancetype)init{
    return [[ZRSoundWaveView alloc] initWithFrame:CGRectMake(0, 0, 10, 10) config:[[ZRSoundWaveConfig alloc] init]];
}

- (instancetype)initWithFrame:(CGRect)frame{
    return [[ZRSoundWaveView alloc] initWithFrame:frame config:[[ZRSoundWaveConfig alloc] init]];
}

- (instancetype)initWithFrame:(CGRect)frame config:(ZRSoundWaveConfig *)config{
    if (self = [super initWithFrame:frame]) {
        _config = config;
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    for (NSInteger i = 0; i < _config.count; i++) {
        ZRSoundWaveBar *bar = [[ZRSoundWaveBar alloc] initWithFrame:CGRectMake(_config.leftMargin+(_config.width+_config.space)*i, 0, _config.width, CGRectGetHeight(self.bounds))];
        bar.duration = 1+0.1*(i%_config.count*0.25);
        bar.color = _config.color;
        bar.radius = _config.radius;
        [self addSubview:bar];
    }
    
    UIView *bar = [self.subviews lastObject];
    CGFloat maxWidth = CGRectGetMaxX(bar.frame);
    CGRect frame = self.frame;
    frame.size.width = maxWidth;
    self.frame = frame;
}

- (void)shouldStartAnimation:(BOOL)flag
{
    for (ZRSoundWaveBar *subview in self.subviews) {
        [subview shouldStartAnimation:flag];
    }
}

- (void)startAnimation
{
    [self shouldStartAnimation:YES];
}

- (void)stopAnimation
{
    [self shouldStartAnimation:NO];
}

@end

