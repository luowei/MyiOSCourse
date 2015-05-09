//
// Created by luowei on 15/5/9.
// Copyright (c) 2015 rootls. All rights reserved.
//

#import <sys/socket.h>
#import <netinet/in.h>
#import "BSDSocketServer.h"


#define MAXBUF  256

@implementation BSDSocketServer {

}

#pragma mark 创建服务端

- (void)setUpServer {

    int identifierCount = 0;

    int server_sockfd, client_sockfd;
    int client_len, n;
    char buf[MAXBUF];
    struct sockaddr_in clientaddr, serveraddr;

    client_len = sizeof(clientaddr);

    //构造服务端的Socket
    if ((server_sockfd = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
        perror("socket error : ");
        exit(0);
    }

    //设置服务地址并绑定到socket
    bzero(&serveraddr, sizeof(serveraddr));
    serveraddr.sin_family = AF_INET;
    serveraddr.sin_addr.s_addr = htonl(INADDR_ANY);
    serveraddr.sin_port = htons(10000);
    bind(server_sockfd, (struct sockaddr *) &serveraddr, sizeof(serveraddr));

    //启动服务端监听
    listen(server_sockfd, 5);

    while (1) {
        memset(buf, 0x00, MAXBUF);
        client_sockfd = accept(server_sockfd, (struct sockaddr *) &clientaddr,
                &client_len);
        printf("something connected!\n");

        while (1) {
            identifierCount += 1;
            if ((n = read(client_sockfd, buf, MAXBUF)) <= 0) {
                close(client_sockfd);
                break;
            }

            printf("buf in the server : %s\n", buf);

            memset(buf, 0x00, MAXBUF);
            sprintf(buf, "response from server : %d!\n", identifierCount);

            if (write(client_sockfd, buf, MAXBUF) <= 0) {
                perror("write error : ");
                close(client_sockfd);
                break;
            }
            memset(buf, 0x00, MAXBUF);
        }
        close(client_sockfd);
    }
}

@end