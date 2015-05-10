//
// Created by luowei on 15/5/10.
// Copyright (c) 2015 luowei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DirectoryWatcher;


@protocol DirectoryWatcherDelegate <NSObject>
@required
- (void)directoryDidChange:(DirectoryWatcher *)folderWatcher;
@end


@interface DirectoryWatcher : NSObject

@property(nonatomic, weak) id <DirectoryWatcherDelegate> delegate;

+ (DirectoryWatcher *)watchFolderWithPath:(NSString *)watchPath delegate:(id <DirectoryWatcherDelegate>)watchDelegate;

- (void)invalidate;

@end