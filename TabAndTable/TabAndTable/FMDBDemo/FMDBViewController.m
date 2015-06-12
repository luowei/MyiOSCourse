//
// Created by luowei on 15/5/21.
// Copyright (c) 2015 rootls. All rights reserved.
//

#import "FMDBViewController.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "Summary.h"
#import "AwarenessViewController.h"

#define PATH_OF_DOCUMENT    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]


@interface FMDBViewController ()

@property(nonatomic, retain) NSString *dbPath;

@property(nonatomic, strong) NSMutableArray *awarenessList;
@end

@implementation FMDBViewController {
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *doc = PATH_OF_DOCUMENT;
    NSString *path = [doc stringByAppendingPathComponent:@"summary.sqlite"];
    self.dbPath = path;
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"TABLECREATED_KEY"]) {
        BOOL res = [self createTable];
        [[NSUserDefaults standardUserDefaults] setBool:res forKey:@"TABLECREATED_KEY"];
    }
    
    self.awarenessList = @[].mutableCopy;
    [self.awarenessList addObjectsFromArray:[self listContent]];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                           target:self
                                                                                           action:@selector(addTabItems)];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark TableViewDatasource Implements

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.awarenessList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"CellId";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    Summary *summary = (Summary *) _awarenessList[(NSUInteger) indexPath.row];
    cell.tag = [summary._id integerValue];
    cell.textLabel.text = summary.content;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    cell.detailTextLabel.text = [formatter stringFromDate:summary.createTime];

    return cell;
}

#pragma mark TableViewDelegate Implements

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    [self deleteById:(@(cell.tag))];

    [_awarenessList removeObjectAtIndex:(NSUInteger) indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

//编辑一条记录
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    [self modifyOftenuseWordsList:indexPath cell:cell];
    AwarenessViewController *viewController = [AwarenessViewController new];
    viewController.awareness = cell.textLabel.text;
    viewController.title = @"编辑记录";
    viewController.updateAwarenessItemBlock = ^(NSString *awareness) {
        if (awareness == nil || [[awareness stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
            return;
        }
        [self updateContent:awareness byId:@(cell.tag)];
        _awarenessList[(NSUInteger) indexPath.row] = [self findById:@(cell.tag)];
    };

    [viewController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark 私有操作方法

//添加一条记录
- (void)addTabItems {
    AwarenessViewController *viewController = [AwarenessViewController new];
    viewController.title = @"添加记录";

    //添加感悟回调block
    viewController.updateAwarenessItemBlock = ^(NSString *awareness) {
        if (awareness == nil || [[awareness stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
            return;
        }

        [self insertContent:awareness];
        Summary *summary = [self findByContent:awareness][0];
        [_awarenessList insertObject:summary atIndex:0];
    };

    [viewController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark 数据库操作，增删改查

- (BOOL)createTable {
    
    BOOL res = NO;
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.dbPath]) {
        // create it
        FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
        if ([db open]) {
            NSString *sql = @"CREATE TABLE summary ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL , \
                    'content' VARCHAR(500), 'createTime' datetime default current_timestamp)";
            res = [db executeUpdate:sql];
        }
    }
    return res;
}

- (BOOL)insertContent:(NSString *)content {
    BOOL res = NO;
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString *sql = @"insert into summary (content) values(?) ";
        res = [db executeUpdate:sql, content];
        [db close];
    }
    return res;
}

- (BOOL)updateContent:(NSString *)content byId:(NSNumber *)_id {
    BOOL res = NO;
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString *sql = @"update summary set content = ? where id = ?";
        res = [db executeUpdate:sql, content, _id];
        [db close];
    }
    return res;
}

- (Summary *)findById:(NSNumber *)_id {
    Summary *summary = nil;
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString *sql = @"select * from summary where id = ?";
        FMResultSet *rs = [db executeQuery:sql, _id];
        while ([rs next]) {
            NSString *createTimeStr = [rs stringForColumn:@"createTime"];
            NSDate *createTime = [self getDateFromString:createTimeStr];
            
            summary = [[Summary alloc] initWithCreateAt:createTime
                                                content:[rs stringForColumn:@"content"]
                                                     id:@([rs intForColumn:@"id"])];
        }
        [db close];
    }
    return summary;
}

- (NSArray *)findByContent:(NSString *)awareness {
    NSMutableArray *data = @[].mutableCopy;
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString *sql = @"select * from summary where content == ? order by id desc";
        FMResultSet *rs = [db executeQuery:sql, awareness];
        while ([rs next]) {
            NSString *createTimeStr = [rs stringForColumn:@"createTime"];
            NSDate *createTime = [self getDateFromString:createTimeStr];
            Summary *summary = [[Summary alloc] initWithCreateAt:createTime
                                                         content:[rs stringForColumn:@"content"]
                                                              id:@([rs intForColumn:@"id"])];
            [data addObject:summary];
        }
        [db close];
    }
    return data.count > 0 ? data : nil;
}

- (NSArray *)listContent {
    NSMutableArray *data = @[].mutableCopy;
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString *sql = @"select * from summary order by id desc";
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NSString *createTimeStr = [rs stringForColumn:@"createTime"];
            NSDate *createTime = [self getDateFromString:createTimeStr];
            
            Summary *summary = [[Summary alloc] initWithCreateAt:createTime
                                                         content:[rs stringForColumn:@"content"]
                                                              id:@([rs intForColumn:@"id"])];
            [data addObject:summary];
        }
        [db close];
    }
    return data.count > 0 ? data : nil;
}


- (BOOL)deleteById:(NSNumber *)_id {
    BOOL res = NO;
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString *sql = @"delete from summary where id = ?";
        res = [db executeUpdate:sql,_id];
        [db close];
    }
    return res;
}

- (BOOL)clearAll {
    BOOL res = NO;
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString *sql = @"delete from summary";
        res = [db executeUpdate:sql];
        [db close];
    }
    return res;
}

- (NSDate *)getDateFromString:(NSString *)createTimeStr {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter dateFromString:createTimeStr];
}

@end