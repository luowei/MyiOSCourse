//
// Created by luowei on 15/5/10.
// Copyright (c) 2015 luowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

enum {
    AssetBrowserItemFillModeCrop,
    AssetBrowserItemFillModeAspectFit
};
typedef NSInteger AssetBrowserItemFillMode;


@interface AssetBrowserItem : NSObject <NSCopying>

@property(nonatomic, readonly) NSURL *URL;
@property(nonatomic, readonly, copy) NSString *title;
@property(nonatomic, readonly) BOOL haveRichestTitle;
@property(nonatomic, readonly, strong) UIImage *thumbnailImage;
@property(weak, nonatomic, readonly) AVAsset *asset;

- (id)initWithURL:(NSURL *)URL;

- (id)initWithURL:(NSURL *)URL title:(NSString *)title; // title can be nil.

/* With AssetBrowserItemFillModeAspectFit size acts as a maximum size. Pass CGRectZero for a full size thumbnail;
 With AssetBrowserItemFillModeCrop the image is cropped to fit size. If the asset does not have enough resolution
 than the returned image have be the aspect ratio specified by size, but lower resolution.
 Retrieve the generated thumbnail with the thumbnailImage property. */
- (void)generateThumbnailAsynchronouslyWithSize:(CGSize)size fillMode:(AssetBrowserItemFillMode)mode completionHandler:(void (^)(UIImage *thumbnail))handler;

- (UIImage *)placeHolderImage;

- (void)generateTitleFromMetadataAsynchronouslyWithCompletionHandler:(void (^)(NSString *title))handler;

- (void)clearThumbnailCache;

- (void)clearAssetCache;

@end