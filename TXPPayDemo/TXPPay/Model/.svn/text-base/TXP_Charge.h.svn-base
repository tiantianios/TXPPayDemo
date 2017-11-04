//
//  TXP_Charge.h
//  TXPPayDemo
//
//  Created by tianxiuping on 2017/10/30.
//  Copyright © 2017年 TXP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXP_Charge : NSObject
//共性问题
// id唯一标示
@property (nonatomic,strong) NSString* chargeId;
// 支付创建时间
// 注意：时间戳
@property (nonatomic,strong) NSString* created;
// 支付使用的第三方支付渠道
@property (nonatomic,strong) NSString* channel;
// 商户订单号，适配每个渠道对此参数的要求，必须在商户系统内唯一
// alipay: 1-64位
// wx: 2-32位
@property (nonatomic,strong) NSString* orderNo;
// 发起支付请求客户端的 IP 地址，
// 格式为IPv4整型，
// 例如:192.168.0.1
@property (nonatomic,strong) NSString* clientIP;
// 订单总金额（必须大于0）
// 单位为对应币种的最小货币单位，人民币单位：分
// 例如：订单总金额为1元，那么amount = 100
@property (nonatomic,strong) NSString* amount;
// 商品标题:该参数最长为32个Unicode字符
// 银联全渠道(upacp/upacp_wap)限制在32个字节
@property (nonatomic,strong) NSString* subject;
// 商品描述信息:该参数最长为128个Unicode字符
@property (nonatomic,strong) NSString* body;
// 订单的错误码
@property (nonatomic,strong) NSString* failCode;
// 订单的错误消息的描述
@property (nonatomic,strong) NSString* failMsg;

//差异问题
// 支付凭证，用于客户端发起支付
@property (nonatomic,strong) NSDictionary* credential;
@end
