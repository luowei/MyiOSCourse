//
// Created by luowei on 15/5/21.
// Copyright (c) 2015 rootls. All rights reserved.
//

#import "SDStatusTableViewCell.h"
#import "SDStatus.h"
#import "SDUser.h"


@implementation SDStatusTableViewCell {

}

-(void)setStatus:(SDStatus *)status {
    super.textLabel.text = status.user.screenName;
    super.detailTextLabel.text = status.text;
}

-(CGFloat)height {
    return 50;
}

@end