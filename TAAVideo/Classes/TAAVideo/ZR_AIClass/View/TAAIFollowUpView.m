//
//  TAAIFollowUpView.m
//  TutorABC
//
//  Created by Slark on 2020/5/6.
//  Copyright © 2020 Slark. All rights reserved.
//

#import "TAAIFollowUpView.h"

@interface TAAIFollowUpView ()

@property (nonatomic, strong) UIProgressView *topProgressView;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIView *scoreView;
@property (nonatomic, strong) UILabel *scoreLable;

@end

@implementation TAAIFollowUpView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
        [self fetchData];
    }
    return self;
}

#pragma mark - 加载页面UI
- (void)setUp {
    [self addSubview: self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(ScreenWidth-BorderMargin);
    }];
    
    [self.bottomView addSubview:self.tipsLabel];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(BorderMargin);
        make.right.mas_equalTo(-BorderMargin);
        make.top.mas_equalTo(BorderMargin);
        make.height.equalTo(@20);
    }];
    
    [self.bottomView addSubview:self.textLabel];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tipsLabel);
        make.width.equalTo(self.tipsLabel.mas_width);
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(10);
    }];

    [self.bottomView addSubview:self.btnView];
    [self.btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        if (@available(iOS 11.0, *)) {
            make.height.mas_equalTo(BottomSafeAreaHeight+100);
        } else {
            make.height.mas_equalTo(100);
        }
        make.top.equalTo(self.textLabel.mas_bottom).with.offset(30);
        make.bottom.equalTo(self.bottomView).offset(-10);
    }];
    
    /**根据接口返回 显示不同三种状态*/
  //  self.btnView.readState = FollowReadStateDefault;
}

#pragma mark Lazy Load
- (TAAIFollowUpBottomBtnView*)btnView {
    if (!_btnView) {
        _btnView = [[TAAIFollowUpBottomBtnView alloc] init];
    }
    return _btnView;
}

- (UIView*)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        _bottomView.layerCornerRadius = 5;
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (UILabel*)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc]init];
        _tipsLabel.font = [UIFont systemFontOfSize:14];
        _tipsLabel.text = @"请跟读一下内容";
        _tipsLabel.textColor = [UIColor UIColorFormHexString:@"#0A1F44"];
        _tipsLabel.alpha = 0.4;
        _tipsLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _tipsLabel;
}

- (BoldLabel*)textLabel {
    if (!_textLabel) {
        _textLabel = [[BoldLabel alloc]init];
        _textLabel.numberOfLines = 0;
        _textLabel.textColor = TextColor;
        _textLabel.preferredMaxLayoutWidth = ScreenWidth-3*BorderMargin;//给一个maxWidth
        [_textLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];//设置huggingPriority
    }
    return _textLabel;
}
#pragma mark - Fetch
- (void)fetchData {
    _textLabel.text = @"I'm naturally competitive and I like to challenge myself.  I try to gain as many qualifications as possible to enhance my employablity.I'm naturally competitive and I like to challenge myself. I'm naturally competitive and I like to challenge myself. ";
    
    //如果弹框高度超出屏幕，则给出弹框的最大高度
    [self layoutIfNeeded];
    CGFloat bottomViewHeight = self.bottomView.height;
    if (bottomViewHeight>ScreenHeight-90) {
        [self.textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(ScreenHeight-90-150);
        }];
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(ScreenHeight-90);
        }];
    }else if (bottomViewHeight<300) {
        [self.textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(100);
        }];
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(300);
        }];
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
}

@end


