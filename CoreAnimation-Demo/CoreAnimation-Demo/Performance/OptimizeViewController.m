//
//  OptimizeViewController.m
//  CoreAnimation-Demo
//
//  Created by luowei on 15/4/18.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import "OptimizeViewController.h"

@interface OptimizeViewController ()
@property(nonatomic, strong) NSArray *items;
@property(nonatomic, strong) UITableView *tableView;
@end

@implementation OptimizeViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    //register cell class
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

    //set up data
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 1000; i++) {
            //add name
            [array addObject:@{@"name" : [self randomName], @"image" : [self randomAvatar]}];
    }
    self.items = array;
}


- (NSString *)randomName {
    NSArray *first = @[@"Alice", @"Bob", @"Bill", @"Charles", @"Dan", @"Dave", @"Ethan", @"Frank"];
    NSArray *last = @[@"Appleseed", @"Bandicoot", @"Caravan", @"Dabble", @"Ernest", @"Fortune"];
    NSUInteger index1 = (rand() / (double) INT_MAX) * [first count];
    NSUInteger index2 = (rand() / (double) INT_MAX) * [last count];
    return [NSString stringWithFormat:@"%@ %@", first[index1], last[index2]];
}

- (NSString *)randomAvatar {
    NSArray *images = @[@"Ship1", @"Ship2", @"Ship3", @"Ship4", @"Ship5", @"Ship6", @"Ship7", @"Ship8", @"Ship9", @"Ship10"];
    NSUInteger index = (rand() / (double) INT_MAX) * [images count];
    return images[index];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //dequeue cell
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    //load image
    NSDictionary *item = self.items[indexPath.row];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:item[@"image"] ofType:@"png"];
    //set image and text
    cell.imageView.image = [UIImage imageWithContentsOfFile:filePath];

//    cell.imageView.image = [UIImage imageNamed:item[@"image"]];

    cell.textLabel.text = item[@"name"];
    //set image shadow
    cell.imageView.layer.shadowOffset = CGSizeMake(0, 5);
    cell.imageView.layer.shadowOpacity = 0.75;
    cell.clipsToBounds = YES;
    //set text shadow
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.layer.shadowOffset = CGSizeMake(0, 2);
    cell.textLabel.layer.shadowOpacity = 0.5;

//    使用shouldRasterize来缓存图层内容,提高性能
    //rasterize,栅格化
//    cell.layer.shouldRasterize = YES;
//    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;

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
