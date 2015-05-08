//
//  SerialConnection.h
//  SerialTester
//
//  Created by Christopher Alford on 04/11/2013.
//  Copyright (c) 2013 Yachtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SerialConnectionDelegate <NSObject>

@optional
- (void)newSentance:(NSString *)sentence;
@end

@interface SerialConnection : NSObject


@property (strong, nonatomic) id delegate;
@property (assign)BOOL logging;


-(void) connectToServerUsingStream:(NSString *)urlStr
                            portNo:(uint) portNo;

-(void) disconnect;
@end
