//
//  NSString+LBString.h
//  app
//
//  Created by LINAICAI on 16/7/26.
//  Copyright © 2016年 广东联结电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,LBCountDownTimeType) {
    LBCountDownTimeTypeYearMonthDay = 1,//年月日时分秒
    LBCountDownTimeTypeHourMinuteSecond = 2,//时分秒
    LBCountDownTimeTypeHourMineteSecondChinese = 3,//用中文时分秒分隔开
    LBCountDownTimeTypeDayHourMinute = 4, //日时分
    LBCountDownTimeTypeDayHour = 5 //日时
};

@interface NSString (LBString)
/**
 获取阅读数

 @return return value description
 */
- (NSString *)readCount;

/**
 获取UTF8编码后的URL，防止URL中因为有中文而无法显示图片

 @return return value description
 */
- (NSString *)encodeURL;
/**
 *  截取URL中的参数
 *
 *  @return NSMutableDictionary parameters
 */
- (NSMutableDictionary *)getURLParameters;
/**
 获取阿里云图片缩略图
 
 @return 返回200*160的三倍图的缩略图
 */
- (NSString *)getThumbnails;
/**
 获取阿里云图片缩略图
 
 @param width 指定宽度
 @param height 指定高度
 @return return value description
 */
- (NSString *)getThumbnailBy:(NSUInteger )width height:(NSUInteger)height;
/**
 过滤HTML标签

 @param html html description
 @return return value description
 */
+ (NSString *)filterHTML:(NSString *)html;
/**
 *  根据字体返回文本宽度
 *
 *  @param text 文本
 *  @param font 字体
 *
 *  @return 文本宽度
 */
+ (CGFloat)getTextWidthWithText:(NSString *)text
                           Font:(UIFont *)font;
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
                           Width:(CGFloat)width;

/**
 *  返回文本宽高
 *
 *  @param content content description
 *  @param font    font description
 *  @param width   width description
 *
 *  @return return value description
 */
+ (CGSize)getTextSizeWithContent:(NSString *)content
                            Font:(UIFont *)font
                           Width:(CGFloat)width;



+ (CGFloat)realWidthForContentText:(NSString *)text
                              Font:(UIFont *)font
                        LimitWidth:(CGFloat)width;


/**
 给文字添加图片富文本

 @param image 图
 @param bounds 坐标大小
 @param index 位于文本的位置
 @return NSMutableAttributedString
 */
- (NSMutableAttributedString *)setAttStringWithImage:(UIImage *)image bounds:(CGRect)bounds index:(NSInteger)index;

/**
 *  DES:阿里云图片压缩图
 *
 *  @param (IN) quality 图片质量
 *  @param (IN) sizeW 压缩后图片宽度
 *  @param (IN) sizeH 压缩后图片高度
 *  @return
 *
 **/
- (NSString *)imageUrlWithQuality:(NSUInteger )quality sizeW:(NSUInteger)sizeW sizeH:(NSUInteger)sizeH;

/**
 *  DES: 企业年报数据展示扩展 -1.企业不公示 0.否 1.是
 *
 *  @param (IN)
 *  @param (IN)
 *
 *  @return
 *
 **/
- (NSString *)companyAnualReportStr;

/**
 *  DES: 企业年报数据展示扩展 -1.企业不公示 其他返回单位万元
 *
 *  @param (IN)
 *  @param (IN)
 *
 *  @return
 *
 **/
- (NSString *)companyAnualReportMoneyDigital;

/**
 *  根据传入的字符串和子串,修改字符串中子串的字体大小和颜色
 *
 *  @param string
 *  @param subString 
 *  @param font
 *  @param fontColor
 *
 *  @return
 */
+(NSMutableAttributedString *)getAtrributedStringWithString:(NSString *)string subString:(NSString *)subString font:(UIFont *)font fontColor:(UIColor *)fontColor;


/**
 *  数据金额转换大写金额
 *
 *  @param amountStr 数字金额
 *
 *  @return 大写金额
 */
- (NSString*)conversionChineseDigital;

//根据判断系统版本处理  关于拨打电话的方法，自己凭喜好选择，导致弹出框延迟的原因，目前初步诊断就是openURL在iOS 10及其之后会阻塞主线程
- (void)callPhone;

/**
 *  倒计时
 *
 *  @param totalCountTimeNum 倒计秒数
 *  @param timeType          返回时间类型
 *  @param theTimer          设置倒计时所在目标时间格式
 *  @param timeSuccess       timeSuccess description
 */
+ (void)stringForCountTimeNum:(NSInteger)totalCountTimeNum
            CountDownTimeType:(LBCountDownTimeType)timeType
                   targetTime:(dispatch_source_t)theTimer
             countDownSuccess:(void(^)(NSString *timeNum,NSInteger surplusTimeNum))timeSuccess;
/**
 *  秒时间转化
 *
 *  @param countTime 倒计秒数
 *  @param timeType  返回时间类型
 *
 *  @return return value description
 */
+ (NSString *)stringForCountTimeDescribeBySurplusCountTime:(long long)countTime
                                         CountDownTimeType:(LBCountDownTimeType)timeType;

@end
