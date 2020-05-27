//
//  ZRCircleProgress.m
//  ZRProgressView
//
//  Created by Mars on 2017/11/28.
//  Copyright © 2017年 赵向禹. All rights reserved.
//

#import "ZRCircleProgress.h"
#import "ZRSoundWaveView.h"
@interface ZRCircleProgress ()
{
    /** 原点 */
    CGPoint _origin;
    /** 半径 */
    CGFloat _radius;
    /** 起始 */
    CGFloat _startAngle;
    /** 结束 */
    CGFloat _endAngle;
}
/** 底层显示层 */
@property (nonatomic, strong) CAShapeLayer *bottomLayer;
/** 顶层显示层 */
@property (nonatomic, strong) CAShapeLayer *topLayer;
/**动画*/
@property (nonatomic, strong) ZRSoundWaveView *soundWaveView;
@end

@implementation ZRCircleProgress

- (instancetype)initWithFrame:(CGRect)frame progress:(CGFloat)progress {
    if (self) {
        self = [super initWithFrame:frame];
        self.backgroundColor = [UIColor clearColor];
        [self setUI];
        self.progress = progress;
    }
    return self;
}

#pragma mark - 初始化页面
- (void)setUI {
    
    [self.layer addSublayer:self.bottomLayer];
    [self.layer addSublayer:self.topLayer];
    ZRSoundWaveConfig *config = [[ZRSoundWaveConfig alloc] init];
    config.count = 3;
    config.space = 2;
    config.width = 4;
    config.radius = 2;
    config.color = [UIColor colorWithRed:95.0/255.0 green:197.0/255.0 blue:151.0/255.0 alpha:1];
    self.soundWaveView = [[ZRSoundWaveView alloc] initWithFrame:CGRectMake(0, 0, 20, 20) config:config];
    [self.soundWaveView startAnimation];
    self.soundWaveView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    [self addSubview:self.soundWaveView];
    _origin = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    _radius = self.bounds.size.width / 2;
    
    UIBezierPath *bottomPath = [UIBezierPath bezierPathWithArcCenter:_origin radius:_radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    _bottomLayer.path = bottomPath.CGPath;    
}
- (void)startAnimation {
    [self.soundWaveView startAnimation];
}
- (void)stopAnimation {
    [self.soundWaveView stopAnimation];
}
#pragma mark - 懒加载
- (CAShapeLayer *)bottomLayer {
    if (!_bottomLayer) {
        _bottomLayer = [CAShapeLayer layer];
        _bottomLayer.fillColor = [UIColor clearColor].CGColor;
    }
    return _bottomLayer;
}

- (CAShapeLayer *)topLayer {
    if (!_topLayer) {
        _topLayer = [CAShapeLayer layer];
        _topLayer.lineCap = kCALineCapRound;
        _topLayer.fillColor = [UIColor clearColor].CGColor;
    }
    return _topLayer;
}

#pragma mark - setMethod
- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    
    _startAngle = - M_PI_2;
    _endAngle = _startAngle + _progress * M_PI * 2;
    
    UIBezierPath *topPath = [UIBezierPath bezierPathWithArcCenter:_origin radius:_radius startAngle:_startAngle endAngle:_endAngle clockwise:YES];
    _topLayer.path = topPath.CGPath;
}

- (void)setBottomColor:(UIColor *)bottomColor {
    _bottomColor = bottomColor;
    _bottomLayer.strokeColor = _bottomColor.CGColor;
}

- (void)setTopColor:(UIColor *)topColor {
    _topColor = topColor;
    _topLayer.strokeColor = _topColor.CGColor;
}

- (void)setProgressWidth:(CGFloat)progressWidth {
    
    _progressWidth = progressWidth;
    _topLayer.lineWidth = progressWidth;
    _bottomLayer.lineWidth = progressWidth;
}

@end
