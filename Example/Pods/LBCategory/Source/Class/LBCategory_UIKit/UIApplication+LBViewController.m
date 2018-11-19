//
//  UIApplication+LBViewController.m
//  app
//
//  Created by 刘文扬 on 16/8/30.
//  Copyright © 2016年 广东联结电子商务有限公司. All rights reserved.
//

#import "UIApplication+LBViewController.h"

@implementation UIApplication (LBViewController)
+(UITabBarController *)tabbarController
{
    id<UIApplicationDelegate> appDelegate = [UIApplication sharedApplication].delegate;
    UIViewController *tabbarController = [appDelegate window].rootViewController;
    if ([tabbarController isKindOfClass:[UITabBarController class]]) {
        return (UITabBarController *)tabbarController;
    }
    return nil;
}

+(UINavigationController *)currentTabbarSelectedNavigationController
{
    UITabBarController *tabbarController = [UIApplication tabbarController];
    UINavigationController *selectedNV = (UINavigationController *)tabbarController.selectedViewController;
    if ([selectedNV isKindOfClass:[UINavigationController class]]) {
        return selectedNV;
    }
    return nil;
}

+(UINavigationController *)navigationControllerByTabbarIndex:(NSInteger)tabbarIndex
{
    UITabBarController *tabbarController = [UIApplication tabbarController];
    
    if (tabbarIndex + 1 > tabbarController.viewControllers.count) {
        return nil;
    }
    
    UINavigationController *selectedNV = (UINavigationController *)tabbarController.viewControllers[tabbarIndex];
    if ([selectedNV isKindOfClass:[UINavigationController class]]) {
        return selectedNV;
    }
    return nil;
}


+(UIViewController *)getCurrentViewController
{
//    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication].delegate window];
    
    UIViewController *rootVC = window.rootViewController;
    
    UIViewController *presentedViewController = rootVC.presentedViewController;
    if (presentedViewController != nil) {
        if ([presentedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nv = (UINavigationController *)presentedViewController;
            return [nv.viewControllers lastObject];
        }else{
            return presentedViewController;
        }
    }
    
    
    UINavigationController *selectedNV = [UIApplication currentTabbarSelectedNavigationController];
    if (selectedNV.viewControllers.count >= 1) {
        return [selectedNV.viewControllers lastObject];
    }
    return nil;
    
    
//    UIView *frontView = [[window subviews] lastObject];
//    id nextResponder = [frontView nextResponder];
//    
//    if ([nextResponder isKindOfClass:[UIViewController class]])
//        result = nextResponder;
//    else
//        result = window.rootViewController;
//    
//    return result;
}

+(UIViewController *)getPresentedViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    
    return topVC;
}
@end
