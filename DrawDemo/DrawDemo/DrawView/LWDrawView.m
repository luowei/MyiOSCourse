//
//  LWDrawView.m
//  DrawDemo
//
//  Created by luowei on 16/8/2.
//  Copyright © 2016年 wodedata. All rights reserved.
//

#import "LWDrawView.h"
#import "DrawControls.h"

@implementation LWDrawView

- (NSMutableArray *)pathArray {
    if (_pathArray == nil) {
        _pathArray = @[].mutableCopy;
    }
    return _pathArray;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];

    //初始化线宽及颜色
    self.lineWidth = 1;
    self.lineColor = [UIColor blackColor];
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    //取出所有保存的路径给绘制出来
    for(LWBezierPath *path in self.pathArray){
        if([path isKindOfClass:[UIImage class]]){
            UIImage *image = (UIImage *)path;
            [image drawInRect:rect];
        }else{
            [path.color set];
            [path stroke];
        }
    }
}


- (void)pan:(UIPanGestureRecognizer *)pan {
    //获得当前手指的点
    CGPoint curP = [pan locationInView:self];
    switch (pan.state){
        case UIGestureRecognizerStateBegan:{
            LWBezierPath *path = [LWBezierPath bezierPath];
            [path moveToPoint:curP];
            //设置线的属性
            path.color = self.lineColor;
            path.lineWidth = self.lineWidth;
            path.lineJoinStyle = kCGLineJoinRound;
            path.lineCapStyle = kCGLineCapRound;
            self.path = path;
            //保存当前路径
            [self.pathArray addObject:self.path];
            break;
        }
        case UIGestureRecognizerStateChanged:{
            //添加一条线到当前手指的点
            [self.path addLineToPoint:curP];
            //重绘
            [self setNeedsDisplay];
            break;
        }
        default:
            break;
    }
}

//清屏
-(void)clear{
    [self.pathArray removeAllObjects];
    [self setNeedsDisplay];
}

//撤销
-(void)undo{
    [self.pathArray removeLastObject];
    [self setNeedsDisplay];
}

//橡皮擦
-(void)erase{
    [self setLineColor:[UIColor whiteColor]];
}

//图片属性
-(void)setImage:(UIImage *)image{
    _image = image;
    [self.pathArray addObject:image];
    [self setNeedsDisplay];
}


@end
