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
#import "RTTest.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");

        [NewClass bbb];

        NewClass *newClass =[[NewClass alloc] init];
        [newClass aaa];

        [NewCppClass ccc];

        NSLog(@"\n***********************************\n");

        RTTest *rtTest = [RTTest new];

        //动态生成类及添加方法，并发送消息
        [rtTest ex_registerClassPair];

        NSLog(@"\n***********************************\n");
        //测试MyClass类的输出
        [rtTest test_MyClass];

        NSLog(@"\n***********************************\n");
        //动态创建类及元类，并添加属性方法，及方法调用
        [rtTest dynamic_genClass];

        NSLog(@"\n***********************************\n");
        //动态创建对象
        [rtTest dynamic_genInstance];

        NSLog(@"\n***********************************\n");
        //把a转换成占用更多空间的子类b
        [rtTest change_ClassInstance];

        NSLog(@"\n***********************************\n");
        //获取类的信息
        [rtTest obtain_ClassInfo];
    }

    return 0;
}