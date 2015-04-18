//
//  Matrix3DViewController.m
//  CoreAnimation-Demo
//
//  Created by luowei on 15/4/18.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import "Matrix3DViewController.h"

/*
#define WIDTH 10
#define HEIGHT 10
#define DEPTH 10
#define SIZE 100
#define SPACING 150
#define CAMERA_DISTANCE 500
*/

#define WIDTH 100
#define HEIGHT 100
#define DEPTH 10
#define SIZE 100
#define SPACING 150
#define CAMERA_DISTANCE 500
#define PERSPECTIVE(z) (float)CAMERA_DISTANCE/(z + CAMERA_DISTANCE)

@interface Matrix3DViewController ()
//<UIScrollViewDelegate>
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) NSMutableSet *recyclePool;
@end

@implementation Matrix3DViewController

/*
//绘制3D图层矩阵
- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.scrollView];

    //set content size
    self.scrollView.contentSize = CGSizeMake((WIDTH - 1) * SPACING, (HEIGHT - 1) * SPACING);
    //set up perspective transform
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0 / CAMERA_DISTANCE;
    self.scrollView.layer.sublayerTransform = transform;
    //create layers
    for (int z = DEPTH - 1; z >= 0; z--) {
        for (int y = 0; y < HEIGHT; y++) {
            for (int x = 0; x < WIDTH; x++) {
                //create layer
                CALayer *layer = [CALayer layer];
                layer.frame = CGRectMake(0, 0, SIZE, SIZE);
                layer.position = CGPointMake(x * SPACING, y * SPACING);
                layer.zPosition = -z * SPACING;
                //set background color
                layer.backgroundColor = [UIColor colorWithWhite:1 - z * (1.0 / DEPTH) alpha:1].CGColor;
                //attach to scroll view
                [self.scrollView.layer addSublayer:layer];
            }
        }
    }
    //log
    NSLog(@"displayed: %i", DEPTH * HEIGHT * WIDTH);
}
*/


/*
//只创建能显示在屏幕上的图层，排除可视区域之外的图层
- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
//    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];

    //set content size
    self.scrollView.contentSize = CGSizeMake((WIDTH - 1) * SPACING, (HEIGHT - 1) * SPACING);
    //set up perspective transform
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0 / CAMERA_DISTANCE;
    self.scrollView.layer.sublayerTransform = transform;
}

- (void)viewDidLayoutSubviews {
    [self updateLayers];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateLayers];
}

- (void)updateLayers {
    //calculate clipping bounds
    CGRect bounds = self.scrollView.bounds;
    bounds.origin = self.scrollView.contentOffset;
    bounds = CGRectInset(bounds, -SIZE / 2, -SIZE / 2);
    //create layers
    NSMutableArray *visibleLayers = [NSMutableArray array];
    for (int z = DEPTH - 1; z >= 0; z--) {
        //increase bounds size to compensate for perspective
        CGRect adjusted = bounds;
        adjusted.size.width /= PERSPECTIVE(z * SPACING);
        adjusted.size.height /= PERSPECTIVE(z * SPACING);
        adjusted.origin.x -= (adjusted.size.width - bounds.size.width) / 2;
        adjusted.origin.y -= (adjusted.size.height - bounds.size.height) / 2;
        for (int y = 0; y < HEIGHT; y++) {
            //check if vertically outside visible rect
            if (y * SPACING < adjusted.origin.y || y * SPACING >= adjusted.origin.y + adjusted.size.height) {
                continue;
            }
            for (int x = 0; x < WIDTH; x++) {
                //check if horizontally outside visible rect
                if (x * SPACING < adjusted.origin.x || x * SPACING >= adjusted.origin.x + adjusted.size.width) {
                    continue;
                }

                //create layer
                CALayer *layer = [CALayer layer];
                layer.frame = CGRectMake(0, 0, SIZE, SIZE);
                layer.position = CGPointMake(x * SPACING, y * SPACING);
                layer.zPosition = -z * SPACING;
                //set background color
                layer.backgroundColor = [UIColor colorWithWhite:1 - z * (1.0 / DEPTH) alpha:1].CGColor;
                //attach to scroll view
                [visibleLayers addObject:layer];
            }
        }
    }
    //update layers
    self.scrollView.layer.sublayers = visibleLayers;
    //log
    NSLog(@"displayed: %i/%i", [visibleLayers count], DEPTH * HEIGHT * WIDTH);
}
*/


- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
//    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];

    //create recycle pool
    self.recyclePool = [NSMutableSet set];
    //set content size
    self.scrollView.contentSize = CGSizeMake((WIDTH - 1) * SPACING, (HEIGHT - 1) * SPACING);
    //set up perspective transform
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0 / CAMERA_DISTANCE;
    self.scrollView.layer.sublayerTransform = transform;
}

- (void)viewDidLayoutSubviews {
    [self updateLayers];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateLayers];
}

- (void)updateLayers {

    //calculate clipping bounds
    CGRect bounds = self.scrollView.bounds;
    bounds.origin = self.scrollView.contentOffset;
    bounds = CGRectInset(bounds, -SIZE / 2, -SIZE / 2);
    //add existing layers to pool
    [self.recyclePool addObjectsFromArray:self.scrollView.layer.sublayers];
    //disable animation
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    //create layers
    NSInteger recycled = 0;
    NSMutableArray *visibleLayers = [NSMutableArray array];
    for (int z = DEPTH - 1; z >= 0; z--) {
        //increase bounds size to compensate for perspective
        CGRect adjusted = bounds;
        adjusted.size.width /= PERSPECTIVE(z * SPACING);
        adjusted.size.height /= PERSPECTIVE(z * SPACING);
        adjusted.origin.x -= (adjusted.size.width - bounds.size.width) / 2;
        adjusted.origin.y -= (adjusted.size.height - bounds.size.height) / 2;
        for (int y = 0; y < HEIGHT; y++) {
            //check if vertically outside visible rect
            if (y * SPACING < adjusted.origin.y ||
                    y * SPACING >= adjusted.origin.y + adjusted.size.height) {
                continue;
            }
            for (int x = 0; x < WIDTH; x++) {
                //check if horizontally outside visible rect
                if (x * SPACING < adjusted.origin.x ||
                        x * SPACING >= adjusted.origin.x + adjusted.size.width) {
                    continue;
                }
                //recycle layer if available
                CALayer *layer = [self.recyclePool anyObject];
                if (layer) {

                    recycled++;
                    [self.recyclePool removeObject:layer];
                }
                else {
                    //create layer
                    layer = [CALayer layer];
                    layer.frame = CGRectMake(0, 0, SIZE, SIZE);
                }
                //set position
                layer.position = CGPointMake(x * SPACING, y * SPACING);
                layer.zPosition = -z * SPACING;
                //set background color
                layer.backgroundColor =
                        [UIColor colorWithWhite:1 - z * (1.0 / DEPTH) alpha:1].CGColor;
                //attach to scroll view
                [visibleLayers addObject:layer];
            }
        }
    }
    [CATransaction commit]; //update layers
    self.scrollView.layer.sublayers = visibleLayers;
    //log
    NSLog(@"displayed: %i/%i recycled: %i",
            [visibleLayers count], DEPTH * HEIGHT * WIDTH, recycled);
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
