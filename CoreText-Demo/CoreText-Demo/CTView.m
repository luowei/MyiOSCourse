//
//  CTView.m
//  CoreText-Demo
//
//  Created by luowei on 15/5/3.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import "CTView.h"
#import "MarkupParser.h"
#import "CTColumnView.h"

@implementation CTView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
/*
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();

    //由于core text使用左下方为原点的坐标系，所以要翻转坐标系
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, (CGFloat) -1.0);

    //创建一个当前视图大小的路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);

    // NSAttributeString -> CTFramesetterRef -> CTFrameRef ,并通过CTFrameDraw绘制出来
//    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"Hello core text world!"];

//    MarkupParser* p = [[MarkupParser alloc] init];
//    NSAttributedString *attrString = [p attrStringFromMarkup: @"Hello <font color=\"red\">core text <font color=\"blue\">world!"];

    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) self.attrString);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, (CFIndex) [self.attrString length]), path, NULL);
    CTFrameDraw(frame, context);

    //释放资源
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);
*/

    [self buildFrames];
}


- (void)setAttrString:(NSAttributedString *)string withImages:(NSArray *)imgs {
    self.attrString = string;
    self.images = imgs;


    CTTextAlignment alignment = kCTJustifiedTextAlignment;

    CTParagraphStyleSetting settings[] = {
            {kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment},
    };
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(settings[0]));
    NSDictionary *attrDictionary = @{(NSString *) kCTParagraphStyleAttributeName : (__bridge id) paragraphStyle};

    NSMutableAttributedString* stringCopy = [[NSMutableAttributedString alloc] initWithAttributedString:self.attrString];
    [stringCopy addAttributes:attrDictionary range:NSMakeRange(0, [string length])];
    self.attrString = (NSAttributedString*)stringCopy;
}


- (void)buildFrames {
    //设置字形在textFrame中X,Y方向的偏移、允许分页、定义空数组
    frameXOffset = 20;
    frameYOffset = 20;
    self.pagingEnabled = YES;
    self.delegate = self;
    self.frames = [NSMutableArray array];

    //构造一个当前视图范围内的path
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect textFrame = CGRectInset(self.bounds, frameXOffset, frameYOffset);
    CGPathAddRect(path, NULL, textFrame );

    //加载属性字串，构造CTFramesetterRef
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.attrString);

    //声明插入符位置及文本位置索引变量
    int textPos = 0;
    int columnIndex = 0;

    while (textPos < [self.attrString length]) { //4
        CGPoint colOffset = CGPointMake( (columnIndex+1)*frameXOffset + columnIndex*(textFrame.size.width/2), 20 );
        CGRect colRect = CGRectMake(0, 0 , textFrame.size.width/2-10, textFrame.size.height-40);

        //构造一个textFrame范围内的path
        CGMutablePathRef textPath = CGPathCreateMutable();
        CGPathAddRect(textPath, NULL, colRect);

        //use the column path
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(textPos, 0), textPath, NULL);
        CFRange frameRange = CTFrameGetVisibleStringRange(frame);

        //create an empty column view
        CTColumnView* content = [[CTColumnView alloc] initWithFrame: CGRectMake(0, 0, self.contentSize.width, self.contentSize.height)];
        content.backgroundColor = [UIColor clearColor];
        content.frame = CGRectMake(colOffset.x, colOffset.y, colRect.size.width, colRect.size.height) ;

        //set the column view contents and add it as subview
        [content setCtFrame:(__bridge id)frame];
        //附加图片
        [self attachImagesWithFrame:frame inColumnView: content];
        [self.frames addObject: (__bridge id)frame];
        [self addSubview: content];

        //prepare for next frame
        textPos += frameRange.length;

        CFRelease(frame);
        CFRelease(textPath);

        columnIndex++;
    }

    //set the total width of the scroll view
    int totalPages = (columnIndex+1) / 2;
    self.contentSize = CGSizeMake(totalPages*self.bounds.size.width, textFrame.size.height);

    CFRelease(framesetter);
    CFRelease(path);
}


-(void)attachImagesWithFrame:(CTFrameRef)f inColumnView:(CTColumnView*)col
{
    //drawing images

    //CTFrameGetLines gives you back an array of CTLine objects
    NSArray *lines = (NSArray *)CTFrameGetLines(f);

    CGPoint origins[[lines count]];
    CTFrameGetLineOrigins(f, CFRangeMake(0, 0), origins); //2

    int imgIndex = 0;
    //You load nextImage with the attribute data of the first image in the text
    // and imgLocation holds the string position of that same image
    NSDictionary* nextImage = self.images[imgIndex];
    int imgLocation = [nextImage[@"location"] intValue];

    //find images for the current column
    //CTFrameGetVisibleStringRange gives you the visible text range for the frame you’re rendering
    CFRange frameRange = CTFrameGetVisibleStringRange(f);
    while ( imgLocation < frameRange.location ) {
        imgIndex++;
        if (imgIndex>=[self.images count]) return; //quit if no images for this column
        nextImage = self.images[imgIndex];
        imgLocation = [nextImage[@"location"] intValue];
    }

    NSUInteger lineIndex = 0;
    //You loop trough the text’s lines and loads each line into the “line” variable
    for (id lineObj in lines) {
        CTLineRef line = (__bridge CTLineRef)lineObj;

        //You loop trough all the runs of that line (you get them by calling CTLineGetGlyphRuns).
        for (id runObj in (NSArray *)CTLineGetGlyphRuns(line)) {
            CTRunRef run = (__bridge CTRunRef)runObj;
            CFRange runRange = CTRunGetStringRange(run);

            //You check whether the next image is located inside the range of the present run ,
            // if so then you have to go on and proceed to rendering the image at this precise spot.
            if ( runRange.location <= imgLocation && runRange.location+runRange.length > imgLocation ) {
                CGRect runBounds;
                CGFloat ascent;//height above the baseline
                CGFloat descent;//height below the baseline

                //You figure out the width and height of the run, by using the CTRunGetTypographicBounds method.
                runBounds.size.width = (CGFloat) CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
                runBounds.size.height = ascent + descent;

                //You figure out the origin of the run, by using the CTLineGetOffsetForStringIndex and other offsets.
                CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
                runBounds.origin.x = origins[lineIndex].x + self.frame.origin.x + xOffset + frameXOffset;
                runBounds.origin.y = origins[lineIndex].y + self.frame.origin.y + frameYOffset;
                runBounds.origin.y -= descent;

                //You load the image with the given name in the variable “img”
                // and get the rectangle of the current column and eventually the rectangle where the image needs to be rendered.
                UIImage *img = [UIImage imageNamed:nextImage[@"fileName"]];
                CGPathRef pathRef = CTFrameGetPath(f);
                CGRect colRect = CGPathGetBoundingBox(pathRef);

                //You create an NSArray with the UIImage and the calculated frame for it,
                // then you add it to the CTColumnView’s image list
                CGRect imgBounds = CGRectOffset(runBounds, colRect.origin.x - frameXOffset - self.contentOffset.x,
                        colRect.origin.y - frameYOffset - self.frame.origin.y);
                [col.images addObject:@[img, NSStringFromCGRect(imgBounds)]];


                //load the next image
                //In the end the next image in the list is loaded if one exists and the loop goes on over the text’s lines.
                imgIndex++;
                if (imgIndex < [self.images count]) {
                    nextImage = self.images[imgIndex];
                    imgLocation = [nextImage[@"location"] intValue];
                }

            }
        }
        lineIndex++;
    }
}


@end
