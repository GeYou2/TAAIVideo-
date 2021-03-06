//
//  SRVideoLayerView.m
//  SRVideoPlayer
//
//  Created by https://github.com/guowilling on 17/1/5.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "SRVideoPlayerLayerView.h"
#import <AVFoundation/AVFoundation.h>

@implementation SRVideoPlayerLayerView

+ (Class)layerClass {
    AVPlayerLayer *playerLayer = [AVPlayerLayer new];
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    return [playerLayer class];
}

@end
