//
//  TiledLayerViewController.m
//  CoreAnimation-Demo
//
//  Created by luowei on 15/4/18.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import "CollectionTiledLayerViewController.h"

#define SCROLL_SPEED 5

@interface CollectionTiledLayerViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic, copy) NSArray *imagePaths;
@property(nonatomic, strong) UICollectionView *collectionView;

@end

@implementation CollectionTiledLayerViewController

- (void)viewDidLoad {
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;

    //set up data
    self.imagePaths = [[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:@"mmPhotos"];

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.imagePaths count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //dequeue cell
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    //add the tiled layer
    CATiledLayer *tileLayer = [cell.contentView.layer.sublayers lastObject];
    if (!tileLayer) {
        tileLayer = [CATiledLayer layer];
        tileLayer.frame = cell.bounds;
        tileLayer.contentsScale = [UIScreen mainScreen].scale;
        tileLayer.tileSize = CGSizeMake(cell.bounds.size.width * [UIScreen mainScreen].scale, cell.bounds.size.height * [UIScreen mainScreen].scale);
        tileLayer.delegate = self;
        [tileLayer setValue:@(indexPath.row) forKey:@"index"];
        [cell.contentView.layer addSublayer:tileLayer];
    }
    //tag the layer with the correct index and reload
    tileLayer.contents = nil;
    [tileLayer setValue:@(indexPath.row) forKey:@"index"];
    [tileLayer setNeedsDisplay];

    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return CGSizeMake(fDeviceWidth, fDeviceHeight);
    return self.collectionView.frame.size;
}

- (void)drawLayer:(CATiledLayer *)layer inContext:(CGContextRef)ctx {
    //get image index
    NSInteger index = [[layer valueForKey:@"index"] integerValue];
    //load tile image
    NSString *imagePath = self.imagePaths[index];
    UIImage *tileImage = [UIImage imageWithContentsOfFile:imagePath];
    //calculate image rect
    CGFloat aspectRatio = tileImage.size.height / tileImage.size.width;
    CGRect imageRect = CGRectZero;
    imageRect.size.width = layer.bounds.size.width;
    imageRect.size.height = layer.bounds.size.height * aspectRatio;
    imageRect.origin.y = (layer.bounds.size.height - imageRect.size.height) / 2;
    //draw tile
    UIGraphicsPushContext(ctx);
    [tileImage drawInRect:imageRect];
    UIGraphicsPopContext();
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
