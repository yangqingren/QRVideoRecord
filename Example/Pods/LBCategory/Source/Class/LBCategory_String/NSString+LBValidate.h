//
//  NSString+LBValidate.h
//  LJBiddingPlatform
//
//  Created by 献华 付 on 16/1/13.
//  Copyright © 2016年 Do1. All rights reserved.
//  数据验证工具类

#import <Foundation/Foundation.h>

@interface NSString (LBValidate)
//  1.NSString 为空(nil)的验证
-(BOOL)emptyOrNull;
//  2.邮箱验证
-(BOOL)validateEmail;
//  3.电话号验证
-(BOOL)validateMobileNumber;
//  4.座机检验
- (BOOL) validateTelphone;
//  4.身份证验证
-(BOOL)validateIdentityCard;
//6-32为数字字母验证
-(BOOL)validatejudgePassWordLegal;
//6-12位数字字母验证
-(BOOL)validatePayPass;
//验证昵称 你能全是数字
-(BOOL)validateNick;
// 身份证号隐藏部分442**** ****1234
- (NSString *)startWithIdentityCard;
//根据正则，过滤特殊字符
- (NSString *)filterCharactorWithRegex:(NSString *)regexStr;
//  判断字符串中是否含有中文
- (BOOL)isHaveChinese;
//  判断字符串中是否含有空格
- (BOOL)isHaveSpace;
//验证是否包含汉字
-(BOOL)validateChinese;
// 是否全是汉字（包括·）
-(BOOL)validateAllChinese;
///判断是否为正常金额
-(BOOL) validateMoney;
// 是否为正整数
- (BOOL)validateInt;
// 验证正浮点数
-(BOOL)validatefloatingPoint;
//是否全数字
-(BOOL)validateNumber;
//校验输入是否有表情
- (BOOL)stringContainsEmoji;


@end
