//
//  EBBTDataModel.h
//  EBike
//
//  Created by 刘佳斌 on 2019/3/5.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface EBBTDataModel : NSObject
/**
 字节2第8bit 电池锁状态 0锁定 1打开
 */
@property(nonatomic, copy)NSString *batteryLockStatus;
/**
 字节2第7bit  单位转换状态   // 0 km  1 mile 1mile = 1.609km
 */
@property(nonatomic, copy)NSString *kmMileType;        //
/**
 字节2第6bit 推行开关 0 是 1 否
 */
@property(nonatomic, copy)NSString *pushStatus;
/**
 字节2第5bit 大灯 0熄灭 1点亮
 */
@property(nonatomic, copy)NSString *lightStatus;
/**
 字节2 低四位 0空档 最高9档 15代表WALK档 6km推行 APP上显示P。
 */
@property(nonatomic, assign)NSInteger gearPosition;
/**
 字节3 当前总档位
 */
@property(nonatomic, assign)NSInteger currentGear;
/**
 字节4-5 字节4为低速度 字节5高速度 速度= 字节5*256+字节4 单位是0.1km/h
 */
@property(nonatomic, copy)NSString *speed;
/**
 字节6-7 当次里程=字节7*256+字节6
 */
@property(nonatomic, copy)NSString *Trip;
/**
 字节8-10 累计里程=字节10*256+字节9*256+字节8
 */
@property(nonatomic, copy)NSString *ODO;
//错误码 11字节
@property(nonatomic,copy)NSString *errorCode;
/**
 字节12-13 实时电流 单位mA
 */
@property(nonatomic, copy)NSString *electricCurrent;
/**
 字节14-15 电池组内部温度 单位为华氏 需转换 (电池内部温度-2731)/10 度
 */
@property(nonatomic, copy)NSString *batteryTemperature;
/**
 字节16-17 电压总电压 单位mV
 */
@property(nonatomic, copy)NSString *totalVoltage;
/**
 字节18 相对容量百分比 范围0-100
 */
@property(nonatomic, copy)NSString *relativeCapacity;
/**
 字节19 绝对容量百分比 范围0-100
 */
@property(nonatomic, copy)NSString *absoluteCapacity;
/**
 字节20-21 剩余容量
 */
@property(nonatomic, copy)NSString *remaingCapacity;
/**
 字节22-23 满电容量
 */
@property(nonatomic, copy)NSString *fullPower;
/**
 字节24-25 循环次数
 */
@property(nonatomic, copy)NSString *cycles;
/**
 字节26 电池信息解析权限 为0xAA是解析battery栏信息，否则不解析 1=解析 0=不解析
 */
@property(nonatomic, copy)NSString *batteryInfoPermission;
/*
 字节27 28保留
 */

/**
 字节29-31 最大充电间隔时间
 */
@property(nonatomic, copy)NSString *chargInterval;

/**
 字节32-33 剩余里程 km
 */
@property(nonatomic, copy)NSString *remainMileage;
/**
 字节34-35 卡路里 范围0~65535，单位为仟卡(Kcal)
 */
@property(nonatomic, copy)NSString *cal;
/**
 字节36-37 踏频
 */
@property(nonatomic, copy)NSString *cadence;
/**
 字节38-39 力矩
 */
@property(nonatomic, copy)NSString *torque;
/**
 字节40-41 扭力信号
 */
@property(nonatomic, copy)NSString *torsion;
/**
 字节42 力矩最大值
 */
@property(nonatomic, copy)NSString *torqueMAX;
/**
 字节43 当前电量百分比
 */
@property(nonatomic, copy)NSString *batteryPower;
/**
 字节44 wheel 轮径值 范围5-35
 */
@property(nonatomic, copy)NSString *wheel;
/**
 字节45 最大速度数据 范围5-100
 */
@property(nonatomic, copy)NSString *maxSpeed;


@end

NS_ASSUME_NONNULL_END

