//
//  XMGDIYHeader.m
//  BuDeJie
//
//  Created by xiaomage on 16/3/29.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGDIYHeader.h"

@interface XMGDIYHeader()
/** 开关 */
@property (nonatomic, weak) UISwitch *s;
/** logo */
@property (nonatomic, weak) UIImageView *logo;
@end

@implementation XMGDIYHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UISwitch *s = [[UISwitch alloc] init];
        [self addSubview:s];
        self.s = s;
        
        UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
        [self addSubview:logo];
        self.logo = logo;
//        self.xmg_height = 70;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.logo.xmg_centerX = self.xmg_width * 0.5;
    self.logo.xmg_y =  -  3 * self.logo.xmg_height;
    
    self.s.xmg_centerX = self.xmg_width * 0.5;
    self.s.xmg_centerY = self.xmg_height * 0.5;
}

#pragma mark - 重写Header内部的方法
- (void)setState:(MJRefreshState)state
{
    [super setState:state];
    
    if (state == MJRefreshStateIdle) { // 下拉可以刷新
        [self.s setOn:NO animated:YES];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.s.transform = CGAffineTransformIdentity;
        }];
    } else if (state == MJRefreshStatePulling) { // 松开立即刷新
        [self.s setOn:YES animated:YES];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.s.transform = CGAffineTransformMakeRotation(M_PI_2);
        }];
    } else if (state == MJRefreshStateRefreshing) { // 正在刷新
        [self.s setOn:YES animated:YES];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.s.transform = CGAffineTransformMakeRotation(M_PI_2);
        }];
    }
}

@end
