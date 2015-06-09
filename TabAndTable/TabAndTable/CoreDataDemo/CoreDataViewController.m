//
// Created by luowei on 15/5/21.
// Copyright (c) 2015 rootls. All rights reserved.
//

#import "CoreDataViewController.h"
#import "CDUser.h"
#import <CoreData/CoreData.h>


@interface CoreDataViewController ()
@property(nonatomic, strong) NSManagedObjectContext *context;
@end

@implementation CoreDataViewController {

}

-(NSManagedObjectContext *)createDbContext{
    NSManagedObjectContext *context;
    //打开模型文件，参数为nil则打开包中所有模型文件并合并成一个
    NSManagedObjectModel *model=[NSManagedObjectModel mergedModelFromBundles:nil];
    //创建解析器
    NSPersistentStoreCoordinator *storeCoordinator=[[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
    //创建数据库保存路径
    NSString *dir=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSLog(@"%@",dir);
    NSString *path=[dir stringByAppendingPathComponent:@"myDatabase.db"];
    NSURL *url=[NSURL fileURLWithPath:path];
    //添加SQLite持久存储到解析器
    NSError *error;
    [storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    if(error){
        NSLog(@"数据库打开失败！错误:%@",error.localizedDescription);
    }else{
        context=[[NSManagedObjectContext alloc]init];
        context.persistentStoreCoordinator=storeCoordinator;
        NSLog(@"数据库打开成功！");
    }
    return context;
}

-(void)addUserWithName:(NSString *)name screenName:(NSString *)screenName
       profileImageUrl:(NSString *)profileImageUrl mbtype:(NSString *)mbtype city:(NSString *)city{
    //添加一个对象
    CDUser *us= [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.context];
    us.name=name;
    us.screenName=screenName;
    us.profileImageUrl=profileImageUrl;
    us.mbtype=mbtype;
    us.city=city;
    NSError *error;
    //保存上下文
    if (![self.context save:&error]) {
        NSLog(@"添加过程中发生错误,错误信息：%@！",error.localizedDescription);
    }
}

-(NSArray *)getStatusesByUserName:(NSString *)name{
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"Status"];
    request.predicate=[NSPredicate predicateWithFormat:@"user.name=%@",name];
    NSArray *array=[self.context executeFetchRequest:request error:nil];
    return  array;
}

-(NSArray *)getUsersByStatusText:(NSString *)text screenName:(NSString *)screenName{
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"Status"];
    request.predicate=[NSPredicate predicateWithFormat:@"text LIKE '*Watch*'",text];
    NSArray *statuses=[self.context executeFetchRequest:request error:nil];

    NSPredicate *userPredicate= [NSPredicate predicateWithFormat:@"user.screenName=%@",screenName];
    NSArray *users= [statuses filteredArrayUsingPredicate:userPredicate];
    return users;
}

-(void)removeUser:(CDUser *)user{
    [self.context deleteObject:user];
    NSError *error;
    if (![self.context save:&error]) {
        NSLog(@"删除过程中发生错误，错误信息：%@!",error.localizedDescription);
    }
}

-(void)modifyUserWithName:(NSString *)name screenName:(NSString *)screenName profileImageUrl:(NSString *)profileImageUrl mbtype:(NSString *)mbtype city:(NSString *)city{
    CDUser *us=[self getUserByName:name];
    us.screenName=screenName;
    us.profileImageUrl=profileImageUrl;
    us.mbtype=mbtype;
    us.city=city;
    NSError *error;
    if (![self.context save:&error]) {
        NSLog(@"修改过程中发生错误,错误信息：%@",error.localizedDescription);
    }
}

- (CDUser *)getUserByName:(NSString *)name {
    return nil;
}

@end