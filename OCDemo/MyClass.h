//
//  MyClass.h
//  OCDemo
//
//  Created by luowei on 14/4/19.
//  Copyright (c) 2014年 luowei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyClass : NSObject<NSCopying, NSCoding>
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, copy) NSString *string;
- (void)method1;
- (void)method2;
+ (void)classMethod1;

@end
