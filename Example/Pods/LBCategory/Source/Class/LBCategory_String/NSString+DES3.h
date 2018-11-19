//
//  NSString+DES3.h
//  LBCategory
//
//  Created by wzl on 2018/7/23.
//

#import <Foundation/Foundation.h>

@interface NSString (DES3)


//3DES 加密参数约束
//偏移量 ：01234567
//加密模式 ：cbc
//填充模式： PKCS5Padding
//在DES中加密数据包单位长度是8字节，在8字节的情况下PKCS7Padding 等价与 PKCS5Padding。貌似.net可以修改数据包长度，OC、Java不清楚能不能修改，但默认都是8字节的。因此手不要太轻，不随意修改默认值，就不用去纠结PKCS7Padding和PKCS5Padding了，要是你兴趣浓厚，那就随意。


/**字符串加密 */
+ (NSString *)doEncryptStr:(NSString *)originalStr;
/**字符串解密 */
+ (NSString*)doDecEncryptStr:(NSString *)encryptStr;
/**十六进制加密 */
+ (NSString *)doEncryptHex:(NSString *)originalStr;
/**十六进制解密 */
+ (NSString*)doDecEncryptHex:(NSString *)encryptStr;

@end
