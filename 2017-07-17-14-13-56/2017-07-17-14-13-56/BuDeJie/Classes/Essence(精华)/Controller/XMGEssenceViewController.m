//
//  XMGEssenceViewController.m
//  BuDeJie
//
//  Created by xiaomage on 16/3/11.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGEssenceViewController.h"
#import "XMGTitleButton.h"

#import "XMGAllViewController.h"
#import "XMGVideoViewController.h"
#import "XMGVoiceViewController.h"
#import "XMGPictureViewController.h"
#import "XMGWordViewController.h"

@interface XMGEssenceViewController () <UIScrollViewDelegate>
/** 用来存放所有子控制器view的scrollView */
@property (nonatomic, weak) UIScrollView *scrollView;
/** 标题栏 */
@property (nonatomic, weak) UIView *titlesView;
/** 标题下划线 */
@property (nonatomic, weak)     UIView *titleUnderline;
/** 上一次点击的标题按钮 */
@property (nonatomic, weak) XMGTitleButton *previousClickedTitleButton;

/**子控制器标题*/
@property(nonatomic,strong)NSMutableArray *vc_title;
@end

@implementation XMGEssenceViewController
#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化子控制器
    [self setupAllChildVcs];
    
    // 设置导航条
    [self setupNavBar];
    
    // scrollView
    [self setupScrollView];
    
    // 标题栏
    [self setupTitlesView];
    
    // 添加第0个子控制器的view
    [self addChildVcViewIntoScrollView:0];
}

/**
 *  初始化子控制器
 */
- (void)setupAllChildVcs
{
    [_vc_title removeAllObjects];
    _vc_title = [NSMutableArray array];
    
    UIViewController *vc_all = [[XMGAllViewController alloc] init];
    vc_all.title = @"全部";
    UIViewController *vc_video = [[XMGVideoViewController alloc] init];
    vc_video.title = @"视频";
    UIViewController *vc_picture = [[XMGPictureViewController alloc] init];
    vc_picture.title = @"图片";
    UIViewController *vc_voice = [[XMGVoiceViewController alloc] init];
    vc_voice.title = @"声音";
    UIViewController *vc_word = [[XMGWordViewController alloc] init];
    vc_word.title = @"段子";
    
    [_vc_title addObject:vc_all.title];
    [_vc_title addObject:vc_video.title];
    [_vc_title addObject:vc_picture.title];
    [_vc_title addObject:vc_voice.title];
    [_vc_title addObject:vc_word.title];
    
    [self addChildViewController:vc_all];
    [self addChildViewController:vc_video];
    [self addChildViewController:vc_picture];
    [self addChildViewController:vc_voice];
    [self addChildViewController:vc_word];
}

/**
 *  设置导航条
 */
- (void)setupNavBar
{
    // 左边按钮
    // 把UIButton包装成UIBarButtonItem.就导致按钮点击区域扩大
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithimage:[UIImage imageNamed:@"navigationButtonReturnClick"] highImage:[UIImage imageNamed:@"navigationButtonReturnClick"] target:self action:@selector(game)];
    
    // 右边按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithimage:[UIImage imageNamed:@"friendsRecommentIcon-click"] highImage:[UIImage imageNamed:@"friendsRecommentIcon-click"] target:self action:@selector(game)];
    
    // titleView
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
}

/**
 *  scrollView
 */
- (void)setupScrollView
{
    // 不允许自动修改UIScrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor blackColor];
    scrollView.frame = self.view.bounds;
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.scrollsToTop = NO; // 点击状态栏的时候，这个scrollView不会滚动到最顶部
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    // 添加子控制器的view
    NSUInteger count = self.childViewControllers.count;
    CGFloat scrollViewW = scrollView.xmg_width;
    scrollView.contentSize = CGSizeMake(count * scrollViewW, 0);
}

/**
 *  标题栏
 */
- (void)setupTitlesView
{
    UIView *titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    
    titlesView.frame = CGRectMake(0, XMGNavMaxY, self.view.xmg_width, XMGTitlesViewH);
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
    // 标题栏按钮
    [self setupTitleButtons];
    
    // 标题下划线
    [self setupTitleUnderline];
}

/**
 *  标题栏按钮
 */
- (void)setupTitleButtons
{
    // 文字
    // 标题按钮的尺寸
    CGFloat titleButtonW = self.titlesView.xmg_width / _vc_title.count;
    CGFloat titleButtonH = self.titlesView.xmg_height;
    
    // 创建5个标题按钮
    for (NSUInteger i = 0; i < _vc_title.count; i++) {
        XMGTitleButton *titleButton = [[XMGTitleButton alloc] init];
        titleButton.tag = i;
        
        titleButton.backgroundColor = [UIColor greenColor];
        [titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.titlesView addSubview:titleButton];
        // frame
        titleButton.frame = CGRectMake(i * titleButtonW, 0, titleButtonW, titleButtonH);
        // 文字
        [titleButton setTitle:_vc_title[i] forState:UIControlStateNormal];
    }
}

/**
 *  标题下划线
 */
- (void)setupTitleUnderline
{
    // 标题按钮
    XMGTitleButton *firstTitleButton = self.titlesView.subviews.firstObject;
    
    // 下划线
    UIView *titleUnderline = [[UIView alloc] init];
    titleUnderline.xmg_height = 2;
    titleUnderline.xmg_y = self.titlesView.xmg_height - titleUnderline.xmg_height;
    titleUnderline.backgroundColor = [firstTitleButton titleColorForState:UIControlStateSelected];
    [self.titlesView addSubview:titleUnderline];
    self.titleUnderline = titleUnderline;
    
    // 切换按钮状态
    firstTitleButton.selected = YES;
    self.previousClickedTitleButton = firstTitleButton;
    
    [firstTitleButton.titleLabel sizeToFit]; // 让label根据文字内容计算尺寸
    self.titleUnderline.xmg_width = firstTitleButton.titleLabel.xmg_width + XMGMarin;
    self.titleUnderline.xmg_centerX = firstTitleButton.xmg_centerX;
}

#pragma mark - 监听
/**
 *  点击标题按钮
 */
- (IBAction)titleButtonClick:(XMGTitleButton *)titleButton
{
    // 重复点击了标题按钮
    if (self.previousClickedTitleButton == titleButton) {
        [[NSNotificationCenter defaultCenter] postNotificationName:XMGTitleButtonDidRepeatClickNotification object:nil];
    }
    
    // 处理标题按钮点击
    [self dealTitleButtonClick:titleButton];
}

/**
 *  处理标题按钮点击
 */
- (void)dealTitleButtonClick:(XMGTitleButton *)titleButton
{
    // 切换按钮状态
    self.previousClickedTitleButton.selected = NO;
    titleButton.selected = YES;
    self.previousClickedTitleButton = titleButton;
    
    NSUInteger index = titleButton.tag;
    [UIView animateWithDuration:0.25 animations:^{
        // 处理下划线
        self.titleUnderline.xmg_width = titleButton.titleLabel.xmg_width + XMGMarin;
        self.titleUnderline.xmg_centerX = titleButton.xmg_centerX;
        
        // 滚动scrollView
        CGFloat offsetX = self.scrollView.xmg_width * index;
        self.scrollView.contentOffset = CGPointMake(offsetX, 0.f);
        
    } completion:^(BOOL finished) {
        // 添加子控制器的view
        [self addChildVcViewIntoScrollView:index];
    }];
    
    // 设置index位置对应的tableView.scrollsToTop = YES， 其他都设置为NO
    for (NSUInteger i = 0; i < self.childViewControllers.count; i++) {
        UIViewController *childVc = self.childViewControllers[i];
        // 如果view还没有被创建，就不用去处理
        if (!childVc.isViewLoaded) continue;
        
        UIScrollView *scrollView = (UIScrollView *)childVc.view;
        if (![scrollView isKindOfClass:[UIScrollView class]]) continue;
        
        
        scrollView.scrollsToTop = (i == index);
    }
}

- (void)game
{
    XMGFunc
}

#pragma mark - <UIScrollViewDelegate>
/**
 *  当用户松开scrollView并且滑动结束时调用这个代理方法（scrollView停止滚动的时候）
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 求出标题按钮的索引
    NSUInteger index = scrollView.contentOffset.x / scrollView.xmg_width;
    
    // 点击对应的标题按钮
    XMGTitleButton *titleButton = self.titlesView.subviews[index];
//    [self titleButtonClick:titleButton];
    [self dealTitleButtonClick:titleButton];
}

#pragma mark - 其他
/**
 *  添加第index个子控制器的view到scrollView中
 */
- (void)addChildVcViewIntoScrollView:(NSUInteger)index
{
    UIViewController *childVc = self.childViewControllers[index];
    
    // 如果view已经被加载过，就直接返回
    if (childVc.isViewLoaded) return;
    
    // 取出index位置对应的子控制器view
    UIView *childVcView = childVc.view;
    
    // 设置子控制器view的frame
    CGFloat scrollViewW = self.scrollView.xmg_width;
    childVcView.frame = CGRectMake(index * scrollViewW, 0, scrollViewW, self.scrollView.xmg_height);
    // 添加子控制器的view到scrollView中
    [self.scrollView addSubview:childVcView];
}

- (void)dealloc{
    NSLog(@". . . .. . 精华这 大块 挂了 . . .. . . . ");
}
@end
