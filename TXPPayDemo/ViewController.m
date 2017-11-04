//
//  ViewController.m
//  TXPPayDemo
//
//  Created by tianxiuping on 2017/11/2.
//  Copyright © 2017年 TXP. All rights reserved.
//

#import "ViewController.h"
#import "TXP_PayEngine.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     ViewController * __weak weakSelf = self;
    TXP_Charge *charge = [[TXP_Charge alloc]init];
    charge.channel = PAY_ALIPAY;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
