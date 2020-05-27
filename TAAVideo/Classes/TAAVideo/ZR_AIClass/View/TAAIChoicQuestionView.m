//
//  TAAIChoicQuestionView.m
//  TutorABC
//
//  Created by Slark on 2020/5/7.
//  Copyright © 2020 Slark. All rights reserved.
//

#import "TAAIChoicQuestionView.h"

@class TAAIChoicQuestionView;

@interface TAAIChoicQuestionView()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation TAAIChoicQuestionView{
    UITableView* _tableView;
    
}
#pragma mark 初始化
- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - 加载页面UI
- (void)setUp{
    _tableView = [[UITableView alloc]initWithFrame:RR(18, 25, self.width-36, 516) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
}

#pragma mark - UITableViewDataSource

#pragma mark - UITableViewDelegate

#pragma mark - OtherDelegat
@end
