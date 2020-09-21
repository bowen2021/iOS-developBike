//
//  EBMacro.h
//  EBike
//
//  Created by 刘佳斌 on 2019/2/19.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#ifndef EBMacro_h
#define EBMacro_h

// 屏幕宽度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
// 屏幕高度
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
// 屏幕bounds
#define kScreenBounds               ([[UIScreen mainScreen] bounds])


//直立时 比例
#define SCALE_PWIDTH(width)          (width * (kScreenWidth / 375.0))
//横向时 比例
#define SCALE_LWIDTH(width)          (width * (kScreenHeight / 375.0))

#define EBWeakSelf __weak typeof(self) weakSelf = self;

// 通知
#define kNotificationCenterHome     @"kNotificationCenterHome"
#define kNotificationRefreshData    @"kNotificationRefreshData"
#define kNotificationDisconnect     @"kNotificationDisconnect"
#define kNotificationTimeout        @"kNotificationTimeout"
#define kNotificationPoweroff       @"kNotificationPoweroff"

#define kNotiDisconnectAuto         @"kNotiDisconnectAuto"


#endif /* EBMacro_h */
