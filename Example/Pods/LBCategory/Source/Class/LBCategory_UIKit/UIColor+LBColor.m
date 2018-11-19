//
//  UIColor+LBColor.m
//  app
//
//  Created by LINAICAI on 16/4/29.
//  Copyright © 2016年 广东联结电子商务有限公司. All rights reserved.
//

#import "UIColor+LBColor.h"

@implementation UIColor (LBColor)
#pragma mark- 蓝色(深蓝、联结蓝、浅蓝)
+ (UIColor *) darkBlue{
   return [UIColor colorWithR:5 G:128 B:244];
}
+ (UIColor *) blue{
   return [UIColor colorWithR:42 G:153 B:241];
}
+ (UIColor *) lightBlue{
   return [UIColor colorWithR:67 G:178 B:255];
}
#pragma mark- 红色(深红、联结红、浅红)
+ (UIColor *) darkRed{
    return [UIColor colorWithR:255 G:49 B:32];
}
+ (UIColor *) red{
    return [UIColor colorWithR:252 G:92 B:56];
}
+ (UIColor *) lightRed{
    return [UIColor colorWithR:254 G:137 B:60];
}
#pragma mark- 黑色(深黑、联结黑、浅黑)
+ (UIColor *) darkBlack{
    return [UIColor colorWithR:69 G:69 B:69];
}
+ (UIColor *) black{
    return [UIColor colorWithR:153 G:153 B:153];
}
+ (UIColor *) lightBlack{
    return [UIColor colorWithR:209 G:209 B:209];
}
#pragma mark- 灰色(深灰=联结黑、联结灰、浅灰)
+ (UIColor *) darkGray{
    return [UIColor colorWithR:153 G:153 B:153];
}
+ (UIColor *) gray{
    return [UIColor colorWithR:216 G:216 B:216];
}
+ (UIColor *) lightGray{
    return [UIColor colorWithR:246 G:246 B:246];
}
+ (UIColor *) colorWithR:(NSInteger)r G:(NSInteger)g B:(NSInteger)b{
    return [UIColor colorWithR:r G:g B:b A:1.0];
}
#pragma mark- RGBA模式
+ (UIColor *) colorWithR:(NSInteger)r G:(NSInteger)g B:(NSInteger)b A:(CGFloat)a{
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
}
#pragma mark- 16进制颜色
+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


- (CGFloat)lb_red {
    CGFloat r;
    if ([self getRed:&r green:0 blue:0 alpha:0]) {
        return r;
    }
    return 0;
}

- (CGFloat)lb_green {
    CGFloat g;
    if ([self getRed:0 green:&g blue:0 alpha:0]) {
        return g;
    }
    return 0;
}

- (CGFloat)lb_blue {
    CGFloat b;
    if ([self getRed:0 green:0 blue:&b alpha:0]) {
        return b;
    }
    return 0;
}

- (CGFloat)lb_alpha {
    CGFloat a;
    if ([self getRed:0 green:0 blue:0 alpha:&a]) {
        return a;
    }
    return 0;
}

-(UIColor *)lb_transitionToColor:(UIColor *)toColor progress:(CGFloat)progress
{
    return [UIColor lb_colorFromColor:self toColor:toColor progress:progress];
}

+ (UIColor *)lb_colorFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor progress:(CGFloat)progress {
    progress = MIN(progress, 1.0f);
    CGFloat fromRed = fromColor.lb_red;
    CGFloat fromGreen = fromColor.lb_green;
    CGFloat fromBlue = fromColor.lb_blue;
    CGFloat fromAlpha = fromColor.lb_alpha;
    
    CGFloat toRed = toColor.lb_red;
    CGFloat toGreen = toColor.lb_green;
    CGFloat toBlue = toColor.lb_blue;
    CGFloat toAlpha = toColor.lb_alpha;
    
    CGFloat finalRed = fromRed + (toRed - fromRed) * progress;
    CGFloat finalGreen = fromGreen + (toGreen - fromGreen) * progress;
    CGFloat finalBlue = fromBlue + (toBlue - fromBlue) * progress;
    CGFloat finalAlpha = fromAlpha + (toAlpha - fromAlpha) * progress;
    
    return [UIColor colorWithRed:finalRed green:finalGreen blue:finalBlue alpha:finalAlpha];
}

- (BOOL)lb_colorIsDark {
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    
    float referenceValue = 0.411;
    float colorDelta = ((red * 0.299) + (green * 0.587) + (blue * 0.114));
    
    return 1.0 - colorDelta > referenceValue;
}


@end
