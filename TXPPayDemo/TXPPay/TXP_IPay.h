//
//  TXP_IPay.h
//  TXPPayDemo
//
//  Created by tianxiuping on 2017/10/30.
//  Copyright © 2017年 TXP. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "TXP_Charge.h"
#import "TXP_PayComplation.h"
//代理模式->目标接口：支付接口
@protocol TXP_IPay <NSObject>


-(void)payWithCharge:(TXP_Charge*)charge controller:(UIViewController*)controller scheme:(NSString*)scheme withComplation:(TXP_PayComplation)complation;

//业务方法二：需要处理支付结果回调(9.0以前回调)
- (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication withComplation:(TXP_PayComplation)complation;

//业务方法三：需要处理支付结果回调(9.0以后回调)
- (BOOL)handleOpenURL:(NSURL *)url withComplation:(TXP_PayComplation)complation;

@end
