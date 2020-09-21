//
//  BOBDataTools.h
//  Bob
//
//  Created by apple on 16/9/1.
//  Copyright © 2016年 com.xabeiying. All rights reserved.
//

#import <Foundation/Foundation.h>

static  UInt8 dataHeader = 0x5A;
static  UInt8 dataFooter = 0xAA;





@interface BOBDataTools : NSObject

+(NSData*)sendDataWIthCommand:(UInt8)CMD check:(UInt8)check data1:(UInt8)data1 data2:(UInt8)data2 data3:(UInt8)data3 data4:(UInt8)data4 data5:(UInt8)data5 data6:(UInt8)data6;

@end
