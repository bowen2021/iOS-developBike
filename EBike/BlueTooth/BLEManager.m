//
//  BLEManager.m
//  Root
//
//  Created by apple on 2018/9/10.
//  Copyright © 2018年 com.GooHarbour. All rights reserved.
//

#import "BLEManager.h"
//#import "WaringAlertView.h"

static BLEManager * bleManager;


@interface BLEManager ()
{
    NSTimer *connectTimer;
}

@property (nonatomic,copy)NSString * deviceName;
@property (nonatomic,copy)void(^sendComplete)(NSString*content);
@property (nonatomic,copy)void(^scanBlock)(CBPeripheral*peripherals);
@property (nonatomic,copy)void(^scanAllBlock)(CBPeripheral*peripherals);
@property (nonatomic,copy)void(^scanAllBlocks)(CBPeripheral *peripheral,NSNumber *RSSI,NSString *mac);
@property (nonatomic,copy)void(^connectCompleteBlock)(CBPeripheral*peripheral, BOOL success);
// 中心管理者(管理设备的扫描和连接)
@property (nonatomic, strong)CBCentralManager *centralManager;
@property (nonatomic,strong)CBCharacteristic * writeCharacteristic;
@property (nonatomic,strong)CBCharacteristic * readCharacteristic;
// 存储的设备
@property (nonatomic, strong) NSMutableArray *peripherals;
// 扫描到的设备
@property (nonatomic, strong) CBPeripheral *cbPeripheral;
// 外设状态
@property (nonatomic, assign) CBManagerState peripheralState;

@property (nonatomic,assign)BOOL discover;

@property(nonatomic, assign)BOOL isManual;

@property(nonatomic, assign)BOOL isWrite;

@end


@implementation BLEManager

+(BLEManager*)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bleManager = [BLEManager new];
        [bleManager centralManager];
    });
    return bleManager;
}


#pragma mark 协议方法

// 当状态更新时调用(如果不实现会崩溃)
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    self.peripheralState = central.state;

    switch (central.state) {
        case CBManagerStatePoweredOn:
        {
//            [self scanForDevicesWithAllBlock:self.scanAllBlock];
            [self scanForDevicesWithAllBlocks:self.scanAllBlocks];
        }
            break;
        default:{
            self.peripherals = nil;
//            if(self.scanAllBlock){
//                self.scanAllBlock(nil);
//            }
            if (self.scanAllBlocks) {
                self.scanAllBlocks(nil,nil,nil);
            }

//            [[WaringAlertView alertViewWithTitle:@"蓝牙未打开是否打开" andSureBlock:^{
//                NSURL *url = [NSURL URLWithString:@"app-Prefs:root=Bluetooth"];
//                
//                if ([[UIApplication sharedApplication] canOpenURL:url]) {
//                    
//                              [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
//                    
//                }
//                
//              
//            }]show];
        }
            break;
    }
}


/**
 扫描到设备
 
 @param central 中心管理者
 @param peripheral 扫描到的设备
 @param advertisementData 广告信息
 @param RSSI 信号强度
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    id data = advertisementData[@"kCBAdvDataManufacturerData"];
    NSLog(@"name%@",peripheral.name);
    NSLog(@"rssi%@",RSSI);
    NSLog(@"advertise%@",advertisementData);
    NSDictionary *dic = (NSDictionary *)advertisementData;
    NSArray *list = dic[@"kCBAdvDataServiceUUIDs"];
    NSString *str = [NSString stringWithFormat:@"%@",list.firstObject];

//    peripheral.
    if([[[BLEManager shareManager] converToMacAddress:data] length]){
        peripheral.macAddres = [[BLEManager shareManager] converToMacAddress:data];
        if ([str isEqualToString:kNotifyServerUUID]) {
            if (![self.peripherals containsObject:peripheral])
            {
                [self.peripherals addObject:peripheral];
            }
        }
    }

    if (self.scanAllBlocks && [str isEqualToString:kNotifyServerUUID]) {
        NSString *mac = [[BLEManager shareManager] converToMacAddress:data];
        self.scanAllBlocks(peripheral, RSSI, mac);
    }
    
//    if(self.scanAllBlock){
//        self.scanAllBlock(peripheral);
//    }
}

/**
 连接失败
 
 @param central 中心管理者
 @param peripheral 连接失败的设备
 @param error 错误信息
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{

//    if ([peripheral.macAddres isEqualToString:self.deviceName])
//    {
//        if(self.connectCompleteBlock){
//            self.connectCompleteBlock(peripheral,NO);
//            self.cbPeripheral = nil;
//        }
    [self.bleConnectDelegate onConnectResult:peripheral isSuccess:YES];
//    }
}


/**
 连接断开
 
 @param central 中心管理者
 @param peripheral 连接断开的设备
 @param error 错误信息
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    if (self.isManual != NO) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotiDisconnectAuto object:nil];
        
//        if (error != nil) {
//            [self.centralManager cancelPeripheralConnection:self.cbPeripheral];
//            [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationPoweroff object:nil];
//        }else{
//            [self.centralManager connectPeripheral:self.cbPeripheral options:nil];
//        }
        
    }else{
        self.isManual = YES;
        self.cbPeripheral = nil;
        self.connectCompleteBlock = nil;
//        [self.bleConnectDelegate onConnectResult:peripheral isSuccess:NO];
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationDisconnect object:nil];
    }
}


/**
 连接成功
 
 @param central 中心管理者
 @param peripheral 连接成功的设备
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    self.cbPeripheral = peripheral;
    self.isManual = YES;
    // 设置设备的代理
    peripheral.delegate = self;
    // services:传入nil代表扫描所有服务
    [peripheral discoverServices:nil];
    [self peripheral:peripheral didDiscoverServices:nil];
}

/**
 扫描到服务
 
 @param peripheral 服务对应的设备
 @param error 扫描错误信息
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    // 遍历所有的服务
    for (CBService *service in peripheral.services)
    {
        NSLog(@"服务:%@",service.UUID.UUIDString);
        // 获取对应的服务
        if ([service.UUID.UUIDString isEqualToString:kNotifyServerUUID] || [service.UUID.UUIDString isEqualToString:kWriteServerUUID])
        {
            // 根据服务去扫描特征
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
}

/**
 根据特征读到数据
 
 @param peripheral 读取到数据对应的设备
 @param characteristic 特征
 @param error 错误信息
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error
{
    if ([characteristic.UUID.UUIDString isEqualToString:kNotifyCharacteristicUUID]){
        NSData *data = characteristic.value;
        NSString * resultString = [self hexStringFromData:data];
        if (self.isWrite&&self.sendComplete&&[resultString hasPrefix:@"fa"]) {
            self.sendComplete(resultString);
            self.isWrite = NO;
            self.sendComplete = nil;
        }else{
            [self.bleConnectDelegate onSendResult:resultString];
        }
//        if(self.sendComplete){
//            self.sendComplete(resultString);
//        }
    }
}

/**
 扫描到对应的特征
 @param peripheral 设备
 @param service 特征对应的服务
 @param error 错误信息
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    
    for (CBCharacteristic *c in service.characteristics) {
        [peripheral discoverDescriptorsForCharacteristic:c];
    }
    
    // 遍历所有的特征
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        NSLog(@"特征值:%@",characteristic.UUID.UUIDString);
        // 获取对应的特征
        if ([characteristic.UUID.UUIDString isEqualToString:kWriteCharacteristicUUID])
        {
            self.writeCharacteristic = characteristic;            // 写入数据
//            if(self.connectCompleteBlock){
//                self.connectCompleteBlock(peripheral, YES);
//            }
            if ([self.bleConnectDelegate respondsToSelector:@selector(onConnectResult:isSuccess:)]) {
                [self.bleConnectDelegate onConnectResult:peripheral isSuccess:YES];
            }
            
        }
        if ([characteristic.UUID.UUIDString isEqualToString:kNotifyCharacteristicUUID])
        {
            // 订阅特征通知
            self.readCharacteristic = characteristic;
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
}


- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    NSLog(@"%s", __func__);
    NSLog(@"error：%@", error);
    NSLog(@"=========%@", characteristic);
    
    for (CBDescriptor *d in characteristic.descriptors) {
        NSLog(@"-- descriptors value --%@",d);
//        [weakSelf.descriptors addObject:d];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    NSLog(@"%s", __func__);
    NSLog(@"%@,",characteristic);
    NSLog(@"error：%@", error);
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{
    NSLog(@"%s", __func__);
    NSLog(@"\n\n%@",characteristic);
    NSLog(@"error：%@", error);
}


#pragma mark 自定义方法
// 扫描设备
- (void)scanForPeripheral:(NSString*)device completeBlock:(void(^)(CBPeripheral*peripheral))complete;
{
    self.deviceName = device;
    __block CBPeripheral * searchPeripheral;
    if(self.peripherals.count==0){
        [self scanForDevicesWithAllBlock:self.scanAllBlock];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             searchPeripheral = [self searchScanDevice];
//        });
    }else{
        searchPeripheral = [self searchScanDevice];
    }
    if(complete){
        complete(searchPeripheral);
    }
}


-(CBPeripheral*)searchScanDevice{
    __block CBPeripheral * peripheral;
    [self.peripherals enumerateObjectsUsingBlock:^(CBPeripheral*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj.macAddres isEqualToString:self.deviceName]){
            peripheral = obj;
        }
    }];
    return peripheral;
}

-(void)scanForDevicesWithAllBlock:(void (^)(CBPeripheral*peripherals))complete{
    self.peripherals = nil;
    self.scanAllBlock = complete;
    NSDictionary * dic = @{CBCentralManagerRestoredStateScanOptionsKey:@(YES)};
    [self.centralManager scanForPeripheralsWithServices:nil options:dic];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(self.peripherals.count==0){
            self.scanAllBlock(nil);
        }
//    });
}

-(void)scanForDevicesWithAllBlocks:(void (^)(CBPeripheral *peripheral,NSNumber *RSSI,NSString *mac))complete{
    self.peripherals = nil;
    self.scanAllBlocks = complete;
    NSDictionary * dic = @{CBCentralManagerRestoredStateScanOptionsKey:@(YES)};
    [self.centralManager scanForPeripheralsWithServices:nil options:dic];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //        if(self.peripherals.count==0){
        //            self.scanAllBlock(nil);
        //        }
//    });
}


-(void)connectPeripheral:(CBPeripheral*)peripheral complete:(void(^)(CBPeripheral*peripheral,BOOL success))complete{
    self.connectCompleteBlock = complete;
    [self.centralManager connectPeripheral:peripheral options:nil];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if(weakSelf.cbPeripheral==nil&&weakSelf.connectCompleteBlock){
//            weakSelf.connectCompleteBlock(peripheral, nil);
//        }
//    });
}

- (void)didConnecPeripheral:(CBPeripheral*)peripheral{
    [self.centralManager connectPeripheral:peripheral options:nil];
}

- (void)didConnecPeripheral:(CBPeripheral*)peripheral timer:(int)timer{
    connectTimer = [NSTimer scheduledTimerWithTimeInterval:timer target:self selector:@selector(stopConnectTimer) userInfo:nil repeats:NO];
    [self.centralManager connectPeripheral:peripheral options:nil];
}

- (void)stopConnectTimer{
    [self disConnect:NO];
    [self removeTimer];
}

- (void)removeTimer{
    if (connectTimer != nil) {
        [connectTimer invalidate];
        connectTimer = nil;
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationTimeout object:nil];
    }
}

-(NSString*)getResponseWithData:(NSData*)data{
    NSString * dataString = [self hexStringFromData:data];
    if(dataString.length==20){
        dataString = [dataString substringWithRange:NSMakeRange(4, 12)];
    }
    NSString * resultString = @"";
    for(int i= 0 ; i < dataString.length/2 ; i++){
        NSString * charString = [dataString substringWithRange:NSMakeRange(i*2, 2)];
        int charINt = [self numberHexString:charString];
        NSString * charItem = [NSString stringWithFormat:@"%c",charINt];
        resultString = [resultString stringByAppendingString:charItem];
    }
    return resultString;
}

- (int) numberHexString:(NSString *)aHexString{
    // 为空,直接返回.
    if (nil == aHexString)
    {
        return 0;
    }
    NSScanner * scanner = [NSScanner scannerWithString:aHexString];
    unsigned long long longlongValue;
    [scanner scanHexLongLong:&longlongValue];
    //将整数转换为NSNumber,存储到数组中,并返回.
    NSNumber * hexNumber = [NSNumber numberWithLongLong:longlongValue];
    return [hexNumber intValue];
}


- (NSString *)hexStringFromData:(NSData *)data
{
    NSMutableString *str = [NSMutableString string];
    Byte *byte = (Byte *)[data bytes];
    for (int i = 0; i<[data length]; i++) {
        // byte+i为指针
        [str appendString:[self stringFromByte:*(byte+i)]];
    }
    return str;
}

- (NSString *)stringFromByte:(Byte)byteVal
{
    NSMutableString *str = [NSMutableString string];
    
    //取高四位
    Byte byte1 = byteVal>>4;
    //取低四位
    Byte byte2 = byteVal & 0xf;
    //拼接16进制字符串
    [str appendFormat:@"%x",byte1];
    [str appendFormat:@"%x",byte2];
    return str;
}





-(NSData *)HexConvertToASCII:(NSString *)hexString{
    int j=0;
    Byte bytes[22];  ///3ds key的Byte 数组， 128位
    for(int i=0;i<[hexString length];i++)
    {
        int int_ch;  /// 两位16进制数转化后的10进制数
        
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        
        int int_ch1;
        
        if(hex_char1 >= '0' && hex_char1 <='9')
            
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        
        else
            
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        
        int int_ch2;
        
        if(hex_char2 >= '0' && hex_char2 <='9')
            
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        
        else
            
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        
        
        
        int_ch = int_ch1+int_ch2;
        
        NSLog(@"int_ch=%d",int_ch);
        
        bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
        
        j++;
        
    }
    
    NSData *newData = [[NSData alloc] initWithBytes:bytes length:22];
    return newData;
}


-(void)sendData:(NSData *)data complete:(void (^)(NSString*content))complete{
    self.sendComplete = complete;
    self.isWrite = YES;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.cbPeripheral writeValue:data forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
//    });
}

-(void)sendData:(NSData *)data isWrite:(BOOL)isWrite {
    self.isWrite = isWrite;
    self.sendComplete = nil;
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self.cbPeripheral writeValue:data forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
    //    });
}

- (void)updatedata{
    [self.cbPeripheral discoverDescriptorsForCharacteristic:self.readCharacteristic];
}

- (NSString *)transformCharateristicValueFromData:(NSData *)dataValue{
    if (!dataValue || [dataValue length] == 0) {
        return @"";
    }
    NSMutableString *destStr = [[NSMutableString alloc]initWithCapacity:[dataValue length]];
    [dataValue enumerateByteRangesUsingBlock:^(const void * _Nonnull bytes, NSRange byteRange, BOOL * _Nonnull stop) {
        unsigned char *dataBytes = (unsigned char *)bytes;
        for (int i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x",(dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [destStr appendString:hexStr];
            }else{
                [destStr appendFormat:@"0%@",hexStr];
            }
        }
    }];
    return destStr;
}
 
-(NSMutableArray*)peripherals{
    if(!_peripherals){
        _peripherals = [NSMutableArray array];
    }
    return _peripherals;
}

- (CBCentralManager *)centralManager
{
    if (!_centralManager)
    {
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:@{CBCentralManagerOptionShowPowerAlertKey:@(YES)}];
    }
    return _centralManager;
}



-(NSString*)converToMacAddress:(NSData*)data{
    NSMutableString *str = [NSMutableString string];
    Byte *byte = (Byte *)[data bytes];
    for (int i = 0; i<[data length]; i++) {
        // byte+i为指针
        [str appendString:[self stringFromByte:*(byte+i)]];
        if (i == [data length]-1) {
            
        }else{
            [str appendString:@":"];
        }
    }
    return str;
}


+ (NSString *)getHexByDecimal:(NSInteger)decimal {
    
    NSString *hex =@"";
    NSString *letter;
    NSInteger number;
    for (int i = 0; i<9; i++) {
        
        number = decimal % 16;
        decimal = decimal / 16;
        switch (number) {
                
            case 10:
                letter =@"A"; break;
            case 11:
                letter =@"B"; break;
            case 12:
                letter =@"C"; break;
            case 13:
                letter =@"D"; break;
            case 14:
                letter =@"E"; break;
            case 15:
                letter =@"F"; break;
            default:
                letter = [NSString stringWithFormat:@"%ld", number];
        }
        hex = [letter stringByAppendingString:hex];
        if (decimal == 0) {
            
            break;
        }
    }
    return hex;
}
- (NSNumber *) changenumberHexString:(NSString *)aHexString

{
    
    // 为空,直接返回.
    
    if (nil == aHexString)
        
    {
        
        return nil;
        
    }
    
    
    
    NSScanner * scanner = [NSScanner scannerWithString:aHexString];
    
    unsigned long long longlongValue;
    
    [scanner scanHexLongLong:&longlongValue];
    
    
    
    //将整数转换为NSNumber,存储到数组中,并返回.
    
    NSNumber * hexNumber = [NSNumber numberWithLongLong:longlongValue];
    
    
    
    return hexNumber;
    
    
    
}


-(void)disConnect{
    if(self.cbPeripheral)
    [self.centralManager cancelPeripheralConnection:self.cbPeripheral];
}

// 手动断开链接
- (void)disConnect:(BOOL)isManual{
    self.isManual = isManual;
    if (self.cbPeripheral) {
        [self.centralManager cancelPeripheralConnection:self.cbPeripheral];
    }
}

- (void)didStopScan{
    [self.centralManager stopScan];
}

@end
