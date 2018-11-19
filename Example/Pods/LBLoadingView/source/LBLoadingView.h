//
//  LBLoadingView.h
//  LBLoadingView
//
//  Created by LINAICAI on 2017/1/16.
//  Copyright © 2017年 LINAICAI. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, LBLoadingBackgroundStyle) {
    LBLoadingBackgroundStyleNone,//没有背景层
    LBLoadingBackgroundStyleBlack,//黑色背景层
    LBLoadingBackgroundStyleLight,//透明背景层
    LBLoadingBackgroundStyleCustom,//自定义背景层颜色
};
@interface LBLoadingView : UIView

+ (void)showWithText:(NSString *)text inView:(UIView *)view completion:(void (^)(void))completion style:(LBLoadingBackgroundStyle)style;
+ (void)showWithText:(NSString *)text inView:(UIView *)view completion:(void (^)(void))completion;

+ (void)showWithText:(NSString *)text inView:(UIView *)view style:(LBLoadingBackgroundStyle)style;
+ (void)showWithText:(NSString *)text inView:(UIView *)view;

+ (void)showWithCompletion:(void (^)(void))completion style:(LBLoadingBackgroundStyle)style;
+ (void)showWithCompletion:(void (^)(void))completion;

+ (void)showWithText:(NSString *)text style:(LBLoadingBackgroundStyle)style ;
+ (void)showWithText:(NSString *)text ;

+ (void)showInView:(UIView *)view style:(LBLoadingBackgroundStyle)style ;
+ (void)showInView:(UIView *)view;

+ (void)showWithStyle:(LBLoadingBackgroundStyle)style ;
+ (void)show;


+ (void)dismiss;
+ (void)dismissCompletion:(void (^)(void))completion;
+ (void)dismissWithDelay:(NSTimeInterval)delay completion:(void (^)(void))completion;

//如果使用LBLoadingBackgroundStyleCustom风格的背景层,请show之前使用下面方法修改颜色
+ (void)setLBLoadingBackgroundCustomColor:(UIColor *)color;
@end
