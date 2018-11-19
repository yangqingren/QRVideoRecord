//
//  UIApplication+LBViewController.h
//  app
//
//  Created by 刘文扬 on 16/8/30.
//  Copyright © 2016年 广东联结电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (LBViewController)

+(UITabBarController *)tabbarController;

+(UINavigationController *)currentTabbarSelectedNavigationController;

+(UINavigationController *)navigationControllerByTabbarIndex:(NSInteger)tabbarIndex;


////这个nv有可能是present出来的
//+(LBNavigationController *)getCurrentNavigationController;

+(UIViewController *)getCurrentViewController;


//看是否有present出来的VC,如果没有返回nil
+ (UIViewController *)getPresentedViewController;


@end
