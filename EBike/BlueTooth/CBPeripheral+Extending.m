//
//  CBPeripheral+Extending.m
//  Root
//
//  Created by apple on 2018/9/15.
//  Copyright © 2018年 com.GooHarbour. All rights reserved.
//

#import "CBPeripheral+Extending.h"
#import <objc/message.h>
static const char *key = "macAddres";
static const char *key1 = "UUID";
@implementation CBPeripheral (Extending)
- (void)setMacAddres:(NSString *)macAddres

{
    
    // 让这个字符串与当前对象产生联系
    
    
    
    // _name = name;
    
    // object:给哪个对象添加属性
    
    // key:属性名称
    
    // value:属性值
    
    // policy:保存策略
    
    
    
    objc_setAssociatedObject(self, key, macAddres, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    
    
    //objc_setAssociatedObject(self, @"name", name, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}


- (NSString *)macAddres

{
    
    // 根据关联的key，获取关联的值。
    
    
    
    return objc_getAssociatedObject(self, key);
    
    //return objc_getAssociatedObject(self, @"name");
    
}


-(void)setUUID:(NSString *)UUID{
    objc_setAssociatedObject(self, key1, UUID, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

-(NSString*)UUID{
    return objc_getAssociatedObject(self, key1);

}
@end
