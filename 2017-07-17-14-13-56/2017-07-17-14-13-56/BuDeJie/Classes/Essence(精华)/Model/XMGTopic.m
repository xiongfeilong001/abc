//
//  XMGTopic.m
//  BuDeJie
//
//  Created by xiaomage on 16/3/22.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGTopic.h"

@implementation XMGTopic

/*
 如果错误信息里面包含了：NaN，一般都是因为除0造成（比如x/0）
 (NaN : Not a number）
 */

- (CGFloat)cellHeight
{
    // 如果已经计算过，就直接返回
    if (_cellHeight) return _cellHeight;
    
    // 文字的Y值
    _cellHeight += 55;
    
    // 文字的高度
    CGSize textMaxSize = CGSizeMake(XMGScreenW - 2 * XMGMarin, MAXFLOAT);
    _cellHeight += [self.text boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height + XMGMarin;
    
    // 中间的内容    
//    if (self.type != XMGTopicTypeWord) { // 中间有内容（图片、声音、视频）
//        CGFloat middleW = textMaxSize.width;
//        CGFloat middleH = middleW * self.height / self.width;
//        if (middleH >= XMGScreenH) { // 显示的图片高度超过一个屏幕，就是超长图片
//            middleH = 200;
//            self.bigPicture = YES;
//        }
//        CGFloat middleY = _cellHeight;
//        CGFloat middleX = XMGMarin;
//        self.middleFrame = CGRectMake(middleX, middleY, middleW, middleH);
//        _cellHeight += middleH + XMGMarin;
//    }
    
    // 最热评论
    if (self.top_cmt.count) { // 有最热评论
        // 标题
        _cellHeight += 21;
        
        // 内容
        NSDictionary *cmt = self.top_cmt.firstObject;
        NSString *content = cmt[@"content"];
        if (content.length == 0) {
            content = @"[语音评论]";
        }
        NSString *username = cmt[@"user"][@"username"];
        NSString *cmtText = [NSString stringWithFormat:@"%@ : %@", username, content];
        _cellHeight += [cmtText boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} context:nil].size.height + XMGMarin;
    }
    
    // 工具条
    _cellHeight += 35 + XMGMarin;
    
    return _cellHeight;
}

@end
