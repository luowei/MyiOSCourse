//
//  ImageIOViewController.m
//  CoreAnimation-Demo
//
//  Created by luowei on 15/4/18.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import "ImageIOViewController.h"
#import <ImageIO/ImageIO.h>

@interface ImageIOViewController ()
@property(nonatomic, copy) NSArray *imagePaths;
@property(nonatomic, strong) UICollectionView *collectionView;
@end

@implementation ImageIOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc]init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor grayColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];

    //set up data
    self.imagePaths = [[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:@"mmPhotos"];
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSLog(@"%@",mainBundle.resourcePath);

    //register cell class
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
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
                imageView.image = image; }
        });
    });
*/


    //绕过UIKit，像下面这样使用ImageIO框架加载图片
    NSInteger index = indexPath.row;
    NSURL *imageURL = [NSURL fileURLWithPath:self.imagePaths[index]];
    NSDictionary *options = @{(__bridge id)kCGImageSourceShouldCache: @YES};
    CGImageSourceRef source = CGImageSourceCreateWithURL((__bridge CFURLRef)imageURL, NULL);
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, 0,(__bridge CFDictionaryRef)options);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CFRelease(source);

    imageView.image = image;

    return cell;
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
