//
// Created by luowei on 15/5/10.
// Copyright (c) 2015 luowei. All rights reserved.
//

#import "AssetBrowserController.h"


/* Generating thumbnails is expensive and requires a lot of resources.
 If we do this while scrolling our framerate is affected. If your app presents a persistent
 media library it may make sense to cache thumbnails and metadata in a database. */
#define ONLY_GENERATE_THUMBS_AND_TITLES_WHEN_NOT_SCROLLING 1

@interface AssetBrowserController () <AssetBrowserSourceDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource> {
    NSArray *assetSources;
    NSMutableArray *activeAssetSources;
    AssetBrowserSourceType browserSourceType;
    BOOL singleSourceTypeMode;
    BOOL haveBuiltSourceLibraries;

    BOOL thumbnailAndTitleGenerationIsRunning;
    BOOL thumbnailAndTitleGenerationEnabled;

    CGFloat lastTableViewYContentOffset;
    BOOL lastTableViewScrollDirection;

    CGFloat thumbnailScale;

    BOOL isModal;
    UIStatusBarStyle lastStatusBarStyle;
}

@property(nonatomic, copy) NSArray *assetSources;

@property(nonatomic, strong) UIView *noSourceView;

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath;

- (void)updateActiveAssetSources;

- (void)enableThumbnailAndTitleGeneration;

- (void)disableThumbnailAndTitleGeneration;

- (void)generateThumbnailsAndTitles;

- (void)cancelAction;

@end

@implementation AssetBrowserController {

}

enum {
    AssetBrowserScrollDirectionDown,
    AssetBrowserScrollDirectionUp
};

#pragma mark -
#pragma mark Initialization

- (id)initWithSourceType:(AssetBrowserSourceType)sourceType modalPresentation:(BOOL)modalPresentation; {
    if ((self = [super initWithStyle:UITableViewStylePlain])) {
        browserSourceType = sourceType;
        if ((browserSourceType & AssetBrowserSourceTypeAll) == 0) {
            NSLog(@"AssetBrowserController: Invalid sourceType");
            return nil;
        }

        [self setEdgesForExtendedLayout:UIRectEdgeAll];

        thumbnailScale = [[UIScreen mainScreen] scale];

        activeAssetSources = [[NSMutableArray alloc] initWithCapacity:0];
        isModal = modalPresentation;


        // Okay now generate the list of Assets to be displayed.
        // This should be relatively quick since we are not creating assets or thumbnails.
        NSMutableArray *sources = [NSMutableArray arrayWithCapacity:0];

        if (browserSourceType & AssetBrowserSourceTypeFileSharing) {
            [sources addObject:[AssetBrowserSource assetBrowserSourceOfType:AssetBrowserSourceTypeFileSharing]];
        }
        if (browserSourceType & AssetBrowserSourceTypeCameraRoll) {
            [sources addObject:[AssetBrowserSource assetBrowserSourceOfType:AssetBrowserSourceTypeCameraRoll]];
        }
        if (browserSourceType & AssetBrowserSourceTypeIPodLibrary) {
            [sources addObject:[AssetBrowserSource assetBrowserSourceOfType:AssetBrowserSourceTypeIPodLibrary]];
        }

        self.assetSources = sources;

        if ([sources count] == 1) {
            singleSourceTypeMode = YES;
            self.title = [self.assetSources[0] name];
        }
        else {
            self.title = NSLocalizedString(@"Media", nil);
        }

    }
    return self;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.rowHeight = 65.0; // 1 point is for the divider, we want our thumbnails to have an even height.
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];


    if (!singleSourceTypeMode)
        self.tableView.sectionHeaderHeight = 22.0;

    // We wait until the scroll view has finished decelerating to generate thumbnails so make the deceleration a bit faster than normal.
    float decel = (float) (UIScrollViewDecelerationRateNormal - (UIScrollViewDecelerationRateNormal - UIScrollViewDecelerationRateFast) / 2.0);
    self.tableView.decelerationRate = decel;

    if (isModal && (self.modalPresentationStyle == UIModalPresentationFullScreen)) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                               target:self action:@selector(cancelAction)];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (isModal && (self.modalPresentationStyle == UIModalPresentationFullScreen)) {
        lastStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
        if (lastStatusBarStyle != UIStatusBarStyleLightContent) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:animated];
        }
    }

    lastTableViewYContentOffset = self.tableView.contentOffset.y;
    lastTableViewScrollDirection = AssetBrowserScrollDirectionDown;

    if (haveBuiltSourceLibraries)
        return;

    haveBuiltSourceLibraries = YES;

    for (AssetBrowserSource *source in self.assetSources) {
        [source buildSourceLibrary];
    }

    [self updateActiveAssetSources];

    [self.tableView reloadData];

    for (AssetBrowserSource *source in self.assetSources) {
        source.delegate = self;
    }

//    //设置title
//    if (browserSourceType == AssetBrowserSourceTypeFileSharing) {
//        self.title = NSLocalizedString(@"File Sharing", nil);
//    }
//    if (browserSourceType == AssetBrowserSourceTypeCameraRoll) {
//        self.title = NSLocalizedString(@"Camera Roll", nil);
//    }
//    if (browserSourceType == AssetBrowserSourceTypeIPodLibrary) {
//        self.title = NSLocalizedString(@"iPod Library", nil);
//    }
}

- (void)cancelAction {
    if ([self.delegate respondsToSelector:@selector(assetBrowserDidCancel:)]) {
        [self.delegate assetBrowserDidCancel:self];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self enableThumbnailAndTitleGeneration];
    [self generateThumbnailsAndTitles];

    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self disableThumbnailAndTitleGeneration];

    if (isModal && (self.modalPresentationStyle == UIModalPresentationFullScreen)) {
        if (lastStatusBarStyle != UIStatusBarStyleLightContent) {
            [[UIApplication sharedApplication] setStatusBarStyle:lastStatusBarStyle animated:animated];
        }
    }
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath)
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)clearSelection {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath)
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return YES;
    }
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    // If a thumbnail finished while we were rotating then its cell might not have been updated, but the cell could still be cached.
    for (UITableViewCell *visibleCell in [self.tableView visibleCells]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:visibleCell];
        [self configureCell:visibleCell forIndexPath:indexPath];
    }
}

#pragma mark -
#pragma mark Table view data source

- (void)updateActiveAssetSources {
    [activeAssetSources removeAllObjects];

    //判断是否存在媒体文件
    AssetBrowserSource *source = self.assetSources ? self.assetSources.firstObject : nil;
    if (source.items.count > 0) {

        if (self.noSourceView) {
            self.noSourceView.hidden = YES;
        }
    } else {
        if (!self.noSourceView) {
            CGRect vRect = self.view.frame;
            self.noSourceView = [[UIView alloc] initWithFrame:CGRectMake(vRect.origin.x, vRect.origin.y, vRect.size.width, vRect.size.height)];
            self.noSourceView.backgroundColor = [UIColor whiteColor];

            UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            tipLabel.bounds = CGRectMake(0, 0, self.view.frame.size.width / 2, 80);
            tipLabel.center = self.view.center;
            tipLabel.text = NSLocalizedString(@"NoMedia", nil);
            tipLabel.font = [UIFont systemFontOfSize:24.0];
            [self.noSourceView addSubview:tipLabel];

            [self.view addSubview:self.noSourceView];
            [self.view bringSubviewToFront:self.noSourceView];

        }
        self.noSourceView.hidden = NO;
    }

    for (AssetBrowserSource *source in self.assetSources) {
        if (([source.items count] > 0)) {
            [activeAssetSources addObject:source];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [activeAssetSources count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (singleSourceTypeMode)
        return nil;

    AssetBrowserSource *source = activeAssetSources[section];
    NSString *name = [source.items count] > 0 ? source.name : nil;
    return name;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSInteger numRows = 0;

    numRows = [[activeAssetSources[section] items] count];

    return numRows;
}

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    if (cell == nil)
        return;

    AssetBrowserSource *source = activeAssetSources[indexPath.section];

    AssetBrowserItem *item = [source items][indexPath.row];
    cell.textLabel.text = item.title;

    UIImage *thumb = item.thumbnailImage;

    if (!thumb || !item.haveRichestTitle) {
        [self generateThumbnailsAndTitles];
    }

    if (!thumb) {
        thumb = [item placeHolderImage];
    }
    cell.imageView.image = thumb;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {

        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0];
        cell.accessoryType = isModal ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;
    }

    [self configureCell:cell forIndexPath:indexPath];

    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AssetBrowserItem *selectedItem = [(AssetBrowserSource *) [activeAssetSources objectAtIndex:indexPath.section] items][indexPath.row];

    if ([self.delegate respondsToSelector:@selector(assetBrowser:didChooseItem:)]) {
        AssetBrowserItem *selectedItemCopy = [selectedItem copy];
        [self.delegate assetBrowser:self didChooseItem:selectedItemCopy];
    }
}

#pragma mark -
#pragma mark Asset Library Delegate

- (void)assetBrowserSourceItemsDidChange:(AssetBrowserSource *)source {
    [self updateActiveAssetSources];
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Thumbnail Generation

- (void)updateCellForBrowserItemIfVisible:(AssetBrowserItem *)browserItem {
    NSArray *visibleIndexPaths = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in visibleIndexPaths) {
        AssetBrowserItem *visibleBrowserItem = [[activeAssetSources objectAtIndex:indexPath.section] items][indexPath.row];
        if ([browserItem isEqual:visibleBrowserItem]) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [self configureCell:cell forIndexPath:indexPath];
            [cell setNeedsLayout];
            break;
        }
    }
}

- (void)thumbnailsAndTitlesTask {
    if (!thumbnailAndTitleGenerationEnabled) {
        thumbnailAndTitleGenerationIsRunning = NO;
        return;
    }

    thumbnailAndTitleGenerationIsRunning = YES;

    NSArray *visibleIndexPaths = [self.tableView indexPathsForVisibleRows];

    id objOrEnumerator = (lastTableViewScrollDirection == AssetBrowserScrollDirectionDown) ? (id) visibleIndexPaths : (id) [visibleIndexPaths reverseObjectEnumerator];
    for (NSIndexPath *path in objOrEnumerator) {
        NSArray *assetItemsInSection = [activeAssetSources[path.section] items];
        AssetBrowserItem *assetItem = ((NSInteger) [assetItemsInSection count] > path.row) ? assetItemsInSection[path.row] : nil;

        if (assetItem) {
            __block NSInteger runningRequests = 0;
            if (assetItem.thumbnailImage == nil) {
                CGFloat targetHeight = self.tableView.rowHeight - 1.0; // The contentView is one point smaller than the cell because of the divider.
                targetHeight *= thumbnailScale;

                CGFloat targetAspectRatio = 1.5;
                CGSize targetSize = CGSizeMake(targetHeight * targetAspectRatio, targetHeight);

                runningRequests++;
                [assetItem generateThumbnailAsynchronouslyWithSize:targetSize fillMode:AssetBrowserItemFillModeCrop completionHandler:^(UIImage *thumbnail) {
                    runningRequests--;
                    if (runningRequests == 0) {
                        [self updateCellForBrowserItemIfVisible:assetItem];
                        // Continue generating until all thumbnails/titles in range have been finished.
                        [self thumbnailsAndTitlesTask];
                    }
                }];


            }
            if (!assetItem.haveRichestTitle) {
                runningRequests++;
                [assetItem generateTitleFromMetadataAsynchronouslyWithCompletionHandler:^(NSString *title) {
                    runningRequests--;
                    if (runningRequests == 0) {
                        [self updateCellForBrowserItemIfVisible:assetItem];
                        // Continue generating until all thumbnails/titles in range have been finished.
                        [self thumbnailsAndTitlesTask];
                    }
                }];
            }
            // If we are generating a title or thumbnail then wait until that returns to generate the next one.
            if (runningRequests > 0)
                return;
        }
    }

    thumbnailAndTitleGenerationIsRunning = NO;

    return;
}

- (void)enableThumbnailAndTitleGeneration {
    thumbnailAndTitleGenerationEnabled = YES;
}

- (void)disableThumbnailAndTitleGeneration {
    thumbnailAndTitleGenerationEnabled = NO;
}

- (void)generateThumbnailsAndTitles {
    if (!thumbnailAndTitleGenerationEnabled) {
        return;
    }
    if (!thumbnailAndTitleGenerationIsRunning) {
        /* Run on the next run loop iteration. We may be called from with configureCell: and we don't want to slow down table view display. */
        thumbnailAndTitleGenerationIsRunning = YES;
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self thumbnailsAndTitlesTask];
        });
    }
}

#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

#if ONLY_GENERATE_THUMBS_AND_TITLES_WHEN_NOT_SCROLLING

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self disableThumbnailAndTitleGeneration];
}

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self enableThumbnailAndTitleGeneration];
        [self generateThumbnailsAndTitles];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self enableThumbnailAndTitleGeneration];
    [self generateThumbnailsAndTitles];
}

#endif //ONLY_GENERATE_THUMBS_AND_TITLES_WHEN_NOT_SCROLLING

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat newOffset = scrollView.contentOffset.y;
    CGFloat oldOffset = lastTableViewYContentOffset;

    CGFloat offsetAmount = newOffset - oldOffset;

    // Only update the scroll direction if we've passed some threshold (8 points).
    if (fabs(offsetAmount) > 8.0) {
        if (offsetAmount > 0.0)
            lastTableViewScrollDirection = AssetBrowserScrollDirectionDown;
        else if (newOffset < oldOffset)
            lastTableViewScrollDirection = AssetBrowserScrollDirectionUp;

        lastTableViewYContentOffset = newOffset;
    }
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Get rid of AVAsset and thumbnail caches for items which aren't on screen.
    NSLog(@"%@ memory warning, clearing asset and thumbnail caches", self);
    NSArray *visibleIndexPaths = [self.tableView indexPathsForVisibleRows];
    NSUInteger section = 0;
    NSUInteger row = 0;
    for (AssetBrowserSource *source in activeAssetSources) {
        row = 0;
        for (AssetBrowserItem *item in [source items]) {
            NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:section];
            if (![visibleIndexPaths containsObject:path]) {
                [item clearAssetCache];
                [item clearThumbnailCache];
            }
            row++;
        }
        section++;
    }
}

- (void)dealloc {
    self.delegate = nil;


}

@end


@implementation UINavigationController (AssetBrowserConvenienceMethods)

+ (UINavigationController *)modalAssetBrowserControllerWithSourceType:(AssetBrowserSourceType)sourceType delegate:(id <AssetBrowserControllerDelegate>)delegate {
    AssetBrowserController *browser = [[AssetBrowserController alloc] initWithSourceType:sourceType modalPresentation:YES];
    browser.delegate = delegate;

    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:browser];
    [navController.navigationBar setBarStyle:UIBarStyleBlack];
    [navController.navigationBar setTranslucent:YES];

    return navController;
}

@end

@implementation UITabBarController (AssetBrowserConvenienceMethods)

+ (UITabBarController *)tabbedModalAssetBrowserControllerWithSourceType:(AssetBrowserSourceType)sourceType delegate:(id <AssetBrowserControllerDelegate>)delegate {
    UITabBarController *tabBarController = [[UITabBarController alloc] init];

    NSMutableArray *assetBrowserControllers = [NSMutableArray arrayWithCapacity:0];

    if (sourceType & AssetBrowserSourceTypeCameraRoll) {
        [assetBrowserControllers addObject:[UINavigationController modalAssetBrowserControllerWithSourceType:AssetBrowserSourceTypeCameraRoll delegate:delegate]];
    }
    if (sourceType & AssetBrowserSourceTypeFileSharing) {
        [assetBrowserControllers addObject:[UINavigationController modalAssetBrowserControllerWithSourceType:AssetBrowserSourceTypeFileSharing delegate:delegate]];
    }
    if (sourceType & AssetBrowserSourceTypeIPodLibrary) {
        [assetBrowserControllers addObject:[UINavigationController modalAssetBrowserControllerWithSourceType:AssetBrowserSourceTypeIPodLibrary delegate:delegate]];
    }

    tabBarController.viewControllers = assetBrowserControllers;

    return tabBarController;
}

@end