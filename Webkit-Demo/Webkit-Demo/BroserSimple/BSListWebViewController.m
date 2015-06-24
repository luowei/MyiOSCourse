//
//  BSListWebViewController.m
//  Webkit-Demo
//
//  Created by luowei on 15/6/24.
//  Copyright (c) 2015 rootls. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "BSListWebViewController.h"
#import "WK.h"
#import "WKPagesCollectionView.h"
#import "WKPagesCollectionViewCell.h"
#import "WKPagesCollectionViewFlowLayout.h"


@interface BSListWebViewController()<WKPagesCollectionViewDataSource,WKPagesCollectionViewDelegate>


@property(nonatomic, strong) NSMutableArray *windows;
@property(nonatomic, strong) WKPagesCollectionView *collectionView;
@end

@implementation BSListWebViewController


- (instancetype)initWithWebView:(WKWebView *)webView {
    self = [super init];
    if (self) {
        __weak __typeof(self) weakSelf = self;
        self.updateDatasourceBlock = ^(WKWebView *wb){
            if(!weakSelf.windows){
                weakSelf.windows = @[wb].mutableCopy;
            }else{
                [weakSelf.windows addObject:wb];
            }

        };
        self.updateDatasourceBlock(webView);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addWebView:)];
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting"] style:UIBarButtonItemStylePlain target:self action:@selector(setting)];

    _collectionView= [[WKPagesCollectionView alloc] initWithFrame:self.view.frame];
    _collectionView.dataSource=self;
    _collectionView.delegate=self;
    [_collectionView registerClass:[WKPagesCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];
    _collectionView.maskShow=YES;

}


//设置
- (void)setting {

}

//添加一个webView
- (void)addWebView:(id)sender {

    [_collectionView appendItem];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


#pragma mark UICollectionViewDataSource Implementation

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _windows.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    WKWebView *webView = _windows[(NSUInteger) indexPath.row];

    static NSString* identity=@"cell";
    WKPagesCollectionViewCell* cell=(WKPagesCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identity forIndexPath:indexPath];
    cell.collectionView=collectionView;

    //对webView截图
    UIGraphicsBeginImageContextWithOptions(webView.bounds.size, YES, 1.0);
    [webView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    UIImageView* imageView= [[UIImageView alloc] initWithImage:image];

    imageView.frame=self.view.bounds;
    [cell.cellContentView addSubview:imageView];
    UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, (indexPath.row+1)*10+100, 320, 50.0f);
    button.backgroundColor=[UIColor whiteColor];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button setTitle:webView.title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addWebView:) forControlEvents:UIControlEventTouchUpInside];
    [cell.cellContentView addSubview:button];
    return cell;
}


#pragma mark WKPagesCollectionViewDataSource Implementation

- (void)collectionView:(WKPagesCollectionView *)collectionView willRemoveCellAtIndexPath:(NSIndexPath *)indexPath {
    [_windows removeObjectAtIndex:(NSUInteger) indexPath.row];
}

- (void)willAppendItemInCollectionView:(WKPagesCollectionView *)collectionView {

//    //添加一个webView
//    [_windows addObject:@"new button"];
}


@end
