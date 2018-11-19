//
//  UIView+LBFindViewController.m
//  app
//
//  Created by LINAICAI on 16/10/9.
//  Copyright © 2016年 广东联结电子商务有限公司. All rights reserved.
//

#import "UIView+LBFindViewController.h"

@implementation UIView (LBFindViewController)
/** 获取当前View的控制器对象 */
-(UIViewController *)lb_findViewController{
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}
@end
