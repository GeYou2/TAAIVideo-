//
//  TAAIDetailPreloadView.m
//  TutorABC
//
//  Created by 葛优 on 2020/5/17.
//  Copyright © 2020 Slark. All rights reserved.
//

#import "TAAIDetailPreloadView.h"

@interface TAAIDetailPreloadView()
@property (nonatomic, strong) UIView *introduceVIew;//课程简介视图
@property (nonatomic, strong) UILabel *courseIntroduceLabel;
@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) UILabel *progressL;//学习进度
@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) UIScrollView *courseListView;//横向滑动课程列表
@property (nonatomic, strong) UILabel *targetL;//学习目标
@property (nonatomic, strong) BoldLabel *contentLabel;
@property (nonatomic, strong) UILabel *contentL;//课程内容

@property (nonatomic, strong) UIButton *tryBtn;//免费试读按钮
@property (nonatomic, strong) UIButton *buyBtn;//立即购买按钮
@end
@implementation TAAIDetailPreloadView
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        //课程内容简介
        self.introduceVIew.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.introduceVIew];
        [self.introduceVIew mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.width.mas_equalTo(ScreenWidth);
            make.height.mas_equalTo(10000);
        }];
        [self.introduceVIew layoutIfNeeded];
        UIRectCorner rectCorner = UIRectCornerTopLeft ;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.introduceVIew.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(20, 20)];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = path.CGPath;
        self.introduceVIew.layer.mask = shapeLayer;
//
//        //课程
        BoldLabel *courseLabel = [[BoldLabel alloc] init];
        courseLabel.backgroundColor = PreLoadVIewColor;
        [self.introduceVIew addSubview:courseLabel];
        [courseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(BorderMargin);
            make.top.mas_equalTo(30);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(20);
        }];

        UIButton *courseIntroduceBtn = [[UIButton alloc] init];
        courseIntroduceBtn.backgroundColor = PreLoadVIewColor;
        [self.introduceVIew addSubview:courseIntroduceBtn];
        [courseIntroduceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(courseLabel.mas_right).offset(10);
            make.top.height.equalTo(courseLabel);
            make.right.mas_equalTo(-BorderMargin);
        }];

        //课程列表
        [self.introduceVIew addSubview:self.courseListView];
        [self.courseListView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.equalTo(courseLabel.mas_bottom).offset(10);
            make.height.mas_equalTo(190);
            make.width.equalTo(self);
        }];
        
        for (UIView *view in [self.courseListView subviews]) {
            [view removeFromSuperview];
        }
        NSMutableArray *courseViews = [NSMutableArray array];
        for (int i=0; i<3; i++) {
            UIView *coverView = [[UIView alloc] init];
            coverView.backgroundColor = PreLoadVIewColor;
            [courseViews addObject:coverView];
        }

        UIView * contenview = [UIView new];
        [self.courseListView addSubview:contenview];
        [contenview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo (self.courseListView);
            make.height.equalTo (self.courseListView); //此处没有设置宽的约束
        }];

            //关于这个延迟 因为masory创建约束之后 获取的frame 是（0，0，0，0）但是有一个延迟的话 才能获取真是的view的大小  延迟时间改成0 也可以

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                NSLog(@"******%@",contenview);
            });

            UIView * lastView ;
            for (int i = 0; i < courseViews.count ; i++) {
                UIView * view = courseViews[i];
                [contenview addSubview:view];
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo (contenview.mas_top);
                    make.bottom.mas_equalTo(-30);
                    make.left.equalTo(lastView ? lastView.mas_right: @0).offset(BorderMargin);
                    make.width.equalTo (contenview.mas_height).multipliedBy(0.65);
                }];

                lastView = view;
          }

            [contenview mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(lastView.mas_right);
            }];

        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = PreLoadVIewColor;
        [self.courseListView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(20);
        }];
        //学习进度
        BoldLabel *progressLabel = [[BoldLabel alloc] init];
        progressLabel.backgroundColor = PreLoadVIewColor;
        [self.introduceVIew addSubview:progressLabel];
        [progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.height.equalTo(courseLabel);
            make.top.equalTo(self.courseListView.mas_bottom).offset(20);
            make.width.mas_equalTo(80);

        }];

        //学习进度条
        [self.introduceVIew addSubview:self.progressView];
        self.progressView.layer.cornerRadius = 3;
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(progressLabel);
            make.right.mas_equalTo(-BorderMargin);
            make.top.equalTo(progressLabel.mas_bottom).offset(10);
            make.height.mas_equalTo(6);
        }];

        [self.introduceVIew addSubview:self.progressL];
        [self.progressL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(progressLabel.mas_left);
            make.top.equalTo(self.progressView.mas_bottom).offset(5);
            make.width.height.equalTo(progressLabel);
        }];

        [self.introduceVIew addSubview:self.totalLabel];
        [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-BorderMargin);
            make.top.width.height.equalTo(self.progressL);
        }];

        //学习目标
        BoldLabel *targetLabel = [[BoldLabel alloc] init];
        targetLabel.backgroundColor = PreLoadVIewColor;
        [self.introduceVIew addSubview:targetLabel];
        [targetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(courseLabel);
            make.width.equalTo(progressLabel);
            make.top.equalTo(self.progressL.mas_bottom).offset(20);
            make.height.equalTo(courseLabel);
        }];

        [self.introduceVIew addSubview:self.targetL];
        [self.targetL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(self.progressView);
            make.top.equalTo(targetLabel.mas_bottom).offset(10);
            make.height.mas_equalTo(50);
        }];
//
        //课程内容
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.backgroundColor = PreLoadVIewColor;
        [self.introduceVIew addSubview:contentLabel];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.height.equalTo(targetLabel);
            make.top.equalTo(self.targetL.mas_bottom).offset(10);
        }];
//
        [self.introduceVIew addSubview:self.contentL];
        [self.contentL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(targetLabel);
            make.top.equalTo(contentLabel.mas_bottom).offset(10);
            make.width.equalTo(self.targetL);
            make.height.mas_equalTo(50);
        }];
       
    }
    return self;
}
#pragma mark - Lazy Load
- (UIView *)introduceVIew {
    if (!_introduceVIew) {
        _introduceVIew = [[UIView alloc] init];
    }
    return _introduceVIew;
}

- (UILabel *)courseIntroduceLabel {
    if (!_courseIntroduceLabel) {
        _courseIntroduceLabel = [[UILabel alloc] init];
        _courseIntroduceLabel.textAlignment=NSTextAlignmentRight;
        _courseIntroduceLabel.backgroundColor = PreLoadVIewColor;
        _courseIntroduceLabel.font=MiniFont;
    }
    return _courseIntroduceLabel;
}

- (UIView *)progressView {
    if (!_progressView) {
        _progressView = [[UIView alloc] init];
        _progressView.backgroundColor = PreLoadVIewColor;
    }
    return _progressView;
}

- (UILabel *)progressL {
    if (!_progressL) {
        _progressL = [[UILabel alloc] init];
        _progressL.backgroundColor = PreLoadVIewColor;
        
    }
    return _progressL;
}

- (UILabel *)totalLabel {
    if (!_totalLabel) {
        _totalLabel = [[UILabel alloc] init];
        _totalLabel.backgroundColor = PreLoadVIewColor;
    }
    return _totalLabel;
}

- (UILabel *)targetL {
    if (!_targetL) {
        _targetL = [[UILabel alloc] init];
        _targetL.backgroundColor = PreLoadVIewColor;
    }
    return _targetL;
}

- (BoldLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel.backgroundColor = PreLoadVIewColor;
    }
    return _contentLabel;;
}

- (UILabel *)contentL {
    if (!_contentL) {
        _contentL = [[UILabel alloc] init];
        _contentL.backgroundColor = PreLoadVIewColor;
    }
    return _contentL;
}

- (UIScrollView *)courseListView{
    if (!_courseListView) {
        _courseListView = [[UIScrollView alloc] init];
        _courseListView.showsHorizontalScrollIndicator = NO;
        _courseListView.pagingEnabled = YES;
    }
    return _courseListView;
}
 
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
