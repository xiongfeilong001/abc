//
//  XMGTopicViewController.h
//  BuDeJie
//
//  Created by xiaomage on 16/3/28.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMGTopic.h"

@interface XMGTopicViewController : UITableViewController
/** 帖子的类型 */
//@property (nonatomic, assign, readonly) XMGTopicType type;

- (XMGTopicType)type;
@end
