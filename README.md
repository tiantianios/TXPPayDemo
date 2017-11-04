# TXPPayDemo
集成（支付宝、微信、银联）支付封装<br>
## 开发环境
1、xcode 8以上<br>
2、iOS 7.0以上<br>
## 支付SDK的集成
        这里就不多说了，网上一大把教程
## 工程目录结构
![](http://img.blog.csdn.net/20171104092543547?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvdGlhbnRpYW5pb3M=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)
## 依赖库目录
![](http://img.blog.csdn.net/20171104092622191?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvdGlhbnRpYW5pb3M=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)
## 工厂模式
### 1、代理统一抽象接口
                #import <UIKit/UIKit.h>
                #import "TXP_Charge.h"
                #import "TXP_PayComplation.h"
                //代理模式->目标接口：支付接口
                @protocol TXP_IPay <NSObject>

                -(void)payWithCharge:(TXP_Charge*)charge controller:(UIViewController*)controller scheme:(NSString*)scheme withComplation:              (TXP_PayComplation)complation;

                //业务方法二：需要处理支付结果回调(9.0以前回调)
                - (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication withComplation:(TXP_PayComplation)complation;

                //业务方法三：需要处理支付结果回调(9.0以后回调)
                - (BOOL)handleOpenURL:(NSURL *)url withComplation:(TXP_PayComplation)complation;

                @end

### 2、支付宝具体实现类（需要遵守自己TXP_IPay的抽象协议）
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

3、微信具体实现类（需要遵守自己TXP_IPay的抽象协议）
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

4、银联具体实现类（需要遵守自己TXP_IPay的抽象协议）
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
#单例模式调用方法类
+(instancetype)sharedEngine{
    static TXP_PayEngine* payEngine;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        payEngine = [[self alloc] init];
    });
    return payEngine;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self registerChannel];
    }
    return self;
}

//注册支付渠道
-(void)registerChannel{

    _channelDic = @{PAY_UNIONPAY : [[TXP_UnionPay alloc] init],
                    PAY_WXPAY : [[TXP_WxPay alloc] init],
                    PAY_ALIPAY: [[TXP_ALiPay alloc]init]
                    };
}

//处理支付
-(void)payWithCharge:(TXP_Charge*)charge controller:(UIViewController*)controller scheme:(NSString*)scheme withComplation:(TXP_PayComplation)complation{
    
    //验证Controller是否为空
    if (controller == nil) {
        complation(nil,[TXP_PayErrorUtils create:TXP_PayErrorViewControllerIsNil]);
        return;
    }
    
    _channel = charge.channel;
   
    id<TXP_IPay> pay = [_channelDic objectForKey:charge.channel];
    if (pay == nil) {
        complation(nil,[TXP_PayErrorUtils create:TXP_PayErrorInvalidChannel]);
        return;
    }
    
    [pay payWithCharge:charge controller:controller scheme:scheme withComplation:complation];
}

//处理回调
- (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication withComplation:(TXP_PayComplation)complation{
    return [[_channelDic objectForKey:_channel] handleOpenURL:url sourceApplication:sourceApplication withComplation:complation];;
}

- (BOOL)handleOpenURL:(NSURL *)url withComplation:(TXP_PayComplation)complation{
    return [[_channelDic objectForKey:_channel] handleOpenURL:url sourceApplication:nil withComplation:complation];
}

调用测试
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     ViewController * __weak weakSelf = self;
    TXP_Charge *charge = [[TXP_Charge alloc]init];//此model配置从服务器获得的参数
    charge.channel = PAY_ALIPAY; //支付类型
    [[TXP_PayEngine sharedEngine] payWithCharge:charge controller:weakSelf scheme:@"TXPPayDemo" withComplation:^(NSString *result, TXP_PayError *error) {
        //回调
        if (error) {
            //出现了异常
            NSLog(@"%@",[error getMsg]);
        }else{
            //支付成功
            NSLog(@"支付成功!");
        }
    }];
}

AppDelegate里
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
   
    return [[TXP_PayEngine sharedEngine] handleOpenURL:url withComplation:nil];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[TXP_PayEngine sharedEngine] handleOpenURL:url withComplation:nil];
}
