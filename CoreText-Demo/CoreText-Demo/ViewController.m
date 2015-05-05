//
//  ViewController.m
//  CoreText-Demo
//
//  Created by luowei on 15/5/3.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import "ViewController.h"
#import "CTView.h"
#import "MarkupParser.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet CTView *containerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

//    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"txt"];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"zombies" ofType:@"txt"];
    NSString* text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    MarkupParser* p = [[MarkupParser alloc] init];
    NSAttributedString* attString = [p attrStringFromMarkup: text];
//    [self.containerView setAttrString: attString];
    [self.containerView setAttrString: attString withImages:p.images];

//    [self.containerView buildFrames];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
