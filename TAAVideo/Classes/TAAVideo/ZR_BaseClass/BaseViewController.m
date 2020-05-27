//
//  BaseViewController.m
//  ios-2Block
//
//  Created by Slark on 17/1/12.
//  Copyright © 2017年 Slark. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()<TAAINoDataViewDelegate>

@property (nonatomic,strong)UIBarButtonItem* rightItem;

@end

@implementation BaseViewController

#pragma mark Life Cycle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    //隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
    //设置状态栏白色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //显示导航栏
    self.navigationController.navigationBarHidden=NO;
    //状态栏颜色回复默认黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNavigationBar];
    self.Hidden_BackTile = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
   // UINavigationBar.appearance.translucent = NO;
    [self loadData];
    self.view.backgroundColor=[UIColor whiteColor];
    //监听APP状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
    
    
}
#pragma mark - load View

- (void)loadNavigationBar{
    [self.view addSubview:self.navView];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(GetRectNavAndStatusHight);
    }];
    
    //返回按钮
    [self.navView addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(BorderMargin);
        make.top.mas_equalTo(self.navigationController.navigationBar.frame.size.height/2-15+[[UIApplication sharedApplication] statusBarFrame].size.height);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.navView addSubview:self.navTitleLable];
       [self.navTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
           make.width.mas_equalTo(ScreenWidth-2*30-20);
           make.centerX.equalTo(self.view);
           make.top.height.equalTo(self.backBtn);
       }];
}

#pragma mark - Fetch
- (void)loadData{
    
}

#pragma mark - Action
- (void)clickToPop {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark setter getter

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

- (void)setRightItemTitle:(NSString *)rightItemTitle{
    _rightItemTitle = rightItemTitle;
    UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithTitle:_rightItemTitle style:UIBarButtonItemStyleDone target:self action:@selector(rightClick)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)setRightItemImageName:(NSString *)rightItemImageName{
    _rightItemImageName = rightItemImageName;
   UIImage *rightImage = [[UIImage imageNamed:rightItemImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithImage:rightImage style:UIBarButtonItemStyleDone target:self action:@selector(rightClick)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)setLeftItemImageName:(NSString *)leftItemImageName{
    _leftItemImageName = leftItemImageName;
    UIImage *rightImage = [[UIImage imageNamed:leftItemImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithImage:rightImage style:UIBarButtonItemStyleDone target:self action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)leftClick{
    if (self.leftItemHandle) {
        self.leftItemHandle();
    }
}

- (void)setArrowColor:(UIColor *)arrowColor{
    _arrowColor = arrowColor;
    self.navigationController.navigationBar.tintColor = _arrowColor;
}

- (void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
     self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:_titleColor};
}

- (void)setBarColor:(UIColor *)barColor{
    _barColor = barColor;
    self.navigationController.navigationBar.barTintColor = _barColor;
}

- (void)rightClick{
    if (self.rightItemHandle) {
        self.rightItemHandle();
    }
}

- (void)pushVC:(UIViewController *)vc{
    if([vc isKindOfClass:[UIViewController class]] ==NO) return;
    if(self.navigationController ==nil) return;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pop{
    if (self.navigationController==nil) return;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)popToVc:(UIViewController *)vc{
    if ([vc isKindOfClass:[UIViewController class]] ==NO) return;
    if (self.navigationController==nil) return;
    [self.navigationController popToViewController:vc animated:YES];
}

- (void)popToRootVc{
    if (self.navigationController==nil) return;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)presentToVC:(UIViewController *)vc{
    if([vc isKindOfClass:[UIViewController class]]==NO) return;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)addchildVc:(UIViewController *)childVc{
    if([childVc isKindOfClass:[UIViewController class]] ==NO) return;
    [childVc willMoveToParentViewController:self];
    [self addChildViewController:childVc];
    [self.view addSubview:childVc.view];
}

- (void)removeChildVc:(UIViewController *)childVc{
    if([childVc isKindOfClass:[UIViewController class]] ==NO) return;
    [childVc.view removeFromSuperview];
    [childVc willMoveToParentViewController:nil];
    [childVc removeFromParentViewController];
    
}

- (void)setHidden_BackTile:(BOOL)Hidden_BackTile{
    _Hidden_BackTile = Hidden_BackTile;
    if (_Hidden_BackTile) {
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] init];
        backButtonItem.title = @"";
        self.navigationItem.backBarButtonItem = backButtonItem;
    }
}

- (void)OpenAlbumAlert{
    UIAlertController* alert = [[UIAlertController alloc]init];
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"我的相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark Lazy Load
-(UIView *)navView{
    if (!_navView) {
        _navView=[[UIView alloc]init];
    }
    return _navView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        [_backBtn setImage:[UIImage imageNamed:@"Group"] forState:normal];
        [_backBtn addTarget:self action:@selector(clickToPop) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

-(BoldLabel *)navTitleLable{
    if (!_navTitleLable) {
        _navTitleLable = [[BoldLabel alloc] init];
        _navTitleLable.textAlignment = NSTextAlignmentCenter;
        _navTitleLable.font = BigFont;
    }
    return _navTitleLable;
}

- (NSMutableArray*)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//app将杀死
- (void)appWillTerminate:(NSNotification *)notification {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"allow4G"];
}
- (void)refrash {
    
}
@end
