//
//  ViewController.m
//  CoreAnimation-Demo
//
//  Created by luowei on 15/4/11.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIView *layerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

////    给视图添加一个蓝色子图层
//    //create sublayer
//    CALayer *blueLayer = [CALayer layer];
//    blueLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
//    blueLayer.backgroundColor = [UIColor blueColor].CGColor;
//    //add it to our view
//    [self.layerView.layer addSublayer:blueLayer];

//    给图层添加寄宿图
    [super viewDidLoad]; //load an image
    UIImage *image = [UIImage imageNamed:@"jingtian"];

    //类型不兼容通过bridged关键字转换
    //add it directly to our view's layer
    self.layerView.layer.contents = (__bridge id)image.CGImage;

    //设置内容与图层边界对齐方式,kCAGravityResizeAspect，它的效果等同于UIViewContentModeScaleAspectFit
    //set the contentsScale to match image
    self.layerView.layer.contentsGravity = kCAGravityResizeAspect;


//    contentsScale属性定义了寄宿图的像素尺寸和视图大小的比例，默认情况下它是一个值为1.0的浮点数
    self.layerView.layer.contentsScale = image.scale;

//    UIView有一个叫做clipsToBounds的属性可以用来决定是否显示超出边界的内容，
//  CALayer对应的属性叫做masksToBounds，把它设置为YES,图像就在边界了
    self.layerView.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
