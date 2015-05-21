//
//  CDStatus.h
//  TabAndTable
//
//  Created by luowei on 15/5/21.
//  Copyright (c) 2015年 rootls. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject;

@interface CDStatus : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSManagedObject *user;

@end
