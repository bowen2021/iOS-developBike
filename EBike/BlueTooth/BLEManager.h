//
//  BLEManager.h
//  Root
//
//  Created by apple on 2018/9/10.
//  Copyright © 2018年 com.GooHarbour. All rights reserved.
//

#import <Foundation/Foundation.h>

// 通知服务
static NSString * const kNotifyServerUUID = @"FA00";
// 写服务
static NSString * const kWriteServerUUID = @"180A";
// 通知特征值
static NSString * const kNotifyCharacteristicUUID = @"FA01";
// 写特征值
static NSString * const kWriteCharacteristicUUID = @"FA02";


@protocol BLE_ConnectDelegate <NSObject>

- (void)onConnectResult:(CBPeripheral *)peripheral isSuccess:(BOOL)isSuccess;

- (void)onSendResult:(NSString *)result;

@end


@interface BLEManager : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>


+(BLEManager*)shareManager;

@property (nonatomic, weak)id <BLE_ConnectDelegate> bleConnectDelegate;

-(void)sendData:(NSData *)data complete:(void (^)(NSString*content))complete;
-(void)sendData:(NSData *)data isWrite:(BOOL)isWrite;
-(void)connectPeripheral:(CBPeripheral*)peripheral complete:(void(^)(CBPeripheral*peripheral,BOOL success))complete;

- (void)didConnecPeripheral:(CBPeripheral*)peripheral;
- (void)didConnecPeripheral:(CBPeripheral*)peripheral timer:(int)timer;
// 扫描设备
- (void)scanForPeripheral:(NSString*)device completeBlock:(void(^)(CBPeripheral*peripheral))complete;


-(void)disConnect;
- (void)disConnect:(BOOL)isManual;
- (void)removeTimer;

-(void)scanForDevicesWithAllBlock:(void (^)(CBPeripheral*))complete;
-(void)scanForDevicesWithAllBlocks:(void (^)(CBPeripheral *peripheral,NSNumber *RSSI,NSString *mac))complete;
- (NSNumber *) changenumberHexString:(NSString *)aHexString;

- (void)updatedata;

- (void)didStopScan;

@end
