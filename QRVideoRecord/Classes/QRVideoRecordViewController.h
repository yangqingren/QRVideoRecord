//
//  QRVideoRecordViewController.h
//  Masonry
//
//  Created by 杨庆人 on 2018/11/19.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol QRVideoRecordDelegate <NSObject>

/**
 视频录制结果

 @param fileURL 文件url
 @param filePath 文件路径
 @param fileName 文件名
 */
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


/**
 拓展
 */
@property (nonatomic, assign) AVCaptureFlashMode flashMode;  // 闪光灯
@property (nonatomic, assign) AVCaptureDevicePosition devicePosition;  // 前后摄像头

- (void)doNextWhenVideoSavedSuccess; // use [super doNextWhenVideoSavedSuccess]

@end

NS_ASSUME_NONNULL_END
