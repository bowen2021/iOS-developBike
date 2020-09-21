//
//  EBBTDataModel.m
//  EBike
//
//  Created by 刘佳斌 on 2019/3/5.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#import "EBBTDataModel.h"

@implementation EBBTDataModel


/**
字节2第8bit 电池锁状态 0锁定 1打开
*/
- (void)setBatteryLockStatus:(NSString *)batteryLockStatus{
    _batteryLockStatus =  batteryLockStatus;
}

- (NSString *)getBatteryLockStatus{
    return _batteryLockStatus;
}

/**
 字节2第7bit  单位转换状态   // 0 km  1 mile 1mile = 1.609km
 */
- (void)setKmMileType:(NSString *)kmMileType{
    _kmMileType = kmMileType;
}
- (NSString *)getKmMileType{
    return _kmMileType;
}

///**
// 字节2第6bit 推行开关 0 是 1 否
// */
- (void)setPushStatus:(NSString *)pushStatus{
    _pushStatus = pushStatus;
}
- (NSString *)getPushStatus{
    return _pushStatus;
}
///**
// 字节2第5bit 大灯 0熄灭 1点亮
// */
- (void)setLightStatus:(NSString *)lightStatus{
    _lightStatus = lightStatus;
}
- (NSString *)getLightStatus{
    return _lightStatus;
}

///**
// 字节2 低四位 0空档 最高9档 15代表WALK档 6km推行 APP上显示P。
// */
- (void)setGearPosition:(NSInteger)gearPosition{
    _gearPosition = gearPosition;
}
- (NSInteger)getGearPosition{
    return _gearPosition;
}
///**
// 字节3 当前总档位
// */
- (void)setCurrentGear:(NSInteger)currentGear{
    _currentGear = currentGear;
}
- (NSInteger)getCurrentGear{
    return _currentGear;
}
///**
// 字节4-5 字节4为低速度 字节5高速度 速度= 字节5*256+字节4 单位是0.1km/h
// */
- (void)setSpeed:(NSString *)speed{
    _speed = speed;
}
- (NSString *)getSpeed{
    return _speed;
}
///**
// 字节6-7 当次里程=字节7*256+字节6
// */
- (void)setTrip:(NSString *)Trip{
    _Trip = Trip;
}
- (NSString *)getTrip{
    return _Trip;
}
///**
// 字节8-10 累计里程=字节10*256+字节9*256+字节8
// */
- (void)setODO:(NSString *)ODO{
    _ODO = ODO;
}
- (NSString *)getODO{
    return _ODO;
}
////错误码 11字节
//
///**
// 字节12-13 实时电流 单位mA
// */
- (void)setElectricCurrent:(NSString *)electricCurrent{
    _electricCurrent = electricCurrent;
}
- (NSString *)getElectricCurrent{
    return _electricCurrent;
}
///**
// 字节14-15 电池组内部温度 单位为华氏 需转换 (电池内部温度-2731)/10 度
// */
- (void)setBatteryTemperature:(NSString *)batteryTemperature{
    _batteryTemperature = batteryTemperature;
}
- (NSString *)getBatteryTemperature{
    return _batteryTemperature;
}

///**
// 字节16-17 电压总电压 单位mV
// */
- (void)setTotalVoltage:(NSString *)totalVoltage{
    _totalVoltage = totalVoltage;
}
- (NSString *)getTotalVoltage{
    return _totalVoltage;
}
///**
// 字节18 相对容量百分比 范围0-100
// */
- (void)setRelativeCapacity:(NSString *)relativeCapacity{
    _relativeCapacity = relativeCapacity;
}
- (NSString *)getRelativeCapacity{
    return _relativeCapacity;
}
///**
// 字节19 绝对容量百分比 范围0-100
// */
- (void)setAbsoluteCapacity:(NSString *)absoluteCapacity{
    _absoluteCapacity = absoluteCapacity;
}
- (NSString *)getAbsoluteCapacity{
    return _absoluteCapacity;
}
///**
// 字节20-21 剩余容量
// */
- (void)setRemaingCapacity:(NSString *)remaingCapacity{
    _remaingCapacity = remaingCapacity;
}
- (NSString *)getRemaingCapacity{
    return _remaingCapacity;
}
///**
// 字节22-23 满电容量
// */
- (void)setFullPower:(NSString *)fullPower{
    _fullPower = fullPower;
}
- (NSString *)getFullPower{
    return _fullPower;
}
///**
// 字节24-25 循环次数
// */
- (void)setCycles:(NSString *)cycles{
    _cycles = cycles;
}
- (NSString *)getCycles{
    return _cycles;
}
///**
// 字节26 电池信息解析权限 为0xAA是解析battery栏信息，否则不解析
// */
- (void)setBatteryInfoPermission:(NSString *)batteryInfoPermission{
    _batteryInfoPermission = batteryInfoPermission;
}
- (NSString *)getBatteryInfoPermission{
    return _batteryInfoPermission;
}
///*
// 字节27 28保留
// */
//
///**
// 字节29-31 最大充电间隔时间
// */
- (void)setChargInterval:(NSString *)chargInterval{
    _chargInterval = chargInterval;
}
- (NSString *)getChargInterval{
    return _chargInterval;
}
//
///**
// 字节32-33 剩余里程 km
// */
- (void)setRemainMileage:(NSString *)remainMileage{
    _remainMileage = remainMileage;
}
- (NSString *)getRemainMileage{
    return _remainMileage;
}
///**
// 字节34-35 卡路里 范围0~65535，单位为仟卡(Kcal)
// */
- (void)setCal:(NSString *)cal{
    _cal = cal;
}
- (NSString *)getCal{
    return _cal;
}
///**
// 字节36-37 踏频
// */
- (void)setCadence:(NSString *)cadence{
    _cadence = cadence;
}
- (NSString *)getCadence{
    return _cadence;
}
///**
// 字节38-39 力矩
// */
- (void)setTorque:(NSString *)torque{
    _torque = torque;
}
- (NSString *)getTorque{
    return _torque;
}
///**
// 字节40-41 扭力信号
// */
- (void)setTorsion:(NSString *)torsion{
    _torsion = torsion;
}
- (NSString *)getTorsion{
    return _torsion;
}
///**
// 字节42 力矩最大值
// */
- (void)setTorqueMAX:(NSString *)torqueMAX{
    _torqueMAX = torqueMAX;
}
- (NSString *)getTorqueMAX{
    return _torqueMAX;
}
///**
// 字节43 当前电量百分比
// */
- (void)setBatteryPower:(NSString *)batteryPower{
    _batteryPower = batteryPower;
}
- (NSString *)getBatteryPower{
    return _batteryPower;
}
///**
// 字节44 wheel 轮径值 范围5-35
// */
- (void)setWheel:(NSString *)wheel{
    _wheel = wheel;
}
- (NSString *)getWheel{
    return _wheel;
}
///**
// 字节45 最大速度数据 范围5-100
// */
- (void)setMaxSpeed:(NSString *)maxSpeed{
    _maxSpeed = maxSpeed;
}
- (NSString *)getMaxSpeed{
    return _maxSpeed;
}
@end
