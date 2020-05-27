//
//  TAAILearnListCell.m
//  TutorABC
//
//  Created by Slark on 2020/5/7.
//  Copyright © 2020 Slark. All rights reserved.
//

#import "TAAILearnListCell.h"

@interface TAAILearnListCell()

@property (nonatomic, strong) UIImageView *bgView;//cell背景图
@property (nonatomic, strong) UIButton *learnBtn;//学习按钮
@property (nonatomic, strong) UILabel *headLabel;//头部标签
@property (nonatomic, strong) UILabel *progressLabel;//学习进度标签
@property (nonatomic, strong) UILabel *describeLabel;//课程描述标签
@property (nonatomic, strong) UILabel *timeLabel;//课时标签
@property (nonatomic, strong) UIButton *levelLabel;//等级标签
@property (nonatomic, strong) UIImageView *learnImageView;

@end

@implementation TAAILearnListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        [self setUp];
    }
    return self;
}

- (void)setUp{
    [self.contentView addSubview:self.bgView];
    self.bgView.clipsToBounds = YES;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.contentView addSubview:self.learnImageView];
    [self.learnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(-6);
        make.top.equalTo(self).with.offset(22);
        make.width.equalTo(@(62));
        make.height.equalTo(@(28));
    }];

    [self.bgView addSubview:self.headLabel];
    [self.headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).with.offset(18);
        make.top.equalTo(self.bgView).with.offset(59);
        make.right.mas_offset(-150);
        make.height.equalTo(@(37));
    }];

    [self.bgView addSubview:self.describeLabel];
    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headLabel.mas_bottom).with.offset(10);
        make.left.equalTo(@18);
        make.right.mas_offset(-150);
    }];

//    [self.bgView addSubview:self.timeLabel];
//    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@18);
//        make.top.equalTo(self.describeLabel.mas_bottom).with.offset(1);
//        make.height.equalTo(@15);
//    }];

    [self.bgView addSubview:self.levelLabel];
    [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.describeLabel);
        make.top.equalTo(self.describeLabel.mas_bottom).offset(11);
        make.width.equalTo(@45);
        make.height.equalTo(@(16));
    }];
    
    [self.bgView addSubview:self.learnBtn];
    [self.learnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@16);
    //    make.top.equalTo(self.progressLabel.mas_bottom).with.offset(29);
        make.bottom.mas_equalTo(-24);
        make.width.equalTo(@117);
        make.height.equalTo(@38);
    }];
    
//    [self.bgView addSubview:self.progressLabel];
//    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@19);
//        make.top.equalTo(self.levelLabel.mas_bottom).with.offset(13);
//        make.height.equalTo(@17);
//    }];
}

#pragma mark Lazy Load
- (UIImageView*)bgView{
    if (!_bgView) {
        _bgView = [UIImageView new];
        _bgView.layerCornerRadius = 4;
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UIImageView*)learnImageView{
    if (!_learnImageView) {
        _learnImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"AIIcon"]];
    }
    return _learnImageView;
}

- (UILabel*)headLabel{
    if (!_headLabel) {
        _headLabel = [UILabel new];
        _headLabel.font = [UIFont systemFontOfSize:24];
        _headLabel.textColor = [UIColor colorWithHex:@"#0A1F44"];
        _headLabel.text = @"职场面试篇";
    }
    return _headLabel;
}

- (UILabel*)describeLabel{
    if (!_describeLabel) {
        _describeLabel= [[UILabel alloc]init];
        _describeLabel.font = [UIFont systemFontOfSize:12];
        _describeLabel.textColor = [UIColor colorWithHex:@"#53627C"];
        _describeLabel.text = @"12堂AI互动课";
    //    _describeLabel.preferredMaxLayoutWidth = ScreenWidth - 80;
        _describeLabel.numberOfLines = 0;
        //设置huggingPriority
     //   [_describeLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return _describeLabel;
}

- (UILabel*)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [UIColor colorWithHex:@"#53627C"];
        _timeLabel.text = @"+12堂24分钟[真人外教1对1]";
    }
    return _timeLabel;
}

- (UIButton*)levelLabel{
    if (!_levelLabel) {
        _levelLabel = [[UIButton alloc]init];
         _levelLabel.titleLabel.font = [UIFont systemFontOfSize:10];
        _levelLabel.titleLabel.textColor = TextColor;
        _levelLabel.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.6];
        _levelLabel.layerCornerRadius = 2;
    }
    return _levelLabel;
}

- (UILabel*)progressLabel{
    if (!_progressLabel) {
        _progressLabel = [UILabel new];
        _progressLabel.text = @"学习进度: 3/12";
        _progressLabel.hidden = YES;
    }
    return _progressLabel;
}

- (UIButton*)learnBtn{
    if (!_learnBtn) {
        _learnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_learnBtn setTitle:@"立即学习" forState:UIControlStateNormal];
        _learnBtn.layerCornerRadius = 20;
        _learnBtn.titleLabel.textColor = TextColor;
        _learnBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _learnBtn;
}

- (void)loadDataFromModel:(TAAILearnListModel *)model{
    [self.bgView sd_setImageWithURL:[NSURL URLWithString:model.coverImage]];
    self.headLabel.text = model.title;
    self.describeLabel.text = model.DDescription;
    [self.levelLabel setTitle:[NSString stringWithFormat:@"等级%@",model.level] forState:normal];
    [self.levelLabel setTitleColor:TextColor forState:normal];
    if ([@(model.isBuy) isEqualToNumber:@1]) {
        [self.learnBtn setTitle:@"立即学习" forState:UIControlStateNormal];
        [self.learnBtn setBackgroundImage:[UIImage imageNamed:@"Rectangle"] forState:normal];
        self.learnBtn.backgroundColor = [UIColor clearColor];
        self.learnBtn.layerBorderColor = [UIColor clearColor];
    }else{
        [self.learnBtn setTitle:@"免费试学" forState:UIControlStateNormal];
        self.learnBtn.backgroundColor = [UIColor whiteColor];
        [self.learnBtn setBackgroundImage:[UIImage imageNamed:@" "] forState:normal];
        self.learnBtn.layerBorderColor = TextGrayColor;
        self.learnBtn.layerBorderWidth = 1;
        [self.learnBtn setTitleColor:TextColor forState:normal];
        [self.learnBtn setTitleColor:[UIColor UIColorFormHexString:@"#182C4F"] forState:UIControlStateNormal];
    }
}

- (void)setFrame:(CGRect)frame{
    frame.size.height -= 20;
    [super setFrame:frame];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
