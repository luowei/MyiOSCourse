//
//  BSListWebViewController.m
//  Webkit-Demo
//
//  Created by luowei on 15/6/24.
//  Copyright (c) 2015 rootls. All rights reserved.
//

#import "BSListWebViewController.h"

@interface BSListWebViewController()<UITableViewDataSource,UITableViewDelegate>


@property(nonatomic, weak) NSMutableArray *windows;
@end

@implementation BSListWebViewController


- (instancetype)initWithDataSource:(NSMutableArray *)array {
    self = [super init];
    if (self) {
        self.windows = array;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addWebView)];
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting"] style:UIBarButtonItemStylePlain target:self action:@selector(setting)];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];

    [self.view addSubview:self.tableView];


//    self.pageCollectionView = [WKPagesCollectionView alloc]
}



- (void)updateDatasource:(NSMutableArray *)array {
    self.windows = array;
}

//设置
- (void)setting {

}

//添加一个webView
- (void)addWebView {

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


#pragma mark UITableView DataSource Implementation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _windows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end
