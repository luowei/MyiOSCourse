//
// Created by luowei on 15/5/21.
// Copyright (c) 2015 rootls. All rights reserved.
//

#import "FMDBViewController.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "Summary.h"

#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]


@interface FMDBViewController ()

@property(nonatomic, retain) NSString *dbPath;

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
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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


- (void)createTable{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:self.dbPath]) {
        // create it
        FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
        if ([db open]) {
            NSString *sql = @"CREATE TABLE summary ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL , 'content' VARCHAR(500), 'createTime' datetime default current_timestamp)";
            BOOL res = [db executeUpdate:sql];
            if (!res) {
                NSLog(@"error when creating db table");
            } else {
                NSLog(@"succ to creating db table");
            }
            [db close];
        } else {
            NSLog(@"error when open db");
        }
    }
}

- (void)insertContent:(NSString *)content {
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString *sql = @"insert into summary (content) values(?) ";
        BOOL res = [db executeUpdate:sql, content];
        if (!res) {
            NSLog(@"error to insert data");
        } else {
            NSLog(@"succ to insert data");
        }
        [db close];
    }
}

-(void)updateContent:(NSString *)content{
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString *sql = @"update summary set content = ? ";
        BOOL res = [db executeUpdate:sql, content];
        if (!res) {
            NSLog(@"error to insert data");
        } else {
            NSLog(@"succ to insert data");
        }
        [db close];
    }
}


- (NSArray *)queryData {
    NSMutableArray *data = @[].mutableCopy;
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString *sql = @"select * from summary";
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            Summary *summary = [[Summary alloc] initWithCreateAt:[rs dateForColumn:@"createTime"]
                                                         content:[rs stringForColumn:@"content"]
                                                              id:@([rs intForColumn:@"id"])];
            [data addObject:summary];
        }
        [db close];
    }
    return data.count > 0 ? [NSArray arrayWithArray:data] : nil;
}

- (void)clearAll{
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString *sql = @"delete from summary";
        BOOL res = [db executeUpdate:sql];
        if (!res) {
            NSLog(@"error to delete db data");
        } else {
            NSLog(@"succ to deleta db data");
        }
        [db close];
    }
}

- (void)multithread {
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.dbPath];
    dispatch_queue_t q1 = dispatch_queue_create("queue1", NULL);
    dispatch_queue_t q2 = dispatch_queue_create("queue2", NULL);

    dispatch_async(q1, ^{
        for (int i = 0; i < 100; ++i) {
            [queue inDatabase:^(FMDatabase *db) {
                NSString *sql = @"insert into summary (content) values(?) ";
                NSString *content = [NSString stringWithFormat:@"queue111 %d", i];
                BOOL res = [db executeUpdate:sql,content];
                if (!res) {
                    NSLog(@"error to add db data: %@", content);
                } else {
                    NSLog(@"succ to add db data: %@", content);
                }
            }];
        }
    });

    dispatch_async(q2, ^{
        for (int i = 0; i < 100; ++i) {
            [queue inDatabase:^(FMDatabase *db) {
                NSString *sql = @"insert into summary (content) values(?) ";
                NSString *content = [NSString stringWithFormat:@"queue222 %d", i];
                BOOL res = [db executeUpdate:sql,content];
                if (!res) {
                    NSLog(@"error to add db data: %@", content);
                } else {
                    NSLog(@"succ to add db data: %@", content);
                }
            }];
        }
    });
}


@end