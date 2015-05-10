//
// Created by luowei on 15/5/10.
// Copyright (c) 2015 luowei. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AVMetaDataViewController : UIViewController

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* copyrightLabel;

@property (nonatomic, copy) NSArray* metadata;

- (void)goAway:(id)sender;

@end