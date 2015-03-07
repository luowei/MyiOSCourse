//
//  CircleView.m
//  FrameWorkTest
//
//  Created by luowei on 15/3/5.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import "CircleView.h"

@implementation CircleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (UIImage *)getEllipseImageFrom:(UIImage *)image boardWidth:(CGFloat)boardWidth boardColor:(UIColor *)boardColor {
    //获得图片大小
    CGSize imageSize = image.size;
    //从image获得椭圆的外切矩形
    CGRect ellipseRect = CGRectMake(0,0,image.size.width, image.size.height);
    
    //设置绘图区的大小
    UIGraphicsBeginImageContext(imageSize);
    //获得的当前绘图环境
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //在矩形区中添加一个椭圆
    CGContextAddEllipseInRect(context, ellipseRect);
    //从绘图环境中剪裁出椭圆
    CGContextClip(context);
    
    //设置绘图起始点,从image绘制
    [image drawAtPoint:CGPointZero];
    
    //再绘制椭圆边框
    CGContextAddEllipseInRect(context, ellipseRect);
    //设置描边颜色
    [boardColor setStroke];
    //设置线宽
    CGContextSetLineWidth(context, boardWidth);
    //直接绘制边框线
    CGContextStrokePath(context);
    
    //从绘图环境中以Image方式取出绘制的内容
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRelease(context);
    return img;
}

@end
