//
//  CoreVocabulartCell.m
//  DevelopmentFramework
//
//  Created by Slark on 2020/5/9.
//  Copyright © 2020 Slark. All rights reserved.
//

#import "TAAICoreVocabulartCell.h"

@interface TAAICoreVocabulartCell()

@property (nonatomic, strong) UIButton *soundBtn;

@end

@implementation TAAICoreVocabulartCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    [self.contentView addSubview:self.wordTitle];
    [self.wordTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@27);
        make.top.equalTo(@16);
        make.height.equalTo(@22);
    }];
    
    [self.contentView addSubview:self.analysisLabel];
    [self.analysisLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@27);
        make.top.equalTo(@38);
        make.height.equalTo(@17);
    }];
    
//    [self.contentView addSubview:self.soundBtn];
//    [self.soundBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(@(-47));
//        make.centerY.equalTo(self.wordTitle.mas_centerY);
//        make.width.equalTo(@(20));
//        make.height.equalTo(@20);
//    }];
}

#pragma mark aciton
- (void)soundClick:(UIButton*)btn {
    NSLog(@"sound sound sound");
}


#pragma mark Lazy Load
- (UILabel*)wordTitle {
    if (!_wordTitle) {
        _wordTitle = [[UILabel alloc]init];
        _wordTitle.text = @"situation";
        _wordTitle.textColor = [UIColor UIColorFormHexString:@"#0A1F44"];
        _wordTitle.font = [UIFont boldSystemFontOfSize:17];
        _wordTitle.textAlignment = NSTextAlignmentLeft;
    }
    return _wordTitle;
}

- (UILabel*)analysisLabel {
    if ((!_analysisLabel)) {
        _analysisLabel = [[UILabel alloc]init];
        _analysisLabel.text = @"n, 情况; 形势; 处境; 位置";
        _analysisLabel.textColor = [UIColor UIColorFormHexString:@"#53627C"];
        _analysisLabel.font = [UIFont systemFontOfSize:12];
    }
    return _analysisLabel;
}

- (UIButton*)soundBtn {
    if (!_soundBtn) {
        _soundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _soundBtn.backgroundColor = [UIColor redColor];
        [_soundBtn addTarget:self action:@selector(soundClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _soundBtn;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
