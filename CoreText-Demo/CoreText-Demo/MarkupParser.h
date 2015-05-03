//
//  MarkupParser.h
//  CoreText-Demo
//
//  Created by luowei on 15/5/3.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface MarkupParser : NSObject

@property (strong, nonatomic) NSString *font;
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) UIColor *strokeColor;
@property (assign, readwrite) float strokeWidth;
@property (strong, nonatomic) NSMutableArray *images;

-(NSAttributedString *)attrStringFromMarkup:(NSString *)html;

@end
