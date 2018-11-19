//
//  LBProgressCircleView.m
//  LBLoadingView
//
//  Created by LINAICAI on 2017/6/13.
//  Copyright © 2017年 LINAICAI. All rights reserved.
//

#import "LBProgressCircleView.h"

@interface LBProgressCircleView()
@property (nonatomic , strong) CAShapeLayer *circleLayer;
@property (nonatomic , strong) CAShapeLayer *fanshapedLayer;


@end
@implementation LBProgressCircleView
- (void)setProgress:(CGFloat)progress{
    self.fanshapedLayer.path = [self makeProgressPathWith:progress].CGPath;
}
- (CAShapeLayer *)circleLayer{
    if (!_circleLayer) {
        _circleLayer = [CAShapeLayer layer];
        _circleLayer.strokeColor = [UIColor colorWithWhite:1 alpha:.8].CGColor;
        _circleLayer.fillColor = [UIColor clearColor].CGColor;
        _circleLayer.path = [self makeCirclePath].CGPath;
    }
    return _circleLayer;
}
- (CAShapeLayer *)fanshapedLayer{
    if (!_fanshapedLayer) {
        _fanshapedLayer = [CAShapeLayer layer];
        _fanshapedLayer.fillColor = [UIColor colorWithWhite:1 alpha:.8].CGColor;
    }
    return _fanshapedLayer;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, 50, 50);
        [self setupUI];
        self.progress = 0;
    }
    return self;
}
- (void)setupUI{
    self.backgroundColor = [UIColor clearColor];
    [self.layer addSublayer:self.circleLayer];
    [self.layer addSublayer:self.fanshapedLayer];
}
- (UIBezierPath *)makeCirclePath{
    CGPoint arcCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:arcCenter radius:25 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    path.lineWidth = 2;
    return  path;
}
- (UIBezierPath *)makeProgressPathWith:(CGFloat)progress{
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat radius = CGRectGetMidY(self.bounds) - 2.5;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:center];
    [path addLineToPoint:CGPointMake(CGRectGetMidX(self.bounds), center.y - radius)];
    [path addArcWithCenter:center radius:radius startAngle:-M_PI/2 endAngle:-M_PI/2  + M_PI*2*progress clockwise:YES];
    [path closePath];
    path.lineWidth = 1;
    return path;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
