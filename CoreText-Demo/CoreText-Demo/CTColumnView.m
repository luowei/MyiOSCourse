//
//  CTColumnView.m
//  CoreText-Demo
//
//  Created by luowei on 15/5/3.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import <CoreText/CoreText.h>
#import "CTColumnView.h"

@implementation CTColumnView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.images = [NSMutableArray array];
    }

    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();

    // Flip the coordinate system
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);

    CTFrameDraw((__bridge CTFrameRef)_ctFrame, context);


    for (NSArray* imageData in self.images) {
        UIImage* img = imageData[0];
        CGRect imgBounds = CGRectFromString(imageData[1]);
        CGContextDrawImage(context, imgBounds, img.CGImage);
    }
}


@end
