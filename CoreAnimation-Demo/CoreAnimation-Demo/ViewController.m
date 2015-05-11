//
//  ViewController.m
//  CoreAnimation-Demo
//
//  Created by luowei on 15/4/11.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import "ViewController.h"
#import "MyView.h"

@interface ViewController ()
@property (nonatomic, weak) IBOutlet UIView *layerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;

    [self addMyView];


/*
    //给视图添加一个蓝色子图层
    //create sublayer
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
    blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    //add it to our view
    [self.layerView.layer addSublayer:blueLayer];
*/

/*
    //给图层添加寄宿图
    [super viewDidLoad]; //load an image
    //如果是jpg图片的话，名字要完整
    UIImage *image = [UIImage imageNamed:@"jingtian.jpg"];

    //类型不兼容通过bridged关键字转换
    //add it directly to our view's layer
    self.layerView.layer.contents = (__bridge id)image.CGImage;

    //设置内容与图层边界对齐方式,kCAGravityResizeAspect，它的效果等同于UIViewContentModeScaleAspectFit
    //set the contentsScale to match image
    self.layerView.layer.contentsGravity = kCAGravityResizeAspect;


    //contentsScale属性定义了寄宿图的像素尺寸和视图大小的比例，默认情况下它是一个值为1.0的浮点数
    self.layerView.layer.contentsScale = image.scale;

    //UIView有一个叫做clipsToBounds的属性可以用来决定是否显示超出边界的内容，
    //CALayer对应的属性叫做masksToBounds，把它设置为YES,图像就在边界了
    self.layerView.layer.masksToBounds = YES;
*/

}

- (void)addMyView {
    MyView *myView = [[MyView alloc] initWithFrame: CGRectMake(0, 0, 375, 667)];
    myView.backgroundColor = [UIColor grayColor];

    [self.view addSubview:myView];


    UIImage *image = [UIImage imageNamed:@"earth.png"];
    //add it directly to our view's layer
    myView.layer.contents = (__bridge id)image.CGImage;
//    myView.contentMode = UIViewContentModeCenter;//UIViewContentModeScaleAspectFit;
    myView.layer.contentsGravity = kCAGravityResizeAspect;//kCAGravityCenter;
    //设置中间区域拉伸
//    myView.layer.contentsCenter = CGRectMake(0.25, 0.25, 0.5, 0.5);

    //create sublayer
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
    blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    //注:这里设置delegate要注意，因为view.layer.delegate默认已经是self;再设置blueLayer.delegate=self会crash
    //set controller as layer delegate
    //blueLayer.delegate = self;
    //ensure that layer backing image uses correct scale
    blueLayer.contentsScale = [UIScreen mainScreen].scale; //add layer to our view
    [myView.layer addSublayer:blueLayer];
    //force layer to redraw
    [blueLayer display];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
