//
//  QRVideoRecordViewController.h
//  Masonry
//
//  Created by 杨庆人 on 2018/11/19.
//

#import <UIKit/UIKit.h>

@protocol QRVideoRecordDelegate <NSObject>

- (void)finishVideoRecordCapture:(NSURL *)fileURL filePath:(NSString *)filePath fileName:(NSString *)fileName;

@end

typedef NS_ENUM(NSInteger, QRVideoRecordQuality) {
    // 录制质量
    QRVideoRecordHighestQuality = 1,
    QRVideoRecordMediumQuality = 2,
    QRVideoRecordLowQuality = 3
};

NS_ASSUME_NONNULL_BEGIN

@interface QRVideoRecordViewController : UIViewController

@property (nonatomic, assign) CGFloat videoMaxTime;   // 录制的最大时间，默认30s
@property (nonatomic, assign) QRVideoRecordQuality recordQuality;   // 录制质量
@property (nonatomic, weak) id<QRVideoRecordDelegate> delegate;

@property (nonatomic, copy, readonly) NSString *videoFileName;    // 视频文件名

// 获取本地视频url预览图片
+ (UIImage*)getVideoPreViewImage:(NSURL *)url;
// 文件大小计算
+ (CGFloat)fileSize:(NSURL *)path;
// 磁盘video文件夹
+ (NSString *)getVideoContents;
// 清理video文件夹
+ (BOOL)clearVideoContents;

@property (nonatomic, copy) void (^doNextAction) (void);  // 拓展，若赋值该complet，则不执行dismiss
// 重录，移除预览
- (void)removePreviewMode;
// 保存录制
- (void)saveCapture;
@end

NS_ASSUME_NONNULL_END
