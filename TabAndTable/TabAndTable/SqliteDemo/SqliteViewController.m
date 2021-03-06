//
// Created by luowei on 15/5/21.
// Copyright (c) 2015 rootls. All rights reserved.
//

#import "SqliteViewController.h"
#import "SDDatabaseCreator.h"
#import "SDUser.h"
#import "SDUserService.h"
#import "SDStatus.h"
#import "SDStatusService.h"
#import "SDStatusTableViewCell.h"

@interface SqliteViewController () {
    NSArray *_status;
    NSMutableArray *_statusCells;
}
@end

@implementation SqliteViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [SDDatabaseCreator initDatabase];

//    [self.tableView registerClass:[SDStatusTableViewCell class] forCellReuseIdentifier:@"myTableViewCellIdentityKey1"];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    NSString *key=@"IsAddData";
    NSUserDefaults *defaults=[[NSUserDefaults alloc]init];
    if ([[defaults valueForKey:key] intValue]!=1) {

        [self addUsers];
        [self addStatus];

        [defaults setValue:@1 forKey:key];
    }

//    [self removeUser];
//    [self modifyUserInfo];

//    [defaults setValue:@0 forKey:key];

    [self loadStatusData];

    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

/*
    [[SDStatusService sharedSDStatusService] removeAllStatus];
    [[SDUserService sharedSDUserService] removeAllUser];

    NSString *key=@"IsAddData";
    NSUserDefaults *defaults=[[NSUserDefaults alloc]init];
    [defaults setValue:@0 forKey:key];
*/

}

- (void)addUsers {
    SDUser *user1 = [SDUser userWithName:@"Binger" screenName:@"冰儿" profileImageUrl:@"binger.jpg" mbtype:@"mbtype.png" city:@"北京"];
    [[SDUserService sharedSDUserService] addUser:user1];
    SDUser *user2 = [SDUser userWithName:@"Xiaona" screenName:@"小娜" profileImageUrl:@"xiaona.jpg" mbtype:@"mbtype.png" city:@"北京"];
    [[SDUserService sharedSDUserService] addUser:user2];
    SDUser *user3 = [SDUser userWithName:@"Lily" screenName:@"丽丽" profileImageUrl:@"lily.jpg" mbtype:@"mbtype.png" city:@"北京"];
    [[SDUserService sharedSDUserService] addUser:user3];
    SDUser *user4 = [SDUser userWithName:@"Qianmo" screenName:@"阡陌" profileImageUrl:@"qianmo.jpg" mbtype:@"mbtype.png" city:@"北京"];
    [[SDUserService sharedSDUserService] addUser:user4];
    SDUser *user5 = [SDUser userWithName:@"Yanyue" screenName:@"炎月" profileImageUrl:@"yanyue.jpg" mbtype:@"mbtype.png" city:@"北京"];
    [[SDUserService sharedSDUserService] addUser:user5];
}

- (void)addStatus {
    SDStatus *status1 = [SDStatus statusWithCreateAt:@"9:00" source:@"iPhone 6" text:@"一只雪猴在日本边泡温泉边玩iPhone的照片，获得了\"2014年野生动物摄影师\"大赛特等奖。一起来为猴子配个词" userId:1];
    [[SDStatusService sharedSDStatusService] addStatus:status1];
    SDStatus *status2 = [SDStatus statusWithCreateAt:@"9:00" source:@"iPhone 6" text:@"一只雪猴在日本边泡温泉边玩iPhone的照片，获得了\"2014年野生动物摄影师\"大赛特等奖。一起来为猴子配个词" userId:1];
    [[SDStatusService sharedSDStatusService] addStatus:status2];
    SDStatus *status3 = [SDStatus statusWithCreateAt:@"9:30" source:@"iPhone 6" text:@"【我们送iPhone6了 要求很简单】真心回馈粉丝，小编觉得现在最好的奖品就是iPhone6了。今起到12月31日，关注我们，转发微博，就有机会获iPhone6(奖品可能需要等待)！每月抽一台[鼓掌]。不费事，还是试试吧，万一中了呢" userId:2];
    [[SDStatusService sharedSDStatusService] addStatus:status3];
    SDStatus *status4 = [SDStatus statusWithCreateAt:@"9:45" source:@"iPhone 6" text:@"重大新闻：蒂姆库克宣布出柜后，ISIS战士怒扔iPhone，沙特神职人员呼吁人们换回iPhone 4。[via Pan-Arabia Enquirer]" userId:3];
    [[SDStatusService sharedSDStatusService] addStatus:status4];
    SDStatus *status5 = [SDStatus statusWithCreateAt:@"10:05" source:@"iPhone 6" text:@"小伙伴们，有谁知道怎么往Iphone4S里倒东西？倒入的东西又该在哪里找？用了Iphone这么长时间，还真的不知道怎么弄！有谁知道啊？谢谢！" userId:4];
    [[SDStatusService sharedSDStatusService] addStatus:status5];
    SDStatus *status6 = [SDStatus statusWithCreateAt:@"10:07" source:@"iPhone 6" text:@"在音悦台iPhone客户端里发现一个悦单《Infinite 金明洙》，推荐给大家! " userId:1];
    [[SDStatusService sharedSDStatusService] addStatus:status6];
    SDStatus *status7 = [SDStatus statusWithCreateAt:@"11:20" source:@"iPhone 6" text:@"如果sony吧mp3播放器产品发展下去，不贪图手头节目源的现实利益，就木有苹果的ipod，也就木有iphone。柯达类似的现实利益，不自我革命的案例也是一种巨头的宿命。" userId:2];
    [[SDStatusService sharedSDStatusService] addStatus:status7];
    SDStatus *status8 = [SDStatus statusWithCreateAt:@"13:00" source:@"iPhone 6" text:@"【iPhone 7 Plus】新买的iPhone 7 Plus ，如何？够酷炫么？" userId:2];
    [[SDStatusService sharedSDStatusService] addStatus:status8];
    SDStatus *status9 = [SDStatus statusWithCreateAt:@"13:24" source:@"iPhone 6" text:@"自拍神器#卡西欧TR500#，tr350S～价格美丽，行货，全国联保～iPhone6 iPhone6Plus卡西欧TR150 TR200 TR350 TR350S全面到货 招收各种代理！[给力]微信：39017366" userId:3];
    [[SDStatusService sharedSDStatusService] addStatus:status9];
    SDStatus *status10 = [SDStatus statusWithCreateAt:@"13:26" source:@"iPhone 6" text:@"猜到猴哥玩手机时所思所想者，再奖iPhone一部。（奖品由“2014年野生动物摄影师”评委会颁发）" userId:3];
    [[SDStatusService sharedSDStatusService] addStatus:status10];
}

- (void)removeUser {
    //注意在SQLite中区分大小写
    [[SDUserService sharedSDUserService] removeUserByName:@"Yanyue"];
}

- (void)modifyUserInfo {
    SDUser *user1 = [[SDUserService sharedSDUserService] getUserByName:@"Xiaona"];
    user1.city = @"上海";
    [[SDUserService sharedSDUserService] modifyUser:user1];

    SDUser *user2 = [[SDUserService sharedSDUserService] getUserByName:@"Lily"];
    user2.city = @"深圳";
    [[SDUserService sharedSDUserService] modifyUser:user2];
}


#pragma mark 加载数据

- (void)loadStatusData {
//    _statusCells = [[NSMutableArray alloc] init];
    _status = [[SDStatusService sharedSDStatusService] getAllStatus];
    [_status enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SDStatusTableViewCell *cell = [[SDStatusTableViewCell alloc] init];
        cell.status = (SDStatus *) obj;
//        [_statusCells addObject:cell];
    }];
    NSLog(@"%@", [_status lastObject]);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _status.count;
}

- (SDStatusTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identtityKey = @"myTableViewCellIdentityKey1";
    SDStatusTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identtityKey];
    if (cell == nil) {
        cell = [[SDStatusTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identtityKey];
    }
    cell.status = _status[(NSUInteger) indexPath.row];
    return cell;
//    return _statusCells[(NSUInteger) indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ((SDStatusTableViewCell *) _statusCells[(NSUInteger) indexPath.row]).height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1.0f;
}

@end