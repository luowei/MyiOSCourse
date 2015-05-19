//
// Created by luowei on 15/5/18.
// Copyright (c) 2015 rootls. All rights reserved.
//

#import "BaseKeyboardViewController.h"
#import "DaiDodgeKeyboard.h"


@implementation UIView (FindFirstResponder)

- (UIView *)findFirstResponder {
    if (self.isFirstResponder) return self;
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView findFirstResponder];
        if (firstResponder != nil) return firstResponder;
    }
    return nil;
}

@end


@interface BaseKeyboardViewController () <UITextFieldDelegate, UITextViewDelegate>

@end

@implementation BaseKeyboardViewController {

}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;

//    UIToolbar *toolBar = [self createToolbar];
    for (UIView *v in self.view.subviews) {
        if ([v isKindOfClass:[UITextView class]] || [v isKindOfClass:[UITextField class]]) {

            [v performSelector:@selector(setDelegate:) withObject:self];
//            [v performSelector:@selector(setInputAccessoryView:) withObject:toolBar];
        }
    }
    [DaiDodgeKeyboard addRegisterTheViewNeedDodgeKeyboard:self.view];
}


#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - private

- (UIToolbar *)createToolbar {
    UIToolbar *toolBar = [UIToolbar new];
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextTextField)];
    UIBarButtonItem *prevButton = [[UIBarButtonItem alloc] initWithTitle:@"Prev" style:UIBarButtonItemStylePlain target:self action:@selector(prevTextField)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(textFieldDone)];
    toolBar.items = @[prevButton, nextButton, space, done];
    [toolBar sizeToFit];
    return toolBar;
}

- (void)nextTextField {
    NSUInteger currentIndex = [[self inputViews] indexOfObject:[self.view findFirstResponder]];
    NSUInteger nextIndex = currentIndex + 1;
    nextIndex += [[self inputViews] count];
    nextIndex %= [[self inputViews] count];
    UITextField *nextTextField = [self inputViews][nextIndex];
    [nextTextField becomeFirstResponder];
}

- (void)prevTextField {
    NSUInteger currentIndex = [[self inputViews] indexOfObject:[self.view findFirstResponder]];
    NSUInteger prevIndex = currentIndex - 1;
    prevIndex += [[self inputViews] count];
    prevIndex %= [[self inputViews] count];
    UITextField *nextTextField = [self inputViews][prevIndex];
    [nextTextField becomeFirstResponder];
}

- (void)textFieldDone {
    [[self.view findFirstResponder] resignFirstResponder];
}

- (NSArray *)inputViews {
    NSMutableArray *returnArray = [NSMutableArray array];
    for (UIView *eachView in self.view.subviews) {
        //if ([eachView respondsToSelector:@selector(setText:)]) {
        if ([eachView isKindOfClass:[UITextView class]]) {
            [returnArray addObject:eachView];
        }
    }
    return returnArray;
}


@end