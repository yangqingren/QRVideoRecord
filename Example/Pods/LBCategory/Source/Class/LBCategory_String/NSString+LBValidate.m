//
//  NSString+LBValidate.m
//  LJBiddingPlatform
//
//  Created by 献华 付 on 16/1/13.
//  Copyright © 2016年 Do1. All rights reserved.
//

#import "NSString+LBValidate.h"

@implementation NSString (LBValidate)
//  1.NSString 为空(nil)的验证
- (BOOL)emptyOrNull{
    if (self == nil) {
        return YES;
    }
    if ([self isEqual:[NSNull null]]) {
        return YES;
    }
    if ([self isEqualToString:@""]) {
        return YES;
    }
    if ([self isEqualToString:@"null"]) {
        return YES;
    }
    if (self == NULL) {
        return YES;
    }
    if ([self isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
//  2.邮箱验证
-(BOOL)validateEmail{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}
//  3.电话号验证
-(BOOL)validateMobileNumber{
    if (!self.length) {
        return NO;
    }
    //只判断1开头，并且11位
//    return [self hasPrefix:@"1"] && self.length == 11;
/**
         * 手机号码
         * 移动：134(0-8)、135、136、137、138、139、147、150、151、152、157、158、159、178、182、183、184、187、188、198
         * 联通：130、131、132、145、155、156、166、175、176、185、186
         * 电信：133、149、153、173、177、180、181、189、199
         */
        NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9]|70|71|73)\\d{8}$";
        
        /**
         10         * 中国移动：China Mobile
         11         * 134(0-8)、135、136、137、138、139、147、150、151、152、157、158、159、178、182、183、184、187、188、198
         12         */
        NSString * CM = @"^1(34[0-8]|(3[5-9]|5[0127-9]|7[8]|8[23478]|47|98)\\d)\\d{7}$";
        
        /**
         15         * 中国联通：China Unicom
         16         * 130、131、132、145、155、156、166、175、176、185、186
         17         */
        NSString * CU = @"^1(3[0-2]|4[5]|5[56]|6[6]|7[56]|8[56])\\d{8}$";
        
        /**
         20         * 中国电信：China Telecom
         21         * 133、149、153、173、177、180、181、189、199
         22         */
        NSString * CT = @"^((133)|(149)|(153)|(199)|(17[3,7])|(18[0,1,9]))\\d{8}|(170[0-2])\\d{7}$";
        /**
         25         * 大陆地区固话及小灵通
         26         * 区号：010,020,021,022,023,024,025,027,028,029
         27         * 号码：七位或八位
         28         */
        NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
        
        NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
        
        NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
        
        NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
        
        NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
        
        NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
        
        
        if (([regextestmobile evaluateWithObject:self] == YES)
            
            || ([regextestcm evaluateWithObject:self] == YES)
            
            || ([regextestct evaluateWithObject:self] == YES)
            
            || ([regextestcu evaluateWithObject:self] == YES)
            
            || ([regextestphs evaluateWithObject:self] == YES))
            
        {
            return YES;
        }
        else
        {
            return NO;
        }
    
}

//  4.身份证验证
-(BOOL)validateIdentityCard{
    NSString *regex1 = @"^\\d{15}$";
    NSString *regex2 = @"^\\d{17}[0-9xX]$";
    NSPredicate *identityCardPredicate1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex1];
    NSPredicate *identityCardPredicate2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    if ( [identityCardPredicate1 evaluateWithObject:self]) {
        return YES;
    }
    else if ([identityCardPredicate2 evaluateWithObject:self]){
        NSArray *vs = @[@"1",@"0",@"x",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2"];
        NSArray *ps = @[@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2"];
        NSMutableArray *ss = [NSMutableArray arrayWithCapacity:self.length];
        for (NSInteger i = 0; i<self.length; i++) {
            NSString *str = [[self substringWithRange:NSMakeRange(i, 1)]lowercaseString];
            [ss addObject:str];
        }
//        NSLog(@"ss=%@",ss);
        long long r = 0;
        for (NSInteger i = 0; i < 17; i++) {
//            NSLog(@"i=%ld",i);
            r += [ps[i] longLongValue] * [ss[i] longLongValue];
//            NSLog(@"内循环中r=%lld",r);
        }
//        NSLog(@"最终r=%lld",r);
        return ([vs[r % 11] isEqualToString:ss[17]]);
    }
    return NO;

//    BOOL flag;
//    if (self.length <= 0) {
//        flag = NO;
//        return flag;
//    }
//    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
//    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
//    return [identityCardPredicate evaluateWithObject:self];
}

// 身份证号隐藏部分442**** ****1234
- (NSString *)startWithIdentityCard{
    if (self.length >= 4) {
        NSString * prefix = [self substringWithRange:NSMakeRange(0, 3)];
        NSString * Suffix = [self substringWithRange:NSMakeRange(self.length - 4, 4)];
        return [NSString stringWithFormat:@"%@**** ****%@",prefix,Suffix];
    }else{
        return self;
    }
}


-(BOOL)validatejudgePassWordLegal{
    BOOL result = false;
    //// 判断长度大于等于6位小于等于16位同时包含数字和字符
    NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    result = [pred evaluateWithObject:self];

    return result;
}
//  判断字符串中是否含有中文
- (BOOL)isHaveChinese{
    if (self.length) {
        for (NSInteger i = 0; i < self.length; i++) {
            int a = [self characterAtIndex:i];
            if (a > 0x4e00 && a < 0x9fff) {
                return YES;
            }
        }
    }
    return NO;
}
//  判断字符串中是否含有空格
- (BOOL)isHaveSpace{
    if (self.length) {
        NSRange _rang = [self rangeOfString:@" "];
        if (_rang.location != NSNotFound) {
            return YES;
        }
    }
    return NO;
}
///验证支付密码
-(BOOL)validatePayPass{
    BOOL result = false;
    if ([self length] >= 6){
        //// 判断长度大于6位后再接着判断是否同时包含数字和字符
        NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,12}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:self];
    }
    return result;
}
//验证昵称
-(BOOL)validateNick
{
    BOOL result = false;
    if ([self length] > 0){
        //// 判断是否只包含数字
        NSString * regex = @"^[0-9]*$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:self];
    }
    return !result;
}
//是否全数字
-(BOOL)validateNumber
{
    BOOL result = false;
    if ([self length] > 0){
        //// 判断是否只包含数字
        NSString * regex = @"^[0-9]*$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:self];
    }
    return result;
}
// 是否包含汉字
-(BOOL)validateChinese
{
    
    BOOL result = false;
    if ([self length] > 0){
        //// 判断是否包含汉字
        NSString * regex = @"[\u4e00-\u9fa5]";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:self];
    }
    return result;
    
}
// 是否全是汉字（包括·）
-(BOOL)validateAllChinese {
    BOOL result = false;
    if ([self length] > 0){
        NSString * regex = @"^[\u4e00-\u9fa5]{0,10}[·.]{0,1}[\u4e00-\u9fa5]{0,10}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:self];
    }
    return result;
}

//根据正则，过滤特殊字符
- (NSString *)filterCharactorWithRegex:(NSString *)regexStr{
    NSString *searchText = self;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *result = [regex stringByReplacingMatchesInString:searchText options:NSMatchingReportCompletion range:NSMakeRange(0, searchText.length) withTemplate:@""];
    return result;
}

///验证金额
-(BOOL) validateMoney
{
    BOOL result = false;
    if ([self length] > 0){
        //// 判断是否为金额
        NSString * regex = @"^(([1-9]\\d{0,9})|0)(\\.\\d{1,2})?$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:self];
    }
    return result;
}

// 验证正浮点数
-(BOOL)validatefloatingPoint
{
    BOOL result = false;
    if ([self length] > 0){
        //// 判断是否为金额
        NSString * regex = @"^(([0-9]+\\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\\.[0-9]+)|([0-9]*[1-9][0-9]*))$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:self];
    }
    return result;
}
// 是否为正整数
-(BOOL) validateInt
{
    BOOL result = false;
    if ([self length] > 0){
        //// 判断是否为金额
        NSString * regex = @"^[0-9]*[1-9][0-9]*$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:self];
    }
    return result;
}


// 判断是不是座机号
- (BOOL) validateTelphone{
    

    
    NSString *phoneRegex = @"\\d{3}-\\d{8}|\\d{4}-\\d{7,8}";
    
    
    
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    
    
    
    return [phoneTest evaluateWithObject:self];
    
}

//判断是否为表情符号
- (BOOL)stringContainsEmoji
{
    __block BOOL returnValue = NO;
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}


@end
