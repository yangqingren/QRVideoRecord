//
//  UIView+Animation.h
//  app
//
//  Created by 赵辉 on 2017/2/14.
//  Copyright © 2017年 NAICAI LI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Animation)

- (void)transitionWithType:(NSString *)type WithSubtype:(NSString *)subtype ForView:(UIView *)view;

@end
