# QRVideoRecord

[![CI Status](https://img.shields.io/travis/yangqingren/QRVideoRecord.svg?style=flat)](https://travis-ci.org/yangqingren/QRVideoRecord)
[![Version](https://img.shields.io/cocoapods/v/QRVideoRecord.svg?style=flat)](https://cocoapods.org/pods/QRVideoRecord)
[![License](https://img.shields.io/cocoapods/l/QRVideoRecord.svg?style=flat)](https://cocoapods.org/pods/QRVideoRecord)
[![Platform](https://img.shields.io/cocoapods/p/QRVideoRecord.svg?style=flat)](https://cocoapods.org/pods/QRVideoRecord)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

    Basic usage
     QRVideoRecordViewController *vc = [[QRVideoRecordViewController alloc] init];
     vc.delegate = (id <QRVideoRecordDelegate>)self;
     [self presentViewController:vc animated:YES completion:nil];
     
     /**
      videoRecordResult

      @param fileURL 文件url
      @param filePath 文件路径
      @param fileName 文件名
      */
     - (void)finishVideoRecordCapture:(NSURL *)fileURL filePath:(NSString *)filePath fileName:(NSString *)fileName;
     
     If you want to expand...
     Please use inherit
     #import <QRVideoRecord/QRVideoRecordViewController.h>
     @interface LBQRViewController : QRVideoRecordViewController
     @end
     
     other usage
     // 获取视频url第一帧图片
     + (UIImage*)getVideoPreViewImage:(NSURL *)url;
     // 计算文件大小
     + (CGFloat)fileSize:(NSURL *)path;
     // 磁盘video文件夹路径
     + (NSString *)getVideoContents;
     // 清理video文件夹
     + (BOOL)clearVideoContents;
     
     other expand
     @property (nonatomic, assign) AVCaptureFlashMode flashMode;  // 闪光灯
     @property (nonatomic, assign) AVCaptureDevicePosition devicePosition;  // 前后摄像头
     // 结束录制拓展方法
     - (void)doNextWhenVideoSavedSuccess;
     

## Installation

QRVideoRecord is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'QRVideoRecord'
```

## Author

yangqingren, 564008993@qq.com

## License

QRVideoRecord is available under the MIT license. See the LICENSE file for more info.
