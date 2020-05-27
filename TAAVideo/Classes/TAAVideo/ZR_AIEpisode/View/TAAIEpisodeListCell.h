//
//  TAAIEpisodeDetailController.m
//  TutorABC
//
//  Created by 葛优 on 2020/5/7.
//  Copyright © 2020 Slark. All rights reserved.
//


#import "BaseTableViewCell.h"
#import "TAAIDetailCourseListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TAAIEpisodeListCell : BaseTableViewCell
@property (nonatomic, strong) UIButton *reportBtn;//查看报告按钮
@property (nonatomic, strong) UIButton *operationBtn;//操作按钮（去订课/继续学习）
/**
 *从课程模型中获取数据
 */
- (void)fetchDataWithImages:(TAAIDetailCourseListModel *)model;

@end

NS_ASSUME_NONNULL_END
