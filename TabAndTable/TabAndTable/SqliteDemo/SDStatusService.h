//
// Created by luowei on 15/5/21.
// Copyright (c) 2015 rootls. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@class SDStatus;


@interface SDStatusService : NSObject

singleton_interface(SDStatusService)
/**
*  添加微博信息
*
*  @param status 微博对象
*/
-(void)addStatus:(SDStatus *)status;
/**
*  删除微博
*
*  @param status 微博对象
*/
-(void)removeStatus:(SDStatus *)status;
/**
*  修改微博内容
*
*  @param status 微博对象
*/
-(void)modifyStatus:(SDStatus *)status;
/**
*  根据编号取得微博
*
*  @param Id 微博编号
*
*  @return 微博对象
*/
-(SDStatus *)getStatusById:(int)Id;
/**
*  取得所有微博对象
*
*  @return 所有微博对象
*/
-(NSArray *)getAllStatus;

- (void)removeAllStatus;
@end