//
//  GroupOpacityViewController.m
//  CoreAnimation-Demo
//
//  Created by luowei on 15/4/11.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import "GroupOpacityViewController.h"

@interface GroupOpacityViewController ()
//@property(nonatomic, weak) IBOutlet UIView *containerView;
@end

@implementation GroupOpacityViewController

- (UIButton *)customButton {
    //create button
    CGRect frame = CGRectMake(0, 0, 150, 50);
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.backgroundColor = [UIColor whiteColor];
    button.layer.cornerRadius = 10;
    //add label
    frame = CGRectMake(20, 10, 110, 30);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = @"Hello World";
    label.textAlignment = NSTextAlignmentCenter;
    [button addSubview:label];
    return button;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;

    //create opaque button
    UIButton *button1 = [self customButton];
    button1.center = CGPointMake(self.view.center.x, self.view.center.y - 100);
    [self.view addSubview:button1];
    //create translucent button
    UIButton *button2 = [self customButton];

    button2.center = CGPointMake(self.view.center.x, self.view.center.y + 100);
    button2.alpha = 0.5;
    [self.view addSubview:button2];
    //enable rasterization for the translucent button
    button2.layer.shouldRasterize = YES;
    button2.layer.rasterizationScale = [UIScreen mainScreen].scale;
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
