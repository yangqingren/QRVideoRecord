//
//  UIViewController+LBCallBack.h
//  app
//
//  Created by 刘文扬 on 16/9/2.
//  Copyright © 2016年 广东联结电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LBCallBackBlock)(id data);
@interface UIViewController (LBCallBack)

@property (nonatomic, copy) LBCallBackBlock lb_callBackBlock;

@end
