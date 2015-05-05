//
//  MarkupParser.m
//  CoreText-Demo
//
//  Created by luowei on 15/5/3.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import "MarkupParser.h"

@implementation MarkupParser

- (instancetype)init {
    self = [super init];
    if (self) {
        self.font = @"Arial";
        self.color = [UIColor blackColor];
        self.strokeColor = [UIColor whiteColor];
        self.strokeWidth = 0.0;
        self.images = [NSMutableArray array];
    }

    return self;
}


/* Callbacks */
static void deallocCallback( void* ref ){
    ref = nil;
//    [(id)ref release];
}
static CGFloat ascentCallback( void *ref ){
    return [(NSString*) ((__bridge NSDictionary *) ref)[@"height"] floatValue];
}
static CGFloat descentCallback( void *ref ){
    return [(NSString*) ((__bridge NSDictionary *) ref)[@"descent"] floatValue];
}
static CGFloat widthCallback( void* ref ){
    return [(NSString*) ((__bridge NSDictionary *) ref)[@"width"] floatValue];
}


- (NSAttributedString *)attrStringFromMarkup:(NSString *)html {
    //创建一个空的属性字符串用来存放匹配的字串
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:@""];

    //创建一个正则表达式匹配的文本和标签块。
    NSRegularExpression *regex = [[NSRegularExpression alloc]
            initWithPattern:@"(.*?)(<[^>]+>|\\Z)"
                    options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
                      error:nil];
    NSArray *chunks = [regex matchesInString:html options:0 range:NSMakeRange(0, [html length])];

    //遍历匹配的块，从标签与文本循环构建属性字串
    for(NSTextCheckingResult *b in chunks){
        NSArray *parts = [[html substringWithRange:b.range] componentsSeparatedByString:@"<"];
        CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef) self.font, 24.0f, NULL);

        //应用当前文本默认样式
        NSDictionary *attrs = @{
                (__bridge NSString*) kCTForegroundColorAttributeName : (__bridge id) self.color.CGColor,
                (__bridge NSString*) kCTFontAttributeName : (__bridge id) fontRef,
                (__bridge NSString*) kCTStrokeColorAttributeName : (__bridge id) self.strokeColor.CGColor,
                (__bridge NSString*) kCTStrokeWidthAttributeName: @(self.strokeWidth),

        };
        [aString appendAttributedString:[[NSAttributedString alloc] initWithString:parts[0] attributes:attrs]];
        CFRelease(fontRef);

        //处理标签中附加的样式
        if([parts count]>1){
            NSString *tag = (NSString *)parts[1];
            if([tag hasPrefix:@"font"]){
                //画笔颜色
                NSRegularExpression *scolorRegex = [[NSRegularExpression alloc] initWithPattern:@"(?<=strokeColor=\")\\w+" options:0 error:NULL];
                [scolorRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length])
                                           usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop){
                    if([[tag substringWithRange:result.range] isEqualToString:@"none"]){
                        self.strokeWidth = 0.0;
                    }else{
                        self.strokeWidth = -3.0f;
                        SEL colorSel = NSSelectorFromString([NSString stringWithFormat:@"%@Color", [tag substringWithRange:result.range]]);
                        self.strokeColor = [UIColor performSelector:colorSel];
                    }
                }];

                //文本颜色
                NSRegularExpression* colorRegex = [[NSRegularExpression alloc] initWithPattern:@"(?<=color=\")\\w+" options:0 error:NULL];
                [colorRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length])
                                          usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    SEL colorSel = NSSelectorFromString([NSString stringWithFormat: @"%@Color", [tag substringWithRange:match.range]]);
                    self.color = [UIColor performSelector:colorSel];
                }];

                //文本外观字体
                NSRegularExpression* faceRegex = [[NSRegularExpression alloc] initWithPattern:@"(?<=face=\")[^\"]+" options:0 error:NULL];
                [faceRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length])
                                         usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    self.font = [tag substringWithRange:match.range];
                }];

            } //end of font parsing


            //解析img
            if ([tag hasPrefix:@"img"]) {

                __block NSNumber* width = @0;
                __block NSNumber* height = @0;
                __block NSString* fileName = @"";

                //width
                NSRegularExpression* widthRegex = [[NSRegularExpression alloc] initWithPattern:@"(?<=width=\")[^\"]+" options:0 error:NULL];
                [widthRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length])
                                          usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    width = @([[tag substringWithRange:match.range] intValue]);
                }];

                //height
                NSRegularExpression* faceRegex = [[NSRegularExpression alloc] initWithPattern:@"(?<=height=\")[^\"]+" options:0 error:NULL];
                [faceRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length])
                                         usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    height = @([[tag substringWithRange:match.range] intValue]);
                }];

                //image
                NSRegularExpression* srcRegex = [[NSRegularExpression alloc] initWithPattern:@"(?<=src=\")[^\"]+" options:0 error:NULL];
                [srcRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length])
                                        usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    fileName = [tag substringWithRange: match.range];
                }];

                //add the image for drawing
                [self.images addObject:@{@"width" : width,
                                @"height" : height,
                                @"fileName" : fileName,
                                @"location" : @([aString length])}
                ];

                //render empty space for drawing the image in the text //1
                CTRunDelegateCallbacks callbacks;
                callbacks.version = kCTRunDelegateVersion1;
                callbacks.getAscent = ascentCallback;
                callbacks.getDescent = descentCallback;
                callbacks.getWidth = widthCallback;
                callbacks.dealloc = deallocCallback;

                NSDictionary* imgAttr = @{@"width": width,@"height" : height};

                CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void *)imgAttr); //3
                NSDictionary *attrDictionaryDelegate = @{(NSString *) kCTRunDelegateAttributeName : (__bridge id) delegate};

                //add a space to the text so that it can call the delegate
                [aString appendAttributedString:[[NSAttributedString alloc] initWithString:@" " attributes:attrDictionaryDelegate]];
            }
        }

    }

    return aString;
}


- (void)dealloc {
    self.font = nil;
    self.color = nil;
    self.strokeColor = nil;
    self.images = nil;
}


@end
