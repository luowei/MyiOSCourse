//
//  DrawViewController.m
//  CoreAnimation-Demo
//
//  Created by luowei on 15/4/15.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import "DrawViewController.h"
#import "DrawingView.h"
#import "BrushDrawingView.h"

@interface DrawViewController ()

@property(nonatomic, strong) DrawingView *drawingView;
@property(nonatomic, strong) BrushDrawingView *brushDrawingView;
@property(nonatomic, strong) UIButton *clearBtn;

@end

@implementation DrawViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    self.view.backgroundColor = [UIColor whiteColor];

/*
    CGRect drawViewFrame= CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-40);
    self.drawingView = [[DrawingView alloc] initWithFrame:drawViewFrame];
    [self.view addSubview:self.drawingView];
*/

    CGRect brushViewFrame= CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-40);
    self.brushDrawingView = [[BrushDrawingView alloc] initWithFrame:brushViewFrame];
    [self.view addSubview:self.brushDrawingView];
}

- (void)clearBtnAction {
//    [self.drawingView clearDraw];
    [self.brushDrawingView clearDraw];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    CGRect clearBtnFrame= CGRectMake(self.view.frame.size.width/2 - 50, self.view.frame.size.height-35, 100, 30);
    self.clearBtn = [[UIButton alloc] initWithFrame:clearBtnFrame];
    [self.clearBtn setTitle:@"清除绘制" forState:UIControlStateNormal];
    [self.clearBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.clearBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    self.clearBtn.layer.backgroundColor = [UIColor cyanColor].CGColor;
    self.clearBtn.layer.cornerRadius = 5.0f;
    self.clearBtn.layer.borderWidth = 0.5f;
    [self.clearBtn addTarget:self action:@selector(clearBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.clearBtn];

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
