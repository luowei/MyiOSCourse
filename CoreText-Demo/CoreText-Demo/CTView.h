//
//  CTView.h
//  CoreText-Demo
//
//  Created by luowei on 15/5/3.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@class CTColumnView;

@interface CTView : UIScrollView<UIScrollViewDelegate> {
    float frameXOffset;
    float frameYOffset;
}

@property(nonatomic, strong) NSAttributedString *attrString;

@property (strong, nonatomic) NSMutableArray* frames;

@property (retain, nonatomic) NSArray* images;


- (void)buildFrames;

-(void)setAttrString:(NSAttributedString *)string withImages:(NSArray*)imgs;

-(void)attachImagesWithFrame:(CTFrameRef)f inColumnView:(CTColumnView*)col;

@end
