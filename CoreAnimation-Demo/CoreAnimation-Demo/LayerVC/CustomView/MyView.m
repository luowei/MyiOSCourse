//
//  MyView.m
//  LayerDraw_Test
//
//  Created by luowei on 15/3/17.
//  Copyright (c) 2015年 2345. All rights reserved.
//

#import "MyView.h"

@implementation MyView

- (void)drawRect:(CGRect)rect {
//    [self drawInContext:UIGraphicsGetCurrentContext()];
}

- (void)drawInContext:(CGContextRef)context {
    //加载图片创建CIImage
    UIImage* moi = [UIImage imageNamed:@"earth.png"];
    CIImage* moi2 = [[CIImage alloc] initWithCGImage:moi.CGImage];

    //根据名称获得滤镜
    CIFilter* grad = [CIFilter filterWithName:@"CIRadialGradient"];

    CIVector* center = [CIVector vectorWithX:moi.size.width / 2.0 Y:moi.size.height / 2.0];

    // 使用setValue：forKey：方法设置滤镜属性
    [grad setValue:center forKey:@"inputCenter"];

    // 在指定滤镜名时提供所有滤镜键值对，即以阴影混合模式加上滤镜效果
    CIFilter* dark = [CIFilter filterWithName:@"CIDarkenBlendMode"
                                keysAndValues:@"inputImage", grad.outputImage, @"inputBackgroundImage", moi2, nil];

    //创建CGImage
    CIContext* c = [CIContext contextWithOptions:nil];
    CGImageRef moi3 = [c createCGImage:dark.outputImage fromRect:moi2.extent];

    //从绘图环境中取出UIImage
    UIImage* im = [UIImage imageWithCGImage:moi3 scale:moi.scale orientation:moi.imageOrientation];

    CGImageRelease(moi3);

    UIImageView* iv = [[UIImageView alloc] initWithImage:im];
    [self addSubview: iv];
    iv.center = self.center;

}

@end

