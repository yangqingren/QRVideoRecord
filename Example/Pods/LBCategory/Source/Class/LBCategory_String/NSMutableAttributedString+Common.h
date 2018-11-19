//
//  NSMutableAttributedString+Common.h
//  app
//
//  Created by 赵辉 on 16/7/4.
//  Copyright © 2016年 广东联结电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSMutableAttributedString (Common)

//获取富文本
+ (NSMutableAttributedString *)lb_getRichTextByByContent:(NSString *)content
                                              NewFont:(UIFont *)newFont
                                          LineMarigin:(CGFloat)lineMargin
                                      NSLineBreakMode:(NSLineBreakMode)lineBreakMode;

//获取富文本尺寸
+ (CGSize)lb_sizeForRichTextByAttributedString:(NSMutableAttributedString *)attrString
                                    NewFont:(UIFont *)newFont
                                      width:(CGFloat)width
                                  linelimit:(NSInteger)lines;

+ (NSMutableAttributedString *)lb_getRichTextByByContent:(NSString *)content
                                                 NewFont:(UIFont *)newFont;

+ (CGFloat)lb_heightForRichTextByString:(NSString *)content
                                NewFont:(UIFont *)newFont
                                  width:(CGFloat)width
                              linelimit:(NSInteger)lines;

// 将html字符串转化为属性字符串
+(NSAttributedString *)initFromHtmlStr:(NSString *)htmlStr;

/**
 设置属性字符
 
 @param str   全部字符
 @param sub   不同颜色的字符
 @param color 不同的颜色
 
 @return
 */
+ (NSMutableAttributedString *)lb_getAttributedStringWithString:(NSString *)str
                                                            sub:(NSString *)sub
                                                          color:(UIColor *)color;

/**
 设置属性字符（多个）
 
 @param str   全部字符
 @param subArray   不同颜色的字符串数组
 @param colorArray 不同的颜色
 
 @return
 */
+ (NSMutableAttributedString *)lb_getArrayAttributedStringWithString:(NSString *)str
                                                      subStringArray:(NSArray *)subArray
                                                               color:(UIColor *)color;
@end
