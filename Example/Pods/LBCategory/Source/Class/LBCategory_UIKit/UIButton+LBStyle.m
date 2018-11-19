//
//  UIButton+LBStyle.m
//  LBCategory
//
//  Created by 刘文扬 on 2017/9/29.
//  Copyright © 2017年 杨庆人. All rights reserved.
//

#import "UIButton+LBStyle.h"
#import "UIImage+LBGradientColor.h"
#import "UIImage+LBImage.h"
#import "UIColor+LBColor.h"

@implementation UIButton (LBStyle)

- (void)setGradientBlueBackgroundImage
{
    [self setBackgroundImage:[UIImage lb_gradientBlueImage] forState:UIControlStateNormal];
    
    [self setBackgroundImage:[UIImage lb_highlightGradientBlueImage] forState:UIControlStateHighlighted];
}


-(void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state
{
    UIImage *image = [UIImage GetImageFromColor:backgroundColor rect:CGRectMake(0, 0, 4, 4)];
    [self setBackgroundImage:image forState:state];
}

-(void)setAutoHighLightBackgroundColor:(UIColor *)backgroundColor
{
    UIColor *normalColor = backgroundColor;
    //如果本身背景是深色的话,那么高亮颜色就是此颜色像黑色过度的15%颜色
    //如果本身背景是浅色,那么高亮颜色就是此颜色像白色过度的.25%颜色
    UIColor *highLightColor;
    if ([normalColor lb_colorIsDark]) {
        highLightColor = [normalColor lb_transitionToColor:[UIColor blackColor] progress:.15];
    }else{
        highLightColor = [normalColor lb_transitionToColor:[UIColor whiteColor] progress:.25];
    }
    [self setBackgroundColor:normalColor forState:UIControlStateNormal];
    [self setBackgroundColor:highLightColor forState:UIControlStateHighlighted];
}

-(void)setAutoHighLightTitleColor:(UIColor *)titleColor
{
    UIColor *normalColor = titleColor;
    //如果本身背景是深色的话,那么高亮颜色就是此颜色像黑色过度的15%颜色
    //如果本身背景是浅色,那么高亮颜色就是此颜色像白色过度的.25%颜色
    UIColor *highLightColor;
    if ([normalColor lb_colorIsDark]) {
        highLightColor = [normalColor lb_transitionToColor:[UIColor blackColor] progress:.15];
    }else{
        highLightColor = [normalColor lb_transitionToColor:[UIColor whiteColor] progress:.25];
    }
    [self setTitleColor:normalColor forState:UIControlStateNormal];
    [self setTitleColor:highLightColor forState:UIControlStateHighlighted];
}

@end
