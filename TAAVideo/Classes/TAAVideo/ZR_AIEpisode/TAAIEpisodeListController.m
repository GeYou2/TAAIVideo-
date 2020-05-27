//
//  TAAIEpisodeDetailController.m
//  TutorABC
//
//  Created by 葛优 on 2020/5/7.
//  Copyright © 2020 Slark. All rights reserved.
//

#import "TAAIEpisodeListController.h"
#import "TAAIEpisodeListCell.h"
#import "TAAIDetailCourseListModel.h"
#import "TAAIClassController.h"
#import "TAAINetWorkViewController.h"
#import "TAAIClassController.h"
@interface TAAIEpisodeListController ()<UITableViewDelegate,
UITableViewDataSource,
ITGUserProtocol>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *introduceLabel;//全部课程简介
@property (nonatomic, strong) UITableView *listView;//课程列表
@property (nonatomic, strong) UILabel *studyPrograssLabel;//学习进度标签
@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation TAAIEpisodeListController
static NSString *CellID = @"TAAIEpisodeList";

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //设置状态栏白色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleStr = @"职场面试篇";
    self.title = self.titleStr;
    [self loadViews];
    [self fetchData];
}

#pragma mark - 加载页面UI
- (void)loadViews {
    BoldLabel *allLabel = [[BoldLabel alloc] init];
    allLabel.text=@"全部课程";
    allLabel.textColor=TextColor;
    allLabel.font=SmallFont;
    [self.view addSubview:allLabel];
    [allLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(BorderMargin);
        make.top.mas_equalTo(GetRectNavAndStatusHight);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(40);
    }];
    
    [self.view addSubview:self.introduceLabel];
    
    [self.introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(allLabel.mas_right);
        make.top.height.equalTo(allLabel);
        make.right.mas_equalTo(-BorderMargin);
    }];
    //课程列表
    [self.view addSubview:self.listView];
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(allLabel);
        make.right.mas_equalTo(-BorderMargin);
        make.top.equalTo(allLabel.mas_bottom);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-46);
        } else {
            make.bottom.mas_equalTo(-allLabel.height-6);
        }
        }];
    //底部分割线
    UIView *bottomLine = [[UIView alloc] init];
    [self.view addSubview:bottomLine];
    bottomLine.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:241.0/255.0 blue:242.0/255.0 alpha:1];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.equalTo(self.listView).offset(0);
        make.height.mas_equalTo(3);
    }];
    //设置阴影
    bottomLine.layer.shadowColor = [UIColor colorWithRed:240.0/255.0 green:241.0/255.0 blue:242.0/255.0 alpha:1].CGColor;//shadowColor阴影颜色
    bottomLine.layer.shadowOffset = CGSizeMake(0,-3);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    bottomLine.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    bottomLine.layer.shadowRadius = 1;//阴影半径，默认3
    //学习进度
    [self.view addSubview:self.studyPrograssLabel];
    [self.studyPrograssLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(allLabel);
        make.top.equalTo(_listView.mas_bottom);
        make.width.mas_equalTo(ScreenWidth/2-2*BorderMargin-5);
    }];
    [self.view addSubview:self.totalLabel];
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-BorderMargin);
        make.width.top.height.equalTo(self.studyPrograssLabel);
    }];
    //学习进度条
    [self.view addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(6);
    }];
    self.progressView.layer.cornerRadius = 3;
}

#pragma mark - Fetch
- (void)fetchData {
    
    self.navTitleLable.text = self.detailModel.title;
    self.introduceLabel.text = self.detailModel.ai_description;
    self.studyPrograssLabel.text = [NSString stringWithFormat:@"已学习%@节课",self.detailModel.finishLessonCount];
    self.totalLabel.text = [NSString stringWithFormat:@"总共%@节AI互动课",self.detailModel.lessonCount];
    CGFloat lessonCount = [self.detailModel.lessonCount floatValue];
    CGFloat finishLessonCount = [self.detailModel.finishLessonCount floatValue];
    NSLog(@"进度是:%lf",finishLessonCount/lessonCount);
    self.progressView.progress =  finishLessonCount/lessonCount;
}

#pragma mark - Action
- (void)toBuyTheCourse {
//    TAAIDetailCourseListModel *model = self.lessons[btn.tag];
    
    TAAINetWorkViewController *netVC = [[TAAINetWorkViewController alloc] init];
    /*    需要传的参数:
    sourceType(APP-华为:20,APP-安卓(非华为):21,APP-iOS:22),
    productSn:先用7225,暂时先用这个代替
    fromWhere也写AUoXRlvGQ7，后面替换正确的
    */
    netVC.needBackbtn = YES;
    netVC.title = @"购买课程";
    netVC.url = @"https://payment.tutorabc.com.cn/mall/#/?sourceType=22&productSn=7225&fromWhere=AUoXRlvGQ7";
    [self.navigationController pushViewController:netVC animated:YES];
}

- (void)toContinueTheCourse:(UIButton *)btn {
    TAAIDetailCourseListModel *model = self.lessons[btn.tag];
    TAAIClassController *classVC = [[TAAIClassController alloc] init];
    classVC.courseId = self.courseId;
    classVC.lessonId = model.lessonId;
    [self pushVC:classVC];
}

- (void)toOrderTheCourse:(UIButton *)btn {
//    TAAIDetailCourseListModel *model = self.lessons[btn.tag];
    
}

- (void)toLookReport:(UIButton *)btn {
    TAAIDetailCourseListModel *model = self.lessons[btn.tag];
    TAAINetWorkViewController *netVC = [[TAAINetWorkViewController alloc] init];
//    netVC.url = [NSString stringWithFormat:@"http://221.226.9.92:8295/report/html/learnReport.html?token=%@&lessonId=%@&courseId=%@",@"b845088dd33c4be3bfe4a9016247b2e2o91v34Fk85889027244",@"30",@"36"];
    netVC.title = @"本课报告";
    netVC.url = [NSString stringWithFormat:@"%@?token=%@&lessonId=%@&courseId=%@",HTMLUrl,tempToken,model.lessonId,self.courseId];
    netVC.courseId = self.courseId;
    [self.navigationController pushViewController:netVC animated:YES];
}

- (void)toHaveCourseForFree:(UIButton *)btn {
    if ([self getIsLogin]) {
        TAAIDetailCourseListModel *model = self.lessons[btn.tag];
        TAAIClassController *classVC = [[TAAIClassController alloc] init];
        classVC.courseId = self.courseId;
        classVC.lessonId = model.lessonId;
        [self pushVC:classVC];
    }else {
        //去登录页面
    }
}

- (BOOL)getIsLogin {
    BOOL isLoagin = NO;
    //判断是否登录
    if ([NSString nullToString:[self getToken]].length>0) {
        isLoagin = YES;
    }
    return isLoagin;
}

#pragma mark - Delegate
- (nullable NSString *)getToken {
    return tempToken;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lessons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TAAIEpisodeListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    TAAIDetailCourseListModel *model = self.lessons[indexPath.row];
    model.isBuy = self.isBuy;
    [cell fetchDataWithImages:model];
    
    cell.operationBtn.tag = indexPath.row;
   
    if ([model.isBuy intValue] == 0) {
        //未购买
        if ([model.isFree intValue] == 1) {
            //免费课程  点击免费试学
            [cell.operationBtn addTarget:self action:@selector(toHaveCourseForFree:) forControlEvents:UIControlEventTouchUpInside];
        }else {
            //立即购课
            [cell.operationBtn addTarget:self action:@selector(toBuyTheCourse) forControlEvents:UIControlEventTouchUpInside];
        }
    }else {
        //已购买
        if ([model.studyStatus intValue] == 2){
               //学习完成 点击去订课
            [cell.operationBtn addTarget:self action:@selector(toOrderTheCourse:) forControlEvents:UIControlEventTouchUpInside];
            

        }else{
               //未学习和学习中  点击继续学习
            [cell.operationBtn addTarget:self action:@selector(toContinueTheCourse:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    [cell.reportBtn addTarget:self action:@selector(toLookReport:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    TAAIDetailCourseListModel *model = self.lessons[indexPath.row];
    if ([model.isBuy intValue] == 0 && [model.isFree intValue] == 0) {
        //未购买且被锁住
        [self toBuyTheCourse];
    }else{
        if ([self getIsLogin]) {
            TAAIClassController *classVC = [[TAAIClassController alloc] init];
            classVC.courseId = self.courseId;
            classVC.lessonId = model.lessonId;
            [self.navigationController pushViewController:classVC animated:YES];
        }else {
            //去登录页面
        }
        
    }
    
}

#pragma mark - OtherDelegate

#pragma mark - 懒加载
- (UILabel *)introduceLabel {
    if (!_introduceLabel) {
        _introduceLabel = [[UILabel alloc] init];
        _introduceLabel.textColor = TextGrayColor;
        _introduceLabel.font = SmallFont;
    }
    return _introduceLabel;
}

- (UITableView *)listView {
    if (!_listView) {
        _listView=[[UITableView alloc] init];
        _listView.backgroundColor=[UIColor clearColor];
        [_listView registerClass:[TAAIEpisodeListCell class] forCellReuseIdentifier:CellID];
        _listView.rowHeight=160;
        _listView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _listView.showsVerticalScrollIndicator=NO;
        _listView.delegate=self;
        _listView.dataSource=self;
        if (@available(iOS 11.0, *)) {
            _listView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _listView;
}

- (UILabel *)studyPrograssLabel {
    if (!_studyPrograssLabel) {
        _studyPrograssLabel = [[UILabel alloc] init];
        _studyPrograssLabel.textColor = TextGrayColor;
        _studyPrograssLabel.font=MiniFont;
    }
    return _studyPrograssLabel;
}

- (UILabel *)totalLabel {
    if (!_totalLabel) {
        _totalLabel = [[UILabel alloc] init];
        _totalLabel.textColor = TextGrayColor;
        _totalLabel.font = MiniFont;
        _totalLabel.textAlignment = NSTextAlignmentRight;
    }
    return _totalLabel;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.layer.cornerRadius = 3;
        _progressView.clipsToBounds = YES;
        _progressView.progressImage = [UIImage gradientColorImageFromColors:
                                       @[[UIColor colorWithHex:@"#FAA2A2"],
                                         [UIColor colorWithHex:@"#F03D3D"]]
                                        gradientType:GradientTypeUpleftToLowright imgSize:CGSizeMake(ScreenWidth/2, 30)];
    }
    return _progressView;
}
@end
