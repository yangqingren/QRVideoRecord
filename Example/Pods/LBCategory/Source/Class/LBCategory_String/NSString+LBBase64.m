//
//  NSString+LBBase64.m
//  LBCategory
//
//  Created by 杨庆人 on 2018/1/18.
//

#import "NSString+LBBase64.h"

@implementation NSString (LBBase64)
- (NSString *)base64EncodedString;
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

- (NSString *)base64DecodedString
{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:self options:0];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}
@end
