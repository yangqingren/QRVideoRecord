//
//  UIView+Animation.m
//  app
//
//  Created by 赵辉 on 2017/2/14.
//  Copyright © 2017年 NAICAI LI. All rights reserved.
//

#import "UIView+Animation.h"

@implementation UIView (Animation)

- (void)transitionWithType:(NSString *)type WithSubtype:(NSString *)subtype ForView:(UIView *)view
{
    //创建CATransition对象
    CATransition *animation = [CATransition animation];
    
    //设置运动时间
    animation.duration = 0.25;
    
    //设置运动type
    animation.type = type;
    if (subtype != nil) {
        
        //设置子类
        animation.subtype = subtype;
    }
    
    //设置运动速度
    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    
    [view.layer addAnimation:animation forKey:@"animation"];
}

@end
