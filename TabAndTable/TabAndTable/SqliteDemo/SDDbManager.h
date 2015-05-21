//
// Created by luowei on 15/5/21.
// Copyright (c) 2015 rootls. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Singleton.h"

@interface SDDbManager : NSObject

#pragma mark - 属性
#pragma mark 数据库引用，使用它进行数据库操作
@property (nonatomic) sqlite3 *database;
#pragma mark - 共有方法


singleton_interface(SDDbManager);
//+ (instancetype)sharedDbManager;

/**
*  打开数据库
*
*  @param dbname 数据库名称
*/
-(void)openDb:(NSString *)dbname;
/**
*  执行无返回值的sql
*
*  @param sql sql语句
*/
-(void)executeNonQuery:(NSString *)sql;
/**
*  执行有返回值的sql
*
*  @param sql sql语句
*
*  @return 查询结果
*/
-(NSArray *)executeQuery:(NSString *)sql;


@end