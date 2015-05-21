//
// Created by luowei on 15/5/21.
// Copyright (c) 2015 rootls. All rights reserved.
//

#import "SDDatabaseCreator.h"
#import "SDDbManager.h"


@implementation SDDatabaseCreator {

}

+(void)initDatabase{
    NSString *key=@"IsCreatedDb";
    NSUserDefaults *defaults=[[NSUserDefaults alloc]init];
    if ([[defaults valueForKey:key] intValue]!=1) {
        [self createUserTable];
        [self createStatusTable];
        [defaults setValue:@1 forKey:key];
    }
}

+(void)createUserTable{
    NSString *sql=@"CREATE TABLE User (Id integer PRIMARY KEY AUTOINCREMENT,name text,screenName text, profileImageUrl text,mbtype text,city text)";
    [[SDDbManager sharedSDDbManager] executeNonQuery:sql];
}
+(void)createStatusTable{
    NSString *sql=@"CREATE TABLE Status (Id integer PRIMARY KEY AUTOINCREMENT,source text,createdAt date,\"text\" text,user integer REFERENCES User (Id))";
    [[SDDbManager sharedSDDbManager] executeNonQuery:sql];
}

@end