//
// Created by luowei on 15/5/10.
// Copyright (c) 2015 luowei. All rights reserved.
//

/*
 AssetBrowserController is a UITableViewController subclass which can be used in a number of ways.
 In particular you can use it as a modal picker style view controller, or as a single view controller
 in a navigation heirarchy. When displaying an AssetBrowserController modally, make the AssetBrowserController
 the root of a UINavigationController then present that controller modally.

 An AssetBrowserController can show one or multiple sources. When using AssetBrowserController
 with UITabBarContoller you may wish to use one AssetBrowserController/source per tab.
 On iPad a picker style AssetBrowserController works nicely inside a UIPopover. Some convenience
 methods are provided below.
* */

#import <UIKit/UIKit.h>
#import "AssetBrowserSource.h"
#import "AssetBrowserItem.h"

@protocol AssetBrowserControllerDelegate;

@interface AssetBrowserController : UITableViewController

@property(nonatomic, weak) id <AssetBrowserControllerDelegate> delegate;

- (id)initWithSourceType:(AssetBrowserSourceType)sourceType modalPresentation:(BOOL)modalPresentation;

- (void)clearSelection; // Used to clear the selection without dismissing the asset browser;

@end


@protocol AssetBrowserControllerDelegate <NSObject>

@optional
/* It is the delegate's responsibility to dismiss the view controller if it has been presented modally.
 If the view controller is part of a navigation heirarchy the client can push a new view controller
 in response to an asset being selected. */
- (void)assetBrowser:(AssetBrowserController *)assetBrowser didChooseItem:(AssetBrowserItem *)assetBrowserItem;

- (void)assetBrowserDidCancel:(AssetBrowserController *)assetBrowser;

@end


@interface UINavigationController (AssetBrowserConvenienceMethods)
// Has a navigation bar and a cancel button. Present the navigation controller modally.
+ (UINavigationController *)modalAssetBrowserControllerWithSourceType:(AssetBrowserSourceType)sourceType delegate:(id <AssetBrowserControllerDelegate>)delegate;
@end

@interface UITabBarController (AssetBrowserConvenienceMethods)
// Configured with one source per tab. Present the tab bar controller modally.
+ (UITabBarController *)tabbedModalAssetBrowserControllerWithSourceType:(AssetBrowserSourceType)sourceType delegate:(id <AssetBrowserControllerDelegate>)delegate;
@end