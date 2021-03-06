/**************************************************************************
 *
 *  Created by shushaoyong on 2016/10/27.
 *    Copyright © 2016年 踏潮. All rights reserved.
 *
 * 项目名称：浙江踏潮-天目山-h5模版制作软件
 * 版权说明：本软件属浙江踏潮网络科技有限公司所有，在未获得浙江踏潮网络科技有限公司正式授权
 *           情况下，任何企业和个人，不能获取、阅读、安装、传播本软件涉及的任何受知
 *           识产权保护的内容。
 ***************************************************************************/

#import "SYPhotoitem.h"
#import "NSString+SY.h"
#import "NSDate+SY.h"
#import <CoreLocation/CoreLocation.h>
#import "SYPhotoConst.h"
#import "SYPhotoLibraryTool.h"

@implementation PhotoGroup

/**
 *  初始化方法
 *
 *  @return 返回当前对象
 */
- (instancetype)init
{
    if (self = [super init]) {
        _images = [NSArray array];
    }
    return self;
}
/**
 *  创建相册组
 *
 *  @param name        组名
 *  @param fetchResult 相册结果集
 *
 *  @return 返回创建好的相册组
 */
+ (instancetype)groupWithName:(NSString *)name result:(id)fetchResult
{
    PhotoGroup *group = [[PhotoGroup alloc] init];
    group.groupName = [self albumWithOriginName:name];
    if ([fetchResult isKindOfClass:[PHFetchResult class]]) {
        PHFetchResult *Result = (PHFetchResult *)fetchResult;
        group.count = Result.count;
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        
    } else if ([fetchResult isKindOfClass:[ALAssetsGroup class]]) {
        ALAssetsGroup *gruop = (ALAssetsGroup *)fetchResult;
        group.count = [gruop numberOfAssets];
        
#pragma clang diagnostic pop
    }
    group.groupName = name;
    group.fetchResult = fetchResult;
    return group;
}
/**
 *  格式化相册组名称
 *
 *  @param name 手机相册对应的相册名
 *
 *  @return 返回处理好的相册组名
 */
+ (NSString *)albumWithOriginName:(NSString *)name {
    
    if (IsIOS8) {
        NSString *newName;
        if ([name rangeOfString:@"Roll"].location != NSNotFound)         newName = @"相机胶卷";
        else if ([name rangeOfString:@"Stream"].location != NSNotFound)  newName = @"我的照片流";
        else if ([name rangeOfString:@"Added"].location != NSNotFound)   newName = @"最近添加";
        else if ([name rangeOfString:@"Selfies"].location != NSNotFound) newName = @"自拍";
        else if ([name rangeOfString:@"shots"].location != NSNotFound)   newName = @"截屏";
        else if ([name rangeOfString:@"Videos"].location != NSNotFound)  newName = @"视频";
        else newName = name;
        return newName;
        
    }else {
        if ([name rangeOfString:@"Roll"].location != NSNotFound) name = @"相机胶卷";
        return name;
    }
}
@end

@implementation SYPhotoItem

/**
 *  返回当前照片的拍摄时间
 *
 *  @return 返回格式化之后的时间字符串
 */
- (NSString *)photoCreateDate
{
    if (_photoCreateDate) {
        return _photoCreateDate;
    }
    if (IsIOS8) {
        return [self.phasset.creationDate dateFormatterYMD];
    }else{
        return [self.asset valueForProperty:ALAssetPropertyDate];
    }
}

/**
 获取原图
 @param completion 获取完成后的回调
 */
- (void)getOriginalImageWithCompletion:(void(^)(UIImage *image))completion
{
    if (self.asset) {
        [[SYPhotoLibraryTool sharedInstance] getOriginImageWithAsset:self.asset completionBlock:^(UIImage *image) {
            if (completion) {
                completion(image);
            }
        }];
    }
}


/**
 *  获取asset对象
 *
 *  @return 返回对应版本的asset对象
 */
- (id)asset
{
    if (IsIOS8) {
        return self.phasset;
    }else{
        return self.alasset;
    }

}


@end
