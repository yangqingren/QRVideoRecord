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
 * video record result

 * @param fileURL video local url
 * @param filePath video local path
 * @param fileName video name
 * fileURL will be triggered after video recording is finished.
 */
- (void)finishVideoRecordCapture:(NSURL *)fileURL filePath:(NSString *)filePath fileName:(NSString *)fileName;

@end

typedef NS_ENUM(NSInteger, QRVideoRecordQuality) {
    // video record quality
    QRVideoRecordHighestQuality = 1,
    QRVideoRecordMediumQuality = 2,
    QRVideoRecordLowQuality = 3
};

NS_ASSUME_NONNULL_BEGIN

@interface QRVideoRecordViewController : UIViewController

/**
 * video record max time
 * default 30s
 */
@property (nonatomic, assign) CGFloat videoMaxTime;

/**
 * video record quality
 * video quality is related to video definition and file size.
 * default HighestQuality
 */
@property (nonatomic, assign) QRVideoRecordQuality recordQuality;

@property (nonatomic, weak, nullable) id <QRVideoRecordDelegate> delegate;

/**
 * video record name
 * videoFileName will use date format video_yyyyMMddHHmmss.mp4
 * readonly property
 */
@property (nonatomic, copy, readonly) NSString *videoFileName;

/**
 * cut out video preview
 * @param url video local url
 * @return video preview
 * video preview expect get video the first frame
 */
+ (UIImage*)getVideoPreViewImage:(NSURL *)url;

/**
 * calculation out video file size
 * @param path video local url
 * @return video size
 * video size unit is MB
 */
+ (CGFloat)fileSize:(NSURL *)path;

/**
 * disk address
 * you can get the video folder stored in the local sandbox, so that you can manage the sandbox storage.
 */
+ (NSString *)getVideoContents;
/**
 * clear video disk folder
 * if the memory of the mobile phone is too small, the video recording will fail. We hope to clean up the video files in the local sandbox when the page is destroyed.
 */
+ (BOOL)clearVideoContents;


/**
 * flash lamp
 * set this property so that you can set up and turn off the astigmatism conveniently.
 * expand property
 */
@property (nonatomic, assign) AVCaptureFlashMode flashMode;

/**
 * camera direction
 * set this property So that you can easily change the front and rear cameras.
 * expand property, nullable property
 */
@property (nonatomic, assign) AVCaptureDevicePosition devicePosition;


/**
 * video record result call.
 * you can do your video recording after completion, such as jump page.
 * The extension must first call the parent class method. use super doNextWhenVideoSavedSuccess will be call fileURL completion
 */
- (void)doNextWhenVideoSavedSuccess; 

@end

NS_ASSUME_NONNULL_END
