//
//  AA3DESManager.m
//  AA3DESDemo
//
//  Created by Arlexovincy on 15/3/12.
//  Copyright (c) 2015年 Arlexovincy. All rights reserved.
//

#import "AA3DESManager.h"
#import "GTMBase64.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCrypto.h>

@implementation AA3DESManager

#pragma mark- 3des加密
+ (NSString*)getEncryptWithString:(NSString *)encryptString keyString:(NSString *)keyString ivString:(NSString *)ivString{

    return [self doCipher:encryptString keyString:keyString ivString:ivString operation:kCCEncrypt];
}

#pragma mark- 3des解密
+ (NSString*)getDecryptWithString:(NSString *)decryptString keyString:(NSString *)keyString ivString:(NSString *)ivString{

    return [self doCipher:decryptString keyString:keyString ivString:ivString operation:kCCDecrypt];
}

+(NSString *) doCipher:(NSString*)plainText keyString:(NSString*)keyString ivString:(NSString*)ivString operation:(CCOperation)encryptOrDecrypt
{
    const void * vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOrDecrypt== kCCDecrypt)
    {
        NSData * EncryptData = [GTMBase64 decodeData:[plainText
                                                      dataUsingEncoding:NSUTF8StringEncoding]];
        
        plainTextBufferSize= [EncryptData length];
        vplainText = [EncryptData bytes];
    }
    else
    {
        NSData * tempData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize= [tempData length];
        vplainText = [tempData bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t * bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    // uint8_t ivkCCBlockSize3DES;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES)
    &~(kCCBlockSize3DES- 1);
    
    bufferPtr = malloc(bufferPtrSize* sizeof(uint8_t));
    memset((void*)bufferPtr,0x0, bufferPtrSize);
    
    NSString * key = keyString;
    NSString * initVec = ivString;
    
    const void * vkey= (const void *)[key UTF8String];
    const void * vinitVec= (const void *)[initVec UTF8String];
    
    uint8_t iv[kCCBlockSize3DES];
    memset((void*) iv,0x0, (size_t)sizeof(iv));
    
    ccStatus = CCCrypt(encryptOrDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey,//"123456789012345678901234", //key
                       kCCKeySize3DES,
                       vinitVec,//"init Vec", //iv,
                       vplainText,//plainText,
                       plainTextBufferSize,
                       (void*)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    //if (ccStatus == kCCSuccess) NSLog(@"SUCCESS");
    if (ccStatus== kCCParamError) return @"PARAM ERROR";
    else if (ccStatus == kCCBufferTooSmall) return @"BUFFER TOO SMALL";
    else if (ccStatus == kCCMemoryFailure) return @"MEMORY FAILURE";
    else if (ccStatus == kCCAlignmentError) return @"ALIGNMENT";
    else if (ccStatus == kCCDecodeError) return @"DECODE ERROR";
    else if (ccStatus == kCCUnimplemented) return @"UNIMPLEMENTED";
    
    NSString * result;
    
    if (encryptOrDecrypt== kCCDecrypt)
    {
        result = [[NSString alloc] initWithData:[NSData
                                                 dataWithBytes:(const void *)bufferPtr
                                                 length:(NSUInteger)movedBytes]
                                       encoding:NSUTF8StringEncoding];
        ;
    }
    else
    {
        NSData * myData =[NSData dataWithBytes:(const void *)bufferPtr
                                        length:(NSUInteger)movedBytes];
        
        result = [GTMBase64 stringByEncodingData:myData];
    }
    
    return result;
}

@end
