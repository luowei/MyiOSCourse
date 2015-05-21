//
// Created by luowei on 15/5/21.
// Copyright (c) 2015 rootls. All rights reserved.
//

#import "SDUser.h"


@implementation SDUser {

}

- (instancetype)initWithName:(NSString *)name screenName:(NSString *)screenName profileImageUrl:(NSString *)profileImageUrl
                      mbtype:(NSString *)mbtype city:(NSString *)city {
    if (self = [super init]) {
        self.name = name;
        self.screenName = screenName;
        self.profileImageUrl = profileImageUrl;
        self.mbtype = mbtype;
        self.city = city;
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (instancetype)userWithName:(NSString *)name screenName:(NSString *)screenName profileImageUrl:(NSString *)profileImageUrl
                      mbtype:(NSString *)mbtype city:(NSString *)city {
    SDUser *user = [[SDUser alloc] initWithName:name screenName:screenName profileImageUrl:profileImageUrl mbtype:mbtype city:city];
    return user;
}

@end