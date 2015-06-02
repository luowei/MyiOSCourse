//
//  ContentRectViewController.m
//  CoreAnimation-Demo
//
//  Created by luowei on 15/4/11.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import "ContentRectViewController.h"

@interface ContentRectViewController ()

@property(nonatomic, weak) IBOutlet UIView *up1;
@property(nonatomic, weak) IBOutlet UIView *mid1;
@property(nonatomic, weak) IBOutlet UIView *mid2;
@property(nonatomic, weak) IBOutlet UIView *down1;

@end

@implementation ContentRectViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)addSpriteImage:(UIImage *)image withContentRect:(CGRect)rect toLayer:(CALayer *)layer {
    //set image
    layer.contents = (__bridge id) image.CGImage;
    //scale contents to fit
//    layer.contentsGravity = kCAGravityResizeAspect;
    layer.contentsScale = image.scale;
    //set contentsRect
    layer.contentsRect = rect;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.

    UIImage *image = [UIImage imageNamed:@"pinghe"];
    //set igloo sprite
    [self addSpriteImage:image withContentRect:CGRectMake(0, 0, 0.5, 0.5) toLayer:self.mid2.layer];
    //set cone sprite
    [self addSpriteImage:image withContentRect:CGRectMake(0.5, 0, 0.5, 0.5) toLayer:self.up1.layer];
    //set anchor sprite
    [self addSpriteImage:image withContentRect:CGRectMake(0, 0.5, 0.5, 0.5) toLayer:self.down1.layer];
    //set spaceship sprite
    [self addSpriteImage:image withContentRect:CGRectMake(0.5, 0.5, 0.5, 0.5) toLayer:self.mid1.layer];

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
