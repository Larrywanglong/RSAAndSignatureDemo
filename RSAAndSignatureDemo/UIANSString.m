//
//  UIANSString.m
//  UIADemo
//
//  Created by zhangchao on 16/12/14.
//  Copyright © 2016年 王龙. All rights reserved.
//

#import "UIANSString.h"

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@implementation UIANSString

+ (NSString *)hexStringFromData:(NSData *)data{
    unsigned char * cc=(unsigned char*)[data bytes];
    NSString * hexStr=@"";
    for(int i=0;i<[data length];i++)
    {
        hexStr=[hexStr stringByAppendingString:[NSString stringWithFormat:@"%02X",cc[i]]];
    }
    return hexStr;
}

+ (NSData*)Decrypt:(NSString*)text{
    if(text&&![text isEqualToString:@""]){
        NSData *data = [self dataWithBase64EncodedString:text];
        return data;
    }else
        return nil;
}

+ (NSData *)dataWithBase64EncodedString:(NSString *)string
{
    if (string == nil)
        return nil;
    if ([string length] == 0)
        return [NSData data];
    
    static char *decodingTable = NULL;
    if (decodingTable == NULL)
    {
        decodingTable = (char*)malloc(256);
        if (decodingTable == NULL)
            return nil;
        memset(decodingTable, CHAR_MAX, 256);
        NSUInteger i;
        for (i = 0; i < 64; i++)
            decodingTable[(short)encodingTable[i]] = i;
    }
    const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
    if (characters == NULL)     //  Not an ASCII string!
        return nil;
    char *bytes = (char*)malloc((([string length] + 3) / 4) * 3);
    if (bytes == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (YES)
    {
        char buffer[4];
        short bufferLength;
        for (bufferLength = 0; bufferLength < 4; i++)
        {
            if (characters[i] == '\0')
                break;
            if (isspace(characters[i]) || characters[i] == '=')
                continue;
            buffer[bufferLength] = decodingTable[(short)characters[i]];
            if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
            {
                free(bytes);
                return nil;
            }
        }
        if (bufferLength == 0)
            break;
        if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
        {
            free(bytes);
            return nil;
        }
        //  Decode the characters in the buffer to bytes.
        bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
        if (bufferLength > 2)
            bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
        if (bufferLength > 3)
            bytes[length++] = (buffer[2] << 6) | buffer[3];
    }
    
    bytes = (char*)realloc(bytes, length);
    return [NSData dataWithBytesNoCopy:bytes length:length];
}
@end
