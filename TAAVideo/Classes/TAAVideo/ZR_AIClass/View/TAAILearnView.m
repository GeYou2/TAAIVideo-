//
//  BaseLearnView.m
//  TutorABC
//
//  Created by Slark on 2020/5/8.
//  Copyright © 2020 Slark. All rights reserved.
//

#import "TAAILearnView.h"
#import "TAAICoreVocabulartCell.h"
#import "TAAIKeyWordsView.h"
#import "TAAIChoiceView.h"
#import "TAAIAnalysisView.h"
#import "SRVideoPlayer.h"
#import "TAAISectionView.h"
#import "TAAISectionModel.h"
#import "TAAILearnObjModel.h"
#import "TAAIKeyWordsModel.h"
#import "TAAIKeyWordsView.h"
#import "TAAIQuestionModel.h"
#import "TAAIClassSectionModel.h"
#import "TAAIFollowUpView.h"
#import "TAAIFollowUpView.h"
#import "TAAIScoreImageView.h"
typedef NS_ENUM(NSUInteger,TAAISubtileState){
    TAAISubtileStateEnglish = 0,//英文
    TAAISubtileStateBilingual = 1,//中英
    TAAISubtileStateHidden = 2,//隐藏
};
#import "TAAIQuestionExtModel.h"

static CGFloat currentProgress = 1.0f;

@interface TAAILearnView()<UITableViewDelegate,
UITableViewDataSource,
TAAIChoiceViewDelegate,
SRVideoTopBarBarDelegate,
SRVideoPlayerDelegate,
TAAISectionViewDelegate,
TAAIFollowUpBottomBtnViewDelegate>

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *scrollBgView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *headTitle;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView* scoreView;
@property (nonatomic, strong) UIButton *drawBtn;//拖拽按钮
@property (nonatomic, strong) UIButton *beginClassBtn;//开始上课按钮
@property (nonatomic, strong) TAAIKeyWordsView *keyWordView;
@property (nonatomic, strong) UIView *bottomBtnView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIProgressView *bottomProgressView;
@property (nonatomic, strong) NSTimer *bottomTimer;
@property (nonatomic, strong) TAAIAnalysisView *analysView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) SRVideoPlayer *videoPlayer;//视频播放器
@property (nonatomic, strong) TAAISectionView *bottomSecitonView;

@property (nonatomic, assign) NSInteger subtileState;//字幕状态（默认0：英文）
@property (nonatomic, assign) NSInteger oldSubtileState;
@property (nonatomic, strong) UIButton *subTitleBtn;//字幕按钮
@property (nonatomic, strong) TAAIPartModel* partModel;//当前播放的part
@property (nonatomic, strong) TAAIQuestionModel *questionModel;
@property (nonatomic, strong) NSMutableDictionary *subtitleDict;//当前字幕
//单独的浮层
@property (nonatomic, strong) UILabel *floatSingleLabel;
@property (nonatomic, strong) MASConstraint *scrollbgHeight;
@property (nonatomic, strong) MASConstraint *viewBottom;
@property (nonatomic, assign) NSInteger dissmissSecond;
@property (nonatomic, strong) TAAIFollowUpView *followView;
//跟读分数
@property (nonatomic, copy) NSString *followScore;
//回弹视图
@property (nonatomic, strong) TAAIScoreImageView *scroeImageView;
@property (nonatomic, strong) TAAIClassSectionModel *sectionModel;
@property (nonatomic, assign) CGFloat minHeight;
@property (nonatomic, strong) NSMutableDictionary *Params;
@property (nonatomic, strong) NSMutableArray *clienAnswerList;
@property (nonatomic, strong) NSMutableDictionary *answerDic;
@property (nonatomic, copy) NSString *followString;
@property (nonatomic, strong) TAAIClassSectionModel *sectionMenuModel;

@end

@implementation TAAILearnView

#pragma mark 初始化
- (instancetype)init {
    self = [super init];
    if (self) {
        //self.backgroundColor = [UIColor orangeColor];
        [self setUp];
    }
    return self;
}

- (void)setUp {
    [self.allParts removeAllObjects];
    [self addSubview:self.topProgressView];
    [self.topProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(36);
        make.height.mas_equalTo(3);
    }];
    self.topProgressView.hidden = YES;
    
    //预加载图片
    [self addSubview:self.bgImageView];
    [self sendSubviewToBack:self.bgImageView];
    self.bgImageView.backgroundColor = [UIColor clearColor];
    self.bgImageView.hidden = YES;
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    //加载播放器
    self.videoPlayer = [SRVideoPlayer playerWithPlayerView:self playerSuperView:self.superview];
    self.videoPlayer.delegate=self;
    self.videoPlayer.bottomHidden = YES;
    self.videoPlayer.playerEndAction = SRVideoPlayerEndActionStop;
    self.videoPlayer.titleLabel.text = @"";
    
    [self addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0.1);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(0);
        } else {
            make.top.mas_equalTo(20);
        }
    }];
    
    [self addSubview:self.bottomSecitonView];
    [self.bottomSecitonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-44);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0.1);
    }];
    //字幕UI
    [self.videoPlayer.subtitle removeFromSuperview];
    [self addSubview:self.videoPlayer.subtitle];
    [self.videoPlayer.subtitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomSecitonView.mas_top).offset(-20);
        make.centerX.equalTo(self);
    }];
    
    [self.videoPlayer.subtitleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.videoPlayer.subtitle);
        make.right.bottom.equalTo(self.videoPlayer.subtitle).mas_equalTo(10);
    }];
    
    [self bringSubviewToFront:self.topProgressView];
}



- (void)publicUI {
    [self.scrollBgView removeFromSuperview];
    self.scrollBgView = nil;
    [self addSubview:self.scrollBgView];
    [self.scrollBgView addSubview:self.scrollView];
    [self.scrollView addSubview:self.bgView];
    [self.bgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self addSubview:self.drawBtn];
    
    [self.scrollBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@8);
        make.right.equalTo(@-8);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(0);
        } else {
            make.bottom.mas_equalTo(0);
        }
        _scrollbgHeight= make.height.mas_equalTo(0.1);
    }];
    
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.mas_equalTo(0);
        make.bottom.equalTo(self).with.offset(0);
    }];
    
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scrollView);
        make.width.mas_equalTo(self.scrollView);
        _viewBottom = make.height.mas_equalTo(self.scrollView);
    }];
    
    [self.drawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@77);
        make.height.equalTo(@0);
        make.bottom.equalTo(self.scrollBgView.mas_top).with.offset(0);
        make.centerX.equalTo(self);
    }];
}

//字幕
- (void)fetchSubtitle{
    NSDictionary *enSubtitle = [self.subtitleDict objectForKey:@"en"];
    NSDictionary *cnSubtitle = [self.subtitleDict objectForKey:@"cn"];
    NSMutableDictionary *subDicat = [NSMutableDictionary dictionary];
    
    switch (self.subtileState) {
        case TAAISubtileStateEnglish:
            [self.subTitleBtn setImage:[UIImage imageNamed:@"英语"] forState:normal];
            [self.subTitleBtn setImage:[UIImage imageNamed:@"英语"] forState:UIControlStateHighlighted];
            if (enSubtitle) {
                [subDicat setObject:enSubtitle forKey:@"en"];
            }
            break;
        case TAAISubtileStateBilingual:
            [self.subTitleBtn setImage:[UIImage imageNamed:@"中英"] forState:normal];
            [self.subTitleBtn setImage:[UIImage imageNamed:@"中英"] forState:UIControlStateHighlighted];
            if (cnSubtitle) {
                [subDicat setObject:cnSubtitle forKey:@"cn"];
            }
            if (enSubtitle) {
                [subDicat setObject:enSubtitle forKey:@"en"];
            }
            break;
        case TAAISubtileStateHidden:
            [self.subTitleBtn setImage:[UIImage imageNamed:@"隐藏"] forState:normal];
            [self.subTitleBtn setImage:[UIImage imageNamed:@"隐藏"] forState:UIControlStateHighlighted];
            break;
        default:
            break;
    }
    self.videoPlayer.subtitledict = subDicat;
}

#pragma mark Core-Method
- (void)showAlerViewWithSectionModel:(TAAIClassSectionModel*)sectionModel
                       withPartModel:(TAAIPartModel*)partModel{
    [self removeScoreView];
    [self removeUselessSubViews];
    //获取进度所有的parts
    
    //通过SectionModel 获取当前SectionModel的第一个part
    self.partModel = partModel;
    self.sectionModel = sectionModel;
    //获取字幕
    TAAILearnObjModel *tempObjModel = [TAAILearnObjModel mj_objectWithKeyValues:partModel.learningObj];
    NSMutableDictionary *subTitle = [NSMutableDictionary dictionary];
    if ([NSString nullToString:tempObjModel.cnSubtitles].length>0) {
        [subTitle setObject:[self dictionaryWithJson:tempObjModel.cnSubtitles] forKey:@"cn"];
    }
    if ([NSString nullToString:tempObjModel.enSubtitles].length>0) {
        [subTitle setObject:[self dictionaryWithJson:tempObjModel.enSubtitles] forKey:@"en"];
    }
    self.subtitleDict = subTitle;
    //显示字幕
    [self fetchSubtitle];
    /*如果是AI评测,则记录每一次的结果*/
    if([sectionModel.aiEvaluating isEqualToString:@"1"]){
        self.answerDic = [NSMutableDictionary new];
    }
    
    //bottomMenuItem
    NSString* currentPro;
    for(NSInteger i = 0; i < self.sectionArray.count; i ++){
        TAAIClassSectionModel * model = self.sectionArray[i];
        if ([model.sectionId isEqualToString:sectionModel.sectionId]) {
            currentPro = [NSString stringWithFormat:@"%ld",i+1];
            NSLog(@"当前进度%@",currentPro);
            [self.bottomSecitonView highlightWithSection:[currentPro integerValue]];
            [TAAILearnViewModel postProgressToServiceWithClientId:tempToken setionId:self.sectionModel.sectionId lessonId:self.sectionModel.lessonId courseId:self.sectionModel.courseId isStartProgress:@"0"];
            self.sectionMenuModel = model;
            
        }
    }
    
    //顶部进度条
    for (NSInteger i = 0; i < self.allParts.count; i ++) {
        TAAIPartModel* partModel = self.allParts[i];
        if ([partModel.partId isEqualToString:self.partModel.partId]) {
            CGFloat progress = [[NSString stringWithFormat:@"%d",i + 1] floatValue];
            CGFloat value = progress / self.allParts.count;
            self.topProgressView.progress = value;
        }
    }
    self.bgImageView.backgroundColor = [UIColor whiteColor];
    self.bgImageView.hidden = NO;
    //判断是否是开场视频
    if([sectionModel.title isEqualToString:@""]||!sectionModel.title||[sectionModel.title isKindOfClass:[NSNull class]]){
        //获取当前学习字典的值
        TAAILearnObjModel *learnObjModel = [TAAILearnObjModel mj_objectWithKeyValues:partModel.learningObj];
        UIImage *placeHolderImage = [TAAILearnViewModel getVideoImageWithUrl:[NSURL URLWithString:learnObjModel.bgUrl] atTime:1];
        self.bgImageView.image = placeHolderImage;
        
        //判断是否是开场视频
        TAAIClassSectionModel * firstSection = self.allSecionsArray.firstObject;
        if ([firstSection.sectionId isEqualToString:sectionModel.sectionId]) {
            //展示核心词汇 如果有keywordList说明有核心词汇
            if (learnObjModel.keywordList.count > 0) {
                //首先获取核心词汇
                NSDictionary *keyWordDic = learnObjModel.keywordList.firstObject;
                TAAIKeyWordsModel *keyWordModel = [TAAIKeyWordsModel mj_objectWithKeyValues:keyWordDic];
                NSMutableArray* dataArray =  [self getCoreWordListWithString:keyWordModel.DDescription];
                self.dataArray = dataArray;
                //先展示缩小图
                [self coreVocabulary];
            }
            self.classState = TAAIClassStateCoreVocabulary;
        }else{
            
        }
        //设置视频
        self.videoUrl = learnObjModel.bgUrl;
        self.videoPlayer.playerEndAction = SRVideoPlayerEndActionStop;
    }else{
        //如果不是开场视频需要判断当前的partModel是学习还是答题
        if([partModel.partType isEqualToString:@"Learning"]){
            //如果是学习视频当keyType为0的时候是基本浮层,其余为分支浮层
            NSDictionary *learnObjDic = partModel.learningObj;
            TAAILearnObjModel *learnObjModel = [TAAILearnObjModel mj_objectWithKeyValues:learnObjDic];
            //占位图
            UIImage *placeHolderImage = [TAAILearnViewModel getVideoImageWithUrl:[NSURL URLWithString:learnObjModel.bgUrl] atTime:1];
            self.bgImageView.image = placeHolderImage;
            NSDictionary *keyWordDic = learnObjModel.keywordList.firstObject;
            TAAIKeyWordsModel *keyWordModel = [TAAIKeyWordsModel mj_objectWithKeyValues:keyWordDic];
            //当keywordType 为0的时候展示基本图层,为其他值的时候展示分支图层
            if ([keyWordModel.keywordType isEqualToString:@"0"]) {
                //基本图层
                self.classState = TAAIClaasStateSingleView;
                //                [self addSubview:self.floatSingleLabel];
                //                self.floatSingleLabel.text = keyWordModel.DDescription;
                //                [self.floatSingleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                //                    make.left.mas_equalTo(16);
                //                    make.right.mas_equalTo(-16);
                //                    make.bottom.mas_equalTo(-120);
                //                }];
            }else{
                //分支图层
                self.classState = TAAIClaasStateBranchView;
                [self lineCoreVocabularyWithArray:[TAAILearnViewModel getFloatLayerDataWithPartModel:self.partModel]];
            }
            //获取视频播放路径
            self.videoUrl = learnObjModel.bgUrl;
        }else if ([partModel.partType isEqualToString:@"Question"]){
            NSDictionary *questionDic = partModel.questionObj;
            TAAIQuestionModel *quesObjModel = [TAAIQuestionModel mj_objectWithKeyValues:questionDic];
            //占位图
            UIImage *placeHolderImage = [TAAILearnViewModel getVideoImageWithUrl:[NSURL URLWithString:quesObjModel.bgUrl] atTime:1];
            self.bgImageView.image = placeHolderImage;
            //判断questionType,0单选,1跟读
            if([quesObjModel.questionType isEqualToString:@"0"]){
                //1.当视频开始播放在出现题目 弹框模式从下到上 //不需要判断appearTime和contituTime
                self.classState = TAAIClassStateAnswerQuestion;
                [self notChoice];
            }else if ([quesObjModel.questionType isEqualToString:@"1"]){
                //1.当视频开始播放在出现跟读题目 弹框模式从下到上 //不需要判断appearTime和contituTime
                //创建跟读View
                self.classState = TAAIClassStateFollowRead;
                [self followRead];
            }
            //获取视频路径
            self.videoUrl =  quesObjModel.bgUrl;
            self.videoPlayer.playerEndAction = SRVideoPlayerEndActionLoop;
        }
    }
}

- (void)setVideoUrl:(NSString *)videoUrl {
    _videoUrl = videoUrl;
    self.videoPlayer.videoURL = [NSURL URLWithString:_videoUrl];
    [self.videoPlayer play];
}


#pragma mark method
- (NSDictionary *)dictionaryWithJson:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (NSMutableArray *)getCoreWordListWithString:(NSString*)keyWords {
    NSMutableArray * wordsArr = [NSMutableArray new];
    if (keyWords.length < 6) {
        return wordsArr;
    }
    NSString *keyWordsSuffix = [keyWords substringFromIndex:5];
    NSArray *dataArray = [keyWordsSuffix componentsSeparatedByString:@"##"];
    NSMutableArray* prefix = [NSMutableArray new];
    NSMutableArray* suffix = [NSMutableArray new];
    for (NSInteger i = 0; i < dataArray.count; i ++) {
        NSString * indexString = dataArray[i];
        NSArray * stringArr = [indexString componentsSeparatedByString:@"\\n"];
        if (stringArr.count >= 2) {
            [prefix addObject:stringArr.firstObject];
            [suffix addObject:stringArr.lastObject];
        }else{
            [prefix addObject:stringArr.firstObject];
            [suffix addObject:@" "];
        }
    }
    [wordsArr addObject:prefix];
    [wordsArr addObject:suffix];
    return wordsArr;
}
#pragma mark method 学习状态UI
#pragma mark ------------跟读
//跟读
- (void)followRead {
    NSDictionary *questionDic = self.partModel.questionObj;
    TAAIQuestionModel *questionModel = [TAAIQuestionModel mj_objectWithKeyValues:questionDic];
    self.questionModel = questionModel;
    [self addSubview:self.followView];
    self.followView.btnView.delegate = self;
    self.followView.btnView.partModel = self.partModel;
    self.followView.tipsLabel.text = @"请跟读以下内容";
    NSDictionary *followDic = questionModel.followList.firstObject;
    self.followView.textLabel.text = followDic[@"content"];
    self.followString = followDic[@"content"];
    self.followView.btnView.contentText = followDic[@"content"];
    [self.followView.btnView creatChEngine];
    [self.followView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self bringSubviewToFront:self.topView];
}

#pragma mark ------------未选
//未选
- (void)notChoice {
    [self publicUI];
    NSDictionary *questionDic = self.partModel.questionObj;
    TAAIQuestionModel *questionModel = [TAAIQuestionModel mj_objectWithKeyValues:questionDic];
    self.questionModel = questionModel;
    [self.bgView addSubview:self.headTitle];
    self.headTitle.text = @"请选择正确的选项";
    self.headTitle.textColor = [UIColor lightGrayColor];
    [self.headTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@25);
        make.top.equalTo(@18);
        make.height.equalTo(@20);
        make.right.mas_equalTo(-25);
    }];
    
    [self.bgView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@25);
        make.right.lessThanOrEqualTo(@-18);
        make.top.equalTo(self.headTitle.mas_bottom).with.offset(12);
    }];
    self.contentLabel.text = questionModel.title;
    
    TAAIChoiceView *replaceView;
    CGFloat questionSpace = 24;
    NSMutableArray *optionArr = [NSMutableArray new];
    for (NSDictionary* optionDic in questionModel.questionExtOptionList) {
        TAAIQuestionExtModel *model = [TAAIQuestionExtModel mj_objectWithKeyValues:optionDic];
        [optionArr addObject:model];
    }
    NSArray *wordArray = @[@"A",@"B",@"C",@"D",@"E",@"F"];
    for (NSInteger i = 0 ; i < questionModel.questionExtOptionList.count; i ++) {
        TAAIQuestionExtModel *optionModel = optionArr[i];
        NSString *optionString = [NSString stringWithFormat:@"%@.%@",optionModel.option,optionModel.content];
        TAAIChoiceView *choice = [[TAAIChoiceView alloc]initWithTitle:optionString AndSelectedTag:wordArray[i]];
        choice.tag = i + 100;
        choice.delegate = self;
        [self.bgView addSubview:choice];
        if (i == 0) {
            [choice mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(18);
                make.right.mas_equalTo(-18);
                make.top.equalTo(self.contentLabel.mas_bottom).with.offset(questionSpace);
            }];
        }else if (i == questionModel.questionExtOptionList.count-1){
            [choice mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(18);
                make.right.mas_equalTo(-18);
                make.top.mas_equalTo(replaceView.mas_bottom).with.offset(questionSpace);
            }];
        }else{
            [choice mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(18);
                make.right.mas_equalTo(-18);
                make.top.mas_equalTo(replaceView.mas_bottom).with.offset(questionSpace);
            }];
        }
        replaceView = choice;
        choice.choiceState = TAAIChoiceStateUnSelected;
    }
    TAAIAnalysisView *analysView = [[TAAIAnalysisView alloc] initWithContent:self.questionModel.answerAnalysis];
    [self.bgView addSubview:analysView];
    self.analysView = analysView;
    [analysView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.right.mas_equalTo(-18);
        make.top.mas_equalTo(replaceView.mas_bottom).with.offset(20);
        make.height.mas_equalTo(0.1);
    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.analysView.mas_bottom).mas_offset(20);
    }];
    
    // 底部弹出按钮
    [self addSubview:self.bottomBtnView];
    [self.bottomBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(0);
        } else {
            make.bottom.mas_equalTo(0);
        }
        make.left.equalTo(@8);
        make.right.equalTo(@-8);
        make.height.equalTo(@0);
    }];
    
    //底部进度条
    [self addSubview:self.bottomProgressView];
    self.bottomProgressView.hidden = YES;
    [self.bottomProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(0);
        } else {
            make.bottom.mas_equalTo(0);
        }
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        make.height.mas_equalTo(10);
    }];
    [self bringSubviewToFront:self.bottomProgressView];
    NSLog(@"%.2f",self.scrollBgView.height);
}

#pragma mark ------------核心词汇

- (void)lineCoreVocabularyWithArray:(NSMutableArray*)array {
    if (array.count <= 0||!array) {
        return;
    }
    self.keyWordView = [[TAAIKeyWordsView alloc] initWithArray:array];
    self.keyWordView.clipsToBounds = YES;
    [self addSubview:self.keyWordView];
    [self.keyWordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(36);
        make.right.mas_equalTo(-36);
        make.bottom.mas_equalTo(-134);
        make.height.mas_equalTo(0.1);
    }];
}

//核心词汇
- (void)coreVocabulary {
    [self publicUI];
    [self.bgView addSubview:self.tableView];
    [self.tableView registerClass:[TAAICoreVocabulartCell class] forCellReuseIdentifier:@"CoreVocabulart"];
    [self.tableView reloadData];
    
    CGFloat BgViewHeight;
    CGFloat spceHeight = 91;
    CGFloat cellHeight = 71;
    BgViewHeight  = (self.dataArray.count+1)*cellHeight+spceHeight;
    //词汇最多5个
    NSArray* currentData = self.dataArray.firstObject;
    if (currentData.count>5) {
        [self.drawBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
        }];
        BgViewHeight = (6)*cellHeight+spceHeight;
    }
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        if (currentData.count > 5) {
            make.height.mas_equalTo((6) * cellHeight);
        }else{
            make.height.mas_equalTo((currentData.count+1) * cellHeight);
        }
    }];
    
    [self.bgView addSubview:self.beginClassBtn];
    [self.beginClassBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-25);
        } else {
            make.bottom.mas_equalTo(0);
        }
        make.left.equalTo(@18);
        make.right.equalTo(@-18);
        make.height.equalTo(@48);
        make.top.mas_equalTo(self.tableView.mas_bottom).with.offset(23);
    }];
}

#pragma mark  Video - Delegate

//开始播放
- (void)videoPlayerDidPlay:(SRVideoPlayer *)videoPlayer {
    NSLog(@"开始播放");
    [MBProgressHUD hideHUD];
    self.topProgressView.hidden = NO;
    [self performSelector:@selector(hiddenPlaceHoloder) withObject:nil afterDelay:1];
    //跟读 回答问题 在视频开始播放的时候直接弹出来
    if(self.classState == TAAIClassStateFollowRead){//跟读
        //  跟读
        NSLog(@"展示跟读视图");
        //  [self showFollowReadView];
    }else if (self.classState == TAAIClassStateAnswerQuestion){//回答问题
        //回答问题  //开启倒计时
        NSLog(@"展示答题视图");
        [self showQuestionView];
    }else if (self.classState == TAAIClassStateEndQuestion){//答题结束
        NSLog(@"答题结束");
    }else if (self.classState == TAAIClassStatefFeedBack){//视频反馈
        NSLog(@"选题反馈");
    }else if (self.classState == TAAIClassStateCoreVocabulary){//核心词汇
        [self showVocabulary];
    }else if (self.classState == TAAIClassStateEndFollowRead){//跟读结束
        NSLog(@"跟读结束");
    }else if (self.classState == TAAIClaasStateSingleView){//单一视图
        NSLog(@"展示单一视图");
        NSArray *keyWordArr = self.partModel.learningObj[@"keywordList"];
        NSDictionary *keywordDic  = keyWordArr.firstObject;
        TAAIKeyWordsModel *keyWordModel = [TAAIKeyWordsModel mj_objectWithKeyValues:keywordDic];
        self.dissmissSecond = [keyWordModel.continueTime integerValue];
        [self performSelector:@selector(showSingleView) withObject:nil afterDelay:[keyWordModel.appearTime integerValue]];
    }else if (self.classState == TAAIClaasStateBranchView){//展示分支视图
        NSLog(@"展示分支视图");
        NSArray *keyWordArr = self.partModel.learningObj[@"keywordList"];
        NSDictionary *keywordDic  = keyWordArr.firstObject;
        TAAIKeyWordsModel *keyWordModel = [TAAIKeyWordsModel mj_objectWithKeyValues:keywordDic];
        self.dissmissSecond = [keyWordModel.continueTime integerValue];
        [self performSelector:@selector(showBranchView) withObject:nil afterDelay:[keyWordModel.appearTime integerValue] + 1];//分支浮层推迟一秒
    }
}

- (void)videoPlayerDidPlayEnd {
    
}

- (void)nextVideo{
    self.classState = TAAIClassStateNextStepState;
    if ([self.delegate respondsToSelector:@selector(nextClick)]) {
        [self.delegate nextClick];
    }
}

- (void)branchDissTime {
    [self showSingleView];
    NSArray *keyWordArr = self.partModel.learningObj[@"keywordList"];
    NSDictionary *keywordDic  = keyWordArr.firstObject;
    TAAIKeyWordsModel *keyWordModel = [TAAIKeyWordsModel mj_objectWithKeyValues:keywordDic];
    [self performSelector:@selector(dissmissSingleView) withObject:nil afterDelay:[keyWordModel.continueTime floatValue]];
}

- (void)videoPlayerTopBarDidClickCloseBtn {
    
}

- (void)videoPlayerTopBarDidClickDownloadBtn{
    
}

//视频切换全屏
- (void)changeScreenOrientationWithIsFullScreen:(BOOL)isFull {
    if (!isFull)  {
    }else{
    }
}

- (void)hiddenPlaceHoloder{
    self.bgImageView.hidden = YES;
}

#pragma mark choiceView - delegate
- (void)selectedViewWithTag:(NSString*)tag WithChoiceView:(id)choiceView{
    NSDictionary *partDic = self.partModel.questionObj;
    //选择之后
    self.bgImageView.hidden = NO;//显示最后一帧图片
    [self.bottomTimer invalidate];//销毁定时器
    self.bottomTimer = nil;
    currentProgress =  1.0f;//重置底部进度条
    TAAIChoiceView *choice = (TAAIChoiceView*)choiceView;
    NSString * correct = @"";
    if (![tag isEqualToString:self.questionModel.correctAnswer]) {
        if([self.sectionModel.aiEvaluating isEqualToString:@"1"]){
            [self.answerDic setValue:@"0" forKey:@"answerCorrect"];
        }
        correct = @"0";
        //选择错误
        [self bottomAlert];
        self.scroeImageView.scoreState = TAAIScoreStateOops;
        [self showScoreView];
        choice.choiceState = TAAIChoiceStateSelectedFalse;
        //获取反馈视频
        self.classState = TAAIClassStatefFeedBack;
        NSString *videoString = [TAAILearnViewModel getFailFeedBackVideoUrlWithPartModel:self.partModel];
        if (![videoString isEqualToString:@""]) {
            self.videoUrl = [TAAILearnViewModel getFailFeedBackVideoUrlWithPartModel:self.partModel];
            self.videoPlayer.playerEndAction = SRVideoPlayerEndActionStop;
        }
    }else{
        if([self.sectionModel.aiEvaluating isEqualToString:@"1"]){
            [self.answerDic setValue:@"1" forKey:@"answerCorrect"];
        }
        
        correct = @"1";
        choice.choiceState = TAAIChoiceStateSelectedRight;
        //选择正确
        self.scroeImageView.scoreState = TAAIScoreStateGreat;
        [self showScoreView];
        [self.bottomProgressView removeFromSuperview];
        self.bottomProgressView = nil;
        self.classState = TAAIClassStateEndQuestion;
        self.videoUrl = [TAAILearnViewModel getSuccessFeedBackVieeoUrlWithPartModel:self.partModel];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(nextVideo) object:nil];
    }
    //如果是AI评测,就存储当前做出的选择
    [self.answerDic setValue:partDic[@"questionId"] forKey:@"questionId"];
    [self.answerDic setValue:@"0" forKey:@"questionType"];//单选0 跟读1
    [self.answerDic setValue:@"TEXT" forKey:@"answerType"];//单选TEXT 音频AUDIO
    [self.answerDic setValue:tag forKey:@"answerContent"];
    [self.answerDic setValue:correct forKey:@"answerCorrect"];
    [self.answerDic setValue:self.partModel.partId forKey:@"partId"];
    if ([self.sectionModel.aiEvaluating isEqualToString:@"1"]) {//AI评测
        [self.clienAnswerList addObject:self.answerDic];//讲答题的数据存储到数组里面
        [self lastPart];
    }else {//答题评测
        [TAAILearnViewModel postChoiceDataToServicewWithPartModel:self.partModel SectionModel:self.sectionModel answer:tag correct:correct];
    }
    
}

- (void)lastPart {
    //如果当前评测的视频是当前section最后一个part
    NSArray *parts = self.sectionModel.partList;
    NSDictionary *lastDic = parts.lastObject;
    TAAIPartModel * lastModel = [TAAIPartModel mj_objectWithKeyValues:lastDic];
    if ([lastModel.partId isEqualToString:self.partModel.partId]) {
        //上传该section的数据给服务
        [TAAILearnViewModel postAITestToServiceWithSectionModel:self.sectionModel WithdataArray:self.clienAnswerList];
    }
}

#pragma mark 上传答案
- (void)postAITest {
    //如果是最后一个 就开开始上传数据
    TAAIClassSectionModel *sectionModel = self.sectionArray.lastObject;
    NSDictionary *dic = sectionModel.partList.lastObject;
    if ([self.partModel.partId isEqualToString:dic[@"partId"]]) {
        [self.Params setValue:ClientId forKey:@"clientId"];
        [self.Params setValue:self.partModel.partId forKey:@"partId"];
        [self.Params setValue:self.sectionModel.sectionId forKey:@"sectionId"];
        [self.Params setValue:self.sectionModel.lessonId forKey:@"lessonId"];
        [self.Params setValue:self.sectionModel.courseId forKey:@"courseId"];
        [self.Params setValue:self.clienAnswerList forKey:@"clientAnswerList"];
        NSLog(@"%@",self.Params);
    }
}


#pragma mark View Show-Diss

- (void)dissmissBranchView {
    NSLog(@"分支浮层消失");
    [self.keyWordView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.1);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
}

- (void)showBranchView {
    //隐藏字幕
    self.oldSubtileState = self.subtileState;
    self.subtileState = TAAISubtileStateHidden;
    [self fetchSubtitle];
    NSLog(@"展示分支浮层");
    NSDictionary *learnObj = self.partModel.learningObj;
    NSArray * array= [learnObj objectForKey:@"keywordList"];
    if (!array||array.count == 0) {
        return;
    }
    [self.keyWordView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(10 + self.keyWordView.dataArray.count * 50+20);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
    [self performSelector:@selector(dissBranchView) withObject:nil afterDelay:self.dissmissSecond];
}


- (void)dissBranchView{
    //显示字幕
    self.subtileState = self.oldSubtileState;
    [self fetchSubtitle];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.keyWordView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.keyWordView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.1);
        }];
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
    NSLog(@"分支消失");
}

- (void)showSingleView {
    NSLog(@"展示基本浮层");
    [UIView animateWithDuration:0.3 animations:^{
        self.floatSingleLabel.alpha = 1;
    }];
    [self performSelector:@selector(dissmissSingleView) withObject:nil afterDelay:self.dissmissSecond];
}

- (void)dissmissSingleView {
    NSLog(@"基本图层消失");
    [UIView animateWithDuration:0.3 animations:^{
        self.floatSingleLabel.alpha = 0;
    }];
}

- (void)showVocabulary{
    NSLog(@"核心词汇出现");
    [self performSelector:@selector(nextVideo) withObject:nil afterDelay:30];
    [_scrollbgHeight uninstall];
    [self.scrollBgView updateConstraints];
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
}

- (void)showQuestionView {
    NSLog(@"创建定时器定时器定时器");
    self.bottomProgressView.hidden = NO;
    self.bottomProgressView.progress = 1.0f;
    self.bottomTimer = [NSTimer timerWithTimeInterval:0.1
                                               target:self
                                             selector:@selector(timerRun)
                                             userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]
     addTimer:self.bottomTimer
     forMode:NSDefaultRunLoopMode];
    [_scrollbgHeight uninstall];
    [self.scrollBgView updateConstraints];
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
    
    NSLog(@"%.2f",self.scrollBgView.height);
    self.minHeight = self.scrollBgView.height;
}

- (void)showFollowReadView {
    NSLog(@"展示跟读视图");
    //    [_scrollbgHeight uninstall];
    //    [self.scrollBgView updateConstraints];
    //    [UIView animateWithDuration:0.3 animations:^{
    //        [self layoutIfNeeded];
    //    }];
}

- (void)dissFollowReadView{
    
}


- (void)removeScoreView{
    [self.scroeImageView removeFromSuperview];
    self.scroeImageView = nil;
    [self addSubview:self.scroeImageView];
    [self.scroeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.equalTo(@77);
        make.height.equalTo(@97);
        make.right.mas_equalTo(-ScreenWidth);
    }];
}


- (void)showScoreView {
    
    if (self.classState == TAAIClassStateFollowRead) {
        NSInteger score = [self.followScore integerValue];
        NSDictionary *questionObj = self.partModel.questionObj;
        NSInteger feedbackScore = [questionObj[@"correctAnswer"] integerValue];
        if (score < feedbackScore) {
            self.scroeImageView.scoreString = self.followScore;
            self.scroeImageView.scoreState = TAAIScoreStateReadCommon;
        }else{
            self.scroeImageView.scoreString = self.followScore;
            self.scroeImageView.scoreState = TAAIScoreStateReadGood;
        }
    }
    [self.scroeImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
    }];
    [UIView animateWithDuration:0.7 delay:0.3 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self performSelector:@selector(scoreDismiss) withObject:self afterDelay:0.5];
    }];
    
}

- (void)scoreDismiss {
    [self.scroeImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ScreenWidth);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.scroeImageView removeFromSuperview];
        self.scroeImageView = nil;
        [self removeScoreView];
    }];
}

- (void)showAlert {
    [self.bottomSecitonView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(66);
    }];
    [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(105);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
}

- (void)hiddenAlert {
    [self.bottomSecitonView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.1);
    }];
    [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.1);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
}

- (void)showDrawBtn {
    [self.drawBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
}

#pragma mark SectionView - Delegate

- (void)TAAISectionViewDidClickSection:(NSInteger )index {
    self.bgImageView.hidden = NO;
    [self dissBranchView];
    if([self.delegate respondsToSelector:@selector(selectMenuItemAtIndex:)]){
        [self.delegate selectMenuItemAtIndex:index];
    }
}

- (void)bottomAlert{
    //  [_viewBottom uninstall];
    [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(self.contentLabel.height);
    }];
    for (NSInteger i = 0; i < self.questionModel.questionExtOptionList.count; i ++) {
        TAAIChoiceView * choice = [self.bgView viewWithTag:i + 100];
        choice.choiceState = TAAIChoiceStateUnSelected;
        choice.userInteractionEnabled = NO;
        [choice mas_updateConstraints:^(MASConstraintMaker *make) {
            NSLog(@"%.2f",choice.height);
            make.height.mas_offset(choice.height);
        }];
    }
    [self.analysView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(60);
    }];
    
    [self.scrollBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.scrollBgView.height+10);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-45);
        } else {
            make.bottom.mas_equalTo(-60);
        }
    }];
    
    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        if([self isIPhoneX]){
            make.bottom.mas_equalTo(self.scrollView).mas_offset(-80);
        }else{
            make.bottom.mas_equalTo(self.scrollView).mas_offset(-50);
        }
    }];
    
    [self.drawBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
    }];
    
    [self.bottomBtnView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(60);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
    
    self.bottomProgressView.hidden = YES;
    //无操作30秒下一个
    [self performSelector:@selector(nextVideo) withObject:nil afterDelay:30];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray* dataArray = self.dataArray.firstObject;
    return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 71;
}

#pragma mark - UITableViewDelegate
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TAAICoreVocabulartCell* cell = [[TAAICoreVocabulartCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CoreVocabulart"];
    NSArray *words = self.dataArray.firstObject;
    NSArray *analys = self.dataArray.lastObject;
    cell.wordTitle.text = words[indexPath.row];
    cell.analysisLabel.text = analys[indexPath.row];
    cell.backgroundColor = [UIColor UIColorFormHexString:@"#FFFFFF"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 71;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor UIColorFormHexString:@"#FFFFFF"];
    UILabel* label = [[UILabel alloc]init];
    label.text = @"核心词汇";
    label.font = [UIFont boldSystemFontOfSize:21];
    label.textColor = [UIColor UIColorFormHexString:@"#0A1F44"];
    [headView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@26);
        make.top.equalTo(@24);
        make.height.equalTo(@29);
    }];
    
    UIView *view = [[UIView alloc] init];
    // gradient
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,3,83,9);
    gl.startPoint = CGPointMake(0.96, 1);
    gl.endPoint = CGPointMake(0.08, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:249/255.0 green:112/255.0 blue:112/255.0 alpha:0.0].CGColor, (__bridge id)[UIColor colorWithRed:240/255.0 green:61/255.0 blue:61/255.0 alpha:0.8].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    [view.layer addSublayer:gl];
    
    [headView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@26);
        make.width.equalTo(label.mas_width);
        make.height.equalTo(@8);
        make.bottom.equalTo(label.mas_bottom).with.offset(-3);
    }];
    
    
    [headView bringSubviewToFront:view];
    return headView;
}
#pragma  mark - other Delegate
- (void)videoPlayerCurrentTime:(CGFloat)currentTime {
    NSLog(@"当前播放%f秒",currentTime);
    //    self.partModel.learningObj.
}

- (void)followUpBottomBtnViewDidClickRecordBtn {
    NSLog(@"录音结束代理");
    //开启录音loading
    [MBProgressHUD showMessage:@""];
    NSDictionary *objDic = self.partModel.questionObj;
    UIImage *placeHolderImage = [TAAILearnViewModel getVideoImageWithUrl:[NSURL URLWithString:objDic[@"bgUrl"]] atTime:1];
    self.bgImageView.image = placeHolderImage;
    self.bgImageView.hidden = NO;
    
}

- (void)followUpBottomBtnViewDidChangeBtns:(NSString *)score allMessage:(NSDictionary *)messageDic{
    NSDictionary *questionObj = self.partModel.questionObj;
    //结束录音loading
    [MBProgressHUD hideHUD];
    NSLog(@"跟读分数：%@",score);
    self.followScore = score;
    [self showScoreView];
    self.classState = TAAIClassStateEndFollowRead;
    //ai评测
    if ([self.sectionModel.aiEvaluating isEqualToString:@"1"]) {
        [self postAIFollowReadWithdic:messageDic];
    }else{
        //不是
        [TAAILearnViewModel postFollowReadDataServiceWithMessageDic:messageDic PartModel:self.partModel SectionModel:self.sectionModel];
    }
    // 改变跟读内容UI
    NSDictionary *result = messageDic[@"result"];
    NSArray *details = result[@"details"];
    NSMutableArray *ranges = [NSMutableArray new];
    for (NSInteger i = 0; i < details.count; i ++) {
        NSDictionary *detailDic = details[i];
        NSString * singleScore = [NSString stringWithFormat:@"%@",detailDic[@"score"]];
        if ([singleScore integerValue] < [questionObj[@"correctAnswer"] integerValue] ) {
            NSString *beginIndex = [NSString stringWithFormat:@"%@",detailDic[@"beginindex"]];
            NSString *endIndex = [NSString stringWithFormat:@"%@",detailDic[@"endindex"]];
            NSArray *rangeArr = @[beginIndex,endIndex];
            [ranges addObject:rangeArr];
        }
    }
    [self changeLabel:self.followView.textLabel Color:[UIColor UIColorFormHexString:@"#F03D3D"] rangeArr:ranges];
}

- (void)changeLabel:(UILabel *)label Color:(UIColor *)changeColor rangeArr:(NSMutableArray *)rangeArr {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:label.text];
    for (NSInteger i = 0; i < rangeArr.count; i ++) {
        NSArray* singlsRange = rangeArr[i];
        NSString *beginIndex = singlsRange.firstObject;
        NSString *endIndex = singlsRange.lastObject;
        NSInteger endIntetger = [endIndex integerValue] - [beginIndex integerValue];
        [string addAttribute:NSForegroundColorAttributeName value:changeColor range:NSMakeRange([beginIndex integerValue], endIntetger+1)];
    }
    
    label.attributedText = string;
}


- (void)postAIFollowReadWithdic:(NSDictionary *)messgaeDic {
    NSDictionary *questionObj = self.partModel.questionObj;
    NSDictionary *result = messgaeDic[@"result"];
    NSString *score = result[@"overall"];
    NSString *fluencyOverall = result[@"fluency"][@"overall"]; //流利度总体得分--> 流利度
    NSString *integrity = result[@"integrity"]; //完整度评分-->词汇量
    NSString *rhythmOverall = result[@"rhythm"][@"overall"]; //韵律得分-->发音标准
    NSString *answerAssess = [NSString stringWithFormat:@"%@|%@|%@",fluencyOverall,integrity,rhythmOverall];
    [self.answerDic setValue:@"1" forKey:@"questionType"];
    [self.answerDic setValue:questionObj[@"questionId"] forKey:@"questionId"];
    [self.answerDic setValue:@"AUDIO" forKey:@"answerType"];
    [self.answerDic setValue:messgaeDic[@"audioUrl"] forKey:@"answerContent"];
    [self.answerDic setValue:score forKey:@"answerAssessTotalScore"];
    [self.answerDic setValue:@"流利度|词汇量|发音标准" forKey:@"answerAssess"];
    [self.answerDic setValue:answerAssess forKey:@"answerAssessScore"];
    [self.answerDic setValue:self.partModel.partId forKey:@"partId"];
    [self.clienAnswerList addObject:self.answerDic];
}

- (void)followReadGood {
    NSLog(@"读得很好");
    self.classState = TAAIClassStateEndFollowRead;
    NSString *video = [TAAILearnViewModel getSuccessFeedBackVieeoUrlWithPartModel:self.partModel];
    if (video.length > 0) {
        self.videoUrl = video;
    }
    [self lastPart];
}

- (void)followReadBad {
    NSLog(@"读得一般");
    self.classState = TAAIClassStateFollowRead;
    NSString *video = [TAAILearnViewModel getFailFeedBackVideoUrlWithPartModel:self.partModel];
    if (video.length > 0) {
        self.videoPlayer.playerEndAction =  SRVideoPlayerEndActionStop;
        self.videoUrl = video;
    }
    [self performSelector:@selector(nextVideo) withObject:nil afterDelay:30];
}


- (void)followUpBottomBtnViewDidClickContinueBtn {
    //占位图
    NSDictionary *objDic = self.partModel.questionObj;
    UIImage *placeHolderImage = [TAAILearnViewModel getVideoImageWithUrl:[NSURL URLWithString:objDic[@"bgUrl"]] atTime:1];
    self.bgImageView.image = placeHolderImage;
    self.bgImageView.hidden = NO;
    
    NSLog(@"继续");
    //检测是否上传数据
    [self lastPart];
    [self.followView removeFromSuperview];
    self.followView = nil;
    self.classState = TAAIClassStateEndQuestion;
    if ([self.delegate respondsToSelector:@selector(nextClick)]) {
        [self.delegate nextClick];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(nextVideo) object:nil];
}

//跟读重学
- (void)followUpBottomBtnViewDidClickReLearnBtn {
    //占位图
    NSDictionary *objDic = self.partModel.questionObj;
    UIImage *placeHolderImage = [TAAILearnViewModel getVideoImageWithUrl:[NSURL URLWithString:objDic[@"bgUrl"]] atTime:1];
    self.bgImageView.image = placeHolderImage;
    self.bgImageView.hidden = NO;
    [self bringSubviewToFront:self.bgImageView];
    
    
    [self.answerDic removeAllObjects];
    [self.clienAnswerList removeAllObjects];
    self.followView.textLabel.text = self.followString;
    NSLog(@"重学");
    [self.followView removeFromSuperview];
    self.followView = nil;
    self.classState = TAAIClassStateEndFollowRead;
    if ([self.delegate respondsToSelector:@selector(retryClick)]) {
        [self.delegate retryClick];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(nextVideo) object:nil];
}


//跟读再来一遍
- (void)followUpBottomBtnViewDidClickLearnAgainBtn {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(nextVideo) object:nil];
    //占位图
    NSDictionary *objDic = self.partModel.questionObj;
    UIImage *placeHolderImage = [TAAILearnViewModel getVideoImageWithUrl:[NSURL URLWithString:objDic[@"bgUrl"]] atTime:1];
    self.bgImageView.image = placeHolderImage;
    self.bgImageView.hidden = NO;
    
    self.videoUrl = self.partModel.questionObj[@"bgUrl"];
    [self.answerDic removeAllObjects];
    self.followView.textLabel.textColor = [UIColor blackColor];
    //分数背景图
    //  [self removeScoreView];
}

- (void)followUpBottomBtnViewDidClickCancelBtn {
    //    NSLog(@"取消允许麦克风  页面返回详情  代理");
    if ([self.delegate respondsToSelector:@selector(followUpViewBottomBtnViewDidClickCancelBtn)]) {
        [self.delegate followUpViewBottomBtnViewDidClickCancelBtn];
    }
}
#pragma mark action
- (void)leftClick{
    //销毁定时器
    [self.bottomTimer invalidate];
    self.bottomTimer = nil;
    //重置进度条
    currentProgress =  1.0f;
    //重学 移除所有存储的数据
    [self.clienAnswerList removeAllObjects];
    [self.answerDic removeAllObjects];
    //设置状态
    self.classState = TAAIClassStateEndQuestion;
    if ([self.delegate respondsToSelector:@selector(retryClick)]) {
        [self.delegate retryClick];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(nextVideo) object:nil];
    NSLog(@"重学");
}
- (void)rightClick{
    //判断是否需要上传评测数据
    [self lastPart];
    //销毁定时器
    [self.bottomTimer invalidate];
    self.bottomTimer = nil;
    currentProgress =  1.0f;
    self.classState = TAAIClassStateEndQuestion;
    if ([self.delegate respondsToSelector:@selector(nextClick)]) {
        [self.delegate nextClick];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(nextVideo) object:nil];
    NSLog(@"继续");
}


- (void)popToPrevious:(UIButton *)btn{
    if (btn.tag == 100) { //返回
        if([self.delegate respondsToSelector:@selector(gobackClick)]){
            [self.delegate gobackClick];
        }
        //上传
        if (self.sectionMenuModel) {
            [TAAILearnViewModel postProgressToServiceWithClientId:tempToken setionId:self.sectionMenuModel.sectionId lessonId:self.sectionMenuModel.lessonId courseId:self.sectionMenuModel.courseId
                                                  isStartProgress:@"1"];
        }
        
    }else if (btn.tag == 101){//切换字幕
        if (self.subtileState < 2) {
            self.subtileState += 1;
        }else {
            self.subtileState = 0;
        }
        [self fetchSubtitle];
        
        if ([self.delegate respondsToSelector:@selector(hiddenSubtitle:)]) {
            [self.delegate hiddenSubtitle:btn];
        }
    }
}

- (void)timerRun {
    currentProgress -= 0.005;
    self.bottomProgressView.progress = currentProgress;
    //  NSLog(@"进度---%.2f",self.bottomProgressView.progress);
    if (currentProgress < 0) {
        [self showScoreView];
        [self bottomAlert];
        for (NSInteger i = 0; i < self.questionModel.questionExtOptionList.count; i ++) {
            TAAIChoiceView * choice = [self.bgView viewWithTag:i + 100];
            choice.choiceState = TAAIChoiceStateUnSelected;
            choice.userInteractionEnabled = NO;
        }
        currentProgress = 1.0f;
        self.bgImageView.hidden = NO;
        self.videoUrl = [TAAILearnViewModel getFailFeedBackVideoUrlWithPartModel:self.partModel];
        self.videoPlayer.playerEndAction = SRVideoPlayerEndActionStop;
        [self.bottomTimer invalidate];
        self.bottomTimer = nil;
        self.scroeImageView.scoreState = TAAIScoreStateOops;
        self.classState = TAAIClassStatefFeedBack;
    }
}

- (void)btnPan:(UIPanGestureRecognizer*)panGes {
    CGPoint p = [panGes locationInView:self];//当前视图相对位置点
    CGPoint transP = [panGes translationInView:self];//手指当前位置偏移
    CGFloat top = p.y;
   
    
    CGFloat maxScrollHeight = (486.0f / 812) *  ScreenHeight;;
    CGFloat minTopSpace = ScreenHeight - maxScrollHeight-30;
    CGFloat maxTopSpace = ScreenHeight - self.minHeight-44;
    CGFloat cellHeight = 71;
    
    if(self.classState == TAAIClassStateCoreVocabulary){
        minTopSpace = ScreenHeight - maxScrollHeight- 2 * cellHeight;
        maxTopSpace = ScreenHeight - maxScrollHeight-24;
    }
    
    if (panGes.state == UIGestureRecognizerStateBegan) {
        
    }else if (panGes.state == UIGestureRecognizerStateChanged){
        if(self.classState == TAAIClassStateCoreVocabulary){
            if(top <= minTopSpace||top >= maxTopSpace){
                return;
            }
            if(transP.y < 0){
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(9 * cellHeight);
                }];
            }else{
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(6 * cellHeight);
                }];
            }
            [self.scrollBgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(top);
            }];
        }else if (self.classState == TAAIClassStatefFeedBack){
            if(top <= minTopSpace||top >= maxTopSpace){
                return;
            }
            //更新视图操作
            [self.scrollBgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(top);
            }];
            NSLog(@"%.2f",top);
            NSLog(@"%.2f",transP.y);            
        }
        
    }else if (panGes.state == UIGestureRecognizerStateEnded){
        if(self.classState == TAAIClassStateCoreVocabulary){
            if (transP.y < 0) {
                [self.scrollBgView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(minTopSpace);
                }];
                [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
                    [self layoutIfNeeded];
                } completion:^(BOOL finished) {
                    
                }];
            }
        }else if (self.classState == TAAIClassStatefFeedBack){

        }
    }
}

- (void)beginClassClick:(UIButton*)btn {
    [self.videoPlayer pause];
    self.bgImageView.hidden = NO;
    if ([self.delegate respondsToSelector:@selector(startClass)]) {
        [self.delegate startClass];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(nextVideo) object:nil];
}

#pragma mark Lazy Load

- (UIView*)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.layerCornerRadius = 16;
        _bgView.backgroundColor = [UIColor UIColorFormHexString:@"#FFFFFF"];
        
    }
    return _bgView;
}

- (UIButton*)drawBtn {
    if (!_drawBtn) {
        _drawBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_drawBtn setImage:[UIImage imageNamed:@"drawBtn"] forState:UIControlStateNormal];
        _drawBtn.clipsToBounds = YES;
        UIPanGestureRecognizer* panGes = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(btnPan:)];
        [_drawBtn addGestureRecognizer:panGes];
    }
    return _drawBtn;
}

- (UILabel*)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.font = [UIFont systemFontOfSize:18];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = [UIColor UIColorFormHexString:@"#0A1F44"];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _contentLabel;
}

- (UITableView*)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
        _tableView.allowsSelection = NO;
        _tableView.backgroundColor = [UIColor lightGrayColor];
    }
    return _tableView;
}

- (UILabel*)headTitle {
    if (!_headTitle) {
        _headTitle = [[UILabel alloc]init];
        _headTitle.font = [UIFont systemFontOfSize:14];
        _headTitle.textColor = TextColor;
        _headTitle.textAlignment = NSTextAlignmentLeft;
        _headTitle.numberOfLines = 0;
    }
    return _headTitle;
}

- (NSMutableArray*)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (UIButton*)beginClassBtn {
    if (!_beginClassBtn) {
        _beginClassBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_beginClassBtn addTarget:self action:@selector(beginClassClick:) forControlEvents:UIControlEventTouchUpInside];
        [_beginClassBtn setTitle:@"开始上课" forState:UIControlStateNormal];
        _beginClassBtn.backgroundColor = [UIColor UIColorFormHexString:@"#F03D3D"];
        _beginClassBtn.titleLabel.textColor = [UIColor UIColorFormHexString:@"#FFFFFF"];
        _beginClassBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _beginClassBtn.layerCornerRadius = 24;
    }
    return _beginClassBtn;
}

- (UIView *)bottomBtnView {
    if (!_bottomBtnView) {
        _bottomBtnView = [[UIView alloc] init];
        _bottomBtnView.backgroundColor = [UIColor lightGrayColor];
        _bottomBtnView.clipsToBounds = YES;
        
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.backgroundColor = [UIColor UIColorFormHexString:@"#FFFFFF"];
        [leftBtn setImage:[UIImage imageNamed:@"icon_relearn"] forState:UIControlStateNormal];
        [leftBtn setImage:[UIImage imageNamed:@"icon_relearn"] forState:UIControlStateHighlighted];
        leftBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 10);
        [leftBtn setTitle:@"重学" forState:UIControlStateNormal];
        leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        [leftBtn setTitleColor:[UIColor UIColorFormHexString:@"#8A94A6"] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomBtnView addSubview:leftBtn];
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(ScreenWidth/2);
        }];
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.backgroundColor = [UIColor UIColorFormHexString:@"#FFFFFF"];
        [rightBtn setTitleColor:[UIColor UIColorFormHexString:@"#8A94A6"] forState:UIControlStateNormal];
        
        rightBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 10);
        rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        [rightBtn setTitle:@"继续" forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn setImage:[UIImage imageNamed:@"icon_continue"] forState:UIControlStateNormal];
        [_bottomBtnView addSubview:rightBtn];
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(ScreenWidth/2);
        }];
    }
    return _bottomBtnView;
}


- (UIView *)scrollBgView {
    if (!_scrollBgView) {
        _scrollBgView = [[UIView alloc] init];
        _scrollBgView.backgroundColor = [UIColor UIColorFormHexString:@"#FFFFFF"];
        _scrollBgView.layerCornerRadius = 16;
        _scrollBgView.clipsToBounds = YES;
    }
    return _scrollBgView;
}

- (UIProgressView *)bottomProgressView {
    if (!_bottomProgressView) {
        _bottomProgressView = [[UIProgressView alloc] init];
        _bottomProgressView.progressTintColor = RGBColor(34, 201, 147);
        _bottomProgressView.trackTintColor = [UIColor clearColor];
        _bottomProgressView.progressViewStyle = UIProgressViewStyleDefault;
        _bottomProgressView.progress = 1.0f;
    }
    return _bottomProgressView;
}


- (void)setSectionArray:(NSMutableArray *)sectionArray{
    _sectionArray = sectionArray;
    [self.bottomSecitonView setDataWithSections:self.sectionArray];
    for (NSInteger i = 0; i < self.allSecionsArray.count; i ++) {
        TAAIClassSectionModel *sectionModel = self.allSecionsArray[i];
        for (NSInteger j = 0; j < sectionModel.partList.count; j ++) {
            NSDictionary * part = sectionModel.partList[j];
            TAAIPartModel *partModel = [TAAIPartModel mj_objectWithKeyValues:part];
            [self.allParts addObject:partModel];
        }
    }
    self.topProgressView.dataArray = self.sectionArray;
    self.topProgressView.progress = 0;
}

- (TAAISectionView*)bottomSecitonView {
    if (!_bottomSecitonView) {
        _bottomSecitonView = [[TAAISectionView alloc] init];
        _bottomSecitonView.backgroundColor = [UIColor clearColor];
        _bottomSecitonView.delegate = self;
    }
    return _bottomSecitonView;
}

- (NSMutableArray *)allParts {
    if (!_allParts) {
        _allParts = [NSMutableArray new];
    }
    return _allParts;
}

- (UIScrollView*)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.userInteractionEnabled = YES;
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIView *)floatSingleLabel {
    if (_floatSingleLabel) {
        _floatSingleLabel = [[UILabel alloc] init];
        _floatSingleLabel.textColor = [UIColor UIColorFormHexString:@"#FFFFFF"];
        _floatSingleLabel.font = [UIFont systemFontOfSize:16];
        _floatSingleLabel.alpha = 0;
        _floatSingleLabel.textAlignment = NSTextAlignmentCenter;
        _floatSingleLabel.numberOfLines = 0;
    }
    return _floatSingleLabel;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor clearColor];
        _topView.clipsToBounds = YES;
        UIButton *backBtn = [[UIButton alloc] init];
        [backBtn addTarget:self action:@selector(popToPrevious:) forControlEvents:UIControlEventTouchUpInside];
        [backBtn setImage:[UIImage imageNamed:@"icon_ back"] forState:UIControlStateNormal];
        [backBtn setTitleColor:[UIColor blackColor]
                      forState:UIControlStateNormal];
        backBtn.tag = 100;
        [_topView addSubview:backBtn];
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(20);
            make.width.height.mas_equalTo(44);
        }];
        
        UIButton *hiddenBtn = [[UIButton alloc] init];
        hiddenBtn.tag = 101;
        [hiddenBtn addTarget:self action:@selector(popToPrevious:) forControlEvents:UIControlEventTouchUpInside];
        [hiddenBtn setImage:[UIImage imageNamed:@"英语"] forState:UIControlStateNormal];
        [hiddenBtn setTitleColor:[UIColor blackColor]
                        forState:UIControlStateNormal];
        self.subTitleBtn = hiddenBtn;
        [_topView addSubview:hiddenBtn];
        [hiddenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(22);
            make.right.mas_equalTo(-22);
            make.width.height.mas_equalTo(44);
        }];
    }
    return _topView;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
    }
    return _bgImageView;
}

- (TAAIFollowUpView *)followView{
    if (!_followView) {
        _followView = [[TAAIFollowUpView alloc] init];
        
    }
    return _followView;
}

- (TAAIProgressView *)topProgressView {
    if (!_topProgressView) {
        _topProgressView = [[TAAIProgressView alloc] init];
        _topProgressView.progressTintColor = RGBColor(255, 52, 103);
        _topProgressView.progressViewStyle = UIProgressViewStyleDefault;
    }
    return _topProgressView;
}

- (TAAIScoreImageView *)scroeImageView {
    if (!_scroeImageView) {
        _scroeImageView = [[TAAIScoreImageView alloc] init];
    }
    return _scroeImageView;
}

- (NSMutableDictionary *)Params {
    if (!_Params) {
        _Params = [NSMutableDictionary new];
    }
    return _Params;
}

- (NSMutableArray *)clienAnswerList {
    if (!_clienAnswerList) {
        _clienAnswerList = [[NSMutableArray alloc] init];
    }
    return  _clienAnswerList;
}

#pragma mark

- (void)removeUselessSubViews{
    [self.scrollBgView removeFromSuperview];
    self.scrollBgView = nil;
    
    [self.drawBtn removeFromSuperview];
    self.drawBtn = nil;
    
    [self.bottomProgressView removeFromSuperview];
    self.bottomProgressView = nil;
    [self.bottomBtnView removeFromSuperview];
    self.bottomBtnView = nil;
    [self.followView removeFromSuperview];
    self.followView = nil;
    
    [self.bottomTimer invalidate];
    self.bottomTimer = nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)dealloc{
    [self.bottomTimer invalidate];
    self.bottomTimer = nil;
    [self.videoPlayer destroy];
    [self.followView.btnView.bottomTimer invalidate];
    self.followView.btnView.bottomTimer = nil;
}

- (void)goback {
    [self.bottomTimer invalidate];
    self.bottomTimer = nil;
    [self.videoPlayer destroy];
}

-(BOOL)isIPhoneX{
    BOOL iPhoneX = NO;
    /// 先判断设备是否是iPhone/iPod
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneX;
    }
    if (@available(iOS 11.0, *)) {
        /// 利用safeAreaInsets.bottom > 0.0来判断是否是iPhone X。
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneX = YES;
        }
    }
    return iPhoneX;
}
@end
