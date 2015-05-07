//
//  LoadingPic.h
//  CFNetWork-Demo
//
//  Created by luowei on 15/5/7.
//  Copyright (c) 2015年 rootls. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingPic : UIImageView

- (id)initWithFrame:(CGRect)frame url:(NSString *)_url;
- (void) downloadImage:(NSString*)url;
-(void)httpConnectEnd;
-(void)fillPhoto:(UIImage*)image;
-(void)httpConnectStart;

@end
