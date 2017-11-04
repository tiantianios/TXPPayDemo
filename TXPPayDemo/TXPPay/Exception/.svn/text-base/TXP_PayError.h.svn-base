//
//  TXP_PayError.h
//  TXPPayDemo
//
//  Created by tianxiuping on 2017/10/30.
//  Copyright © 2017年 TXP. All rights reserved.
//

#import <Foundation/Foundation.h>
//定义枚举
typedef NS_ENUM(NSUInteger,TXP_PayErrorOption){
    //渠道验证
    TXP_PayErrorInvalidChannel,
    //取消支付
    TXP_PayErrorCancelled,
    //Controller不能为空
    TXP_PayErrorViewControllerIsNil,
    //连接异常
    TXP_PayErrorConnectionError,
    //未知异常
    TXP_PayErrorUnknownError,
    //请求超时
    TXP_PayErrorRequestTimeOut,
    //新增异常(是否安装了微信：给童鞋们课后实现)
    //没有安装微信APP
    TXP_PayErrorWxNoInstalled,
    //调起支付失败
    TXP_PayErrorActivation,
    //验证支付凭证失败
    TXP_PayErrorInvalidCredential,
    //如果你还有其他的异常同学们可以自己新增(扩展、完善框架)
    
};
@interface TXP_PayError : NSObject

@property (nonatomic,assign) TXP_PayErrorOption errorOption;

//异常信息
-(NSString*)getMsg;

@end
