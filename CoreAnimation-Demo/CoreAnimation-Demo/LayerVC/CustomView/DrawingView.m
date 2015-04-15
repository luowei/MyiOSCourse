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
@end

@implementation DrawingView

/*
//用Core Graphics实现一个简单的绘图应用

- (void)awakeFromNib {
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
    //redraw the view
    [self setNeedsDisplay];
}
*/



//用CAShapeLayer重新实现绘图应用
+ (Class)layerClass {
    //this makes our view create a CAShapeLayer
    //instead of a CALayer for its backing layer
    return [CAShapeLayer class];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        //create a mutable path
        self.path = [[UIBezierPath alloc] init];
        //configure the layer
        CAShapeLayer *shapeLayer = (CAShapeLayer *) self.layer;
        shapeLayer.strokeColor = [UIColor redColor].CGColor;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.lineJoin = kCALineJoinRound;
        shapeLayer.lineCap = kCALineCapRound;
        shapeLayer.lineWidth = 5;
    }

    return self;
}


//- (void)awakeFromNib {
//    //create a mutable path
//    self.path = [[UIBezierPath alloc] init];
//    //configure the layer
//    CAShapeLayer *shapeLayer = (CAShapeLayer *) self.layer;
//    shapeLayer.strokeColor = [UIColor redColor].CGColor;
//    shapeLayer.fillColor = [UIColor clearColor].CGColor;
//    shapeLayer.lineJoin = kCALineJoinRound;
//    shapeLayer.lineCap = kCALineCapRound;
//    shapeLayer.lineWidth = 5;
//}

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

    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    //draw path
    [[UIColor clearColor] setFill];
    [[UIColor redColor] setStroke];
    [self.path stroke];
}





@end
