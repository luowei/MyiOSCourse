//
//  EmitterLayerViewController.m
//  CoreAnimation-Demo
//
//  Created by luowei on 15/4/13.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import "EmitterLayerViewController.h"

@interface EmitterLayerViewController ()
@property (nonatomic, strong) UIView *containerView;
@end

@implementation EmitterLayerViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    _containerView = [[UIView alloc] initWithFrame:CGRectMake(120, 240, 100, 100)];
    _containerView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_containerView];

    //create particle emitter layer
    CAEmitterLayer *emitter = [CAEmitterLayer layer];
    emitter.frame = self.containerView.bounds;
    [self.containerView.layer addSublayer:emitter];
    //configure emitter
    emitter.renderMode = kCAEmitterLayerAdditive;
    emitter.emitterPosition = CGPointMake(emitter.frame.size.width / 2.0, emitter.frame.size.height / 2.0);
    //create a particle template
    CAEmitterCell *cell = [[CAEmitterCell alloc] init];
//    cell.contents = (__bridge id)[UIImage imageNamed:@"Spark.png"].CGImage;
    cell.contents = (__bridge id)[UIImage imageNamed:@"Spark2.png"].CGImage;
    cell.birthRate = 150;
    cell.lifetime = 5.0;
    cell.color = [UIColor colorWithRed:1 green:0.5 blue:0.1 alpha:1.0].CGColor;
    cell.alphaSpeed = -0.4;
    cell.velocity = 50;
    cell.velocityRange = 50;
    cell.emissionRange = M_PI * 2.0;
    //add particle template to emitter
    emitter.emitterCells = @[cell];
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
