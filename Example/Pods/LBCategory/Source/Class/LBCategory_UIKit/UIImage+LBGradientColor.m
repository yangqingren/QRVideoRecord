//
//  UIImage+LBGradientColor.m
//  LBCategory
//
//  Created by 刘文扬 on 2017/9/29.
//  Copyright © 2017年 杨庆人. All rights reserved.
//

#import "UIImage+LBGradientColor.h"


@implementation UIImage (LBGradientColor)

+ (UIImage *)lb_gradientColorImageFromColors:(NSArray*)colors gradientType:(GradientType)gradientType imgSize:(CGSize)imgSize {
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(imgSize, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint start;
    CGPoint end;
    switch (gradientType) {
        case GradientTypeTopToBottom:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, imgSize.height);
            break;
        case GradientTypeLeftToRight:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(imgSize.width, 0.0);
            break;
        case GradientTypeUpleftToLowright:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(imgSize.width, imgSize.height);
            break;
        case GradientTypeUprightToLowleft:
            start = CGPointMake(imgSize.width, 0.0);
            end = CGPointMake(0.0, imgSize.height);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}


+(UIImage *)lb_highlightGradientBlueImage
{
    UIColor *blueBeginColor =[UIColor colorWithRed:88.0/255.0 green:121.0/255.0 blue:204.0/255.0 alpha:1];
    
    UIColor *blueEndColor =[UIColor colorWithRed:82.0/255.0 green:170.0/255.0 blue:190.0/255.0 alpha:1];
    
    CGSize imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 50);
    
    return [UIImage lb_gradientColorImageFromColors:@[blueBeginColor,blueEndColor] gradientType:GradientTypeLeftToRight imgSize:imageSize];
}

+(UIImage *)lb_gradientBlueImage
{

    UIColor *blueBeginColor =[UIColor colorWithRed:110.0/255.0 green:152.0/255.0 blue:255.0/255.0 alpha:1];
    
    UIColor *blueEndColor =[UIColor colorWithRed:103.0/255.0 green:212.0/255.0 blue:238.0/255.0 alpha:1];
    
    CGSize imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 50);
    
    return [UIImage lb_gradientColorImageFromColors:@[blueBeginColor,blueEndColor] gradientType:GradientTypeLeftToRight imgSize:imageSize];
}

@end
