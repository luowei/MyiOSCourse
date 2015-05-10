//
//  CollectionScrollViewController.m
//  CoreAnimation-Demo
//
//  Created by luowei on 15/4/18.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import "CollectionScrollViewController.h"
#import "RGCardViewLayout.h"

@interface CollectionScrollViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(strong, nonatomic) UICollectionView *collectionView;
@property(nonatomic, copy) NSArray *imagePaths;
@end

@implementation CollectionScrollViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame
                                         collectionViewLayout:[RGCardViewLayout new]];
    _collectionView.backgroundColor = [UIColor lightGrayColor];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.view addSubview:_collectionView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;

    //set up data
    self.imagePaths = [[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:@"mmPhotos"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = (UICollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell"
                                                                                                    forIndexPath:indexPath];
    [self configureCell:cell withIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UICollectionViewCell *)cell withIndexPath:(NSIndexPath *)indexPath {

    NSString *imagePath = self.imagePaths[indexPath.section];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    switch (indexPath.section) {
        case 0:
            cell.backgroundColor = [UIColor colorWithPatternImage:[self reSizeImage:image toSize:cell.contentView.frame.size]];
            break;
        case 1:
            cell.backgroundColor = [UIColor colorWithPatternImage:[self reSizeImage:image toSize:cell.contentView.frame.size]];
            break;
        case 2:
            cell.backgroundColor = [UIColor colorWithPatternImage:[self reSizeImage:image toSize:cell.contentView.frame.size]];
            break;
        case 3:
            cell.backgroundColor = [UIColor colorWithPatternImage:[self reSizeImage:image toSize:cell.contentView.frame.size]];
            break;
        default:
            break;
    }

}

- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize {
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
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
