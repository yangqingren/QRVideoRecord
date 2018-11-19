//
//  UIView+LBDashLine.m
//  LBCategory
//
//  Created by LINAICAI on 2018/1/15.
//

#import "UIView+LBDashLine.h"
@implementation UIView (LBDashLine)
- (CAShapeLayer *)addDashLineWithColor:(UIColor *)color
                  leftMargin:(CGFloat)leftMargin
                 rightMargin:(CGFloat)rightMargin{
    return [self addDashLineWithColor:color leftMargin:leftMargin rightMargin:rightMargin lineWith:3.0 lineSpace:2.0];
    
}
- (CAShapeLayer *)addDashLineWithColor:(UIColor *)color
                  leftMargin:(CGFloat)leftMargin
                 rightMargin:(CGFloat)rightMargin
                    lineWith:(CGFloat)lineWith
                   lineSpace:(CGFloat)lineSpace{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    CGRect rect =  self.bounds;
    rect.size.height = 1.0;
    [shapeLayer setBounds:rect];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(rect) / 2, 0)];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:color.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(rect)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineWith], [NSNumber numberWithInt:lineSpace], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, leftMargin, 0);
    CGPathAddLineToPoint(path, NULL,CGRectGetWidth(rect)-rightMargin, 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [self.layer addSublayer:shapeLayer];
    return shapeLayer;
}


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
                                     lineSpace:(CGFloat)lineSpace {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    CGRect rect =  self.bounds;
    rect.size.width = 1.0;
    [shapeLayer setBounds:rect];
    //    [shapeLayer setPosition:CGPointMake(5, CGRectGetHeight(rect) / 2)];
    [shapeLayer setPosition:position];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:color.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetWidth(rect)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineWith], [NSNumber numberWithInt:lineSpace], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, topMargin);
    CGPathAddLineToPoint(path, NULL,0, CGRectGetHeight(rect)-bottomMargin);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [self.layer addSublayer:shapeLayer];
    return shapeLayer;
}

@end
