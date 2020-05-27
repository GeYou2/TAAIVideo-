//
//  TAAIReportViewController.m
//  TutorABC
//
//  Created by 葛优 on 2020/5/17.
//  Copyright © 2020 Slark. All rights reserved.
//

#import "TAAINetWorkViewController.h"
#import <WebKit/WebKit.h>
#import "TAAIClassController.h"
#import "TAAIEpisodeDetailController.h"
@interface TAAINetWorkViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>
@property (nonatomic,strong)WKWebView* webView;
@property (nonatomic,strong)UIButton* nextBtn;
@property (nonatomic,strong)UIButton* orderBtn;
@property (nonatomic,assign)BOOL isBuy;
@property (nonatomic,copy)NSString *nextLessonId;
@end

@implementation TAAINetWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.url = @"http://192.168.1.150:5500/html/learnReport.html?token=b845088dd33c4be3bfe4a9016247b2e2o91v34Fk85889027244&lessonId=36&courseId=30";
  //  self.title = @"本课报告";
    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
//    [self.backBtn addTarget:self action:
//     @selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    if (self.needBackbtn) {
        //需要返回导航栏
        self.webView.frame = CGRectMake(0, GetRectNavAndStatusHight,
                                ScreenWidth, ScreenHeight-GetRectNavAndStatusHight);
        self.navTitleLable.text = self.title;
        //状态栏颜色回复默认黑色
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    if ([self.title isEqualToString:@"本课报告"]) {
        self.webView.frame = CGRectMake(0, 0,
                                ScreenWidth, ScreenHeight-BottomSafeAreaHeight-80);
        self.navTitleLable.text = self.title;
        //返回按钮
        [self.backBtn removeFromSuperview];
        [self.backBtn setImage:[UIImage imageNamed:@"icon_ back"] forState:normal];
        [self.view addSubview:self.backBtn];
        [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(BorderMargin);
            make.top.mas_equalTo(self.navigationController.navigationBar.frame.size.height/2-15+[[UIApplication sharedApplication] statusBarFrame].size.height);
            make.width.height.mas_equalTo(30);
        }];
        [self.navTitleLable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.navigationController.navigationBar.frame.size.height/2-15+[[UIApplication sharedApplication] statusBarFrame].size.height);
        }];
        self.navView.alpha = 0;
        //底部按钮
        for (int i=0; i<2; i++) {
            UIButton *btn = [[UIButton alloc] init];
            [btn setTitleColor:[UIColor whiteColor] forState:normal];
            btn.titleLabel.font = NormalFont;
            btn.layerCornerRadius = 20;
            [self.view addSubview:btn];
            if (i==0) {
                //下一集
                btn.layerBorderColor = TextGrayColor;
                btn.layerBorderWidth = 1;
                [btn setTitleColor:TextColor forState:normal];
                self.nextBtn = btn;
                
                [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(BorderMargin);
                    make.width.mas_equalTo((ScreenWidth-3*BorderMargin)/2);
                    if (@available(iOS 11.0, *)) {
                        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-20);
                    } else {
                        make.bottom.mas_equalTo(-20);
                    }
                    make.height.mas_equalTo(40);
                }];
            }else if (i==1){
                //去订课
                [btn setBackgroundImage:[UIImage imageNamed:@"Rectangle"] forState:normal];
                self.orderBtn = btn;
                [self.orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-BorderMargin);
                    make.top.width.height.equalTo(self.nextBtn);
                }];
            }
        }
        self.nextBtn.enabled = NO;
        self.orderBtn.enabled = NO;
    }
    //监听APP状态
       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - Action
- (void)clickToPop {
    if (self.needPopToDetail) {
       TAAIEpisodeDetailController *listViewController =self.navigationController.viewControllers[2];
        [self.navigationController popToViewController:listViewController animated:NO];
     
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)toOrder {
    NSLog(@"去订课");
}

- (void)nextClick {
    NSLog(@"下一集");
    TAAIClassController *classVC = [[TAAIClassController alloc] init];
    classVC.courseId = self.courseId;
    classVC.lessonId = self.nextLessonId;
    [self.navigationController pushViewController:classVC animated:YES];
}

- (void)buyClick {
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
#pragma mark - delegate
//页面加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self.view bringSubviewToFront:self.navView];
    self.navView.backgroundColor = [UIColor whiteColor];
    [self.view bringSubviewToFront:self.backBtn];
    if (self.needBackbtn) {
        //状态栏颜色回复默认黑色
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
}
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"JS的方法名%@",message.name);
//    NSLog(@"JS传递过来的内容%@",message.body);
     if ([message.name isEqualToString:@"startNextView"]){
        NSArray *arr = message.body;
        NSLog(@"获取到穿过来%@",arr);
        if ([arr[0] intValue] == -1) {
            self.nextLessonId = nil;
        }else {
            self.nextLessonId = arr[0];
        }
        if ([arr[1] intValue] == -1) {
            self.isBuy = nil;
        }else {
            self.isBuy = [arr[1] boolValue];
        }
        if (self.nextLessonId) {
            if (self.isBuy) {
                //已购课
                [self.nextBtn addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
                [self.nextBtn setTitle:@"下一集" forState:normal];
                [self.orderBtn setTitle:@"去订课" forState:normal];
                [self.orderBtn addTarget:self action:@selector(toOrder) forControlEvents:UIControlEventTouchUpInside];
            }else{

                //去购买，//去订课
                [self.nextBtn addTarget:self action:@selector(buyClick) forControlEvents:UIControlEventTouchUpInside];
                [self.nextBtn setTitle:@"去购买" forState:normal];
                [self.orderBtn setTitle:@"去订课" forState:normal];
                [self.orderBtn addTarget:self action:@selector(toOrder) forControlEvents:UIControlEventTouchUpInside];
            }

        }else{
            //            最后一课
            self.nextBtn.hidden = YES;
            [self.orderBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_offset(BorderMargin);
                make.width.mas_offset(ScreenWidth-2*BorderMargin);
            }];
            [self.orderBtn setTitle:@"去订课" forState:normal];
            [self.orderBtn addTarget:self action:@selector(toOrder) forControlEvents:UIControlEventTouchUpInside];
        }

        self.nextBtn.enabled = YES;
        self.orderBtn.enabled = YES;
    }else if ([message.name isEqualToString:@"scrollListener"]){
        
        CGFloat tempObj = [message.body intValue];
        NSLog(@"滚动到%lf",tempObj);
        //整个页面上下滑动视图
        if (tempObj<=150) {
            self.navView.alpha = tempObj/150.0;
            [self.backBtn setImage:[UIImage imageNamed:@"icon_ back"] forState:normal];
            //状态栏颜色白色
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        }else{
            self.navView.alpha = 1;
            [self.backBtn setImage:[UIImage imageNamed:@"Group"] forState:normal];
            //状态栏颜色回复默认黑色
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        }
    }
        
}
#pragma  mark - Lazy Load
- (WKWebView *)webView {
    if (!_webView) {
        // 设置偏好设置
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.preferences.minimumFontSize = 10;
        //  是否支持JavaScript
        config.preferences.javaScriptEnabled = YES;
        //   不通过用户交互，是否可以打开窗口
        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        //   是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
        config.allowsInlineMediaPlayback = YES;
        //   设置视频是否需要用户手动播放  设置为NO则会允许自动播放
        
        WKUserContentController *userCC = config.userContentController;
        [userCC addScriptMessageHandler:self name:@"startNextView"];
        [userCC addScriptMessageHandler:self name:@"scrollListener"];
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, ScreenHeight) configuration:config];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.allowsBackForwardNavigationGestures = YES;
        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
               }else {
                   self.automaticallyAdjustsScrollViewInsets = NO;
               }
    }
    return _webView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//app将杀死
- (void)appWillTerminate:(NSNotification *)notification {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"allow4G"];
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
