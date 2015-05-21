//
// Created by luowei on 15/5/21.
// Copyright (c) 2015 rootls. All rights reserved.
//

#import "SDUserService.h"
#import "SDUser.h"
#import "SDDbManager.h"


@implementation SDUserService {

}

singleton_implementation(SDUserService)

- (void)addUser:(SDUser *)user {
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO User (name,screenName, profileImageUrl,mbtype,city) VALUES('%@','%@','%@','%@','%@')", user.name, user.screenName, user.profileImageUrl, user.mbtype, user.city];
    [[SDDbManager sharedSDDbManager] executeNonQuery:sql];
}

- (void)removeUser:(SDUser *)user {
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM User WHERE Id='%@'", user.Id];
    [[SDDbManager sharedSDDbManager] executeNonQuery:sql];
}

- (void)removeUserByName:(NSString *)name {
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM User WHERE name='%@'", name];
    [[SDDbManager sharedSDDbManager] executeNonQuery:sql];
}

- (void)modifyUser:(SDUser *)user {
    NSString *sql = [NSString stringWithFormat:@"UPDATE User SET name='%@',screenName='%@',profileImageUrl='%@',mbtype='%@',city='%@' WHERE Id='%@'", user.name, user.screenName, user.profileImageUrl, user.mbtype, user.city, user.Id];
    [[SDDbManager sharedSDDbManager] executeNonQuery:sql];
}

- (SDUser *)getUserById:(int)Id {
    SDUser *user = [[SDUser alloc] init];
    NSString *sql = [NSString stringWithFormat:@"SELECT name,screenName,profileImageUrl,mbtype,city FROM User WHERE Id='%i'", Id];
    NSArray *rows = [[SDDbManager sharedSDDbManager] executeQuery:sql];
    if (rows && rows.count > 0) {
        [user setValuesForKeysWithDictionary:rows[0]];
    }
    return user;
}

- (SDUser *)getUserByName:(NSString *)name {
    SDUser *user = [[SDUser alloc] init];
    NSString *sql = [NSString stringWithFormat:@"SELECT Id, name,screenName,profileImageUrl,mbtype,city FROM User WHERE name='%@'", name];
    NSArray *rows = [[SDDbManager sharedSDDbManager] executeQuery:sql];
    if (rows && rows.count > 0) {
        [user setValuesForKeysWithDictionary:rows[0]];
    }
    return user;
}

@end