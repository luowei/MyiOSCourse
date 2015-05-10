//
//  NearestViewController.m
//  CoreAnimation-Demo
//
//  Created by luowei on 15/4/11.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import "NearestViewController.h"

@interface NearestViewController ()
@property(nonatomic, strong) IBOutletCollection(UIView) NSArray *digitViews;
@property(nonatomic, weak) NSTimer *timer;
@end

@implementation NearestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;

    //get spritesheet image
    UIImage *digits = [UIImage imageNamed:@"Digits"];
    //set up digit views
    for (UIView *view in self.digitViews) {
        //set contents
        view.layer.contents = (__bridge id) digits.CGImage;
        view.layer.contentsRect = CGRectMake(0, 0, 0.1, 1.0);
        view.layer.contentsGravity = kCAGravityResizeAspect;

        //默认的kCAFilterLinear,改成kCAFilterNearest
        view.layer.magnificationFilter = kCAFilterNearest;
    }
    //start timer
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    //set initial clock time
    [self tick];
}

- (void)setDigit:(NSInteger)digit forView:(UIView *)view {
    //adjust contentsRect to select correct digit
    view.layer.contentsRect = CGRectMake(digit * 0.1, 0, 0.1, 1.0);
}

- (void)tick {
    //convert time to hours, minutes and seconds
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger units = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;

    NSDateComponents *components = [calendar components:units fromDate:[NSDate date]];
    //set hours
    [self setDigit:components.hour / 10 forView:self.digitViews[0]];
    [self setDigit:components.hour % 10 forView:self.digitViews[1]];
    //set minutes
    [self setDigit:components.minute / 10 forView:self.digitViews[2]];
    [self setDigit:components.minute % 10 forView:self.digitViews[3]];
    //set seconds
    [self setDigit:components.second / 10 forView:self.digitViews[4]];
    [self setDigit:components.second % 10 forView:self.digitViews[5]];
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
