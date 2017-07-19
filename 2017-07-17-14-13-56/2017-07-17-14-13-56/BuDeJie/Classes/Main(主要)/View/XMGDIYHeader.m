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

/**刷新标题所在标签*/

@end

@implementation XMGDIYHeader



- (void)dealloc{
    NSLog(@". .. .header . ..老子挂了。。 。 。。 ");
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        UISwitch *s = [[UISwitch alloc] init];
//        [self addSubview:s];
//        self.s = s;
        
        [self addLbn];
//        [self addLogo];
    }
    return self;
}

- (void)addLogo{
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    logo.alpha = 0.5;
    [self addSubview:logo];
    self.logo = logo;
}

- (void)addLbn{
    [_logo removeFromSuperview];
    UILabel *title_lbn = [[UILabel alloc]init];
    _title_lbn = title_lbn;
    [self addSubview:title_lbn];
    _title_lbn.text = @"正在加载中 . . .";
    _title_lbn.font = [UIFont systemFontOfSize:33];
    [_title_lbn setTextColor:[UIColor yellowColor]];
    _title_lbn.textAlignment = NSTextAlignmentCenter;
    [_title_lbn sizeToFit];
    self.title_lbn.hidden = NO;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
        self.title_lbn.frame = CGRectMake(0, -50, 320, 50);
    self.title_lbn.xmg_centerX = self.xmg_width * 0.5;;
    
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
        self.title_lbn.hidden = NO;
        
        [UIView animateWithDuration:0.25 animations:^{
            self.s.transform = CGAffineTransformIdentity;
        }];
    } else if (state == MJRefreshStatePulling) { // 松开立即刷新
        [self.s setOn:YES animated:YES];
        self.title_lbn.hidden = NO;
        
        [UIView animateWithDuration:0.25 animations:^{
            self.s.transform = CGAffineTransformMakeRotation(M_PI_2);
        }];
    } else if (state == MJRefreshStateRefreshing) { // 正在刷新
        [self.s setOn:YES animated:YES];
        self.title_lbn.hidden = NO;
        
        [UIView animateWithDuration:0.25 animations:^{
            self.s.transform = CGAffineTransformMakeRotation(M_PI_2);
        }];
    }else if (state == MJRefreshStateNoMoreData){
        self.title_lbn.hidden = YES;
    }
}

@end
