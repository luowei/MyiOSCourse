//
//  ViewController.m
//  HelloWorld
//
//  Created by luowei on 15/3/4.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnClick:(UIButton *)sender {

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"title AA" message:@"bbbbbbbbb" delegate:nil
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
