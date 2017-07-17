//
//  XMGTestHeader.m
//  BuDeJie
//
//  Created by xiaomage on 16/3/29.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGTestHeader.h"

@implementation XMGTestHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 设置状态文字颜色
        self.stateLabel.textColor = [UIColor orangeColor];
        // 自动切换透明度
        self.automaticallyChangeAlpha = YES;
    }
    return self;
}

@end
