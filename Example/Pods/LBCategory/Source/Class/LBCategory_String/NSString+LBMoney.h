//
//  NSString+LBMoney.h
//  app
//
//  Created by LINAICAI on 16/8/30.
//  Copyright © 2016年 广东联结电子商务有限公司. All rights reserved.
//  金额格式化定义

#import <Foundation/Foundation.h>

@interface NSString (LBMoney)
/**
 *  金额显示(统一)
 *
 *  @param money 金额字符串（单位：分）
 *
 *  @return
 */
+ (NSString *)lb_getFormatWithMoney:(NSString *)money;

/**
 *
 * DES: 获取元为单位的金额字符串
 
 * @param (IN) money 金额 单位分
 
 * @return
 
 */

+ (NSString *)lb_getYuanFormatWithMoney:(NSString *)money;



/**
 *
 * DES: 获取元为单位的金额字符串,不带元为单位的
 * @param Fen money 金额 单位分
 
 * @return
 
 */
+ (NSString *)lb_getYuanFormatWithFen:(NSString *)Fen;

/**
 *  设置model的时候需要把用户的参数,一般情况是元转成分,传给后台
 *
 *  @param yuan 用户的输入
 *
 *  @return 转换的方法
 */
+ (NSString *)lb_getFenFormatWithYuan:(NSString *)yuan;

/**
 *  * DES: 获取元为单位的金额字符串,不带小数点
 *
 *  @param money
 *
 *  @return 
 */
+ (NSString *)lb_getYuanFormatWithoutPointWithMoney:(NSString *)money;


/**
 *
 * DES: 获取万为单位的金额字符串
 
 * @param (IN) money 金额 单位分
 
 * @return
 
 */
+ (NSString *)lb_getWanFormatWithMoney:(NSString *)money;

/**
 *
 * DES: 招标人金额显示规则
 超过万元，以万元为单位精确到0.00 ；未超过万元的，以元为 单位精确到0.00
 
 * @param (IN) money 单位分
 
 * @return
 
 */
+ (NSString *)lb_getWanFormatForBid:(NSString *)money;

/**
 *  DES: 金额小写转大写
 *
 *  @param (IN) numstr 小写金额
 *  @param (IN)
 *
 *  @return
 *
 **/
+(NSString *)digitUppercase:(NSString *)numstr;


/**
 精度准确计算

 @param fen 分
 @return 元
 */
+ (NSString *)lb_getYuanBydecimalNumber:(NSString *)fen;

/**
 精度准确计算
 
 @param fen 元
 @return 分
 */
+ (NSString *)lb_getFenBydecimalNumber:(NSString *)yuan;

@end
