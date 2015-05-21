//
//  CDUser.h
//  TabAndTable
//
//  Created by luowei on 15/5/21.
//  Copyright (c) 2015年 rootls. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDStatus;

@interface CDUser : NSManagedObject

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * mbtype;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * profileImageUrl;
@property (nonatomic, retain) NSString * screenName;
@property (nonatomic, retain) NSSet *status;
@end

@interface CDUser (CoreDataGeneratedAccessors)

- (void)addStatusObject:(CDStatus *)value;
- (void)removeStatusObject:(CDStatus *)value;
- (void)addStatus:(NSSet *)values;
- (void)removeStatus:(NSSet *)values;

@end
