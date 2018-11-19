//
//  UIView+LBDashLine.h
//  LBCategory
//
//  Created by LINAICAI on 2018/1/15.
//  画虚线

#import <UIKit/UIKit.h>

@interface UIView (LBDashLine)

/**
 画虚线

 @param color 虚线颜色
 @param leftMargin 左边距
 @param rightMargin 右边距
 */
- (CAShapeLayer *)addDashLineWithColor:(UIColor *)color
                  leftMargin:(CGFloat)leftMargin
                 rightMargin:(CGFloat)rightMargin;

/**
 画虚线

 @param color 虚线颜色
 @param leftMargin 左边距
 @param rightMargin 右边距
 @param lineWith 线宽
 @param lineSpace 线间隔
 */
- (CAShapeLayer *)addDashLineWithColor:(UIColor *)color
                  leftMargin:(CGFloat)leftMargin
                 rightMargin:(CGFloat)rightMargin
                    lineWith:(CGFloat)lineWith
                   lineSpace:(CGFloat)lineSpace;


/**
 画竖虚线
 
 @param color 虚线颜色
 @param position 位置
 @param topMargin 上边距
 @param bottomMargin 下边距
 @param lineWith 线宽
 @param lineSpace 线间隔
 */
- (CAShapeLayer *)addDashVerticalLineWithColor:(UIColor *)color
                            position:(CGPoint)position
                           topMargin:(CGFloat)topMargin
                        bottomMargin:(CGFloat)bottomMargin
                            lineWith:(CGFloat)lineWith
                           lineSpace:(CGFloat)lineSpace;
@end
