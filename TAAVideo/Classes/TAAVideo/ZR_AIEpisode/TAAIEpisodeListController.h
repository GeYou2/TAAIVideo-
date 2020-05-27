//
//  TAAIEpisodeDetailController.m
//  TutorABC
//
//  Created by 葛优 on 2020/5/7.
//  Copyright © 2020 Slark. All rights reserved.
//


#import "BaseViewController.h"
#import "TAAIEpisodeDetalModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TAAIEpisodeListController : BaseViewController
@property (nonatomic, strong) TAAIEpisodeDetalModel *detailModel;
@property (copy, nonatomic) NSString *courseId;//课程id
@property (copy, nonatomic) NSString *isBuy;//课程id
@property (strong, nonatomic) NSArray *lessons;//课程
@property (copy, nonatomic) NSString *titleStr;//标题

@end

NS_ASSUME_NONNULL_END
