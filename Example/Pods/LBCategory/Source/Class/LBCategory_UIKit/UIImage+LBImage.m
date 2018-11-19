//
//  UIImage+LBImage.m
//  app
//
//  Created by LINAICAI on 16/5/3.
//  Copyright © 2016年 广东联结电子商务有限公司. All rights reserved.
//

#import "UIImage+LBImage.h"
#import "UIColor+LBColor.h"

@implementation UIImage (LBImage)
/**
 改变图片颜色
 
 @param color 颜色
 @return 处理过的图片
 */
- (UIImage *)lb_imageWithColor:(UIColor *)color{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
/**
 *  图片压缩
 *
 *  @param image   原图
 *  @param newSize 压缩大小
 *
 *  @return
 */
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize{
    if (!image) {
        return nil;
    }
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
/**
 *  创建一个二维码图片
 *
 *  @param string 二维码信息字符串
 *  @param size   大小
 *
 *  @return
 */
+ (UIImage *)createQRForString:(NSString *)string withSize:(CGFloat)size{
    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    // 创建filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 设置内容和纠错级别
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    //导出CIImage
    CIImage *image = qrFilter.outputImage;
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    //原图
    UIImage *outputImage = [UIImage imageWithCGImage:scaledImage];
    UIGraphicsBeginImageContextWithOptions(outputImage.size, NO, [[UIScreen mainScreen] scale]);
    [outputImage drawInRect:CGRectMake(0,0 , size, size)];
    
    //水印图
//    UIImage *waterimage = [UIImage imageNamed:@"load"];
//    [waterimage drawInRect:CGRectMake((size-waterImagesize)/2.0, (size-waterImagesize)/2.0, waterImagesize, waterImagesize)];
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(scaledImage);
    CGColorSpaceRelease(cs);
    return newPic;
}
/**
 *  通过颜色来生成一个纯色图片
 *
 *  @param color 颜色
 *  @param rect  大小
 *
 */
+ (UIImage *)GetImageFromColor:(UIColor *)color rect:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
/**
 *  从视图得到一张图片
 *
 *  @param view 视图
 *
 */
+ (UIImage*)imageFromView:(UIView*)view{
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, view.layer.contentsScale);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}
/**
 *  从图片切一个指定大小的图
 *
 *  @param image      原图
 *  @param mCGRect    大小
 *  @param centerBool 是否从中心切取
 *
 *  @return
 */
+(UIImage*)getSubImage:(UIImage *)image mCGRect:(CGRect)mCGRect centerBool:(BOOL)centerBool
{
    
    /*如若centerBool为Yes则是由中心点取mCGRect范围的图片*/
    
    
    float imgwidth = image.size.width;
    float imgheight = image.size.height;
    float viewwidth = mCGRect.size.width;
    float viewheight = mCGRect.size.height;
    CGRect rect;
    if(centerBool)
        rect = CGRectMake((imgwidth-viewwidth)/2, (imgheight-viewheight)/2, viewwidth, viewheight);
    else{
        if (viewheight < viewwidth) {
            if (imgwidth <= imgheight) {
                rect = CGRectMake(0, 0, imgwidth, imgwidth*viewheight/viewwidth);
            }else {
                float width = viewwidth*imgheight/viewheight;
                float x = (imgwidth - width)/2 ;
                if (x > 0) {
                    rect = CGRectMake(x, 0, width, imgheight);
                }else {
                    rect = CGRectMake(0, 0, imgwidth, imgwidth*viewheight/viewwidth);
                }
            }
        }else {
            if (imgwidth <= imgheight) {
                float height = viewheight*imgwidth/viewwidth;
                if (height < imgheight) {
                    rect = CGRectMake(0, 0, imgwidth, height);
                }else {
                    rect = CGRectMake(0, 0, viewwidth*imgheight/viewheight, imgheight);
                }
            }else {
                float width = viewwidth*imgheight/viewheight;
                if (width < imgwidth) {
                    float x = (imgwidth - width)/2 ;
                    rect = CGRectMake(x, 0, width, imgheight);
                }else {
                    rect = CGRectMake(0, 0, imgwidth, imgheight);
                }
            }
        }
    }
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    CGImageRelease(subImageRef);
    return smallImage;
}
/**
 *  重置一张图片至指定大小
 *
 *  @param imageName 原图的名称
 *  @param width     宽
 *  @param height    高
 *
 *  @return
 */
+ (UIImage *)resizeImage:(NSString *)imageName kWidth:(CGFloat)width kHeight:(CGFloat)height
{
    UIImage *image = [UIImage imageNamed:imageName];
    CGFloat imageW = image.size.width * width;
    CGFloat imageH = image.size.height * height;
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(imageH,imageW,10,imageW) resizingMode:UIImageResizingModeStretch];
}
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
+ (instancetype)imageWithColor:(UIColor *)color size:(CGSize)size dashLineLengths:(CGFloat [])lengths counts:(NSInteger)count{
    
    UIGraphicsBeginImageContextWithOptions(size, 0, [UIScreen mainScreen].scale);
    [color set];
    //    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, size.height);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    //    CGFloat lengths[] = {10,10};
    CGContextSetLineDash(context, 0, lengths,count);
    CGContextMoveToPoint(context, 0.0, 0.0);
    CGContextAddLineToPoint(context, size.width,size.height);
    CGContextStrokePath(context);
    //    CGContextClosePath(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)getIconImageBySuffix:(NSString *)suffix
{
    NSString *imageString;
    if ([suffix containsString:@"pdf"]) {
        imageString = @"lb_icon_file_pdf_65";
    } else if ([suffix containsString:@"jpg"]) {
        imageString = @"lb_icon_file_jpg_65";
    } else if ([suffix containsString:@"doc"] || [suffix containsString:@"docx"]) {
        imageString = @"lb_icon_file_word_65";
    } else if ([suffix containsString:@"png"])
    {
        imageString = @"lb_icon_file_png_65";
    }
    else if ([suffix containsString:@"xls"] || [suffix containsString:@"xlsx"]){
        imageString = @"lb_icon_file_excel_65";
    }
    else
    {
        imageString = @"lb_icon_file_unknown";
    }
    
    return [UIImage imageNamed:imageString];
}

@end
