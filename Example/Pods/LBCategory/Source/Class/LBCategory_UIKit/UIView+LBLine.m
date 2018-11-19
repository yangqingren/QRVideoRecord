//
//  UIView+LBLine.m
//  app
//
//  Created by LINAICAI on 16/5/30.
//  Copyright © 2016年 广东联结电子商务有限公司. All rights reserved.
//

#import "UIView+LBLine.h"
#import <Masonry/Masonry.h>
#import "UIColor+LBColor.h"

#define kTagBadgeView  1000
#define kTagLineView 1007
#define kScreen_Width [UIScreen mainScreen].bounds.size.width
@implementation UIView (LBLine)
- (void)addLineUp:(BOOL)hasUp andDown:(BOOL)hasDown andColor:(UIColor *)color{
    [self removeViewWithTag:kTagLineView];
    if (hasUp) {
        UIView *upView = [UIView lineViewWithPointYY:0 andColor:color];
        upView.tag = kTagLineView;
        [self addSubview:upView];
    }
    if (hasDown) {
        UIView *downView = [UIView lineViewWithPointYY:CGRectGetMaxY(self.bounds)-0.5 andColor:color];
        downView.tag = kTagLineView;
        [self addSubview:downView];
    }
    return [self addLineUp:hasUp andDown:hasDown andColor:color andLeftSpace:0];
}
- (void)addLineUp:(BOOL)hasUp andDown:(BOOL)hasDown andColor:(UIColor *)color andLeftSpace:(CGFloat)leftSpace{
    [self removeViewWithTag:kTagLineView];
    if (hasUp) {
        UIView *upView = [UIView lineViewWithPointYY:0 andColor:color andLeftSpace:leftSpace];
        upView.tag = kTagLineView;
        [self addSubview:upView];
    }
    if (hasDown) {
        UIView *downView = [UIView lineViewWithPointYY:CGRectGetMaxY(self.bounds)-0.5 andColor:color andLeftSpace:leftSpace];
        downView.tag = kTagLineView;
        [self addSubview:downView];
    }
}
+ (UIView *)lineViewWithPointYY:(CGFloat)pointY andColor:(UIColor *)color{
    return [self lineViewWithPointYY:pointY andColor:color andLeftSpace:0];
}

- (void)removeViewWithTag:(NSInteger)tag{
    for (UIView *aView in [self subviews]) {
        if (aView.tag == tag) {
            [aView removeFromSuperview];
        }
    }
}
+ (UIView *)lineViewWithPointYY:(CGFloat)pointY andColor:(UIColor *)color andLeftSpace:(CGFloat)leftSpace{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(leftSpace, pointY, kScreen_Width - leftSpace, 0.5)];
    lineView.backgroundColor = color;
    return lineView;
}

- (void)addLineIsUp:(BOOL)isUp LeftMargin:(CGFloat)leftMargin RightMargin:(CGFloat)rightMargin
{
    __weak typeof(self)weakSelf = self;
    [self removeViewWithTag:kTagLineView];
    UIView *lineView = [[UIView alloc]init];
    [self addSubview:lineView];
    lineView.tag = kTagLineView;
    lineView.backgroundColor = [UIColor colorWithR:243 G:244 B:245 A:1];
    if (isUp) {
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf);
            make.left.mas_equalTo(weakSelf).offset(leftMargin);
            make.right.mas_equalTo(weakSelf).offset(-rightMargin);
            make.height.mas_equalTo(1);
        }];
    } else {
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(weakSelf);
            make.left.mas_equalTo(weakSelf).offset(leftMargin);
            make.right.mas_equalTo(weakSelf).offset(-rightMargin);
            make.height.mas_equalTo(1);
        }];
    }
}

- (void)addLineIsLeft:(BOOL)isLeft
            TopMargin:(CGFloat)topMargin
         BottomMargin:(CGFloat)bottomMargin
{
    [self removeViewWithTag:kTagLineView];
    UIView *lineView = [[UIView alloc]init];
    [self addSubview:lineView];
    lineView.tag = kTagLineView;
    lineView.backgroundColor = [UIColor colorWithR:243 G:244 B:245 A:1];
    if (isLeft) {
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(topMargin);
            make.bottom.mas_equalTo(self).offset(-bottomMargin);
            make.left.mas_equalTo(self);
            make.width.mas_equalTo(1);
        }];
    } else {
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(topMargin);
            make.bottom.mas_equalTo(self).offset(-bottomMargin);
            make.right.mas_equalTo(self);
            make.width.mas_equalTo(1);
        }];
    }
}

- (void)addLineIsUp:(BOOL)isUp
              Color:(UIColor *)color
         LeftMargin:(CGFloat)leftMargin
        RightMargin:(CGFloat)rightMargin
{
    [self removeViewWithTag:kTagLineView];
    UIView *lineView = [[UIView alloc]init];
    [self addSubview:lineView];
    lineView.tag = kTagLineView;
    if (color) {
        lineView.backgroundColor = color;
    } else {
        lineView.backgroundColor = [UIColor colorWithR:243 G:244 B:245 A:1];
    }
    if (isUp) {
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self);
            make.left.mas_equalTo(self).offset(leftMargin);
            make.right.mas_equalTo(self).offset(-rightMargin);
            make.height.mas_equalTo(1);
        }];
    } else {
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self);
            make.left.mas_equalTo(self).offset(leftMargin);
            make.right.mas_equalTo(self).offset(-rightMargin);
            make.height.mas_equalTo(1);
        }];
    }
}

- (void)setBorderDashedLine
{
    
    CAShapeLayer *brokenLine = [CAShapeLayer layer];
    brokenLine.frame = self.bounds;
    
    brokenLine.path = [UIBezierPath bezierPathWithRoundedRect:brokenLine.bounds cornerRadius:5].CGPath;
    brokenLine.lineWidth = 1. / [[UIScreen mainScreen] scale];
    
    //虚线边框
    brokenLine.lineDashPattern = @[@4, @4];
    
    //实线边框
    //    borderLayer.lineDashPattern = nil;
    brokenLine.fillColor = [UIColor whiteColor].CGColor;
    brokenLine.strokeColor = [UIColor colorWithRed:74/255.0 green:144/255.0 blue:226/255.0 alpha:1].CGColor;
    
    [self.layer addSublayer:brokenLine];
    
}

- (void)setBorderDashedLineByBorderColor:(UIColor *)borderColor
{
    CAShapeLayer *brokenLine = [CAShapeLayer layer];
    brokenLine.frame = self.bounds;
    
    brokenLine.path = [UIBezierPath bezierPathWithRoundedRect:brokenLine.bounds cornerRadius:5].CGPath;
    brokenLine.lineWidth = 1. / [[UIScreen mainScreen] scale];
    
    //虚线边框
    brokenLine.lineDashPattern = @[@2, @2];
    
    //实线边框
    //    borderLayer.lineDashPattern = nil;
    brokenLine.fillColor = [UIColor whiteColor].CGColor;
    
    if (borderColor) {
        brokenLine.strokeColor = borderColor.CGColor;
    } else {
        brokenLine.strokeColor = [UIColor colorWithRed:74/255.0 green:144/255.0 blue:226/255.0 alpha:1].CGColor;
    }
    [self.layer addSublayer:brokenLine];
}

-(void)addLineWithTopView:(UIView *)topView topMarginFromTopView:(CGFloat)topMarginFromTopView LeftMargin:(CGFloat)leftMargin RightMargin:(CGFloat)rightMargin
{
    UIView *lineView = [[UIView alloc]init];
    [self addSubview:lineView];
    lineView.tag = kTagLineView;
    lineView.backgroundColor = [UIColor colorWithR:243 G:244 B:245 A:1];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_bottom).offset(topMarginFromTopView);
        make.left.mas_equalTo(self).offset(leftMargin);
        make.right.mas_equalTo(self).offset(-rightMargin);
        make.height.mas_equalTo(1);
    }];
}


-(UIView *)addLineWithBottomView:(UIView *)bottomView bottomMarginFrombottomView:(CGFloat)bottomMarginFrombottomView LeftMargin:(CGFloat)leftMargin RightMargin:(CGFloat)rightMargin
{
    UIView *lineView = [[UIView alloc]init];
    [self addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithR:243 G:244 B:245 A:1];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(bottomView.mas_top).offset(-bottomMarginFrombottomView);
        make.left.mas_equalTo(self).offset(leftMargin);
        make.right.mas_equalTo(self).offset(-rightMargin);
        make.height.mas_equalTo(1);
    }];
    return lineView;
}


+ (void)lb_drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

@end
