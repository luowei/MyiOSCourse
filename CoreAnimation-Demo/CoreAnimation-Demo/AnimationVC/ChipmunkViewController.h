//
//  ChipmunkViewController.h
//  CoreAnimation-Demo
//
//  Created by luowei on 15/4/17.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Chipmunk6_iOS/chipmunk.h>

@interface Crate : UIImageView
@property (nonatomic, assign) cpBody *body;
@property (nonatomic, assign) cpShape *shape;
@end

@interface ChipmunkViewController : UIViewController

@end
