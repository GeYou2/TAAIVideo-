//
//  TAAIClassController.m
//  TutorABC
//
//  Created by Slark on 2020/5/6.
//  Copyright © 2020 Slark. All rights reserved.
//

#import "TAAIClassController.h"
#import "TAAIFollowUpView.h"
#import "TAAIFollowUpBottomBtnView.h"
#import "TAAICustomAlertView.h"
#import "TAAILearnView.h"
#import "TAAISectionView.h"
#import "TAAISectionModel.h"
#import "TAAILearnModel.h"
#import "TAAIClassSectionModel.h"
#import "TAAIPartModel.h"
#import "TAAILearnObjModel.h"
#import "TAAIKeyWordsModel.h"
#import "TAAINetWorkViewController.h"

@interface TAAIClassController ()<UIGestureRecognizerDelegate,
TAAIFollowUpBottomBtnViewDelegate,
TAAISectionViewDelegate,
TAAIMenudelegate>

@property (nonatomic, strong) TAAIFollowUpView *followUpView;
@property (nonatomic, strong) TAAILearnView *learView;
@property (nonatomic, weak) id<UIGestureRecognizerDelegate> delegate;
@property (nonatomic, strong) TAAISectionView *sectionView;
@property (nonatomic, strong) TAAILearnModel *learnModel;
@property (nonatomic, strong) UIProgressView *topProgressView;
//当前class所有的section,包括开场/转场Section
@property (nonatomic, strong) NSMutableArray *sectionArray;
//点击目录跳转part,不包括开场转场Section
@property (nonatomic, strong) NSMutableArray *sectionMenuArray;
//不点击目录按照流程播放
@property (nonatomic, strong) NSMutableArray *partArray;
//点击目录播放的的Part
@property (nonatomic, strong) NSMutableArray *partMenuArray;

@property (nonatomic, strong) NSMutableArray *currentPlayArray;
@property (nonatomic, strong) TAAIClassSectionModel *firstPlayModel;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger currentSection;
@end

@implementation TAAIClassController

#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navView.hidden = YES;
    if (self.navigationController.viewControllers.count > 1) {
        // 记录系统返回手势的代理
        _delegate = self.navigationController.interactivePopGestureRecognizer.delegate;
        // 设置系统返回手势的代理为当前控制器
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.learView];
    [self.learView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    [self fetchData];
    
    [self.learView showAlert];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(partEnd) name:@"nextPartVideo" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"nextPartVideo" object:nil];
    // 设置系统返回手势的代理为我们刚进入控制器的时候记录的系统的返回手势代理
    self.navigationController.interactivePopGestureRecognizer.delegate = _delegate;
    [self.learView goback];
}

#pragma mark - Fetch
- (void)fetchData {
    [self.sectionArray removeAllObjects];
    [self.sectionMenuArray removeAllObjects];
    [self.partArray removeAllObjects];
    [self.partMenuArray removeAllObjects];
    NSDictionary *params = @{@"clientId":@"889017717",
                             @"courseId":self.courseId,
                             @"lessonId":self.lessonId
    };

    ZR_Request *request = [ZR_Request cc_requestWithUrl:@"business/lessonInfo" isPost:NO Params:params];
    [request cc_sendRequstWith:^(NSDictionary *jsonDic) {
        NSDictionary *dataDic = jsonDic[@"data"];
        //获取该课程整个学习model
        self.learnModel = [TAAILearnModel mj_objectWithKeyValues:dataDic];
        //获取所有的Section信息
        for (NSInteger i = 0; i < self.learnModel.sectionList.count; i ++) {
            NSDictionary *sectionDic = self.learnModel.sectionList[i];
            TAAIClassSectionModel *sectionModel = [TAAIClassSectionModel mj_objectWithKeyValues:sectionDic];
            [self.sectionArray addObject:sectionModel];
        }
        //当数组里面的SectionModel的title为空时,则说明是转场视频
        //转场视频 不进行目录展示
        for (NSInteger i = 0; i < self.sectionArray.count; i ++) {
            TAAIClassSectionModel *sectionModel = self.sectionArray[i];
            if (![sectionModel.title isEqualToString:@""]&&sectionModel.title&&![sectionModel.title isKindOfClass:[NSNull class]]) {
                [self.sectionMenuArray addObject:sectionModel];
            }
        }
        //展示目录
        self.learView.allSecionsArray = self.sectionArray;
        self.learView.sectionArray = self.sectionMenuArray;
        //取所有part对应partModel
        for (TAAIClassSectionModel* sectionModel in self.sectionArray) {
            NSMutableArray *sectionParArr = [NSMutableArray new];
            NSArray *partArr = sectionModel.partList;
            for (NSDictionary *partDetailDic in partArr) {
                TAAIPartModel *partModel = [TAAIPartModel mj_objectWithKeyValues:partDetailDic];
                [sectionParArr addObject:partModel];
            }
            [self.partArray addObject:partArr];
        }
        //取出目录下面的part对应的partModel
        for (TAAIClassSectionModel* sectionModel in self.sectionMenuArray) {
            NSMutableArray *sectionParArr = [NSMutableArray new];
            NSArray *partArr = sectionModel.partList;
            for (NSDictionary *partDetailDic in partArr) {
                TAAIPartModel *partModel = [TAAIPartModel mj_objectWithKeyValues:partDetailDic];
                [sectionParArr addObject:partModel];
            }
            [self.partMenuArray addObject:partArr];
        }
        
        //获取当前进度 获取方式是循环sectionArray 对比sectionId
        //如果secitonId相同,则代表当前学到该section,直接播放当前Section
        NSInteger currentSectionId = 0;
        for (NSInteger i = 0;i < self.sectionMenuArray.count ; i ++) {
            TAAIClassSectionModel * sectionModel = self.sectionMenuArray[i];
            if ([sectionModel.currentSection isEqualToString:self.learnModel.sectionProgress]) {
                currentSectionId = i;
                NSLog(@"当前应该学习第%ld个secion课程",currentSectionId);
                self.currentSection = currentSectionId;
                self.currentIndex = 0;
            }else{
                //说明当前课程已经学习结束
            }
        }
        if (!self.learnModel.sectionProgress) {
            self.currentIndex = 0;
            self.currentSection = 0;
        }
        //传入当前进度的sectionModel PartModel
        TAAIClassSectionModel *setionModel = self.sectionMenuArray[currentSectionId];
        NSArray *currentParts = setionModel.partList;
//        TAAIClassSectionModel *setionModel = self.sectionArray[0];
//        NSArray *currentParts = self.partArray[0];
        NSDictionary *currentPartDic = currentParts.firstObject;
        TAAIPartModel *currentPart =[TAAIPartModel mj_objectWithKeyValues:currentPartDic];
        [self.learView showAlerViewWithSectionModel:setionModel withPartModel:currentPart];
        
    } failCompletion:^(NSString *errorString) {
        NSLog(@"返回的错误message为: %@",errorString);
        [self pop];
    } WithString:@"正在加载..."];
}

- (void)fetchMoreData {
    
}

#pragma mark - Action
- (void)subtitleSwitch:(UIButton *)btn {
    
}

#pragma mark - Delegate
- (void)refrash {
    //没有网络的页面点击刷新调用
    [self fetchData];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return self.navigationController.childViewControllers.count > 1;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return self.navigationController.viewControllers.count > 1;
}

#pragma mark - UITableViewDataSource

#pragma mark - UITableViewDelegate

#pragma mark - OtherDelegate

- (void)gobackClick{
    NSLog(@"点击返回");
    TAAIBackAlertView *alert = [[TAAIBackAlertView alloc] init];
    __weak TAAIBackAlertView *weakSelf = alert;
    [alert showWithButtonTitles:@[@"取消",@"确定"] headTitle:@"确认退出课堂?" littleHeadTitle:@"一鼓作气学习效果更佳哦"];
    //点击回调
    alert.click = ^(NSString * _Nonnull title, NSInteger index) {
        if(index == 1){
            [self pop];
        }
        [weakSelf dismiss];
        
//         for(NSInteger i = 0; i < self.sectionArray.count; i ++){
//             TAAIClassSectionModel * model = self.sectionArray[i];
//             if ([model.sectionId isEqualToString:sectionModel.sectionId]) {
//                 currentPro = [NSString stringWithFormat:@"%ld",i+1];
//                 [self.bottomSecitonView highlightWithSection:[currentPro integerValue]];
//                 [TAAILearnViewModel postProgressToServiceWithClientId:tempToken setionId:self.sectionModel.sectionId lessonId:self.sectionModel.lessonId courseId:self.sectionModel.courseId isStartProgress:@"0"];
//             }
//         }
        
    };
}

- (void)hiddenSubtitle:(UIButton *)btn{
    NSLog(@"切换字幕");
}


- (void)selectMenuItemAtIndex:(NSInteger)index{
    [MBProgressHUD showMessage:@""];
    TAAIClassSectionModel * sectionModel = self.sectionMenuArray[index];
    NSInteger currentIndex = 0;
    for (NSInteger i = 0; i < self.sectionArray.count; i ++) {
        TAAIClassSectionModel * model = self.sectionArray[i];
        if ([sectionModel.sectionId isEqualToString:model.sectionId]) {
            NSLog(@"对应的index为:%ld",i);
            currentIndex = i;
        }
    }
    TAAIClassSectionModel * model = self.sectionArray[currentIndex];
    NSDictionary *partDic = model.partList.firstObject;
    TAAIPartModel *partModel = [TAAIPartModel mj_objectWithKeyValues:partDic];
    self.currentIndex = 0;
    self.currentSection = currentIndex;
    [self.learView showAlerViewWithSectionModel:model withPartModel:partModel];
}

- (void)TAAISectionViewDidClickSection:(NSInteger)index {
    
}




- (void)startClass {
    NSLog(@"开始上课");
    self.learView.classState = TAAIClassStateEndQuestion;
    [self partEnd];
}
- (void)retryClick {
    self.currentIndex = -1;
    [self partEnd];
}
- (void)nextClick {
    [self partEnd];
}

- (void)followUpViewBottomBtnViewDidClickCancelBtn {
    //弹出是否允许访问麦克风时，选择了取消
    [self pop];
}

#pragma mark action
- (void)partEnd {
    NSLog(@"播放结束了");
    //移除所有视图
    if (self.learView.classState == TAAIClassStateAnswerQuestion||self.learView.classState == TAAIClassStateCoreVocabulary||self.learView.classState == TAAIClassStatefFeedBack||self.learView.classState == TAAIClassStateFollowRead) {
        //如果当前是答题模式或者是核心词汇模式则需要作出选择之后才可以进行下一个视频播放
        return;
    }
    if (self.currentSection > self.sectionArray.count) {
        return;
    }
    self.currentIndex ++;
    //当前Section 小于 所有section则说明没学完
    if (self.currentSection < self.sectionArray.count) {
        //1.先判断当前index是否大于当前seciton的part数量
        NSArray *pars = self.partArray[self.currentSection];
        if(self.currentIndex < pars.count){
            TAAIClassSectionModel *sectionModel = self.sectionArray[self.currentSection];
            NSDictionary *partDic = pars[self.currentIndex];
            NSLog(@"当前index:%ld--当前section:%ld",self.currentIndex,self.currentSection);
            TAAIPartModel *partModel = [TAAIPartModel mj_objectWithKeyValues:partDic];
            if (!partModel.learningObj&&!partModel.questionObj) {
                [self partEnd];
                return;
            }
            //继续学习下一个part
            [self.learView showAlerViewWithSectionModel:sectionModel withPartModel:partModel];
        }else{
            //学习下一个section
            self.currentSection ++;
            self.currentIndex = 0;
             NSLog(@"当前index:%ld--当前section:%ld",self.currentIndex,self.currentSection);
            if (self.currentSection == self.sectionArray.count) {                NSLog(@"学习完了");
                TAAINetWorkViewController *net = [[TAAINetWorkViewController alloc] init];
                net.title = @"本课报告";
                net.needPopToDetail = YES;
                net.courseId = self.learnModel.courseId;
                net.url = [NSString stringWithFormat:@"%@?token=%@&lessonId=%@&courseId=%@",HTMLUrl,tempToken,self.learnModel.lessonId,self.learnModel.courseId];
                [self pushVC:net];
                return;
            }
            //循环学下去
            TAAIClassSectionModel *sectionModel = self.sectionArray[self.currentSection];
            pars = self.partArray[self.currentSection];
            if (pars.count == 0) {
                [self partEnd];
                return;
            }
            NSDictionary *partDic = pars[self.currentIndex];
            TAAIPartModel* partModel = [TAAIPartModel mj_objectWithKeyValues:partDic];
            [self.learView showAlerViewWithSectionModel:sectionModel withPartModel:partModel];
        }
    
    }
}



#pragma mark lazy Load
- (NSMutableArray *)partArray {
    if (!_partArray) {
        _partArray = [NSMutableArray new];
    }
    return _partArray;
}

- (NSMutableArray *)sectionArray {
    if (!_sectionArray) {
        _sectionArray = [NSMutableArray new];
    }
    return _sectionArray;
}

- (NSMutableArray *)currentPlayArray {
    if (!_currentPlayArray) {
        _currentPlayArray = [NSMutableArray new];
    }
    return _currentPlayArray;
}

- (TAAISectionView *)sectionView {
    if (!_sectionView) {
        _sectionView = [[TAAISectionView alloc] init];
        _sectionView.backgroundColor = [UIColor whiteColor];
        _sectionView.delegate = self;
    }
    return _sectionView;;
}

- (TAAILearnView *)learView {
    if (!_learView) {
        _learView = [[TAAILearnView alloc] init];
        _learView.delegate = self;
    }
    return _learView;
}

- (NSMutableArray *)sectionMenuArray {
    if (!_sectionMenuArray) {
        _sectionMenuArray = [NSMutableArray new];
    }
    return _sectionMenuArray;
}

- (NSMutableArray *)partMenuArray {
    if (!_partMenuArray) {
        _partMenuArray = [NSMutableArray new];
    }
    return _partMenuArray;
}

- (TAAIFollowUpView*)followUpView {
    if (!_followUpView) {
        _followUpView = [[TAAIFollowUpView alloc]init];
        _followUpView.btnView.delegate=self;
    }
    return _followUpView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    static int i = 0;
    if (i % 2==0) {
        [self.learView hiddenAlert];
    }else{
        [self.learView showAlert];
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
    i ++;
}

@end
