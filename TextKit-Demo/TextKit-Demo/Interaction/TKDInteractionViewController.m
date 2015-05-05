//
//  TKDInteractionViewController.m
//  TextKit-Demo
//
//  Created by luowei on 15/5/5.
//  Copyright (c) 2015年 rootls. All rights reserved.
//

#import "TKDInteractionViewController.h"
#import "TKDCircleView.h"

@interface TKDInteractionViewController () <UITextViewDelegate> {
    CGPoint _panOffset;
}


@property(strong, nonatomic) UIImageView *clippyView;
@property(strong, nonatomic) TKDCircleView *circleView;
@property(strong, nonatomic) UITextView *textView;

@end

@implementation TKDInteractionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];
    self.textView = [[UITextView alloc] initWithFrame:CGRectInset(self.view.bounds, 0, 20)];
    [self.view addSubview:self.textView];

    self.circleView = [[TKDCircleView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    self.circleView.layer.opaque = NO;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectInset(self.circleView.bounds, 20, 60)];
    label.text = @"Drag Me!";
    label.textAlignment = NSTextAlignmentCenter;
    [self.circleView addSubview:label];
    [self.view addSubview:self.circleView];

    self.clippyView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clip"]];
    self.clippyView.frame = CGRectMake(150, 300, 30, 30);
    [self.view addSubview:self.clippyView];

    // Load text
    [self.textView.textStorage replaceCharactersInRange:NSMakeRange(0, 0)
                                             withString:[NSString stringWithContentsOfURL:[NSBundle.mainBundle
                                                     URLForResource:@"lorem" withExtension:@"txt"] usedEncoding:NULL error:NULL]];

    // Delegate
    self.textView.delegate = self;
    self.clippyView.hidden = YES;

    // Set up circle pan
    [self.circleView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(circlePan:)]];
    [self updateExclusionPaths];

    // Enable hyphenation
    self.textView.layoutManager.hyphenationFactor = 1.0;
}

#pragma mark - Exclusion

- (void)circlePan:(UIPanGestureRecognizer *)pan {
    // Capute offset in view on begin
    if (pan.state == UIGestureRecognizerStateBegan)
        _panOffset = [pan locationInView:self.circleView];

    // Update view location
    CGPoint location = [pan locationInView:self.view];
    CGPoint circleCenter = self.circleView.center;

    circleCenter.x = location.x - _panOffset.x + self.circleView.frame.size.width / 2;
    circleCenter.y = location.y - _panOffset.y + self.circleView.frame.size.width / 2;
    self.circleView.center = circleCenter;

    // Update exclusion path
    [self updateExclusionPaths];
}

- (void)updateExclusionPaths {
    CGRect ovalFrame = [self.textView convertRect:self.circleView.bounds fromView:self.circleView];

    // Since text container does not know about the inset, we must shift the frame to container coordinates
    ovalFrame.origin.x -= self.textView.textContainerInset.left;
    ovalFrame.origin.y -= self.textView.textContainerInset.top;

    // Simply set the exclusion path
    UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:ovalFrame];
    self.textView.textContainer.exclusionPaths = @[ovalPath];

    // And don't forget clippy
    [self updateClippy];
}


#pragma mark - Selection tracking

- (void)textViewDidChangeSelection:(UITextView *)textView {
    [self updateClippy];
}

- (void)updateClippy {
    // Zero length selection hide clippy
    NSRange selectedRange = self.textView.selectedRange;
    if (!selectedRange.length) {
        self.clippyView.hidden = YES;
        return;
    }

    // Find last rect of selection
    NSRange glyphRange = [self.textView.layoutManager glyphRangeForCharacterRange:selectedRange actualCharacterRange:NULL];
    __block CGRect lastRect;
    [self.textView.layoutManager enumerateEnclosingRectsForGlyphRange:glyphRange withinSelectedGlyphRange:glyphRange inTextContainer:self.textView.textContainer usingBlock:^(CGRect rect, BOOL *stop) {
        lastRect = rect;
    }];


    // Position clippy at bottom-right of selection
    CGPoint clippyCenter;
    clippyCenter.x = CGRectGetMaxX(lastRect) + self.textView.textContainerInset.left;
    clippyCenter.y = CGRectGetMaxY(lastRect) + self.textView.textContainerInset.top;

    clippyCenter = [self.textView convertPoint:clippyCenter toView:self.view];
    clippyCenter.x += self.clippyView.bounds.size.width / 2;
    clippyCenter.y += self.clippyView.bounds.size.height / 2;

    self.clippyView.hidden = NO;
    self.clippyView.center = clippyCenter;
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
