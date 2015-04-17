//
//  DrawingView.m
//  CoreAnimation-Demo
//
//  Created by luowei on 15/4/15.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import "BrushDrawingView.h"

#define BRUSH_SIZE 32

@interface BrushDrawingView ()
@property(nonatomic, strong) NSMutableArray *strokes;
@end

@implementation BrushDrawingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setup];
    }

    return self;
}


- (void)awakeFromNib {
    [self setup];
}

- (void)setup {
    //create array
    self.strokes = [NSMutableArray array];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //get the starting point
    CGPoint point = [[touches anyObject] locationInView:self];
    //add brush stroke
    [self addBrushStrokeAtPoint:point];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //get the touch point
    CGPoint point = [[touches anyObject] locationInView:self];
    //add brush stroke
    [self addBrushStrokeAtPoint:point];
}

- (void)clearDraw{
    if (self.strokes) {
        [self.strokes removeAllObjects];
        [self setNeedsDisplay];
    }
}

/*
- (void)addBrushStrokeAtPoint:(CGPoint)point
{
    //add brush stroke to array
    [self.strokes addObject:[NSValue valueWithCGPoint:point]];
    //needs redraw
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect
{
    //redraw strokes
    for (NSValue *value in self.strokes) {
        //get point
        CGPoint point = [value CGPointValue];
        //get brush rect
        CGRect brushRect = CGRectMake(point.x - BRUSH_SIZE/2, point.y - BRUSH_SIZE/2, BRUSH_SIZE, BRUSH_SIZE);
        //draw brush stroke    ?
        [[UIImage imageNamed:@"mm.jpg"] drawInRect:brushRect];
    }
}
*/


//用-setNeedsDisplayInRect:来减少不必要的绘制
- (void)addBrushStrokeAtPoint:(CGPoint)point {
    //add brush stroke to array
    [self.strokes addObject:[NSValue valueWithCGPoint:point]];
    //set dirty rect
    [self setNeedsDisplayInRect:[self brushRectForPoint:point]];
}

- (CGRect)brushRectForPoint:(CGPoint)point {
    return CGRectMake(point.x - BRUSH_SIZE / 2, point.y - BRUSH_SIZE / 2, BRUSH_SIZE, BRUSH_SIZE);
}

- (void)drawRect:(CGRect)rect {
    //redraw strokes
    for (NSValue *value in self.strokes) {
        //get point
        CGPoint point = [value CGPointValue];
        //get brush rect
        CGRect brushRect = [self brushRectForPoint:point];

        //only draw brush stroke if it intersects dirty rect
        if (CGRectIntersectsRect(rect, brushRect)) {
            //draw brush stroke
            [[UIImage imageNamed:@"luowei"] drawInRect:brushRect];
        }
    }
}

@end
