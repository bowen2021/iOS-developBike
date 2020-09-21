//
//  EBTool.h
//  EBike
//
//  Created by 刘佳斌 on 2019/2/19.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EBMacro.h"

NS_ASSUME_NONNULL_BEGIN

@interface EBTool : NSObject

+ (instancetype)shareTools;


+ (UIColor*)colorWithHexString:(NSString*)color;

//设置字符串中某字段的颜色和字体
+ (NSAttributedString *)willBecomeColorNeedStrOfAllStr:(NSString *)allStr needBecomeStr:(NSString *)becomeStr needColor:(UIColor *)color needFont:(UIFont *)font;

+ (CGFloat)handleCommonFit:(CGFloat)num;

/**
 十六进制转二进制
 */
+ (NSString *)getBinaryByHex:(NSString *)hex;

/**
 十进制转十六进制
 */
+ (NSString *)getHexByDecimal:(NSInteger)decimal;

/**
 二进制转换为十进制
 
 @param binary 二进制数
 @return 十进制数
 */
+ (NSInteger)getDecimalByBinary:(NSString *)binary;

/**
 十六进制转十进制
 */
+ (NSInteger)getDecimalByHex:(NSString *)hex;

/**
 十进制转换为二进制
 
 @param decimal 十进制数
 @return 二进制数
 */
+ (NSString *)getBinaryByDecimal:(NSInteger)decimal;


/**
 字符串转byte
 */
+ (Byte)getByteByStr:(NSString *)value;


+ (UIViewController *)appRootVC;

//字符是否为空
+ (BOOL)isBlank:(NSString *)string;
@end

NS_ASSUME_NONNULL_END
