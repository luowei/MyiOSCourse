//
//  ViewController.m
//  HelloWorld_OS
//
//  Created by luowei on 15/3/6.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "ViewController.h"
#import "AVPlaybackView.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}
- (IBAction)btnClick:(NSButton *)sender {
    
    //创建弹窗
    NSAlert *alert = [[NSAlert alloc] init];
    [alert.window setFrame:NSMakeRect(self.view.bounds.origin.x + 50, self.view.bounds.origin.y + 50, 200, 150) display:YES];
    alert.messageText = @"Hello World !";
    [alert runModal];
    
}

@end
