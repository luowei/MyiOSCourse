//
// Created by luowei on 15/5/21.
// Copyright (c) 2015 rootls. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDStatus;


@interface SDStatusTableViewCell : UITableViewCell
@property(nonatomic, strong) SDStatus *status;
@property(nonatomic) CGFloat height;
@end