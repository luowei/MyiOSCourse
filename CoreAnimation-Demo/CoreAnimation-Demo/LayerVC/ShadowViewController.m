//
//  ShadowViewController.m
//  CoreAnimation-Demo
//
//  Created by luowei on 15/4/11.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import "ShadowViewController.h"

@interface ShadowViewController ()
@property (nonatomic, weak) IBOutlet UIView *layerView1;
@property (nonatomic, weak) IBOutlet UIView *layerView2;
@property (nonatomic, weak) IBOutlet UIView *shadowView;
@end

@implementation ShadowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;

    // Do any additional setup after loading the view from its nib.
    //set the corner radius on our layers
    self.layerView1.layer.cornerRadius = 20.0f;
    self.layerView2.layer.cornerRadius = 20.0f;
    self.shadowView.layer.cornerRadius = 20.0f;

    //add a border to our layers
    self.layerView1.layer.borderWidth = 5.0f;
    self.layerView2.layer.borderWidth = 5.0f;

    //add same shadow to shadowView (not layerView2)
    self.shadowView.layer.shadowOpacity = 0.5f;
    self.shadowView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    self.shadowView.layer.shadowRadius = 5.0f;

    //enable clipping on the second layer
    self.layerView2.layer.masksToBounds = YES;

//    //enable layer shadows
//    self.layerView1.layer.shadowOpacity = 0.5f;
//    self.layerView2.layer.shadowOpacity = 0.5f;
//    //create a square shadow
//    CGMutablePathRef squarePath = CGPathCreateMutable();
//    CGPathAddRect(squarePath, NULL, self.layerView1.bounds);
//    self.layerView1.layer.shadowPath = squarePath; CGPathRelease(squarePath);
//    //create a circular shadow
//    CGMutablePathRef circlePath = CGPathCreateMutable();
//    CGPathAddEllipseInRect(circlePath, NULL, self.layerView2.bounds);
//    self.layerView2.layer.shadowPath = circlePath; CGPathRelease(circlePath);
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
