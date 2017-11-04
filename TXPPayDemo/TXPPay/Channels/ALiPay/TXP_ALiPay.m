//
//  TXP_ALiPay.m
//  搭搭手
//
//  Created by tianxiuping on 2017/10/31.
//  Copyright © 2017年 nieguizhi. All rights reserved.
//

#import "TXP_ALiPay.h"
#import "UPPaymentControl.h"
#import "TXP_PayErrorUtils.h"
#import <AlipaySDK/AlipaySDK.h>
#define STR_PAY_SUCCESS @"支付成功!"
@interface TXP_ALiPay ()

@property (nonatomic) TXP_PayComplation complation;

@end
@implementation TXP_ALiPay
- (instancetype)init{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)payWithCharge:(TXP_Charge*)charge controller:(UIViewController *)controller scheme:(NSString *)scheme withComplation:(TXP_PayComplation)complation{
    
    if (complation) {
        _complation = complation;
    }

    [[AlipaySDK defaultService] payOrder:charge.orderNo fromScheme:scheme callback:^(NSDictionary *resultDic) {
        NSString * state = [NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]];
        if ([state isEqualToString:@"9000"]) {
           _complation(STR_PAY_SUCCESS,nil);
        }
        else if ([state isEqualToString:@"6001"])
        {
             _complation(nil,[TXP_PayErrorUtils create:TXP_PayErrorActivation]);
            
        }else
        {
            _complation(nil,[TXP_PayErrorUtils create:TXP_PayErrorActivation]);
        }
    }];
}

//业务方法二：需要处理支付结果回调(9.0以前回调)
- (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication withComplation:(TXP_PayComplation)complation{
    if (complation) {
        _complation = complation;
    }
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //            NSLog(@"result = %@",resultDic);
            NSString * state = [NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]];
            if ([state isEqualToString:@"9000"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"judgePayStatu" object:self];
            }  else if ([state isEqualToString:@"6001"]){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelPayment" object:self];
            }
        }];
    }
    return YES;
}

//业务方法三：需要处理支付结果回调(9.0以后回调)
- (BOOL)handleOpenURL:(NSURL *)url withComplation:(TXP_PayComplation)complation{
    
    return [self handleOpenURL:url sourceApplication:nil withComplation:complation];
}
@end
