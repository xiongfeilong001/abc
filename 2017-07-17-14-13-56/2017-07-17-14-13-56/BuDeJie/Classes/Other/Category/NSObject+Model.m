//
//  NSObject+Model.m
//  n0624
//
//  Created by Macx on 2017/6/24.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "NSObject+Model.h"
#import <objc/message.h>

@implementation NSObject (Model)

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    
    if ([self init]) {
        //获取本类全部（包含内部）属性：
        unsigned int count = 0;
        Ivar *var = class_copyIvarList(self.class, &count);
        //遍历内部属性：
        for (int i = 0; i < count; i++) {
            //得到单个属性的 名称
            Ivar v = var[i];
            
            //把属性名称 转化成 OC字符串
            NSString *property = [NSString stringWithUTF8String:ivar_getName(v)];
            
            //名字去掉前面那个_
            property = [property substringFromIndex:1];
            
            
            id value = dict[property];
            
            //获得 属性值的 类型名
            NSString *class_str = [NSString stringWithUTF8String:ivar_getTypeEncoding(v)];
            class_str = [class_str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            class_str = [class_str stringByReplacingOccurrencesOfString:@"@" withString:@""];
            
            //如果发现这个属性值的类是自定义类 那么就（递归）转化.
            if ([value isKindOfClass:[NSDictionary class]] && ![class_str hasPrefix:@"NS"]) {
                value = [NSClassFromString(class_str) initWithDictionary:value];
            }
            
            //如果字典里面有这个键值 就 把对象kvc设置给这个键值
            if (value) {
                [self setValue:value forKey:property];
            }
        }
    }
    
    return self;
}


+ (NSMutableArray *)modelFromKeyvalueArray:(NSArray <NSDictionary *>*)keyValueArray{
    NSMutableArray *arrM = [NSMutableArray array];
    
    [keyValueArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arrM addObject:[self modelsFromDictionary:obj]];
    }];
    
    return arrM;
}

+ (instancetype)modelsFromDictionary:(NSDictionary *)dict{
    return [[self alloc]initWithDictionary:dict];
}

@end
