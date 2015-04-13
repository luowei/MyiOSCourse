//
//  TextLayerViewController.m
//  CoreAnimation-Demo
//
//  Created by luowei on 15/4/13.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import "TextLayerViewController.h"
#import <CoreText/CoreText.h>

@interface TextLayerViewController ()
@property (nonatomic, strong) UIView *labelView;
@end

@implementation TextLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //init label view
    _labelView = [[UIView alloc] initWithFrame:CGRectMake(20, 130, 250, 250)];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_labelView];

    /*
    //创建一个文本图层
    //create a text layer
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = self.labelView.bounds;
    [self.labelView.layer addSublayer:textLayer];
    //set text attributes
    textLayer.foregroundColor = [UIColor blackColor].CGColor;
    textLayer.alignmentMode = kCAAlignmentJustified;
    textLayer.wrapped = YES;
    //choose a font
    UIFont *font = [UIFont systemFontOfSize:15];
    //set layer font
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    textLayer.font = fontRef;
    textLayer.fontSize = font.pointSize;
    CGFontRelease(fontRef);
    //choose some text
    NSString *text = @"Lorem ipsum dolor sit amet, consectetur adipiscing \ elit. Quisque massa arcu, eleifend vel varius in, "
            "facilisis pulvinar \ leo. Nunc quis nunc at mauris pharetra condimentum ut ac neque. Nunc elementum, libero ut porttitor dictum,"
            " diam odio congue lacus, vel \ fringilla sapien diam at purus. Etiam suscipit pretium nunc sit amet \ lobortis";
    //set layer text
    textLayer.string = text;
    */

    //创建一个富文本图层
    //create a text layer
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = self.labelView.bounds;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.labelView.layer addSublayer:textLayer];
    //set text attributes
    textLayer.alignmentMode = kCAAlignmentJustified;
    textLayer.wrapped = YES;
    //choose a font
    UIFont *font = [UIFont systemFontOfSize:15];
    //choose some text
    NSString *text = @"Lorem ipsum dolor sit amet, consectetur adipiscing \ elit. "
            "Quisque massa arcu, eleifend vel varius in, facilisis pulvinar \ leo. "
            "Nunc quis nunc at mauris pharetra condimentum ut ac neque. Nunc \ elementum, "
            "libero ut porttitor dictum, diam odio congue lacus, vel \ fringilla sapien diam at purus. "
            "Etiam suscipit pretium nunc sit amet \ lobortis";

    //create attributed string
    NSMutableAttributedString *string = nil;
    string = [[NSMutableAttributedString alloc] initWithString:text];
    //convert UIFont to a CTFont
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFloat fontSize = font.pointSize;
    CTFontRef fontRef = CTFontCreateWithName(fontName, fontSize, NULL);
    //set text attributes
    NSDictionary *attribs = @{
            (__bridge id)kCTForegroundColorAttributeName:(__bridge id)[UIColor blackColor].CGColor,
            (__bridge id)kCTFontAttributeName: (__bridge id)fontRef
    };
    [string setAttributes:attribs range:NSMakeRange(0, [text length])];
    attribs = @{
            (__bridge id)kCTForegroundColorAttributeName: (__bridge id)[UIColor redColor].CGColor,
            (__bridge id)kCTUnderlineStyleAttributeName: @(kCTUnderlineStyleSingle),
            (__bridge id)kCTFontAttributeName: (__bridge id)fontRef
    };
    [string setAttributes:attribs range:NSMakeRange(6, 5)];
    //release the CTFont we created earlier
    CFRelease(fontRef);
    //set layer text
    textLayer.string = string;

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
