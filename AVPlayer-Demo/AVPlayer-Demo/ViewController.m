//
//  ViewController.m
//  AVPlayer-Demo
//
//  Created by luowei on 15/5/10.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "ViewController.h"
#import "AVMetaDataViewController.h"
#import "AVPlaybackView.h"

@interface ViewController () {
    float mRestoreAfterScrubbingRate;
    BOOL seekToZeroBeforePlay;
    id mTimeObserver;
    BOOL isSeeking;
    BOOL playbackViewTouched;
}

//视频画面的播放按钮
@property(nonatomic, strong) UIButton *playBtn;

- (void)initScrubberTimer;

- (void)showPlayButton;

- (void)showStopButton;

- (void)syncScrubber;

- (BOOL)isScrubbing;

- (void)handleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer;

- (void)syncPlayPauseButtons;

- (void)beginScrubbing:(id)sender;

- (void)scrub:(id)sender;

- (void)endScrubbing:(id)sender;

@end


@interface ViewController (Player)
- (void)removePlayerTimeObserver;

- (CMTime)playerItemDuration;

- (BOOL)isPlaying;

- (void)playerItemDidReachEnd:(NSNotification *)notification;

- (void)prepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys;
@end

static void *AVPlayerDemoPlaybackViewControllerRateObservationContext = &AVPlayerDemoPlaybackViewControllerRateObservationContext;
static void *AVPlayerDemoPlaybackViewControllerStatusObservationContext = &AVPlayerDemoPlaybackViewControllerStatusObservationContext;
static void *AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext = &AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext;


#pragma mark -

@implementation ViewController

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        [self setPlayer:nil];

        [self setEdgesForExtendedLayout:UIRectEdgeAll];
    }

    return self;
}

- (id)init {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return [self initWithNibName:@"AVPlayerDemoPlaybackView-iPad" bundle:nil];
    }
    else {
        return [self initWithNibName:@"AVPlayerDemoPlaybackView" bundle:nil];
    }
}
*/


- (void)viewDidUnload {
    self.playbackView = nil;

    self.toolbar = nil;
    self.playButton = nil;
    self.stopButton = nil;
    self.scrubber = nil;

    [super viewDidUnload];
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setPlayer:nil];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.view.backgroundColor = [UIColor whiteColor];

    //播放视图
    self.playbackView = [[AVPlaybackView alloc] initWithFrame:self.view.frame];
    self.playbackView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.playbackView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playbackViewTouched:)]];
    [self.view addSubview:self.playbackView];
    
    //添加播放按钮
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playBtn.bounds = CGRectMake(0, 0, 60, 60);
    self.playBtn.center = self.playbackView.center;
    [self.playBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [self.playBtn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    [self.playbackView addSubview:self.playBtn];
    
    //工具栏
    self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 30, self.view.frame.size.width, 30)];
    self.toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;

    self.playButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(play:)];
    self.stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(pause:)];
    self.scrubber = [[UISlider alloc] initWithFrame:CGRectMake(30, 0, self.toolbar.frame.size.width - 88, 20)];
    [self.scrubber setThumbImage:[ViewController imageWithImage:self.scrubber.currentThumbImage scaledToSize:CGSizeMake(5, 5)] forState:UIControlStateNormal];
    self.scrubber.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.scrubber addTarget:self action:@selector(beginScrubbing:) forControlEvents:UIControlEventTouchDown];
    [self.scrubber addTarget:self action:@selector(scrub:) forControlEvents:UIControlEventTouchDragInside | UIControlEventValueChanged];
    [self.scrubber addTarget:self action:@selector(endScrubbing:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel];


    [self.view addSubview:self.toolbar];

    //进度条添加手势
    UISwipeGestureRecognizer *swipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeUpRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer:swipeUpRecognizer];

    UISwipeGestureRecognizer *swipeDownRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeDownRecognizer setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:swipeDownRecognizer];

    UIBarButtonItem *scrubberItem = [[UIBarButtonItem alloc] initWithCustomView:self.scrubber];
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [infoButton addTarget:self action:@selector(showMetadata:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *infoItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];

    self.toolbar.items = @[self.playButton, flexItem, scrubberItem, infoItem];
    isSeeking = NO;
    [self initScrubberTimer];

    [self syncPlayPauseButtons];
    [self syncScrubber];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关灯"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(closeAndOpenLight)];;
}

- (void)closeAndOpenLight {

    //编辑
    if (self.view.backgroundColor == [UIColor whiteColor]) {
        self.view.backgroundColor = [UIColor blackColor];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"开灯"
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(closeAndOpenLight)];
        //保存
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关灯"
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(closeAndOpenLight)];
    }

}

- (void)playbackViewTouched:(id)gesture {
    if (!playbackViewTouched) {
        self.navigationController.navigationBar.hidden = YES;
        self.toolbar.hidden = YES;
    } else {
        self.navigationController.navigationBar.hidden = NO;
        self.toolbar.hidden = NO;
    }
    playbackViewTouched = !playbackViewTouched;
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.player pause];

    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)setViewDisplayName {
    /* Set the view title to the last component of the asset URL. */
    self.title = [_url lastPathComponent];

    /* Or if the item has a AVMetadataCommonKeyTitle metadata, use that instead. */
    for (AVMetadataItem *item in ([[[self.player currentItem] asset] commonMetadata])) {
        NSString *commonKey = [item commonKey];

        if ([commonKey isEqualToString:AVMetadataCommonKeyTitle]) {
            self.title = [item stringValue];
        }
    }
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer {
    UIView *view = [self view];
    UISwipeGestureRecognizerDirection direction = [gestureRecognizer direction];
    CGPoint location = [gestureRecognizer locationInView:view];

    if (location.y < CGRectGetMidY([view bounds])) {
        if (direction == UISwipeGestureRecognizerDirectionUp) {
            [UIView animateWithDuration:0.2f animations:
                    ^{
                        [[self navigationController] setNavigationBarHidden:YES animated:YES];
                    }        completion:
                    ^(BOOL finished) {
                        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
                    }];
        }
        if (direction == UISwipeGestureRecognizerDirectionDown) {
            [UIView animateWithDuration:0.2f animations:
                    ^{
                        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
                    }        completion:
                    ^(BOOL finished) {
                        [[self navigationController] setNavigationBarHidden:NO animated:YES];
                    }];
        }
    }
    else {
        if (direction == UISwipeGestureRecognizerDirectionDown) {
            if (![self.toolbar isHidden]) {
                [UIView animateWithDuration:0.2f animations:
                        ^{
                            [self.toolbar setTransform:CGAffineTransformMakeTranslation(0.f, CGRectGetHeight([self.toolbar bounds]))];
                        }        completion:
                        ^(BOOL finished) {
                            [self.toolbar setHidden:YES];
                        }];
            }
        }
        else if (direction == UISwipeGestureRecognizerDirectionUp) {
            if ([self.toolbar isHidden]) {
                [self.toolbar setHidden:NO];

                [UIView animateWithDuration:0.2f animations:
                        ^{
                            [self.toolbar setTransform:CGAffineTransformIdentity];
                        }        completion:^(BOOL finished) {
                }];
            }
        }
    }
}

- (void)dealloc {
    [self removePlayerTimeObserver];

    [self.player removeObserver:self forKeyPath:@"rate"];
    [_player.currentItem removeObserver:self forKeyPath:@"status"];

    [self.player pause];


}

#pragma mark Asset URL

- (void)setUrl:(NSURL *)url {
    if (_url != url) {
        _url = [url copy];

        /*
         Create an asset for inspection of a resource referenced by a given URL.
         Load the values for the asset key "playable".
         */
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:_url options:nil];

        NSArray *requestedKeys = @[@"playable"];

        /* Tells the asset to load the values of any of the specified keys that are not already loaded. */
        [asset loadValuesAsynchronouslyForKeys:requestedKeys completionHandler:
                ^{
                    dispatch_async(dispatch_get_main_queue(),
                            ^{
                                /* IMPORTANT: Must dispatch to main queue in order to operate on the AVPlayer and AVPlayerItem. */
                                [self prepareToPlayAsset:asset withKeys:requestedKeys];
                            });
                }];
    }
}


#pragma mark -
#pragma mark Movie controller methods

#pragma mark
#pragma mark Button Action Methods

- (void)play:(id)sender {
    /* If we are at the end of the movie, we must seek to the beginning first
        before starting playback. */
    if (seekToZeroBeforePlay) {
        seekToZeroBeforePlay = NO;
        [self.player seekToTime:kCMTimeZero];
    }

    [self.player play];

    self.playBtn.hidden = YES;
    [self showStopButton];
}

- (void)pause:(id)sender {
    [self.player pause];

    self.playBtn.hidden = NO;
    [self showPlayButton];
}

/* Display AVMetadataCommonKeyTitle and AVMetadataCommonKeyCopyrights metadata. */
- (void)showMetadata:(id)sender {
    AVMetaDataViewController *metadataViewController = [[AVMetaDataViewController alloc] init];

    [metadataViewController setMetadata:[[[self.player currentItem] asset] commonMetadata]];

    [self presentViewController:metadataViewController animated:YES completion:NULL];

}

#pragma mark -
#pragma mark Play, Stop buttons

/* Show the stop button in the movie player controller. */
- (void)showStopButton {
    NSMutableArray *toolbarItems = [NSMutableArray arrayWithArray:[self.toolbar items]];
    toolbarItems[0] = self.stopButton;
    self.toolbar.items = toolbarItems;
}

/* Show the play button in the movie player controller. */
- (void)showPlayButton {
    NSMutableArray *toolbarItems = [NSMutableArray arrayWithArray:[self.toolbar items]];
    toolbarItems[0] = self.playButton;
    self.toolbar.items = toolbarItems;
}

/* If the media is playing, show the stop button; otherwise, show the play button. */
- (void)syncPlayPauseButtons {
    if ([self isPlaying]) {
        [self showStopButton];
    }
    else {
        [self showPlayButton];
    }
}

- (void)enablePlayerButtons {
    self.playButton.enabled = YES;
    self.stopButton.enabled = YES;
}

- (void)disablePlayerButtons {
    self.playButton.enabled = NO;
    self.stopButton.enabled = NO;
}

#pragma mark -
#pragma mark Movie scrubber control

/* ---------------------------------------------------------
**  Methods to handle manipulation of the movie scrubber control
** ------------------------------------------------------- */

/* Requests invocation of a given block during media playback to update the movie scrubber control. */
- (void)initScrubberTimer {
    double interval = .1f;

    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration)) {
        return;
    }
    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration)) {
        CGFloat width = CGRectGetWidth([self.scrubber bounds]);
        interval = 0.5f * duration / width;
    }

    /* Update the scrubber during normal playback. */
    __weak ViewController *weakSelf = self;
    mTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(interval, NSEC_PER_SEC)
                                                              queue:NULL /* If you pass NULL, the main queue is used. */
                                                         usingBlock:^(CMTime time) {
                                                             [weakSelf syncScrubber];
                                                         }];
}

//把播放时长同步到进度条
- (void)syncScrubber {
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration)) {
        _scrubber.minimumValue = 0.0;
        return;
    }

    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration)) {
        float minValue = [self.scrubber minimumValue];
        float maxValue = [self.scrubber maximumValue];
        double time = CMTimeGetSeconds([self.player currentTime]);

        [self.scrubber setValue:(float) ((maxValue - minValue) * time / duration + minValue)];
    }
}

//当用户开始拖拽进度条
- (void)beginScrubbing:(id)sender {
    mRestoreAfterScrubbingRate = [self.player rate];
    [self.player setRate:0.f];

    /* Remove previous timer. */
    [self removePlayerTimeObserver];
}

//拖拽进度条
- (void)scrub:(id)sender {
    if ([sender isKindOfClass:[UISlider class]] && !isSeeking) {
        isSeeking = YES;
        UISlider *slider = sender;

        CMTime playerDuration = [self playerItemDuration];
        if (CMTIME_IS_INVALID(playerDuration)) {
            return;
        }

        double duration = CMTimeGetSeconds(playerDuration);
        if (isfinite(duration)) {
            float minValue = [slider minimumValue];
            float maxValue = [slider maximumValue];
            float value = [slider value];

            double time = duration * (value - minValue) / (maxValue - minValue);

            [self.player seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC) completionHandler:^(BOOL finished) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    isSeeking = NO;
                });
            }];
        }
    }
}

//当用完成进度条拖拽
- (void)endScrubbing:(id)sender {
    if (!mTimeObserver) {
        CMTime playerDuration = [self playerItemDuration];
        if (CMTIME_IS_INVALID(playerDuration)) {
            return;
        }

        double duration = CMTimeGetSeconds(playerDuration);
        if (isfinite(duration)) {
            CGFloat width = CGRectGetWidth([self.scrubber bounds]);
            double tolerance = 0.5f * duration / width;

            __weak ViewController *weakSelf = self;
            mTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(tolerance, NSEC_PER_SEC) queue:NULL usingBlock:
                    ^(CMTime time) {
                        [weakSelf syncScrubber];
                    }];
        }
    }

    if (mRestoreAfterScrubbingRate) {
        [self.player setRate:mRestoreAfterScrubbingRate];
        mRestoreAfterScrubbingRate = 0.f;
    }
}

- (BOOL)isScrubbing {
    return mRestoreAfterScrubbingRate != 0.f;
}

- (void)enableScrubber {
    self.scrubber.enabled = YES;
}

- (void)disableScrubber {
    self.scrubber.enabled = NO;
}

@end


@implementation ViewController (Player)

#pragma mark Player Item

- (BOOL)isPlaying {
    return mRestoreAfterScrubbingRate != 0.f || [self.player rate] != 0.f;
}

/* Called when the player item has played to its end time. */
- (void)playerItemDidReachEnd:(NSNotification *)notification {
    /* After the movie has played to its end time, seek back to time zero
        to play it again. */
    seekToZeroBeforePlay = YES;
}

/* ---------------------------------------------------------
 **  Get the duration for a AVPlayerItem.
 ** ------------------------------------------------------- */

- (CMTime)playerItemDuration {
    AVPlayerItem *playerItem = [self.player currentItem];
    if (playerItem.status == AVPlayerItemStatusReadyToPlay) {
        return ([playerItem duration]);
    }

    return (kCMTimeInvalid);
}


/* Cancels the previously registered time observer. */
- (void)removePlayerTimeObserver {
    if (mTimeObserver) {
        [self.player removeTimeObserver:mTimeObserver];
        mTimeObserver = nil;
    }
}

#pragma mark -
#pragma mark Loading the Asset Keys Asynchronously

#pragma mark -
#pragma mark Error Handling - Preparing Assets for Playback Failed

/* --------------------------------------------------------------
 **  Called when an asset fails to prepare for playback for any of
 **  the following reasons:
 **
 **  1) values of asset keys did not load successfully,
 **  2) the asset keys did load successfully, but the asset is not
 **     playable
 **  3) the item did not become ready to play.
 ** ----------------------------------------------------------- */

- (void)assetFailedToPrepareForPlayback:(NSError *)error {
    [self removePlayerTimeObserver];
    [self syncScrubber];
    [self disableScrubber];
    [self disablePlayerButtons];

    /* Display the error. */
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
                                                        message:[error localizedFailureReason]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}


#pragma mark Prepare to play asset, URL

/*
 Invoked at the completion of the loading of the values for all keys on the asset that we require.
 Checks whether loading was successfull and whether the asset is playable.
 If so, sets up an AVPlayerItem and an AVPlayer to play the asset.
 */
- (void)prepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys {
    /* Make sure that the value of each key has loaded successfully. */
    for (NSString *thisKey in requestedKeys) {
        NSError *error = nil;
        AVKeyValueStatus keyStatus = [asset statusOfValueForKey:thisKey error:&error];
        if (keyStatus == AVKeyValueStatusFailed) {
            [self assetFailedToPrepareForPlayback:error];
            return;
        }
        /* If you are also implementing -[AVAsset cancelLoading], add your code here to bail out properly in the case of cancellation. */
    }

    /* Use the AVAsset playable property to detect whether the asset can be played. */
    if (!asset.playable) {
        /* Generate an error describing the failure. */
        NSString *localizedDescription = NSLocalizedString(@"Item cannot be played", @"Item cannot be played description");
        NSString *localizedFailureReason = NSLocalizedString(@"The assets tracks were loaded, but could not be made playable.", @"Item cannot be played failure reason");
        NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
                localizedDescription, NSLocalizedDescriptionKey,
                localizedFailureReason, NSLocalizedFailureReasonErrorKey,
                        nil];
        NSError *assetCannotBePlayedError = [NSError errorWithDomain:@"StitchedStreamPlayer" code:0 userInfo:errorDict];

        /* Display the error to the user. */
        [self assetFailedToPrepareForPlayback:assetCannotBePlayedError];

        return;
    }

    /* At this point we're ready to set up for playback of the asset. */

    /* Stop observing our prior AVPlayerItem, if we have one. */
    if (self.playerItem) {
        /* Remove existing player item key value observers and notifications. */

        [self.playerItem removeObserver:self forKeyPath:@"status"];

        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:AVPlayerItemDidPlayToEndTimeNotification
                                                      object:self.playerItem];
    }

    /* Create a new instance of AVPlayerItem from the now successfully loaded AVAsset. */
    self.playerItem = [AVPlayerItem playerItemWithAsset:asset];

    /* Observe the player item "status" key to determine when it is ready to play. */
    [self.playerItem addObserver:self
                      forKeyPath:@"status"
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:AVPlayerDemoPlaybackViewControllerStatusObservationContext];

    /* When the player item has played to its end time we'll toggle
     the movie controller Pause button to be the Play button */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.playerItem];

    seekToZeroBeforePlay = NO;

    /* Create new player, if we don't already have one. */
    if (!self.player) {
        /* Get a new AVPlayer initialized to play the specified player item. */
        [self setPlayer:[AVPlayer playerWithPlayerItem:self.playerItem]];

        /* Observe the AVPlayer "currentItem" property to find out when any
         AVPlayer replaceCurrentItemWithPlayerItem: replacement will/did
         occur.*/
        [self.player addObserver:self
                      forKeyPath:@"currentItem"
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext];

        /* Observe the AVPlayer "rate" property to update the scrubber control. */
        [self.player addObserver:self
                      forKeyPath:@"rate"
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:AVPlayerDemoPlaybackViewControllerRateObservationContext];
    }

    /* Make our new AVPlayerItem the AVPlayer's current item. */
    if (self.player.currentItem != self.playerItem) {
        /* Replace the player item with a new player item. The item replacement occurs
         asynchronously; observe the currentItem property to find out when the
         replacement will/did occur

		 If needed, configure player item here (example: adding outputs, setting text style rules,
		 selecting media options) before associating it with a player
		 */
        [self.player replaceCurrentItemWithPlayerItem:self.playerItem];

        [self syncPlayPauseButtons];
    }

    [self.scrubber setValue:0.0];
}

#pragma mark -
#pragma mark Asset Key Value Observing
#pragma mark

#pragma mark Key Value Observer for player rate, currentItem, player item status

/* ---------------------------------------------------------
**  Called when the value at the specified key path relative
**  to the given object has changed.
**  Adjust the movie play and pause button controls when the
**  player item "status" value changes. Update the movie
**  scrubber control when the player item is ready to play.
**  Adjust the movie scrubber control when the player item
**  "rate" value changes. For updates of the player
**  "currentItem" property, set the AVPlayer for which the
**  player layer displays visual output.
**  NOTE: this method is invoked on the main queue.
** ------------------------------------------------------- */

- (void)observeValueForKeyPath:(NSString *)path
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    /* AVPlayerItem "status" property value observer. */
    if (context == AVPlayerDemoPlaybackViewControllerStatusObservationContext) {
        [self syncPlayPauseButtons];

        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey] integerValue];
        switch (status) {
            /* Indicates that the status of the player is not yet known because
             it has not tried to load new media resources for playback */
            case AVPlayerItemStatusUnknown: {
                [self removePlayerTimeObserver];
                [self syncScrubber];

                [self disableScrubber];
                [self disablePlayerButtons];
            }
                break;

            case AVPlayerItemStatusReadyToPlay: {
                /* Once the AVPlayerItem becomes ready to play, i.e.
                 [playerItem status] == AVPlayerItemStatusReadyToPlay,
                 its duration can be fetched from the item. */

                [self initScrubberTimer];

                [self enableScrubber];
                [self enablePlayerButtons];
            }
                break;

            case AVPlayerItemStatusFailed: {
                AVPlayerItem *playerItem = (AVPlayerItem *) object;
                [self assetFailedToPrepareForPlayback:playerItem.error];
            }
                break;
        }
    }
        /* AVPlayer "rate" property value observer. */
    else if (context == AVPlayerDemoPlaybackViewControllerRateObservationContext) {
        [self syncPlayPauseButtons];
    }
        /* AVPlayer "currentItem" property observer.
            Called when the AVPlayer replaceCurrentItemWithPlayerItem:
            replacement will/did occur. */
    else if (context == AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext) {
        AVPlayerItem *newPlayerItem = change[NSKeyValueChangeNewKey];

        /* Is the new player item null? */
        if (newPlayerItem == (id) [NSNull null]) {
            [self disablePlayerButtons];
            [self disableScrubber];
        }
        else /* Replacement of player currentItem has occurred */
        {
            /* Set the AVPlayer for which the player layer displays visual output. */
            [self.playbackView setPlayer:_player];

            [self setViewDisplayName];

            /* Specifies that the player should preserve the video’s aspect ratio and
             fit the video within the layer’s bounds. */
            [self.playbackView setVideoFillMode:AVLayerVideoGravityResizeAspect];

            [self syncPlayPauseButtons];
        }
    }
    else {
        [super observeValueForKeyPath:path ofObject:object change:change context:context];
    }
}

@end
