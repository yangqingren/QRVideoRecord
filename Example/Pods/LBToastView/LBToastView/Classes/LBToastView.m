//
//  LBToastView.m
//  app
//
//  Created by 赵辉 on 16/12/6.
//  Copyright © 2016年 NAICAI LI. All rights reserved.
//

#import "LBToastView.h"
#import <Masonry.h>

#define LBToastViewWindow [[UIApplication sharedApplication].delegate window]

@interface LBToastView ()

@property (strong, nonatomic) UILabel *contentLabel;

@property (assign, nonatomic) LBNoticePopuViewPosition positionType;

@end

@implementation LBToastView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.layer.cornerRadius = 6.0;
        [self addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.edges.mas_equalTo(UIEdgeInsetsMake(15, 30, 15, 30));
        }];
    }
    return self;
}
+ (void)showByMessage:(NSString *)msg
{
    [self showByMessage:msg inView:LBToastViewWindow];
}
+ (void)showByMessage:(NSString *)msg inView:(UIView *)view{
    [self showByMessage:msg positionType:LBNoticePopuViewPositionBottom];
}
+ (void)showByMessage:(NSString *)msg
         positionType:(LBNoticePopuViewPosition)position
{
    [self showByMessage:msg positionType:position inView:LBToastViewWindow];
}
+ (void)showByMessage:(NSString *)msg
         positionType:(LBNoticePopuViewPosition)position inView:(UIView *)view{
    
    LBToastView *toastView = [[LBToastView alloc]initWithFrame:CGRectZero];
    [toastView.contentLabel setText:[NSString stringWithFormat:@"%@",msg]];
    toastView.alpha = 0;
    toastView.positionType = position;
    [view addSubview:toastView];
    
    [toastView setUpFrame];
    
    toastView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear  animations:^{
        toastView.transform = CGAffineTransformIdentity;
        [toastView setAlpha:1];
    } completion:^(BOOL finished) {
        //停留1秒再消失
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.25 animations:^{
                [toastView setAlpha:0];
            }completion:^(BOOL finished) {
                [toastView removeFromSuperview];
                
            }];
        });
    }];
    
}
#pragma mark - getter

- (void)setUpFrame
{
    CGFloat bottomAndTopSpace = 20;
    
    CGFloat leftAndRightSpaec = 20;
    
    CGFloat bottomSpace = 60;
    
    CGFloat maxShowWidth = (CGRectGetWidth(self.superview.bounds) - leftAndRightSpaec * 2);
    
    CGFloat maxShowHeight = (CGRectGetHeight(self.superview.bounds) - bottomAndTopSpace * 2);
    
    if (LBNoticePopuViewPositionCenter == self.positionType) {
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.superview);
            make.size.mas_lessThanOrEqualTo(CGSizeMake(maxShowWidth, maxShowHeight));
        }];
    } else {
        maxShowHeight -= bottomSpace;
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.superview);
            make.bottom.mas_equalTo(self.superview).offset(-bottomSpace);
            make.size.mas_lessThanOrEqualTo(CGSizeMake(maxShowWidth, maxShowHeight));
        }];
    }
    
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.font = [UIFont systemFontOfSize:18];
    }
    return _contentLabel;
}

@end
