//
//  LWDrawView.h
//  DrawDemo
//
//  Created by luowei on 16/8/2.
//  Copyright © 2016年 wodedata. All rights reserved.
//

//参考:http://www.jianshu.com/p/a94c5b3c08e9


#import <UIKit/UIKit.h>

@class LWDrawBoard;

@interface LWDrawView : UIView

@property (nonatomic, weak) UIBezierPath *path;
@property (nonatomic, strong) NSMutableArray *pathArray;

@property (nonatomic,strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, weak) IBOutlet UIImageView * drawBGView;
@property (nonatomic, weak) IBOutlet LWDrawBoard * drawBoard;

@end


@interface LWDrawBoard:UIView



@end



