//
//  UINavigationController+remove.m
//  app
//
//  Created by 魏宗磊 on 16/11/16.
//  Copyright © 2016年 广东联结电子商务有限公司. All rights reserved.

#import <UIKit/UIKit.h>

@interface UINavigationController (remove)

-(void)removeViewController:(NSString *)viewControllerName;
-(void)removeTheMidleViewControllers;

//删除之间的vc,不包含fromViewController,ToController
-(void)removeFromViewController:(Class)fromViewController ToController:(Class)toController;

//删除之间的vc,包含viewController,不包含ToController
-(void)removeWithViewController:(Class)withViewController ToController:(Class)toController;

@end
