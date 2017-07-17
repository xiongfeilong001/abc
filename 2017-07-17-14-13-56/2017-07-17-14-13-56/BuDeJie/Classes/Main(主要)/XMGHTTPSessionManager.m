//
//  XMGHTTPSessionManager.m
//  BuDeJie
//
//  Created by xiaomage on 16/3/29.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGHTTPSessionManager.h"

@implementation XMGHTTPSessionManager

- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    if (self = [super initWithBaseURL:url sessionConfiguration:configuration]) {
        [self.requestSerializer setValue:[UIDevice currentDevice].model forHTTPHeaderField:@"Phone"];
        [self.requestSerializer setValue:[UIDevice currentDevice].systemVersion forHTTPHeaderField:@"OS"];
    }
    return self;
}
@end
