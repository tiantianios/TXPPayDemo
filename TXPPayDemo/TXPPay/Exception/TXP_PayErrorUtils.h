//
//  TXP_PayErrorUtils.h
//  TXPPayDemo
//
//  Created by tianxiuping on 2017/10/30.
//  Copyright © 2017年 TXP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXP_PayError.h"
#import "TXP_PayComplation.h"
#import "TXP_Charge.h"
@interface TXP_PayErrorUtils : NSObject

+(TXP_PayError*)create:(TXP_PayErrorOption)code;

+(BOOL)invalidCharge:(TXP_Charge*)charge withComplation:(TXP_PayComplation)complation;

@end
