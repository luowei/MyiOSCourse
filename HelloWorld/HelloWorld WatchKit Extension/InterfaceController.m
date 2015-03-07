//
//  InterfaceController.m
//  HelloWorld WatchKit Extension
//
//  Created by luowei on 15/3/6.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import "InterfaceController.h"


@interface InterfaceController()
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *textLabel;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}
- (IBAction)btnClick {
    [_textLabel setText:@"你好！"];
}

@end



