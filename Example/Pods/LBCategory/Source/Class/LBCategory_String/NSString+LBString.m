//
//  NSString+LBString.m
//  app
//
//  Created by LINAICAI on 16/7/26.
//  Copyright © 2016年 广东联结电子商务有限公司. All rights reserved.
//

#import "NSString+LBString.h"

@implementation NSString (LBString)
+ (UILabel *)shareLabel
{
    static UILabel *shareLabel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareLabel = [UILabel new];
    });
    return shareLabel;
}
/**
 获取阅读数
 
 @return return value description
 */
- (NSString *)readCount{
    double count = self.doubleValue;
    if (count < 10000) {
        ///小于1万，显示到个位
        return [NSString stringWithFormat:@"%u",(NSUInteger)count];
    }
   else if (count <= 100000) {
        ///小于10万
        double result = [NSString stringWithFormat:@"%.1f",floor(count)/10000.0].doubleValue;
        if ((int)(result * 10) % 10  == 0) {
            return [NSString stringWithFormat:@"%.0f万",result];
        }
        return [NSString stringWithFormat:@"%.1f万",result];
    }
    else{
        ///大于10万
        return [NSString stringWithFormat:@"%.0f万",floor(count/10000.0)];
    }

}

/**
 获取UTF8编码后的URL，防止URL中因为有中文而无法显示图片
 
 @return return value description
 */
- (NSString *)encodeURL{
    NSString *originString = (self == nil?@"":self);
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                                    
                                                                                                    (CFStringRef)originString,
                                                                                                    
                                                                                                    (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                                                                    
                                                                                                    NULL,
                                                                                                    
                                                                                                    kCFStringEncodingUTF8));
    return encodedString;
}
/**
 *  截取URL中的参数
 *
 *  @return NSMutableDictionary parameters
 */
- (NSMutableDictionary *)getURLParameters {
    
    // 查找参数
    NSRange range = [self rangeOfString:@"?"];
    if (range.location == NSNotFound) {
        return nil;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    // 截取参数
    NSString *parametersString = [self substringFromIndex:range.location + 1];
    
    // 判断参数是单个参数还是多个参数
    if ([parametersString containsString:@"&"]) {
        
        // 多个参数，分割参数
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];
        
        for (NSString *keyValuePair in urlComponents) {
            // 生成Key/Value
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            
            // Key不能为nil
            if (key == nil || value == nil) {
                continue;
            }
            
            id existValue = [params valueForKey:key];
            
            if (existValue != nil) {
                
                // 已存在的值，生成数组
                if ([existValue isKindOfClass:[NSArray class]]) {
                    // 已存在的值生成数组
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    
                    [params setValue:items forKey:key];
                } else {
                    
                    // 非数组
                    [params setValue:@[existValue, value] forKey:key];
                }
                
            } else {
                
                // 设置值
                [params setValue:value forKey:key];
            }
        }
    } else {
        // 单个参数
        
        // 生成Key/Value
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        
        // 只有一个参数，没有值
        if (pairComponents.count == 1) {
            return nil;
        }
        
        // 分隔值
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        
        // Key不能为nil
        if (key == nil || value == nil) {
            return nil;
        }
        
        // 设置值
        [params setValue:value forKey:key];
    }
    
    return params;
}

/**
 获取阿里云图片缩略图
 
 @return 返回200*160的三倍图的缩略图
 */
- (NSString *)getThumbnails{
    return [self getThumbnailBy:600 height:480];
}
/**
 获取阿里云图片缩略图
 
 @param width 指定宽度
 @param height 指定高度
 @return return value description
 */
- (NSString *)getThumbnailBy:(NSUInteger )width height:(NSUInteger)height{
    if (self.length) {
        if ([self containsString:@"@watermark"]) {
            NSString *str = [self componentsSeparatedByString:@"@watermark"].firstObject;
            return [NSString stringWithFormat:@"%@?x-oss-process=image/resize,m_fill,h_%lu,w_%lu",str,width,height];
        }
        else{
            NSString *str = self;
            return [NSString stringWithFormat:@"%@?x-oss-process=image/resize,m_fill,h_%lu,w_%lu",str,width,height];
        }
    }
    return self;
}


+ (NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    // NSString * regEx = @"<([^>]*)>";
    html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    return html;
}
/**
 *  根据字体返回文本宽度
 *
 *  @param text 文本
 *  @param font 字体
 *
 *  @return 文本宽度
 */
+ (CGFloat)getTextWidthWithText:(NSString *)text
                           Font:(UIFont *)font{
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName: font,
                                 };
    CGRect expectedLabelRect = [text boundingRectWithSize:(CGSize){CGFLOAT_MAX, CGFLOAT_MAX}
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:attributes
                                                  context:nil];
    return CGRectGetWidth(expectedLabelRect);
    
}
/**
 *  根据字体和宽返回文本高度
 *
 *  @param text  文本
 *  @param font  字体
 *  @param width 宽度
 *
 *  @return 高度
 */
+ (CGFloat)getTextHeightWithText:(NSString *)text
                            Font:(UIFont *)font
                           Width:(CGFloat)width {
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName: font,
                                 };
    CGRect expectedLabelRect = [text boundingRectWithSize:(CGSize){width, CGFLOAT_MAX}
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:attributes
                                                  context:nil];
    return CGRectGetHeight(expectedLabelRect);
    
}

+ (CGFloat)realWidthForContentText:(NSString *)text
                              Font:(UIFont *)font
                        LimitWidth:(CGFloat)width {
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName: font,
                                 };
    CGRect expectedLabelRect = [text boundingRectWithSize:(CGSize){width, CGFLOAT_MAX}
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:attributes
                                                  context:nil];
    return CGRectGetWidth(expectedLabelRect);
    
}

+ (CGSize)getTextSizeWithContent:(NSString *)content
                            Font:(UIFont *)font
                           Width:(CGFloat)width
{
    UILabel *tmpLable = [self shareLabel];
    [tmpLable setText:nil];
    [tmpLable setAttributedText:nil];
    CGRect rect = tmpLable.frame;
    rect.size = CGSizeMake(width, CGFLOAT_MAX);
    tmpLable.frame = rect;
    tmpLable.numberOfLines = 0;
    tmpLable.lineBreakMode = NSLineBreakByWordWrapping;
    tmpLable.textAlignment = NSTextAlignmentJustified;
    tmpLable.font = font;
    [tmpLable setText:content];
    [tmpLable sizeToFit];
    
    CGSize realSize = tmpLable.frame.size;
    
    if (realSize.width > width) {
        realSize.width = width;
    }
    
    return realSize;
}
/**
 给文字添加图片富文本，用于查需求列表
 
 @param image 图
 @param bounds 坐标大小
 @param index 位于文本的位置
 @return NSMutableAttributedString
 */
- (NSMutableAttributedString *)setAttStringWithImage:(UIImage *)image bounds:(CGRect)bounds index:(NSInteger)index {
    
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",self]];
    
    NSTextAttachment * attachment = [[NSTextAttachment alloc] init];
    
    attachment.image = image;
    
    attachment.bounds = bounds;
    
    NSAttributedString * attributedStr = [NSAttributedString attributedStringWithAttachment:attachment];
    
    [attStr insertAttributedString:attributedStr atIndex:index];
    
    return attStr;
}

// 当前只适用有水印的图片，目前还不清楚所有图片的格式，以后支持其他格式图片
- (NSString *)imageUrlWithQuality:(NSUInteger)quality sizeW:(NSUInteger)sizeW sizeH:(NSUInteger)sizeH
{
    NSString *str = self;
    if ([str containsString:@"@watermark"])
    {
        NSRange range =  [str rangeOfString:@"@watermark"];
        str =[str substringToIndex:range.location];
        NSString *formatStr = [NSString stringWithFormat:@"@%ldw_%ldh_%ldQ", (unsigned long)sizeW, (unsigned long)sizeH, (unsigned long)quality];
        str = [str stringByAppendingString:formatStr];
    }
    
    return str;
}

//
- (NSString *)companyAnualReportStr
{
    NSString *origStr = self;
    NSInteger valueInt = [origStr integerValue];
    if (valueInt == -1)
    {
        origStr = @"企业不公示";
    }
    else if (valueInt == 0)
    {
        origStr = @"否";
    }
    else if (valueInt == 1)
    {
        origStr = @"是";
    }
    
    return origStr;
}

//
- (NSString *)companyAnualReportMoneyDigital
{
    NSString *origStr = self;
    NSInteger valueInt = [origStr integerValue];
    if (valueInt == -1)
    {
        origStr = @"企业不公示";
        
        return origStr;
    }
    
    return [NSString stringWithFormat:@"%@ 万元", origStr];
}

+(NSMutableAttributedString *)getAtrributedStringWithString:(NSString *)string subString:(NSString *)subString font:(UIFont *)font fontColor:(UIColor *)fontColor
{
    
    subString = subString == nil ? @"" : subString;
    NSRange range = [string rangeOfString:subString];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];
    if (range.location != NSNotFound) {
        NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                       font,NSFontAttributeName,
                                       fontColor,NSForegroundColorAttributeName,nil];
        [attributeString setAttributes:attributeDict range:range];
    }
    
    return attributeString;
    
    
}

/**
 *  数据金额转换大写金额
 *
 *  @param amountStr 数字金额
 *
 *  @return 大写金额
 */
- (NSString*)conversionChineseDigital{

    //首先转化成标准格式        “200.23”
    NSMutableString *tempStr=[[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%.2f",[self doubleValue]]];
    //位
    NSArray *carryArr1=@[@"元", @"拾", @"佰", @"仟", @"万", @"拾", @"佰", @"仟", @"亿", @"拾", @"佰", @"仟", @"兆", @"拾", @"佰", @"仟" ];
    NSArray *carryArr2=@[@"分",@"角"];
    //数字
    NSArray *numArr=@[@"零", @"壹", @"贰", @"叁", @"肆", @"伍", @"陆", @"柒", @"捌", @"玖"];
    
    NSArray *temarr = [tempStr componentsSeparatedByString:@"."];
    //小数点前的数值字符串
    NSString *firstStr=[NSString stringWithFormat:@"%@",temarr[0]];
    //小数点后的数值字符串
    NSString *secondStr=[NSString stringWithFormat:@"%@",temarr[1]];
    
    //是否拼接了“零”，做标记
    bool zero=NO;
    //拼接数据的可变字符串
    NSMutableString *endStr=[[NSMutableString alloc] init];
    
    /**
     *  首先遍历firstStr，从最高位往个位遍历    高位----->个位
     */
    
    for(int i=(int)firstStr.length;i>0;i--)
    {
        //取最高位数
        NSInteger MyData=[[firstStr substringWithRange:NSMakeRange(firstStr.length-i, 1)] integerValue];
        
        if ([numArr[MyData] isEqualToString:@"零"]) {
            
            if ([carryArr1[i-1] isEqualToString:@"万"]||[carryArr1[i-1] isEqualToString:@"亿"]||[carryArr1[i-1] isEqualToString:@"元"]||[carryArr1[i-1] isEqualToString:@"兆"]) {
                //去除有“零万”
                if (zero) {
                    endStr =[NSMutableString stringWithFormat:@"%@",[endStr substringToIndex:(endStr.length-1)]];
                    [endStr appendString:carryArr1[i-1]];
                    zero=NO;
                }else{
                    [endStr appendString:carryArr1[i-1]];
                    zero=NO;
                }
                
                //去除有“亿万”、"兆万"的情况
                if ([carryArr1[i-1] isEqualToString:@"万"]) {
                    if ([[endStr substringWithRange:NSMakeRange(endStr.length-2, 1)] isEqualToString:@"亿"]) {
                        endStr =[NSMutableString stringWithFormat:@"%@",[endStr substringToIndex:endStr.length-1]];
                    }
                    
                    if ([[endStr substringWithRange:NSMakeRange(endStr.length-2, 1)] isEqualToString:@"兆"]) {
                        endStr =[NSMutableString stringWithFormat:@"%@",[endStr substringToIndex:endStr.length-1]];
                    }
                    
                }
                //去除“兆亿”
                if ([carryArr1[i-1] isEqualToString:@"亿"]) {
                    if ([[endStr substringWithRange:NSMakeRange(endStr.length-2, 1)] isEqualToString:@"兆"]) {
                        endStr =[NSMutableString stringWithFormat:@"%@",[endStr substringToIndex:endStr.length-1]];
                    }
                }
                
                
            }else{
                if (!zero) {
                    [endStr appendString:numArr[MyData]];
                    zero=YES;
                }
                
            }
            
        }else{
            //拼接数字
            [endStr appendString:numArr[MyData]];
            //拼接位
            [endStr appendString:carryArr1[i-1]];
            //不为“零”
            zero=NO;
        }
    }
    
    /**
     *  再遍历secondStr    角位----->分位
     */
    
    if ([secondStr isEqualToString:@"00"]) {
        [endStr appendString:@"整"];
    }else{
        for(int i=(int)secondStr.length;i>0;i--)
        {
            //取最高位数
            NSInteger MyData=[[secondStr substringWithRange:NSMakeRange(secondStr.length-i, 1)] integerValue];
            
            [endStr appendString:numArr[MyData]];
            [endStr appendString:carryArr2[i-1]];
        }
    }
    
    return endStr;
}

// 拨打电话
- (void)callPhone {
    
    if (self.length == 0) {
        return;
    }
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", self];
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
}

+ (void)stringForCountTimeNum:(NSInteger)totalCountTimeNum
            CountDownTimeType:(LBCountDownTimeType)timeType
                   targetTime:(dispatch_source_t)theTimer
             countDownSuccess:(void(^)(NSString *timeNum,NSInteger surplusTimeNum))timeSuccess
{
    if (totalCountTimeNum <= 0) {
        if (timeSuccess) {
            NSString *showTime = [self stringForCountTimeDescribeBySurplusCountTime:totalCountTimeNum CountDownTimeType:timeType];
            timeSuccess(showTime,totalCountTimeNum);
        }
        if (theTimer) {
            dispatch_source_cancel(theTimer);
        }
        return;
    }
    __block NSInteger timeout = totalCountTimeNum; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    theTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(theTimer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(theTimer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(theTimer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSString *showTime = [self stringForCountTimeDescribeBySurplusCountTime:timeout CountDownTimeType:timeType];
                if (0 == timeout) {
                    if (timeSuccess) {
                        timeSuccess(showTime,timeout);
                    }
                }
                
            });
            timeout--;
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                if (timeout > 0) {
                    NSString *showTime = [self stringForCountTimeDescribeBySurplusCountTime:timeout CountDownTimeType:timeType];
                    if (timeSuccess) {
                        timeSuccess(showTime,timeout);
                    }
                }
            });
            timeout--;
        }
    });
    
    dispatch_resume(theTimer);
}

+ (NSString *)stringForCountTimeDescribeBySurplusCountTime:(long long)countTime
                                         CountDownTimeType:(LBCountDownTimeType)timeType
{
    if (countTime <= 0) {
        if (LBCountDownTimeTypeYearMonthDay == timeType) {
            return @"0天0时00分00秒";
        } else if(LBCountDownTimeTypeHourMinuteSecond == timeType){
            return @"00:00:00";
        }else if(LBCountDownTimeTypeDayHourMinute == timeType){
            return @"00天00时00分";
        }else if(LBCountDownTimeTypeDayHour == timeType){
            return @"00天00时";
        }
        else{
            return @"00时00分00秒";
        }
        
    } else {
        long long oneDay = 24 * 60 * 60;
        long long oneHour = 60 * 60;
        long long oneMinutes = 60;
        
        long long days = countTime / oneDay;
        
        long long hours = (countTime - days * oneDay) / oneHour;
        
        long long minutes = (countTime - days * oneDay - hours * oneHour) / oneMinutes;
        
        long long seconds = (countTime - days * oneDay - hours * oneHour - minutes * oneMinutes);
        
        NSMutableString *timeString = [NSMutableString string];
        
        if (LBCountDownTimeTypeYearMonthDay == timeType) {
            
            NSString *dayString = [@(days)stringValue];
            
            if (1 == dayString.length) {
                dayString = [NSString stringWithFormat:@"%@",[@(days)stringValue]];
            }
            
            NSString *hoursString = [@(hours)stringValue];
            
            if (1 == hoursString.length) {
                hoursString = [NSString stringWithFormat:@"%@",[@(hours)stringValue]];
            }
            
            NSString *minutesString = [@(minutes)stringValue];
            
            if (1 == minutesString.length) {
                minutesString = [NSString stringWithFormat:@"0%@",[@(minutes)stringValue]];
            }
            
            NSString *secondString = [@(seconds)stringValue];
            
            if (1 == secondString.length) {
                secondString = [NSString stringWithFormat:@"0%@",[@(seconds)stringValue]];
            }
            
            [timeString appendFormat:@"%@天",dayString];
            
            [timeString appendFormat:@"%@时",hoursString];
            
            [timeString appendFormat:@"%@分",minutesString];
            
            [timeString appendFormat:@"%@秒",secondString];
            
            return timeString;
        } else if(LBCountDownTimeTypeHourMinuteSecond == timeType){
            
            NSString *hoursString = [@(hours)stringValue];
            
            if (1 == hoursString.length) {
                hoursString = [NSString stringWithFormat:@"0%@",[@(hours)stringValue]];
            }
            
            NSString *minutesString = [@(minutes)stringValue];
            
            if (1 == minutesString.length) {
                minutesString = [NSString stringWithFormat:@"0%@",[@(minutes)stringValue]];
            }
            
            NSString *secondString = [@(seconds)stringValue];
            
            if (1 == secondString.length) {
                secondString = [NSString stringWithFormat:@"0%@",[@(seconds)stringValue]];
            }
            
            [timeString appendFormat:@"%@:",hoursString];
            
            [timeString appendFormat:@"%@:",minutesString];
            
            [timeString appendFormat:@"%@",secondString];
            
            return timeString;
        }
        else if(LBCountDownTimeTypeDayHourMinute == timeType){
            
            NSString *dayString = [@(days)stringValue];
            
            if (1 == dayString.length) {
                dayString = [NSString stringWithFormat:@"%@",[@(days)stringValue]];
            }
            
            NSString *hoursString = [@(hours)stringValue];
            
            if (1 == hoursString.length) {
                hoursString = [NSString stringWithFormat:@"%@",[@(hours)stringValue]];
            }
            
            NSString *minutesString = [@(minutes)stringValue];
            
            if (1 == minutesString.length) {
                minutesString = [NSString stringWithFormat:@"0%@",[@(minutes)stringValue]];
            }
            [timeString appendFormat:@"%@天",dayString];
            
            [timeString appendFormat:@"%@时",hoursString];
            
            [timeString appendFormat:@"%@分",minutesString];
            
            
            return timeString;
        }
        else if(LBCountDownTimeTypeDayHour == timeType){
            
            NSString *dayString = [@(days)stringValue];
            
            if (1 == dayString.length) {
                dayString = [NSString stringWithFormat:@"%@",[@(days)stringValue]];
            }
            
            NSString *hoursString = [@(hours)stringValue];
            
            if (1 == hoursString.length) {
                hoursString = [NSString stringWithFormat:@"%@",[@(hours)stringValue]];
            }
            
            [timeString appendFormat:@"%@天",dayString];
            
            [timeString appendFormat:@"%@时",hoursString];
            
            return timeString;
        }
        else{
            NSString *hoursString = [@(hours)stringValue];
            
            if (1 == hoursString.length) {
                hoursString = [NSString stringWithFormat:@"0%@",[@(hours)stringValue]];
            }
            
            NSString *minutesString = [@(minutes)stringValue];
            
            if (1 == minutesString.length) {
                minutesString = [NSString stringWithFormat:@"0%@",[@(minutes)stringValue]];
            }
            
            NSString *secondString = [@(seconds)stringValue];
            
            if (1 == secondString.length) {
                secondString = [NSString stringWithFormat:@"0%@",[@(seconds)stringValue]];
            }
            
            [timeString appendFormat:@"%@时",hoursString];
            
            [timeString appendFormat:@"%@分",minutesString];
            
            [timeString appendFormat:@"%@秒",secondString];
            
            return timeString;
        }
    }
}

@end
