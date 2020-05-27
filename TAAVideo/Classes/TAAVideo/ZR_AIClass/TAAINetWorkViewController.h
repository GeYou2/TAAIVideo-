//
//  TAAIReportViewController.h
//  TutorABC
//
//  Created by 葛优 on 2020/5/17.
//  Copyright © 2020 Slark. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TAAINetWorkViewController : BaseViewController

@property (nonatomic ,copy) NSString *url;
@property (nonatomic ,assign) BOOL needBackbtn;//1.需要返回按钮  2.不需要返回按钮
@property (nonatomic, copy) NSString *lessonId;
@property (nonatomic, copy) NSString *courseId;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *clientId;
@property (nonatomic ,assign) BOOL needPopToDetail;//1.需要返回到详情页面  2.不需要


@end
/*
   netVC.url = [NSString stringWithFormat:@"http://221.226.9.92:8295/report/html/learnReport.html?token=%@&clientId=%@&lessonId=%@&courseId=%@",@"b845088dd33c4be3bfe4a9016247b2e2o91v34Fk85889027244",ClientId,model.lessonId,self.courseId];
 
 */


NS_ASSUME_NONNULL_END
