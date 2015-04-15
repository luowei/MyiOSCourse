//
//  DrawViewController.m
//  CoreAnimation-Demo
//
//  Created by luowei on 15/4/15.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import "DrawViewController.h"
#import "DrawingView.h"

@interface DrawViewController ()

@property(nonatomic, strong) DrawingView *drawingView;
@end

@implementation DrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.drawingView = [DrawingView new];
    self.drawingView.frame = self.view.frame;
    self.drawingView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.drawingView];
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
