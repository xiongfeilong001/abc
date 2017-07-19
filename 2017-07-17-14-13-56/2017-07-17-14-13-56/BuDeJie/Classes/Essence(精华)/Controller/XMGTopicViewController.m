//
//  XMGTopicViewController.m
//  BuDeJie
//
//  Created by xiaomage on 16/3/18.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGTopicViewController.h"
#import "MJExtension.h"
#import "XMGTopic.h"
#import "SVProgressHUD.h"
#import "XMGTopicCell.h"
#import "SDImageCache.h"
#import "XMGRefreshHeader.h"
#import "XMGTestHeader.h"
#import "XMGDIYHeader.h"
#import "XMGDIYFooter.h"
#import "XMGHTTPSessionManager.h"

@interface XMGTopicViewController ()
/** 当前最后一条帖子数据的描述信息，专门用来加载下一页数据 */
@property (nonatomic, copy) NSString *maxtime;
/** 所有的帖子数据 */
@property (nonatomic, strong) NSMutableArray<XMGTopic *> *topics;
/** 请求管理者 */
@property (nonatomic, strong) XMGHTTPSessionManager *manager;

/**刷新标题标签*/
@property(nonatomic,strong)UILabel *title_lbn;
@end

@implementation XMGTopicViewController

- (UILabel *)title_lbn{
    if (!_title_lbn) {
        [self addLbn];
    }
    return _title_lbn;
}

- (void)addLbn{
    UILabel *title_lbn = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    [self.view addSubview:title_lbn];
    title_lbn.xmg_centerX = self.view.xmg_centerX;
    title_lbn.text = @"正在加载中 . . .";
    title_lbn.font = [UIFont systemFontOfSize:33];
    [title_lbn setTextColor:[UIColor yellowColor]];
    title_lbn.textAlignment = NSTextAlignmentCenter;
    [title_lbn sizeToFit];
    [title_lbn addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [UIView animateWithDuration:3 animations:^{
        title_lbn.mj_y -= 50;
    }];
    
    _title_lbn = title_lbn;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"hidden"] && !self.title_lbn.hidden) {
        [self loadNewTopics];
    }
    
    if ([keyPath isEqualToString:@"contentOffset"] && self.tableView.contentOffset.y < -self.tableView.contentInset.top && self.title_lbn.hidden) {
//        NSLog(@". . . . ");
        self.title_lbn.hidden = NO;
        
        NSLog(@".. %f   %f",self.tableView.contentOffset.y , self.tableView.contentInset.top);
    }
    
}


/** 在这里实现type方法，仅仅是为了消除警告 */
- (XMGTopicType)type {return 1;}

/* cell的重用标识 */
static NSString * const XMGTopicCellId = @"XMGTopicCellId";

- (XMGHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [XMGHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLbn];
    self.view.backgroundColor = [UIColor darkGrayColor];

    self.tableView.contentInset = UIEdgeInsetsMake(XMGNavMaxY + XMGTitlesViewH, 0, XMGTabBarH, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([XMGTopicCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:XMGTopicCellId];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarButtonDidRepeatClick) name:XMGTabBarButtonDidRepeatClickNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleButtonDidRepeatClick) name:XMGTitleButtonDidRepeatClickNotification object:nil];
    
    [self setupRefresh];
    
    
    self.tableView.estimatedRowHeight = 200;
    [self loadNewTopics];
}

- (void)dealloc
{
    NSLog(@". .. .. .. 子控制器这小块 挂了 。 。 。 。");
    [self.title_lbn removeObserver:self forKeyPath:@"hidden"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupRefresh
{
    // 广告条
//    UILabel *label = [[UILabel alloc] init];
//    label.backgroundColor = [UIColor blackColor];
//    label.frame = CGRectMake(0, 0, 0, 50);
//    label.textColor = [UIColor whiteColor];
//    label.text = @"老子是广告";
//    label.textAlignment = NSTextAlignmentCenter;
//    self.tableView.tableHeaderView = label;
    
    // header
//    self.tableView.mj_header = [XMGDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
//    [self.tableView.mj_header beginRefreshing];
    self.title_lbn.hidden = NO;
    self.title_lbn.xmg_centerX = self.tableView.xmg_centerX;
//    [self loadNewTopics];
//    self.tableView.mj_header = [XMGDIYHeader headerWithRefreshingBlock:^{
//        XMGFunc
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.tableView.mj_header endRefreshing];
//        });
//    }];
//    self.tableView.mj_header = [XMGTestHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
//    [self.tableView.mj_header beginRefreshing];
    
//    [self.tableView mj_addNormalHeaderWithBlock:^{
//    
//    }];
//    
//    [self.tableView mj_addDIYHeaderWithBlock:^{
//        
//    }];
//    
//    [self.tableView mj_addTestHeaderWithBlock:^{
//        
//    }];
//    
//    [self.tableView mj_addMMMHeaderWithBlock:^{
//        
//    }];
//    
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        
//    }];
    
    // footer
    self.tableView.mj_footer = [XMGDIYFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
    
}

#pragma mark - 监听
/**
 *  监听tabBarButton重复点击
 */
- (void)tabBarButtonDidRepeatClick
{
    // 重复点击的不是精华按钮
    if (self.view.window == nil) return;
    
    // 显示在正中间的不是VideoViewController
    if (self.tableView.scrollsToTop == NO) return;
    
    // 进入下拉刷新
//    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.contentOffset = CGPointMake(0, -150);
    self.title_lbn.hidden = NO;
}

/**
 *  监听titleButton重复点击
 */
- (void)titleButtonDidRepeatClick
{
    [self tabBarButtonDidRepeatClick];
}




#pragma mark - 数据处理
/**
 *  发送请求给服务器，下拉刷新数据
 */
- (void)loadNewTopics
{
//    [[SDImageCache sharedImageCache] clearMemory];
    // 1.取消之前的请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 2.拼接参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(self.type);
    
    // 3.发送请求
    [self.manager GET:XMGCommonURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        
//        NSLog(@". .. .  .%@",responseObject);
        // 存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        // 字典数组 -> 模型数据
        self.topics = [XMGTopic modelFromKeyvalueArray:responseObject[@"list"]];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新
//        [self.tableView.mj_header endRefreshing];
//        self.tableView.mj_header.state = MJRefreshStateNoMoreData;
        self.title_lbn.hidden = YES;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code != NSURLErrorCancelled) { // 并非是取消任务导致的error，其他网络问题导致的error
            [SVProgressHUD showErrorWithStatus:@"网络繁忙，请稍后再试！"];
            self.title_lbn.hidden = YES;
        }
        
        // 结束刷新
//        [self.tableView.mj_header endRefreshing];
    }];
}

/**
 *  发送请求给服务器，上拉加载更多数据
 */
- (void)loadMoreTopics
{
    
    // 1.取消之前的请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 2.拼接参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(self.type);
    parameters[@"maxtime"] = self.maxtime;
    
    // 3.发送请求
    [self.manager GET:XMGCommonURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        // 存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        // 字典数组 -> 模型数据
        NSArray *moreTopics = [XMGTopic modelFromKeyvalueArray:responseObject[@"list"]];
        // 累加到旧数组的后面
        [self.topics addObjectsFromArray:moreTopics];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
//        self.tableView.mj_header.state = MJRefreshStateNoMoreData;
        self.title_lbn.hidden = YES;
//        if (self.topics.count >= 60) {
//            [self.tableView.mj_footer endRefreshingWithNoMoreData];
//        } else {
//            [self.tableView.mj_footer endRefreshing];
//        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code != NSURLErrorCancelled) { // 并非是取消任务导致的error，其他网络问题导致的error
            [SVProgressHUD showErrorWithStatus:@"网络繁忙，请稍后再试！"];
        }
        
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        self.title_lbn.hidden = YES;
    }];
}

#pragma mark - 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 根据数据量显示或者隐藏footer
    self.tableView.mj_footer.hidden = (self.topics.count == 0);
    return self.topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMGTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:XMGTopicCellId];
    
    cell.topic = self.topics[indexPath.row];
    
    return cell;
}

#pragma mark - 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.topics[indexPath.row].cellHeight;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 清除内存缓存
//    [[SDImageCache sharedImageCache] clearMemory];
    
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [[SDImageCache sharedImageCache] clearMemory];
}

@end
