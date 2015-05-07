//
//  LoadingPic.m
//  CFNetWork-Demo
//
//  Created by luowei on 15/5/7.
//  Copyright (c) 2015年 rootls. All rights reserved.
//

#import "LoadingPic.h"

@interface LoadingPic() <NSURLConnectionDataDelegate> {
    BOOL done;
    long total;

    NSMutableData *characterBuffer;
    NSURLConnection *connect;
    UIProgressView *prg_Bar;
}

@end

@implementation LoadingPic

- (id)initWithFrame:(CGRect)frame url:(NSString *)_url {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setImage:[UIImage imageNamed:@"imgPlaceholder"]];
        //启动线程
        [NSThread detachNewThreadSelector:@selector(downloadImage:) toTarget:self withObject:_url];
    }
    return self;
}

- (void)downloadImage:(NSString *)url {
    characterBuffer = [NSMutableData data];
    done = NO;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];

    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];

    connect = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [self performSelectorOnMainThread:@selector(httpConnectStart) withObject:nil waitUntilDone:NO];
    if (connect != nil) {
        do {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        } while (!done);
    }

    UIImage* photo = [[UIImage alloc]initWithData:characterBuffer];
    //下载结束，刷新
    [self performSelectorOnMainThread:@selector(fillPhoto:) withObject:photo waitUntilDone:NO];
}

- (void)httpConnectEnd {

}

- (void)fillPhoto:(UIImage *)image {
    [self setImage:image];
    self.contentMode = UIViewContentModeScaleAspectFit;
    [prg_Bar removeFromSuperview];
}

- (void)httpConnectStart {
    prg_Bar = [[UIProgressView alloc]initWithFrame:CGRectMake(0, self.frame.size.height/2, self.frame.size.width, self.frame.size.height)];
    [prg_Bar setProgressViewStyle:UIProgressViewStyleDefault];

    [prg_Bar setProgress:0];
    [self addSubview:prg_Bar];
}



- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {

    return nil;
}

// Forward errors to the delegate.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    done = YES;
    [self performSelectorOnMainThread:@selector(httpConnectEnd) withObject:nil waitUntilDone:NO];
    [characterBuffer setLength:0];

}

// Called when a chunk of data has been downloaded.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Process the downloaded chunk of data.

    [prg_Bar setProgress:(prg_Bar.progress+data.length/(float)total) animated:YES];
    [characterBuffer appendData:data];

}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {

    [self performSelectorOnMainThread:@selector(httpConnectEnd) withObject:nil waitUntilDone:NO];
    // Set the condition which ends the run loop.
    done = YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if(httpResponse && [httpResponse respondsToSelector:@selector(allHeaderFields)]){

        NSDictionary *httpResponseHeaderFields = [httpResponse allHeaderFields];
        total = (long) [httpResponseHeaderFields[@"Content-Length"] longLongValue];
    }
}


@end
