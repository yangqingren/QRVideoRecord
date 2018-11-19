//
//  LBToastView.h
//  app
//
//  Created by 赵辉 on 16/12/6.
//  Copyright © 2016年 NAICAI LI. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,LBNoticePopuViewPosition) {
    LBNoticePopuViewPositionCenter = 1,//中部
    LBNoticePopuViewPositionBottom = 2,//底部
    
};

@interface LBToastView : UIView

+ (void)showByMessage:(NSString *)msg;//default ios style show bottom

+ (void)showByMessage:(NSString *)msg inView:(UIView *)view;


+ (void)showByMessage:(NSString *)msg
         positionType:(LBNoticePopuViewPosition)position;//custom show position

+ (void)showByMessage:(NSString *)msg
         positionType:(LBNoticePopuViewPosition)position inView:(UIView *)view;

@end
