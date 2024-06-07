//
//  KIRSA.m
//  CodeFragmentation
//
//  Created by Kaaaaai on 2020/3/27.
//  Copyright © 2020 Kaaaaai. All rights reserved.
//

#import "KIRSA.h"

//私钥的密码
static NSString * pwd = @"0";

@implementation KIRSA

+(NSString *)encryptString:(NSString *)originalString{
    
    if (!originalString)
        return nil;
    SecKeyRef publicKey = [self getPublicKeyRef];
    size_t cipherBufferSize = SecKeyGetBlockSize(publicKey);
    uint8_t *cipherBuffer = malloc(cipherBufferSize);
    uint8_t *nonce = (uint8_t *) [originalString UTF8String];
    
    SecKeyEncrypt(publicKey,
                  kSecPaddingPKCS1,
                  nonce,
                  strlen((char *) nonce),
                  &cipherBuffer[0],
                  &cipherBufferSize);
    NSData *encryptedData = [NSData dataWithBytes:cipherBuffer length:cipherBufferSize];
    free(cipherBuffer);
    
    return [encryptedData base64EncodedStringWithOptions:0];
    
}

+(NSString *)decryptString:(NSString *)ciphertextString{
    
    if (!ciphertextString)
        return nil;
    
    SecKeyRef privateKey = [self getPrivateKeyRef];
    size_t plainBufferSize = SecKeyGetBlockSize(privateKey);
    uint8_t *plainBuffer = malloc(plainBufferSize);
    
    
    NSData *incomingData = [[NSData alloc] initWithBase64EncodedString:ciphertextString options:NSDataBase64DecodingIgnoreUnknownCharacters];
    uint8_t *cipherBuffer = (uint8_t *) [incomingData bytes];
    size_t cipherBufferSize = SecKeyGetBlockSize(privateKey);
    SecKeyDecrypt(privateKey,
                  kSecPaddingPKCS1,
                  cipherBuffer,
                  cipherBufferSize,
                  plainBuffer,
                  &plainBufferSize);
    NSData *decryptedData = [NSData dataWithBytes:plainBuffer length:plainBufferSize];
    NSString *originalString = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
    [incomingData release];
    free(plainBuffer);
    return originalString;
;
    
}

//获取公钥

+(SecKeyRef)getPublicKeyRef{
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"publickey.der" ofType:nil];
    NSData *certData = [NSData dataWithContentsOfFile:path];
    
    if (!certData) {
        return nil;
    }
    
    SecCertificateRef cert = SecCertificateCreateWithData(NULL, (CFDataRef)certData);
    
    SecKeyRef publicKey = NULL;
    SecTrustRef trust = NULL;
    SecPolicyRef policy = NULL;
    
    if (cert != NULL) {
        policy = SecPolicyCreateBasicX509();
        if (policy) {
            if (SecTrustCreateWithCertificates((CFTypeRef)cert, policy, &trust) == noErr) {
                SecTrustResultType result;
                if (SecTrustEvaluate(trust, &result) == noErr) {
                    publicKey = SecTrustCopyPublicKey(trust);
                }
            }
        }
    }
    
    if (policy) CFRelease(policy);
    if (trust) CFRelease(trust);
    if (cert) CFRelease(cert);
    
    return publicKey;
}


//获取私钥
+(SecKeyRef)getPrivateKeyRef{
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"privatekey.p12" ofType:nil];
    NSData *p12Data = [NSData dataWithContentsOfFile:path];
    
    NSMutableDictionary * options = [[NSMutableDictionary alloc] init];
    
    SecKeyRef privateKeyRef = NULL;
    
    //这里的密码改成实际私钥的密码
    [options setObject:pwd forKey:(__bridge id)kSecImportExportPassphrase];
    
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    
    OSStatus securityError = SecPKCS12Import((__bridge CFDataRef) p12Data,
                                             (__bridge CFDictionaryRef)options, &items);
    
    if (securityError == noErr && CFArrayGetCount(items) > 0) {
        CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
        SecIdentityRef identityApp =
        (SecIdentityRef)CFDictionaryGetValue(identityDict,
                                             kSecImportItemIdentity);
        
        securityError = SecIdentityCopyPrivateKey(identityApp, &privateKeyRef);
        if (securityError != noErr) {
            privateKeyRef = NULL;
        }
    }
    CFRelease(items);
    [options release];
    return privateKeyRef;
}

@end
