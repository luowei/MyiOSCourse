//
//  ViewController.h
//  AVPlayer-Demo
//
//  Created by luowei on 15/5/10.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVPlayerItem;
@class AVPlayer;
@class AVPlaybackView;

@interface ViewController : UIViewController{

}


@property (nonatomic, copy) NSURL* url;
@property (nonatomic, strong) AVPlayer* player;
@property (nonatomic,strong) AVPlayerItem* playerItem;


@property (nonatomic, strong) AVPlaybackView *playbackView;

@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIBarButtonItem *playButton;
@property (nonatomic, strong) UIBarButtonItem *stopButton;
@property (nonatomic, strong) UISlider* scrubber;

- (void)play:(id)sender;
- (void)pause:(id)sender;
- (void)showMetadata:(id)sender;

@end

