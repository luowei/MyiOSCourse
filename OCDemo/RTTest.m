//
//  RTTest.m
//  OCDemo
//
//  运行时编程示例。参考自:https://github.com/ming1016/study/wiki/Objc-Runtime
//
//  Created by luowei on 14/4/19.
//  Copyright (c) 2014年 luowei. All rights reserved.
//

#import "RTTest.h"
#import "MyClass.h"


@implementation RTTest


void TestMetaClass(id self, SEL _cmd) {

    NSLog(@"This objcet is %p", self);
    NSLog(@"Class is %@, super class is %@", [self class], [self superclass]);

    Class currentClass = [self class];
    //
    for (int i = 0; i < 4; i++) {
        NSLog(@"Following the isa pointer %d times gives %p", i, currentClass);
        //通过objc_getClass获得对象isa，这样可以回溯到Root class及NSObject的meta class，可以看到最后指针指向的是0x0和NSObject的meta class类地址一样。
        currentClass = objc_getClass((__bridge void *)currentClass);
    }

    NSLog(@"NSObject's class is %p", [NSObject class]);
    NSLog(@"NSObject's meta class is %p", objc_getClass((__bridge void *)[NSObject class]));
}

//动态创建类并绑定方法发送消息
- (void)ex_registerClassPair {

    //创建一个新类
    Class newClass = objc_allocateClassPair([NSError class], "TestClass", 0);
    //给新类动态添加方法
    class_addMethod(newClass, @selector(testMetaClass), (IMP)TestMetaClass, "v@:");
    //注册新添加的方法
    objc_registerClassPair(newClass);

    //构造新类的实例
    id instance = [[newClass alloc] initWithDomain:@"some domain" code:0 userInfo:nil];

    //发送消息
    [instance performSelector:@selector(testMetaClass)];
}


void imp_submethod1(){
    NSLog(@"run sub method 1");
}

//动态创建类及元类，并添加属性方法，及方法调用
-(void)dynamic_genClass{
    Class cls = objc_allocateClassPair(MyClass.class, "MySubClass", 0);
    class_addMethod(cls, @selector(submethod1), (IMP)imp_submethod1, "v@:");
    class_replaceMethod(cls, @selector(method1), (IMP)imp_submethod1, "v@:");
    class_addIvar(cls, "_ivar1", sizeof(NSString *), log(sizeof(NSString *)), "i");

    objc_property_attribute_t type = {"T", "@\"NSString\""};
    objc_property_attribute_t ownership = { "C", "" };
    objc_property_attribute_t backingivar = { "V", "_ivar1"};
    objc_property_attribute_t attrs[] = {type, ownership, backingivar};

    class_addProperty(cls, "property2", attrs, 3);
    objc_registerClassPair(cls);

    id instance = [[cls alloc] init];
    [instance performSelector:@selector(submethod1)];
    [instance performSelector:@selector(method1)];
}

//动态创建对象
-(void)dynamic_genInstance{
    //可以看出class_createInstance和alloc的不同
    id theObject = class_createInstance(NSString.class, sizeof(unsigned));
    id str1 = [theObject init];
    NSLog(@"%@", [str1 class]);
    id str2 = [[NSString alloc] initWithString:@"test"];
    NSLog(@"%@", [str2 class]);
}

//把a转换成占用更多空间的子类b
- (void)change_ClassInstance {
    NSObject *a = [[NSObject alloc] init];
    // 返回对象a的一份拷贝
    id newB = object_copy(a, class_getInstanceSize(MyClass.class));
    //设置对象newB的类
    object_setClass(newB, MyClass.class);
    // 释放对象a占用的内存
    object_dispose(a);
}

//获取类的信息
- (void)obtain_ClassInfo {
    int numClasses;
    Class * classes = NULL;
    // 获取已注册的类的数量
    numClasses = objc_getClassList(NULL, 0);

    if (numClasses > 0) {
        classes = malloc(sizeof(Class) * numClasses);
        // 获取已注册的类定义的列表
        numClasses = objc_getClassList(classes, numClasses);
        NSLog(@"number of classes: %d", numClasses);

        for (int i = 0; i < numClasses; i++) {
            Class cls = classes[i];
            NSLog(@"class name: %s", class_getName(cls));

            if(i > 20){
                NSLog(@"。。。。\n还有%d个类没输出",numClasses-20);
                break;
            }
/*
            // 返回指定类的类定义
            Class objc_lookUpClass ( const char *name );
            Class objc_getClass ( const char *name );
            Class objc_getRequiredClass ( const char *name );

            // 返回指定类的元类
            Class objc_getMetaClass ( const char *name );
*/
        }
        free(classes);
    }
}


//使用运行时函数操作MyClass类
- (void)test_MyClass{

    MyClass *myClass = [[MyClass alloc] init];
    unsigned int outCount = 0;
    Class cls = myClass.class;
    // 类名
    NSLog(@"class name: %s", class_getName(cls));
    NSLog(@"==========================================================");

    // 父类
    NSLog(@"super class name: %s", class_getName(class_getSuperclass(cls)));
    NSLog(@"==========================================================");

    // 是否是元类
    NSLog(@"MyClass is %@ a meta-class", (class_isMetaClass(cls) ? @"" : @"not"));
    NSLog(@"==========================================================");

    Class meta_class = objc_getMetaClass(class_getName(cls));
    NSLog(@"%s's meta-class is %s", class_getName(cls), class_getName(meta_class));
    NSLog(@"==========================================================");

    // 变量实例大小
    NSLog(@"instance size: %zu", class_getInstanceSize(cls));
    NSLog(@"==========================================================");

    // 成员变量
    Ivar *ivars = class_copyIvarList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        Ivar ivar = ivars[i];
        NSLog(@"instance variable's name: %s at index: %d", ivar_getName(ivar), i);
    }

    free(ivars);

    Ivar string = class_getInstanceVariable(cls, "_string");
    if (string != NULL) {
        NSLog(@"instace variable %s", ivar_getName(string));
    }

    NSLog(@"==========================================================");

    // 属性操作
    objc_property_t * properties = class_copyPropertyList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSLog(@"property's name: %s", property_getName(property));
    }

    free(properties);

    objc_property_t array = class_getProperty(cls, "array");
    if (array != NULL) {
        NSLog(@"property %s", property_getName(array));
    }

    NSLog(@"==========================================================");

    // 方法操作
    Method *methods = class_copyMethodList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        Method method = methods[i];
        NSLog(@"method's signature: %s", method_getName(method));
    }

    free(methods);

    Method method1 = class_getInstanceMethod(cls, @selector(method1));
    if (method1 != NULL) {
        NSLog(@"method %s", method_getName(method1));
    }

    Method classMethod = class_getClassMethod(cls, @selector(classMethod1));
    if (classMethod != NULL) {
        NSLog(@"class method : %s", method_getName(classMethod));
    }

    NSLog(@"MyClass is%@ responsd to selector: method3WithArg1:arg2:", class_respondsToSelector(cls, @selector(method3WithArg1:arg2:)) ? @"" : @" not");

    IMP imp = class_getMethodImplementation(cls, @selector(method1));
    imp();

    NSLog(@"==========================================================");

    // 协议
    Protocol * __unsafe_unretained * protocols = class_copyProtocolList(cls, &outCount);
    Protocol * protocol;
    for (int i = 0; i < outCount; i++) {
        protocol = protocols[i];
        NSLog(@"protocol name: %s", protocol_getName(protocol));
    }

    NSLog(@"MyClass is%@ responsed to protocol %s", class_conformsToProtocol(cls, protocol) ? @"" : @" not", protocol_getName(protocol));

    NSLog(@"==========================================================");

}


@end