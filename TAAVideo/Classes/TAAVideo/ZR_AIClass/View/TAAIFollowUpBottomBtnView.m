//
//  TAAIFollowUpBottomBtnView.m
//  TutorABC
//
//  Created by Slark on 2020/5/6.
//  Copyright © 2020 Slark. All rights reserved.
//

#import "TAAIFollowUpBottomBtnView.h"
#import "ZRCircleProgress.h"
#import <AVFoundation/AVFoundation.h>
#import "aiengine.h"
#include "CSRecorder.h"
#import "zlib.h"
#define BtnWidth 70
static NSInteger readTime = 30; //跟读倒计时30秒

@interface TAAIFollowUpBottomBtnView()<AVAudioRecorderDelegate>

@property (nonatomic,strong) UIButton *recorderBtn;//倒计时按钮
@property (nonatomic,strong) UILabel *countLabel;//倒计时标签
@property (nonatomic,strong) UIButton *greateBtn;
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@property (nonatomic, strong)ZRCircleProgress *circleProgress;
@property (nonatomic, assign)struct aiengine * engine;
@property (nonatomic, assign)struct airecorder * recorder;
@end

@implementation TAAIFollowUpBottomBtnView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self followReadDefault];
        //监听程序到后台
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    }
    return self;
}

- (void)setReadState:(FollowReadState)readState {
    switch (readState) {
        case FollowReadStateCommon:
            [self readCommon];
            break;
        case FollowReadStateGood:
            [self readGood];
            break;
        case FollowReadStateDefault:
            [self followReadDefault];
            break;
    }
}

#pragma mark FollowReadDefault
- (void)followReadDefault {
    for (UIView *subView in [self subviews]) {
        [subView removeFromSuperview];
    }
    [self addSubview:self.circleProgress];
    [self addSubview:self.recorderBtn];
    [self.recorderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(@0);
        make.width.height.mas_equalTo(BtnWidth);
    }];
    
    [self addSubview:self.countLabel];
    [ self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.recorderBtn);
        make.top.equalTo(self.recorderBtn.mas_bottom).offset(10);
        make.centerX.equalTo(self.recorderBtn);
        make.height.mas_equalTo(20);
    }];
    //开始录音
    self.circleProgress.hidden = YES;
    //销毁原有
    if (self.engine) {
        aiengine_delete(self.engine);
        self.engine = NULL;
    }
    
}

#pragma mark FollowReadGood
- (void)readGood {
    for (UIView *subView in [self subviews]) {
        [subView removeFromSuperview];
    }
    [self addSubview:self.greateBtn];
    [self.greateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(0));
        make.centerX.equalTo(self);
        make.width.height.mas_equalTo(BtnWidth);
    }];
    
    BoldLabel *label = [[BoldLabel alloc] init];
    label.textColor = [UIColor colorWithRed:10/255.0 green:31/255.0 blue:68/255.0 alpha:1.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"Great Job!";
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_greateBtn);
        make.top.equalTo(_greateBtn.mas_bottom).mas_offset(@10);
        make.width.equalTo(@190);
        make.height.equalTo(@20);
    }];
    if ([self.delegate respondsToSelector:@selector(followReadGood)]) {
        [self.delegate followReadGood];
    }
}

#pragma mark common
- (void)readCommon {
    for (UIView *subView in [self subviews]) {
        [subView removeFromSuperview];
    }
    NSArray* titleArr = @[@"重学",@"再试一次",@"继续"];
    NSArray* imgArr = @[@"icon_relearn1",@"icon_record",@"icon_continue1"];
    CGFloat btnWidth = BtnWidth;
    CGFloat space = (ScreenWidth-(btnWidth*3)-16) / 4;
    for(int i = 0;i < 3;i ++){
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateHighlighted];
        btn.tag = 100 + i;
        [self addSubview:btn];
        UILabel* label = [[UILabel alloc]init];
        label.text = titleArr[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor colorWithRed:10/255.0 green:31/255.0 blue:68/255.0 alpha:1.0];
        label.alpha = 0.4;
        [self addSubview:label];
        if (i==0) {
            //重学按钮
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(space);
                make.top.mas_equalTo(5);
                make.width.height.mas_equalTo(btnWidth-10);
            }];
            [btn addTarget:self action:@selector(reLearn:) forControlEvents:UIControlEventTouchUpInside];
        }else if (i==1) {
            //再来一次按钮
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.mas_equalTo(0);
                make.width.height.mas_equalTo(btnWidth);
            }];
            [btn addTarget:self
                    action:@selector(learnAgain:)
          forControlEvents:UIControlEventTouchUpInside];
        }else if (i==2){
            //继续按钮
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-space);
                make.top.mas_equalTo(5);
                make.width.height.mas_equalTo(btnWidth-10);
            }];
            [btn addTarget:self
                    action:@selector(continueLearn:)
          forControlEvents:UIControlEventTouchUpInside];
        }
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(btnWidth+10);
            make.centerX.equalTo(btn);
            make.width.mas_equalTo(btnWidth+20);
            make.height.mas_equalTo(20);
        }];
    }
    if ([self.delegate respondsToSelector:@selector(followReadBad)]) {
        [self.delegate followReadBad];
    }
}

#pragma mark action
//点击录音按钮 录音结束
- (void)recordClick:(UIButton*)btn {
    [self destryTimer];
    self.circleProgress.hidden = YES;
    self.circleProgress.progress = 0;
    [self.circleProgress stopAnimation];
    [self audioRecorderDidFinishRecording];
    
    if ([_delegate respondsToSelector:@selector(followUpBottomBtnViewDidClickRecordBtn)]) {
        [_delegate followUpBottomBtnViewDidClickRecordBtn];
    }
}
//重学
- (void)reLearn:(UIButton *)btn {
    if ([_delegate respondsToSelector:@selector(followUpBottomBtnViewDidClickReLearnBtn)]) {
        [_delegate followUpBottomBtnViewDidClickReLearnBtn];
    }
}
//再试一次
- (void)learnAgain:(UIButton *)btn {
    [self followReadDefault];
    _countLabel.text = @"30s";
    [self creatChEngine];
    if ([_delegate respondsToSelector:@selector(followUpBottomBtnViewDidClickLearnAgainBtn)]) {
        [_delegate followUpBottomBtnViewDidClickLearnAgainBtn];
    }
}
//继续
- (void)continueLearn:(UIButton *)btn {
    if ([_delegate respondsToSelector:@selector(followUpBottomBtnViewDidClickContinueBtn)]) {
        [_delegate followUpBottomBtnViewDidClickContinueBtn];
    }
}
//开始录音
- (void)startAudioRecoder:(UIButton *)sender{
    
    //驰声发送请求
    int rv = 0;
    
    char wav_path[1024];
    char record_id[64] = {0};
    char param[4096];
    /*引擎启用param传参设置*/
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithCapacity:10];
    /*在线离线参数配置（cloud/native）*/
    [paramDic setValue:@"cloud" forKey:@"coreProvideType"];
    /*音量实时返回参数设置（0关/1开）*/
    [paramDic setValue:[NSNumber numberWithInt:0] forKey:@"soundIntensityEnable"];
    /*appUser传参*/
    NSMutableDictionary *appDic = [[NSMutableDictionary alloc] init];
    [appDic setValue:UserId forKey:@"userId"];
    /*audio音频数据传参*/
    NSMutableDictionary *audioDic = [[NSMutableDictionary alloc] init];
    [audioDic setValue:@"wav" forKey:@"audioType"];//音频编码格式
    [audioDic setValue:[NSNumber numberWithInt:16000] forKey:@"sampleRate"];//音频采样率
    [audioDic setValue:[NSNumber numberWithInt:1] forKey:@"channel"];//单声道设置
    [audioDic setValue:[NSNumber numberWithInt:2] forKey:@"sampleBytes"];//采样字节数（1-单字节-8位，2-双字节-16位）
    /*内核request传参*/
    NSMutableDictionary *requestDic = [[NSMutableDictionary alloc] init];
    NSString *refText = self.contentText;
    //内核类型设置en.word.score/en.sent.score/en.pred.exam
    [requestDic setValue:@"en.sent.score" forKey:@"coreType"];
    [requestDic setValue:refText forKey:@"refText"];//评测文本
    [requestDic setValue:[NSNumber numberWithInt:100] forKey:@"rank"];//总分分制
    [requestDic setValue:[NSNumber numberWithInt:1] forKey:@"attachAudioUrl"];
    [requestDic setValue:[NSNumber numberWithInt:1] forKey:@"precision"];//段落评分精度设置（0.5/1）
    
    [paramDic setValue:appDic forKey:@"app"];
    [paramDic setValue:audioDic forKey:@"audio"];
    [paramDic setValue:requestDic forKey:@"request"];
    
    NSString *paramString;
    paramString = [self dictToJsonString:paramDic];
    /*cfg赋值：string转char*/
    strcpy(param, [paramString UTF8String]);
    NSLog(@"cfg: %s\n",param);
    
    /*评分引擎开始一个请求*/
    rv = aiengine_start(self.engine, param, record_id, (aiengine_callback)_aiengine_callback, (__bridge const void *)(self));
    
    if (rv) {
        NSLog(@"aiengine_start() failed: %d\n", rv);
        return;
    }
    /*录音音频文件保存路径*/
    sprintf(wav_path, "%s/Documents/record/%s.wav", [NSHomeDirectory() UTF8String], record_id);
    /*录音设备开启*/
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord                                            error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    if((rv = airecorder_start(self.recorder, wav_path, _recorder_callback, self.engine, 100)) != 0) {
        NSLog(@"aiengine_start() failed: %d\n", rv);
        return;
    }
    
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.circleProgress.hidden = NO;
        //开始录音动画
        weakSelf.bottomTimer = [NSTimer timerWithTimeInterval:1
                                                       target:weakSelf
                                                     selector:@selector(timerRun)
                                                     userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]
         addTimer:weakSelf.bottomTimer
         forMode:NSDefaultRunLoopMode];
    });
    
}
/*录音回调，上传数据*/
static int _recorder_callback(const void * usrdata, const void * data, int size)
{
    //    NSLog(@"feed: %d\n", size);
    return aiengine_feed((struct aiengine*) usrdata, data, size);
}

- (void)audioRecorderDidFinishRecording{
    [self destryTimer];
    self.bottomTimer = nil;
    airecorder_stop(self.recorder);
    aiengine_stop(self.engine);
}

/*评分引擎回调方法*/
static int _aiengine_callback(const void *usrdata, const char *id, int type, const void *message, int size)
{
    if (type == AIENGINE_MESSAGE_TYPE_JSON) {
        
        /* received score result in json formatting */
        [(__bridge TAAIFollowUpBottomBtnView *)usrdata performSelectorOnMainThread:@selector(request:) withObject:[[NSString alloc] initWithUTF8String:(char *)message] waitUntilDone:NO];
    }
    return 0;
}

- (void)request: (NSString *) result {
    //messageDict是驰声得到的信息
    NSDictionary *messageDict = [self dictionaryWithJsonString:result];
    NSLog(@"得到评分信息%@",messageDict[@"audioUrl"]);
    NSString *overall = messageDict[@"result"][@"overall"];
    if ([self.delegate respondsToSelector:@selector(followUpBottomBtnViewDidChangeBtns:allMessage:)]) {
        [self.delegate followUpBottomBtnViewDidChangeBtns:overall allMessage:messageDict];
    }
    NSInteger scoreLine = 60;
    if (self.partModel) {
        NSDictionary *dic = self.partModel.questionObj;
        NSString *correctScore = dic[@"correctAnswer"];
        scoreLine = [correctScore integerValue];
    }
    
    if ([overall intValue]<scoreLine) {
        //分数小于60  到错误页面
        [self readCommon];
        
    }else{
        //大于60  到good页面
        [self readGood];
        
    }
  
}

//判断是否获取麦克风权限
- (BOOL)hasAuthority{
    BOOL authority = NO;
    AVAuthorizationStatus microPhoneStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (microPhoneStatus) {
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
        {
            // 被拒绝
            [self goMicroPhoneSet];
        }
            break;
        case AVAuthorizationStatusNotDetermined:
        {
            // 没弹窗
            [self requestMicroPhoneAuth];
        }
            break;
        case AVAuthorizationStatusAuthorized:
        {
            // 有授权
            authority = YES;
            [self startAudioRecoder:self.recorderBtn];
        }
            break;
            
        default:
            break;
    }
    return authority;
}

//驰声创建引擎(开始录音)
- (void)creatChEngine {
    
    //销毁原有
    if (self.engine) {
        aiengine_delete(self.engine);
        self.engine = NULL;
    }
    
    
    char cfg[4096];
    char version[512] = {0};
    /*获取当前SDK版本号*/
    aiengine_opt(NULL, AIENGINE_OPT_GET_VERSION, version, sizeof(version));
    NSLog(@"version: %s\n",version);
    /*获取证书路径*/
    NSString * provision = [[NSBundle mainBundle] pathForResource:@"aiengine" ofType:@"provision"];
    /*引擎初始化传参设置*/
    NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc] initWithCapacity:10];
    /*授权参数*/
    [jsonDic setValue:@"158442864500004b" forKey:@"appKey"];
    [jsonDic setValue:@"4e70c426bd37c6c20419dfb0e3748c7d" forKey:@"secretKey"];
    [jsonDic setValue:provision forKey:@"provision"];
    /*日志传参*/
    NSMutableDictionary *logDic = [[NSMutableDictionary alloc] init];
    NSString *logFileName = @"log.txt";
    [logDic setValue:[NSNumber numberWithInt:0] forKey:@"enable"];
    [logDic setValue:logFileName forKey:@"output"];
    /*服务链接参数*/
    NSMutableDictionary *cloudDic = [[NSMutableDictionary alloc] init];
    NSString *serverPath = @"wss://cloud.chivox.com:443";
    [cloudDic setValue:[NSNumber numberWithInt:1] forKey:@"enable"];
    [cloudDic setValue:serverPath forKey:@"server"];
    [cloudDic setValue:[NSNumber numberWithInt:60] forKey:@"serverTimeout"];
    /*初始化传参设置*/
    [jsonDic setValue:logDic forKey:@"prof"];
    [jsonDic setValue:cloudDic forKey:@"cloud"];
    
    NSString *jsonString;
    jsonString = [self dictToJsonString:jsonDic];
    /*cfg赋值：string转char*/
    strcpy(cfg, [jsonString UTF8String]);
    NSLog(@"cfg: %s\n",cfg);
    
    /*评分引擎初始化*/
    self.engine = aiengine_new(cfg);
    /*初始化录音机&播放器*/
    self.recorder = airecorder_new();
    //    NSLog(@"engine: %p\n", self.engine);
    //    NSLog(@"recorder: %p\n", self.recorder);
    if (self.self.engine == NULL || self.recorder == NULL) {
        NSLog(@"驰声创建引擎失败");
        return;
    }
    //获取录音权限
    [self hasAuthority];
}

//如果还有进行申请，要进行权限申请
-(void) requestMicroPhoneAuth
{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        if (granted == YES) {
            [self creatChEngine];
        }else{
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([weakSelf.delegate respondsToSelector:@selector(followUpBottomBtnViewDidClickCancelBtn)]) {
                    [weakSelf.delegate followUpBottomBtnViewDidClickCancelBtn];
                }
            });
            return;
        }
    }];
}
//如果用户没有允许，可以进行弹窗提示，进入设置页面，让用户进行选择
-(void) goMicroPhoneSet
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"您还没有允许麦克风权限" message:@"去设置一下吧" preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([weakSelf.delegate respondsToSelector:@selector(followUpBottomBtnViewDidClickCancelBtn)]) {
            [weakSelf.delegate followUpBottomBtnViewDidClickCancelBtn];
        }
    }];
    UIAlertAction * setAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [UIApplication.sharedApplication openURL:url options:nil completionHandler:^(BOOL success) {
                [weakSelf startAudioRecoder:weakSelf.recorderBtn];
            }];
        });
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:setAction];
    
    [[self viewController] presentViewController:alert animated:YES completion:nil];
}
//获取当前控制器
- (UIViewController *)viewController {
    
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

- (void)timerRun {
    NSLog(@"定时器定时器定时器");
    readTime -=1;
    if (readTime>-1) {
        _countLabel.text = [NSString stringWithFormat:@"%lds",readTime];
    }
    self.circleProgress.progress += 1.0/30;
    self.circleProgress.hidden = NO;

    if (self.circleProgress.progress > 1) {
        [self destryTimer];
        self.bottomTimer = nil;
        self.circleProgress.progress = 1;
        [self.circleProgress stopAnimation];
        [self recordClick:self.recorderBtn];
    }
}
//销毁定时器
- (void)destryTimer {
    if (self.bottomTimer) {
        [self.bottomTimer invalidate];
        readTime = 30;
    }
    //录音完，保证视频播放
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory :AVAudioSessionCategoryPlayback error:&err];
    //移除进度视图
    [self.circleProgress removeFromSuperview];
    self.circleProgress = nil;
}

//json转字典
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
//字典转json
- (NSString *)dictToJsonString:(NSDictionary *)dict {
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments
                                                     error:nil];
    
    if (data == nil) {
        return nil;
    }
    
    NSString *string = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    return string;
    
}
#pragma mark Lazy Load
- (UIButton *)recorderBtn {
    if (!_recorderBtn) {
        _recorderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _recorderBtn.layerCornerRadius = BtnWidth/2;
        [_recorderBtn addTarget:self action:@selector(recordClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recorderBtn;
}
- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc]init];
        _countLabel.text = @"30s";
        _countLabel.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.alpha = 0.5;
    }
    return _countLabel;
}

- (UIButton *)greateBtn {
    if (!_greateBtn) {
        _greateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_greateBtn setImage:[UIImage imageNamed:@"icon_Great"] forState:normal];
    }
    return _greateBtn;
}

- (ZRCircleProgress *)circleProgress {
    if (!_circleProgress) {
        _circleProgress = [[ZRCircleProgress alloc] initWithFrame:CGRectMake(ScreenWidth/2-BtnWidth/2, 0, BtnWidth, BtnWidth) progress:0];
        _circleProgress.progressWidth = 5;
        _circleProgress.bottomColor = [UIColor clearColor];
        _circleProgress.topColor = [UIColor colorWithRed:95.0/255.0 green:197.0/255.0 blue:151.0/255.0 alpha:1];
    }
    return _circleProgress;
}

- (void)dealloc{
    [self recordClick:self.recorderBtn];
    if (self.engine) {
        aiengine_delete(self.engine);
        self.engine = NULL;
    }
     [self destryTimer];
}

- (void)applicationWillResignActive {
    //程序进入后台 停止录音并上传答案
        [self recordClick:self.recorderBtn];
    
}
@end

