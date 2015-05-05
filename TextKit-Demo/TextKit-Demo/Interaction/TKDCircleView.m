//
// Created by luowei on 15/5/5.
// Copyright (c) 2015 rootls. All rights reserved.
//

#import "TKDCircleView.h"


@implementation TKDCircleView {

}

- (void)drawRect:(CGRect)rect {
    [self.tintColor setFill];
    [[UIBezierPath bezierPathWithOvalInRect:self.bounds] fill];
}

@end