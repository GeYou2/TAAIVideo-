//
//  TAAICustomAlertView.m
//  TutorABC
//
//  Created by Slark on 2020/5/8.
//  Copyright © 2020 Slark. All rights reserved.
//

#import "TAAICustomAlertView.h"

@interface TAAIBackAlertView ()

@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *littleTitleLabel;
@property (nonatomic, strong)NSArray *buttonTitles;
@property (nonatomic,strong)UIView *lineView;

@end

@implementation TAAIBackAlertView

- (void)showWithButtonTitles:(NSArray *)titles
                   headTitle:(NSString *)title
                littleHeadTitle:(NSString *)littleTitle{
    self.buttonTitles = titles;
    self.titleLabel.text = title;
    self.littleTitleLabel.text = littleTitle;
    self.contentView = [self customView];
    self.type = TAAIAlertViewTypeNormal;
    self.clickBgHidden = YES;
    [self show];
}

- (UIView *)customView {
    UIView *containView = [UIView new];
    containView.backgroundColor = [UIColor colorWithHex:@"#FFFFFF"];
    containView.layer.cornerRadius = 5;
    containView.layer.masksToBounds = YES;
    //添加标题
    [containView addSubview:self.titleLabel];
    [containView addSubview:self.littleTitleLabel];
    //添加分割线
    [containView addSubview:self.lineView];
    for (NSInteger index = 0; index < self.buttonTitles.count; index++) {
        NSString *title = self.buttonTitles[index];
        UIButton *button = [self createButton];
        [button setTitle:title forState:UIControlStateNormal];
        button.tag = 1000 + index;
        button.backgroundColor = [UIColor colorWithHex:@"#FFFFFF"];
        [button setTitleColor:[self p_buttonColor:index] forState:UIControlStateNormal];
        [containView addSubview:button];
    }
    return containView;
}

#pragma mark Lazy load
- (UILabel*)littleTitleLabel{
    if (!_littleTitleLabel) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 282, 70)];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor colorWithHex:@"#8A94A6"];
        titleLabel.backgroundColor = [UIColor clearColor];
        _littleTitleLabel = titleLabel;
    }
    return _littleTitleLabel;
}

-(UILabel *)titleLabel {
    if(!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 282, 70)];
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor colorWithHex:@"#0A1F44"];
        titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (UIButton *)createButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    return button;
}

- (UIView*)lineView{
    if(!_lineView){
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor whiteColor];
    }
    return _lineView;
}

#pragma mark action
- (void)buttonClick:(UIButton *)btn {
    NSInteger index = btn.tag - 1000;
    if(self.click) {
        self.click(self.buttonTitles[index], index);
    }
}

- (UIColor *)p_buttonColor:(NSInteger)index {
    UIColor *color;
    index = index % 3;
    switch (index) {
        case 0:
            color = [UIColor colorWithHex:@"#182C4F"];
            break;
        case 1:
            color = [UIColor colorWithHex:@"#F03D3D"];
            break;
    }
    return color;
}

#pragma mark autolayout
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(@295);
        make.height.equalTo(@143);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@25);
        make.left.equalTo(@33);
        make.right.equalTo(@-33);
        make.height.equalTo(@22);
    }];
    [self.littleTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(11);
        make.width.height.equalTo(self.titleLabel);
        make.centerX.equalTo(self.titleLabel);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.littleTitleLabel.mas_bottom).with.offset(24);
        make.left.right.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    UIButton* btn = [self.contentView viewWithTag:1000];
    UIButton* confire = [self.contentView viewWithTag: 1001];
    NSArray* masonryArr = @[btn,confire];
    [masonryArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [masonryArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).with.offset(0);
        make.bottom.equalTo(@0);
    }];
}
@end
