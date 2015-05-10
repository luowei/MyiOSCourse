//
// Created by luowei on 15/5/10.
// Copyright (c) 2015 luowei. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AssetBrowserSourceDelegate;

enum {
    AssetBrowserSourceTypeFileSharing = 1 << 0,
    AssetBrowserSourceTypeCameraRoll = 1 << 1,
    AssetBrowserSourceTypeIPodLibrary = 1 << 2,
    AssetBrowserSourceTypeAll = 0xFFFFFFFF
};
typedef NSUInteger AssetBrowserSourceType;


@interface AssetBrowserSource : NSObject

@property(nonatomic, readonly) NSString *name;
@property(nonatomic, readonly, copy) NSArray *items; // NSArray of AssetBrowserItems
@property(nonatomic, readonly) AssetBrowserSourceType type;
@property(nonatomic, weak) id <AssetBrowserSourceDelegate> delegate;


+ (AssetBrowserSource *)assetBrowserSourceOfType:(AssetBrowserSourceType)sourceType;

- (id)initWithSourceType:(AssetBrowserSourceType)sourceType;

- (void)buildSourceLibrary;

@end


@protocol AssetBrowserSourceDelegate <NSObject>

@optional
- (void)assetBrowserSourceItemsDidChange:(AssetBrowserSource *)source;

@end