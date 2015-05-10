//
// Created by luowei on 15/5/10.
// Copyright (c) 2015 luowei. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "AVMetaDataViewController.h"


@interface AVMetaDataViewController () {
}

@end

@implementation AVMetaDataViewController {

}

/*
- (id)init {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return [self initWithNibName:@"AVPlayerDemoMetadataView-iPad" bundle:nil];
    }
    else {
        return [self initWithNibName:@"AVPlayerDemoMetadataView" bundle:nil];
    }
}
*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

/* Display the asset 'title' and 'copyright' metadata. */
- (void)syncLabels {
    /* Assume no metadata was found. */
    [_titleLabel setText:@"<Title metadata not found>"];
    [_copyrightLabel setText:@"<Copyright metadata not found>"];

    for (AVMetadataItem *item in self->_metadata) {
        NSString *commonKey = [item commonKey];

        if ([commonKey isEqualToString:AVMetadataCommonKeyTitle]) {
            [_titleLabel setText:[item stringValue]];
            [_titleLabel setHidden:NO];

//            //宽度不变，根据字的多少计算label的高度
//            CGSize size = [[item stringValue] sizeWithFont:_titleLabel.font constrainedToSize:CGSizeMake(_titleLabel.frame.size.width, MAXFLOAT)
//                              lineBreakMode:NSLineBreakByWordWrapping];
//            //根据计算结果重新设置UILabel的尺寸
//            [_titleLabel setFrame:CGRectMake(0, 10, self.view.frame.size.width-100, size.height)];
        }
        if ([commonKey isEqualToString:AVMetadataCommonKeyCopyrights]) {
            [_copyrightLabel setText:[item stringValue]];
            [_copyrightLabel setHidden:NO];

//            //宽度不变，根据字的多少计算label的高度
//            CGSize size = [[item stringValue] sizeWithFont:_titleLabel.font constrainedToSize:CGSizeMake(_titleLabel.frame.size.width, MAXFLOAT)
//                                             lineBreakMode:NSLineBreakByWordWrapping];
//            //根据计算结果重新设置UILabel的尺寸
//            [_titleLabel setFrame:CGRectMake(0, 10, self.view.frame.size.width-100, size.height)];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    CGSize viewSize = self.view.frame.size;
    self.view.backgroundColor = [UIColor whiteColor];

    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewSize.width-40, 50)];
    _titleLabel.center = CGPointMake(self.view.center.x, 100);
    _titleLabel.font = [UIFont boldSystemFontOfSize:24.0f];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_titleLabel];

    _copyrightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewSize.width-20, 100)];
    _copyrightLabel.center = CGPointMake(self.view.center.x, 200);
    _copyrightLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    _copyrightLabel.textAlignment = NSTextAlignmentCenter;
    _copyrightLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_copyrightLabel];

    [self syncLabels];

    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    infoBtn.frame = CGRectMake(viewSize.width-40, viewSize.height-40, 40, 40);
    infoBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin;
    [infoBtn addTarget:self action:@selector(goAway:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:infoBtn];
}


- (void)setMetadata:(NSArray *)metadata {
    self->_metadata = [metadata copy];

    [self syncLabels];
}

- (void)goAway:(id)sender {
    if ([self respondsToSelector:@selector(presentingViewController)]) {
        [[self presentingViewController] dismissViewControllerAnimated:YES completion:NULL];
    }
    else {
        [[self parentViewController] dismissViewControllerAnimated:YES completion:NULL];
    }

}

@end