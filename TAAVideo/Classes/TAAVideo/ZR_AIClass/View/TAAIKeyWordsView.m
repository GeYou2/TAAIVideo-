//
//  TAAIKeyWordsView.m
//  DevelopmentFramework
//
//  Created by Slark on 2020/5/9.
//  Copyright © 2020 Slark. All rights reserved.
//

#import "TAAIKeyWordsView.h"
#import "TAAILineView.h"
#import "TAAIKeyWordsModel.h"
@interface TAAIKeyWordsView()

@end

@implementation TAAIKeyWordsView

- (instancetype)initWithArray:(NSMutableArray *)dataArray {
    self = [super init];
    if (self) {
        self.dataArray = dataArray;
        [self setUp];
        self.backgroundColor = [UIColor UIColorFormHexString:@"#000000"];
        self.alpha = 0.8;
    }
    return self;
}

- (void)setUp {    
    CGFloat space =  40;
    for (NSInteger i = 0; i < self.dataArray.count; i ++) {
        CGFloat lineWidth = 48;
        TAAILineView* line1 = [[TAAILineView alloc]init];
        [self addSubview:line1];
        if ( i == 0) {
            lineWidth = 22;
        }
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@((space*i)+(6*i)+20));
            make.left.equalTo(@57);
            make.width.mas_equalTo(lineWidth);
            make.height.equalTo(@6);
        }];
        NSString * contentStrin = self.dataArray[i];
        UIView* wordView;
        if(![contentStrin containsString:@"\\n"]){
            wordView = [self createWordViewWithTitle:self.dataArray.firstObject description:@""];
        }else{
             NSArray* contenArr = [contentStrin componentsSeparatedByString:@"\\n"];
             wordView = [self createWordViewWithTitle:contenArr.firstObject description:contenArr.lastObject];
        }
        [self addSubview:wordView];
        [wordView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(line1.mas_right).with.offset(8);
            make.top.equalTo(line1.mas_top).with.offset(-6);
            make.height.equalTo(@46);
            make.right.equalTo(@0);
        }];
    }
    UILabel* hengxianLabel = [[UILabel alloc]init];
    hengxianLabel.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:hengxianLabel];
    [hengxianLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@57);
        make.top.equalTo(@24);
        make.height.equalTo(@(space*(self.dataArray.count-1)+((self.dataArray.count-1)*6)));
        make.width.equalTo(@1);
    }];
}

- (UIView *)createWordViewWithTitle:(NSString *)titleStr description:(NSString *)descriptionStr {
  
    UIView *wordView = [[UIView alloc]init];
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = titleStr;
    titleLabel.textColor = [UIColor UIColorFormHexString:@"#FFFFFF"];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [wordView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@23);
    }];
    
    UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.text = descriptionStr;
    contentLabel.textColor = [UIColor UIColorFormHexString:@"#FFFFFF"];
    contentLabel.font = [UIFont systemFontOfSize:14];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.numberOfLines = 0;
    [wordView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(0);
        make.left.equalTo(@0);
        make.right.mas_equalTo(-10);
        
      //  make.height.equalTo(@20);
    }];
    return wordView;
}

@end
