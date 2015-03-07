//
//  EllipseView.h
//  StaticLibTest
//
//  Created by luowei on 15/3/6.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EllipseView : UIImageView

- (UIImage *)getEllipseImageFrom:(UIImage *)image boardWidth:(CGFloat)boardWidth boardColor:(UIColor *)boardColor;

@end
