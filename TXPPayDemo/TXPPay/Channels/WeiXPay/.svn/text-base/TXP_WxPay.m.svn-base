//
//  TXP_WxPay.m
//  TXPPayDemo
//
//  Created by tianxiuping on 2017/10/30.
//  Copyright © 2017年 TXP. All rights reserved.
//

#import "TXP_WxPay.h"
#import "WXApi.h"
#import "TXP_PayErrorUtils.h"
#define STR_PAY_SUCCESS @"支付成功!"
@interface TXP_WxPay ()<WXApiDelegate>

@property (nonatomic) TXP_PayComplation complation;

@end
@implementation TXP_WxPay

- (instancetype)init{
    self = [super init];
    if (self) {
        BOOL isSuccess = [WXApi registerApp:@"这里填写注册key"];
        if (isSuccess) {
            NSLog(@"注册成功！");
        }
    }
    return self;
}

//业务方法一：需要调用微信支付接口(唤醒微信支付)
-(void)payWithCharge:(TXP_Charge*)charge controller:(UIViewController*)controller scheme:(NSString*)scheme withComplation:(TXP_PayComplation)complation{
    _complation = complation;
    NSString* timeStamp = [NSString stringWithFormat:@"%@",[charge.credential objectForKey:@"timestamp"]];
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = [charge.credential objectForKey:@"partnerid"];
    request.prepayId= [charge.credential objectForKey:@"prepayid"];
    request.package = @"Sign=WXPay";
    request.nonceStr= [charge.credential objectForKey:@"noncestr"];
    request.timeStamp= [timeStamp intValue];
    request.sign= [charge.credential objectForKey:@"sign"];
    [WXApi sendReq:request];
}

//业务方法二：需要处理支付结果回调(9.0以前回调)
- (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication withComplation:(TXP_PayComplation)complation{
    if (complation) {
        _complation = complation;
    }
    return [WXApi handleOpenURL:url delegate:self];
}

//业务方法三：需要处理支付结果回调(9.0以后回调)
- (BOOL)handleOpenURL:(NSURL *)url withComplation:(TXP_PayComplation)complation{
    return [self handleOpenURL:url sourceApplication:nil withComplation:complation];
}

-(void)onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:
                _complation(STR_PAY_SUCCESS,nil);
                break;
            case WXErrCodeCommon:
                _complation(nil,[TXP_PayErrorUtils create:TXP_PayErrorUnknownError]);
                break;
            case WXErrCodeUserCancel:
                _complation(nil,[TXP_PayErrorUtils create:TXP_PayErrorCancelled]);
                break;
            default:
                _complation(nil,[TXP_PayErrorUtils create:TXP_PayErrorCancelled]);
                break;
        }
    }
}

@end
