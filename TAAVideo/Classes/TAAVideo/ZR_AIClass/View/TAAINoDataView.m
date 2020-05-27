//
//  TAAINoDataView.m
//  TutorABC
//
//  Created by Slark on 2020/5/23.
//  Copyright © 2020 Slark. All rights reserved.
//

#import "TAAINoDataView.h"

@interface TAAINoDataView()

@property (nonatomic, strong) UIImageView *netImageView;
@property (nonatomic, strong) UILabel *contenLabel;
@property (nonatomic, strong) UIButton *refreshBtn;

@end


@implementation TAAINoDataView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addViews];
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)addViews{
    [self addSubview:self.netImageView];
    [self addSubview:self.contenLabel];
    [self addSubview:self.refreshBtn];
}

- (void)layoutSubviews{
    [self.netImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_offset(100);
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(-100);
    }];
    [self.contenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.netImageView.mas_bottom);
        make.width.mas_equalTo(self);
        make.height.mas_equalTo(42);
    }];
    [self.refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contenLabel.mas_bottom).with.offset(30);
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(48);
        make.width.mas_equalTo(174);
    }];
}

- (UIImageView *)netImageView {
    if (!_netImageView) {
        _netImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"网络断开"]];
    }
    return _netImageView;
}

- (UILabel *)contenLabel {
    if (!_contenLabel) {
        _contenLabel = [[UILabel alloc] init];
        _contenLabel.textColor = [UIColor UIColorFormHexString:@"#8A94A6"];
        _contenLabel.textAlignment = NSTextAlignmentCenter;
        _contenLabel.font = [UIFont systemFontOfSize:15];
        _contenLabel.numberOfLines = 0;
        _contenLabel.text = @"Oops，网络开小差了哦～\n请检查网络并再次刷新";
    }
    return _contenLabel;
}

- (UIButton *)refreshBtn {
    if (!_refreshBtn) {
        _refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refreshBtn setTitle:@"刷新" forState:UIControlStateNormal];
        [_refreshBtn setTitleColor:[UIColor UIColorFormHexString:@"#8A94A6"] forState:UIControlStateNormal];
        _refreshBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_refreshBtn addTarget:self action:@selector(clickedRefreshButton:) forControlEvents:UIControlEventTouchUpInside];
        _refreshBtn.layer.cornerRadius = 24;
        _refreshBtn.layerBorderColor = [UIColor UIColorFormHexString:@"#B5BBC6"];
        _refreshBtn.layer.borderWidth = 1.0f;
    }
    return _refreshBtn;
}

//获取当前控制器
- (UIViewController *)viewController {
   
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

#pragma actioin
- (void)clickedRefreshButton:(UIButton *)btn {
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(refrash)]) {
        [self.delegate refrash];
    }
}

@end
