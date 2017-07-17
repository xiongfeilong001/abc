//
//  ViewController.m
//  2017-07-16-11-42-05
//
//  Created by Macx on 2017/7/16.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "ViewController.h"
#import <objc/message.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
//    
//    unsigned int outCount = 0;
//    
//    Ivar *ivars =  class_copyIvarList([UIGestureRecognizer class], &outCount);
//    NSMutableString *strM = [NSMutableString string];
//    for (int i = 0; i<outCount; i++) {
//        NSString *name = @(ivar_getName(ivars[i]));
//        [strM appendString:[NSString stringWithFormat:@"%@\n",name]];
//    }
//    
//    NSLog(@".....%@",strM);

    
    
//    unsigned int countM = 0;
//    Method *ivars2 =  class_copyMethodList([UIGestureRecognizer class], &countM);
//    
//    NSLog(@". . .%d",countM);
//    
//    for (int i = 0; i<countM; i++) {
//        
//        SEL m = method_getName(ivars2[i]);
//        
//        NSString *name = @(sel_getName(m));
//        NSLog(@"---------%@",name);
//    }

    [self setXmg_Placeholder:@"aa"];
}

- (void)setXmg_Placeholder:(NSString *)placeholder
{
    [self setXmg_Placeholder:placeholder];
    
    NSLog(@"...%s",__func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
