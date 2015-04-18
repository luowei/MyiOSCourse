//
//  RTTest.h
//  OCDemo
//
//  运行时编程示例。参考自:https://github.com/ming1016/study/wiki/Objc-Runtime
//
//  Created by luowei on 14/4/19.
//  Copyright (c) 2014年 luowei. All rights reserved.
//

#ifndef OCDemo_RTTest_h
#define OCDemo_RTTest_h


#endif

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface RTTest : NSObject

//动态创建类并绑定方法发送消息
- (void)ex_registerClassPair;

//使用运行时函数操作MyClass类
- (void)test_MyClass;

//动态创建类及元类，并添加属性方法，及方法调用
-(void)dynamic_genClass;

//动态创建对象
-(void)dynamic_genInstance;

//把a转换成占用更多空间的子类b
-(void)change_ClassInstance;

//获取类的信息
-(void)obtain_ClassInfo;

@end