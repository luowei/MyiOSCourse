//
//  main.m
//  OCDemo
//
//  Created by luowei on 15/3/10.
//  Copyright (c) 2015 luowei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewClass.h"
#import "NewCppClass.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");

        [NewClass bbb];

        NewClass *newClass =[[NewClass alloc] init];
        [newClass aaa];

        [NewCppClass ccc];
    }

    return 0;
}