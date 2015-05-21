//
// Created by luowei on 15/5/21.
// Copyright (c) 2015 rootls. All rights reserved.
//

#import "SDStatusService.h"
#import "SDStatus.h"
#import "SDDbManager.h"
#import "SDUserService.h"
#import "SDUser.h"


@implementation SDStatusService {

}

singleton_implementation(SDStatusService)

- (void)addStatus:(SDStatus *)status {
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO Status (source,createdAt,\"text\" ,user) VALUES('%@','%@','%@','%@')", status.source, status.createdAt, status.text, status.user.Id];
    [[SDDbManager sharedSDDbManager] executeNonQuery:sql];
}

- (void)removeStatus:(SDStatus *)status {
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM Status WHERE Id='%@'", status.Id];
    [[SDDbManager sharedSDDbManager] executeNonQuery:sql];
}

- (void)modifyStatus:(SDStatus *)status {
    NSString *sql = [NSString stringWithFormat:@"UPDATE Status SET source='%@',createdAt='%@',\"text\"='%@' ,user='%@' WHERE Id='%@'", status.source, status.createdAt, status.text, status.user, status.Id];
    [[SDDbManager sharedSDDbManager] executeNonQuery:sql];
}

- (SDStatus *)getStatusById:(int)Id {
    SDStatus *status = [[SDStatus alloc] init];
    NSString *sql = [NSString stringWithFormat:@"SELECT Id, source,createdAt,\"text\" ,user FROM Status WHERE Id='%i'", Id];
    NSArray *rows = [[SDDbManager sharedSDDbManager] executeQuery:sql];
    if (rows && rows.count > 0) {
        [status setValuesForKeysWithDictionary:rows[0]];
        status.user = [[SDUserService sharedSDUserService] getUserById:[(NSNumber *) rows[0][@"user"] intValue]];
    }
    return status;
}

- (NSArray *)getAllStatus {
    NSMutableArray *array = [NSMutableArray array];
    NSString *sql = @"SELECT Id, source,createdAt,\"text\" ,user FROM Status ORDER BY Id";
    NSArray *rows = [[SDDbManager sharedSDDbManager] executeQuery:sql];
    for (NSDictionary *dic in rows) {
        SDStatus *status = [self getStatusById:[(NSNumber *) dic[@"Id"] intValue]];
        [array addObject:status];
    }
    return array;
}

@end