//
// Created by luowei on 15/5/21.
// Copyright (c) 2015 rootls. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@class SDUser;


@interface SDUserService : NSObject

singleton_interface(SDUserService)

/**
*  添加用户信息
*
*  @param user 用户对象
*/
- (void)addUser:(SDUser *)user;

/**
*  删除用户
*
*  @param user 用户对象
*/
- (void)removeUser:(SDUser *)user;

/**
*  根据用户名删除用户
*
*  @param name 用户名
*/
- (void)removeUserByName:(NSString *)name;

/**
*  修改用户内容
*
*  @param user 用户对象
*/
- (void)modifyUser:(SDUser *)user;

/**
*  根据用户编号取得用户
*
*  @param Id 用户编号
*
*  @return 用户对象
*/
- (SDUser *)getUserById:(int)Id;

/**
*  根据用户名取得用户
*
*  @param name 用户名
*
*  @return 用户对象
*/
- (SDUser *)getUserByName:(NSString *)name;

- (void)removeAllUser;
@end