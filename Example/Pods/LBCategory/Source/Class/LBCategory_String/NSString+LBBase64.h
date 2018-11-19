//
//  NSString+LBBase64.h
//  LBCategory
//
//  Created by 杨庆人 on 2018/1/18.
//

#import <Foundation/Foundation.h>

@interface NSString (LBBase64)
/**
 *  转换为Base64编码
 */
- (NSString *)base64EncodedString;
/**
 *  将Base64编码解码
 */
- (NSString *)base64DecodedString;
@end
