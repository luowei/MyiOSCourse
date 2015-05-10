//
//  HitTestViewController.m
//  CoreAnimation-Demo
//
//  Created by luowei on 15/4/11.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import "HitTestViewController.h"

@interface HitTestViewController ()
@property(nonatomic, weak) IBOutlet UIView *layerView;
@property(nonatomic, strong) CALayer *blueLayer;
@end

@implementation HitTestViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;

    //create sublayer
    self.blueLayer = [CALayer layer];
    self.blueLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
    self.blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    //add it to our view
//    self.blueLayer.opacity = 0.3;
    [self.layerView.layer addSublayer:self.blueLayer];
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    //get touch position
//    CGPoint point = [[touches anyObject] locationInView:self.view];
//    //get touched layer
//    CALayer *layer = [self.layerView.layer hitTest:point];
//    //get layer using hitTest
//    if (layer == self.blueLayer) {
//        [[[UIAlertView alloc] initWithTitle:@"Inside Blue Layer"
//                                    message:nil
//                                   delegate:nil
//                          cancelButtonTitle:@"OK"
//                          otherButtonTitles:nil] show];
//    } else if (layer == self.layerView.layer) {
//        [[[UIAlertView alloc] initWithTitle:@"Inside White Layer"
//                                    message:nil
//                                   delegate:nil
//                          cancelButtonTitle:@"OK"
//                          otherButtonTitles:nil] show];
//    }
//}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //get touch position relative to main view
    CGPoint point = [[touches anyObject] locationInView:self.view];
    //convert point to the white layer's coordinates
    point = [self.layerView.layer convertPoint:point fromLayer:self.view.layer];
    //get layer using containsPoint:
    if ([self.layerView.layer containsPoint:point]) {
        //convert point to blueLayer’s coordinates
        point = [self.blueLayer convertPoint:point fromLayer:self.layerView.layer];
        if ([self.blueLayer containsPoint:point]) {
            [[[UIAlertView alloc] initWithTitle:@"Inside Blue Layer"
                                        message:nil
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Inside White Layer"
                                        message:nil
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
    }
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
