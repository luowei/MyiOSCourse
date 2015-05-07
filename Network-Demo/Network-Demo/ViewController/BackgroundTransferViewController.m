//
//  BackgroundTransferViewController.m
//  CFNetWork-Demo
//
//  Created by luowei on 15/5/7.
//
//

#import "BackgroundTransferViewController.h"
#import "AppDelegate.h"

static NSString *DownloadURLString = @"http://d.hiphotos.baidu.com/image/pic/item/78310a55b319ebc4b455b4168026cffc1e17160b.jpg";

@interface BackgroundTransferViewController () <NSURLSessionDownloadDelegate>

@property(strong, nonatomic) UIImageView *imageView;
@property(strong, nonatomic) UIProgressView *progressView;

@property(strong, nonatomic) NSURLSession *session;
@property(strong, nonatomic) NSURLSessionDownloadTask *downloadTask;

@end

@implementation BackgroundTransferViewController

- (void)loadView {
    [super loadView];

    self.view.backgroundColor = [UIColor whiteColor];
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.imageView];

    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.center = self.view.center;
    [self.view addSubview:self.progressView];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay
                                                                                           target:self
                                                                                           action:@selector(startLoading:)];
}

- (void)startLoading:(id)sender {
    if (self.downloadTask) {
        return;
    }

    /*
     Create a new download task using the URL session. Tasks start in the “suspended” state;
     to start a task you need to explicitly call -resume on a task after creating it.
     */
    NSURL *downloadURL = [NSURL URLWithString:DownloadURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:downloadURL];
    self.downloadTask = [self.session downloadTaskWithRequest:request];
    [self.downloadTask resume];

    self.imageView.hidden = YES;
    self.progressView.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //构造后台线程
    self.session = [self backgroundSession];

    self.progressView.progress = 0;
    self.imageView.hidden = NO;
    self.progressView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSURLSession *)backgroundSession {
/*
 Using disptach_once here ensures that multiple background sessions with the same identifier are not created
 in this instance of the application. If you want to support multiple background sessions within a single process,
 you should create each session with its own identifier.
 */
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfiguration:@"com.rootls.Network-Demo.SimpleBackgroundTransfer.BackgroundSession"];
        session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    });
    return session;
}

#pragma mark NSURLSessionDownloadDelegate Implements

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
             didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    BLog();

    /*
     Report progress on the task.
     If you created more than one task, you might keep references to them and report on them individually.
     */

    if (downloadTask == self.downloadTask) {
        double progress = (double) totalBytesWritten / (double) totalBytesExpectedToWrite;
        BLog(@"DownloadTask: %@ progress: %lf", downloadTask, progress);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressView.progress = (float) progress;
        });
    }
}


- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)downloadURL {
    BLog();

    /*
     The download completed, you need to copy the file at targetPath before the end of this block.
     As an example, copy the file to the Documents directory of your app.
    */
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSArray *URLs = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsDirectory = URLs[0];

    NSURL *originalURL = [[downloadTask originalRequest] URL];
    NSURL *destinationURL = [documentsDirectory URLByAppendingPathComponent:[originalURL lastPathComponent]];
    NSError *errorCopy;

    // For the purposes of testing, remove any esisting file at the destination.
    [fileManager removeItemAtURL:destinationURL error:NULL];
    BOOL success = [fileManager copyItemAtURL:downloadURL toURL:destinationURL error:&errorCopy];

    if (success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithContentsOfFile:[destinationURL path]];
            self.imageView.image = image;
            self.imageView.hidden = NO;
            self.progressView.hidden = YES;
        });
    }
    else {
        /*
         In the general case, what you might do in the event of failure depends on the error
         and the specifics of your application.
         */
        BLog(@"Error during the copy: %@", [errorCopy localizedDescription]);
    }
}


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    BLog();

    if (error == nil) {
        NSLog(@"Task: %@ completed successfully", task);
    }
    else {
        NSLog(@"Task: %@ completed with error: %@", task, [error localizedDescription]);
    }

    double progress = (double) task.countOfBytesReceived / (double) task.countOfBytesExpectedToReceive;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressView.progress = (float) progress;
    });

    self.downloadTask = nil;
}


/*
 If an application has received an -application:handleEventsForBackgroundURLSession:completionHandler: message,
 the session delegate will receive this message to indicate that all messages previously enqueued for this session
 have been delivered. At this time it is safe to invoke the previously stored completion handler, or to begin any internal
 updates that will result in invoking the completion handler.
 */
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    if (appDelegate.backgroundSessionCompletionHandler) {
        void (^completionHandler)() = appDelegate.backgroundSessionCompletionHandler;
        appDelegate.backgroundSessionCompletionHandler = nil;
        completionHandler();
    }

    NSLog(@"All tasks are finished");
}


- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    BLog();
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
