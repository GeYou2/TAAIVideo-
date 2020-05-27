//
//  TAAISectionView.m
//  TutorABC
//
//  Created by 葛优 on 2020/5/13.
//  Copyright © 2020 Slark. All rights reserved.
//

#import "TAAISectionView.h"
#import "TAAIClassSectionModel.h"
@interface TAAISectionView()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) UIButton *selectedBtn;
@end

@implementation TAAISectionView
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.scrollView];
        //监听高亮效果
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(highlightSection:) name:@"highlightSection" object:nil];
    }
    return self;
}
- (void)highlightSection:(NSNotification *)notification;{
    NSInteger index = [[[notification object] objectForKey:@"Index"] intValue];
    UIButton *btn = [[UIButton alloc] init];
    btn.tag = index;
    //选中样式
    for (UIButton *sectionBtn in [self.scrollView subviews]) {
        if ([sectionBtn isKindOfClass:[UIButton class]]) {
            sectionBtn.layerBorderColor = [UIColor clearColor];
        }
    }
    btn.layerBorderColor = [UIColor whiteColor];
}

- (void)highlightWithSection:(NSInteger)inidex {
    UIButton *btn = [self.scrollView viewWithTag:inidex];
    for (UIButton *sectionBtn in [self.scrollView subviews]) {
        if ([sectionBtn isKindOfClass:[UIButton class]]) {
            sectionBtn.layerBorderColor = [UIColor clearColor];
        }
    }
    btn.layerBorderColor = [UIColor whiteColor];
}

- (void)layoutSubviews {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}
#pragma mark - Fetch
- (void)setDataWithSections:(NSArray *)sections {
    self.sections = sections;
    CGFloat btnWidth = 120;
    UIButton *tempBtn;
    for (int i=0; i<self.sections.count; i++) {
        TAAIClassSectionModel *model = self.sections[i];
        UIButton *sectionBtn = [[UIButton alloc] init];
        if (i==0) {
            sectionBtn.layerBorderColor = [UIColor whiteColor];
        }
        sectionBtn.layerBorderWidth = 2;
        sectionBtn.layerCornerRadius = 5;
        sectionBtn.tag = i+1;
        [sectionBtn addTarget:self action:@selector(clickSection:) forControlEvents:UIControlEventTouchUpInside];
//        [sectionBtn setTitle:model.title forState:UIControlStateNormal];
        [self.scrollView addSubview:sectionBtn];
        sectionBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
        [sectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(BorderMargin+i*(btnWidth+BorderMargin));
            make.centerY.height.equalTo(self);
            make.width.mas_equalTo(btnWidth);
        }];
        tempBtn = sectionBtn;
        
        UILabel *sectionTitleLabel = [[UILabel alloc] init];
        sectionTitleLabel.preferredMaxLayoutWidth = btnWidth-12;
        [sectionTitleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];//设置huggingPriority
        sectionTitleLabel.numberOfLines = 2;
        [sectionBtn addSubview:sectionTitleLabel];
        [sectionTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(10);
            make.right.mas_equalTo(-10);
        }];
        sectionTitleLabel.font = SmallFont;
        sectionTitleLabel.textAlignment = NSTextAlignmentLeft;
        sectionTitleLabel.textColor = [UIColor whiteColor];
        sectionTitleLabel.text =[NSString stringWithFormat:@"%d.%@",i + 1,model.title];;
        
        UILabel *sectionLabel = [[UILabel alloc] init];
        sectionLabel.preferredMaxLayoutWidth = btnWidth-12;
        [sectionLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];//设置huggingPriority
        sectionLabel.numberOfLines = 1;
        [sectionBtn addSubview:sectionLabel];
        [sectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(10);
            make.right.mas_equalTo(-10);
            make.top.equalTo(sectionTitleLabel.mas_bottom).offset(0);
        }];
        sectionLabel.font = SmallFont;
        sectionLabel.textAlignment = NSTextAlignmentLeft;
        sectionLabel.textColor = [UIColor whiteColor];
        sectionLabel.text = model.content;
    }
    [tempBtn mas_updateConstraints:^(MASConstraintMaker *make) {
         make.right.equalTo(self.scrollView).offset(-BorderMargin);
    }];
}
#pragma mark - Action
- (void)clickSection:(UIButton *)btn {
    if (self.selectedBtn.tag == btn.tag) {
        return;
    }
    
    [MBProgressHUD showMessage:@""];

    //选中样式
    for (UIButton *sectionBtn in [self.scrollView subviews]) {
        if ([sectionBtn isKindOfClass:[UIButton class]]) {
            sectionBtn.layerBorderColor = [UIColor clearColor];
        }
    }
    btn.layerBorderColor = [UIColor whiteColor];
    
    if ([self.delegate respondsToSelector:@selector(TAAISectionViewDidClickSection:)]) {
        [self.delegate TAAISectionViewDidClickSection:btn.tag-1];
    }
    self.selectedBtn = btn;
    
}

#pragma mark - Lazy Load
- (UIScrollView *)scrollView {
    if (!_scrollView) {
         _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"highlightSection" object:nil];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
