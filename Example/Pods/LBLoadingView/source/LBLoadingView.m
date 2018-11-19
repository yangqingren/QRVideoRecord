//
//  LBLoadingView.m
//  LBLoadingView
//
//  Created by LINAICAI on 2017/1/16.
//  Copyright © 2017年 LINAICAI. All rights reserved.
//

#import "LBLoadingView.h"
#import "LBLoadingAnimatedView.h"
//局部常量
static CGFloat const kWith = 140.f;
static CGFloat const kHeight = 61.f;
static CGFloat const kSize = 33.f;
static NSString * const kText = @"正在载入...";
//局部变量
static LBLoadingView *shareView = nil;
@interface LBLoadingView()
//提示动画视图
@property (nonatomic , strong)LBLoadingAnimatedView *loadingAnimatedView;
//提示文本视图
@property (nonatomic , strong)UILabel *titleLabel;
//背景层风格
@property (nonatomic , assign)LBLoadingBackgroundStyle style;
//自定义背景层颜色
@property (nonatomic , strong)UIColor *customColor;
//背景层
@property (nonatomic , strong)UIView *overlayView;

//是否在加载中
@property (nonatomic , assign , getter=isLoading)BOOL loading;
@end
@implementation LBLoadingView
#pragma mark- 初始化加载默认配置

+ (void)load{
    [super load];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareView = [[LBLoadingView alloc]initWithFrame:CGRectMake(0, 0, kWith, kHeight)];
        shareView.backgroundColor = [UIColor whiteColor];
        shareView.layer.cornerRadius = 5.0;
        shareView.layer.shadowColor = [UIColor colorWithRed:0./255 green:0./255 blue:0./255 alpha:0.15].CGColor;
        shareView.layer.shadowRadius = 5;
        shareView.layer.shadowOpacity = 5;
        shareView.layer.shadowOffset = CGSizeMake(0, 0);
        [shareView setContent];
    });
    
}

#pragma mark- 私有方法
- (void)setContent{
    [shareView addSubview:shareView.titleLabel];
    [shareView addSubview:shareView.loadingAnimatedView];
    shareView.loadingAnimatedView.translatesAutoresizingMaskIntoConstraints = NO;
    shareView.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    //宽度约束，等于父控件的高度的一半
    NSLayoutConstraint *widthConstrait = [NSLayoutConstraint constraintWithItem:shareView.loadingAnimatedView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:shareView attribute:NSLayoutAttributeHeight multiplier:0.5 constant:0];
    [shareView addConstraint:widthConstrait];
    //高度约束,父控件的一半
    NSLayoutConstraint *heightConstrait = [NSLayoutConstraint constraintWithItem:shareView.loadingAnimatedView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:shareView attribute:NSLayoutAttributeHeight multiplier:0.5 constant:0];
    [shareView addConstraint:heightConstrait];
    //垂直居中
    NSLayoutConstraint *centerYConstrait = [NSLayoutConstraint constraintWithItem:shareView.loadingAnimatedView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:shareView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    [shareView addConstraint:centerYConstrait];
    //左约束
    NSLayoutConstraint *leftConstrait = [NSLayoutConstraint constraintWithItem:shareView.loadingAnimatedView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:shareView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:15];
    [shareView addConstraint:leftConstrait];
    
    
    
    
    //高度约束,父控件的一半
    heightConstrait = [NSLayoutConstraint constraintWithItem:shareView.titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:shareView attribute:NSLayoutAttributeHeight multiplier:0.5 constant:0];
    [shareView addConstraint:heightConstrait];
    //垂直居中
    centerYConstrait = [NSLayoutConstraint constraintWithItem:shareView.titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:shareView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    [shareView addConstraint:centerYConstrait];
    
    //左约束
    leftConstrait = [NSLayoutConstraint constraintWithItem:shareView.titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:shareView.loadingAnimatedView attribute:NSLayoutAttributeRight multiplier:1.0 constant:10];
    [shareView addConstraint:leftConstrait];
    
    //右约束
    NSLayoutConstraint *rightConstrait = [NSLayoutConstraint constraintWithItem:shareView.titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:shareView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-15];
    [shareView addConstraint:rightConstrait];
    
}
#pragma mark- Show
+ (void)showWithText:(NSString *)text inView:(UIView *)view completion:(void (^)(void))completion {
    [self showWithText:text inView:view completion:completion style:LBLoadingBackgroundStyleNone];
}
+ (void)showWithText:(NSString *)text inView:(UIView *)view completion:(void (^)(void))completion style:(LBLoadingBackgroundStyle)style{
    
    //如果还在加载中，先关闭，然后继续重新展示出来
    if (shareView.isLoading && shareView.overlayView) {
        [shareView.overlayView removeFromSuperview];
    }
    shareView.loading = YES;
    //为了防止在这个block中操作界面的时候不注意线程问题，使用主线程队列来运行
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        switch (style) {
            case LBLoadingBackgroundStyleNone:
            {
                //没有背景层
                shareView.overlayView.backgroundColor = [UIColor clearColor];
                [shareView.overlayView addSubview:shareView];
                shareView.overlayView.userInteractionEnabled = NO;
                [view addSubview:shareView.overlayView];
            }
                break;
            case LBLoadingBackgroundStyleBlack:
            {
                //带浅黑色背景层
                shareView.overlayView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
                [shareView.overlayView addSubview:shareView];
                shareView.overlayView.userInteractionEnabled = YES;
                [view addSubview:shareView.overlayView];
            }
                break;
            case LBLoadingBackgroundStyleLight:
            {
                //带透明背景层
                shareView.overlayView.backgroundColor = [UIColor clearColor];
                [shareView.overlayView addSubview:shareView];
                shareView.overlayView.userInteractionEnabled = YES;
                [view addSubview:shareView.overlayView];
            }
                break;
            case LBLoadingBackgroundStyleCustom:
            {
                //使用自定义颜色的背景层
                shareView.overlayView.backgroundColor = shareView.customColor;
                [shareView.overlayView addSubview:shareView];
                shareView.overlayView.userInteractionEnabled = YES;
                [view addSubview:shareView.overlayView];
            }
                break;
            default:
                break;
        }
        shareView.style = style;
        shareView.titleLabel.text = text;
        shareView.overlayView.frame = view.bounds;
        shareView.center = shareView.overlayView.center;
        shareView.hidden = YES;
        [UIView animateWithDuration:0.25 animations:^{
            shareView.hidden = NO;
        }completion:^(BOOL finished) {
            if (completion && finished) {completion();}
        }];
    }];
    
}
+ (void)showWithText:(NSString *)text inView:(UIView *)view{
    [self showWithText:text inView:view completion:nil style:LBLoadingBackgroundStyleNone];
}
+ (void)showWithText:(NSString *)text inView:(UIView *)view style:(LBLoadingBackgroundStyle)style{
    [self showWithText:text inView:view completion:nil style:style];
}

+ (void)showWithCompletion:(void (^)(void))completion{
    [self showWithText:kText inView:[UIApplication sharedApplication].delegate.window completion:completion style:LBLoadingBackgroundStyleNone];
}
+ (void)showWithCompletion:(void (^)(void))completion style:(LBLoadingBackgroundStyle)style{
    [self showWithText:kText inView:[UIApplication sharedApplication].delegate.window completion:completion style:style];
}

+ (void)showWithText:(NSString *)text{
    [self showWithText:text inView:[UIApplication sharedApplication].delegate.window completion:nil style:LBLoadingBackgroundStyleNone];
}
+ (void)showWithText:(NSString *)text style:(LBLoadingBackgroundStyle)style{
    [self showWithText:text inView:[UIApplication sharedApplication].delegate.window completion:nil style:style];
}

+ (void)show{
    [self showWithCompletion:nil style:LBLoadingBackgroundStyleNone];
}
+ (void)showWithStyle:(LBLoadingBackgroundStyle)style{
    [self showWithCompletion:nil style:style];
}

+ (void)showInView:(UIView *)view{
    [self showWithText:kText inView:view style:LBLoadingBackgroundStyleNone];
}
+ (void)showInView:(UIView *)view style:(LBLoadingBackgroundStyle)style{
    [self showWithText:kText inView:view style:style];
}
#pragma mark- Dismiss
+ (void)dismissCompletion:(void (^)(void))completion{
    [self dismissWithDelay:0.f completion:completion];
}
+ (void)dismissWithDelay:(NSTimeInterval)delay completion:(void (^)(void))completion{
    shareView.loading = NO;
    //为了防止在这个block中操作界面的时候不注意线程问题，使用主线程队列来运行
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        shareView.hidden = NO;
        [UIView animateWithDuration:0 delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            shareView.hidden = YES;
        } completion:^(BOOL finished) {
            if (completion && finished) {completion();}
            if (shareView.overlayView) {
                [shareView.overlayView removeFromSuperview];
            }
        }];
        
    }];
    
}
+ (void)dismiss{
    [self dismissWithDelay:0 completion:nil];
}
#pragma mark- Setting|Getting
//如果使用LBLoadingBackgroundStyleCustom风格的背景层,请show之前使用下面方法修改颜色
+ (void)setLBLoadingBackgroundCustomColor:(UIColor *)color{
    shareView.customColor = color;
}
- (LBLoadingAnimatedView *)loadingAnimatedView{
    if (!_loadingAnimatedView) {
        _loadingAnimatedView = [[LBLoadingAnimatedView alloc]initWithFrame:CGRectMake(0, 0, kSize, kSize)];
    }
    return _loadingAnimatedView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor colorWithRed:120./255 green:120./255 blue:120./255 alpha:1.0];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}
- (UIView *)overlayView{
    if (!_overlayView) {
        _overlayView = [[UIView alloc]init];
    }
    return _overlayView;
}
@end
