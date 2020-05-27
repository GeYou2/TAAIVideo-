//
//  TAAICourseCoverView.m
//  TutorABC
//
//  Created by 葛优 on 2020/5/16.
//  Copyright © 2020 Slark. All rights reserved.
//

#import "TAAICourseCoverView.h"

@interface TAAICourseCoverView()
@property (nonatomic, strong) UIImageView *mainImageView;
@property (nonatomic, strong) UIView *coverView;//用来变暗的视图
@property (nonatomic, strong) UILabel *courseTitleLabel;
@property (nonatomic, strong) UILabel *subcourseTitleLabel;
@property (nonatomic, strong) UIImageView *lockIcon;//锁图标
@property (nonatomic, strong) UIImageView *stateBgImage;//状态贴图
@property (nonatomic, strong) UIProgressView *progressView;//已学进度
@property (nonatomic, strong) UIImageView *lineView;
@property (nonatomic, strong) UIImageView *selectIconView;
@property (nonatomic, strong) UIImageView *freeIcon;//免费角标
@end

@implementation TAAICourseCoverView
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubview:self.mainImageView];
        [self.mainImageView addSubview:self.coverView];
        [self.mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.width.equalTo(self);
            make.bottom.mas_equalTo(-30);
        }];
        
        [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        [self.mainImageView addSubview:self.lockIcon];
        [self.lockIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(30);
            make.center.mas_equalTo(0);
        }];
        
        [self.mainImageView addSubview:self.stateBgImage];
        [self.stateBgImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(7);
            make.bottom.mas_equalTo(-50);
            make.width.mas_equalTo(self.mainImageView.mas_width).multipliedBy(0.4);
            make.height.mas_equalTo(self.stateBgImage.mas_width).multipliedBy(0.48);
        }];
        
        [self.mainImageView addSubview:self.courseTitleLabel];
        [self.courseTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.stateBgImage);
            make.top.equalTo(self.stateBgImage.mas_bottom).offset(0);
            make.height.mas_equalTo(20);
            make.right.mas_equalTo(-20);
        }];
        
        [self.mainImageView addSubview:self.subcourseTitleLabel];
        [self.subcourseTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.stateBgImage);
            make.top.equalTo(self.courseTitleLabel.mas_bottom).offset(0);
            make.height.width.equalTo(self.courseTitleLabel);
        }];
        //免费角标
        self.freeIcon = [[UIImageView alloc] init];
        [self.mainImageView addSubview:self.freeIcon];
        [self.freeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.mas_equalTo(0);
            make.width.height.mas_equalTo(50);
        }];
        self.freeIcon.image = [UIImage imageNamed:@"路径备份 6"];
        //学习进度条
        [self.mainImageView addSubview:self.progressView];
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(4);
        }];
        self.progressView.layer.cornerRadius = 2;
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleCellTapAction:)];
        [self addGestureRecognizer:singleTap];
        
        [self addSubview:self.selectIconView];
        self.selectIconView.image = [UIImage imageNamed:@"椭圆形备份 2"];
        self.selectIconView.userInteractionEnabled=YES;
        [self.selectIconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(6);
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(-8);
        }];
        

        UIImageView *lineView = [[UIImageView alloc] init];
        lineView.userInteractionEnabled = YES;
        lineView.alpha=0.3;
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(20);
        }];
        UIImageView *line = [[UIImageView alloc] init];
        [lineView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(3);
        }];
        //绘制虚线
        [self drawDashLine:line lineLength:8 lineSpacing:2 lineColor:[UIColor colorWithRed:229.0/255.0 green:123.0/255.0 blue:119.0/255.0 alpha:1]];
        
    }
    return self;
}

#pragma mark - Fetch
- (void)fetchDataWithImages:(TAAIDetailCourseListModel *)model {
    [self.mainImageView sd_setImageWithURL:[NSURL URLWithString:model.coverImage]];
     self.progressView.hidden = NO;
    if ([model.studyStatus intValue] == 0) {
        //未开始带挑战
        self.stateBgImage.image = [UIImage imageNamed:@"icon_wait"];
        self.progressView.progress = 0;
    }else if ([model.studyStatus intValue] == 1) {
        //学习中
        self.stateBgImage.image = [UIImage imageNamed:@"icon_study"];
        self.progressView.progress = 0.5;
    }else if ([model.studyStatus intValue] == 2){
        //学习完成
        self.stateBgImage.image = [UIImage imageNamed:@"study"];
        self.progressView.hidden = YES;
    }
    
    
    self.courseTitleLabel.text = model.title;
    self.subcourseTitleLabel.text = model.ai_description;
    
    //未购买
    if ([model.isBuy intValue] == 0) {
        if ([model.isFree intValue] == 1) {
            self.freeIcon.hidden = NO;
            self.coverView.hidden = YES;
            self.lockIcon.hidden = YES;
        }else{
            self.freeIcon.hidden = YES;
            self.coverView.hidden = NO;
            self.lockIcon.hidden = NO;
            self.coverView.alpha=0.5;
            self.lockIcon.image = [UIImage imageNamed:@"icon_lock"];
        }
    }else {
        self.coverView.hidden = YES;
        self.lockIcon.hidden = YES;
    }
    
    
}

#pragma mark -Action
/**
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
- (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CGRect lineFrame =CGRectMake(0, 0, 135, 1);
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineFrame];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineFrame) / 2, CGRectGetHeight(lineFrame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    
    //  设置虚线颜色为
    [shapeLayer setStrokeColor:lineColor.CGColor];
    
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineFrame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(lineFrame), 0);
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}
- (void)singleCellTapAction:(UIGestureRecognizer *)gesture {
    if ([self.delegate respondsToSelector:@selector(chooseCourse:)]) {
        [self.delegate chooseCourse:self.tag];
    }
}

#pragma mark - Lazy Load
- (UIImageView *)mainImageView {
    if (_mainImageView == nil) {
        _mainImageView = [[UIImageView alloc] init];
        _mainImageView.userInteractionEnabled = YES;
    }
    return _mainImageView;
}

-(UIImageView *)stateBgImage {
    if (!_stateBgImage) {
        _stateBgImage = [[UIImageView alloc] init];
    }
    return _stateBgImage;
}

- (UIImageView *)lockIcon {
    
    if (_lockIcon == nil) {
        _lockIcon = [[UIImageView alloc] init];
        _lockIcon.userInteractionEnabled = YES;
    }
    return _lockIcon;
}

- (UIView *)coverView {
    if (_coverView == nil) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor blackColor];
    }
    return _coverView;
}

- (UILabel *)courseTitleLabel {
    if (!_courseTitleLabel) {
        _courseTitleLabel = [[UILabel alloc] init];
        _courseTitleLabel.textColor = [UIColor whiteColor];
        _courseTitleLabel.font =[UIFont boldSystemFontOfSize:10];
    }
    return _courseTitleLabel;
}

- (UILabel *)subcourseTitleLabel {
    if (!_subcourseTitleLabel) {
        _subcourseTitleLabel = [[UILabel alloc] init];
        _subcourseTitleLabel.textColor = [UIColor whiteColor];
        _subcourseTitleLabel.font =[UIFont boldSystemFontOfSize:10];
    }
    return _subcourseTitleLabel;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.progressTintColor = [UIColor redColor];
    }
    return _progressView;
}

- (UIImageView *)selectIconView {
    if (_selectIconView == nil) {
        _selectIconView = [[UIImageView alloc] init];
        _selectIconView.userInteractionEnabled=YES;
    }
    return _selectIconView;
}

- (UIImageView *)lineView {
    
    if (_lineView == nil) {
        _lineView = [[UIImageView alloc] init];
        _lineView.userInteractionEnabled = YES;
        _lineView.alpha=0.3;
    }
    return _lineView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
