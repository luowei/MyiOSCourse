//
// Created by luowei on 15/5/10.
// Copyright (c) 2015 luowei. All rights reserved.
//

#import "AssetTabBarController.h"

@interface AssetTabBarController () <UITabBarDelegate>

@end

@implementation AssetTabBarController {

}

// Sent to the delegate when the user selects a tab bar item.
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    // UITabBarItem 'tag' value is used to identify the saved tab bar item
    NSNumber *tabBarItemIndex = @(item.tag);
    // Save current tab bar item to the defaults system.
    [[NSUserDefaults standardUserDefaults] setObject:tabBarItemIndex forKey:AVPlayerDemoPickerViewControllerSourceTypeUserDefaultsKey];
}

@end