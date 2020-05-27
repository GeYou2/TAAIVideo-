//
//  TAAIEpisodeDetailController.m
//  TutorABC
//
//  Created by 葛优 on 2020/5/6.
//  Copyright © 2020 Slark. All rights reserved.
//

#import "TAAIEpisodeDetailController.h"
#import "TAAIDetailPreloadView.h"
#import "SRVideoPlayer.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVTime.h>
#import "TAAIEpisodeListController.h"
#import "TAAILearnListController.h"
#import "TAAICourseCoverView.h"
#import "TAAIEpisodeDetalModel.h"
#import "TAAIDetailCourseListModel.h"
#import "TAAIClassController.h"
#import "Reachability.h"
#import "TAAINetWorkViewController.h"
@interface TAAIEpisodeDetailController ()<UIScrollViewDelegate,SRVideoTopBarBarDelegate,SRVideoPlayerDelegate,TAAICourseCoverViewDelegate,ITGUserProtocol>

@property (nonatomic, strong) UIButton *introduceBtn;
@property (nonatomic, strong) SRVideoPlayer *videoPlayer;//视频播放器
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIScrollView *scrollView;//整体可滑动视图
@property (nonatomic, strong) UIView *topView;//头部(简介图、简介视频)
@property (nonatomic, strong) UIImageView *topVieoView;//视频
@property (nonatomic, strong) UIImageView *topImageView;//头部简介图
@property (nonatomic, strong) BoldLabel *courseTitleLabel;//课程标题
@property (nonatomic, strong) UILabel *subTitleLabel;//副标题
@property (nonatomic, strong) UIButton *levelView;//等级
@property (nonatomic, strong) UIImageView *personImage;//简介图中的人物图
@property (nonatomic, strong) UIView *introduceVIew;//课程简介视图
@property (nonatomic, strong) TAAIDetailPreloadView *preloadView;//预加载视图
@property (nonatomic, strong) UILabel *courseIntroduceLabel;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UILabel *progressL;//学习进度
@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) UILabel *targetL;//学习目标
@property (nonatomic, strong) BoldLabel *contentLabel;
@property (nonatomic, strong) UILabel *contentL;//课程内容
@property (nonatomic, strong) UIButton *tryBtn;//免费试读按钮
@property (nonatomic, strong) UIButton *buyBtn;//立即购买按钮
@property (nonatomic, strong) UIImageView *buyIcon;
@property (nonatomic, strong) UIButton *continueBtn;//继续学习按钮
@property (nonatomic, strong) NSMutableArray *courseArray;//图片数组
@property (nonatomic, strong) UIScrollView *courseListView;//横向滑动课程列表
@property (nonatomic, strong) UIImageView *selectIconView;
@property (nonatomic, strong) UIImageView *bottomImageView;//底部图片
@property (nonatomic, strong) TAAIEpisodeDetalModel *model;
@property (nonatomic, strong) TAAIDetailCourseListModel *currntCourse;//课程列表当前选中课程
@end

@implementation TAAIEpisodeDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadViews];
    //隐藏导航栏
    self.navigationController.navigationBarHidden=YES;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self fetchData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.videoPlayer destroy];
}
#pragma mark - Load View
- (void)loadViews {
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(@0);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-80);
        } else {
            make.bottom.equalTo(@-80);
        }
    }];
    
    //顶部视图
    [self.scrollView addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@0);
        make.width.equalTo(self.scrollView);
        make.height.mas_equalTo(GetRectNavAndStatusHight +190);
    }];
    
    //顶部简介图
    [self.topView addSubview:self.topImageView];
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(@0);
    }];
    //标题
    [self.topImageView addSubview:self.courseTitleLabel];
    [self.courseTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@BorderMargin);
        make.top.equalTo(self.topImageView).offset(GetRectNavAndStatusHight+10);
        make.height.mas_equalTo(45);
        make.width.mas_equalTo((ScreenWidth-2*BorderMargin-120));
    }];
    //副标题
    [self.topImageView addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@BorderMargin);
        make.top.equalTo(self.courseTitleLabel.mas_bottom).offset(0);
//        make.height.mas_equalTo(30);
        make.width.equalTo(self.courseTitleLabel);
    }];
    //等级
    [self.topImageView addSubview:self.levelView];
    [self.levelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@BorderMargin);
        make.top.equalTo(self.subTitleLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(45);
    }];

    
    //课程简介按钮
    [self.topImageView addSubview:self.introduceBtn];
    [self.introduceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@BorderMargin);
        make.bottom.equalTo(@-45);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(18);
    }];
    _introduceBtn.layer.cornerRadius=9;
    
    //顶部视频
    [self.topView addSubview:self.topVieoView];
    [self.topVieoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.equalTo(self.topView);
        make.height.equalTo(self.topView).offset(-10);
    }];
    _videoPlayer = [SRVideoPlayer playerWithPlayerView:self.topVieoView playerSuperView:self.topVieoView.superview ];
    _videoPlayer.isDetailPlayer = 1;
    _videoPlayer.delegate=self;
    self.videoPlayer.playerView.hidden =YES;
    //是否循环播放
    _videoPlayer.playerEndAction = SRVideoPlayerEndActionStop;
    
    //课程内容简介
    self.introduceVIew.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.introduceVIew];
    [self.introduceVIew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.scrollView);
        make.top.equalTo(self.topView.mas_bottom).offset(-30);
        make.bottom.equalTo(self.scrollView).offset(-20);
    //高度自适应，由子view的高度决定。此处切勿设置高度约束。
    }];
    
    //课程
    BoldLabel *courseLabel = [[BoldLabel alloc] init];
    courseLabel.text =@"课程";
    [self.introduceVIew addSubview:courseLabel];
    [courseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@BorderMargin);
        make.top.equalTo(@30);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
    }];
    
    UIButton *courseIntroduceBtn = [[UIButton alloc] init];
    [self.introduceVIew addSubview:courseIntroduceBtn];
    [courseIntroduceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(courseLabel.mas_right).offset(10);
        make.top.height.equalTo(courseLabel);
        make.right.mas_equalTo(-BorderMargin);
    }];
    
    [courseIntroduceBtn addSubview:self.courseIntroduceLabel];
    [courseIntroduceBtn addTarget:self action:@selector(toLessonList) forControlEvents:UIControlEventTouchUpInside];
    [self.courseIntroduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@0);
        make.right.mas_equalTo(-16);
        make.height.equalTo(courseIntroduceBtn);
    }];
    
    UIImageView *courseIntroduceBtnIcon = [[UIImageView alloc] init];
    courseIntroduceBtnIcon.image=[UIImage imageNamed:@"arrow"];
    [courseIntroduceBtn addSubview:courseIntroduceBtnIcon];
    [courseIntroduceBtnIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0);
        make.top.equalTo(@7.5);
        make.width.height.mas_equalTo(15);
    }];
    
    //课程列表
    [self.introduceVIew addSubview:self.courseListView];
    [self.courseListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(courseLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(190);
        make.width.equalTo(self.scrollView);
    }];
    
    //学习进度
    BoldLabel *progressLabel = [[BoldLabel alloc] init];
    progressLabel.text =@"学习进度";
    [self.introduceVIew addSubview:progressLabel];
    [progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(courseLabel);
        make.top.equalTo(self.courseListView.mas_bottom).offset(20);
        make.width.mas_equalTo(80);
        
    }];
    
    //学习进度条
    [self.introduceVIew addSubview:self.progressView];
    self.progressView.layer.cornerRadius = 3;
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(progressLabel);
        make.right.equalTo(@-BorderMargin);
        make.top.equalTo(progressLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(6);
    }];
    
    [self.introduceVIew addSubview:self.progressL];
    [self.progressL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(progressLabel.mas_left);
        make.top.equalTo(self.progressView.mas_bottom).offset(5);
        make.height.equalTo(progressLabel);
    }];
    
    [self.introduceVIew addSubview:self.totalLabel];
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-BorderMargin);
        make.top.height.equalTo(self.progressL);
    }];
    
    //学习目标
    BoldLabel *targetLabel = [[BoldLabel alloc] init];
    targetLabel.text =@"学习目标";
    [self.introduceVIew addSubview:targetLabel];
    [targetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(courseLabel);
        make.width.equalTo(progressLabel);
        make.top.equalTo(self.progressL.mas_bottom).offset(20);
        make.height.equalTo(courseLabel);
    }];
    
    [self.introduceVIew addSubview:self.targetL];
    [self.targetL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.progressView);
        make.top.equalTo(targetLabel.mas_bottom);
    }];
    
    //课程内容
    [self.introduceVIew addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.height.equalTo(targetLabel);
        make.top.equalTo(self.targetL.mas_bottom).offset(10);
    }];
    
    [self.introduceVIew addSubview:self.contentL];
    [self.contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(targetLabel);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
        make.width.equalTo(self.targetL);
    }];
    
    [self.introduceVIew addSubview:self.bottomImageView];
    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.introduceVIew);
        make.width.mas_equalTo(ScreenWidth-2*BorderMargin);
        make.top.equalTo(self.contentL.mas_bottom).offset(20);
        //用于撑开container。注意不要设置container高度相关的约束。
        make.bottom.equalTo(self.introduceVIew).offset(-10);
    }];
    //底部分割线
    UIView *bottomLine = [[UIView alloc] init];
    [self.view addSubview:bottomLine];
    bottomLine.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:241.0/255.0 blue:242.0/255.0 alpha:1];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.mas_equalTo(3);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-77);
        } else {
             make.bottom.equalTo(@-77);
        }
    }];
    //设置阴影
    bottomLine.layer.shadowColor = [UIColor colorWithRed:240.0/255.0 green:241.0/255.0 blue:242.0/255.0 alpha:1].CGColor;//shadowColor阴影颜色
    bottomLine.layer.shadowOffset = CGSizeMake(0,-3);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    bottomLine.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    bottomLine.layer.shadowRadius = 1;//阴影半径，默认3
    //底部按钮
    for (int i=0; i<3; i++) {
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitleColor:[UIColor whiteColor] forState:normal];
        btn.titleLabel.font = NormalFont;
        btn.layerCornerRadius = 20;
        [self.view addSubview:btn];
        if (i==0) {
            //免费试学
            btn.layerBorderColor = TextGrayColor;
            btn.layerBorderWidth = 1;
            [btn setTitleColor:TextColor forState:normal];
            self.tryBtn = btn;
            [self.tryBtn addTarget:self action:@selector(tryClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.tryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(courseLabel);
                make.width.mas_equalTo((ScreenWidth-3*BorderMargin)/2);
                if (@available(iOS 11.0, *)) {
                    make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-20);
                } else {
                    make.bottom.mas_equalTo(-20);
                }
                make.height.mas_equalTo(40);
            }];
        }else if (i==1){
            //立即购课
            [btn setBackgroundImage:[UIImage imageNamed:@"Rectangle"] forState:normal];
            self.buyBtn = btn;
            [self.buyBtn addTarget:self action:@selector(toBuy) forControlEvents:UIControlEventTouchUpInside];
            [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(@-BorderMargin);
                make.top.width.height.equalTo(self.tryBtn);
            }];
        }else if (i==2){
            //继续学习
            [btn setBackgroundImage:[UIImage imageNamed:@"Rectangle"] forState:normal];
            [btn setTitle:@"继续学习" forState:normal];
            self.continueBtn = btn;
            self.continueBtn.hidden=YES;
            [self.continueBtn addTarget:self action:@selector(continueToCourse) forControlEvents:UIControlEventTouchUpInside];
            [self.continueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.equalTo(self.tryBtn);
                make.right.equalTo(@-BorderMargin);
                make.height.mas_equalTo(40);
            }];
        }
    }
    self.buyBtn.enabled = NO;
    self.tryBtn.enabled = NO;
    [self.view bringSubviewToFront:self.navView];
    //返回按钮
    [self.backBtn removeFromSuperview];
    [self.backBtn setImage:[UIImage imageNamed:@"icon_ back"] forState:normal];
    [self.view addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@BorderMargin);
        make.top.equalTo(self.view).offset(self.navigationController.navigationBar.frame.size.height/2-15+[[UIApplication sharedApplication] statusBarFrame].size.height);
        make.width.height.mas_equalTo(30);
    }];
    [self.navTitleLable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navigationController.navigationBar.frame.size.height/2-15+[[UIApplication sharedApplication] statusBarFrame].size.height);
    }];
    self.topView.backgroundColor = PreLoadVIewColor;
    self.navView.backgroundColor = PreLoadVIewColor;
    [self setLayerMask];
    
    [self.scrollView addSubview:self.preloadView];
    [self.preloadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.introduceVIew);
        make.width.height.mas_equalTo(self.introduceVIew);
    }];
}

- (void)loadCourseListView {
    for (UIView *view in [self.courseListView subviews]) {
        [view removeFromSuperview];
    }
    NSMutableArray *courseViews = [NSMutableArray array];
    for (int i=0; i<self.courseArray.count; i++) {
        TAAICourseCoverView *coverView = [[TAAICourseCoverView alloc] init];
        coverView.delegate =self;
        coverView.tag = i;
        [coverView fetchDataWithImages:self.courseArray[i]];
        [courseViews addObject:coverView];
    }
    
    UIView * contenview = [UIView new];
    [self.courseListView addSubview:contenview];
    [contenview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo (self.courseListView);
        make.height.equalTo (self.courseListView); //此处没有设置宽的约束
    }];
        //关于这个延迟 因为masory创建约束之后 获取的frame 是（0，0，0，0）但是有一个延迟的话 才能获取真是的view的大小  延迟时间改成0 也可以
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            NSLog(@"******%@",contenview);
        });

        UIView * lastView ;
        for (int i = 0; i < courseViews.count ; i++) {
            UIView * view = courseViews[i];
            [contenview addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo (contenview.mas_top);
                make.bottom.mas_equalTo(0);
                make.left.equalTo(lastView ? lastView.mas_right: @0).offset(15);
                make.width.mas_equalTo (120);
            }];
            
            lastView = view;
      }

        [contenview mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(lastView.mas_right);
        }];
    [self.courseListView layoutIfNeeded];
    self.courseListView.contentSize = CGSizeMake(self.courseListView.width+
                                                 (self.courseArray.count-1)*135, 190);
    [self.courseListView.superview addSubview:self.selectIconView];
    self.selectIconView.image = [UIImage imageNamed:@"编组 5"];
    [self.selectIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(14);
        make.left.mas_equalTo(BorderMargin+53);
        make.bottom.equalTo(self.courseListView).offset(-4);
    }];
}

#pragma mark - Fetch
- (void)fetchData {
    //请求
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:ClientId forKey:@"clientId"];
    [dict setValue:self.courseId forKey:@"courseId"];
  
    ZR_Request *getRequest = [ZR_Request cc_requestWithUrl:@"business/courseDescription" isPost:NO Params:dict];
    __weak typeof(self) weakSelf = self;
    [getRequest cc_sendRequstWith:^(NSDictionary *jsonDic) {
        weakSelf.model = [TAAIEpisodeDetalModel mj_objectWithKeyValues:
                                        [jsonDic objectForKey:@"data"]];
        weakSelf.preloadView.hidden = YES;
        weakSelf.buyBtn.enabled = YES;
        weakSelf.tryBtn.enabled = YES;
        weakSelf.levelView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
        weakSelf.navView.backgroundColor = [UIColor whiteColor];
        weakSelf.navView.alpha = 0;
        weakSelf.navTitleLable.text = weakSelf.model.title;
        weakSelf.introduceBtn.hidden = NO;
        weakSelf.scrollView.delegate = self;
        [weakSelf.tryBtn setTitle:@"免费试学" forState:normal];
        [weakSelf.buyBtn setTitle:@"立即购课" forState:normal];
        //顶部图片
        [weakSelf.topImageView sd_setImageWithURL:[NSURL URLWithString:weakSelf.model.detailsImage]];
        weakSelf.courseTitleLabel.text = weakSelf.model.title;
        weakSelf.subTitleLabel.text  = weakSelf.model.subtitle;
        [weakSelf.levelView setTitle:[NSString stringWithFormat:@"等级%@",weakSelf.model.level] forState:normal];
            weakSelf.personImage.backgroundColor=[UIColor yellowColor];
            //顶部视频
        if (weakSelf.model.detailsVideo.length>0) {
            weakSelf.videoPlayer.videoURL = [NSURL URLWithString:weakSelf.model.detailsVideo] ;
            weakSelf.videoPlayer.titleLabel.text = weakSelf.model.title;
            //播放视频
            [self.topVieoView setImage:
             [self getVideoPreViewImage:[NSURL URLWithString:weakSelf.model.detailsVideo]]];
            [self toPlayVideo:self.introduceBtn];
        }
            //课程列表
        if (weakSelf.model.lessonList&&weakSelf.model.lessonList.count>0) {
             [weakSelf.courseArray removeAllObjects];
             [weakSelf.courseArray addObjectsFromArray:weakSelf.model.lessonList];
             [weakSelf loadCourseListView];
            
        }
        CGFloat lessonCount = [weakSelf.model.lessonCount floatValue];
        CGFloat finishLessonCount = [weakSelf.model.finishLessonCount floatValue];
        NSLog(@"进度是:%lf",finishLessonCount/lessonCount);
        weakSelf.progressView.progress = finishLessonCount/lessonCount;
            
        weakSelf.courseIntroduceLabel.text = weakSelf.model.ai_description;
        weakSelf.progressL.text = [NSString stringWithFormat:@"已学习%@节课",weakSelf.model.finishLessonCount];
        weakSelf.totalLabel.text = [NSString stringWithFormat:@"总共%@节AI互动课",weakSelf.model.lessonCount];
        NSString *target = weakSelf.model.target;

            weakSelf.targetL.text = target;
        NSString *content = weakSelf.model.content;
            weakSelf.contentL.text = content;
         
        [weakSelf reLoadBottomBtn];
        
        if (weakSelf.model.footerDetailsUrl.length>0) {
             
            NSURL * url = [NSURL URLWithString:weakSelf.model.footerDetailsUrl];
            [weakSelf.bottomImageView sd_setImageWithURL:url];
        }
        //底部图片是自适应的，这里给到scrollView高度
        [self.introduceVIew mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.scrollView.contentSize.height);
        }];
            //页面根据数据自适应完成后再给右上角切圆角
            [weakSelf setLayerMask];
    } failCompletion:^(NSString *eeror) {
        
    } WithString:@"加载中"];
    
    
}
#pragma mark - Action
- (void)reLoadBottomBtn {
//    if ([self.model.isBuy intValue]==0) {
//            //未购买
//            if ([self.currntCourse.isFree intValue] == 1) {
//                //当前选择的课程是免费的
                self.continueBtn.hidden=YES;
                self.tryBtn.hidden=NO;
                self.buyBtn.hidden=NO;
//            }else{
//                self.tryBtn.hidden=YES;
//                self.buyBtn.hidden=YES;
//                self.continueBtn.hidden=NO;
//                [self.continueBtn setTitle:@"立即购课" forState:normal];
//            }
//        }else{
//            //已购买，继续学习
//            self.tryBtn.hidden=YES;
//            self.buyBtn.hidden=YES;
//            self.continueBtn.hidden=NO;
//            if ([self.currntCourse.studyStatus intValue] == 2){
//                   //学习完成 点击去订课
//                [self.continueBtn setTitle:@"去订课" forState:normal];
//            }else{
//                   //学习中和待挑战  点击继续学习
//                [self.continueBtn setTitle:@"继续学习" forState:normal];
//            }
//        }
}
- (void)toLessonList {
    
    TAAIEpisodeListController *listVC = [[TAAIEpisodeListController alloc] init];
    listVC.lessons = self.courseArray;
    listVC.courseId = self.courseId;
    listVC.detailModel = self.model;
    [self.navigationController pushViewController:listVC animated:YES];

}
- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)toPlayVideo:(UIButton *)btn {
    self.videoPlayer.playerView.hidden =NO;
    [self.videoPlayer play];
    self.topImageView.hidden = YES;
}

- (void)showTopImageView {
    self.videoPlayer.playerView.hidden =YES;
    self.topImageView.hidden = NO;
}
- (void)tryClick:(UIButton *)btn{
//    NSLog(@"免费试学");
    if (!self.currntCourse) {
        self.currntCourse = self.model.lessonList[0];
    }
    if ((![self.currntCourse.isBuy boolValue]) && (![self.currntCourse.isFree boolValue])) {
        //未购买且不是免费的
        return;
    }
    if ([self getIsLogin]) {
        TAAIClassController *classVC = [[TAAIClassController alloc] init];
        classVC.courseId = self.courseId;
        classVC.lessonId = self.currntCourse.lessonId;
        [self.navigationController pushViewController:classVC animated:YES];
    }else {
        //去登录页面
    }
    
}

- (void)toBuy{
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

- (void)continueToCourse {
    if ([self.model.isBuy intValue] == 0) {
        //未购买且不免费 点击立即购课
        [self toBuy];
    }else{
        //已购买
        if ([self.currntCourse.studyStatus intValue] == 2) {
            //已完成 点击去订课
        }else {
            //继续学习
            TAAIClassController *classVC = [[TAAIClassController alloc] init];
            classVC.courseId = self.courseId;
            classVC.lessonId = self.currntCourse.lessonId;
            [self.navigationController pushViewController:classVC animated:YES];
        }
        
    }
}
//设置简介视图左上圆角
- (void)setLayerMask{
    [self.introduceVIew layoutIfNeeded];
    UIRectCorner rectCorner = UIRectCornerTopLeft ;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.introduceVIew.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    self.introduceVIew.layer.mask = shapeLayer;
}

- (BOOL) getIsLogin {
    BOOL isLoagin = NO;
    //判断是否登录
    if ([NSString nullToString:[self getToken]].length>0) {
        isLoagin = YES;
    }
    return isLoagin;
}

// 获取视频第一帧
- (UIImage*) getVideoPreViewImage:(NSURL *)path
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}

#pragma mark - Delegate
- (void)refrash {
    //没有网络的页面点击刷新调用
    self.navView.backgroundColor = [UIColor grayColor];
    [self.backBtn setImage:[UIImage imageNamed:@"icon_ back"] forState:normal];
    [self fetchData];
}
- (nullable NSString *)getToken {
    return tempToken;
}

- (void)chooseCourse:(NSInteger)courseIndex {
    TAAIDetailCourseListModel *model = self.courseArray[courseIndex];
    if ([self.model.isBuy intValue] == 0 && [model.isFree intValue] == 0) {
        //未购买且不免费
        [self toBuy];
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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    int contentOffsety = scrollView.contentOffset.y;
    if (scrollView.tag == 1) {
        //整个页面上下滑动视图
        if (scrollView.contentOffset.y<=150) {
            self.navView.alpha = scrollView.contentOffset.y/150;
            [self.backBtn setImage:[UIImage imageNamed:@"icon_ back"] forState:normal];
            //状态栏颜色白色
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        }else{
            self.navView.alpha = 1;
            [self.backBtn setImage:[UIImage imageNamed:@"Group"] forState:normal];
            //状态栏颜色回复默认黑色
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        }
    }else if (scrollView.tag == 2){
        self.selectIconView.hidden = YES;
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        BOOL dragToDragStop = scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
        if (dragToDragStop) {
            [self setCourseListOffset];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
        BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
            if (scrollToScrollStop) {
                if (scrollView.tag == 2) {
                    //课程列表横向滑动列表
                    [self setCourseListOffset];
                }
            }
}

- (void)setCourseListOffset {
    NSInteger offsetx = round(self.courseListView.contentOffset.x / 135);
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.courseListView.contentOffset = CGPointMake(offsetx*135, 0);
        weakSelf.currntCourse = weakSelf.model.lessonList[offsetx];
        NSLog(@"当前选中%@",weakSelf.currntCourse.ai_description);
    }completion:^(BOOL finished) {
        self.selectIconView.hidden = NO;
        [self reLoadBottomBtn];
    }];
}

- (void)videoPlayerTopBarDidClickCloseBtn {
//    视频返回
    [self goBack];
}

- (void)videoPlayerTopBarDidClickDownloadBtn{
    
}
//视频播放结束
- (void)videoPlayerDidPlayEnd {
    [self showTopImageView];
}
//视频切换全屏
- (void)changeScreenOrientationWithIsFullScreen:(BOOL)isFull isRate:(CGFloat)rate{
    if (!isFull)  {
        if (rate == 0) {
            //当前正在暂停显示图片
            [self showTopImageView];
        }
        
        [UIApplication sharedApplication].statusBarHidden = NO;
    }else{
        [UIApplication sharedApplication].statusBarHidden = YES;
    }
}
//视频暂停
- (void)videoPlayerDidPause:(SRVideoPlayer *)videoPlayer {
        [self showTopImageView];
}
#pragma mark - UITableViewDelegate

#pragma mark - OtherDelegate

#pragma mark - Lazy Load
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.tag = 1;
        _scrollView.showsVerticalScrollIndicator = NO;
        //解决scrollView子视图顶部空出状态栏高度问题
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _scrollView;
}

-(UIButton *)introduceBtn {
    if (!_introduceBtn) {
        _introduceBtn = [[UIButton alloc] init];
        _introduceBtn.hidden=YES;
        _introduceBtn.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
        _introduceBtn.layerCornerRadius = _introduceBtn.height/2;
        [_introduceBtn addTarget:self action:@selector(toPlayVideo:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *icon = [[UIImageView alloc] init];
        [_introduceBtn addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5);
            make.centerY.mas_equalTo(0);
            make.width.height.mas_equalTo(10);
        }];
        icon.image = [UIImage imageNamed:@"播放"];

        UILabel *playLabel = [[UILabel alloc] init];
        [_introduceBtn addSubview:playLabel];
        [playLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(icon.mas_right).offset(2);
            make.right.mas_equalTo(0);
            make.top.bottom.mas_equalTo(0);
        }];
        playLabel.textColor = [UIColor whiteColor];
        playLabel.font=[UIFont systemFontOfSize:10];
        playLabel.text = @"课程介绍";
    }
    return _introduceBtn;
}
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIImageView alloc] init];
        _topView.userInteractionEnabled=YES;
    }
    return _topView;
}

- (UIImageView *)topVieoView {
    if (!_topVieoView) {
        _topVieoView = [[UIImageView alloc] init];
    }
    return _topVieoView;
}

- (UIImageView *)topImageView {
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] init];
        _topImageView.userInteractionEnabled=YES;
    }
    return _topImageView;;
}

- (BoldLabel *)courseTitleLabel {
    if (!_courseTitleLabel) {
        _courseTitleLabel = [[BoldLabel alloc] init];
        _courseTitleLabel.textColor = [UIColor whiteColor];
        _courseTitleLabel.font =[UIFont boldSystemFontOfSize:35];
    }
    return _courseTitleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.textColor = [UIColor whiteColor];
        _subTitleLabel.font =SmallFont;
        _targetL.preferredMaxLayoutWidth = ScreenWidth-2*BorderMargin-120;//给一个maxWidth
               [_targetL setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];//设置huggingPriority
        _subTitleLabel.numberOfLines = 2;
    }
    return _subTitleLabel;
}

- (UIButton *)levelView {
    if (!_levelView) {
        _levelView = [[UIButton alloc] init];
        _levelView.enabled = NO;
        _levelView.titleLabel.font = [UIFont systemFontOfSize:10];
        [_levelView setTitleColor:[UIColor whiteColor] forState:normal];
    }
    return _levelView;
}
- (UIImageView *)personImage {
    if (!_personImage) {
        _personImage = [[UIImageView alloc] init];
    }
    return _personImage;
}

- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [[UIButton alloc] init];
        [_shareBtn setImage:[UIImage imageNamed:@"icon_share"] forState:normal];
    }
    return _shareBtn;
}

- (UIView *)introduceVIew {
    if (!_introduceVIew) {
        _introduceVIew = [[UIView alloc] init];
    }
    return _introduceVIew;
}

- (UIView *)preloadView {
    if (!_preloadView) {
        _preloadView = [[TAAIDetailPreloadView alloc] init];
    }
    return _preloadView;
}

- (UILabel *)courseIntroduceLabel {
    if (!_courseIntroduceLabel) {
        _courseIntroduceLabel = [[UILabel alloc] init];
        _courseIntroduceLabel.textAlignment=NSTextAlignmentRight;
        _courseIntroduceLabel.textColor = TextGrayColor;
        _courseIntroduceLabel.font=MiniFont;
    }
    return _courseIntroduceLabel;
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

- (UILabel *)progressL {
    if (!_progressL) {
        _progressL = [[UILabel alloc] init];
        _progressL.textColor = TextLightGrayColor;
        _progressL.font = MiniFont;
        [_progressL setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _progressL;
}

- (UILabel *)totalLabel {
    if (!_totalLabel) {
        _totalLabel = [[UILabel alloc] init];
        _totalLabel.textColor = TextLightGrayColor;
        _totalLabel.font = MiniFont;
        _totalLabel.textAlignment = NSTextAlignmentRight;
        [_totalLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _totalLabel;
}

- (UILabel *)targetL {
    if (!_targetL) {
        _targetL = [[UILabel alloc] init];
        _targetL.textColor = TextGrayColor;
        _targetL.font = SmallFont;
        _targetL.text = @"\n\n\n\n";
//        _targetL.backgroundColor = TextGrayColor;
        _targetL.preferredMaxLayoutWidth = ScreenWidth-2*BorderMargin-10;//给一个maxWidth
        [_targetL setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];//设置huggingPriority
        _targetL.numberOfLines = 0;
    }
    return _targetL;
}

- (BoldLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[BoldLabel alloc] init];
        _contentLabel.text = @"课程内容";
    }
    return _contentLabel;;
}

- (UILabel *)contentL {
    if (!_contentL) {
        _contentL = [[UILabel alloc] init];
        _contentL.textColor = TextGrayColor;
        _contentL.font = SmallFont;
        _contentL.text = @"\n";
        _contentL.preferredMaxLayoutWidth = ScreenWidth-2*BorderMargin-10;//给一个maxWidth
        [_contentL setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];//设置huggingPriority
        _contentL.numberOfLines = 0;
    }
    return _contentL;
}

- (NSMutableArray *)courseArray {
    if (_courseArray == nil) {
        _courseArray = [NSMutableArray array];
    }
    return _courseArray;
}

- (UIScrollView *)courseListView{
    if (!_courseListView) {
        _courseListView = [[UIScrollView alloc] init];
        _courseListView.delegate = self;
        _courseListView.showsHorizontalScrollIndicator = NO;
        _courseListView.tag = 2;
    }
    return _courseListView;
}

- (UIImageView *)selectIconView {
    if (_selectIconView == nil) {
        _selectIconView = [[UIImageView alloc] init];
        _selectIconView.userInteractionEnabled=YES;
    }
    return _selectIconView;
}

- (UIImageView *)bottomImageView {
    if (!_bottomImageView) {
        _bottomImageView = [[UIImageView alloc] init];
    }
    return _bottomImageView;
}

- (void)dealloc{
    [self.videoPlayer destroy];
    [self.videoPlayer.playerView removeFromSuperview];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
