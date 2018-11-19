//
//  UIViewController+LBCallBack.m
//  app
//
//  Created by 刘文扬 on 16/9/2.
//  Copyright © 2016年 广东联结电子商务有限公司. All rights reserved.
//

#import "UIViewController+LBCallBack.h"
#import <objc/runtime.h>

static const void *callBackKey = &callBackKey;
@implementation UIViewController (LBCallBack)


-(LBCallBackBlock)lb_callBackBlock
{
    return objc_getAssociatedObject(self, callBackKey);
}

-(void)setLb_callBackBlock:(LBCallBackBlock)lb_callBackBlock
{
    objc_setAssociatedObject(self, callBackKey, lb_callBackBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
