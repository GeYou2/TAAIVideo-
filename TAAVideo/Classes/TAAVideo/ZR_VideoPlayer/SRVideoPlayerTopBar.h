//
//  SRVideoTopBar.h
//  SRVideoPlayer
//
//  Created by https://github.com/guowilling on 17/1/6.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SRVideoTopBarBarDelegate <NSObject>

- (void)videoPlayerTopBarDidClickCloseBtn;
- (void)videoPlayerTopBarDidClickDownloadBtn;

@end

@interface SRVideoPlayerTopBar : UIView

@property (nonatomic, weak) id<SRVideoTopBarBarDelegate> delegate;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UILabel  *titleLabel;
//@property (nonatomic, strong) UIButton *downloadBtn;
+ (instancetype)videoTopBar;

- (void)setTitle:(NSString *)text;

@end
