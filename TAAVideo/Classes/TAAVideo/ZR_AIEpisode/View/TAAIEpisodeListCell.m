//
//  TAAIEpisodeDetailController.m
//  TutorABC
//
//  Created by 葛优 on 2020/5/7.
//  Copyright © 2020 Slark. All rights reserved.
//


#import "TAAIEpisodeListCell.h"
@interface TAAIEpisodeListCell()
@property (nonatomic, strong) UIImageView *coverImage;//封面图片
@property (nonatomic, strong) UIView *lockBgView;//封面图片锁住蒙层
@property (nonatomic, strong) UIImageView *lockIcon;//锁图标
@property (nonatomic, strong) BoldLabel *title;//课程标题
@property (nonatomic, strong) BoldLabel *introductionLabel;//课程介绍
@property (nonatomic, strong) UIImageView *stateBgImage;//状态背景图
@property (nonatomic, strong) UILabel *stateLabel;//状态标签（已订课/未定课/学习中/待挑战）
@property (nonatomic, strong) UIImageView *studyPrograssBGImage;//已学进度背景图
@property (nonatomic, strong) UILabel *studyPrograssLabel;//已学进度标签（20%已学）
@property (nonatomic, strong) UIImageView *freeIcon;//免费角标
@end
@implementation TAAIEpisodeListCell
// 1. 初始化子视图
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 封面
        self.coverImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.coverImage];
        
        self.lockBgView = [[UIView alloc] init];
        [self.coverImage addSubview:self.lockBgView];
        self.lockIcon = [[UIImageView alloc] init];
        [self.coverImage addSubview:self.lockIcon];
        //免费角标
        self.freeIcon = [[UIImageView alloc] init];
        [self.coverImage addSubview:self.freeIcon];
        //标题
        self.title = [[BoldLabel alloc] init];
        [self.contentView addSubview:self.title];
        //简介
        self.introductionLabel = [[BoldLabel alloc] init];
        [self.contentView addSubview:self.introductionLabel];
        //课程状态
        self.stateBgImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.stateBgImage];
        self.stateLabel = [[UILabel alloc] init];
        self.stateLabel.textAlignment=NSTextAlignmentCenter;
        //给一个maxWidth
        self.stateLabel.preferredMaxLayoutWidth = (ScreenWidth-2*BorderMargin)/2-5;
        //设置huggingPriority
        [self.stateLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        self.stateLabel.font = MiniFont;
        [self.contentView addSubview:self.stateLabel];
        
        self.studyPrograssBGImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.studyPrograssBGImage];
        self.studyPrograssLabel = [[UILabel alloc] init];
        self.studyPrograssLabel.font = MiniFont;
        self.studyPrograssLabel.textAlignment=NSTextAlignmentCenter;
        //给一个maxWidth
        self.studyPrograssLabel.preferredMaxLayoutWidth = (ScreenWidth-2*BorderMargin)/2-5;
        //设置huggingPriority
        [self.studyPrograssLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.contentView addSubview:self.studyPrograssLabel];
        //操作按钮
        self.operationBtn = [[UIButton alloc] init];
        [self.contentView addSubview:self.operationBtn];
        self.operationBtn.titleLabel.font = SmallFont;
        self.operationBtn.layerBorderColor = [UIColor redColor];
        self.operationBtn.layerBorderWidth = 1;
        //查看报告按钮
        self.reportBtn = [[UIButton alloc] init];
        [self.contentView addSubview:self.reportBtn];
        self.reportBtn.titleLabel.font = SmallFont;
    }
    
    return self;
}

#pragma mark -布局子视图
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@5);
        make.bottom.equalTo(@-10);
        make.width.mas_equalTo(self.coverImage.mas_height).multipliedBy(0.75);
    }];

    [self.lockBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];

    [self.lockIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.freeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(@0);
        make.width.height.mas_equalTo(50);
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverImage.mas_right).offset(5);
        make.top.equalTo(self.coverImage).offset(5);
        make.right.equalTo(@-BorderMargin);
        make.height.mas_equalTo(25);
    }];
    
    [self.introductionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title);
        make.top.equalTo(self.title.mas_bottom);
        make.width.height.equalTo(self.title);
    }];
    
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(self.title);
        make.top.equalTo(self.introductionLabel.mas_bottom).offset(5);
        make.height.equalTo(self.title);
    }];
    
    [self.stateBgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.stateLabel);
    }];

    [self.studyPrograssLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.stateBgImage.mas_right).offset(10);
        make.top.height.equalTo(self.stateLabel);
    }];
    
    [self.studyPrograssBGImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.studyPrograssLabel);
    }];
    
    [self.operationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0);
        make.top.equalTo(self.coverImage.mas_bottom).offset(-40);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(36);
    }];
    self.operationBtn.layer.cornerRadius = 18;
    
    [self.reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.operationBtn.mas_left).offset(-10);
        make.top.width.height.equalTo(self.operationBtn);
    }];
}

#pragma mark - Fetch
- (void)fetchDataWithImages:(TAAIDetailCourseListModel *)model {
    
    [self.coverImage sd_setImageWithURL:[NSURL URLWithString:model.coverImage]];
    
    if ([model.studyStatus intValue] == 0) {
        //未开始带挑战
        self.stateBgImage.image = [UIImage imageNamed:@"icon_wait"];
        [self.operationBtn setTitle:@"开始学习" forState:normal];
    }else if ([model.studyStatus intValue] == 1) {
        //学习中
        self.stateBgImage.image = [UIImage imageNamed:@"icon_study"];
        [self.operationBtn setTitle:@"继续学习" forState:normal];
    }else if ([model.studyStatus intValue] == 2){
                //学习完成
        self.stateBgImage.image = [UIImage imageNamed:@"study"];
        [self.operationBtn setTitle:@"去订课" forState:normal];
        
        if ([model.hasReport intValue] == 1) {
            self.reportBtn.hidden = NO;
            [self.reportBtn setTitle:@"查看报告" forState:normal];
        }else{
            self.reportBtn.hidden = YES;
        }
    }

    
    self.title.text = model.title;
    self.introductionLabel.text = model.ai_description;
    
    self.freeIcon.image = [UIImage imageNamed:@"路径备份 6"];
    if ([model.isFree intValue] == 1) {
        self.freeIcon.hidden = NO;
    }else{
        self.freeIcon.hidden = YES;
    }
    
    [self.operationBtn setBackgroundImage:[UIImage imageNamed:@"Rectangle"] forState:normal];
    self.operationBtn.layerBorderColor = [UIColor clearColor];
    [self.operationBtn setTitleColor:[UIColor whiteColor] forState:normal];
    
    if ([model.isBuy intValue] == 0){
        //未购买
        self.lockBgView.hidden = YES;
        self.lockIcon.hidden = YES;
        if ([model.isFree intValue]  == 1) {
            [self.operationBtn setBackgroundImage:[UIImage imageNamed:@" "] forState:normal];
            self.operationBtn.layerBorderColor = TextColor;
            [self.operationBtn setTitleColor:TextColor forState:normal];
            [self.operationBtn setTitle:@"免费试学" forState:normal];
        }else {
            self.lockBgView.hidden = NO;
            self.lockIcon.hidden = NO;
            self.lockBgView.backgroundColor = [UIColor blackColor];
            self.lockBgView.alpha = 0.5;
            self.lockIcon.image = [UIImage imageNamed:@"icon_lock"];
            self.stateBgImage.image = [UIImage imageNamed:@"icon_wait"];
            [self.operationBtn setTitle:@"立即购课" forState:normal];
        }
        
    }else{
        //已购买
        self.lockBgView.hidden = YES;
        self.lockIcon.hidden = YES;
        
    }
    if ([model.studyStatus intValue] == 1) {
    //学习中
    self.lockIcon.hidden = NO;
    self.lockIcon.image = [UIImage imageNamed:@"icon_attend class"];
    }
    
    [self.reportBtn setTitleColor:[UIColor colorWithHex:@"#C99D9D"] forState:normal];
}


@end
