//
//  TiledLayerViewController.m
//  CoreAnimation-Demo
//
//  Created by luowei on 15/4/13.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import "TiledLayerViewController.h"

@interface TiledLayerViewController ()
@property(nonatomic, weak) IBOutlet UIScrollView *scrollView;
@end

@implementation TiledLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;

    //add the tiled layer
    CATiledLayer *tileLayer = [CATiledLayer layer];
    tileLayer.frame = CGRectMake(0, 0, 2048, 2048);
    tileLayer.delegate = self;
    [self.scrollView.layer addSublayer:tileLayer];
    //configure the scroll view
    self.scrollView.contentSize = tileLayer.frame.size;
    //draw layer
    [tileLayer setNeedsDisplay];
}

- (void)drawLayer:(CATiledLayer *)layer inContext:(CGContextRef)ctx {
    //determine tile coordinate
    CGRect bounds = CGContextGetClipBoundingBox(ctx);
    NSInteger x = floor(bounds.origin.x / layer.tileSize.width);
    NSInteger y = floor(bounds.origin.y / layer.tileSize.height);
    //load tile image
    NSString *imageName = [NSString stringWithFormat:@"flower_%i_%i", x, y];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"jpg"];
    UIImage *tileImage = [UIImage imageWithContentsOfFile:imagePath];
    //draw tile
    UIGraphicsPushContext(ctx);
    [tileImage drawInRect:bounds];
    UIGraphicsPopContext();
}

//小片裁剪
- (IBAction)shatterImage:(UIButton *)sender {
    /*
    // ---- Only For Mac OS ---- //
    //input file
    NSString *inputFile = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];
    //tile size
    CGFloat tileSize = 256; //output path
    NSString *outputPath = [inputFile stringByDeletingPathExtension];
    //load image
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:inputFile];
    NSSize size = [image size];
    NSArray *representations = [image representations];
    if ([representations count]){
        NSBitmapImageRep *representation = representations[0];
        size.width = [representation pixelsWide];
        size.height = [representation pixelsHigh];
    }
    NSRect rect = NSMakeRect(0.0, 0.0, size.width, size.height);
    CGImageRef imageRef = [image CGImageForProposedRect:&rect context:NULL hints:nil];
    //calculate rows and columns
    NSInteger rows = ceil(size.height / tileSize);
    NSInteger cols = ceil(size.width / tileSize);
    //generate tiles
    for (int y = 0; y < rows; ++y) {
        for (int x = 0; x < cols; ++x) {
            //extract tile image
            CGRect tileRect = CGRectMake(x*tileSize, y*tileSize, tileSize, tileSize);
            CGImageRef tileImage = CGImageCreateWithImageInRect(imageRef, tileRect);
            //convert to jpeg data
            NSBitmapImageRep *imageRep = [[NSBitmapImageRep alloc] initWithCGImage:tileImage];
            NSData *data = [imageRep representationUsingType: NSJPEGFileType properties:nil];
            CGImageRelease(tileImage);
            //save file
            NSString *path = [outputPath stringByAppendingFormat: @"_i_i.jpg", x, y];
            [data writeToFile:path atomically:NO];
        }
    }
    */
}

//拼合加载
- (IBAction)joggedImage:(UIButton *)sender {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
