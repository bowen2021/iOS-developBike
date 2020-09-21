//
//  BOBDataTools.m
//  Bob
//
//  Created by apple on 16/9/1.
//  Copyright © 2016年 com.xabeiying. All rights reserved.
//

#import "BOBDataTools.h"

@implementation BOBDataTools

+(NSData*)sendDataWIthCommand:(UInt8)CMD check:(UInt8)check data1:(UInt8)data1 data2:(UInt8)data2 data3:(UInt8)data3 data4:(UInt8)data4 data5:(UInt8)data5 data6:(UInt8)data6
{
   
    NSLog(@"%d",data2);
    NSData * mydata;
    UInt8 message[10];
    message[0] = dataHeader;
    message[1] = CMD;
    message[2] = data1;
    message[3] = data2;
    message[4] = data3;
    message[5] = data4;
    message[6] = data5;
    message[7] = data6;
    message[8] = CMD^data1^data2^data3^data4^data5^data6;
    message[9] = dataFooter;
   

    mydata = [NSData dataWithBytes:message length:10];
    return mydata;
}



        
       
@end
