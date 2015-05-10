//
//  ChipmunkViewController.m
//  CoreAnimation-Demo
//
//  Created by luowei on 15/4/17.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import "ChipmunkViewController.h"


@implementation Crate
#define MASS 100

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        //set image
        self.image = [UIImage imageNamed:@"luowei"];
        self.contentMode = UIViewContentModeScaleAspectFill;
        //create the body
        self.body = cpBodyNew(MASS, cpMomentForBox(MASS, frame.size.width, frame.size.height));
        //create the shape
        cpVect corners[] = {
                cpv(0, 0),
                cpv(0, frame.size.height),
                cpv(frame.size.width, frame.size.height),
                cpv(frame.size.width, 0),
        };
        self.shape = cpPolyShapeNew(self.body, 4, corners, cpv(-frame.size.width / 2, -frame.size.height / 2));
        //set shape friction & elasticity
        cpShapeSetFriction(self.shape, 0.5);
        cpShapeSetElasticity(self.shape, 0.8);
        //link the crate to the shape
        //so we can refer to crate from callback later on
        self.shape->data = (__bridge void *) self;
        //set the body position to match view
        cpBodySetPos(self.body, cpv(frame.origin.x + frame.size.width / 2, 600 - frame.origin.y - frame.size.height / 2));
    }
    return self;
}

- (void)dealloc {
    //release shape and body
    cpShapeFree(_shape);
    cpBodyFree(_body);
}
@end


@interface ChipmunkViewController ()
@property(nonatomic, strong) UIView *containerView;
@property(nonatomic, assign) cpSpace *space;
@property(nonatomic, strong) CADisplayLink *timer;
@property(nonatomic, assign) CFTimeInterval lastStep;
@end

@implementation ChipmunkViewController

#define GRAVITY 1000

/*
- (void)viewDidLoad {

    self.containerView = [[UIView alloc] initWithFrame:self.view.frame];
    self.containerView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.containerView];

    //invert view coordinate system to match physics
    self.containerView.layer.geometryFlipped = YES;
    //set up physics space
    self.space = cpSpaceNew();
    cpSpaceSetGravity(self.space, cpv(0, -GRAVITY));
    //add a crate
    Crate *crate = [[Crate alloc] initWithFrame:CGRectMake(100, 0, 100, 100)];
    [self.containerView addSubview:crate];
    cpSpaceAddBody(self.space, crate.body);
    cpSpaceAddShape(self.space, crate.shape);
    //start the timer
    self.lastStep = CACurrentMediaTime();
    self.timer = [CADisplayLink displayLinkWithTarget:self
                                             selector:@selector(step:)];
    [self.timer addToRunLoop:[NSRunLoop mainRunLoop]
                     forMode:NSDefaultRunLoopMode];
}
*/


//使用围墙及加速计
- (void)addCrateWithFrame:(CGRect)frame {
    Crate *crate = [[Crate alloc] initWithFrame:frame];
    [self.containerView addSubview:crate];
    cpSpaceAddBody(self.space, crate.body);
    cpSpaceAddShape(self.space, crate.shape);
}

- (void)addWallShapeWithStart:(cpVect)start end:(cpVect)end {
    cpShape *wall = cpSegmentShapeNew(self.space->staticBody, start, end, 1);
    cpShapeSetCollisionType(wall, 2);
    cpShapeSetFriction(wall, 0.5);
    cpShapeSetElasticity(wall, 0.8);
    cpSpaceAddStaticShape(self.space, wall);
}

- (void)viewDidLoad {
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;

    self.containerView = [[UIView alloc] initWithFrame:self.view.frame];
    self.containerView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.containerView];

    //invert view coordinate system to match physics
    self.containerView.layer.geometryFlipped = YES;
    //set up physics space
    self.space = cpSpaceNew();
    cpSpaceSetGravity(self.space, cpv(0, -GRAVITY));

    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;

    //add wall around edge of view
    [self addWallShapeWithStart:cpv(0, 0) end:cpv(width, 0)];
    [self addWallShapeWithStart:cpv(width, 0) end:cpv(width, height)];
    [self addWallShapeWithStart:cpv(width, height) end:cpv(0, height)];
    [self addWallShapeWithStart:cpv(0, height) end:cpv(0, 0)];
    //add a crates
    [self addCrateWithFrame:CGRectMake(0, 0, 32, 32)];
    [self addCrateWithFrame:CGRectMake(32, 0, 32, 32)];
    [self addCrateWithFrame:CGRectMake(64, 0, 64, 64)];
    [self addCrateWithFrame:CGRectMake(128, 0, 32, 32)];
    [self addCrateWithFrame:CGRectMake(0, 32, 64, 64)];
    //start the timer
    self.lastStep = CACurrentMediaTime();
    self.timer = [CADisplayLink displayLinkWithTarget:self
                                             selector:@selector(step:)];
    [self.timer addToRunLoop:[NSRunLoop mainRunLoop]
                     forMode:NSDefaultRunLoopMode];
    //update gravity using accelerometer
    [UIAccelerometer sharedAccelerometer].delegate = self;
    [UIAccelerometer sharedAccelerometer].updateInterval = 1 / 60.0;
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    //update gravity
    cpSpaceSetGravity(self.space, cpv(acceleration.x * GRAVITY, acceleration.y * GRAVITY));
}


void updateShape(cpShape *shape, void *unused) {
    //get the crate object associated with the shape
    Crate *crate = (__bridge Crate *) shape->data;
    //update crate view position and angle to match physics shape
    cpBody *body = shape->body;
    crate.center = cpBodyGetPos(body);
    crate.transform = CGAffineTransformMakeRotation(cpBodyGetAngle(body));
}

/*
- (void)step:(CADisplayLink *)timer {
    //calculate step duration
    CFTimeInterval thisStep = CACurrentMediaTime();
    CFTimeInterval stepDuration = thisStep - self.lastStep;
    self.lastStep = thisStep;
    //update physics
    cpSpaceStep(self.space, stepDuration);
    //update all the shapes
    cpSpaceEachShape(self.space, &updateShape, NULL);
}
*/

//固定时间步长的木箱模拟,这里用120分之一秒
#define SIMULATION_STEP (1/120.0)

- (void)step:(CADisplayLink *)timer {
    //calculate frame step duration
    CFTimeInterval frameTime = CACurrentMediaTime();
    //update simulation
    while (self.lastStep < frameTime) {
        cpSpaceStep(self.space, SIMULATION_STEP);
        self.lastStep += SIMULATION_STEP;
    }

    //update all the shapes
    cpSpaceEachShape(self.space, &updateShape, NULL);
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
