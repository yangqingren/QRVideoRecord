//
//  UINavigationController+remove.m
//  app
//
//  Created by 魏宗磊 on 16/11/16.
//  Copyright © 2016年 广东联结电子商务有限公司. All rights reserved.

#import "UINavigationController+remove.h"
#import "UINavigationController+LBFindViewController.h"

@implementation UINavigationController (remove)

-(void)removeViewController:(NSString *)viewControllerName
{
    NSMutableArray * viewControllers = [self.viewControllers mutableCopy];
    BOOL containRemoveVC = NO;
    for (UIViewController *viewController in [viewControllers reverseObjectEnumerator]) {
        NSString *tempName = NSStringFromClass([viewController class]);
        if ([tempName isEqualToString:viewControllerName]) {
            containRemoveVC = YES;
            [viewControllers removeObject:viewController];
        }
    }
    
    if (containRemoveVC) {
        [self setViewControllers:viewControllers animated:NO];
    }

    
}

-(void)removeTheMidleViewControllers
{
    NSArray *viewControllers = self.viewControllers;
    
    if (viewControllers.count > 2 ) {
        
        UIViewController *rootCtrl = [self.viewControllers firstObject];
        UIViewController *topCtrl = [self.viewControllers lastObject];
        NSArray *newArr = [NSArray arrayWithObjects:rootCtrl,topCtrl, nil];
        [self setViewControllers:newArr animated:NO];
    }
}

-(void)removeFromViewController:(Class)fromViewController ToController:(Class)toController
{
    NSMutableArray * viewControllers = [self.viewControllers mutableCopy];
    NSInteger fromIndex = 0;
    NSInteger toIndex = 0;
    for (NSInteger i = 0; i < viewControllers.count; ++i) {
        UIViewController *viewController = viewControllers[i];
        if ([viewController isKindOfClass:fromViewController]) {
            fromIndex = i;
        }
        
        if ([viewController isKindOfClass:toController]) {
            toIndex = i;
        }
    }
    
    if (fromIndex + 1 >=  toIndex) {
        return;
    }
    
    if (fromIndex > toIndex) {
        return;
    }
    
    NSRange removeRange = NSMakeRange(fromIndex + 1, (toIndex - fromIndex) - 1);
    
    [viewControllers removeObjectsInRange:removeRange];
    
    [self setViewControllers:viewControllers animated:NO];
}

-(void)removeWithViewController:(Class)withViewController ToController:(Class)toController
{
    NSMutableArray * viewControllers = [self.viewControllers mutableCopy];
    NSInteger fromIndex = 0;
    NSInteger toIndex = 0;
    for (NSInteger i = 0; i < viewControllers.count; ++i) {
        UIViewController *viewController = viewControllers[i];
        if ([viewController isKindOfClass:withViewController]) {
            fromIndex = i;
        }
        
        if ([viewController isKindOfClass:toController]) {
            toIndex = i;
        }
    }
    
    if (fromIndex + 1 >=  toIndex) {
        return;
    }
    
    if (fromIndex > toIndex) {
        return;
    }
    
    NSRange removeRange = NSMakeRange(fromIndex, (toIndex - fromIndex));
    
    [viewControllers removeObjectsInRange:removeRange];
    
    [self setViewControllers:viewControllers animated:NO];
}


@end
