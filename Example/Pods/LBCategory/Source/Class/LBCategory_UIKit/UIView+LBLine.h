//
//  UIView+LBLine.h
//  app
//
//  Created by LINAICAI on 16/5/30.
//  Copyright © 2016年 广东联结电子商务有限公司. All rights reserved.
//  给视图添加横线

#import <UIKit/UIKit.h>

@interface UIView (LBLine)

- (void)addLineUp:(BOOL)hasUp
          andDown:(BOOL)hasDown
         andColor:(UIColor *)color;

- (void)addLineIsUp:(BOOL)isUp
         LeftMargin:(CGFloat)leftMargin
        RightMargin:(CGFloat)rightMargin;

- (void)addLineIsLeft:(BOOL)isLeft
            TopMargin:(CGFloat)topMargin
         BottomMargin:(CGFloat)bottomMargin;

- (void)addLineIsUp:(BOOL)isUp
              Color:(UIColor *)color
         LeftMargin:(CGFloat)leftMargin
        RightMargin:(CGFloat)rightMargin;

- (void)setBorderDashedLineByBorderColor:(UIColor *)borderColor;//default borderColor is blue must have size

- (void)addLineWithTopView:(UIView *)topView
      topMarginFromTopView:(CGFloat)topMarginFromTopView
                LeftMargin:(CGFloat)leftMargin
               RightMargin:(CGFloat)rightMargin;

- (UIView *)addLineWithBottomView:(UIView *)bottomView
      bottomMarginFrombottomView:(CGFloat)bottomMarginFrombottomView
                LeftMargin:(CGFloat)leftMargin
               RightMargin:(CGFloat)rightMargin;
/**
 *  画虚线
 *
 *  @param lineView    view
 *  @param lineLength  长度
 *  @param lineSpacing 空隙
 *  @param lineColor   颜色
 */
+ (void)lb_drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

@end
