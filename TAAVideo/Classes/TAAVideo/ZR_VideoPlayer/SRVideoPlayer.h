//
//  SRVideoPlayer.h
//  SRVideoPlayer
//
//  Created by https://github.com/guowilling on 17/1/5.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SRVideoPlayer.h"
#import "SRVideoPlayerLayerView.h"
#import "SRVideoProgressTip.h"
#import "SRVideoPlayerTopBar.h"
#import "SRVideoPlayerBottomBar.h"
#import "SRBrightnessView.h"
#import "SRVideoDownloader.h"
#import "Masonry.h"
@class SRVideoPlayer;

typedef NS_ENUM(NSInteger, SRVideoPlayerState) {
    SRVedioPlayerStateFailed,
    SRVideoPlayerStateBuffering,
    SRVideoPlayerStatePlaying,
    SRVideoPlayerStatePaused,
    SRVideoPlayerStateFinished
};

typedef NS_ENUM(NSInteger, SRVideoPlayerEndAction) {
    SRVideoPlayerEndActionStop,
    SRVideoPlayerEndActionLoop,
    SRVideoPlayerEndActionDestroy
};

@protocol SRVideoPlayerDelegate <NSObject>

@optional
- (void)videoPlayerDidPlay:(SRVideoPlayer *)videoPlayer;
- (void)videoPlayerDidPause:(SRVideoPlayer *)videoPlayer;
- (void)videoPlayerDidResume:(SRVideoPlayer *)videoPlayer;
- (void)videoPlayerDidDestroy:(SRVideoPlayer *)videoPlayer;
- (void)changeScreenOrientationWithIsFullScreen:(BOOL)isFull isRate:(CGFloat)rate;
- (void)videoPlayerDidPlayEnd;
- (void)videoPlayerCurrentTime:(CGFloat)currentTime;
- (void)videoPlayerFPSImageWithUrl:(NSURL*)videoUrl atTime:(NSInteger)time;
@end

@interface SRVideoPlayer : NSObject

@property (nonatomic, weak) id<SRVideoPlayerDelegate> delegate;

/**
 The current state of video player.
 */
@property (nonatomic, assign, readonly) SRVideoPlayerState playerState;

/**
 The action when the video play to end, default is SRVideoPlayerEndActionStop.
 */
@property (nonatomic, assign) SRVideoPlayerEndAction playerEndAction;

/**
 The name of the video which will be displayed in the top center.
 */
@property (nonatomic, weak  ) UIView *playerView;
@property (nonatomic, assign) CGRect  playerViewOriginalRect;
@property (nonatomic, weak  ) UIView *playerSuperView;
@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic, strong) UIView *subtitleBgView;
@property (nonatomic, strong) UILabel *subtitle;//字幕
@property (nonatomic, strong) NSDictionary *subtitledict;//字幕
@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, assign) BOOL bottomHidden;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, assign) BOOL isDetailPlayer;
/**
 Creates and returns a video player with a video's URL, playerView and playerSuperView.

 @param playerView      The view which you want to display the video.
 @param playerSuperView The playerView's super view.
 @return A newly video player.
 */
+ (instancetype)playerWithPlayerView:(UIView *)playerView playerSuperView:(UIView *)playerSuperView;

- (void)play;
- (void)pause;
- (void)resume;
- (void)destroy;
- (void)changeSubtitle;
@end
