//
// Created by luowei on 15/3/10.
// Copyright (c) 2015 luowei. All rights reserved.
//

#include "NewCppClass.h"

#include <stdio.h>
#include <iostream>

@implementation NewCppClass

+(void)ccc{

    printf("Hello world 1 !");                   // 教科书的写法
    puts("Hello world 2 !");                     // 我最喜欢的
    puts("Hello" " " "world 3 !");               // 拼接字符串
    std::cout << "Hello world 4 !" << std::endl; // C++风格的教科书写法

}

@end