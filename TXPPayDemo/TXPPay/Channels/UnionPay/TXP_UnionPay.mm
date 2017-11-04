//
//  TXP_UnionPay.m
//  TXPPayDemo
//
//  Created by tianxiuping on 2017/10/30.
//  Copyright © 2017年 TXP. All rights reserved.
//

#import "TXP_UnionPay.h"
#import "UPPaymentControl.h"
#import "TXP_PayErrorUtils.h"
#define STR_PAY_SUCCESS @"支付成功!"
@interface TXP_UnionPay ()

@property (nonatomic) TXP_PayComplation complation;

@end

@implementation TXP_UnionPay

//业务方法一：需要调用银联支付接口(唤醒银联支付)
//银联支付请求处理
- (void)payWithCharge:(TXP_Charge*)charge controller:(UIViewController *)controller scheme:(NSString *)scheme withComplation:(TXP_PayComplation)complation{
    
    _complation = complation;
    dispatch_sync(dispatch_get_main_queue(), ^{
        //需要支付凭证
        NSString* tn = [charge.credential objectForKey:@"tn"];
        NSString* unionPaymode = [charge.credential objectForKey:@"mode"];
        BOOL isSuccess = [[UPPaymentControl defaultControl] startPay:tn fromScheme:scheme mode:unionPaymode viewController:controller];
        if (!isSuccess) {
            _complation(nil,[TXP_PayErrorUtils create:TXP_PayErrorActivation]);
        }
    });
}

//银联支付回调
//业务方法二：需要处理支付结果回调(9.0以前回调)
- (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication withComplation:(TXP_PayComplation)complation{
    if (complation) {
        _complation = complation;
    }
    [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
        if([code isEqualToString:@"success"]) {
            //结果code为成功时，去商户后台查询一下确保交易是成功的再展示成功
            complation(STR_PAY_SUCCESS,nil);
        }else if([code isEqualToString:@"fail"]) {
            //交易失败
            complation(nil,[TXP_PayErrorUtils create:TXP_PayErrorUnknownError]);
        }else if([code isEqualToString:@"cancel"]) {
            //交易取消
            complation(nil,[TXP_PayErrorUtils create:TXP_PayErrorCancelled]);
        }
    }];
    return YES;
}

//业务方法三：需要处理支付结果回调(9.0以后回调)
- (BOOL)handleOpenURL:(NSURL *)url withComplation:(TXP_PayComplation)complation{
    
    return [self handleOpenURL:url sourceApplication:nil withComplation:complation];
}
@end
