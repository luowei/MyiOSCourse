//
//  SerialConnection.m
//  SerialTester
//
//  Created by Christopher Alford on 04/11/2013.
//  Copyright (c) 2013 Yachtech. All rights reserved.
//

#import "SerialConnection.h"

@interface SerialConnection () <NSStreamDelegate>

@property (assign) CFReadStreamRef readStream;
@property (assign) CFWriteStreamRef writeStream;

@property (strong, nonatomic) NSInputStream *iStream;
@property (strong, nonatomic) NSOutputStream *oStream;

@property (strong, nonatomic) NSMutableData *dataBuffer;
@property (strong, nonatomic) NSMutableString *previousSentence;

@property (strong, nonatomic) NSSet *registeredLiseners;
@end



@implementation SerialConnection

- (id)init
{
    self = [super init];
    if(self)
        return self;
    return nil;
}

#pragma mark - Lazy initializers
- (NSMutableString *)previousSentence
{
    if(!_previousSentence) _previousSentence = [[NSMutableString alloc] init];
    return _previousSentence;
}

- (NSMutableData *)dataBuffer
{
    if(!_dataBuffer) _dataBuffer = [[NSMutableData alloc]init];
    return _dataBuffer;
}

#pragma mark - Instance methods
// Roving Networks device connection
-(void) connectToServerUsingStream:(NSString *)urlStr portNo:(uint)portNo {
    
    if(![urlStr isEqualToString:@""]) {
        
        CFStringRef strRef = (__bridge CFStringRef) urlStr; //CFStringCreateWithCString(NULL,[urlStr UTF8String],NSUTF8StringEncoding);
        
        CFStreamCreatePairWithSocketToHost(
                                           NULL,
                                           strRef,
                                           portNo,
                                           &_readStream,
                                           &_writeStream
                                           );
        
        self.iStream = objc_unretainedObject(_readStream);
        self.oStream = objc_unretainedObject(_writeStream);
        
        [self.iStream setDelegate:self];
        [self.oStream setDelegate:self];
        [self.iStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.oStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        [self.oStream open];
        [self.iStream open];
        
    }
}

// Write to Roving Networks device
-(void) writeToServer:(const uint8_t *) buf{
    [self.oStream write:buf maxLength:strlen((char *)buf)];
}

-(void) disconnect {
    [self.iStream close];
    [self.oStream close];
}

// Stream event callbacks
-(void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode {
	
    switch(eventCode) {
			
        case NSStreamEventHasBytesAvailable:
        {
			// Local buffer for stream read, len is actual ASCII bytes read
            uint8_t buffer[1024];
            NSInteger len =0;
            len = [(NSInputStream *)stream read:buffer maxLength:sizeof(buffer)];
			
			NSArray *sentences;
			
			if (len){
				// Create temporary string for read data
				NSString *aSentence = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
				//NSLog(@"Raw sentence : %@", sentence);
				
				// Split this up using CR & NL character pair
				sentences = [[NSArray alloc]initWithArray:[aSentence componentsSeparatedByString:@"\r\n"]];
				// Iterate through array combining objects to make complete sentences
				for (int n=0; n < [sentences count]; n++) {
					if (sentences[n]) {
						//NSLog(@"Sentence at %d : %@",n ,[sentences objectAtIndex:n]);
						// If the sentence contains a $ character split at this position
						// appending start onto previous sentence.
						// Process previous sentence
						// Replace previous sentence with end and loop
						
						int splitHere = -1;
						NSString *startSentence;
						NSString *endSentence;
						
						for (int i=0; i< [sentences[n] length]; i++) {
							if ([sentences[n] characterAtIndex:i]=='$') {
								splitHere = i;
								break;
							}
						}
						
						// If the split is at the beginning of the sentence then process the previous sentence
						if (splitHere == 0) {
							//NSLog(@"Process this >>> %@", previousSentence);
							if (self.logging) {
								[self insertNMEASentence:self.previousSentence];
							}
							// You can now start a new previousSentence using this endSentence as you don't know if it is split
							endSentence = [[NSString alloc] initWithString:[sentences[n] substringFromIndex:splitHere]];
							//NSLog(@"New End   : %@", endSentence);
							[self.previousSentence setString:endSentence];
							//NSLog(@"New Previous : %@", previousSentence);
						}
						else if (splitHere == -1) {
							// Deal with sentences without a start
							endSentence = [[NSString alloc] initWithString:sentences[n]];
							[self.previousSentence appendString:endSentence];
							//NSLog(@"New end appended Previous : %@", previousSentence);
						}
						else {
							// As the sentence started mid way, append the start to previous and process
							startSentence = [[NSString alloc] initWithString:[sentences[n] substringToIndex:splitHere]];
							//NSLog(@"New Start : %@", startSentence);
							[self.previousSentence appendString:startSentence];
							//NSLog(@"Process this >>> %@", previousSentence);
							if (self.logging) {
								[self insertNMEASentence:self.previousSentence];
							}
							// then save the end part for the next loop
							endSentence = [[NSString alloc] initWithString:[sentences[n] substringFromIndex:splitHere]];
							[self.previousSentence setString:endSentence];
							//NSLog(@"New end appended to previous : %@", previousSentence);
						} // End If..Else
					}
				}
			}
            break;
		}
			
		case NSStreamEventOpenCompleted:
		{
			if(stream == self.iStream)
				NSLog(@"Input stream open completed OK");
			if(stream == self.oStream)
				NSLog(@"Output stream open completed OK");
			break;
		}
            
		case NSStreamEventErrorOccurred:
		{
			if(stream == self.iStream)
				NSLog(@"An error occured on the input stream");
			if(stream == self.oStream)
				NSLog(@"An error occured on the output stream");
			break;
		}
			
		case NSStreamEventEndEncountered:
        {
			NSLog(@"EVENT: End encountered.");
			[self.iStream close];
			[self.oStream close];
            [self.iStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
			[self.oStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            self.iStream = nil;
            self.oStream = nil;
			break;
		}
            
		case NSStreamEventHasSpaceAvailable:
        {
			NSLog(@"EVENT: Has space available.");
			break;
        }
            
        case NSStreamEventNone:
        {
            NSLog(@"%@", @"NSStreamEventNone produced");
        }
    }
}

//=======================================================
// Write new sentence data to database
- (void)insertNMEASentence: (NSString *)aSentence {
	
	// Ignore any empty sentence, normally the first one
	if ([aSentence length] < 1) {
		return;
	}
	[self.delegate newSentance:aSentence];
}



@end
