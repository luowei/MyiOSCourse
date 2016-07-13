//
//  ViewController.m
//  TabAndTable
//
//  Created by luowei on 15/5/19.
//  Copyright (c) 2015年 rootls. All rights reserved.
//

#import "ViewController.h"
#import "KeyBoardTypeViewController.h"
#import "ReturnTypeViewController.h"
#import "BaseKeyboardViewController.h"
#import "CustomeKeyboardViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong) UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    switch (indexPath.row){
        case 0:{
            cell.textLabel.text = @"键盘类型测试";
            break;
        }
        case 1:{
            cell.textLabel.text = @"返回键类型测试";
            break;
        }
        case 2:{
            cell.textLabel.text = @"第三方应用定制键盘工具栏";
            break;
        }
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIViewController *viewController = nil;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    switch (indexPath.row){
        case 0:{
            viewController = [KeyBoardTypeViewController new];
            viewController.title = cell.textLabel.text;
            viewController.view.backgroundColor = [UIColor whiteColor];
            break;
        }
        case 1:{
            viewController = [ReturnTypeViewController new];
            viewController.title = cell.textLabel.text;
            viewController.view.backgroundColor = [UIColor whiteColor];
            break;
        }
        case 2:{
            //viewController = [BaseKeyboardViewController new];
            viewController =  [CustomeKeyboardViewController new];
            viewController.title = cell.textLabel.text;
            viewController.view.backgroundColor = [UIColor whiteColor];
            break;
        }
        default:
            break;
    }
    
    [viewController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:viewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
