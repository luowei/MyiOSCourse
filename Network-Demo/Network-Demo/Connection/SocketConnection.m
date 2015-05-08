//
//  SocketConnection.m
//  KeyboardTouch
//
//  Created by luowei on 15/1/21.
//  Copyright (c) 2015 2345. All rights reserved.
//

#import "SocketConnection.h"

@implementation SocketConnection


#pragma mark SocketConnectionDelegate Implement

- (void)connectToHost:(NSString *)host port:(NSString *)port {
//    NSLog(@"Connecting to \"%@\" on port %@...", host, port);

    NSError *error = nil;
    _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    if (![_socket connectToHost:host onPort:(uint16_t) port.intValue error:&error]) {
//        NSLog(@"Error connecting: %@", error);
        @throw [NSException exceptionWithName:@"连接失败！"
                                       reason:[NSString stringWithFormat:@"faild connecting to server:%@ at port:%@  \nError:%@", host, port,error.description]
                                     userInfo:nil];
    }
}

- (void)disConnectSocket {
    [_socket disconnect];
    _socket = nil;
//    NSLog(@"Disconnected from Server");
}

#pragma mark 发送消息

- (void)sendMessage:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [_socket writeData:data withTimeout:-1 tag:0];

//    NSLog(@"我发送:%@",string);
    [_socket readDataWithTimeout:-1 tag:0];
}

- (void)sendData:(NSData *)data {
    [_socket writeData:data withTimeout:-1 tag:0];
}


#pragma mark -----------------------------------------

#pragma mark -- GCDAsyncSocketDelegate Implements --

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
//    NSLog(@"socket:%@  连接到:%@ 端口:%hu \n", sock, host, port);

    NSMutableData *sendData;

/*
    int type = KT_DEFS_CONNECT;
    sendData = [AppContext fillContentToData:sendData type:&type header:PACKAGE_HEADER content:@"I'm Client !"];
*/

    [_socket writeData:sendData withTimeout:-1 tag:0];

    [_socket readDataWithTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {

    //如果消息不为空
//    if (data) {
//        //读取消息
//        if(data.length > sizeof(KTPackageHeader)){
//            KTPackage *ktPackage = (KTPackage *)data.bytes;
//
//           if( ktPackage->m_header.m_type == KT_DEFS_CONNECT){
//
//           }
//        }

//    }else{
//
//    }

}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
//    NSLog(@"-----didWriteDataWithTag-----");

//    [sock readDataWithTimeout:-1 tag:0];
}


- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
//    NSLog(@"已断开 socket 连接");

    if([self.delegate respondsToSelector:@selector(alertDisConnectedError:)]){

        NSException *except = [NSException exceptionWithName:@"连接断开"
                                                      reason:[NSString stringWithFormat:@"disconnnected the socket connection !"]
                                                    userInfo:nil];
        [self.delegate alertDisConnectedError:except];
    }
}


@end
