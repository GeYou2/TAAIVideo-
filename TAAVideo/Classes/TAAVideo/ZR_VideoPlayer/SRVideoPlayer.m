//
//  SRVideoPlayer.m
//  SRVideoPlayer
//
//  Created by https://github.com/guowilling on 17/1/5.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SRVideoPlayer.h"
#import "SRVideoPlayerLayerView.h"
#import "SRVideoProgressTip.h"
#import "SRVideoPlayerTopBar.h"
#import "SRVideoPlayerBottomBar.h"
#import "SRBrightnessView.h"
#import "SRVideoDownloader.h"
#import "Masonry.h"
#import "Reachability.h"
#import "AFNetworking.h"
static const CGFloat kTopBottomBarH = 60;

#define SRVideoPlayerImageName(fileName) [@"SRVideoPlayer.bundle" stringByAppendingPathComponent:fileName]

static NSString * const SRVideoPlayerItemStatusKeyPath           = @"status";
static NSString * const SRVideoPlayerItemLoadedTimeRangesKeyPath = @"loadedTimeRanges";
static NSString * const SRVideoPlayerTimeControlStatusKeyPath = @"timeControlStatus";

typedef NS_ENUM(NSUInteger, SRControlType) {
    SRControlTypeProgress,
    SRControlTypeVoice,
    SRControlTypeLight,
    SRControlTypeNone = 999
};

@interface SRVideoPlayer() <UIGestureRecognizerDelegate,
SRVideoTopBarBarDelegate,
SRVideoBottomBarDelegate>

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UIView *touchView;
@property (nonatomic, assign, readwrite) SRVideoPlayerState playerState;
@property (nonatomic, assign) UIInterfaceOrientation currentOrientation;
@property (nonatomic, assign) BOOL moved;
@property (nonatomic, assign) BOOL controlHasJudged;
@property (nonatomic, assign) SRControlType controlType;

@property (nonatomic, assign) CGPoint panBeginPoint;
@property (nonatomic, assign) CGFloat panBeginVoiceValue;

@property (nonatomic, assign) NSTimeInterval videoDuration;
@property (nonatomic, assign) NSTimeInterval videoCurrent;

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) NSObject *playbackTimeObserver;

@property (nonatomic, assign) BOOL isFullScreen;
@property (nonatomic, assign) BOOL isDragingSlider;
@property (nonatomic, assign) BOOL isManualPaused;
@property (nonatomic, assign) BOOL screenLocked;

@property (nonatomic, strong) SRVideoPlayerLayerView *playerLayerView;
@property (nonatomic, strong) SRVideoPlayerTopBar *topBar;
@property (nonatomic, strong) SRVideoPlayerBottomBar *bottomBar;
@property (nonatomic, strong) SRVideoProgressTip *progressTip;
@property (nonatomic, strong) MPVolumeView *volumeView;
@property (nonatomic, strong) UISlider *volumeSlider;
@property (nonatomic, strong) UIButton *lockScreenBtn;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *replayBtn;
@property (nonatomic, strong) UILabel *tip4GLabel;//提示4G
@property (nonatomic, strong) UIButton *continueBtn;//继续播放按钮
@property (nonatomic, assign) BOOL allow4G;//是否允许使用4G播放
@property(nonatomic, assign)NSInteger netWorkStatesCode;// 当前的网络状态
@property (nonatomic, assign) NSInteger lastTime;
@end

@implementation SRVideoPlayer

- (void)dealloc {
    NSLog(@"%s", __func__);
    [self destroy];
}

#pragma mark - Lazy Load
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        [_backBtn setImage:[UIImage imageNamed:@"icon_ back"] forState:normal];
        [_backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UILabel *)tip4GLabel {
    if (!_tip4GLabel) {
        _tip4GLabel = [[UILabel alloc] init];
        _tip4GLabel.textColor = [UIColor whiteColor];
        _tip4GLabel.text = @"当前正在使用手机流量\n播放将消耗流量";
        _tip4GLabel.hidden = YES;
        _tip4GLabel.numberOfLines = 2;
        _tip4GLabel.textAlignment = NSTextAlignmentCenter;
        _tip4GLabel.font = NormalFont;
    }
    return _tip4GLabel;
}

- (UIButton *)continueBtn {
    if (!_continueBtn) {
        _continueBtn = [[UIButton alloc] init];
        [_continueBtn setTitle:@"继续播放" forState:normal];
        [_continueBtn setTitleColor:[UIColor whiteColor] forState:normal];
        _continueBtn.layerBorderWidth = 1;
        _continueBtn.hidden = YES;
        _continueBtn.layerBorderColor = [UIColor whiteColor];
        _continueBtn.titleLabel.font = BigFont;
        [_continueBtn addTarget:self action:@selector(continuPlayWith4G) forControlEvents:UIControlEventTouchUpInside];
    }
    return _continueBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _titleLabel;
}

- (SRVideoPlayerLayerView *)playerLayerView {
    if (!_playerLayerView) {
        _playerLayerView = [[SRVideoPlayerLayerView alloc] init];
    }
    return _playerLayerView;
}

- (SRVideoPlayerTopBar *)topBar {
    if (!_topBar) {
        _topBar = [SRVideoPlayerTopBar videoTopBar];
        _topBar.delegate = self;
    }
    return _topBar;
}

- (SRVideoPlayerBottomBar *)bottomBar {
    if (!_bottomBar) {
        _bottomBar = [SRVideoPlayerBottomBar videoBottomBar];
        _bottomBar.delegate = self;
        _bottomBar.userInteractionEnabled = NO;
    }
    return _bottomBar;
}

- (UIView *)subtitleBgView {
    if (!_subtitleBgView) {
        _subtitleBgView = [[UIView alloc] init];
        _subtitleBgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }
    return _subtitleBgView;
}

- (UILabel *)subtitle {
    if (!_subtitle) {
        _subtitle = [[UILabel alloc] init];
        _subtitle.font = [UIFont systemFontOfSize:17];
        _subtitle.textColor = [UIColor whiteColor];
        [_subtitle setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        _subtitle.textAlignment = NSTextAlignmentCenter;
        _subtitle.preferredMaxLayoutWidth = ScreenWidth-2*BorderMargin;
        [_subtitle setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        _subtitle.numberOfLines = 10;
    }
    return _subtitle;
}

- (UIActivityIndicatorView *)activityIndicatorView {
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] init];
    }
    return _activityIndicatorView;
}

//- (UIView *)touchView {
//    if (!_touchView) {
//        _touchView = [[UIView alloc] init];
//        _touchView.backgroundColor = [UIColor clearColor];
//        _touchView.userInteractionEnabled = NO;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchViewTapAction:)];
//        tap.delegate = self;
//        [_touchView addGestureRecognizer:tap];
//        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(touchViewPanAction:)];
//        pan.delegate = self;
//        [_touchView addGestureRecognizer:pan];
//    }
//    return _touchView;
//}

- (MPVolumeView *)volumeView {
    if (!_volumeView) {
        _volumeView = [[MPVolumeView alloc] init];
        _volumeView.showsRouteButton = NO;
        _volumeView.showsVolumeSlider = NO;
        for (UIView *view in _volumeView.subviews) {
            if ([NSStringFromClass(view.class) isEqualToString:@"MPVolumeSlider"]) {
                _volumeSlider = (UISlider *)view;
                break;
            }
        }
    }
    return _volumeView;
}

- (SRVideoProgressTip *)progressTip {
    if (!_progressTip) {
        _progressTip = [[SRVideoProgressTip alloc] init];
        _progressTip.hidden = YES;
        _progressTip.layer.cornerRadius = 10.0;
    }
    return _progressTip;
}

- (UIButton *)replayBtn {
    if (!_replayBtn) {
        _replayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_replayBtn setImage:[UIImage imageNamed:SRVideoPlayerImageName(@"replay")] forState:UIControlStateNormal];
        [_replayBtn addTarget:self action:@selector(replayAction) forControlEvents:UIControlEventTouchUpInside];
        _replayBtn.hidden = YES;
    }
    return _replayBtn;
}

- (UIButton *)lockScreenBtn {
    if (!_lockScreenBtn) {
        _lockScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lockScreenBtn setImage:[UIImage imageNamed:SRVideoPlayerImageName(@"unlock")] forState:UIControlStateNormal];
        [_lockScreenBtn setImage:[UIImage imageNamed:SRVideoPlayerImageName(@"lock")] forState:UIControlStateSelected];
        [_lockScreenBtn addTarget:self action:@selector(lockScreenBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _lockScreenBtn.hidden = YES;
    }
    return _lockScreenBtn;
}

#pragma mark - Init Methods

+ (instancetype)playerWithPlayerView:(UIView *)playerView playerSuperView:(UIView *)playerSuperView {
    return [[SRVideoPlayer alloc] initWithPlayerView:playerView playerSuperView:playerSuperView];
}

- (instancetype)initWithPlayerView:(UIView *)playerView playerSuperView:(UIView *)playerSuperView {
    if (self = [super init]) {
        _playerState = SRVideoPlayerStateBuffering;
        _playerEndAction = SRVideoPlayerEndActionStop;
        _playerView = playerView;
        _playerView.userInteractionEnabled = YES;
        [_playerView layoutIfNeeded];
        _playerViewOriginalRect = playerView.frame;
        _playerSuperView = playerSuperView;
        //调整播放器的UI
        self.topBar.hidden=YES;
        [self.topBar.closeBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
        
        self.bottomBar.totalTimeLabel.hidden=YES;//隐藏视频总时长
        self.bottomBar.playingProgressSlider.hidden=YES;//隐藏播放进度条
        self.bottomBar.bufferedProgressView.hidden=YES;//隐藏缓存进度条
        [self setupSubViews];
        [self setupOrientation];
    }
    return self;
}

- (void)setupSubViews {
    __weak typeof(self) weakSelf = self;
    
    [_playerView addSubview:self.playerLayerView];
    [self.playerLayerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    
    //返回按钮
    [_playerView addSubview:self.backBtn];
    self.backBtn.hidden = YES;
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(BorderMargin);
        make.top.mas_equalTo(40);
        make.width.height.mas_equalTo(30);
    }];
    
    [_playerView addSubview:self.tip4GLabel];
    [self.tip4GLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_playerView);
        make.centerY.mas_equalTo(-60);
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(70);
    }];
    
    [_playerView addSubview:self.continueBtn];
    self.continueBtn.layer.cornerRadius = 25;
    [self.continueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tip4GLabel);
        make.width.mas_equalTo(120);
        make.top.equalTo(self.tip4GLabel.mas_bottom).offset(0);
        make.height.mas_equalTo(50);
    }];
    
    [_playerView addSubview:self.bottomBar];
    [self.bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(kTopBottomBarH);
    }];
    //标题
    [_playerView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(BorderMargin);
        make.bottom.mas_equalTo(self.bottomBar.mas_top).offset(5);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(100);
    }];
    
    [_playerView addSubview:self.activityIndicatorView];
    
    //字幕
    [_playerView addSubview:self.subtitleBgView];
    [_playerView addSubview:self.subtitle];
    self.subtitleBgView.hidden = YES;
    self.subtitle.hidden = YES;
    [self.subtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_playerView);
        make.bottom.equalTo(_playerView).offset(-100);
    }];
    
    [self.subtitleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.subtitle);
        make.right.bottom.equalTo(self.subtitle).mas_equalTo(10);
    }];
    
    [self.activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(weakSelf.playerLayerView);
        make.width.height.mas_equalTo(44);
    }];
    
    [_playerView addSubview:self.touchView];
    [self.touchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.playerLayerView);
        make.top.mas_equalTo(weakSelf.playerLayerView).offset(44);
        make.bottom.mas_equalTo(weakSelf.playerLayerView).offset(-44);
    }];
    
    [_playerView addSubview:self.progressTip];
    [self.progressTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(weakSelf.playerView);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(90);
    }];
    
    [_playerView addSubview:self.replayBtn];
    [self.replayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(weakSelf.playerView);
    }];
    
//    [_playerView addSubview:self.lockScreenBtn];
//    [self.lockScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(weakSelf.playerView).offset(-20);
//        make.centerY.mas_equalTo(weakSelf.playerView);
//    }];
    
    [_playerView addSubview:self.volumeView];
    
    [SRBrightnessView sharedView];
}

- (void)setupOrientation {
    switch ([UIDevice currentDevice].orientation) {
        case UIDeviceOrientationPortrait:
            _currentOrientation = UIInterfaceOrientationPortrait;
            break;
        case UIDeviceOrientationLandscapeLeft:
            _currentOrientation = UIInterfaceOrientationLandscapeLeft;
            break;
        case UIDeviceOrientationLandscapeRight:
            _currentOrientation = UIInterfaceOrientationLandscapeRight;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            _currentOrientation = UIInterfaceOrientationPortraitUpsideDown;
            break;
        default:
            break;
    }
    // notice: must set the app only support portrait orientation
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

#pragma mark - Monitor Methods

- (void)deviceOrientationDidChange {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            [self changeToOrientation:UIInterfaceOrientationPortrait];
            break;
        case UIDeviceOrientationLandscapeLeft:
            [self changeToOrientation:UIInterfaceOrientationLandscapeLeft];
            break;
        case UIDeviceOrientationLandscapeRight:
            [self changeToOrientation:UIInterfaceOrientationLandscapeRight];
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            [self changeToOrientation:UIInterfaceOrientationPortraitUpsideDown];
            break;
        default:
            break;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:SRVideoPlayerItemStatusKeyPath]) {
        NSLog(@"SRVideoPlayerItemStatusKeyPath");
        switch (playerItem.status) {
            case AVPlayerStatusReadyToPlay:{
                [self.activityIndicatorView stopAnimating];
                [self.activityIndicatorView removeFromSuperview];
                [self.player play];
                _playerState = SRVideoPlayerStatePlaying;
                if ([self.delegate respondsToSelector:@selector(videoPlayerDidPlay:)]) {
                    [self.delegate videoPlayerDidPlay:self];
                }
                self.bottomBar.userInteractionEnabled = YES;
                self.touchView.userInteractionEnabled = YES; // prevents the crash that caused by dragging before the video has not loaded successfully
                
                _videoDuration = playerItem.duration.value / playerItem.duration.timescale; // total time of the video in second
                self.bottomBar.totalTimeLabel.text = [self formatTimeWith:(long)ceil(_videoDuration)];
                self.bottomBar.playingProgressSlider.minimumValue = 0.0;
                self.bottomBar.playingProgressSlider.maximumValue = _videoDuration;
                
                __weak __typeof(self) weakSelf = self;
                _playbackTimeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
                    __strong __typeof(weakSelf) strongSelf = weakSelf;
                    //                    if (strongSelf.isDragingSlider) {
                    //                        return;
                    //                    }
                    //                    if (strongSelf.isManualPaused) {
                    //                        return;
                    //                    }
                    if (strongSelf.activityIndicatorView.isAnimating) {
                        [strongSelf.activityIndicatorView stopAnimating];
                    }
                    strongSelf.playerState = SRVideoPlayerStatePlaying;
                    CGFloat currentTime = playerItem.currentTime.value / playerItem.currentTime.timescale;
                    weakSelf.lastTime = currentTime;
                    
                    //这里对比当前时间和字幕数组里的时间，显示字幕
                    NSArray *enSubtitle = [strongSelf.subtitledict objectForKey:@"en"];
                    NSArray *cnSubtitle = [strongSelf.subtitledict objectForKey:@"cn"];
                    NSMutableString *subtitleStr = [NSMutableString string];
                    if (enSubtitle) {
                        for (NSDictionary *subDict in enSubtitle) {
                            if ([self timeToSeconds:subDict[@"startTime"]] == currentTime
                                ||([self timeToSeconds:subDict[@"startTime"]] < currentTime
                                   &&[self timeToSeconds:subDict[@"endTime"]] > currentTime)
                                ) {
                                [subtitleStr appendString:subDict[@"content"]];
                                strongSelf.subtitle.hidden = NO;
                                strongSelf.subtitleBgView.hidden = NO;
                                //                                NSLog(@"当前播放------%@",subtitleStr);
                            }else if([self timeToSeconds:subDict[@"endTime"]] == currentTime) {
                                strongSelf.subtitle.hidden = YES;
                                strongSelf.subtitleBgView.hidden = YES;
                            }
                        }
                    }
                    NSInteger enSubtitleLength = subtitleStr.length;//中文字幕长度
                    //  NSLog(@"当前播放%lf秒",currentTime);
                    if (cnSubtitle) {
                        for (NSDictionary *subDict in cnSubtitle) {
                            if ([self timeToSeconds:subDict[@"startTime"]] == currentTime
                                ||([self timeToSeconds:subDict[@"startTime"]] < currentTime
                                   &&[self timeToSeconds:subDict[@"endTime"]] > currentTime)
                                ) {
                                if ([NSString nullToString:subtitleStr].length>0) {
                                    [subtitleStr appendString:@"\n"];
                                }
                                [subtitleStr appendString:subDict[@"content"]];
                                strongSelf.subtitle.hidden = NO;
                                strongSelf.subtitleBgView.hidden = NO;
                                //                                NSLog(@"当前播放------%@",subtitleStr);
                            }else if([self timeToSeconds:subDict[@"endTime"]] == currentTime) {
                                strongSelf.subtitle.hidden = YES;
                                strongSelf.subtitleBgView.hidden = YES;
                            }
                        }
                    }
                    if ([NSString nullToString:subtitleStr].length>0) {
                        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:subtitleStr];
                        [attrString addAttribute:NSFontAttributeName value:
                         [UIFont systemFontOfSize:17] range:NSMakeRange(0,enSubtitleLength)];
                        [attrString addAttribute:NSFontAttributeName value:
                         [UIFont systemFontOfSize:14] range:
                         NSMakeRange(enSubtitleLength,subtitleStr.length-enSubtitleLength)];
                        
                        strongSelf.subtitle.attributedText = attrString;
                        [strongSelf.subtitle layoutIfNeeded];
                        //处理字幕太多超出屏幕
                        if (strongSelf.subtitle.width > ScreenWidth - 2*BorderMargin) {
                            [strongSelf.subtitle mas_updateConstraints:^(MASConstraintMaker *make) {
                                make.width.mas_equalTo(ScreenWidth - 2*BorderMargin);
                            }];
                        }
                    }else {
                        strongSelf.subtitle.hidden = YES;
                        strongSelf.subtitleBgView.hidden = YES;
                    }
                    
                    CGFloat lastTime = strongSelf.videoDuration - currentTime;//剩余时间
                    
                    strongSelf.bottomBar.currentTimeLabel.text = [strongSelf formatTimeWith:(long)ceil(lastTime)];
                    [strongSelf.bottomBar.playingProgressSlider setValue:currentTime animated:YES];
                    strongSelf.videoCurrent = currentTime;
                    if (strongSelf.videoCurrent > strongSelf.videoDuration) {
                        strongSelf.videoCurrent = strongSelf.videoDuration;
                    }
                }];
                break;
            }
            case AVPlayerStatusFailed:{
                // loading video error which usually a resource issue
                //播放过程中退出程序，再进来
                NSLog(@"AVPlayerStatusFailed");
                NSLog(@"player error: %@", _player.error);
                NSLog(@"playerItem error: %@", _playerItem.error);
                _playerState = SRVedioPlayerStateFailed;
                [self.activityIndicatorView stopAnimating];
                [self destroy];
                break;
            }
            case AVPlayerStatusUnknown:{
                NSLog(@"AVPlayerStatusUnknown");
                break;
            }
        }
    }
    if ([keyPath isEqualToString:SRVideoPlayerItemLoadedTimeRangesKeyPath]) {
        CMTimeRange timeRange = [playerItem.loadedTimeRanges.firstObject CMTimeRangeValue]; // buffer area
        NSTimeInterval timeBuffered = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration); // buffer progress
        NSTimeInterval timeTotal = CMTimeGetSeconds(playerItem.duration);
        [self.bottomBar.bufferedProgressView setProgress:timeBuffered / timeTotal animated:YES];
        //        NSLog(@"视频缓存了%.2f",self.bottomBar.playingProgressSlider.value);
        //判断网络
        Reachability *reach = [Reachability reachabilityForInternetConnection];
        NetworkStatus status22 = [reach currentReachabilityStatus];
        // 判断网络状态
        if (status22 == ReachableViaWWAN && (!self.allow4G)) {
            //移动网
            [self pauseForReachableViaWWAN];
        }
        
    }
    //监听 timeControlStatus 播放状态
    if (object == self.player && [keyPath isEqualToString:SRVideoPlayerTimeControlStatusKeyPath]) {
        if (@available(iOS 10.0, *)) {
            AVPlayerTimeControlStatus status = [[change objectForKey:NSKeyValueChangeNewKey]integerValue];
            if (status == AVPlayerTimeControlStatusWaitingToPlayAtSpecifiedRate) {
                //判断网络
                Reachability *reach = [Reachability reachabilityForInternetConnection];
                NetworkStatus status22 = [reach currentReachabilityStatus];
                // 判断网络状态
                if (status22 == ReachableViaWiFi) {
                    //无线网
                    if (!self.tip4GLabel.hidden) {
                        self.tip4GLabel.hidden = YES;
                        self.continueBtn.hidden = YES;
                        [self applicationDidBecomeActive];
                        //开启缓存
                        self.playerItem.canUseNetworkResourcesForLiveStreamingWhilePaused = YES;
                    }
                } else if (status22 == ReachableViaWWAN && (!self.allow4G)) {
                    //移动网
                    [self pauseForReachableViaWWAN];
                } else{
                    //没有网络
                    NSLog(@"播放时没有网络");
                }
            }
        } else {
            NSLog(@"回来了？");
            // Fallback on earlier versions
            // ios10.0之后才能够监听到暂停后继续播放的状态，ios10.0之前监测不到这个状态
            //但是可以监听到开始播放的状态 AVPlayerStatus  status监听这个属性。
        }
    }
}

#pragma mark placeHolder
- (void)showPlaceHolder{
    UIImage *lastImage = [TAAILearnViewModel getVideoImageWithUrl:self.videoURL atTime:self.lastTime];
    self.bgImageView = [[UIImageView alloc] initWithImage:lastImage];
    self.bgImageView.hidden = NO;
    self.bgImageView.frame = RR(0, 0, ScreenWidth, ScreenHeight);
    [self.playerView addSubview: self.bgImageView];
    [self.playerView sendSubviewToBack:self.bgImageView];
}

- (void)placeHoladerDissmiss{
    self.bgImageView.hidden = YES;
}


//切换关闭视频的时候 需要移除监听
- (void)closePlayer {
    if(_playerItem){
        //status
        [_playerItem removeObserver:self forKeyPath:SRVideoPlayerItemStatusKeyPath context:nil];
        [_playerItem removeObserver:self forKeyPath:SRVideoPlayerItemLoadedTimeRangesKeyPath context:nil];
    }
    if (self.player) {
      //  [self.player removeObserver:self forKeyPath:@"rate"context:nil];
        if (_playbackTimeObserver) {
            [self.player removeTimeObserver:_playbackTimeObserver];
            _playbackTimeObserver = nil;
        }
    }

}

- (void)playerItemDidPlayToEnd:(NSNotification *)notification {

    _playerState = SRVideoPlayerStateFinished;
    if (self.isDetailPlayer && self.isFullScreen) {
        [self videoPlayerBottomBarDidClickChangeScreenBtn];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"nextPartVideo" object:nil];
    if ([self.delegate respondsToSelector:@selector(videoPlayerDidPlayEnd)]) {
        [self.delegate videoPlayerDidPlayEnd];
    }

    switch (_playerEndAction) {
        case SRVideoPlayerEndActionStop:
            self.topBar.hidden    = YES;
            if (!self.isDetailPlayer) {
                self.bottomBar.hidden = YES;
            }
            self.replayBtn.hidden = YES;
            break;
        case SRVideoPlayerEndActionLoop:
            [self replayAction];
            break;
        case SRVideoPlayerEndActionDestroy:
            [self destroy];
            break;
    }
}

- (void)applicationWillResignActive {
    if (!_playerItem) {
        return;
    }
    [self.player pause];
    _playerState = SRVideoPlayerStatePaused;
    [self.bottomBar.playPauseBtn setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
}

- (void)applicationDidBecomeActive {
    if (!_playerItem) {
        return;
    }
    if (_isManualPaused) {
        return;
    }
    [self.player play];
    _playerState = SRVideoPlayerStatePlaying;
    [self.bottomBar.playPauseBtn setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
}


- (void)replayAction {
    [self seekToTimeWithSeconds:0];
    self.topBar.hidden    = YES;
    if (!self.isDetailPlayer) {
        self.bottomBar.hidden = YES;
    }
    self.replayBtn.hidden = YES;
    [self timingHideTopBottomBar];
}

- (void)lockScreenBtnAction:(UIButton *)btn {
    btn.selected = !btn.isSelected;
    self.screenLocked = btn.isSelected;
}

#pragma mark - Player Methods

- (void)play {
    [self closePlayer];
    if (!_videoURL) {
        return;
    }
    if ([_videoURL.absoluteString containsString:@"http"] || [_videoURL.absoluteString containsString:@"https"]) {
        NSString *cachePath = [[SRVideoDownloader sharedDownloader] querySandboxWithURL:_videoURL];
        if (cachePath) {
            _videoURL = [NSURL fileURLWithPath:cachePath];
        }
    }
    
    [self setupPlayer];
    self.bottomBar.currentTimeLabel.text = @"";
}
//点击继续播放允许使用流量播放
- (void)continuPlayWith4G {
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"allow4G"];
    self.allow4G = [[[NSUserDefaults standardUserDefaults] objectForKey:@"allow4G"] boolValue];
    self.tip4GLabel.hidden = YES;
    self.continueBtn.hidden = YES;
    [self applicationDidBecomeActive];
    //开启缓存
    self.playerItem.canUseNetworkResourcesForLiveStreamingWhilePaused = YES;
}
//移动网络下暂停播放
- (void)pauseForReachableViaWWAN{
    self.allow4G = [[[NSUserDefaults standardUserDefaults] objectForKey:@"allow4G"] boolValue];
    if (self.allow4G == NO) {
        self.tip4GLabel.hidden = NO;
        self.continueBtn.hidden = NO;
        [self applicationWillResignActive];
        self.playerItem.canUseNetworkResourcesForLiveStreamingWhilePaused = NO;
    }
    
}
#pragma mark - 检测网络状态变化
-(void)netWorkChangeEvent
{
    NSURL *url = [NSURL URLWithString:[self.videoURL absoluteString]];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    self.netWorkStatesCode =AFNetworkReachabilityStatusUnknown;
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        self.netWorkStatesCode = status;
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"当前使用的是流量模式");
                //移动网
                [self pauseForReachableViaWWAN];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"当前使用的是wifi模式");
                if (!self.tip4GLabel.hidden) {
                    self.tip4GLabel.hidden = YES;
                    self.continueBtn.hidden = YES;
                    [self applicationDidBecomeActive];
                    //开启缓存
                    self.playerItem.canUseNetworkResourcesForLiveStreamingWhilePaused = YES;
                }
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"断网了");
                break;
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"变成了未知网络状态");
                break;
                
            default:
                break;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"netWorkChangeEventNotification" object:@(status)];
    }];
    [manager.reachabilityManager startMonitoring];
}

- (void)pause {
    if (!_playerItem) {
        return;
    }
    [_player pause];
    _isManualPaused = YES;
    _playerState = SRVideoPlayerStatePaused;
    if ([self.delegate respondsToSelector:@selector(videoPlayerDidPause:)]) {
        if (self.isFullScreen&&self.isDetailPlayer) {
             [self.bottomBar.playPauseBtn setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
            return;
        }
        [self.delegate videoPlayerDidPause:self];
    }
    if ((!self.isFullScreen)&&(!self.isDetailPlayer)) {
        [self.bottomBar.playPauseBtn setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
    }
    
}

- (void)resume {
    if (!_playerItem) {
        return;
    }
    [_player play];
    _isManualPaused = NO;
    _playerState = SRVideoPlayerStatePlaying;
    if ([self.delegate respondsToSelector:@selector(videoPlayerDidResume:)]) {
        [self.delegate videoPlayerDidResume:self];
    }
    [self.bottomBar.playPauseBtn setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
}

- (void)setupPlayer {
    CFRunLoopStop([NSRunLoop currentRunLoop].getCFRunLoop);
   
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        _playerItem = [AVPlayerItem playerItemWithURL:_videoURL];
        [_playerItem addObserver:self forKeyPath:SRVideoPlayerItemStatusKeyPath options:NSKeyValueObservingOptionNew context:nil];
        [_playerItem addObserver:self forKeyPath:SRVideoPlayerItemLoadedTimeRangesKeyPath options:NSKeyValueObservingOptionNew context:nil];
        _player = [AVPlayer playerWithPlayerItem:_playerItem];
        //解决刘海屏不全屏问题
        AVPlayerLayer *playerLayer = (AVPlayerLayer *)self.playerLayerView.layer;
        playerLayer.videoGravity = AVLayerVideoGravityResize;
        [playerLayer setPlayer:_player];
        [self addNotification];
    });
      
    [self.activityIndicatorView startAnimating];
}
//添加监听
- (void)addNotification {
    //监听 timeControlStatus
    [self.player addObserver:self forKeyPath:SRVideoPlayerTimeControlStatusKeyPath options:NSKeyValueObservingOptionNew context:nil];
    //实时监控当前网络状态
    [self netWorkChangeEvent];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)destroy {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.player) {
         [self.player removeObserver:self forKeyPath:SRVideoPlayerTimeControlStatusKeyPath];
    }
    if (_player) {
        if (_playerState == SRVideoPlayerStatePlaying) {
            [_player pause];
        }
         [_player pause];
        
        @try {
             [_player removeTimeObserver:_playbackTimeObserver];
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
        
     //   [_player removeTimeObserver:_playbackTimeObserver];
        [_playerItem removeObserver:self forKeyPath:SRVideoPlayerItemStatusKeyPath];
        [_playerItem removeObserver:self forKeyPath:SRVideoPlayerItemLoadedTimeRangesKeyPath];
        _player = nil;
        _playerItem = nil;
        _playbackTimeObserver = nil;
    }
    if (!self.isDetailPlayer) {
        [_playerView removeFromSuperview];
    }else {
//        self.bottomBar.currentTimeLabel.text = @"";
    }
    
    if ([self.delegate respondsToSelector:@selector(videoPlayerDidDestroy:)]) {
        [self.delegate videoPlayerDidDestroy:self];
    }
}

#pragma mark - Orientation Methods
//切换全屏
- (void)changeToOrientation:(UIInterfaceOrientation)orientation {
    if (_currentOrientation == orientation) {
        return;
    }
    _currentOrientation = orientation;
    
    [_playerView removeFromSuperview];
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:{
            //小屏
            __weak typeof(self) weakSelf = self;
            [_playerSuperView addSubview:_playerView];
            [_playerSuperView sendSubviewToBack:_playerView];
            [_playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@0);
                make.left.equalTo(@0);
                make.width.mas_equalTo(CGRectGetWidth(weakSelf.playerViewOriginalRect));
                make.height.mas_equalTo(CGRectGetHeight(weakSelf.playerViewOriginalRect));
            }];
            _bottomBar.changeScreenBtn.hidden = NO;
            _titleLabel.hidden = NO;
            self.backBtn.hidden = YES;
            [_bottomBar.changeScreenBtn setImage:[UIImage imageNamed:@"icon_enlarge"] forState:UIControlStateNormal];
            _isFullScreen = NO;
            break;
        }
        case UIInterfaceOrientationLandscapeLeft:
            //全屏横屏
            self.bottomBar.changeScreenBtn.hidden = YES;
            self.titleLabel.hidden = YES;
            self.backBtn.hidden = NO;
            [[UIApplication sharedApplication].keyWindow addSubview:_playerView];
            [_playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(ScreenHeight);
                make.height.mas_equalTo(ScreenWidth);
                make.center.mas_equalTo([UIApplication sharedApplication].keyWindow);
            }];
            _isFullScreen = YES;
            break;
        case UIInterfaceOrientationUnknown:
        {
            //全屏竖屏
            [[UIApplication sharedApplication].keyWindow addSubview:_playerView];
            [_playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
                make.height.mas_equalTo([UIScreen mainScreen].bounds.size.height);
                make.center.mas_equalTo([UIApplication sharedApplication].keyWindow);
            }];
            [_bottomBar.changeScreenBtn setImage:[UIImage imageNamed:SRVideoPlayerImageName(@"small_screen")] forState:UIControlStateNormal];
            _isFullScreen = YES;
            break;
        }
        default:
            break;
    }
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.playerView.transform = [self getTransformWithOrientation:orientation];
    }];
    
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:[SRBrightnessView sharedView]];
}

- (CGAffineTransform)getTransformWithOrientation:(UIInterfaceOrientation)orientation {
    if (orientation == UIInterfaceOrientationPortrait) {
        [self updateToVerticalOrientation];
        return CGAffineTransformIdentity;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft) {
        [self updateToHorizontalOrientation];
        return CGAffineTransformMakeRotation(M_PI_2);
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        [self updateToHorizontalOrientation];
        return CGAffineTransformMakeRotation(-M_PI_2);
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        [self updateToVerticalOrientation];
        return CGAffineTransformMakeRotation(M_PI);
    }
    return CGAffineTransformIdentity;
}

- (void)updateToVerticalOrientation {
    self.isFullScreen = NO;
    self.lockScreenBtn.hidden = YES;
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)updateToHorizontalOrientation {
    self.isFullScreen = YES;
    self.lockScreenBtn.hidden = NO;
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (_controlHasJudged) {
        return NO;
    } else {
        return YES;
    }
    
}

- (void)touchViewTapAction:(UITapGestureRecognizer *)tap {
    if (self.screenLocked) {
        if (self.lockScreenBtn.isHidden) {
            self.lockScreenBtn.hidden = NO;
            [self performSelector:@selector(hideLockScreenBtn) withObject:nil afterDelay:3.0];
        }
        return;
    }
    if (self.bottomBar.hidden) {
        [self showTopBottomBar];
    } else {
        [self hideTopBottomBar];
    }
}

- (void)touchViewPanAction:(UIPanGestureRecognizer *)pan {
    if (self.playerState == SRVideoPlayerStateFinished) {
        return;
    }
    if (self.screenLocked) {
        return;
    }
    [self showTopBottomBar];
    CGPoint panPoint = [pan locationInView:pan.view];
    if (pan.state == UIGestureRecognizerStateBegan) {
        _panBeginPoint = panPoint;
        _moved = NO;
        _controlHasJudged = NO;
        _panBeginVoiceValue = _volumeSlider.value;
    }
    if (pan.state == UIGestureRecognizerStateChanged) {
        if (fabs(panPoint.x - _panBeginPoint.x) < 10 && fabs(panPoint.y - _panBeginPoint.y) < 10) {
            return;
        }
        _moved = YES;
        if (!_controlHasJudged) {
            float tan = fabs(panPoint.y - _panBeginPoint.y) / fabs(panPoint.x - _panBeginPoint.x);
            if (tan < 1 / sqrt(3)) { // sliding angle is less than 30 degrees
                _controlType = SRControlTypeProgress;
                _controlHasJudged = YES;
            } else if (tan > sqrt(3)) { // sliding angle is greater than 60 degrees
                if (_panBeginPoint.x < pan.view.frame.size.width / 2) { // the left side of the screen controls the brightness
                    _controlType = SRControlTypeLight;
                } else { // the right side of the screen controls the volume
                    _controlType = SRControlTypeVoice;
                }
                _controlHasJudged = YES;
            } else {
                _controlType = SRControlTypeNone;
            }
        }
        if (_controlType == SRControlTypeProgress) {
            NSTimeInterval videoCurrentTime = [self videoCurrentTimeWithPanPoint:panPoint];
            if (videoCurrentTime > _videoCurrent) {
                [self.progressTip setTipImageViewImage:[UIImage imageNamed:SRVideoPlayerImageName(@"progress_right")]];
            } else if(videoCurrentTime < _videoCurrent) {
                [self.progressTip setTipImageViewImage:[UIImage imageNamed:SRVideoPlayerImageName(@"progress_left")]];
            }
            self.progressTip.hidden = NO;
            [self.progressTip setTipLabelText:[NSString stringWithFormat:@"%@ / %@",
                                                    [self formatTimeWith:(long)videoCurrentTime],
                                                    self.bottomBar.totalTimeLabel.text]];
        } else if (_controlType == SRControlTypeVoice) {
            float voiceValue = _panBeginVoiceValue - ((panPoint.y - _panBeginPoint.y) / CGRectGetHeight(pan.view.frame));
            if (voiceValue < 0) {
                self.volumeSlider.value = 0;
            } else if (voiceValue > 1) {
                self.volumeSlider.value = 1;
            } else {
                self.volumeSlider.value = voiceValue;
            }
        } else if (_controlType == SRControlTypeLight) {
            [UIScreen mainScreen].brightness -= ((panPoint.y - _panBeginPoint.y) / 5000);
        } else if (_controlType == SRControlTypeNone) {
            if (self.bottomBar.hidden) {
                [self showTopBottomBar];
            } else {
                [self hideTopBottomBar];
            }
        }
    }
    if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
        _controlHasJudged = NO;
        if (_moved && _controlType == SRControlTypeProgress) {
            self.progressTip.hidden = YES;
            [self seekToTimeWithSeconds:[self videoCurrentTimeWithPanPoint:panPoint]];
            [self.bottomBar.playPauseBtn setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - SRVideoTopBarBarDelegate

- (void)videoPlayerTopBarDidClickCloseBtn {
    [self destroy];
}

- (void)videoPlayerTopBarDidClickDownloadBtn {
    [[SRVideoDownloader sharedDownloader] downloadVideoOfURL:_videoURL progress:^(CGFloat progress) {
        NSLog(@"downloadVideo progress: %.2f", progress);
    } completion:^(NSString *cacheVideoPath, NSError *error) {
        if (cacheVideoPath) {
            NSLog(@"cacheVideoPath: %@", cacheVideoPath);
        } else {
            NSLog(@"error: %@", error);
        }
    }];
}

#pragma mark - SRVideoBottomBarDelegate

- (void)videoPlayerBottomBarDidClickPlayPauseBtn {
    if (!_playerItem) {
        return;
    }
    switch (_playerState) {
        case SRVideoPlayerStatePlaying:
            [self pause];
            break;
        case SRVideoPlayerStatePaused:
            [self resume];
            break;
        default:
            break;
    }
    [self timingHideTopBottomBar];
}
//返回按钮是退出全屏的作用
- (void)goBack{
    [self videoPlayerBottomBarDidClickChangeScreenBtn];
}
- (void)videoPlayerBottomBarDidClickChangeScreenBtn {
    if (_isFullScreen) {
        [self changeToOrientation:UIInterfaceOrientationPortrait];
    } else {
        //全屏设置竖屏
//        [self changeToOrientation:UIInterfaceOrientationUnknown];
        //全屏设置横屏
        [self changeToOrientation:UIInterfaceOrientationLandscapeLeft];
    }
    if (self.isDetailPlayer) {
        [self.bottomBar.playPauseBtn setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
        self.bottomBar.currentTimeLabel.text = @"";
    }
    if ([self.delegate respondsToSelector:@selector(changeScreenOrientationWithIsFullScreen: isRate:)]) {
        [self.delegate changeScreenOrientationWithIsFullScreen:_isFullScreen isRate:self.player.rate];
    }
    
    [self timingHideTopBottomBar];
}

- (void)videoPlayerBottomBarDidTapSlider:(UISlider *)slider withTap:(UITapGestureRecognizer *)tap {
    CGPoint touchPoint = [tap locationInView:slider];
    float value = (touchPoint.x / slider.frame.size.width) * slider.maximumValue;
    self.bottomBar.currentTimeLabel.text = [self formatTimeWith:(long)ceil(value)];
    [self seekToTimeWithSeconds:value];
    [self.bottomBar.playPauseBtn setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
    [self timingHideTopBottomBar];
}

- (void)videoPlayerBottomBarChangingSlider:(UISlider *)slider {
    _isDragingSlider = YES;
    self.bottomBar.currentTimeLabel.text = [self formatTimeWith:(long)ceil(slider.value)];
    [self timingHideTopBottomBar];
}

- (void)videoPlayerBottomBarDidEndChangeSlider:(UISlider *)slider {
    // delay to prevent the sliding point from jumping
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self->_isDragingSlider = NO;
    });
    self.bottomBar.currentTimeLabel.text = [self formatTimeWith:(long)ceil(slider.value)];
    [self seekToTimeWithSeconds:slider.value];
    [self.bottomBar.playPauseBtn setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
    [self timingHideTopBottomBar];
}

#pragma mark - Assist Methods

- (CGFloat)timeToSeconds:(NSString *)time{
    NSArray *timeArray = [time componentsSeparatedByString:@":"];
    CGFloat totalSecond = 0;
    CGFloat hour = [timeArray[0] floatValue];
    CGFloat min = [timeArray[1] floatValue];
    CGFloat s = [timeArray[2] floatValue];
    totalSecond += hour * 3600;
    totalSecond += min * 60;
    totalSecond += s;
    return round(totalSecond);
}


- (NSString *)formatTimeWith:(long)time {
    NSString *formatTime = nil;
    if (time < 3600) {
        formatTime = [NSString stringWithFormat:@"%02li:%02li", lround(floor(time / 60.0)), lround(floor(time / 1.0)) % 60];
    } else {
        formatTime = [NSString stringWithFormat:@"%02li:%02li:%02li", lround(floor(time / 3600.0)), lround(floor(time % 3600) / 60.0), lround(floor(time / 1.0)) % 60];
    }
    return formatTime;
}

- (void)seekToTimeWithSeconds:(CGFloat)seconds {
    seconds = MAX(0, seconds);
    seconds = MIN(seconds, _videoDuration);
    __weak typeof(self) weakSelf = self;
    [self.player pause];
    [self.player seekToTime:CMTimeMakeWithSeconds(seconds, NSEC_PER_SEC) completionHandler:^(BOOL finished) {
        [weakSelf.player play];
        weakSelf.isManualPaused = NO;
        weakSelf.playerState = SRVideoPlayerStatePlaying;
        if (!weakSelf.playerItem.isPlaybackLikelyToKeepUp) {
            weakSelf.playerState = SRVideoPlayerStateBuffering;
            [weakSelf.activityIndicatorView startAnimating];
        }
    }];
}

- (NSTimeInterval)videoCurrentTimeWithPanPoint:(CGPoint)panPoint {
    float videoCurrentTime = _videoCurrent + 99 * ((panPoint.x - _panBeginPoint.x) / [UIScreen mainScreen].bounds.size.width);
    if (videoCurrentTime > _videoDuration) {
        videoCurrentTime = _videoDuration;
    }
    if (videoCurrentTime < 0) {
        videoCurrentTime = 0;
    }
    return videoCurrentTime;
}

- (void)showTopBottomBar {
    if (_playerState != SRVideoPlayerStatePlaying) {
        return;
    }
    self.topBar.hidden = NO;
    self.bottomBar.hidden = NO;
    if (self.isFullScreen) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideLockScreenBtn) object:nil];
        self.lockScreenBtn.hidden = NO;
    }
    [self timingHideTopBottomBar];
}

- (void)hideTopBottomBar {
    if (_playerState != SRVideoPlayerStatePlaying) {
        return;
    }
    self.topBar.hidden = YES;
    self.bottomBar.hidden = YES;
    if (self.isFullScreen) {
        [self performSelector:@selector(hideLockScreenBtn) withObject:nil afterDelay:3.0];
    }
}

- (void)hideLockScreenBtn {
    self.lockScreenBtn.hidden = YES;
}

- (void)setBottomHidden:(BOOL)bottomHidden{
    self.bottomBar.hidden = bottomHidden;
}

- (void)timingHideTopBottomBar {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideTopBottomBar) object:nil];
    //自动隐藏工具栏
//    [self performSelector:@selector(hideTopBottomBar) withObject:nil afterDelay:5.0];
}

@end
