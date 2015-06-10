//
// Created by luowei on 15/5/21.
// Copyright (c) 2015 rootls. All rights reserved.
//

#import "CoreDataViewController.h"
#import "CDUser.h"
#import "AppDelegate.h"
#import "CDStatus.h"
#import "SDStatusTableViewCell.h"
#import <CoreData/CoreData.h>


@interface CoreDataViewController ()
@property(nonatomic, strong) NSManagedObjectContext *context;
@end

@implementation CoreDataViewController {
    NSArray *_status;
    NSMutableArray *_statusCells;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createDbContext2];

//    [self addUserWithName:@"张三" screenName:@"zs" profileImageUrl:@"zs.png" mbtype:@"vip" city:@"ShangHai"];
//    [self addUserWithName:@"李四" screenName:@"ls" profileImageUrl:@"lisi.png" mbtype:@"commom" city:@"BeiJing"];
//    [self addUserWithName:@"王五" screenName:@"ww" profileImageUrl:@"wangwu.png" mbtype:@"low" city:@"GuangZhou"];
//
//    [self addStatusWithSource:@"来自iphone6" text:@"这是一条测试微博" username:@"张三" createDate:[NSDate date]];
//    [self addStatusWithSource:@"来自iphone6" text:@"测试微博测试微博测试微博测试微博测试微博" username:@"张三" createDate:[NSDate date]];
//    [self addStatusWithSource:@"来自iphone6" text:@"测试这一条微博测试这一条微测试这一条" username:@"李四" createDate:[NSDate date]];


//    //根据名字获得某一个实体
//    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Contact" inManagedObjectContext:self.context];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self loadStatusData];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}


- (NSManagedObjectContext *)createDbContext {
    //打开模型文件，参数为nil则打开包中所有模型文件并合并成一个
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    //创建解析器
    NSPersistentStoreCoordinator *storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    //创建数据库保存路径
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSLog(@"%@", dir);
    NSString *path = [dir stringByAppendingPathComponent:@"db.sqlite"];
    NSURL *url = [NSURL fileURLWithPath:path];
    //添加SQLite持久存储到解析器
    NSError *error;
    [storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    if (error) {
        NSLog(@"数据库打开失败！错误:%@", error.localizedDescription);
    } else {
        self.context = [[NSManagedObjectContext alloc] init];
        self.context.persistentStoreCoordinator = storeCoordinator;
        NSLog(@"数据库打开成功！");
    }

    return _context;
}


- (void)createDbContext2 {
//    //开启多线程锁
//    self.context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.context = [[NSManagedObjectContext alloc] init];
    self.context.undoManager = [[NSUndoManager alloc] init];

    //数据库文件存储路径
    NSURL *documentsDirectory = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask
                                                              appropriateForURL:nil create:YES error:NULL];
    NSURL *storeURL = [documentsDirectory URLByAppendingPathComponent:@"db.sqlite"];

    //模型映射文件
//    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CDModel" withExtension:@"xcdatamodeld"];
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CDModel" withExtension:@"momd"];
    NSManagedObjectModel *objectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];

    //加载模型映射并关联到数据库文件
    self.context.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:objectModel];
    NSError *error;
    [self.context.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                          configuration:nil URL:storeURL options:nil error:&error];
    if (error) {
        NSLog(@"error: %@", error);
    }
}

- (void)addUserWithName:(NSString *)name screenName:(NSString *)screenName
        profileImageUrl:(NSString *)profileImageUrl mbtype:(NSString *)mbtype city:(NSString *)city {
    //添加一个对象
    CDUser *us = [NSEntityDescription insertNewObjectForEntityForName:@"CDUser" inManagedObjectContext:self.context];
    us.name = name;
    us.screenName = screenName;
    us.profileImageUrl = profileImageUrl;
    us.mbtype = mbtype;
    us.city = city;
    NSError *error;
    //保存上下文
    if (![self.context save:&error]) {
        NSLog(@"添加过程中发生错误,错误信息：%@！", error.localizedDescription);
    }
}

- (void)addStatusWithSource:(NSString *)source text:(NSString *)text
        username:(NSString *)name createDate:(NSDate *)date {
    //添加一个对象
    CDStatus *status = [NSEntityDescription insertNewObjectForEntityForName:@"CDStatus" inManagedObjectContext:self.context];
    status.source = source;
    status.text = text;
    status.user = [self getUserByName:name];
    status.createdAt = date;

    NSError *error;
    //保存上下文
    if (![self.context save:&error]) {
        NSLog(@"添加过程中发生错误,错误信息：%@！", error.localizedDescription);
    }
}

- (NSArray *)getStatusesByUserName:(NSString *)name {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CDStatus"];
    request.predicate = [NSPredicate predicateWithFormat:@"user.name=%@", name];
    NSArray *array = [self.context executeFetchRequest:request error:nil];
    return array;
}

- (NSArray *)getUsersByStatusText:(NSString *)text screenName:(NSString *)screenName {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CDStatus"];
    request.predicate = [NSPredicate predicateWithFormat:@"text LIKE '*Watch*'", text];
    NSArray *statuses = [self.context executeFetchRequest:request error:nil];
    
    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"user.screenName=%@", screenName];
    NSArray *users = [statuses filteredArrayUsingPredicate:userPredicate];
    return users;
}

- (void)removeUser:(CDUser *)user {
    [self.context deleteObject:user];
    NSError *error;
    if (![self.context save:&error]) {
        NSLog(@"删除过程中发生错误，错误信息：%@!", error.localizedDescription);
    }
}

- (void)modifyUserWithName:(NSString *)name screenName:(NSString *)screenName
           profileImageUrl:(NSString *)profileImageUrl mbtype:(NSString *)mbtype city:(NSString *)city {
    CDUser *us = [self getUserByName:name];
    us.screenName = screenName;
    us.profileImageUrl = profileImageUrl;
    us.mbtype = mbtype;
    us.city = city;
    NSError *error;
    if (![self.context save:&error]) {
        NSLog(@"修改过程中发生错误,错误信息：%@", error.localizedDescription);
    }
}

- (CDUser *)getUserByName:(NSString *)name {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CDUser"];
    request.predicate = [NSPredicate predicateWithFormat:@"name=%@", name];
    NSArray *array = [self.context executeFetchRequest:request error:nil];
    return [array firstObject];
}

-(NSArray *)getAllWeiBoStatus{
    return [self.context executeFetchRequest:[NSFetchRequest fetchRequestWithEntityName:@"CDStatus"] error:nil];
}

#pragma mark 加载设置TableView的数据

#pragma mark 加载数据

- (void)loadStatusData {
    _statusCells = [[NSMutableArray alloc] init];
    _status = [self getAllWeiBoStatus];
    [_status enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SDStatusTableViewCell *cell = [[SDStatusTableViewCell alloc] init];
        cell.status = (SDStatus *) obj;
        [_statusCells addObject:cell];
    }];
    NSLog(@"%@", [_status lastObject]);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _status.count;
}

- (SDStatusTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identtityKey = @"myTableViewCellIdentityKey1";
    SDStatusTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identtityKey];
    if (cell == nil) {
        cell = [[SDStatusTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identtityKey];
    }
    cell.status = _status[(NSUInteger) indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ((SDStatusTableViewCell *) _statusCells[(NSUInteger) indexPath.row]).height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1.0f;
}


@end