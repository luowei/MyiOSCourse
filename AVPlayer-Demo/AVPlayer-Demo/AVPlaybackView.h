//
// Created by luowei on 15/5/10.
// Copyright (c) 2015 luowei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>


@interface AVPlaybackView : UIView

@property (nonatomic, strong) AVPlayer* player;

- (void)setPlayer:(AVPlayer*)player;
- (void)setVideoFillMode:(NSString *)fillMode;

@end