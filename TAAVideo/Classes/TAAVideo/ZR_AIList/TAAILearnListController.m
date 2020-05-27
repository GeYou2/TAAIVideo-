//
//  TAAILearnListController.m
//  TutorABC
//
//  Created by Slark on 2020/5/7.
//  Copyright © 2020 Slark. All rights reserved.
//

#import "TAAILearnListController.h"
#import "TAAILearnListCell.h"
#import "TAAILearnBottomCell.h"
#import "TAAIClassController.h"
#import "TAAIEpisodeDetailController.h"
#import "TAAILearnListBannerModel.h"
#import "TAAILearnListModel.h"
#import "TAAINetWorkViewController.h"
#import "TAAINetWorkViewController.h"
#import "TAAIProtocol.h"
@interface TAAILearnListController ()<UITableViewDelegate,
UITableViewDataSource,
TAAIClientDelegate,
TAAINoDataViewDelegate>
@property (nonatomic, strong) TAAINoDataView *noDataView;//无网络状态默认图
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) TAAILearnListBannerModel *learnModel;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation TAAILearnListController

#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.arrowColor = RGBColor(20, 49, 83);
    _noDataView.hidden = YES;
    //监听无网络状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNoDataView) name:@"noNet" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"noNet" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"AI 互动学习";
    self.view.clipsToBounds = YES;
    self.dataArray = [NSMutableArray array];
    //设置背景色
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:242/255.0 blue:244/255.0 alpha:1.0];
    //添加tableView到页面
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if ([self isIPhoneX]) {
            make.top.equalTo(@108);
        }else{
            make.top.equalTo(@84);
        }
        make.left.equalTo(@18);
        make.right.equalTo(@-18);
        make.bottom.equalTo(@0);
    }];
    self.currentPage = 1;
    
    MJRefreshStateHeader *headr = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
    headr.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = headr;
    
     MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
       [footer setTitle:@"已加载全部数据" forState:MJRefreshStateIdle];
       self.tableView.mj_footer = footer;
    [self fetchData];
}

- (void)headRefresh {
     self.currentPage = 1;
    self.tableView.allowsSelection = NO;
    [self.dataArray removeAllObjects];
    [self fetchData];
}

- (void)footRefresh {
     self.currentPage +=1;
     [self fetchData];
}

- (void)dealloc {
    
}

#pragma mark - Fetch
- (void)fetchData {
    //PAD
    NSString * channel = @"";
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        NSLog(@"iPhone");
        channel = @"APP";
    }else{
        NSLog(@"iPad");
        channel = @"PAD";
    }
    NSDictionary *params = @{@"current":@(self.currentPage),
                             @"size":@"10",
                             @"channel":@"APP",
                             @"courseType":@"CLASS"
    };
    __weak typeof(self) weakSelf = self;
    ZR_Request *request = [ZR_Request cc_requestWithUrl:@"business/coursePage" isPost:NO Params:params];
    [request cc_sendRequstWith:^(NSDictionary *jsonDic) {
        weakSelf.learnModel = [TAAILearnListBannerModel mj_objectWithKeyValues:jsonDic[@"data"]];
        NSArray *jsonArray = jsonDic[@"data"][@"courseInfoList"];
        for (NSDictionary * dict in jsonArray) {
            TAAILearnListModel * listModel = [TAAILearnListModel mj_objectWithKeyValues:dict];
                [weakSelf.dataArray addObject:listModel];
        }
        self.tableView.hidden = NO;
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        self.tableView.allowsSelection = YES;
    } failCompletion:^(NSString *eerorString) {
        [self.tableView reloadData];
        self.tableView.hidden = YES;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } WithString:@""];

}

- (void)fetchMoreData{
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.learnModel.isOpen intValue] == 1) {
        if (self.dataArray.count != 0) {
              return self.dataArray.count+1;
        }
    }else {
        return self.dataArray.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.learnModel.isOpen intValue] == 1 && indexPath.row == self.dataArray.count)
    {
        return 100;
    }else {
        return 283;
    }
}

#pragma mark - UITableViewDelegate
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.learnModel.isOpen intValue] == 1 && indexPath.row == self.dataArray.count) {
        TAAILearnBottomCell *bottomCell = [[TAAILearnBottomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        [bottomCell fetchDataWithModel:self.learnModel];
        return bottomCell;
    }else {
        TAAILearnListCell *cell = [[TAAILearnListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"aaa"];
        TAAILearnListModel * model = self.dataArray[indexPath.row];
        [cell loadDataFromModel:model];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"AI 互动学习");
    if ([self.learnModel.isOpen intValue] == 1 && indexPath.row == self.dataArray.count) {
        //底部banner
        if ([NSString nullToString:self.learnModel.bannerLink].length > 0) {
            if ([NSString nullToString:self.learnModel.bannerLink].length > 0) {
                TAAINetWorkViewController *netVC = [[TAAINetWorkViewController alloc] init];
                netVC.needBackbtn = YES;
                netVC.title = @"介绍";
                netVC.url = self.learnModel.bannerLink;
                [self.navigationController pushViewController:netVC animated:YES];
            }
        }
    }else {
        TAAILearnListModel * model = self.dataArray[indexPath.row];
        TAAIEpisodeDetailController * class = [[TAAIEpisodeDetailController alloc] init];
        class.courseId = model.courseId;
        [self pushVC: class];
    }
    
}

- (void)loadNoDataView {
    [MBProgressHUD hideHUD];
    if (!_noDataView) {
        _noDataView = [[TAAINoDataView alloc] init];
        _noDataView.delegate = self;
        
    }
    [self.view addSubview:_noDataView];
    self.navView.backgroundColor = [UIColor whiteColor];
    [self.backBtn setImage:[UIImage imageNamed:@"Group"] forState:normal];
    [_noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navView.mas_bottom);
        make.width.bottom.equalTo(self.view);
    }];
    _noDataView.hidden = NO;
    [self.view bringSubviewToFront:_noDataView];
}
#pragma mark - Delegate
#pragma mark - OtherDelegate
- (void)refrash {
    //没有网络的页面点击刷新调用
    [self fetchData];
}
#pragma mark - Lazy Load
- (UITableView*)tableView{
    if (!_tableView) {
        _tableView =[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor colorWithHex:@"#F1F2F4"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.clipsToBounds = NO;
        [_tableView registerClass:[TAAILearnListCell class] forCellReuseIdentifier:@"aaa"];
    }
    return _tableView;
}

@end
