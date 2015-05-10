//
// Created by luowei on 15/5/10.
// Copyright (c) 2015 luowei. All rights reserved.
//

#import "AssetBrowserSource.h"
#import "AssetBrowserItem.h"
#import "DirectoryWatcher.h"


#import <MobileCoreServices/UTCoreTypes.h>
#import <MobileCoreServices/UTType.h>

#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface AssetBrowserSource () {

    BOOL haveBuiltSourceLibrary;
    ALAssetsLibrary *assetsLibrary;
    BOOL receivingIPodLibraryNotifications;
    dispatch_queue_t enumerationQueue;

    DirectoryWatcher *directoryWatcher;
}

@property(nonatomic, copy) NSArray *items; // NSArray of AssetBrowserItems


@end

@implementation AssetBrowserSource {

}


- (NSString *)nameForSourceType {
    NSString *name = nil;

    switch (_type) {
        case AssetBrowserSourceTypeFileSharing:
            name = NSLocalizedString(@"File Sharing", nil);
            break;
        case AssetBrowserSourceTypeCameraRoll:
            name = NSLocalizedString(@"Camera Roll", nil);
            break;
        case AssetBrowserSourceTypeIPodLibrary:
            name = NSLocalizedString(@"iPod Library", nil);
            break;
        default:
            name = nil;
            break;
    }

    return name;
}

+ (AssetBrowserSource *)assetBrowserSourceOfType:(AssetBrowserSourceType)sourceType {
    return [[self alloc] initWithSourceType:sourceType];
}

- (id)initWithSourceType:(AssetBrowserSourceType)type {
    if ((self = [super init])) {
        _type = type;
        _name = [self nameForSourceType];
        _items = [NSArray array];

        enumerationQueue = dispatch_queue_create("Browser Enumeration Queue", DISPATCH_QUEUE_SERIAL);
        dispatch_set_target_queue(enumerationQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0));
    }
    return self;
}

- (void)updateBrowserItemsAndSignalDelegate:(NSArray *)newItems {
    self.items = newItems;

    /* Ideally we would reuse the AssetBrowserItems which remain unchanged between updates.
     This could be done by maintaining a dictionary of assetURLs -> AssetBrowserItems.
     This would also allow us to more easily tell our delegate which indices were added/removed
     so that it could animate the table view updates. */

    if (self.delegate && [self.delegate respondsToSelector:@selector(assetBrowserSourceItemsDidChange:)]) {
        [self.delegate assetBrowserSourceItemsDidChange:self];
    }
}

- (void)dealloc {
    if (receivingIPodLibraryNotifications) {
        MPMediaLibrary *iPodLibrary = [MPMediaLibrary defaultMediaLibrary];
        [iPodLibrary endGeneratingLibraryChangeNotifications];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMediaLibraryDidChangeNotification object:nil];
    }

    if (assetsLibrary) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:ALAssetsLibraryChangedNotification object:nil];
    }

    [directoryWatcher invalidate];
    directoryWatcher.delegate = nil;
}

#pragma mark -
#pragma mark iPod Library

- (void)updateIPodLibrary {
    dispatch_async(enumerationQueue, ^(void) {
        // Grab videos from the iPod Library
        MPMediaQuery *videoQuery = [[MPMediaQuery alloc] init];

        NSMutableArray *items = [NSMutableArray arrayWithCapacity:0];
        NSArray *mediaItems = [videoQuery items];
        for (MPMediaItem *mediaItem in mediaItems) {
            NSURL *URL = (NSURL *) [mediaItem valueForProperty:MPMediaItemPropertyAssetURL];

            if (URL) {
                NSString *title = (NSString *) [mediaItem valueForProperty:MPMediaItemPropertyTitle];
                AssetBrowserItem *item = [[AssetBrowserItem alloc] initWithURL:URL title:title];
                [items addObject:item];
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self updateBrowserItemsAndSignalDelegate:items];
        });
    });
}

- (void)iPodLibraryDidChange:(NSNotification *)changeNotification {
    [self updateIPodLibrary];
}

- (void)buildIPodLibrary {
    MPMediaLibrary *iPodLibrary = [MPMediaLibrary defaultMediaLibrary];
    receivingIPodLibraryNotifications = YES;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(iPodLibraryDidChange:)
                                                 name:MPMediaLibraryDidChangeNotification object:nil];
    [iPodLibrary beginGeneratingLibraryChangeNotifications];

    [self updateIPodLibrary];
}

#pragma mark -
#pragma mark Assets Library

- (void)updateAssetsLibrary {
    NSMutableArray *assetItems = [NSMutableArray arrayWithCapacity:0];
    ALAssetsLibrary *assetLibrary = assetsLibrary;

    [assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                if (group) {
                    [group setAssetsFilter:[ALAssetsFilter allVideos]];
                    [group enumerateAssetsUsingBlock:
                            ^(ALAsset *asset, NSUInteger index, BOOL *stopIt) {
                                if (asset) {
                                    ALAssetRepresentation *defaultRepresentation = [asset defaultRepresentation];
                                    NSString *uti = [defaultRepresentation UTI];
                                    NSURL *URL = [[asset valueForProperty:ALAssetPropertyURLs] valueForKey:uti];
                                    NSString *title = [NSString stringWithFormat:@"%@ %lu", NSLocalizedString(@"Video", nil), [assetItems count] + 1];
                                    AssetBrowserItem *item = [[AssetBrowserItem alloc] initWithURL:URL title:title];

                                    [assetItems addObject:item];
                                }
                            }];
                }
                    // group == nil signals we are done iterating.
                else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self updateBrowserItemsAndSignalDelegate:assetItems];
                    });
                }
            }
                              failureBlock:^(NSError *error) {
                                  NSLog(@"error enumerating AssetLibrary groups %@\n", error);
                              }];
}

- (void)assetsLibraryDidChange:(NSNotification *)changeNotification {
    [self updateAssetsLibrary];
}

- (void)buildAssetsLibrary {
    assetsLibrary = [[ALAssetsLibrary alloc] init];
    ALAssetsLibrary *notificationSender = nil;

    NSString *minimumSystemVersion = @"4.1";
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    if ([systemVersion compare:minimumSystemVersion options:NSNumericSearch] != NSOrderedAscending)
        notificationSender = assetsLibrary;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(assetsLibraryDidChange:)
                                                 name:ALAssetsLibraryChangedNotification object:notificationSender];
    [self updateAssetsLibrary];
}

#pragma mark -
#pragma mark iTunes File Sharing

- (NSArray *)browserItemsInDirectory:(NSString *)directoryPath {
    NSMutableArray *paths = [NSMutableArray arrayWithCapacity:0];
    NSArray *subPaths = [[[NSFileManager alloc] init] contentsOfDirectoryAtPath:directoryPath error:nil];
    if (subPaths) {
        for (NSString *subPath in subPaths) {
            NSString *pathExtension = [subPath pathExtension];
            CFStringRef preferredUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef) pathExtension, NULL);
            BOOL fileConformsToUTI = UTTypeConformsTo(preferredUTI, kUTTypeAudiovisualContent);
            CFRelease(preferredUTI);
            NSString *path = [directoryPath stringByAppendingPathComponent:subPath];

            if (fileConformsToUTI) {
                [paths addObject:path];
            }
        }
    }

    NSMutableArray *browserItems = [NSMutableArray arrayWithCapacity:0];
    for (NSString *path in paths) {
        AssetBrowserItem *item = [[AssetBrowserItem alloc] initWithURL:[NSURL fileURLWithPath:path]];
        [browserItems addObject:item];
    }
    return browserItems;
}

- (void)directoryDidChange:(DirectoryWatcher *)folderWatcher {
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    dispatch_async(enumerationQueue, ^(void) {
        NSArray *browserItems = [self browserItemsInDirectory:documentsDirectory];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self updateBrowserItemsAndSignalDelegate:browserItems];
        });
    });
}

- (void)buildFileSharingLibrary {
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSArray *browserItems = [self browserItemsInDirectory:documentsDirectory];
    [self updateBrowserItemsAndSignalDelegate:browserItems];
    directoryWatcher = [DirectoryWatcher watchFolderWithPath:documentsDirectory delegate:self];
}

- (void)buildSourceLibrary {
    if (haveBuiltSourceLibrary)
        return;

    switch (_type) {
        case AssetBrowserSourceTypeFileSharing:
            [self buildFileSharingLibrary];
            break;
        case AssetBrowserSourceTypeCameraRoll:
            [self buildAssetsLibrary];
            break;
        case AssetBrowserSourceTypeIPodLibrary:
            [self buildIPodLibrary];
            break;
        default:
            break;
    }

    haveBuiltSourceLibrary = YES;
}


@end