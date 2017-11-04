//
//  TXP_PayError.m
//  TXPPayDemo
//
//  Created by tianxiuping on 2017/10/30.
//  Copyright © 2017年 TXP. All rights reserved.
//

#import "TXP_PayError.h"

@interface TXP_PayError ()

@property (nonatomic) NSMutableDictionary* errorDic;

@end
@implementation TXP_PayError

- (instancetype)init{
    self = [super init];
    if (self) {
        //初始化异常信息
        //注册异常信息(配置文件)
        _errorDic = [[NSMutableDictionary alloc] init];
        [_errorDic setValue:@"取消支付" forKey:[[NSString alloc] initWithFormat:@"%lu",(unsigned long)TXP_PayErrorCancelled]];
        [_errorDic setValue:@"没有这个支付渠道" forKey:[[NSString alloc] initWithFormat:@"%lu",(unsigned long)TXP_PayErrorInvalidChannel]];
        [_errorDic setValue:@"ViewController不能为空" forKey:[[NSString alloc] initWithFormat:@"%lu",(unsigned long)TXP_PayErrorViewControllerIsNil]];
        [_errorDic setValue:@"链接异常" forKey:[[NSString alloc] initWithFormat:@"%lu",(unsigned long)TXP_PayErrorConnectionError]];
        [_errorDic setValue:@"未知异常" forKey:[[NSString alloc] initWithFormat:@"%lu",(unsigned long)TXP_PayErrorUnknownError]];
        [_errorDic setValue:@"请求超时" forKey:[[NSString alloc] initWithFormat:@"%lu",(unsigned long)TXP_PayErrorRequestTimeOut]];
        
        //新增异常
        [_errorDic setValue:@"请求安装微信APP" forKey:[[NSString alloc] initWithFormat:@"%lu",(unsigned long)TXP_PayErrorWxNoInstalled]];
        [_errorDic setValue:@"调起支付控件失败" forKey:[[NSString alloc] initWithFormat:@"%lu",(unsigned long)TXP_PayErrorActivation]];
        [_errorDic setValue:@"验证支付凭证失败" forKey:[[NSString alloc] initWithFormat:@"%lu",(unsigned long)TXP_PayErrorInvalidCredential]];
    }
    return self;
}

-(NSString*)getMsg{
    return [_errorDic objectForKey:[[NSString alloc] initWithFormat:@"%lu",(unsigned long)_errorOption]];
}
@end
