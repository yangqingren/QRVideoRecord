//
//  UIImageView+FitNetSize.m
//  app
//
//  Created by luckyRoy on 2017/4/5.
//  Copyright © 2017年 NAICAI LI. All rights reserved.
//

#import "UIImageView+FitNetSize.h"
#import "UIImage+LBImage.h"

@implementation UIImageView (FitNetSize)

- (UIImage *)newImageByImage:(UIImage *)urlImage
{
    UIImage *newImage = urlImage;
    if (self.frame.size.width && self.frame.size.height && urlImage.size.width && urlImage.size.height) {
        if (self.frame.size.width != urlImage.size.width ||
            self.frame.size.height != urlImage.size.height) {
            newImage = [UIImage imageWithImageSimple:urlImage scaledToSize:self.frame.size];
        }
    }
    return newImage;
}

- (void)fit_setImageWithURL:(NSURL *)url
{
    __weak typeof(self)weakSelf = self;
    [self sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [weakSelf setImage:[weakSelf newImageByImage:image]];
        }
    }];
}

- (void)fit_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    __weak typeof(self)weakSelf = self;
    [self sd_setImageWithURL:url placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [weakSelf setImage:[weakSelf newImageByImage:image]];
        }
    }];
}

@end
