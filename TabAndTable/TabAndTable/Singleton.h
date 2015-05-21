//
//  Singleton.h
//  TabAndTable
//
//  Created by luowei on 15/5/21.
//  Copyright (c) 2015 rootls. All rights reserved.
//

#ifndef TabAndTable_Singleton____FILEEXTENSION___
#define TabAndTable_Singleton____FILEEXTENSION___


// @interface
#define singleton_interface(className) \
+ (className *)shared##className;


// @implementation
#define singleton_implementation(className) \
static className *_instance; \
+ (id)allocWithZone:(NSZone *)zone \
{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instance = [super allocWithZone:zone]; \
    }); \
    return _instance; \
} \
+ (className *)shared##className \
{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instance = [[self alloc] init]; \
    }); \
    return _instance; \
}

#endif
