//
//  UIColor+LBColor.h
//  app
//
//  Created by LINAICAI on 16/4/29.
//  Copyright © 2016年 广东联结电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (LBColor)
#pragma mark- 蓝色(深蓝、联结蓝、浅蓝)
+ (UIColor *) darkBlue;
+ (UIColor *) blue;
+ (UIColor *) lightBlue;
#pragma mark- 红色(深红、联结红、浅红)
+ (UIColor *) darkRed;
+ (UIColor *) red;
+ (UIColor *) lightRed;
#pragma mark- 黑色(深黑、联结黑、浅黑)
+ (UIColor *) darkBlack;
+ (UIColor *) black;
+ (UIColor *) lightBlack;
#pragma mark- 灰色(深灰、联结灰、浅灰)
+ (UIColor *) darkGray;
+ (UIColor *) gray;
+ (UIColor *) lightGray;
#pragma mark- RGB模式
+ (UIColor *) colorWithR:(NSInteger)r G:(NSInteger)g B:(NSInteger)b;
#pragma mark- RGBA模式
+ (UIColor *) colorWithR:(NSInteger)r G:(NSInteger)g B:(NSInteger)b A:(CGFloat)a;
#pragma mark- 16进制颜色
+ (UIColor *) colorWithHexString: (NSString *)color;


/**
 *  获取当前UIColor对象里的红色色值
 *
 *  @return 红色通道的色值，值范围为0.0-1.0
 */
- (CGFloat)lb_red;

/**
 *  获取当前UIColor对象里的绿色色值
 *
 *  @return 绿色通道的色值，值范围为0.0-1.0
 */
- (CGFloat)lb_green;

/**
 *  获取当前UIColor对象里的蓝色色值
 *
 *  @return 蓝色通道的色值，值范围为0.0-1.0
 */
- (CGFloat)lb_blue;

/**
 *  获取当前UIColor对象里的透明色值
 *
 *  @return 透明通道的色值，值范围为0.0-1.0
 */
- (CGFloat)lb_alpha;

/**
 *  将自身变化到某个目标颜色，可通过参数progress控制变化的程度，最终得到一个纯色
 *  @param toColor 目标颜色
 *  @param progress 变化程度，取值范围0.0f~1.0f
 */
- (UIColor *)lb_transitionToColor:(UIColor *)toColor progress:(CGFloat)progress;

/**
 *  判断当前颜色是否为深色，可用于根据不同色调动态设置不同文字颜色的场景。
 *
 *  @link http://stackoverflow.com/questions/19456288/text-color-based-on-background-image @/link
 *
 *  @return 若为深色则返回“YES”，浅色则返回“NO”
 */
- (BOOL)lb_colorIsDark;

@end
