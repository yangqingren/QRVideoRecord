//
//  UIImage+LBImage.h
//  app
//
//  Created by LINAICAI on 16/5/3.
//  Copyright © 2016年 广东联结电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LBImage)
/**
 改变图片颜色

 @param color 颜色
 @return 处理过的图片
 */
- (UIImage *)lb_imageWithColor:(UIColor *)color;
/**
 *  图片压缩
 *
 *  @param image   原图
 *  @param newSize 压缩大小
 *
 *  @return
 */
+ (UIImage*)imageWithImageSimple:(UIImage*)image
                    scaledToSize:(CGSize)newSize;
/**
 *  创建一个二维码图片
 *
 *  @param string 二维码信息字符串
 *  @param size   大小
 *
 *  @return
 */
+ (UIImage *)createQRForString:(NSString *)string
                      withSize:(CGFloat)size;

#pragma mark- 通用方法
/**
 *  通过颜色来生成一个纯色图片
 *
 *  @param color 颜色
 *  @param rect  大小
 *
 *  @return
 */
+ (UIImage *)GetImageFromColor:(UIColor *)color
                          rect:(CGRect)rect;
/**
 *  从视图得到一张图片
 *
 *  @param view 视图
 *
 *  @return
 */
+ (UIImage*)imageFromView:(UIView*)view;
/**
 *  从图片切一个指定大小的图
 *
 *  @param image      原图
 *  @param mCGRect    大小
 *  @param centerBool 是否从中心切取
 *
 *  @return
 */
+ (UIImage*)getSubImage:(UIImage *)image
                mCGRect:(CGRect)mCGRect
             centerBool:(BOOL)centerBool;
/**
 *  重置一张图片至指定大小
 *
 *  @param imageName 原图的名称
 *  @param width     宽
 *  @param height    高
 *
 *  @return
 */
+ (UIImage *)resizeImage:(NSString *)imageName
                  kWidth:(CGFloat)width
                 kHeight:(CGFloat)height;
/**
 *  画虚线
 *
 *  @param color   虚线颜色
 *  @param size    虚线所在区域宽高
 *  @param lengths 虚线 实线 比例 如 lengths[] = {4.0f,4.0f}
 *  @param count   count description 一般为 2
 *
 *  @return return value description
 */
+ (instancetype)imageWithColor:(UIColor *)color
                          size:(CGSize)size
               dashLineLengths:(CGFloat [])lengths
                        counts:(NSInteger)count;

/**
 *  通过后缀获取文件类型图片
 *
 *  @param suffix suffix description
 *
 *  @return return value description
 */
+ (UIImage *)getIconImageBySuffix:(NSString *)suffix;

@end
