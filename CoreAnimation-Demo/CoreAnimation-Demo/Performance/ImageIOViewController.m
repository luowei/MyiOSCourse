//
//  ImageIOViewController.m
//  CoreAnimation-Demo
//
//  Created by luowei on 15/4/18.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import "ImageIOViewController.h"
#import "AppDelegate.h"
#import "RGCardViewLayout.h"
#import <ImageIO/ImageIO.h>

#define SCROLL_SPEED 5

@interface ImageIOViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property(nonatomic, copy) NSArray *imagePaths;
@property(nonatomic, strong) UICollectionView *collectionView;
@end

@implementation ImageIOViewController {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];

    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    self.collectionView.backgroundColor = [UIColor grayColor];

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];


    //set up data
    self.imagePaths = [[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:@"mmPhotos"];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.imagePaths count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //dequeue cell
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    //add image view
    const NSInteger imageTag = 99;
    UIImageView *imageView = (UIImageView *) [cell viewWithTag:imageTag];
    if (!imageView) {
        imageView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
        imageView.tag = imageTag;
        [cell.contentView addSubview:imageView];
    }


/*
    //set image
    NSString *imagePath = self.imagePaths[indexPath.row];
    imageView.image = [UIImage imageWithContentsOfFile:imagePath];
*/


/*
    //使用GCD加载传送图片
    //tag cell with index and clear current image
    cell.tag = indexPath.row;
    imageView.image = nil;
    //switch to background thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        //load image
        NSInteger index = indexPath.row;
        NSString *imagePath = self.imagePaths[index];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];

        //强制图片解压显示
        //redraw image using device context
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, YES, 0);
        [image drawInRect:imageView.bounds];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        //set image on main thread, but only if index still matches up
        dispatch_async(dispatch_get_main_queue(), ^{
            if (index == cell.tag) {
                imageView.image = image;
            }
        });
    });
*/


/*
    //绕过UIKit，像下面这样使用ImageIO框架加载图片
    NSInteger index = indexPath.row;
    NSURL *imageURL = [NSURL fileURLWithPath:self.imagePaths[index]];
    NSDictionary *options = @{(__bridge id) kCGImageSourceShouldCache : @YES};
    CGImageSourceRef source = CGImageSourceCreateWithURL((__bridge CFURLRef) imageURL, NULL);
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, 0, (__bridge CFDictionaryRef) options);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CFRelease(source);

    imageView.image = image;
*/

    //使用自定义缓存加载图片
    //set or load image for this index
    imageView.image = [self loadImageAtIndex:indexPath.item];
    //preload image for previous and next index
    if (indexPath.item < [self.imagePaths count] - 1) {
        [self loadImageAtIndex:indexPath.item + 1]; }
    if (indexPath.item > 0) {
        [self loadImageAtIndex:indexPath.item - 1]; }

    return cell;
}

//利用NSCache创建自定缓存加载图片
- (UIImage *)loadImageAtIndex:(NSUInteger)index {
    //set up cache
    static NSCache *cache = nil;
    if (!cache) {
        cache = [[NSCache alloc] init];
    }
    //if already cached, return immediately
    UIImage *image = [cache objectForKey:@(index)];
    if (image) {
        return [image isKindOfClass:[NSNull class]] ? nil : image;
    }
    //set placeholder to avoid reloading image multiple times
    [cache setObject:[NSNull null] forKey:@(index)];
    //switch to background thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        //load image
        NSString *imagePath = self.imagePaths[index];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        //redraw image using device context
        UIGraphicsBeginImageContextWithOptions(image.size, YES, 0);
        [image drawAtPoint:CGPointZero];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //set image for correct image view
        dispatch_async(dispatch_get_main_queue(), ^{ //cache the image
            [cache setObject:image forKey:@(index)];
            //display the image
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
            UIImageView *imageView = [cell.contentView.subviews lastObject];
            imageView.image = image;
        });
    });
    //not loaded yet
    return nil;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return CGSizeMake(fDeviceWidth, fDeviceHeight);
    return self.collectionView.frame.size;
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
