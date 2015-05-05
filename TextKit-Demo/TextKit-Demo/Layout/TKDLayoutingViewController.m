//
//  TKDLayoutingViewController.m
//  TextKit-Demo
//
//  Created by luowei on 15/5/5.
//  Copyright (c) 2015年 rootls. All rights reserved.
//

#import "TKDLayoutingViewController.h"
#import "TKDLinkDetectingTextStorage.h"
#import "TKDOutliningLayoutManager.h"

@interface TKDLayoutingViewController () <NSLayoutManagerDelegate> {
    // Text storage must be held strongly, only the default storage is retained by the text view.
    TKDLinkDetectingTextStorage *_textStorage;
}

@end

@implementation TKDLayoutingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Create componentes
    _textStorage = [TKDLinkDetectingTextStorage new];

    NSLayoutManager *layoutManager = [TKDOutliningLayoutManager new];
    [_textStorage addLayoutManager:layoutManager];

    CGSize size = self.view.bounds.size;
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(size.width, size.height-40)];
    [layoutManager addTextContainer:textContainer];

    self.view.backgroundColor = [UIColor whiteColor];
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectInset(self.view.bounds, 0, 20) textContainer:textContainer];
    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    textView.translatesAutoresizingMaskIntoConstraints = YES;
    textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    [self.view addSubview:textView];

/*
    UIView *innerView = [[UIView alloc] initWithFrame:CGRectInset(self.view.bounds, 50, 100)];
    innerView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:innerView];
*/

    // Set delegate
    layoutManager.delegate = self;

    // Load layout text
    [_textStorage replaceCharactersInRange:NSMakeRange(0, 0)
                                withString:[NSString stringWithContentsOfURL:[NSBundle.mainBundle
                                        URLForResource:@"layout" withExtension:@"txt"] usedEncoding:NULL error:NULL]];
}


#pragma mark - Layout

- (BOOL)layoutManager:(NSLayoutManager *)layoutManager shouldBreakLineByWordBeforeCharacterAtIndex:(NSUInteger)charIndex {
    NSRange range;
    NSURL *linkURL = [layoutManager.textStorage attribute:NSLinkAttributeName atIndex:charIndex effectiveRange:&range];

    // Do not break lines in links unless absolutely required
    if (linkURL && charIndex > range.location && charIndex <= NSMaxRange(range))
        return NO;
    else
        return YES;
}

- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect {
    return floorf(glyphIndex / 100);
}

- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager paragraphSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect {
    return 10;
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
