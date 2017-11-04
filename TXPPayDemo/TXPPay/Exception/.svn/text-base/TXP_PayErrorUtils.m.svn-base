//
//  TXP_PayErrorUtils.m
//  TXPPayDemo
//
//  Created by tianxiuping on 2017/10/30.
//  Copyright © 2017年 TXP. All rights reserved.
//

#import "TXP_PayErrorUtils.h"

@implementation TXP_PayErrorUtils

+(TXP_PayError*)create:(TXP_PayErrorOption)code{
    TXP_PayError* error = [[TXP_PayError alloc] init];
    error.errorOption = code;
    return error;
}

//验证支付对象
+(BOOL)invalidCharge:(TXP_Charge*)charge withComplation:(TXP_PayComplation)complation{
    if ([charge.failCode isEqualToString:@"1"]) {
        complation(nil,[TXP_PayErrorUtils create:TXP_PayErrorInvalidCredential]);
        return NO;
    }else if([charge.failCode isEqualToString:@"2"]) {
        complation(nil,[TXP_PayErrorUtils create:TXP_PayErrorInvalidCredential]);
        return NO;
    }else if([charge.failCode isEqualToString:@"11"]) {
        complation(nil,[TXP_PayErrorUtils create:TXP_PayErrorInvalidCredential]);
        return NO;
    }
    if (charge.credential == nil) {
        complation(nil,[TXP_PayErrorUtils create:TXP_PayErrorInvalidCredential]);
        return NO;
    }
    return YES;
}


@end
