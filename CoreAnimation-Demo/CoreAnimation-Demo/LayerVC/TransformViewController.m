//
//  TransformViewController.m
//  CoreAnimation-Demo
//
//  Created by luowei on 15/4/11.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import "TransformViewController.h"

#define RADIANS_TO_DEGREES(x) ((x)/M_PI*180.0)
#define DEGREES_TO_RADIANS(x) ((x)/180.0*M_PI)

@interface TransformViewController ()
@property(nonatomic, weak) IBOutlet UIView *layerView;
@property(nonatomic, weak) IBOutlet UIView *layerView2;
@property(weak, nonatomic) IBOutlet UIView *layerView3;
@end

@implementation TransformViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    //如果是jpg图片的话，名字要跟上后缀
    UIImage *image = [UIImage imageNamed:@"mm.jpg"];

    self.layerView.layer.contents = (__bridge id) image.CGImage;
    self.layerView.layer.cornerRadius = 20.0;
    self.layerView.layer.masksToBounds = YES;
    self.layerView2.layer.contents = (__bridge id) image.CGImage;
    self.layerView2.layer.cornerRadius = 20.0;
    self.layerView2.layer.masksToBounds = YES;
    self.layerView3.layer.contents = (__bridge id) image.CGImage;
    self.layerView3.layer.cornerRadius = 20.0;
    self.layerView3.layer.masksToBounds = YES;

    //旋转变换
    //rotate the layer 45 degrees
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI_4);
    self.layerView.layer.affineTransform = transform;

    //混合变换
    //create a new transform
    CGAffineTransform transform2 = CGAffineTransformIdentity;
    //scale by 50%
    transform2 = CGAffineTransformScale(transform2, 0.5, 0.5);
    //rotate by 30 degrees
    transform2 = CGAffineTransformRotate(transform2, M_PI / 180.0 * 30.0);
    //x translate by 200 points,y translate by -300 points
    transform2 = CGAffineTransformTranslate(transform2, 200, -50);
    //apply transform to layer
    self.layerView2.layer.affineTransform = transform2;

    //斜切变换
    //shear the layer at a 45-degree angle
    self.layerView3.layer.affineTransform = CGAffineTransformMakeShear(1, 0);
}

//实现一个斜切变换
CGAffineTransform CGAffineTransformMakeShear(CGFloat x, CGFloat y) {
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform.c = -x;
    transform.b = y;
    return transform;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
