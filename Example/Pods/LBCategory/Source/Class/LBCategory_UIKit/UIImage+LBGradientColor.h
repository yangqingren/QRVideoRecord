//
//  UIImage+LBGradientColor.h
//  LBCategory
//
//  Created by 刘文扬 on 2017/9/29.
//  Copyright © 2017年 杨庆人. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GradientType) {
    GradientTypeTopToBottom = 0,//从上到小
    GradientTypeLeftToRight = 1,//从左到右
    GradientTypeUpleftToLowright = 2,//左上到右下
    GradientTypeUprightToLowleft = 3,//右上到左下
};


@interface UIImage (LBGradientColor)

+ (UIImage *)lb_gradientColorImageFromColors:(NSArray*)colors gradientType:(GradientType)gradientType imgSize:(CGSize)imgSize;


+ (UIImage *)lb_gradientBlueImage;

+ (UIImage *)lb_highlightGradientBlueImage;

@end
