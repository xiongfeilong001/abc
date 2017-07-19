
//
//  My_tableview_header_refresh.m
//  2017-07-17-14-13-56
//
//  Created by Macx on 2017/7/19.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "My_tableview_header_refresh.h"
//#import "UIView+MJExtension.h"

@implementation My_tableview_header_refresh

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}


- (void)setup{
    
//    self.xmg_centerX = self.view.xmg_centerX;
    self.text = @"正在加载中 . . .";
    self.font = [UIFont systemFontOfSize:33];
    [self setTextColor:[UIColor yellowColor]];
    self.textAlignment = NSTextAlignmentCenter;
    [self sizeToFit];
    [self addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [self.superview addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    UIView *v = [[UIView alloc]init];
    v.mj_y -= 50;
    [UIView animateWithDuration:3 animations:^{
//        v.mj_y -= 50;
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
