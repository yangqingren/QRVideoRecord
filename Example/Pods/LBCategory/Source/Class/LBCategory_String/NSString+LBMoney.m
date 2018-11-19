//
//  NSString+LBMoney.m
//  app
//
//  Created by LINAICAI on 16/8/30.
//  Copyright © 2016年 广东联结电子商务有限公司. All rights reserved.
//

#import "NSString+LBMoney.h"
@implementation NSString (LBMoney)
/**
 *  金额显示(统一) 整除保留两位小数，否则不带小数点
 *
 *  @param money 金额字符串（单位：分）
 *
 *  @return
 */
+ (NSString *)lb_getFormatWithMoney:(NSString *)money{
    NSString *newMoney;

    if (money.length && [money containsString:@"."]) {
        //兼容带小数位的字符串
        newMoney = [money substringToIndex:[money rangeOfString:@"."].location];
    }
    else{
        newMoney = money;
    }
    if (newMoney.length < 7) {
        //小于一万
        NSString *suffix = @"00";
        if ([newMoney hasSuffix:suffix])
        {
            return [NSString stringWithFormat:@"%.0f元",[newMoney doubleValue]/100];
        }
        else
        {
            return [NSString stringWithFormat:@"%.2f元",[newMoney doubleValue]/100];
        }
    }
    else if (newMoney.length < 11){
        //小于一亿大于一万
        NSString *suffix = @"000000";

        if ([newMoney hasSuffix:suffix])
        {
            return [NSString stringWithFormat:@"%.0f万",[newMoney doubleValue]/(10000*100)];
        }
        else
        {
            return [NSString stringWithFormat:@"%.2f万",[newMoney doubleValue]/(10000*100)];
        }
    }
    else{
        //大于一亿
        NSString *suffix = @"0000000000";
        
        if ([newMoney hasSuffix:suffix])
        {
            newMoney = [NSString stringWithFormat:@"%.0f亿",[newMoney doubleValue]/(10000*10000*100.0)];
        }
        else
        {
            // 除以 10000*10000*100 会溢出 得到错误结果
            newMoney = [NSString stringWithFormat:@"%.2f亿",[newMoney doubleValue]/(10000*10000*100.0)];
        }
        
        return newMoney;
    }
    
    return newMoney;
}

// 返回元单位
+ (NSString *)lb_getYuanFormatWithMoney:(NSString *)money
{
    NSString *newMoney;
    
    if (money.length && [money containsString:@"."]) {
        //兼容带小数位的字符串
        newMoney = [money substringToIndex:[money rangeOfString:@"."].location];
    }
    else{
        newMoney = money;
    }

    return [NSString stringWithFormat:@"%.2f元",[newMoney doubleValue]/100];

}


+(NSString *)lb_getYuanFormatWithFen:(NSString *)Fen
{
    NSString *newMoney;
    
    if (Fen.length && [Fen containsString:@"."]) {
        //兼容带小数位的字符串
        newMoney = [Fen substringToIndex:[Fen rangeOfString:@"."].location];
    }
    else{
        newMoney = Fen;
    }
    
    return [NSString stringWithFormat:@"%.2f",[newMoney doubleValue]/100];
}

+(NSString *)lb_getFenFormatWithYuan:(NSString *)yuan
{
    return [NSString stringWithFormat:@"%ld",(long)([yuan floatValue] * 100)];
}
+(NSString *)lb_getYuanFormatWithoutPointWithMoney:(NSString *)money
{
    NSString *newMoney;
    
    if (money.length && [money containsString:@"."]) {
        //兼容带小数位的字符串
        newMoney = [money substringToIndex:[money rangeOfString:@"."].location];
    }
    else{
        newMoney = money;
    }
    long long showMoney = (long long)([newMoney doubleValue]/100);
    if (showMoney == 0) {
        if ([money longLongValue] != 0) {
            return [NSString stringWithFormat:@"%.2f元",([newMoney doubleValue]/100)];
        }else{
            return [NSString stringWithFormat:@"%@元",@((long long)([newMoney doubleValue]/100))];
        }
    }
    return [NSString stringWithFormat:@"%@元",@((long long)([newMoney doubleValue]/100))];
}

// 返回万单位
+ (NSString *)lb_getWanFormatWithMoney:(NSString *)money
{
    NSString *newMoney;
    
    if (money.length && [money containsString:@"."]) {
        //兼容带小数位的字符串
        newMoney = [money substringToIndex:[money rangeOfString:@"."].location];
    }
    else{
        newMoney = money;
    }
    
    return [NSString stringWithFormat:@"%.2f万",[newMoney doubleValue]/(100*10000)];
}

+ (NSString *)lb_getWanFormatForBid:(NSString *)money
{
    NSString *newMoney;

    if (money.length && [money containsString:@"."]) {
        //兼容带小数位的字符串
        newMoney = [money substringToIndex:[money rangeOfString:@"."].location];
    }
    else
    {
        newMoney = money;
    }
    
    if (newMoney.length < 7) {
        // 小于一万
        return [NSString stringWithFormat:@"%.2f元",[newMoney doubleValue]/100];
    }
    else
    {
        //
        return [NSString stringWithFormat:@"%.2f万",[newMoney doubleValue]/(10000*100)];
    }
}

// 金额小写转大写
+(NSString *)digitUppercase:(NSString *)numstr{
    double numberals=[numstr doubleValue];
    NSArray *numberchar = @[@"零",@"壹",@"贰",@"叁",@"肆",@"伍",@"陆",@"柒",@"捌",@"玖"];
    NSArray *inunitchar = @[@"",@"拾",@"佰",@"仟"];
    NSArray *unitname = @[@"",@"万",@"亿",@"万亿"];
    //金额乘以100转换成字符串（去除圆角分数值）
    NSString *valstr=[NSString stringWithFormat:@"%.2f",numberals];
    NSString *prefix;
    NSString *suffix;
    if (valstr.length<=2) {
        prefix=@"零元";
        if (valstr.length==0) {
            suffix=@"零角零分";
        }
        else if (valstr.length==1)
        {
            suffix=[NSString stringWithFormat:@"%@分",[numberchar objectAtIndex:[valstr intValue]]];
        }
        else
        {
            NSString *head=[valstr substringToIndex:1];
            NSString *foot=[valstr substringFromIndex:1];
            suffix = [NSString stringWithFormat:@"%@角%@分",[numberchar objectAtIndex:[head intValue]],[numberchar  objectAtIndex:[foot intValue]]];
        }
    }
    else
    {
        prefix=@"";
        suffix=@"";
        NSInteger flag = valstr.length - 2;
        NSString *head=[valstr substringToIndex:flag - 1];
        NSString *foot=[valstr substringFromIndex:flag];
        if (head.length>13) {
            return@"数值太大（最大支持13位整数），无法处理";
        }
        //处理整数部分
        NSMutableArray *ch=[[NSMutableArray alloc]init];
        for (int i = 0; i < head.length; i++) {
            NSString * str=[NSString stringWithFormat:@"%x",[head characterAtIndex:i]-'0'];
            [ch addObject:str];
        }
        int zeronum=0;
        
        for (int i=0; i<ch.count; i++) {
            int index=(ch.count -i-1)%4;//取段内位置
            NSInteger indexloc=(ch.count -i-1)/4;//取段位置
            if ([[ch objectAtIndex:i]isEqualToString:@"0"]) {
                zeronum++;
            }
            else
            {
                if (zeronum!=0) {
                    if (index!=3) {
                        prefix=[prefix stringByAppendingString:@"零"];
                    }
                    zeronum=0;
                }
                prefix=[prefix stringByAppendingString:[numberchar objectAtIndex:[[ch objectAtIndex:i]intValue]]];
                prefix=[prefix stringByAppendingString:[inunitchar objectAtIndex:index]];
            }
            if (index ==0 && zeronum<4) {
                prefix=[prefix stringByAppendingString:[unitname objectAtIndex:indexloc]];
            }
        }
        prefix =[prefix stringByAppendingString:@"元"];
        //处理小数位
        if ([foot isEqualToString:@"00"]) {
            suffix =[suffix stringByAppendingString:@"整"];
        }
        else if ([foot hasPrefix:@"0"])
        {
            NSString *footch=[NSString stringWithFormat:@"%x",[foot characterAtIndex:1]-'0'];
            suffix=[NSString stringWithFormat:@"%@分",[numberchar objectAtIndex:[footch intValue] ]];
        }
        else
        {
            NSString *headch=[NSString stringWithFormat:@"%x",[foot characterAtIndex:0]-'0'];
            NSString *footch=[NSString stringWithFormat:@"%x",[foot characterAtIndex:1]-'0'];
            suffix=[NSString stringWithFormat:@"%@角%@分",[numberchar objectAtIndex:[headch intValue]],[numberchar  objectAtIndex:[footch intValue]]];
        }
    }
    
    return [prefix stringByAppendingString:suffix];
}

/**
 精度准确计算
 
 @param fen 分
 @return 元
 */
+ (NSString *)lb_getYuanBydecimalNumber:(NSString *)fen {
    if (!fen) {
        fen = @"0";
    }
    NSDecimalNumber *price = [NSDecimalNumber decimalNumberWithString:fen];
    NSDecimalNumber *hundred = [NSDecimalNumber decimalNumberWithString:@"100"];
    
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    
    // 除
    return [[price decimalNumberByDividingBy:hundred withBehavior:roundUp] stringValue];
}

/**
 精度准确计算
 
 @param fen 元
 @return 分
 */
+ (NSString *)lb_getFenBydecimalNumber:(NSString *)yuan {
    if (!yuan) {
        yuan = @"0";
    }
    NSDecimalNumber *price = [NSDecimalNumber decimalNumberWithString:yuan];
    NSDecimalNumber *hundred = [NSDecimalNumber decimalNumberWithString:@"100"];
    
    // 乘
    return [[price decimalNumberByMultiplyingBy:hundred ] stringValue];
}

@end
