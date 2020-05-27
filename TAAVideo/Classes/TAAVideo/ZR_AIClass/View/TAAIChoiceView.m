//
//  TAAIChoiceView.m
//  DevelopmentFramework
//
//  Created by Slark on 2020/5/11.
//  Copyright © 2020 Slark. All rights reserved.
//

#import "TAAIChoiceView.h"

@interface TAAIChoiceView()

@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, strong) UILabel *optionLabel;
@property (nonatomic, copy) NSString *currentTag;

@end

@implementation TAAIChoiceView

- (instancetype)initWithTitle:(NSString *)titleString AndSelectedTag:(NSString*)stringTag{
    self = [super init];
    if (self) {
        self.titleString = titleString;
        self.layerBorderColor = [UIColor UIColorFormHexString:@"#53627C"];
        self.layerBorderWidth = 1;
        self.layerCornerRadius = 4;
        self.currentTag = stringTag;
        [self setUp];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGes:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tapGes:(UITapGestureRecognizer*)tap {
    if ([self.delegate respondsToSelector:@selector(selectedViewWithTag:WithChoiceView:)]) {
        [self.delegate selectedViewWithTag:self.currentTag WithChoiceView:self];
    }
}

- (void)setUp {
    [self addSubview:self.optionLabel];
    [self.optionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@29);
        make.top.equalTo(@15);
        make.right.lessThanOrEqualTo(@-17);
        make.bottom.equalTo(@-15);
    }];
}

#pragma mark Lazy Load
- (UILabel*) optionLabel {
    if (!_optionLabel) {
        _optionLabel = [[UILabel alloc]init];
        _optionLabel.numberOfLines = 0;
        _optionLabel.text = self.titleString;
        [self borderWithView:self.optionLabel];
    }
    return _optionLabel;
}

#pragma mark setter getter
- (void)setChoiceState:(TAAIChoiceState)choiceState {
    _choiceState = choiceState;
    switch (choiceState) {
        case TAAIChoiceStateSelected:
            [self selectedItem];
            break;
        case TAAIChoiceStateUnSelected:
            [self unSelected];
            break;
        case TAAIChoiceStateSelectedRight:
            [self selectedRight];
            break;
        case TAAIChoiceStateSelectedFalse:
            [self selectedFales];
            break;
    }
}

- (void)unSelected {
    self.backgroundColor = [UIColor UIColorFormHexString:@"#F1F2F4"];
    self.optionLabel.textColor = [UIColor blackColor];
    self.layerBorderWidth = 0;
}

- (void)selectedItem {
    self.layerBorderWidth = 0;
    self.backgroundColor = [UIColor UIColorFormHexString:@"#F1F2F4"];
    self.optionLabel.textColor = [UIColor blackColor];
}

- (void)selectedRight {
    self.layerBorderWidth = 0;
    self.backgroundColor = [UIColor UIColorFormHexString:@"#22C993"];
    self.optionLabel.textColor = [UIColor UIColorFormHexString:@"#FFFFFF"];
}

- (void)selectedFales {
    self.layerBorderWidth = 0;
    self.backgroundColor = [UIColor UIColorFormHexString:@"#F03D3D"];
    self.optionLabel.textColor = [UIColor UIColorFormHexString:@"#FFFFFF"];
}

- (void)borderWithView:(UIView *)View {
    
    CAShapeLayer *border = [CAShapeLayer layer];
    //虚线的颜色
    border.strokeColor = [UIColor colorWithRed:136 / 255.0 green:136 / 255.0 blue:136 / 255.0 alpha:1].CGColor;
    //填充的颜色
    border.fillColor = [UIColor clearColor].CGColor;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:View.bounds cornerRadius:0];
    //设置路径
    border.path = path.CGPath;
    border.frame = View.bounds;
    //虚线的宽度
    border.lineWidth = 1.f;
    //设置线条的样式
    //    border.lineCap = @"square";
    //虚线的间隔
    border.lineDashPattern = @[@4, @2];
    View.layer.masksToBounds = YES;
    [View.layer addSublayer:border];
}

- (void)layoutSubviews {
    [super layoutSubviews];
   // [self borderWithView:self.optionLabel];
}

@end
