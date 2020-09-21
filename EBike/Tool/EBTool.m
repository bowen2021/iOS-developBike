//
//  EBTool.m
//  EBike
//
//  Created by 刘佳斌 on 2019/2/19.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#import "EBTool.h"


static EBTool * _tools =nil;

@implementation EBTool

+ (instancetype)shareTools{
    
    static dispatch_once_t tocken;
    dispatch_once(&tocken, ^{
        _tools = [[super alloc]init];
    });
    return _tools;
}


#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
+ (UIColor*)colorWithHexString:(NSString*)color
{
    NSString* cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString* rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString* gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString* bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float)r / 255.0f)green:((float)g / 255.0f)blue:((float)b / 255.0f)alpha:1.0f];
}

+ (NSAttributedString *)willBecomeColorNeedStrOfAllStr:(NSString *)allStr needBecomeStr:(NSString *)becomeStr needColor:(UIColor *)color needFont:(UIFont *)font
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:allStr];
    NSRange range = [allStr rangeOfString:becomeStr];
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:range];
    [attributedString addAttribute:NSFontAttributeName value:font range:range];
    return attributedString;
}

+ (CGFloat)handleCommonFit:(CGFloat)num{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
        return SCALE_LWIDTH(num);
    }else{
        return SCALE_PWIDTH(num);
    }
}

/**
 十六进制->十进制
 */
+ (NSInteger)getDecimalByHex:(NSString *)hex{
    return (NSInteger)strtoul(hex.UTF8String, 0, 16);
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

/**
 十六进制 - 二进制
 */
+ (NSString *)getBinaryByHex:(NSString *)hex {
    
    NSMutableDictionary *hexDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    [hexDic setObject:@"0000" forKey:@"0"];
    [hexDic setObject:@"0001" forKey:@"1"];
    [hexDic setObject:@"0010" forKey:@"2"];
    [hexDic setObject:@"0011" forKey:@"3"];
    [hexDic setObject:@"0100" forKey:@"4"];
    [hexDic setObject:@"0101" forKey:@"5"];
    [hexDic setObject:@"0110" forKey:@"6"];
    [hexDic setObject:@"0111" forKey:@"7"];
    [hexDic setObject:@"1000" forKey:@"8"];
    [hexDic setObject:@"1001" forKey:@"9"];
    [hexDic setObject:@"1010" forKey:@"A"];
    [hexDic setObject:@"1011" forKey:@"B"];
    [hexDic setObject:@"1100" forKey:@"C"];
    [hexDic setObject:@"1101" forKey:@"D"];
    [hexDic setObject:@"1110" forKey:@"E"];
    [hexDic setObject:@"1111" forKey:@"F"];
    NSString *binary = @"";
    for (int i=0; i<[hex length]; i++) {
        NSString *key = [hex substringWithRange:NSMakeRange(i, 1)];
        NSString *value = [hexDic objectForKey:key.uppercaseString];
        if (value) {
            binary = [binary stringByAppendingString:value];
        }
    }
    return binary;
}


/**
 二进制转换为十进制
 
 @param binary 二进制数
 @return 十进制数
 */
+ (NSInteger)getDecimalByBinary:(NSString *)binary {
    
    NSInteger decimal = 0;
    for (int i=0; i<binary.length; i++) {
        NSString *number = [binary substringWithRange:NSMakeRange(binary.length - i - 1, 1)];
        if ([number isEqualToString:@"1"]) {
            decimal += pow(2, i);
        }
    }
    return decimal;
}

/**
 十进制转换为二进制
 
 @param decimal 十进制数
 @return 二进制数
 */
+ (NSString *)getBinaryByDecimal:(NSInteger)decimal {
    
    NSString *binary = @"";
    while (decimal) {
        
        binary = [[NSString stringWithFormat:@"%ld", decimal % 2] stringByAppendingString:binary];
        if (decimal / 2 < 1) {
            
            break;
        }
        decimal = decimal / 2 ;
    }
    if (binary.length % 4 != 0) {
        
        NSMutableString *mStr = [[NSMutableString alloc]init];;
        for (int i = 0; i < 4 - binary.length % 4; i++) {
            
            [mStr appendString:@"0"];
        }
        binary = [mStr stringByAppendingString:binary];
    }
    return binary;
}

/**
 字符串转byte
 */
+ (Byte)getByteByStr:(NSString *)value{
    if ([value isEqualToString:@"0"]) {
        return 0x00;
    }else if ([value isEqualToString:@"1"]){
        return 0x01;
    }else if ([value isEqualToString:@"2"]){
        return 0x02;
    }else if ([value isEqualToString:@"3"]){
        return 0x03;
    }else if ([value isEqualToString:@"4"]){
        return 0x04;
    }else if ([value isEqualToString:@"5"]){
        return 0x05;
    }else if ([value isEqualToString:@"6"]){
        return 0x06;
    }else if ([value isEqualToString:@"7"]){
        return 0x07;
    }else if ([value isEqualToString:@"8"]){
        return 0x08;
    }else if ([value isEqualToString:@"9"]){
        return 0x09;
    }else if ([value isEqualToString:@"10"]){
        return 0x0A;
    }else if ([value isEqualToString:@"11"]){
        return 0x0B;
    }else if ([value isEqualToString:@"12"]){
        return 0x0C;
    }else if ([value isEqualToString:@"13"]){
        return 0x0D;
    }else if ([value isEqualToString:@"14"]){
        return 0x0E;
    }else if ([value isEqualToString:@"15"]){
        return 0x0F;
    }
    return 0x00;
}


//func AppRootViewController() -> UIViewController? {
//    var topVC = UIApplication.shared.keyWindow?.rootViewController
//    while topVC?.presentedViewController != nil {
//        topVC = topVC?.presentedViewController
//    }
//    return topVC
//}

+ (UIViewController *)appRootVC{
    UIViewController *topVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topVc.presentedViewController != nil) {
        topVc = topVc.presentedViewController;
    }
    return topVc;
}

+ (BOOL)isBlank:(NSString *)string {
    if(nil != string) {
        if((string.length > 0)
           && (![string isEqualToString:@"<null>"])
           && (![string isEqualToString:@"<NULL>"])
           && (![string isEqualToString:@"<Null>"])
           && (![string isEqualToString:@" "])
           ) {
            return false;
        }
    }
    return true;
}

@end
