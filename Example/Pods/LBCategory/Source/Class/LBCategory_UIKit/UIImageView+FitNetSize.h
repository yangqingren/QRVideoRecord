//
//  UIImageView+FitNetSize.h
//  app
//
//  Created by luckyRoy on 2017/4/5.
//  Copyright © 2017年 NAICAI LI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
//网络图片自适应容器大小减少反锯齿计算提高性能
@interface UIImageView (FitNetSize)

- (void)fit_setImageWithURL:(NSURL *)url;

- (void)fit_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

@end
