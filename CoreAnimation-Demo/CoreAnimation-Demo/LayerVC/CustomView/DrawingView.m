//
//  DrawingView.m
//  CoreAnimation-Demo
//
//  Created by luowei on 15/4/15.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import "DrawingView.h"

@interface DrawingView ()
@property(nonatomic, strong) UIBezierPath *path;
@property(nonatomic, strong) UIImage *drawedImage;
@end

@implementation DrawingView {
    UIColor *_color;
    CGFloat _lineWidth;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _color = [UIColor redColor];
        _lineWidth = 5;
        [self setup];
    }

    return self;
}

- (void)awakeFromNib {
    [self setup];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
/*
    if (self.path) {
        [self.path removeAllPoints];
    }
*/
//    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}

- (void)drawRect:(CGRect)rect {
/*
    //setup image rect
    [self.drawedImage drawInRect:rect];
*/

    //draw path
    [[UIColor clearColor] setFill];
    [_color setStroke];
    [self.path stroke];

}


/*
//将绘制的图像到图片图层
- (void)drawBitmapImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0.0);

    if (!self.drawedImage) {
        UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:self.bounds];
        [[UIColor whiteColor] setFill];
        [rectpath fill];
    }
    [self.drawedImage drawAtPoint:CGPointZero];

    //Set final color for drawing
    [_color setStroke];
    [self.path stroke];
    _path.lineJoinStyle = kCGLineJoinRound;
    _path.lineCapStyle = kCGLineCapRound;
    _path.lineWidth = _lineWidth;
    self.drawedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}
*/



/*
//用Core Graphics实现一个简单的绘图应用

- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
//    [self setMultipleTouchEnabled:NO];
    //create a mutable path
    self.path = [[UIBezierPath alloc] init];
    self.path.lineJoinStyle = kCGLineJoinRound;
    self.path.lineCapStyle = kCGLineCapRound;

    self.path.lineWidth = 5;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //get the starting point
    CGPoint point = [[touches anyObject] locationInView:self];
    //move the path drawing cursor to the starting point
    [self.path moveToPoint:point];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //get the current point
    CGPoint point = [[touches anyObject] locationInView:self];
    //add a new line segment to our path
    [self.path addLineToPoint:point];

//    //copy一份绘制到图片区域
//    [self drawBitmapImage];

    //redraw the view
    [self setNeedsDisplay];
}

- (void)clearDraw {
    if (self.path) {
        [self.path removeAllPoints];
        [self setNeedsDisplay];
    }
}
*/




//用CAShapeLayer重新实现绘图应用

- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
    [self setMultipleTouchEnabled:NO];

    //create a mutable path
    self.path = [[UIBezierPath alloc] init];
    //configure the layer
    CAShapeLayer *shapeLayer = (CAShapeLayer *) self.layer;
    shapeLayer.strokeColor = _color.CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineWidth = _lineWidth;
}

+ (Class)layerClass {
    //this makes our view create a CAShapeLayer
    //instead of a CALayer for its backing layer
    return [CAShapeLayer class];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //get the starting point
    CGPoint point = [[touches anyObject] locationInView:self];
    //move the path drawing cursor to the starting point
    [self.path moveToPoint:point];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //get the current point
    CGPoint point = [[touches anyObject] locationInView:self];
    //add a new line segment to our path
    [self.path addLineToPoint:point];
    //update the layer with a copy of the path
    ((CAShapeLayer *) self.layer).path = self.path.CGPath;

//    //copy一份绘制到图片区域
//    [self drawBitmapImage];

    [self setNeedsDisplay];
}

- (void)clearDraw {
    if (self.path) {
        [self.path removeAllPoints];
        ((CAShapeLayer *) self.layer).path = self.path.CGPath;
        [self setNeedsDisplay];
    }
}


@end
