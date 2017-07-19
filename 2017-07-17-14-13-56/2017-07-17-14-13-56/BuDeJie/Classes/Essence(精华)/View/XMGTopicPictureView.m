//
//  XMGTopicPictureView.m
//  BuDeJie
//
//  Created by xiaomage on 16/3/24.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGTopicPictureView.h"
#import "XMGTopic.h"
#import "UIImageView+WebCache.h"
#import "XMGSeeBigPictureViewController.h"

@interface XMGTopicPictureView()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderView;
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
@property (weak, nonatomic) IBOutlet UIButton *seeBigPictureButton;
@end

@implementation XMGTopicPictureView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    
    self.imageView.userInteractionEnabled = YES;
    
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBigPicture)]];
}

/**
 *  查看大图
 */
- (void)seeBigPicture
{
    XMGSeeBigPictureViewController *vc = [[XMGSeeBigPictureViewController alloc] init];
    vc.topic = self.topic;
    [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
    
    //    [UIApplication sharedApplication].keyWindow.rootViewController;
}

- (void)setTopic:(XMGTopic *)topic
{
    _topic = topic;
    
    // 设置图片
    self.placeholderView.hidden = NO;

    
    // 点击查看大图
    
    [self.imageView xmg_setOriginImage:topic.image1 thumbnailImage:topic.image0 placeholder:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) return;
        self.placeholderView.hidden = YES;
        
        // gif
        self.gifView.hidden = !topic.is_gif;
    }];
    
    
    
    if (topic.isBigPicture) { // 超长图
//        NSLog(@".. . . 它是 大 图高有%f",topic.middleFrame.size.height);
        self.seeBigPictureButton.hidden = NO;
        self.imageView.contentMode = UIViewContentModeTop;
        self.imageView.clipsToBounds = YES;
    } else {
//        NSLog(@".. . . 它是 小 图高有%f   %@    %f  %f  ",topic.middleFrame.size.height,topic.name,topic.width,topic.height);
        self.seeBigPictureButton.hidden = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.clipsToBounds = NO;
    }
}
@end
