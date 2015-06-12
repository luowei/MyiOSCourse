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
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"TABLECREATED_KEY"]) {

        [self addUsers];
        [self addStatus];

        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"TABLECREATED_KEY"];
    }

//    //根据名字获得某一个实体
//    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Contact" inManagedObjectContext:self.context];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self loadStatusData];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

#pragma mark 加载数据

- (void)addUsers {
    [self addUserWithName:@"Binger" screenName:@"aaaa" profileImageUrl:@"binger.jpg" mbtype:@"mbtype.png" city:@"北京"];
    [self addUserWithName:@"Xiaona" screenName:@"bbbb" profileImageUrl:@"xiaona.jpg" mbtype:@"mbtype.png" city:@"北京"];
    [self addUserWithName:@"Lily" screenName:@"cccc" profileImageUrl:@"lily.jpg" mbtype:@"mbtype.png" city:@"北京"];
    [self addUserWithName:@"Qianmo" screenName:@"dddd" profileImageUrl:@"qianmo.jpg" mbtype:@"mbtype.png" city:@"北京"];
    [self addUserWithName:@"Yanyue" screenName:@"eeee" profileImageUrl:@"yanyue.jpg" mbtype:@"mbtype.png" city:@"北京"];
}

- (void)addStatus {
    [self addStatusWithCreateAt:nil source:@"iPhone 6" text:@"一只雪aaaaaaaaa照片，获得了\"2014年野生动物摄影师\"大赛特等奖。一起来为猴子配个词" username:@"Binger"];
    [self addStatusWithCreateAt:nil source:@"iPhone 6" text:@"xxxxxx日本边泡温泉边玩iPhone的照片，获得了\"2014年野生动物摄影师\"大赛特等奖。一起来为猴子配个词" username:@"Binger"];
    [self addStatusWithCreateAt:nil source:@"iPhone 6" text:@"【eeeeeee ihone6了 要求很简单】真心回馈粉丝，小编觉得现在最好的奖品就是iPhone6了。今起到12月31日，关注我们，转发微博，就有机会获iPhone6(奖品可能需要等待)！每月抽一台[鼓掌]。不费事，还是试试吧，万一中了呢" username:@"Xiaona"];
    [self addStatusWithCreateAt:nil source:@"iPhone 6" text:@"重大新闻：蒂yxxxyxxxxxx 出柜后，ISIS战士怒扔iPhone，沙特神职人员呼吁人们换回iPhone 4。[via Pan-Arabia Enquirer]" username:@"Lily"];
    [self addStatusWithCreateAt:nil source:@"iPhone 6" text:@"ooooooooooppppp怎么往Iphone4S里倒东西？倒入的东西又该在哪里找？用了Iphone这么长时间，还真的不知道怎么弄！有谁知道啊？谢谢！" username:@"Qianmo"];
    [self addStatusWithCreateAt:nil source:@"iPhone 6" text:@"在bbbbbbbbbbb《Infinite 金明洙》，推荐给大家! " username:@"Binger"];
    [self addStatusWithCreateAt:nil source:@"iPhone 6" text:@"如pppppppppppp产品发展下去，不贪图手头节目源的现实利益，就木有苹果的ipod，也就木有iphone。柯达类似的现实利益，不自我革命的案例也是一种巨头的宿命。" username:@"Xiaona"];
    [self addStatusWithCreateAt:nil source:@"iPhone 6" text:@"【iadfadsfasdfadsa】新买的iPhone 7 Plus ，如何？够酷炫么？" username:@"Xiaona"];
    [self addStatusWithCreateAt:nil source:@"iPhone 6" text:@"自adsfasdadweqewqvzc 213 R500#，tr350S～价格美丽，行货，全国联保～iPhone6 iPhone6Plus卡西欧TR150 TR200 TR350 TR350S全面到货 招收各种代理！[给力]微信：39017366" username:@"Lily"];
    [self addStatusWithCreateAt:nil source:@"iPhone 6" text:@"猜到;lqemr109ruknzc[aei 所想者，再奖iPhone一部。（奖品由“2014年野生动物摄影师”评委会颁发）" username:@"Lily"];
}

- (void)loadStatusData {
    _statusCells = @[].mutableCopy;
    _status = [self getAllWeiBoStatus];
    [_status enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SDStatusTableViewCell *cell = [[SDStatusTableViewCell alloc] init];
        cell.status = (SDStatus *) obj;
        [_statusCells addObject:cell];
    }];
    NSLog(@"%@", [_status lastObject]);
}

#pragma mark 加载设置TableView的数据

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


#pragma mark CoreData 相关的数据操作

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

- (void)addStatusWithCreateAt:(NSDate *)date source:(NSString *)source
        text:(NSString *)text username:(NSString *)name  {
    //添加一个对象
    CDStatus *status = [NSEntityDescription insertNewObjectForEntityForName:@"CDStatus" inManagedObjectContext:self.context];
    status.source = source;
    status.text = text;
    status.user = [self getUserByName:name];
//    status.createdAt = date;

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

@end