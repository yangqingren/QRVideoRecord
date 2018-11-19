//
//  UINavigationController+LBFindViewController.m
//  app
//
//  Created by 刘文扬 on 16/8/31.
//  Copyright © 2016年 广东联结电子商务有限公司. All rights reserved.
//

#import "UINavigationController+LBFindViewController.h"

@implementation UINavigationController (LBFindViewController)

-(UIViewController *)lb_findViewControllerWithClass:(Class)viewControllerClass
{
    for (UIViewController *viewController in self.viewControllers) {
        
        if ([viewController isMemberOfClass:viewControllerClass]) {
            return viewController;
        }
        
    }
    return nil;
}

@end
