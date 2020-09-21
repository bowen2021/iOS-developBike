//
//  CBPeripheral+Extending.h
//  Root
//
//  Created by apple on 2018/9/15.
//  Copyright © 2018年 com.GooHarbour. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

@interface CBPeripheral (Extending)
- (void)setMacAddres:(NSString *)macAddres;
- (NSString *)macAddres;

- (void)setUUID:(NSString *)UUID;
- (NSString *)UUID;
@end
