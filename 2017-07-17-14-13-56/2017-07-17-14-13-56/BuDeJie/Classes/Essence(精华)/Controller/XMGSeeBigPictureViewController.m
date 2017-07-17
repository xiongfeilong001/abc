//
//  XMGSeeBigPictureViewController.m
//  BuDeJie
//
//  Created by xiaomage on 16/3/27.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGSeeBigPictureViewController.h"
#import "XMGTopic.h"
#import <SVProgressHUD.h>
#import <Photos/Photos.h>

@interface XMGSeeBigPictureViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIImageView *imageView;

/** 当前App对应的自定义相册 */
- (PHAssetCollection *)createdCollection;
/** 返回刚才保存到【相机胶卷】的图片 */
- (PHFetchResult<PHAsset *> *)createdAssets;
@end

@implementation XMGSeeBigPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = [UIScreen mainScreen].bounds;
    [scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)]];
    [self.view insertSubview:scrollView atIndex:0];
    self.scrollView = scrollView;
    
    // imageView
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.topic.image1] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) return;
        self.saveButton.enabled = YES;
    }];
    imageView.xmg_width = scrollView.xmg_width;
    imageView.xmg_height = imageView.xmg_width * self.topic.height / self.topic.width;
    imageView.xmg_x = 0;
    if (imageView.xmg_height > XMGScreenH) { // 超过一个屏幕
        imageView.xmg_y = 0;
        scrollView.contentSize = CGSizeMake(0, imageView.xmg_height);
    } else {
        imageView.xmg_centerY = scrollView.xmg_height * 0.5;
    }
    [scrollView addSubview:imageView];
    self.imageView = imageView;
    
    // 图片缩放
    CGFloat maxScale = self.topic.width / imageView.xmg_width;
    if (maxScale > 1) {
        scrollView.maximumZoomScale = maxScale;
        scrollView.delegate = self;
    }
}

#pragma mark - <UIScrollViewDelegate>
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

#pragma mark - 获得当前App对应的自定义相册
- (PHAssetCollection *)createdCollection
{
    // 获得软件名字
    NSString *title = [NSBundle mainBundle].infoDictionary[(__bridge NSString *)kCFBundleNameKey];
    
    // 抓取所有的自定义相册
    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    // 查找当前App对应的自定义相册
    for (PHAssetCollection *collection in collections) {
        if ([collection.localizedTitle isEqualToString:title]) {
            return collection;
        }
    }
    
    /** 当前App对应的自定义相册没有被创建过 **/
    // 创建一个【自定义相册】
    NSError *error = nil;
    __block NSString *createdCollectionID = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        createdCollectionID = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    
    if (error) return nil;
    
    // 根据唯一标识获得刚才创建的相册
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[createdCollectionID] options:nil].firstObject;
}

- (PHFetchResult<PHAsset *> *)createdAssets
{
     NSError *error = nil;
    __block NSString *assetID = nil;
    
    // 保存图片到【相机胶卷】
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        assetID = [PHAssetChangeRequest creationRequestForAssetFromImage:self.imageView.image].placeholderForCreatedAsset.localIdentifier;
    } error:&error];
    
    if (error) return nil;
    
    // 获取刚才保存的相片
    return [PHAsset fetchAssetsWithLocalIdentifiers:@[assetID] options:nil];
}

#pragma mark - 监听点击
- (IBAction)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save {
    PHAuthorizationStatus oldStatus = [PHPhotoLibrary authorizationStatus];
    
    // 请求\检查访问权限 :
    // 如果用户还没有做出选择，会自动弹框，用户对弹框做出选择后，才会调用block
    // 如果之前已经做过选择，会直接执行block
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status == PHAuthorizationStatusDenied) { // 用户拒绝当前App访问相册
                if (oldStatus != PHAuthorizationStatusNotDetermined) {
                    XMGLog(@"提醒用户打开开关")
                }
            } else if (status == PHAuthorizationStatusAuthorized) { // 用户允许当前App访问相册
                [self saveImageIntoAlbum];
            } else if (status == PHAuthorizationStatusRestricted) { // 无法访问相册
                [SVProgressHUD showErrorWithStatus:@"因系统原因，无法访问相册！"];
            }
        });
    }];
}

/**
 *  保存图片到相册
 */
- (void)saveImageIntoAlbum
{
    // 获得相片
    PHFetchResult<PHAsset *> *createdAssets = self.createdAssets;
    if (createdAssets == nil) {
        [SVProgressHUD showErrorWithStatus:@"保存图片失败！"];
        return;
    }
    
    // 获得相册
    PHAssetCollection *createdCollection = self.createdCollection;
    if (createdCollection == nil) {
        [SVProgressHUD showErrorWithStatus:@"创建或者获取相册失败！"];
        return;
    }
    
    // 添加刚才保存的图片到【自定义相册】
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdCollection];
        [request insertAssets:createdAssets atIndexes:[NSIndexSet indexSetWithIndex:0]];
    } error:&error];
    
    // 最后的判断
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存图片失败！"];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"保存图片成功！"];
    }
}
@end
