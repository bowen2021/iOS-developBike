//
//  EBUserTool.h
//  EBike
//
//  Created by 刘佳斌 on 2019/2/22.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EBBTDataModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface EBUserTool : NSObject

/**
 是否是第一次启动
 
 @param value YES/NO
 */
+ (void)setLogin:(BOOL)value;
+ (BOOL)isLogin;


/**
 保存密码
 @param value 密码状态
 */
+ (void)setUserPassword:(NSString *)value;
+ (NSString *)getUserPassword;


/**
 保存密码级别
 @param value 密码级别
 */
+ (void)setUserPasswordLevel:(NSString *)value;
+ (NSString *)getUserPasswordLevel;

/**
 保存蓝牙名称
 @param value 蓝牙名称
 */
+ (void)setBLEName:(NSString *)value;
+ (NSString *)getBLEName;

/**
 保存蓝牙名称
 @param value 蓝牙名称
 */
+ (void)setBLEData:(EBBTDataModel *)value;
+ (EBBTDataModel *)getBLEData;


/*
 蓝牙mac地址
 */
+ (void)setBLEMac:(NSString *)value;
+ (NSString *)getBLEMac;

+ (void)clearData;

@end

NS_ASSUME_NONNULL_END
