//
//  UIANSString.h
//  UIADemo
//
//  Created by zhangchao on 16/12/14.
//  Copyright © 2016年 王龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIANSString : NSObject
/**
 数据转换为16进制字符串

 @param data 数据

 @return 转换后的字符串
 */
+ (NSString *)hexStringFromData:(NSData *)data;

/*** base64解码 **/

/**
 BASE64编码解密文本

 @param text 需要解密的文本

 @return 解密后的结果
 */
+ (NSData*)Decrypt:(NSString*)text;
@end
