//
//  NSObject+Model.h
//  n0624
//
//  Created by Macx on 2017/6/24.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Model)

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)modelsFromDictionary:(NSDictionary *)dict;
+ (NSMutableArray *)modelFromKeyvalueArray:(NSArray <NSDictionary *>*)keyValueArray;
@end
