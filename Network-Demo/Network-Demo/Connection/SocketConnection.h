//
//  SocketConnection.h
//  KeyboardTouch
//
//  Created by luowei on 15/1/21.
//  Copyright (c) 2015 2345. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

@protocol SocketConnectionProtol<NSObject>

-(void)alertDisConnectedError:(NSException *)exception;

@end


@interface SocketConnection : NSObject<GCDAsyncSocketDelegate>

@property(nonatomic, assign) id <SocketConnectionProtol> delegate;

@property(nonatomic, strong) GCDAsyncSocket *socket;


//#pragma mark 创建socket
//
//-(instancetype)createSocket;

#pragma mark 连接

- (void)connectToHost:(NSString *)host port:(NSString *)port;

#pragma mark 断开连接

- (void)disConnectSocket;

#pragma mark 发送消息

- (void)sendMessage:(NSString *)string;
- (void)sendData:(NSData *)data;

@end
