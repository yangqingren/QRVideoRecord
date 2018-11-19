//
//  UIButton+LBStyle.h
//  LBCategory
//
//  Created by 刘文扬 on 2017/9/29.
//  Copyright © 2017年 杨庆人. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (LBStyle)

-(void)setGradientBlueBackgroundImage;

-(void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;


-(void)setAutoHighLightBackgroundColor:(UIColor *)backgroundColor;

-(void)setAutoHighLightTitleColor:(UIColor *)titleColor;

@end
