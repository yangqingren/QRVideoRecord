//
//  NSMutableAttributedString+Common.m
//  app
//
//  Created by 赵辉 on 16/7/4.
//  Copyright © 2016年 广东联结电子商务有限公司. All rights reserved.
//

#import "NSMutableAttributedString+Common.h"

static CGFloat const LBDefaultLineMarigin = 3;

@implementation NSMutableAttributedString (Common)

+ (UILabel *)shareLabel
{
    static UILabel *shareLabel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareLabel = [UILabel new];
    });
    return shareLabel;
}

+ (NSMutableAttributedString *)lb_getRichTextByByContent:(NSString *)content
                                              NewFont:(UIFont *)newFont
                                          LineMarigin:(CGFloat)lineMargin
                                      NSLineBreakMode:(NSLineBreakMode)lineBreakMode
{
    return [self lb_getRichTextByByContent:content NewFont:newFont LineMarigin:lineMargin textAlignment:NSTextAlignmentJustified NSLineBreakMode:lineBreakMode];
}

+ (NSMutableAttributedString *)lb_getRichTextByByContent:(NSString *)content
                                              NewFont:(UIFont *)newFont
                                          LineMarigin:(CGFloat)lineMargin
                                        textAlignment:(NSTextAlignment)textAlignment
                                      NSLineBreakMode:(NSLineBreakMode)lineBreakMode{
    
    if(content.length < 1){
        return nil;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineMargin;
    paragraphStyle.alignment = textAlignment;
    paragraphStyle.lineBreakMode = lineBreakMode;
    NSDictionary *attributes = @{NSFontAttributeName:newFont,
                                 NSBaselineOffsetAttributeName: @0,
                                 NSParagraphStyleAttributeName: paragraphStyle};
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:content];;
    [attrString addAttributes:attributes range:NSMakeRange(0, attrString.length)];
    return attrString;
}

+ (CGSize)lb_sizeForRichTextByAttributedString:(NSMutableAttributedString *)attrString
                                    NewFont:(UIFont *)newFont
                                      width:(CGFloat)width
                                  linelimit:(NSInteger)lines
{
    UILabel *tmpLable = [self shareLabel];
    [tmpLable setText:nil];
    [tmpLable setAttributedText:nil];
    CGRect rect = tmpLable.frame;
    rect.size = CGSizeMake(width, CGFLOAT_MAX);
    tmpLable.frame = rect;
    tmpLable.numberOfLines = lines;
    tmpLable.lineBreakMode = NSLineBreakByWordWrapping;
    tmpLable.textAlignment = NSTextAlignmentJustified;
    tmpLable.font = newFont;
    [tmpLable setAttributedText:attrString];
    [tmpLable sizeToFit];
    CGSize newSize = tmpLable.frame.size;
    if (newSize.width > width) {
        newSize.width = width;
    }
    return newSize;
}

+ (NSMutableAttributedString *)lb_getRichTextByByContent:(NSString *)content
                                                 NewFont:(UIFont *)newFont
{
    return [self lb_getRichTextByByContent:content NewFont:newFont LineMarigin:LBDefaultLineMarigin NSLineBreakMode:NSLineBreakByWordWrapping];
}

+ (CGFloat)lb_heightForRichTextByString:(NSString *)content
                                NewFont:(UIFont *)newFont
                                  width:(CGFloat)width
                              linelimit:(NSInteger)lines
{
    NSMutableAttributedString *attString = [self lb_getRichTextByByContent:content
                                                                   NewFont:newFont
                                                               LineMarigin:LBDefaultLineMarigin
                                                           NSLineBreakMode:NSLineBreakByWordWrapping];
    return [self lb_sizeForRichTextByAttributedString:attString NewFont:newFont width:width linelimit:lines].height;
}

+(NSAttributedString *)initFromHtmlStr:(NSString *)htmlStr
{
    if ([htmlStr isKindOfClass:[NSNull class]] || [htmlStr length] == 0)
        return nil;
    
    NSData *htmlData = [htmlStr dataUsingEncoding:NSUnicodeStringEncoding];
    NSAttributedString *attrHtmlStr = [[NSAttributedString alloc] initWithData:htmlData
                                                                       options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType}
                                                            documentAttributes:nil
                                                                         error:nil];
    
    return attrHtmlStr;
}

+ (NSMutableAttributedString *)lb_getAttributedStringWithString:(NSString *)str
                                                            sub:(NSString *)sub
                                                          color:(UIColor *)color
{
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:str];
    if (!sub || sub.length == 0) {
        [string addAttribute:NSForegroundColorAttributeName
                       value:color
                       range:NSMakeRange(0,0)];
        return string;
    }
    else{
        [string addAttribute:NSForegroundColorAttributeName
                       value:color
                       range:NSMakeRange([str rangeOfString:sub].location,sub.length)];
        return string;
    }
    
    
}
/**
 设置属性字符（多个）
 
 @param str   全部字符
 @param subArray   不同颜色的字符串数组
 @param colorArray 不同的颜色
 
 @return
 */
+ (NSMutableAttributedString *)lb_getArrayAttributedStringWithString:(NSString *)str
                                                      subStringArray:(NSArray *)subArray
                                                               color:(UIColor *)color{
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:str];
    if (!subArray.count) {
        
        [string addAttribute:NSForegroundColorAttributeName
                       value:color
                       range:NSMakeRange(0,0)];
        return string;
    }
    else{
        
        NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                       color,NSForegroundColorAttributeName,nil];
        for (int i = 0; i < subArray.count; i++) {
            
            [string setAttributes:attributeDict range:NSMakeRange([str rangeOfString:subArray[i]].location, [NSString stringWithFormat:@"%@",subArray[i]].length)];

        }

        return string;
    }
}
@end
