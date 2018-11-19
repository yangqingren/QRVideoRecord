//
//  LBLoadView.m
//  LBLoadingView
//
//  Created by LINAICAI on 2017/1/17.
//  Copyright © 2017年 LINAICAI. All rights reserved.
//

#import "LBLoadingAnimatedView.h"

@interface LBLoadingAnimatedView()
@property (nonatomic , strong)CAShapeLayer *shapreLayer;
@property (nonatomic , strong)CALayer *backgroundLayer;
@property (nonatomic , strong)CAShapeLayer *foregroundLayer;
@end
@implementation LBLoadingAnimatedView
- (CAShapeLayer *)foregroundLayer{
    if (!_foregroundLayer) {
        _foregroundLayer= [CAShapeLayer layer];
        //设置线条的宽度和颜色
        _foregroundLayer.lineWidth = 2.0f;
        _foregroundLayer.strokeColor = [UIColor colorWithRed:239./255 green:239./255 blue:239./255 alpha:1.0].CGColor;
        _foregroundLayer.fillColor = nil;
        _foregroundLayer.lineCap = kCALineCapSquare;
        //设置stroke起始点
        _foregroundLayer.strokeEnd = 1.0;
        _foregroundLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(self.frame, 5, 5)].CGPath;
    }
    return _foregroundLayer;
}
- (CALayer *)backgroundLayer{
    if (!_backgroundLayer) {
        _backgroundLayer = [CALayer layer];
        _backgroundLayer.frame = self.bounds;
        _backgroundLayer.backgroundColor = [UIColor colorWithRed:86./255 green:168./255 blue:252./255 alpha:1.0].CGColor
        ;
        _backgroundLayer.mask = self.shapreLayer;
    }
    return _backgroundLayer;
}
- (CAShapeLayer *)shapreLayer{
    if (!_shapreLayer) {
        _shapreLayer= [CAShapeLayer layer];
        //设置线条的宽度和颜色
        _shapreLayer.lineWidth = 2.0f;
        _shapreLayer.strokeColor = [UIColor whiteColor].CGColor;
        _shapreLayer.fillColor = nil;
        _shapreLayer.lineCap = kCALineCapSquare;
        //设置stroke起始点
        _shapreLayer.strokeEnd = .2;
        _shapreLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(self.frame, 5, 5)].CGPath;
    }
    return _shapreLayer;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.layer addSublayer:self.foregroundLayer];
        [self.layer addSublayer:self.backgroundLayer];
        [self rotate];
    }
    return self;
}
//旋转
- (void)rotate{
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.toValue = [NSNumber numberWithFloat:M_PI];
    //执行时间
    animation.duration =0.5;
    animation.cumulative =YES;//累积的
    //执行次数
    animation.repeatCount = INFINITY;
    animation.autoreverses=NO;//是否自动重复
    animation.removedOnCompletion = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.backgroundLayer addAnimation:animation forKey:@"animation"];
}
@end
