//
//  EBUserTool.m
//  EBike
//
//  Created by 刘佳斌 on 2019/2/22.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#import "EBUserTool.h"

//密码
#define kUserPassword               @"kUserPassword"
#define kUserPasswordLevel          @"kUserPasswordLevel"
#define kUserIsLogin                @"kUserIsLogin"
#define kBleName                    @"BleName"
#define kCurCharacter               @"kCurCharacter"
#define kCurPeripheral              @"kCurPeripheral"
#define kBTDataModel                @"kBTDataModel"
#define kBLEMac                     @"kBLEMac"
#define kBLEAuto                    @"kBLEAuto"

@implementation EBUserTool

/**
 是否登陆
 
 @param value YES/NO
 */
+ (void)setLogin:(BOOL)value {
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:kUserIsLogin];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL)isLogin {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kUserIsLogin];
}

/**
 用户密码
 */
+ (void)setUserPassword:(NSString *)value{
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:kUserPassword];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getUserPassword{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kUserPassword];
}

/**
 用户密码级别
 */
+ (void)setUserPasswordLevel:(NSString *)value{
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:kUserPasswordLevel];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getUserPasswordLevel{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kUserPasswordLevel];
}

/**
 保存蓝牙名称
 @param value 蓝牙名称
 */
+ (void)setBLEName:(NSString *)value{
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:kBleName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getBLEName{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kBleName];
}

+ (void)setBLEData:(EBBTDataModel *)value{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:kBTDataModel];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (EBBTDataModel *)getBLEData{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kBTDataModel];
}

/*
 蓝牙mac地址
 */
+ (void)setBLEMac:(NSString *)value{
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:kBLEMac];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getBLEMac{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kBLEMac];
}


+ (void)clearData{
    [self setBLEName:@"Name"];
}

@end
