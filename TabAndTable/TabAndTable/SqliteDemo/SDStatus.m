//
// Created by luowei on 15/5/21.
// Copyright (c) 2015 rootls. All rights reserved.
//

#import "SDStatus.h"
#import "SDUser.h"


@implementation SDStatus {

}

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
        self.user = [[SDUser alloc] init];
        self.user.Id = dic[@"user"];
    }
    return self;
}

- (instancetype)initWithCreateAt:(NSString *)createAt source:(NSString *)source text:(NSString *)text user:(SDUser *)user {
    if (self = [super init]) {
        self.createdAt = createAt;
        self.source = source;
        self.text = text;
        self.user = user;
    }
    return self;
}

- (instancetype)initWithCreateAt:(NSString *)createAt source:(NSString *)source text:(NSString *)text userId:(int)userId {
    if (self = [super init]) {
        self.createdAt = createAt;
        self.source = source;
        self.text = text;
        SDUser *user = [[SDUser alloc] init];
        user.Id = @(userId);
        self.user = user;
    }
    return self;
}

- (NSString *)source {
    return [NSString stringWithFormat:@"来自 %@", _source];
}

+ (instancetype)statusWithCreateAt:(NSString *)createAt source:(NSString *)source text:(NSString *)text user:(SDUser *)user {
    SDStatus *status = [[SDStatus alloc] initWithCreateAt:createAt source:source text:text user:user];
    return status;
}

+ (instancetype)statusWithCreateAt:(NSString *)createAt source:(NSString *)source text:(NSString *)text userId:(int)userId {
    SDStatus *status = [[SDStatus alloc] initWithCreateAt:createAt source:source text:text userId:userId];
    return status;
}


@end